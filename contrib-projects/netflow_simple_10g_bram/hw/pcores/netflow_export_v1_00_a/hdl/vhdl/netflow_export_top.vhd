-- ******************************************************************************
 -- *  Design:
 -- *        NetFlow_Simple_10G_Bram
 -- *  
 -- *  NetFPGA-10G http://www.netfpga.org
 -- *
 -- *  File:
 -- *        netflow_export_top.vhd
 -- *
 -- *  Pcore:
 -- *        netflow_export
 -- *
 -- *  Authors:
 -- *        Marco Forconesi, Gustavo Sutter, Sergio Lopez-Buedo
 -- *
 -- *  Description:
 -- *          Receives expired flows from netflow_cache Pcore.
 -- *          Encodes up to N expired flows in a single NetFlow packet.
 -- *          Sends NetFlow packets through an Ethernet Interface using
 -- *          the 10GMAC core user interface.
 -- *          The maximun number of expired flows per NetFlow packet (N)
 -- *          is defined by the protocol specification (For NetFlow v5
 -- *          N = 30).
 -- *          If N is not reachet within 60 seconds (defined in NetFlow v5
 -- *          specification) a NetFlow packet is sent with the actual
 -- *          number of expired flows.
 -- *          Reads expired flows, written by flow_encoding, from the FIFO and
 -- *          writes the data + packets headers on a Block Ram (in the correct
 -- *          order to be sent). Signals when all the data is on the Block Ram.
-- ******************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
library work;
use work.netflow_export_pack.all;

Library UNIMACRO;
use UNIMACRO.vcomponents.all;

entity netflow_export is
generic (
	DEST_MAC_ADDR :  std_logic_vector(48-1 downto 0) := x"A1A2A3A4A5A6";
	SRC_MAC_ADDR :  std_logic_vector(48-1 downto 0) := x"B1B2B3B4B5B6";
	SRC_IP_ADDR :  std_logic_vector(32-1 downto 0) := x"C1C2C3C4";
	DEST_IP_ADDR :  std_logic_vector(32-1 downto 0) := x"D1D2D3D4";
	SRC_UDP_PORT :  std_logic_vector(16-1 downto 0) := x"270C";
	DEST_UDP_PORT :  std_logic_vector(16-1 downto 0) := x"270C";
	ACLK_FREQ : integer := 200000000;
	C_M_AXIS_TDATA_WIDTH : integer := 64;
	C_S_AXIS_EXP_RECORDS_DATA_WIDTH : integer := 64;
	SIM_ONLY : integer := 0;
	ENCODING_TIMEOUT_IN_SECS : integer := 60
	);
port (
	ACLK : in std_logic;
	ARESETN : in std_logic;
	-- Master interface to 10GMAC Pcore
	M_AXIS_TDATA       : out std_logic_vector (C_M_AXIS_TDATA_WIDTH-1 downto 0);
	M_AXIS_TSTRB       : out std_logic_vector (C_M_AXIS_TDATA_WIDTH/8-1 downto 0);
	M_AXIS_TVALID      : out std_logic;
	M_AXIS_TREADY      : in  std_logic;
	M_AXIS_TLAST       : out std_logic;
	-- Exported flows receive interface
	S_AXIS_EXP_RECORDS_TDATA : in std_logic_vector(C_S_AXIS_EXP_RECORDS_DATA_WIDTH-1 downto 0);
	S_AXIS_EXP_RECORDS_TSTRB : in std_logic_vector(C_S_AXIS_EXP_RECORDS_DATA_WIDTH/8-1 downto 0);
	S_AXIS_EXP_RECORDS_TVALID : in std_logic;
	S_AXIS_EXP_RECORDS_TREADY : out std_logic;
	S_AXIS_EXP_RECORDS_TLAST : in std_logic
	);

attribute SIGIS : string; 
attribute SIGIS of ACLK : signal is "Clk"; 

end netflow_export;

architecture netflow_export_arch of netflow_export is

	-- Flow_encoding's signals
	signal flow_encoding_ready : std_logic;
	signal flow_encoding_ready_ack : std_logic;
	signal numb_of_records : natural  range 0 to MAX_NUMB_OF_FLOWS_PER_PACKET;
	signal udp_partial_checksum_stage1 : std_logic_vector(32-1 downto 0);
	
	-- ExpotFIFO's signals
	signal fifo_din : std_logic_vector(FIFO_DATA_WIDTH-1 downto 0);
	signal fifo_dout : std_logic_vector(FIFO_DATA_WIDTH-1 downto 0);
	signal fifo_empty : std_logic;
	signal fifo_full : std_logic;
	signal RDCOUNT : std_logic_vector(9-1 downto 0);
	signal WRCOUNT : std_logic_vector(9-1 downto 0);
	signal fifo_rd_en : std_logic;
	signal fifo_w_en : std_logic;
	signal fifo_rst : std_logic;
	
	-- Sys_time_generator's signals
	signal SysUptime : std_logic_vector(32-1 downto 0);
	signal unix_secs : std_logic_vector(32-1 downto 0);
	signal unix_nsecs : std_logic_vector(32-1 downto 0);

	-- Netflow_v5_header's signals
	signal udp_partial_checksum_stage2 : std_logic_vector(32-1 downto 0);
	signal netflow_hed_ready : std_logic;
	signal netf_v5 : netf_hed_type;
	signal bytes_netflow_pkt : integer  range 0 to MAX_LENGTH_NETFLOW_PACKET;
	
	-- Udp_packet's signals
	signal udp_hed_ready : std_logic;
	signal udp_hed : udp_hed_type;
	signal bytes_udp_pkt : integer range 0 to MAX_LENGTH_UDP_PACKET;
	
	-- Ip_header's signals
	signal ip_hed_ready : std_logic;
	signal ip_hed : ip_hed_type;
	signal bytes_ip_pkt : integer range 0 to MAX_LENGTH_IP_PACKET;

	-- RAM
	constant ADDR_WIDTH : integer := RAM_ADDR_WIDTH;
	constant DATA_WIDTH : integer := C_M_AXIS_TDATA_WIDTH;
	signal NETF_PDUs_RAM_START_INDEX : integer;	-- Position to start writing the expired flows, after all packet's headers

	type ram_type is array (2**ADDR_WIDTH-1 downto 0) of std_logic_vector (DATA_WIDTH-1 downto 0);
	signal bram1: ram_type;

	signal addra : integer range 0 to 2**RAM_ADDR_WIDTH-1;
	signal addrb : integer range 0 to 2**RAM_ADDR_WIDTH-1;
	signal dia : std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
	signal doa : std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
	signal dob : std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
	signal ram_en : std_logic;
	signal ram_w_en : std_logic;
	
	-- Eth frame sender's signals
	signal numb_of_transactions : integer range 0 to 2**RAM_ADDR_WIDTH-1;
	signal numb_of_bytes : integer range 0 to MAX_LENGTH_ETH_PACKET;
	signal eth_frame_transmitted : std_logic;
	
	-- General_control_process's signals
	signal index : integer range 0 to 2**RAM_ADDR_WIDTH-1;
	type general_control_fsm_type is (INIT_0,INIT_1,NETF_PDU_0,NETF_PDU_1,NETF_PDU_2,NETF_PDU_3,IP_HED_0,IP_HED_1,UDP_HED_0,NETF_HEAD_0,NETF_HEAD_1,NETF_HEAD_2,WAIT_FRAME_SENDER);
	signal general_control_fsm : general_control_fsm_type;
	signal first_flow : std_logic;
	signal send_eth_frame : std_logic;
	constant ETH_TYPE : std_logic_vector(16-1 downto 0) := x"0800";
	signal prev_bytes : std_logic_vector(16-1 downto 0);

begin
NETF_PDUs_RAM_START_INDEX <= ALL_PACKETS_HED_LENGTH*8/C_M_AXIS_TDATA_WIDTH;


bram_process:process (ACLK)
begin
   if (ACLK'event and ACLK = '1') then
      if (ram_en = '1') then
         if (ram_w_en = '1') then
            bram1(addra) <= dia;
         end if;
         doa <= bram1(addra);
         dob <= bram1(addrb);
      end if;
   end if;
end process bram_process;

general_control_process: process(ACLK)
	variable j : integer;
begin
	if (ACLK'event and ACLK = '1') then
		if (ARESETN = '0') then
			index <= 0;
			ram_w_en <= '0';
			addra <= 0;
			send_eth_frame <= '0';
			first_flow <= '1';
			flow_encoding_ready_ack <= '0';
			fifo_rd_en <= '0';
			general_control_fsm <= INIT_0;
			ram_en <= '0';
		else
			ram_w_en <= '0';
			ram_en <= '1';
			case general_control_fsm is
				when INIT_0 =>
					dia <= DEST_MAC_ADDR & SRC_MAC_ADDR(48-1 downto 32);
					addra <= index;
					ram_w_en <= '1';
					index <= index +1;
					general_control_fsm <= INIT_1;
				when INIT_1 =>
					dia <= SRC_MAC_ADDR(32-1 downto 0) & ETH_TYPE & ip_hed.VER_HED_LEN & ip_hed.DIFF_SERV;
					addra <= index;
					ram_w_en <= '1';
					index <= NETF_PDUs_RAM_START_INDEX;
					general_control_fsm <= NETF_PDU_0;				
				when NETF_PDU_0 =>
					numb_of_transactions <= index;
					if (fifo_empty = '0') then
						fifo_rd_en <= '1';
						general_control_fsm <= NETF_PDU_1;
					elsif (flow_encoding_ready = '1') then
						flow_encoding_ready_ack <= '1';
						first_flow <= '1';
						addra <= index;
						ram_w_en <= '1';
						dia <= prev_bytes & zeros(C_M_AXIS_TDATA_WIDTH-(prev_bytes'high+1)-1 downto 0);
						index <= 2;
						general_control_fsm <= IP_HED_0;
					end if;
				when NETF_PDU_1 =>
					general_control_fsm <= NETF_PDU_2;	-- wait for fifo's data
				when NETF_PDU_2 =>
					if (first_flow = '1') then
						first_flow <= '0';
						dia <= netf_v5.SAMPLING_MODE & fifo_dout(64-1 downto 16);
					else
						dia <= prev_bytes & fifo_dout(64-1 downto 16);
					end if;
					prev_bytes <= fifo_dout(16-1 downto 0);
					addra <= index;
					ram_w_en <= '1';
					index <= index +1;
					j := 0;
					general_control_fsm <= NETF_PDU_3;
				when NETF_PDU_3 =>
					dia <= prev_bytes & fifo_dout(64-1 downto 16);
					prev_bytes <= fifo_dout(16-1 downto 0);
					addra <= index;
					ram_w_en <= '1';
					index <= index +1;
					j := j+1;
					if (j = NUB_OF_FIFO_RD_PER_FLOW-1) then
						fifo_rd_en <= '0';
						general_control_fsm <= NETF_PDU_0;
					end if;
				when IP_HED_0 =>
					flow_encoding_ready_ack <= '0';
					numb_of_bytes <= bytes_ip_pkt + ETH_HEADER_LENGTH;
					dia <= ip_hed.total_length & ip_hed.IDENTIFICATION & ip_hed.FLAGS_AND_OFFSET & ip_hed.TTL & ip_hed.PROTOCOL;
					addra <= index;
					if (ip_hed_ready = '1') then
						send_eth_frame <= '1';
						ram_w_en <= '1';
						index <= index +1;
						general_control_fsm <= IP_HED_1;
					end if;
				when IP_HED_1 =>
					send_eth_frame <= '0';
					dia <= ip_hed.hed_checksum & SRC_IP_ADDR & DEST_IP_ADDR(32-1 downto 16);
					addra <= index;
					ram_w_en <= '1';
					index <= index +1;
					general_control_fsm <= UDP_HED_0;
				when UDP_HED_0 =>
					dia <= DEST_IP_ADDR(16-1 downto 0) & SRC_UDP_PORT & DEST_UDP_PORT & udp_hed.udp_length;
					addra <= index;
					ram_w_en <= '1';
					index <= index +1;
					general_control_fsm <= NETF_HEAD_0;
				when NETF_HEAD_0 =>
					dia <= udp_hed.udp_checksum & netf_v5.NETF_VER & netf_v5.count & netf_v5.SysUptime(32-1 downto 16);
					addra <= index;
					ram_w_en <= '1';
					index <= index +1;
					general_control_fsm <= NETF_HEAD_1;
				when NETF_HEAD_1 =>
					dia <= netf_v5.SysUptime(16-1 downto 0) & netf_v5.unix_secs & netf_v5.unix_nsecs(32-1 downto 16);
					addra <= index;
					ram_w_en <= '1';
					index <= index +1;
					general_control_fsm <= NETF_HEAD_2;
				when NETF_HEAD_2 =>
					dia <= netf_v5.unix_nsecs(16-1 downto 0) & netf_v5.flow_sequence & netf_v5.ENGINETYPE & netf_v5.ENGINEID;
					addra <= index;
					ram_w_en <= '1';
					index <= NETF_PDUs_RAM_START_INDEX;
					general_control_fsm <= WAIT_FRAME_SENDER;
				when WAIT_FRAME_SENDER =>
					if (eth_frame_transmitted = '1') then
						general_control_fsm <= NETF_PDU_0;
					end if;
			end case;
		end if;
	end if;
end process general_control_process;


------------------------------------------------------------------
-- Component declarations
------------------------------------------------------------------
eth_sender: ethernet_frame_sender
generic map (
	C_M_AXIS_TDATA_WIDTH => C_M_AXIS_TDATA_WIDTH)
port map(
	ACLK => ACLK,
	ARESETN => ARESETN,
	M_AXIS_TDATA => M_AXIS_TDATA,
	M_AXIS_TSTRB => M_AXIS_TSTRB,
	M_AXIS_TVALID => M_AXIS_TVALID,
	M_AXIS_TREADY => M_AXIS_TREADY,
	M_AXIS_TLAST => M_AXIS_TLAST,
	send_eth_frame => send_eth_frame,
	numb_of_transactions => numb_of_transactions,
	numb_of_bytes => numb_of_bytes,
	addr => addrb,
	do => dob,
	eth_frame_transmitted => eth_frame_transmitted);
------------------------------------------------------------------
flow_encoding_inst: flow_encoding
generic map(
	C_S_AXIS_EXP_RECORDS_DATA_WIDTH => C_S_AXIS_EXP_RECORDS_DATA_WIDTH,
	ACLK_FREQ => ACLK_FREQ,
	SIM_ONLY => SIM_ONLY,
	ENCODING_TIMEOUT_IN_SECS => ENCODING_TIMEOUT_IN_SECS)
port map(
	ACLK => ACLK,
	ARESETN => ARESETN,
	S_AXIS_EXP_RECORDS_TDATA => S_AXIS_EXP_RECORDS_TDATA,
	S_AXIS_EXP_RECORDS_TSTRB => S_AXIS_EXP_RECORDS_TSTRB,
	S_AXIS_EXP_RECORDS_TVALID => S_AXIS_EXP_RECORDS_TVALID,
	S_AXIS_EXP_RECORDS_TREADY => S_AXIS_EXP_RECORDS_TREADY,
	S_AXIS_EXP_RECORDS_TLAST => S_AXIS_EXP_RECORDS_TLAST,
	flow_encoding_ready => flow_encoding_ready,
	flow_encoding_ready_ack => flow_encoding_ready_ack,
	numb_of_records_out => numb_of_records,
	udp_partial_checksum_out => udp_partial_checksum_stage1,
	fifo_rst => fifo_rst,
	fifo_w_en => fifo_w_en,
	fifo_full => fifo_full,
	fifo_din => fifo_din);
------------------------------------------------------------------
sys_time_generator_inst : sys_time_generator
generic map(
	ACLK_FREQ => ACLK_FREQ)
port map(
	ACLK => ACLK,
	ARESETN => ARESETN,
	SysUptime => SysUptime,
	unix_secs => unix_secs,
	unix_nsecs => unix_nsecs);
------------------------------------------------------------------
netflow_v5_packet_inst : netflow_v5_header
port map(
	ACLK => ACLK,
	ARESETN => ARESETN,
	eth_frame_transmitted => eth_frame_transmitted,
	flow_encoding_ready => flow_encoding_ready,
	numb_of_records => numb_of_records,
	udp_partial_checksum_in => udp_partial_checksum_stage1,
	SysUptime => SysUptime,
	unix_secs => unix_secs,
	unix_nsecs => unix_nsecs,
	udp_partial_checksum_out => udp_partial_checksum_stage2,
	netflow_hed_ready => netflow_hed_ready,
	netf_hed_out => netf_v5,
	bytes_netflow_pkt => bytes_netflow_pkt);
------------------------------------------------------------------
udp_header_inst : udp_header
generic map(
	SRC_UDP_PORT => SRC_UDP_PORT,
	DEST_UDP_PORT => DEST_UDP_PORT,
	SRC_IP_ADDR => SRC_IP_ADDR,
	DEST_IP_ADDR => DEST_IP_ADDR)
port map(
	ACLK => ACLK,
	ARESETN => ARESETN,
	eth_frame_transmitted => eth_frame_transmitted,
	netflow_hed_ready => netflow_hed_ready,
	bytes_netflow_pkt => bytes_netflow_pkt,
	udp_partial_checksum_in => udp_partial_checksum_stage2,
	udp_hed_ready => udp_hed_ready,
	udp_hed_out => udp_hed,
	bytes_udp_pkt => bytes_udp_pkt);
------------------------------------------------------------------
ip_header_inst : ip_header
generic map(
	SRC_IP_ADDR => SRC_IP_ADDR,
	DEST_IP_ADDR => DEST_IP_ADDR)
port map(
	ACLK => ACLK,
	ARESETN => ARESETN,
	eth_frame_transmitted => eth_frame_transmitted,
	udp_hed_ready => udp_hed_ready,
	bytes_udp_pkt => bytes_udp_pkt,
	ip_hed_ready => ip_hed_ready,
	ip_hed_out => ip_hed,
	bytes_ip_pkt => bytes_ip_pkt);
------------------------------------------------------------------
	FIFO_SYNC_MACRO_exp0 : FIFO_SYNC_MACRO
	generic map (
	  DEVICE => "VIRTEX5",            -- Target Device: "VIRTEX5, "VIRTEX6" 
	  ALMOST_FULL_OFFSET => X"0080",  -- Sets almost full threshold
	  ALMOST_EMPTY_OFFSET => X"0080", -- Sets the almost empty threshold
	  DATA_WIDTH => FIFO_DATA_WIDTH,   -- Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
	  FIFO_SIZE => "36Kb",            -- Target BRAM, "18Kb" or "36Kb" 
	  SIM_MODE => "SAFE") -- Simulation) "SAFE" vs "FAST", 
						  -- see "Synthesis and Simulation Design Guide" for details
	port map (
	  ALMOSTEMPTY => open,   -- Output almost empty 
	  ALMOSTFULL => fifo_full,     -- Output almost full
	  DO => fifo_dout,                     -- Output data
	  EMPTY => fifo_empty,               -- Output empty
	  FULL => open,                 -- Output full
	  RDCOUNT => RDCOUNT,           -- Output read count
	  RDERR => open,               -- Output read error
	  WRCOUNT => WRCOUNT,           -- Output write count
	  WRERR => open,               -- Output write error
	  CLK => ACLK,                   -- Input clock
	  DI => fifo_din,                     -- Input data
	  RDEN => fifo_rd_en,                 -- Input read enable
	  RST => fifo_rst,                   -- Input reset
	  WREN => fifo_w_en                 -- Input write enable
	);
------------------------------------------------------------------

end architecture netflow_export_arch;
