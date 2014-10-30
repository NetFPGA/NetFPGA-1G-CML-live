-- ******************************************************************************
 -- *  Design:
 -- *        NetFlow_Simple_10G_Bram
 -- *  
 -- *  NetFPGA-10G http://www.netfpga.org
 -- *
 -- *  File:
 -- *        timestamp_counter_generator.vhd
 -- *
 -- *  Pcore:
 -- *        netflow_cache
 -- *
 -- *  Authors:
 -- *        Marco Forconesi, Gustavo Sutter, Sergio Lopez-Buedo
 -- *
 -- *  Description:
 -- *        This module generates a time counter. It is used to:
 -- *         - Time stamp each frame the interface receives (pkt_classification) 
 -- *         - Check if a flow is inactive  for removal (time since the last
 -- *           packet matched the flow-entry > INACTIVE_TIMEOUT constant)
 -- *         - Check if a flow has been active for too long for removal (time 
 -- *           since flow-entry creation > ACTIVE_TIMEOUT constant)
 -- *        In the future this module should be connected to a  GPS receiver
 -- *        to synchronize with absolute time.
-- ******************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
library work;
use work.netflow_cache_pack.all;


entity timestamp_counter_mod is
generic (
	SIM_ONLY : integer := 0;
	ACLK_FREQ : integer := 200000000
	); 
port (
	-- AXI4-Stream slave interface
	ACLK  : in  std_logic;	
	ARESETN  : in  std_logic;
	--Output counter
	timestamp_counter_out : out std_logic_vector(timestamp_WIDTH-1 downto 0)
	);
end entity timestamp_counter_mod;

architecture  timestamp_counter_mod_arch of timestamp_counter_mod is

	constant ONE_KHZ_MAX_COUNT : integer := ACLK_FREQ/1000;	-- To generate a signal with 1ms of period
	
	signal timestamp_counter : std_logic_vector(timestamp_WIDTH-1 downto 0);
	signal divisor_for_miliseconds : integer;
	signal max_count : integer;

begin

max_count <= ONE_KHZ_MAX_COUNT when (SIM_ONLY = 0) else ONE_KHZ_MAX_COUNT/10000;

timestamp_counter_out <= timestamp_counter;

timestamp_counter_process: process(ACLK)
begin
	if (ACLK'event and ACLK = '1') then
		if (ARESETN = '0') then                    
			timestamp_counter <= (others => '0');
			divisor_for_miliseconds <= 0;
		else
			if (divisor_for_miliseconds = max_count) then
				divisor_for_miliseconds <= 0;
				timestamp_counter <= timestamp_counter +1;
			else
				divisor_for_miliseconds <= divisor_for_miliseconds +1;
			end if;
		end if;	
	end if;	
end process timestamp_counter_process; 

end architecture  timestamp_counter_mod_arch;