-- ******************************************************************************
 -- *  Design:
 -- *        NetFlow_Simple_10G_Bram
 -- *  
 -- *  NetFPGA-10G http://www.netfpga.org
 -- *
 -- *  File:
 -- *        pkt_classification.vhd
 -- *
 -- *  Pcore:
 -- *        netflow_cache
 -- *
 -- *  Authors:
 -- *        Marco Forconesi, Gustavo Sutter, Sergio Lopez-Buedo
 -- *
 -- *  Description:
 -- *        This module extracts the 5-tuple of each Ethernet frame and time stamps
 -- *        the frame. Additional information is extracted from the frame:
 -- *         - Number of bytes in the IP Total Length field of IPv4 packet
 -- *         - TCP flags, if protocol is TCP
 -- *        Assumes a 64-bits AXI4-Stream connection.
 -- *        If the Ethernet frame that interface is receiving is not valid
 -- *        (refer to the documentation to see the valid frames) the frame is
 -- *        discarded.
 -- *        The composition of the 5-tuple:
 -- *         - SOURCE-IP, DEST-IP,
 -- *         - SOURCE_TCP/UDP_PORT, DEST_TCP/UDP_PORT,
 -- *         - PROTOCOL_OF_TRANSPORT_LAYER
-- ******************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
library work;
use work.netflow_cache_pack.all;

entity pkt_classification is
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
	timestamp_counter : in std_logic_vector(TIMESTAMP_WIDTH-1 downto 0);
	-- Outputs
	num_processed_pkts : out std_logic_vector(32-1 downto 0);
	five_tuple    : out std_logic_vector(FIVE_TUPLE_WIDTH-1 downto 0);
	pkt_info    : out std_logic_vector(PKT_INFO_WIDTH-1 downto 0);
	tuple_and_info_valid : out  std_logic
	);
attribute SIGIS : string; 
attribute SIGIS of ACLK : signal is "Clk";  

end entity pkt_classification;


architecture pkt_classification_arch of pkt_classification is
  	
	type extract_fsm_type is (IDLE_STATE, DONT_TRANSMIT_STATE, TRANSMIT_STATE, RCV_1, RCV_ipv4_no_vlan_0, RCV_ipv4_no_vlan_1,
	RCV_ipv4_no_vlan_2, RCV_ipv4_no_vlan_3, RCV_ipv4_vlan1_0, RCV_ipv4_vlan1_1, RCV_ipv4_vlan1_2, RCV_ipv4_vlan1_3, RCV_ipv4_vlan1_4,
	RCV_ipv4_vlan2_0, RCV_ipv4_vlan2_1, RCV_ipv4_vlan2_2, RCV_ipv4_vlan2_3);
	signal extract_fsm : extract_fsm_type;
	signal S_AXIS_TDATA_rev : std_logic_vector(C_S_AXIS_10GMAC_DATA_WIDTH-1 downto 0);
  	signal processed_packets : std_logic_vector(32-1 downto 0);	
	-- Some flags
	signal new_packet  : std_logic;
	-- Frame Information
	signal frame_ip_total_length : std_logic_vector(IP_TOTAL_LENGTH_FIELD_WIDTH-1 downto 0);
	signal frame_tcp_flags : std_logic_vector(TCP_FLAGS_WIDTH-1 downto 0);
	signal frame_timestamp : std_logic_vector(TIMESTAMP_WIDTH-1 downto 0);
	-- Frame 5-tuple
	signal src_ip : std_logic_vector(32-1 downto 0);
	signal dest_ip : std_logic_vector(32-1 downto 0);
	signal src_port : std_logic_vector(16-1 downto 0);
	signal dest_port : std_logic_vector(16-1 downto 0);
	signal protocol : std_logic_vector(8-1 downto 0);

begin

num_processed_pkts <= processed_packets;

five_tuple <= src_ip & dest_ip & src_port & dest_port & protocol;

-- Reverse the byte order in order to simplify the code 
Rev_byte_order : for L in 0 to (C_S_AXIS_10GMAC_DATA_WIDTH/8-1) generate
	S_AXIS_TDATA_rev(C_S_AXIS_10GMAC_DATA_WIDTH-L*8-1 downto C_S_AXIS_10GMAC_DATA_WIDTH-(L+1)*8) <= S_AXIS_TDATA((L+1)*8-1 downto L*8);
end generate Rev_byte_order ;

extractor_5_tuple_process: process(ACLK)
begin
	if (ACLK'event and ACLK = '1') then
		if (ARESETN = '0') then                    
			new_packet <= '1';
			S_AXIS_TREADY <= '0';
			processed_packets <= (others => '0');
			tuple_and_info_valid <= '0';
		else
			S_AXIS_TREADY <= '1';                  -- Slave must always be ready according to the 10G-MAC core specification
			tuple_and_info_valid <= '0';
			if (S_AXIS_TVALID = '1' and new_packet = '1') then
				new_packet <= '0';
				frame_timestamp <= timestamp_counter;    -- Time stamp is aligned to the start of the Ethernet frame.
			end if;
			--#######-----FSM------########
			case extract_fsm is
				when IDLE_STATE =>
					if (S_AXIS_TVALID = '1') then
						extract_fsm <= RCV_1;							-- Do nothing for the first AXI4-Stream transaction (MAC addresses)
					end if;
				when RCV_1 =>
					processed_packets <= processed_packets +1;
					if (S_AXIS_TVALID = '1') then
						if (S_AXIS_TDATA_rev(31 downto 16) = x"0800" and S_AXIS_TDATA_rev(15 downto 12) = x"4") then -- Check if  packet isIPv4
							extract_fsm <= RCV_ipv4_no_vlan_0;
						elsif (S_AXIS_TDATA_rev(31 downto 16) = x"8100") then
							extract_fsm <= RCV_ipv4_vlan1_0;		-- If the frame has a VLAN tag, extract the fields after the VLAN fields
						else                                                           													  --if it isn't one of the others above
							extract_fsm <= DONT_TRANSMIT_STATE;                            -- Machine goes to wait the end of the current useless packet
						end if;
					end if;
				when RCV_ipv4_no_vlan_0 =>
					frame_ip_total_length <= S_AXIS_TDATA_rev(63 downto 48);      -- Save the IP_TOTAL_LENGTH (# of bytes)
					protocol <= S_AXIS_TDATA_rev(7 downto 0);         -- Save the PROTOCOL
					if (S_AXIS_TVALID = '1') then
						if (S_AXIS_TDATA_rev(7 downto 0) = x"06" or S_AXIS_TDATA_rev(7 downto 0) = x"11") then      -- If TCP or UDP
							extract_fsm <= RCV_ipv4_no_vlan_1;
						else
							extract_fsm <= DONT_TRANSMIT_STATE;                          -- Machine goes to wait the end of the current useless packet
						end if;
					end if;	
				when RCV_ipv4_no_vlan_1 =>
					src_ip <= S_AXIS_TDATA_rev(47 downto 16);       -- Source IP
					dest_ip(32-1 downto 16) <= S_AXIS_TDATA_rev(15 downto 0);         -- 1st half of destination IP
					if (S_AXIS_TVALID = '1') then
						extract_fsm <= RCV_ipv4_no_vlan_2;
					end if;
				when RCV_ipv4_no_vlan_2 =>
					dest_ip(16-1 downto 0) <= S_AXIS_TDATA_rev(63 downto 48);         -- 2nd half of destination IP
					src_port <= S_AXIS_TDATA_rev(47 downto 32);         -- Source TCP/UDP port
					dest_port <= S_AXIS_TDATA_rev(31 downto 16);          -- Destination TCP/UDP port
					if (S_AXIS_TVALID = '1') then
						extract_fsm <= RCV_ipv4_no_vlan_3;
					end if;
				when RCV_ipv4_no_vlan_3 =>
					if (protocol = TCP) then
						frame_tcp_flags <= S_AXIS_TDATA_rev(7 downto 0);                    -- Save TCP flags if protocol = TCP
					else
						frame_tcp_flags <= (others => '0');
					end if;
					if (S_AXIS_TVALID = '1') then
						extract_fsm <= TRANSMIT_STATE;
					end if;
				---------------------------------------------------------------------------
				when RCV_ipv4_vlan1_0 =>		-- If the frame has a VLAN tag, extract the fields after the VLAN fields
					frame_ip_total_length <= S_AXIS_TDATA_rev(31 downto 16);      -- Save the IP_TOTAL_LENGTH (# of bytes)
					if (S_AXIS_TVALID = '1') then
						if (S_AXIS_TDATA_rev(63 downto 48) = x"8100" and S_AXIS_TDATA_rev(31 downto 16) = x"0800" and S_AXIS_TDATA_rev(15 downto 12) = x"4") then -- If 2nd TAG is found, extract the fields after the two VLANs fields
							extract_fsm <= RCV_ipv4_vlan2_0;
						elsif (S_AXIS_TDATA_rev(63 downto 48) = x"0800" and S_AXIS_TDATA_rev(47 downto 44) = x"4") then			-- If  IPv4
							extract_fsm <= RCV_ipv4_vlan1_1;
						else
							extract_fsm <= DONT_TRANSMIT_STATE;                          -- Machine goes to wait the end of the current useless packet
						end if;
					end if;
				when RCV_ipv4_vlan1_1 =>
					protocol <= S_AXIS_TDATA_rev(39 downto 32);         -- Save the PROTOCOL
					src_ip(32-1 downto 16) <= S_AXIS_TDATA_rev(15 downto 0);       -- 1st half of source IP
					if (S_AXIS_TVALID = '1') then
						extract_fsm <= RCV_ipv4_vlan1_2;
					end if;
				when RCV_ipv4_vlan1_2 =>
					src_ip(16-1 downto 0) <= S_AXIS_TDATA_rev(63 downto 48);       -- 2nd half of source IP
					dest_ip <= S_AXIS_TDATA_rev(47 downto 16);       -- Destination IP
					src_port <= S_AXIS_TDATA_rev(15 downto 0);        -- Source TCP/UDP port
					if (S_AXIS_TVALID = '1') then
						extract_fsm <= RCV_ipv4_vlan1_3;
					end if;
				when RCV_ipv4_vlan1_3 =>
					dest_port <= S_AXIS_TDATA_rev(63 downto 48);        -- Destination TCP/UDP port
					if (S_AXIS_TVALID = '1') then
						extract_fsm <= RCV_ipv4_vlan1_4;
					end if;
				when RCV_ipv4_vlan1_4 =>
					if (protocol = TCP) then
						frame_tcp_flags <= S_AXIS_TDATA_rev(7 downto 0);                    -- Save TCP flags if protocol = TCP
					else
						frame_tcp_flags <= (others => '0');
					end if;
					if (S_AXIS_TVALID = '1') then
						extract_fsm <= TRANSMIT_STATE;
					end if;
				---------------------------------------------------------------------------
				when RCV_ipv4_vlan2_0 =>		-- If the frame has a 2 VLAN tags, extract the fields after the VLAN fields
					frame_ip_total_length <= S_AXIS_TDATA_rev(63 downto 48);      -- Save the IP_TOTAL_LENGTH (# of bytes)
					protocol <= S_AXIS_TDATA_rev(7 downto 0);         -- Save the PROTOCOL
					if (S_AXIS_TVALID = '1') then
						extract_fsm <= RCV_ipv4_vlan2_1;
					end if;
				when RCV_ipv4_vlan2_1 =>
					src_ip <= S_AXIS_TDATA_rev(47 downto 16);       -- Source IP
					dest_ip(32-1 downto 16) <= S_AXIS_TDATA_rev(15 downto 0);         -- 1st half of destination IP
					if (S_AXIS_TVALID = '1') then
						extract_fsm <= RCV_ipv4_vlan2_2;
					end if;
				when RCV_ipv4_vlan2_2 =>
					dest_ip(16-1 downto 0) <= S_AXIS_TDATA_rev(63 downto 48);         -- 2nd half of destination IP
					src_port <= S_AXIS_TDATA_rev(47 downto 32);         -- Source TCP/UDP port
					dest_port <= S_AXIS_TDATA_rev(31 downto 16);           -- Destination TCP/UDP port
					if (S_AXIS_TVALID = '1') then
						extract_fsm <= RCV_ipv4_vlan2_3;			
					end if;
				when RCV_ipv4_vlan2_3 =>
					if (protocol = TCP) then
						frame_tcp_flags <= S_AXIS_TDATA_rev(7 downto 0);                    -- Save TCP flags if protocol = TCP
					else
						frame_tcp_flags <= (others => '0');
					end if;
					if (S_AXIS_TVALID = '1') then
						extract_fsm <= TRANSMIT_STATE;					
					end if;
				---------------------------------------------------------------------------
				when DONT_TRANSMIT_STATE =>                                  -- Wait for the current Ethernet frame to finish. do not transmit de 5-tuple
					if (S_AXIS_TVALID = '1' and S_AXIS_TLAST = '1') then
						extract_fsm <= IDLE_STATE;                          -- When last AXI4-Stream transaction comes, drive the machine to wait the next Ethernet frame
						new_packet <= '1';
					end if;
				when TRANSMIT_STATE =>                                  -- Wait for the current Ehernet frame to finish. transmit de 5-tuple and the frame's information
					pkt_info(16-1 downto 0) <= frame_ip_total_length;
					pkt_info(48-1 downto 16) <= frame_timestamp;
					pkt_info(56-1 downto 48) <= frame_tcp_flags;
					if (S_AXIS_TVALID = '1' and S_AXIS_TLAST = '1') then		-- We should use the CRC verification line provided by the 10GMAC core, but not implemented in the reference design. If Ethernet frame CRC checksum is wrong, then discard the current frame
						new_packet <= '1';
						extract_fsm <= IDLE_STATE;
						tuple_and_info_valid <= '1';
					end if;
				when others =>
					extract_fsm <= DONT_TRANSMIT_STATE;
			end case;
			-------------FSM----------------
		end if;
	end if;
end process;

end architecture pkt_classification_arch;
