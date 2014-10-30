-- ******************************************************************************
 -- *  Design:
 -- *        NetFlow_Simple_10G_Bram
 -- *  
 -- *  NetFPGA-10G http://www.netfpga.org
 -- *
 -- *  File:
 -- *        netflow_v5_header.vhd
 -- *
 -- *  Pcore:
 -- *        netflow_export
 -- *
 -- *  Authors:
 -- *        Marco Forconesi, Gustavo Sutter, Sergio Lopez-Buedo
 -- *
 -- *  Description:
 -- *          Waits for the flow_encoding_ready signal.
 -- *          Calculates the NetFlow v5 header according to the payload (bundle
 -- *          of expired flows).
 -- *          Calculates the partial UDP checksum with the payload data.
 -- *          Signals when the NetFlow header is ready.
-- ******************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.netflow_export_pack.all;

entity netflow_v5_header is
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

end netflow_v5_header;


architecture netflow_v5_header_arch of netflow_v5_header is

	signal netf_rec : netf_hed_type;
	signal bytes_netflow_pkt_int : integer range 0 to MAX_LENGTH_NETFLOW_PACKET;
	signal netf_hed_one_vec : std_logic_vector(NETFLOW_V5_HEADER_LENGTH*8-1 downto 0);
	
	signal count_prev : std_logic_vector(16-1 downto 0);
	signal flow_sequence_prev : std_logic_vector(32-1 downto 0); -- The sequence number is equal to the sequence number of the previous datagram plus the number of flows in the previous datagram. http://www.cisco.com/en/US/docs/net_mgmt/netflow_collection_engine/3.6/user/guide/format.html 

	type netflow_v5_header_fsm_type is (s0,s1,s2,s3);
	signal netflow_v5_header_fsm : netflow_v5_header_fsm_type;
	
-- UDP checksum calculation
	signal udp_partial_checksum_int : std_logic_vector(32-1 downto 0);
	constant numb_of_addend : integer := NETFLOW_V5_HEADER_LENGTH*8/16;	-- total # of 16-bits chunks to be added
	signal udp_partial_checksum_in_reg : std_logic_vector(32-1 downto 0);
	
begin

-- Constant values
netf_rec.NETF_VER <= x"0005";
netf_rec.ENGINETYPE <= x"00";
netf_rec.ENGINEID <= x"00";
netf_rec.SAMPLING_MODE <= x"0000";

netf_hed_out <= netf_rec;

netflow_v5_header_process: process(ACLK)
	variable L : integer range 0 to NETFLOW_V5_HEADER_LENGTH*8/16;
begin
	if (ACLK'event and ACLK = '1') then
		if (ARESETN = '0') then
			netflow_hed_ready <= '0';
			count_prev <= (others => '0');
			flow_sequence_prev <= (others => '0');
			netflow_v5_header_fsm <= s0;
		else
			case netflow_v5_header_fsm is
				when s0 =>
					netf_rec.SysUptime <= SysUptime;
					netf_rec.unix_secs <= unix_secs;
					netf_rec.unix_nsecs <= unix_nsecs;
					netf_rec.count <= std_logic_vector(to_unsigned(numb_of_records,netf_rec.count'high+1));
					netf_rec.flow_sequence <= std_logic_vector(unsigned(flow_sequence_prev) + unsigned(count_prev));
					udp_partial_checksum_in_reg <= udp_partial_checksum_in;
					if (flow_encoding_ready = '1') then
						netflow_v5_header_fsm <= s1;
					end if;
					-- UDP checksum
					udp_partial_checksum_int <= (others => '0');
					L := 0;
				when s1 =>
					bytes_netflow_pkt_int <= to_integer(unsigned(netf_rec.count)) * NETFLOW_V5_RECORD_LENGTH;
					-- UDP checksum calculation
					udp_partial_checksum_int <= std_logic_vector(unsigned(udp_partial_checksum_int) + unsigned(netf_hed_one_vec((netf_hed_one_vec'high+1)-L*16-1 downto (netf_hed_one_vec'high+1)-L*16-16)));
					L := L +1;
					if (L = numb_of_addend) then
						netflow_v5_header_fsm <= s2;
					end if;
				when s2 =>
					netflow_hed_ready <= '1';
					udp_partial_checksum_out <= std_logic_vector(unsigned(udp_partial_checksum_int) + unsigned(udp_partial_checksum_in_reg));
					bytes_netflow_pkt <= bytes_netflow_pkt_int + NETFLOW_V5_HEADER_LENGTH;
					netflow_v5_header_fsm <= s3;
				when s3 =>
					count_prev <= netf_rec.count;
					flow_sequence_prev <= netf_rec.flow_sequence;
					if (eth_frame_transmitted = '1') then
						netflow_hed_ready <= '0';
						netflow_v5_header_fsm <= s0;
					end if;
			end case;
		end if;
	end if;
end process netflow_v5_header_process;

netf_hed_one_vec <= netf_rec.NETF_VER & netf_rec.count & netf_rec.SysUptime & netf_rec.unix_secs & netf_rec.unix_nsecs & netf_rec.flow_sequence & netf_rec.ENGINETYPE & netf_rec.ENGINEID & netf_rec.SAMPLING_MODE;

end architecture netflow_v5_header_arch;
