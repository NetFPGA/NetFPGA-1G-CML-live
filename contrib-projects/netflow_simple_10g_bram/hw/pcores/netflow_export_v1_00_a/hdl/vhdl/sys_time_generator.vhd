-- ******************************************************************************
 -- *  Design:
 -- *        NetFlow_Simple_10G_Bram
 -- *  
 -- *  NetFPGA-10G http://www.netfpga.org
 -- *
 -- *  File:
 -- *        sys_time_generator.vhd
 -- *
 -- *  Pcore:
 -- *        netflow_export
 -- *
 -- *  Authors:
 -- *        Marco Forconesi, Gustavo Sutter, Sergio Lopez-Buedo
 -- *
 -- *  Description:
 -- *          Provides the time information for the netflow v5 header:
 -- *          SysUptime: Current time in milliseconds since the export device booted
 -- *          unix_secs: Current count of seconds since 0000 UTC 1970
 -- *          unix_nsecs: Residual nanoseconds since 0000 UTC 1970
-- ******************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.netflow_export_pack.all;


entity sys_time_generator is
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

end sys_time_generator;

architecture sys_time_generator_arch of sys_time_generator is

	constant ONE_HZ_MAX_COUNT : natural := ACLK_FREQ;
	constant ONE_KHZ_MAX_COUNT : natural := ACLK_FREQ/1000;
	
	signal	SysUptime_int : std_logic_vector(32-1 downto 0);
	signal	unix_secs_int : std_logic_vector(32-1 downto 0);
	signal	unix_nsecs_int : std_logic_vector(32-1 downto 0);

	signal divisor_1 : natural;
	signal divisor_2 : natural;

begin

SysUptime <= SysUptime_int;
unix_secs <= unix_secs_int;
unix_nsecs <= unix_nsecs_int;

sys_time_process: process(ACLK)
begin
	if (ACLK'event and ACLK = '1') then
		if (ARESETN = '0') then
			divisor_1 <= 0;
			SysUptime_int <= (others => '0'); -- Current time in milliseconds since the export device booted  
		else
			divisor_1 <= divisor_1 +1;
			if (divisor_1 = ONE_KHZ_MAX_COUNT-1) then
				divisor_1 <= 0;
				SysUptime_int <= std_logic_vector(unsigned(SysUptime_int) + to_unsigned(1,32));
			end if;
		end if;
	end if;
end process sys_time_process;

unix_secs_process: process(ACLK)
begin
	if (ACLK'event and ACLK = '1') then
		if (ARESETN = '0') then
			divisor_2 <= 0;
			unix_secs_int <= x"4F468A58"; -- Current count of seconds since 0000 UTC 1970 (Thu, 23 Feb 2012 18:50:00 GMT)
		else
			divisor_2 <= divisor_2 +1;
			if (divisor_2 = ONE_HZ_MAX_COUNT-1) then
				divisor_2 <= 0;
				unix_secs_int <= std_logic_vector(unsigned(unix_secs_int) + to_unsigned(1,32));
			end if;
		end if;
	end if;
end process unix_secs_process;

unix_nsecs_process: process(ACLK)
begin
	if (ACLK'event and ACLK = '1') then
		if (ARESETN = '0') then
			unix_nsecs_int <= (others => '0'); -- Residual nanoseconds since 0000 UTC 1970 
		else
			unix_nsecs_int <= std_logic_vector(unsigned(unix_nsecs_int) + to_unsigned(5,32));
		end if;
	end if;
end process unix_nsecs_process;

end architecture sys_time_generator_arch;