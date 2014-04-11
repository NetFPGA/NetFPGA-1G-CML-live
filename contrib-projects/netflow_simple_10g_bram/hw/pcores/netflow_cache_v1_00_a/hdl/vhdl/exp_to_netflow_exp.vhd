-- ******************************************************************************
 -- *  Design:
 -- *        NetFlow_Simple_10G_Bram
 -- *  
 -- *  NetFPGA-10G http://www.netfpga.org
 -- *
 -- *  File:
 -- *        exp_to_netflow_exp.vhd
 -- *
 -- *  Pcore:
 -- *        netflow_cache
 -- *
 -- *  Authors:
 -- *        Marco Forconesi, Gustavo Sutter, Sergio Lopez-Buedo
 -- *
 -- *  Description:
 -- *        This module reads the expired flows from the FIFO and exports the
 -- *        flows to the netflow_export Pcore via AXI4-Stream transactions
-- ******************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
library work;
use work.netflow_cache_pack.all;

entity exp_to_netflow_exp is
port(
	ACLK  : in  std_logic;	--clk0 as well
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
end entity exp_to_netflow_exp;

architecture exp_to_netflow_exp_arch of exp_to_netflow_exp is

	type fsm_exp_type is (s0,s1,s2,s3,s4,s5,s6,s7,s8);
	signal fsm_exp : fsm_exp_type;
	
	signal flow_to_export : std_logic_vector(240-1 downto 0);
	
begin


exp_to_netflow_exp_process: process(ACLK)
begin
if (ACLK'event and ACLK = '1') then
	if (ARESETN = '0') then	
		M_AXIS_10GMAC_tdata <= (others => '0');
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
					M_AXIS_10GMAC_tdata <= flow_to_export(64-1 downto 0);
					fsm_exp <= s4;
				end if;
			when s4 =>
				M_AXIS_10GMAC_tvalid <= '0';
				if (M_AXIS_10GMAC_tready = '1') then
					M_AXIS_10GMAC_tvalid <= '1';
					M_AXIS_10GMAC_tdata <= flow_to_export(128-1 downto 64);
					fsm_exp <= s5;
				end if;
			when s5 =>
				M_AXIS_10GMAC_tvalid <= '0';
				if (M_AXIS_10GMAC_tready = '1') then
					M_AXIS_10GMAC_tvalid <= '1';
					M_AXIS_10GMAC_tdata <= flow_to_export(192-1 downto 128);
					fsm_exp <= s6;
				end if;
			when s6 =>
				M_AXIS_10GMAC_tvalid <= '0';
				if (M_AXIS_10GMAC_tready = '1') then
					M_AXIS_10GMAC_tvalid <= '1';
					M_AXIS_10GMAC_tdata <= zeros(16-1 downto 0) & flow_to_export(240-1 downto 192);
					M_AXIS_10GMAC_tlast <= '1';
					fsm_exp <= s0;
				end if;
			when others =>
		end case;
	end if;
end if;
end process exp_to_netflow_exp_process;

end architecture exp_to_netflow_exp_arch;