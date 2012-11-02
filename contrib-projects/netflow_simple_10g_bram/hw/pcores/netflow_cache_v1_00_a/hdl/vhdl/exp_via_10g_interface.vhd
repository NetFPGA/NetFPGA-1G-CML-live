-- ******************************************************************************
 -- *  Design:
 -- *        NetFlow_Simple_10G_Bram
 -- *  
 -- *  NetFPGA-10G http://www.netfpga.org
 -- *
 -- *  File:
 -- *        exp_via_10g_interface.vhd
 -- *
 -- *  Pcore:
 -- *        netflow_cache
 -- *
 -- *  Authors:
 -- *        Marco Forconesi, Gustavo Sutter, Sergio Lopez-Buedo
 -- *
 -- *  Description:
 -- *        This module is instantiated in case the netflow_export Pcore is not
 -- *        present in the EDK project. It reads the expired flows from the FIFO
 -- *        and exports the flows via a 10G interface in a non-standard Ethernet
 -- *        format.
-- ******************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity exp_via_10g_interface is
generic (
	C_M_AXIS_EXP_RECORDS_DATA_WIDTH   : integer := 64
	);
port(
	ACLK  : in  std_logic;	--clk0 as well
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
end entity exp_via_10g_interface;

architecture exp_via_10g_interface_arch of exp_via_10g_interface is

	type fsm_exp_type is (s0,s1,s2,s3,s4,s5,s6,s7,s8);
	signal fsm_exp : fsm_exp_type;
	
	signal M_AXIS_10GMAC_tdata_rev : std_logic_vector(64-1 downto 0);
	
	signal flow_to_export : std_logic_vector(240-1 downto 0);
	signal byte_counter : std_logic_vector(32-1 downto 0);
	signal frame_counter : std_logic_vector(32-1 downto 0);
	signal last_timestamp : std_logic_vector(32-1 downto 0);
	signal initial_timestamp : std_logic_vector(32-1 downto 0);
	signal tcp_flags : std_logic_vector(8-1 downto 0);
	signal five_tuple : std_logic_vector(104-1 downto 0);
	
	signal processed_packets  : std_logic_vector(32-1 downto 0);
	
begin

processed_packets <= counters(32-1 downto 0);

byte_counter	<= flow_to_export(32-1 downto 0);
frame_counter <= flow_to_export(64-1 downto 32);
last_timestamp <= flow_to_export(96-1 downto 64);
initial_timestamp <= flow_to_export(128-1 downto 96);
tcp_flags <= flow_to_export(136-1 downto 128);
five_tuple <= flow_to_export (240-1 downto 136);

-- Reverse the byte order in order to simplify the code 
Rev_byte_order : for L in 0 to (C_M_AXIS_EXP_RECORDS_DATA_WIDTH/8-1) generate
	M_AXIS_10GMAC_tdata(C_M_AXIS_EXP_RECORDS_DATA_WIDTH-L*8-1 downto C_M_AXIS_EXP_RECORDS_DATA_WIDTH-(L+1)*8) <= M_AXIS_10GMAC_tdata_rev((L+1)*8-1 downto L*8);
end generate Rev_byte_order ;

exp_via_10g_interface_process: process(ACLK)
begin
if (ACLK'event and ACLK = '1') then
	if (ARESETN = '0') then	
		M_AXIS_10GMAC_tdata_rev <= (others => '0');
		M_AXIS_10GMAC_tstrb <= (others => '0');
		M_AXIS_10GMAC_tvalid <= '0';
		M_AXIS_10GMAC_tlast <= '0';
		fifo_rd_exp_en <= '0';
		fsm_exp <= s0;
	else
		case fsm_exp is
			when s0 =>
				M_AXIS_10GMAC_tvalid <= '0';
				M_AXIS_10GMAC_tlast <= '0';
				if (fifo_empty_exp = '0') then
					fifo_rd_exp_en <= '1';
					fsm_exp <= s1;
				end if;
			when s1 =>
				fifo_rd_exp_en <= '0';
				fsm_exp <= s2;
			when s2 =>
					flow_to_export <= fifo_out_exp;
					fsm_exp <= s3;
			when s3 =>
				if (M_AXIS_10GMAC_tready = '1') then
					M_AXIS_10GMAC_tstrb <= (others => '1');
					M_AXIS_10GMAC_tvalid <= '1';
					M_AXIS_10GMAC_tdata_rev <= five_tuple(104-1 downto 40);
					fsm_exp <= s4;
				end if;
			when s4 =>
				M_AXIS_10GMAC_tvalid <= '0';
				if (M_AXIS_10GMAC_tready = '1') then
					M_AXIS_10GMAC_tvalid <= '1';
					M_AXIS_10GMAC_tdata_rev <= five_tuple(40-1 downto 0) & x"000000";
					fsm_exp <= s5;
				end if;
			when s5 =>
				M_AXIS_10GMAC_tvalid <= '0';
				if (M_AXIS_10GMAC_tready = '1') then
					M_AXIS_10GMAC_tvalid <= '1';
					M_AXIS_10GMAC_tdata_rev <= frame_counter & byte_counter;
					fsm_exp <= s6;
				end if;
			when s6 =>
				M_AXIS_10GMAC_tvalid <= '0';
				if (M_AXIS_10GMAC_tready = '1') then
					M_AXIS_10GMAC_tvalid <= '1';
					M_AXIS_10GMAC_tdata_rev <= initial_timestamp & last_timestamp;
					fsm_exp <= s7;
				end if;
			when s7 =>
				M_AXIS_10GMAC_tvalid <= '0';
				if (M_AXIS_10GMAC_tready = '1') then
					M_AXIS_10GMAC_tvalid <= '1';
					M_AXIS_10GMAC_tdata_rev <= tcp_flags & x"000000" & collision_counter;
					fsm_exp <= s8;
				end if;
			when s8 =>
				M_AXIS_10GMAC_tvalid <= '0';
				if (M_AXIS_10GMAC_tready = '1') then
					M_AXIS_10GMAC_tvalid <= '1';
					M_AXIS_10GMAC_tdata_rev <= processed_packets & x"00000000";
					M_AXIS_10GMAC_tlast <= '1';
					fsm_exp <= s0;
				end if;
			when others =>
		end case;
	end if;
end if;
end process exp_via_10g_interface_process;

end architecture exp_via_10g_interface_arch;