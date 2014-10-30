-- ******************************************************************************
 -- *  Design:
 -- *        NetFlow_Simple_10G_Bram
 -- *  
 -- *  NetFPGA-10G http://www.netfpga.org
 -- *
 -- *  File:
 -- *        netflow_cache_top.vhd
 -- *
 -- *  Pcore:
 -- *        netflow_cache
 -- *
 -- *  Authors:
 -- *        Marco Forconesi, Gustavo Sutter, Sergio Lopez-Buedo
 -- *
 -- *  Description:
 -- *          Instantiates and interfaces the different modules within this Pcore.
 -- *          Contains a flow-table to store the different active flows the
 -- *          Ethernet interface is receiving. When a flow expires it is removed
 -- *          from the flow table and exported to the next Pcore (netflow_export).
 -- *          Analizes every ethernet frame and matches the packet's header (5-tuple)
 -- *          to the flow entries stored on the flow table. Updates the statistics
 -- *          of each flow-entry.
 -- *          The Pcore has two AXI4-Stream interfaces, one slave and one master.
 -- *          From the slave interface it receives the Ethernet frames.
 -- *          By the master interface it sends out the expired flows.
-- ******************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use IEEE.MATH_REAL.ALL;
library work;
use work.netflow_cache_pack.all;

Library UNIMACRO;
use UNIMACRO.vcomponents.all;

entity netflow_cache is
generic (
	SIM_ONLY : integer := 0;
	ACLK_FREQ : integer := 200000000;
	C_S_AXIS_10GMAC_DATA_WIDTH   : integer := 64;
	C_M_AXIS_EXP_RECORDS_DATA_WIDTH : integer := 64;
	-- Active & Inactive time out in seconds
	C_ACTIVE_TIMEOUT_INIT : integer := 1800;	-- in seconds
	C_InACTIVE_TIMEOUT_INIT : integer := 15;	-- in seconds
	-- If no NetFlow export protocol is implemented, expired flows are exported to a 10G interface
	NETFLOW_EXPORT_PRESENT : integer := 1
	);
port (
	-- AXI4-Stream slave interface
	ACLK  : in  std_logic;
	ARESETN  : in  std_logic;
	S_AXIS_TREADY  : out  std_logic;
	S_AXIS_TDATA  : in  std_logic_vector(C_S_AXIS_10GMAC_DATA_WIDTH-1 downto 0);
	S_AXIS_TSTRB    : in    std_logic_vector (C_S_AXIS_10GMAC_DATA_WIDTH/8-1 downto 0);
	S_AXIS_TLAST  : in  std_logic;
	S_AXIS_TVALID  : in  std_logic;
	-- AXI4-Stream Master Interface
	M_AXIS_EXP_RECORDS_TDATA : out std_logic_vector(C_M_AXIS_EXP_RECORDS_DATA_WIDTH-1 downto 0);
	M_AXIS_EXP_RECORDS_TSTRB : out std_logic_vector((C_M_AXIS_EXP_RECORDS_DATA_WIDTH/8)-1 downto 0);
	M_AXIS_EXP_RECORDS_TVALID : out std_logic;
	M_AXIS_EXP_RECORDS_TLAST : out std_logic;
	M_AXIS_EXP_RECORDS_TREADY : in std_logic
	);

attribute SIGIS : string; 
attribute SIGIS of ACLK : signal is "Clk"; 

end netflow_cache;


architecture netflow_cache_arch of netflow_cache is

	-- Active and inactive time outs
	constant ACTIVE_TIMEOUT_HW_IMP : std_logic_vector(timestamp_WIDTH-1 downto 0) := conv_std_logic_vector(C_ACTIVE_TIMEOUT_INIT,timestamp_WIDTH-10) * conv_std_logic_vector(1000,10); -- in ms
	constant InACTIVE_TIMEOUT_HW_IMP : std_logic_vector(timestamp_WIDTH-1 downto 0) := conv_std_logic_vector(C_InACTIVE_TIMEOUT_INIT,timestamp_WIDTH-10) * conv_std_logic_vector(1000,10);  -- in ms
	constant ACTIVE_TIMEOUT_SYM : std_logic_vector(timestamp_WIDTH-1 downto 0) := conv_std_logic_vector(2,timestamp_WIDTH); -- in ms
	constant InACTIVE_TIMEOUT_SYM : std_logic_vector(timestamp_WIDTH-1 downto 0) := conv_std_logic_vector(1,timestamp_WIDTH); -- in ms
	signal ACTIVE_TIMEOUT : std_logic_vector(timestamp_WIDTH-1 downto 0);
	signal InACTIVE_TIMEOUT : std_logic_vector(timestamp_WIDTH-1 downto 0);
	
	--Pkt Classf
	signal frame_five_tuple : std_logic_vector(FIVE_TUPLE_WIDTH-1 downto 0);
	signal pkt_info : std_logic_vector(PKT_INFO_WIDTH-1 downto 0);
	signal num_processed_pkts : std_logic_vector(32-1 downto 0);
	signal tuple_and_info_valid : std_logic;
	signal timestamp_counter : std_logic_vector(timestamp_WIDTH-1 downto 0);

	--	Flow-table's signals
	-- Port A
	signal ena : std_logic;
	signal wea : std_logic;
	signal addra : std_logic_vector(MEM_ADDR_WIDTH-1 downto 0);
	signal dia : std_logic_vector(MEM_DATA_WIDTH-1 downto 0);
	signal doa : std_logic_vector(MEM_DATA_WIDTH-1 downto 0);
	-- Port B
	signal enb : std_logic;
	signal web : std_logic;
	signal addrb : std_logic_vector(MEM_ADDR_WIDTH-1 downto 0);
	signal dib : std_logic_vector(MEM_DATA_WIDTH-1 downto 0);
	signal dob : std_logic_vector(MEM_DATA_WIDTH-1 downto 0);	

	-- Create_or_update_flows's signals
	signal export_now : std_logic;
	signal export_this : std_logic_vector(MEM_ADDR_WIDTH-1 downto 0);
	signal flow_exported_ok : std_logic;
	signal collision_counter : std_logic_vector(32-1 downto 0);

	-- ExpotFIFO's signals
	type fifo_inout_type_exp is array (0 to 3) of std_logic_vector(72-1 downto 0);
	signal fifo_out_exp_int : fifo_inout_type_exp;
	signal fifo_in_exp_int : fifo_inout_type_exp;
	signal fifo_out_exp : std_logic_vector(240-1 downto 0);
	signal fifo_in_exp : std_logic_vector(240-1 downto 0);
	type fifo_signals_exp is array (0 to 3) of std_logic;
	signal fifo_full_exp_int : fifo_signals_exp;
	signal fifo_full_exp : std_logic;
	signal fifo_empty_exp_int : fifo_signals_exp;
	signal fifo_empty_exp : std_logic;
	signal fifo_rd_exp_en : std_logic;
	signal fifo_exp_rst : std_logic;
	signal fifo_w_exp_en : std_logic;
	type fifo_rd_wr_count_type_exp is array (0 to 3) of std_logic_vector(9-1 downto 0);
	signal RDCOUNT_exp, WRCOUNT_exp : fifo_rd_wr_count_type_exp;

begin

	ACTIVE_TIMEOUT <= ACTIVE_TIMEOUT_HW_IMP when (SIM_ONLY = 0) else ACTIVE_TIMEOUT_SYM;
	InACTIVE_TIMEOUT <= InACTIVE_TIMEOUT_HW_IMP when (SIM_ONLY = 0) else InACTIVE_TIMEOUT_SYM;

------------------------------------------------------------------
-- Component declarations
------------------------------------------------------------------
comp1: pkt_classification
generic map (
	C_S_AXIS_10GMAC_DATA_WIDTH   => C_S_AXIS_10GMAC_DATA_WIDTH)
port map( 
	ACLK => ACLK,
	ARESETN => ARESETN,
	S_AXIS_TREADY => S_AXIS_TREADY,
	S_AXIS_TDATA => S_AXIS_TDATA,
	S_AXIS_TSTRB => S_AXIS_TSTRB,
	S_AXIS_TLAST => S_AXIS_TLAST,
	S_AXIS_TVALID => S_AXIS_TVALID,
	timestamp_counter => timestamp_counter,
	num_processed_pkts => num_processed_pkts,
	five_tuple => frame_five_tuple,
	pkt_info => pkt_info,
	tuple_and_info_valid => tuple_and_info_valid);
------------------------------------------------------------------
comp2: timestamp_counter_mod
generic map (
	SIM_ONLY => SIM_ONLY,
	ACLK_FREQ => ACLK_FREQ)
port map( 
	ACLK => ACLK,
	ARESETN => ARESETN,
	timestamp_counter_out => timestamp_counter);
------------------------------------------------------------------
flow_table: BSRAM  
generic map(
	ADDR_BITS => MEM_ADDR_WIDTH,
	DATA_BITS => MEM_DATA_WIDTH)
port map(clk => ACLK,
		ena => ena,
		enb => enb,
		wea => wea,
		web => web,
		addra => addra,
		addrb => addrb,
		dia   => dia,
		dib   => dib,
		doa => doa,
		dob => dob);
------------------------------------------------------------------
comp3: create_or_update_flows
port map(
	ACLK  => ACLK,
	ARESETN => ARESETN,
	frame_five_tuple  => frame_five_tuple,
	pkt_info => pkt_info,
	tuple_and_info_valid => tuple_and_info_valid,
	ena => ena,
	wea => wea,
	hash_code_out => addra,
	doa => doa,
	dia => dia,
	export_now => export_now,
	export_this => export_this,
	flow_exported_ok => flow_exported_ok,
	collision_counter => collision_counter);
------------------------------------------------------------------
comp4: export_expired_flows_from_mem
port map(
	ACLK  => ACLK,
	ARESETN => ARESETN,
	ACTIVE_TIMEOUT => ACTIVE_TIMEOUT,
	InACTIVE_TIMEOUT => InACTIVE_TIMEOUT,
	enb => enb,
	web => web,
	addrb => addrb,
	dob => dob,
	dib => dib,
	export_now => export_now,
	export_this => export_this,
	timestamp_counter => timestamp_counter,
	flow_exported_ok => flow_exported_ok,
	fifo_exp_rst => fifo_exp_rst,
	fifo_w_exp_en => fifo_w_exp_en,
	fifo_in_exp => fifo_in_exp,
	fifo_full_exp => fifo_full_exp);
------------------------------------------------------------------
export_fifo: for L in 0 to 3 generate
   FIFO_SYNC_MACRO_exp0 : FIFO_SYNC_MACRO
   generic map (
      DEVICE => "VIRTEX5",            -- Target Device: "VIRTEX5, "VIRTEX6" 
      ALMOST_FULL_OFFSET => X"0080",  -- Sets almost full threshold
      ALMOST_EMPTY_OFFSET => X"0080", -- Sets the almost empty threshold
      DATA_WIDTH => 72,   -- Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
      FIFO_SIZE => "36Kb",            -- Target BRAM, "18Kb" or "36Kb" 
      SIM_MODE => "SAFE") -- Simulation) "SAFE" vs "FAST", 
                          -- see "Synthesis and Simulation Design Guide" for details
   port map (
      ALMOSTEMPTY => open,   -- Output almost empty 
      ALMOSTFULL => fifo_full_exp_int(L),     -- Output almost full
      DO => fifo_out_exp_int(L),                     -- Output data
      EMPTY => fifo_empty_exp_int(L),               -- Output empty
      FULL => open,                 -- Output full
      RDCOUNT => RDCOUNT_exp(L),           -- Output read count
      RDERR => open,               -- Output read error
      WRCOUNT => WRCOUNT_exp(L),           -- Output write count
      WRERR => open,               -- Output write error
      CLK => ACLK,                   -- Input clock
      DI => fifo_in_exp_int(L),                     -- Input data
      RDEN => fifo_rd_exp_en,                 -- Input read enable
      RST => fifo_exp_rst,                   -- Input reset
      WREN => fifo_w_exp_en                 -- Input write enable
   );
end generate export_fifo;
------------------------------------------------------------------
-- Export fifo
fifo_empty_exp <= fifo_empty_exp_int(3) or fifo_empty_exp_int(2) or fifo_empty_exp_int(1) or fifo_empty_exp_int(0);
fifo_full_exp 	<= fifo_full_exp_int(3) or fifo_full_exp_int(2) or fifo_full_exp_int(1) or fifo_full_exp_int(0);
fifo_out_exp	<=	fifo_out_exp_int(3)(24-1 downto 0) & fifo_out_exp_int(2) & fifo_out_exp_int(1) & fifo_out_exp_int(0);
fifo_in_exp_int(0) <= fifo_in_exp(72-1 downto 0);
fifo_in_exp_int(1) <= fifo_in_exp(144-1 downto 72);
fifo_in_exp_int(2) <= fifo_in_exp(216-1 downto 144);
fifo_in_exp_int(3) <= zeros(48-1 downto 0) & fifo_in_exp(240-1 downto 216);


------------------------------------------------------------------
-- Conditional components instantiations
------------------------------------------------------------------
no_netflow_exp: if NETFLOW_EXPORT_PRESENT = 0 generate
	exp_via_10g_intf_inst: exp_via_10g_interface
	port map(
		ACLK  => ACLK,
		ARESETN => ARESETN,
		M_AXIS_10GMAC_tdata => M_AXIS_EXP_RECORDS_TDATA,
		M_AXIS_10GMAC_tstrb => M_AXIS_EXP_RECORDS_TSTRB,
		M_AXIS_10GMAC_tvalid => M_AXIS_EXP_RECORDS_TVALID,
		M_AXIS_10GMAC_tready => M_AXIS_EXP_RECORDS_TREADY,
		M_AXIS_10GMAC_tlast => M_AXIS_EXP_RECORDS_TLAST,
		counters => num_processed_pkts,
		collision_counter => collision_counter,
		fifo_rd_exp_en => fifo_rd_exp_en,
		fifo_out_exp => fifo_out_exp,
		fifo_empty_exp => fifo_empty_exp);
end generate;
------------------------------------------------------------------
netflow_exp: if NETFLOW_EXPORT_PRESENT = 1 generate
	exp_to_netflow_exp_inst: exp_to_netflow_exp
	port map(
		ACLK  => ACLK,
		ARESETN => ARESETN,
		M_AXIS_10GMAC_tdata => M_AXIS_EXP_RECORDS_TDATA,
		M_AXIS_10GMAC_tstrb => M_AXIS_EXP_RECORDS_TSTRB,
		M_AXIS_10GMAC_tvalid => M_AXIS_EXP_RECORDS_TVALID,
		M_AXIS_10GMAC_tready => M_AXIS_EXP_RECORDS_TREADY,
		M_AXIS_10GMAC_tlast => M_AXIS_EXP_RECORDS_TLAST,
		fifo_rd_exp_en => fifo_rd_exp_en,
		fifo_out_exp => fifo_out_exp,
		fifo_empty_exp => fifo_empty_exp);
end generate;
------------------------------------------------------------------

end architecture netflow_cache_arch;
