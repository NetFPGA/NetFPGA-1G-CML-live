-- ******************************************************************************
 -- *  Design:
 -- *        NetFlow_Simple_10G_Bram
 -- *  
 -- *  NetFPGA-10G http://www.netfpga.org
 -- *
 -- *  File:
 -- *        netflow_cache_pack.vhd
 -- *
 -- *  Pcore:
 -- *        netflow_cache
 -- *
 -- *  Authors:
 -- *        Marco Forconesi, Gustavo Sutter, Sergio Lopez-Buedo
 -- *
 -- *  Description:
 -- *          Contains definitions of constants and types.
 -- *          Declares components of the Pcore.
-- ******************************************************************************

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package netflow_cache_pack is

	-- Constants def
	constant zeros : std_logic_vector(200-1 downto 0) := (others => '0');
	constant TCP : std_logic_vector(8-1 downto 0) := x"06";
	-- PACKET_INFO
	constant IP_TOTAL_LENGTH_FIELD_WIDTH : integer := 16;
	constant timestamp_WIDTH : integer := 32;
	constant TCP_FLAGS_WIDTH : integer := 8;
	constant FIVE_TUPLE_WIDTH   : integer := 104;
	constant PKT_INFO_WIDTH : integer := TCP_FLAGS_WIDTH+timestamp_WIDTH+IP_TOTAL_LENGTH_FIELD_WIDTH;

	-- FLOW_COUNTERS
	constant BYTE_COUNTER_WIDTH : integer := 32;
	constant FRAME_COUNTER_WIDTH : integer := 32;

	-- FLOW_MEMORY
	-- Memory organization: 
	--             - Entry_status (1 bit) 
	--             - 5-tuple 
	--             - tcp_flags 
	--             - Initial_timestamp 
	--             - Last_timestamp 
	--             - frame_counter 
	--             - byte_counter
	constant MEM_ADDR_WIDTH: integer := 12;
	constant MEM_DATA_WIDTH: integer := 1 + FIVE_TUPLE_WIDTH
										  + TCP_FLAGS_WIDTH
										  + timestamp_WIDTH*2
										  + FRAME_COUNTER_WIDTH
										  + BYTE_COUNTER_WIDTH;
	constant MEM_ENTRY_STATUS_INDEX : integer := MEM_DATA_WIDTH-1;

	--FIFO
	constant FIFO_DATA_WIDTH : integer := 240;

------------------------------------------------------------------
-- Component declarations
------------------------------------------------------------------
component pkt_classification is
generic (
	C_S_AXIS_10GMAC_DATA_WIDTH : integer := 64 --fixed value, The AXI4-Lite interface width
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
	-- Input timestamp_counter
	timestamp_counter : in std_logic_vector(timestamp_WIDTH-1 downto 0);
	-- Outputs
	num_processed_pkts : out std_logic_vector(32-1 downto 0);
	five_tuple    : out std_logic_vector(FIVE_TUPLE_WIDTH-1 downto 0);
	pkt_info    : out std_logic_vector(PKT_INFO_WIDTH-1 downto 0);
	tuple_and_info_valid : out  std_logic
	);
end component pkt_classification;
------------------------------------------------------------------
component timestamp_counter_mod is
generic (
	SIM_ONLY : integer := 0;
	ACLK_FREQ : integer := 200000000
	); 
port(
		-- AXI4-Stream slave interface
		ACLK  : in  std_logic;	
		ARESETN  : in  std_logic;
		--Output counter
		timestamp_counter_out : out std_logic_vector(timestamp_WIDTH-1 downto 0)
	);
end component timestamp_counter_mod;
------------------------------------------------------------------
-- BRAM Component declaration
component BSRAM is   
generic(
	ADDR_BITS: natural := MEM_ADDR_WIDTH;
	DATA_BITS: natural := MEM_DATA_WIDTH);
port (clk  : in std_logic;   
	ena     : in std_logic; 
	enb     : in std_logic; 
	wea     : in std_logic; 
	web     : in std_logic;     
	addra   : in std_logic_vector(MEM_ADDR_WIDTH-1 downto 0);  
	addrb   : in std_logic_vector(MEM_ADDR_WIDTH-1 downto 0);  
	dia     : in std_logic_vector(MEM_DATA_WIDTH-1 downto 0);   
	dib     : in std_logic_vector(MEM_DATA_WIDTH-1 downto 0);   
	doa : out std_logic_vector(MEM_DATA_WIDTH-1 downto 0);   
	dob : out std_logic_vector(MEM_DATA_WIDTH-1 downto 0)
	);   
end component;   
------------------------------------------------------------------
component create_or_update_flows is
port (
	ACLK  : in  std_logic;
	ARESETN  : in  std_logic;
	-- 5-tuple receive interface
	frame_five_tuple    : in   std_logic_vector(FIVE_TUPLE_WIDTH-1 downto 0);
	pkt_info    : in   std_logic_vector(PKT_INFO_WIDTH-1 downto 0);
	tuple_and_info_valid : in  std_logic;
	--RAM SIGNALS PORT_A
	ena : out std_logic;
	wea : out std_logic;
	hash_code_out : out std_logic_vector(MEM_ADDR_WIDTH-1 downto 0);
	doa : in std_logic_vector(MEM_DATA_WIDTH-1 downto 0);
	dia : out std_logic_vector(MEM_DATA_WIDTH-1 downto 0);
	--Export accelerator
	export_now : out std_logic;
	export_this : out std_logic_vector(MEM_ADDR_WIDTH-1 downto 0);
	flow_exported_ok : in std_logic;
	-- Output counter
	collision_counter : out std_logic_vector(32-1 downto 0)
	);
end component create_or_update_flows;
------------------------------------------------------------------
component export_expired_flows_from_mem is
--generic (
----
--  );
port (
	ACLK  : in  std_logic;
	ARESETN  : in  std_logic;
	ACTIVE_TIMEOUT : in std_logic_vector(timestamp_WIDTH-1 downto 0);
	InACTIVE_TIMEOUT : in std_logic_vector(timestamp_WIDTH-1 downto 0);
	-- RAM SIGNALS PORTB
	enb : out std_logic;
	web : out std_logic;
	addrb : out std_logic_vector(MEM_ADDR_WIDTH-1 downto 0);
	dob : in std_logic_vector(MEM_DATA_WIDTH-1 downto 0);
	dib : out std_logic_vector(MEM_DATA_WIDTH-1 downto 0);
	--Export accelerator
	export_now : in std_logic;
	export_this : in std_logic_vector(MEM_ADDR_WIDTH-1 downto 0);
	timestamp_counter : in std_logic_vector(timestamp_WIDTH-1 downto 0);
	flow_exported_ok : out std_logic;
	-- flow output fifo
	fifo_exp_rst : out std_logic;
	fifo_w_exp_en : out std_logic;
	fifo_in_exp : out std_logic_vector(FIFO_DATA_WIDTH-1 downto 0);
	fifo_full_exp : in std_logic
	);
end component export_expired_flows_from_mem;
------------------------------------------------------------------
component exp_via_10g_interface is
port(
	ACLK  : in  std_logic;	
	ARESETN  : in  std_logic;
	M_AXIS_10GMAC_tdata       : out std_logic_vector (64-1 downto 0);
	M_AXIS_10GMAC_tstrb       : out std_logic_vector (64/8-1 downto 0);
	M_AXIS_10GMAC_tvalid      : out std_logic;
	M_AXIS_10GMAC_tready      : in  std_logic;
	M_AXIS_10GMAC_tlast       : out std_logic;
	--counters
	counters	: in  std_logic_vector(32-1 downto 0);
	collision_counter : in std_logic_vector(32-1 downto 0);
	--Fifo's signals
	fifo_rd_exp_en : out std_logic;
	fifo_out_exp : in std_logic_vector(240-1 downto 0);
	fifo_empty_exp : in std_logic
	);
end component exp_via_10g_interface;
------------------------------------------------------------------
component exp_to_netflow_exp is
port(
	ACLK  : in  std_logic;	
	ARESETN  : in  std_logic;
	M_AXIS_10GMAC_tdata       : out std_logic_vector (64-1 downto 0);
	M_AXIS_10GMAC_tstrb       : out std_logic_vector (64/8-1 downto 0);
	M_AXIS_10GMAC_tvalid      : out std_logic;
	M_AXIS_10GMAC_tready      : in  std_logic;
	M_AXIS_10GMAC_tlast       : out std_logic;
	--Fifo's signals
	fifo_rd_exp_en : out std_logic;
	fifo_out_exp : in std_logic_vector(240-1 downto 0);
	fifo_empty_exp : in std_logic
	);
end component exp_to_netflow_exp;
------------------------------------------------------------------

end netflow_cache_pack;

package body netflow_cache_pack is


end netflow_cache_pack;
