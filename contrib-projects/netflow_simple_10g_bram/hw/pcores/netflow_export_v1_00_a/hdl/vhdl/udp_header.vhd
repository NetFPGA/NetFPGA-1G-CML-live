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
 -- *          Waits for the netflow_v5_header_ready signal.
 -- *          Calculates the UDP header according to the payload (NetFlow v5 pkt)
 -- *          Calculates the UDP checksum with the previous partial UDP checksum
 -- *          Signals when the UDP header is ready.
-- ******************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.netflow_export_pack.all;


entity udp_header is
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
end udp_header;


architecture udp_header_arch of udp_header is

	signal udp_hed : udp_hed_type;
	signal UDP_CHECKSUM_CONST : std_logic_vector(32-1 downto 0) :=  std_logic_vector(unsigned(zeros(16-1 downto 0) & SRC_IP_ADDR(32-1 downto 16)) +
																																	unsigned(SRC_IP_ADDR(16-1 downto 0)) +  unsigned(DEST_IP_ADDR(32-1 downto 16)) + 
																																	unsigned(DEST_IP_ADDR(16-1 downto 0)) + unsigned(UDP) + 
																																	unsigned(SRC_UDP_PORT) + unsigned(DEST_UDP_PORT));
	signal udp_length : std_logic_vector(16-1 downto 0);
	signal udp_checksum : std_logic_vector(16-1 downto 0);
	signal udp_checksum_aux : std_logic_vector(32-1 downto 0);
	type field_calc_fsm_type is (s0,s1,s2,s3,s4);
	signal field_calc_fsm : field_calc_fsm_type;
begin


udp_hed_out <= udp_hed;
	
field_calc_process: process(ACLK)
begin
	if (ACLK'event and ACLK = '1') then
		if (ARESETN = '0') then
			udp_hed_ready <= '0';
			field_calc_fsm <= s0;
		else
			case field_calc_fsm is
				when s0 =>
					udp_hed.udp_length <= std_logic_vector(to_unsigned(UDP_HEADER_LENGTH + bytes_netflow_pkt,udp_hed.udp_length'high+1));
					udp_checksum_aux <= std_logic_vector(unsigned(UDP_CHECKSUM_CONST) + unsigned(udp_partial_checksum_in));
					if (netflow_hed_ready = '1') then
						field_calc_fsm <= s1;
					end if;
				when s1 =>
					udp_checksum_aux <= std_logic_vector(unsigned(udp_checksum_aux) + unsigned(udp_hed.udp_length) + unsigned(udp_hed.udp_length)); -- UDP check sum calculation alg see RFC 768 at http://tools.ietf.org/html/rfc768
					field_calc_fsm <= s2;
				when s2 =>
					udp_hed.udp_checksum <= not (std_logic_vector(unsigned(udp_checksum_aux(32-1 downto 16)) + unsigned(udp_checksum_aux(16-1 downto 0))) );
					field_calc_fsm <= s3;
				when s3 =>
					if (udp_hed.udp_checksum = zeros(16-1 downto 0)) then
						udp_hed.udp_checksum <= (others => '1');	-- UDP check sum calculation alg see RFC 768 at http://tools.ietf.org/html/rfc768
					end if;
					bytes_udp_pkt <= to_integer(unsigned(udp_hed.udp_length));
					udp_hed_ready <= '1';
					field_calc_fsm <= s4;
				when s4 =>
					if (eth_frame_transmitted = '1') then
						udp_hed_ready <= '0';
						field_calc_fsm <= s0;
					end if;
			end case;
		end if;
	end if;
end process field_calc_process;

end architecture udp_header_arch;
