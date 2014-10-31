-- ******************************************************************************
 -- *  Design:
 -- *        NetFlow_Simple_10G_Bram
 -- *  
 -- *  NetFPGA-10G http://www.netfpga.org
 -- *
 -- *  File:
 -- *        udp_header.vhd
 -- *
 -- *  Pcore:
 -- *        netflow_export
 -- *
 -- *  Authors:
 -- *        Marco Forconesi, Gustavo Sutter, Sergio Lopez-Buedo
 -- *
 -- *  Description:
 -- *          Contains constants and types definitions.
 -- *          Declares components of the module.
-- ******************************************************************************

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package netflow_export_pack is

	-- Constants def
	constant zeros : std_logic_vector(200-1 downto 0) := (others => '0');
	constant TCP : std_logic_vector(8-1 downto 0) := x"06";
	constant UDP : std_logic_vector(8-1 downto 0) := x"11";

	-- RAM
	constant RAM_ADDR_WIDTH : integer := 8; --log2(MAX_LENGTH_ETH_PACKET*8/C_M_AXIS_TDATA_WIDTH);

	-- PACKET_INFO
	constant TIME_STAMP_WIDTH : integer := 32;
	constant TCP_FLAGS_WIDTH : integer := 8;

	-- FLOW_COUNTERS
	constant BYTE_COUNTER_WIDTH : integer := 32;
	constant FRAME_COUNTER_WIDTH : integer := 32;

	-- Netflow v5 constants
	constant NETFLOW_V5_RECORD_LENGTH : integer := 48;
	constant MAX_NUMB_OF_FLOWS_PER_PACKET : integer := 30;
	constant NETFLOW_V5_HEADER_LENGTH : integer := 24;
	constant MAX_LENGTH_NETFLOW_PAYLOAD : integer := MAX_NUMB_OF_FLOWS_PER_PACKET * NETFLOW_V5_RECORD_LENGTH;
	constant MAX_LENGTH_NETFLOW_PACKET : integer := NETFLOW_V5_HEADER_LENGTH + MAX_LENGTH_NETFLOW_PAYLOAD;

	-- UDP constants
	constant UDP_HEADER_LENGTH : integer := 8;
	constant MAX_LENGTH_UDP_PACKET : integer := UDP_HEADER_LENGTH + MAX_LENGTH_NETFLOW_PACKET;

	-- IP constants
	constant IP_HEADER_LENGTH : integer := 20;
	constant MAX_LENGTH_IP_PACKET : integer := IP_HEADER_LENGTH + MAX_LENGTH_UDP_PACKET;

	-- ETH constants
	constant ETH_HEADER_LENGTH : integer := 14;
	constant MAX_LENGTH_ETH_PACKET : integer := ETH_HEADER_LENGTH + MAX_LENGTH_IP_PACKET;

	-- FIFO constants
	constant FIFO_DATA_WIDTH : natural := 64;
	constant NUB_OF_FIFO_RD_PER_FLOW : integer := NETFLOW_V5_RECORD_LENGTH*8/FIFO_DATA_WIDTH;
	constant ALL_PACKETS_HED_LENGTH : integer := ETH_HEADER_LENGTH + IP_HEADER_LENGTH + UDP_HEADER_LENGTH + NETFLOW_V5_HEADER_LENGTH;
	
-- Specific types
------------------------------------------------------------------
	type netf_hed_type is record
		NETF_VER : std_logic_vector(16-1 downto 0);
		ENGINETYPE : std_logic_vector(8-1 downto 0);
		ENGINEID : std_logic_vector(8-1 downto 0);
		SAMPLING_MODE : std_logic_vector(16-1 downto 0);
		SysUptime : std_logic_vector(32-1 downto 0);
		unix_secs : std_logic_vector(32-1 downto 0);
		unix_nsecs : std_logic_vector(32-1 downto 0);
		count : std_logic_vector(16-1 downto 0);
		flow_sequence : std_logic_vector(32-1 downto 0);
	end record;
------------------------------------------------------------------
	type udp_hed_type is record
		udp_checksum : std_logic_vector(16-1 downto 0);
		udp_length : std_logic_vector(16-1 downto 0);
	end record;
------------------------------------------------------------------
	type ip_hed_type is record
		VER_HED_LEN : std_logic_vector(8-1 downto 0);
		DIFF_SERV : std_logic_vector(8-1 downto 0);
		IDENTIFICATION : std_logic_vector(16-1 downto 0);
		FLAGS_AND_OFFSET : std_logic_vector(16-1 downto 0);
		TTL  : std_logic_vector(8-1 downto 0);
		PROTOCOL  : std_logic_vector(8-1 downto 0);
		total_length : std_logic_vector(16-1 downto 0);
		hed_checksum : std_logic_vector(16-1 downto 0);
	end record;
------------------------------------------------------------------
	-- Buffer for records
	type flow_record_type is record
		src_ip : std_logic_vector(32-1 downto 0);
		dest_ip : std_logic_vector(32-1 downto 0);
		src_port : std_logic_vector(16-1 downto 0);
		dest_port : std_logic_vector(16-1 downto 0);
		protocol : std_logic_vector(8-1 downto 0);
		byte_counter : std_logic_vector(BYTE_COUNTER_WIDTH-1 downto 0);
		frame_counter : std_logic_vector(FRAME_COUNTER_WIDTH-1 downto 0);
		initial_time_stamp : std_logic_vector(TIME_STAMP_WIDTH-1 downto 0);
		last_time_stamp : std_logic_vector(TIME_STAMP_WIDTH-1 downto 0);
		tcp_flags : std_logic_vector(TCP_FLAGS_WIDTH-1 downto 0);
	end record;

------------------------------------------------------------------
-- Component declarations
------------------------------------------------------------------
component ethernet_frame_sender is
generic (
	C_M_AXIS_TDATA_WIDTH : integer := 64
	);
port (
	ACLK : in std_logic;
	ARESETN : in std_logic;
	M_AXIS_TDATA       : out std_logic_vector (C_M_AXIS_TDATA_WIDTH-1 downto 0);
	M_AXIS_TSTRB       : out std_logic_vector (C_M_AXIS_TDATA_WIDTH/8-1 downto 0);
	M_AXIS_TVALID      : out std_logic;
	M_AXIS_TREADY      : in  std_logic;
	M_AXIS_TLAST       : out std_logic;
	-- Input
	send_eth_frame : in std_logic;
	numb_of_transactions : in integer range 0 to 2**RAM_ADDR_WIDTH-1;
	numb_of_bytes : in integer range 0 to MAX_LENGTH_ETH_PACKET;	-- Total # of bytes to send to the 10GMAC core
	-- Ram port
	addr : out integer range 0 to 2**RAM_ADDR_WIDTH-1;
	do : in std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
	-- Output
	eth_frame_transmitted : out std_logic
	);
end component ethernet_frame_sender;
------------------------------------------------------------------
component flow_encoding is
generic (
	C_S_AXIS_EXP_RECORDS_DATA_WIDTH : integer := 64;
	ACLK_FREQ : integer := 200000000;
	SIM_ONLY : integer := 0;
	ENCODING_TIMEOUT_IN_SECS : integer := 60
	);
port(
	ACLK : in std_logic;
	ARESETN : in std_logic;
	-- Exported flows receive interface
	S_AXIS_EXP_RECORDS_TDATA : in std_logic_vector(C_S_AXIS_EXP_RECORDS_DATA_WIDTH-1 downto 0);
	S_AXIS_EXP_RECORDS_TSTRB : in std_logic_vector(C_S_AXIS_EXP_RECORDS_DATA_WIDTH/8-1 downto 0);
	S_AXIS_EXP_RECORDS_TVALID : in std_logic;
	S_AXIS_EXP_RECORDS_TREADY : out std_logic;
	S_AXIS_EXP_RECORDS_TLAST : in std_logic;
	-- Output
	flow_encoding_ready :  out std_logic;
	flow_encoding_ready_ack : in std_logic;
	numb_of_records_out : out natural range 0 to MAX_NUMB_OF_FLOWS_PER_PACKET;
	udp_partial_checksum_out : out std_logic_vector(32-1 downto 0);
	-- Input FIFO's signals
	fifo_rst :  out std_logic;
	fifo_w_en :  out std_logic;
	fifo_full : in std_logic;
	fifo_din : out std_logic_vector(FIFO_DATA_WIDTH-1 downto 0)
	);
end component flow_encoding;
------------------------------------------------------------------
component sys_time_generator is
generic (
	ACLK_FREQ : integer := 200000000
	);
port (
	ACLK : in std_logic;
	ARESETN : in std_logic;
	-- Output
	SysUptime : out std_logic_vector(32-1 downto 0);
	unix_secs : out std_logic_vector(32-1 downto 0);
	unix_nsecs : out std_logic_vector(32-1 downto 0)
	);
end component sys_time_generator;
------------------------------------------------------------------
component netflow_v5_header is
port (
	ACLK : in std_logic;
	ARESETN : in std_logic;
	-- Input
	eth_frame_transmitted : in std_logic;
	-- Input
	flow_encoding_ready : in std_logic;
	numb_of_records : in natural  range 0 to MAX_NUMB_OF_FLOWS_PER_PACKET;
	udp_partial_checksum_in : in std_logic_vector(32-1 downto 0);
	-- Input time
	SysUptime : in std_logic_vector(32-1 downto 0);
	unix_secs : in std_logic_vector(32-1 downto 0);
	unix_nsecs : in std_logic_vector(32-1 downto 0);
	-- Output
	udp_partial_checksum_out : out std_logic_vector(32-1 downto 0);
	netflow_hed_ready : out std_logic;
	bytes_netflow_pkt : out integer range 0 to MAX_LENGTH_NETFLOW_PACKET;
	netf_hed_out : out netf_hed_type
	);
end component netflow_v5_header;
------------------------------------------------------------------
component udp_header is
generic (
	SRC_UDP_PORT :  std_logic_vector(16-1 downto 0) := x"270C";
	DEST_UDP_PORT :  std_logic_vector(16-1 downto 0) := x"270C";
	SRC_IP_ADDR :  std_logic_vector(32-1 downto 0) := x"C1C2C3C4";
	DEST_IP_ADDR :  std_logic_vector(32-1 downto 0) := x"D1D2D3D4"
	);
port (
	ACLK : in std_logic;
	ARESETN : in std_logic;
	-- Input
	eth_frame_transmitted : in std_logic;
	netflow_hed_ready : in std_logic;
	bytes_netflow_pkt : in integer range 0 to MAX_LENGTH_NETFLOW_PACKET;
	udp_partial_checksum_in : in std_logic_vector(32-1 downto 0);
	-- Output
	udp_hed_ready : out std_logic;
	udp_hed_out : out udp_hed_type;
	bytes_udp_pkt : out integer range 0 to MAX_LENGTH_UDP_PACKET	-- # bytes in the ip payload
	);
end component udp_header;
------------------------------------------------------------------
component ip_header is
generic (
	SRC_IP_ADDR :  std_logic_vector(32-1 downto 0) := x"C1C2C3C4";
	DEST_IP_ADDR :  std_logic_vector(32-1 downto 0) := x"D1D2D3D4"
	);
port (
	ACLK : in std_logic;
	ARESETN : in std_logic;
	-- Input
	eth_frame_transmitted : in std_logic;
	udp_hed_ready : in std_logic;
	bytes_udp_pkt : in integer range 0 to MAX_LENGTH_UDP_PACKET;
	-- Output
	ip_hed_ready : out std_logic;
	ip_hed_out : out ip_hed_type;
	bytes_ip_pkt : out integer range 0 to MAX_LENGTH_IP_PACKET	-- # bytes in the ethernet payload
	);
end component ip_header;
------------------------------------------------------------------

end netflow_export_pack;

package body netflow_export_pack is


end netflow_export_pack;
