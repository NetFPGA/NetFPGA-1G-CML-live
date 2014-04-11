-- ******************************************************************************
 -- *  Design:
 -- *        NetFlow_Simple_10G_Bram
 -- *  
 -- *  NetFPGA-10G http://www.netfpga.org
 -- *
 -- *  File:
 -- *        ip_header.vhd
 -- *
 -- *  Pcore:
 -- *        netflow_export
 -- *
 -- *  Authors:
 -- *        Marco Forconesi, Gustavo Sutter, Sergio Lopez-Buedo
 -- *
 -- *  Description:
 -- *          Waits for the udp_header_ready signal.
 -- *          Calculates the IP header according to the payload (UDP pkt)
 -- *          Signals when the IP header is ready.
-- ******************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
library work;
use work.netflow_export_pack.all;

entity ip_header is
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

end ip_header;

architecture ip_header_arch of ip_header is

	signal ip_hed : ip_hed_type;
	signal HED_CHECKSUM_CONST : std_logic_vector(32-1 downto 0);
	signal hed_checksum_aux : std_logic_vector(32-1 downto 0);
	type field_calc_fsm_type is (s0,s2,s3,s4);
	signal field_calc_fsm : field_calc_fsm_type;
	
begin

ip_hed_out <= ip_hed;

-- Constant values
ip_hed.VER_HED_LEN <= x"45"; -- Version and header length
ip_hed.DIFF_SERV <= x"00"; -- Differentiated Services Field or Differentiated Services Code Point & ECN
ip_hed.IDENTIFICATION <= x"0000"; -- Identification
ip_hed.FLAGS_AND_OFFSET <= x"0000";
ip_hed.TTL <= x"80"; -- Time to live
ip_hed.PROTOCOL <= UDP;

HED_CHECKSUM_CONST <= zeros(16-1 downto 0) & (ip_hed.VER_HED_LEN & ip_hed.DIFF_SERV) + ip_hed.IDENTIFICATION + ip_hed.FLAGS_AND_OFFSET + (ip_hed.TTL & ip_hed.PROTOCOL) + SRC_IP_ADDR(32-1 downto 16) + SRC_IP_ADDR(16-1 downto 0) +  DEST_IP_ADDR(32-1 downto 16) + DEST_IP_ADDR(16-1 downto 0);

field_calc_process: process(ACLK)
begin
	if (ACLK'event and ACLK = '1') then
		if (ARESETN = '0') then
			ip_hed_ready <= '0';
			field_calc_fsm <= s0;
		else
			case field_calc_fsm is
				when s0 =>
					ip_hed.total_length <= conv_std_logic_vector(IP_HEADER_LENGTH + bytes_udp_pkt,ip_hed.total_length'high+1);
					bytes_ip_pkt <= IP_HEADER_LENGTH + bytes_udp_pkt;
					if (udp_hed_ready = '1') then
						field_calc_fsm <= s2;
					end if;
				when s2 =>
					hed_checksum_aux <= HED_CHECKSUM_CONST + ip_hed.total_length;
					field_calc_fsm <= s3;
				when s3 =>
					ip_hed.hed_checksum <= not ( hed_checksum_aux(32-1 downto 16) + hed_checksum_aux(16-1 downto 0));
					ip_hed_ready <= '1';
					field_calc_fsm <= s4;
				when s4 =>
					if (eth_frame_transmitted = '1') then
						ip_hed_ready <= '0';
						field_calc_fsm <= s0;
					end if;
			end case;
		end if;
	end if;
end process field_calc_process;

end architecture ip_header_arch;
