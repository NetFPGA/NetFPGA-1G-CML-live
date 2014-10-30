-- ******************************************************************************
 -- *  Design:
 -- *        NetFlow_Simple_10G_Bram
 -- *  
 -- *  NetFPGA-10G http://www.netfpga.org
 -- *
 -- *  File:
 -- *        BSRAM.vhd
 -- *
 -- *  Pcore:
 -- *        netflow_cache
 -- *
 -- *  Authors:
 -- *        Xilinx templates
 -- *
 -- *  Description:
 -- *        Behavioural description of a BRAM used for the flow table
-- ******************************************************************************

library ieee;   
use ieee.std_logic_1164.all;   
use ieee.std_logic_unsigned.all; 

entity BSRAM is   
generic(
	ADDR_BITS: natural := 10;
	DATA_BITS: natural := 289);
  port (clk  : in std_logic;   
        ena     : in std_logic; 
        enb     : in std_logic; 
        wea     : in std_logic; 
        web     : in std_logic; 		
        addra: in std_logic_vector(ADDR_BITS-1 downto 0);  
        addrb: in std_logic_vector(ADDR_BITS-1 downto 0);  
        dia     : in std_logic_vector(DATA_BITS-1 downto 0);   
        dib     : in std_logic_vector(DATA_BITS-1 downto 0);   
        doa : out std_logic_vector(DATA_BITS-1 downto 0);   
        dob : out std_logic_vector(DATA_BITS-1 downto 0));   
end BSRAM;   

architecture syn of BSRAM is  
  type ram_type is array (0 to 2**ADDR_BITS-1) of std_logic_vector (DATA_BITS-1 downto 0);   
  shared variable RAM : ram_type := (others => (others => '0'));  
begin   
 
PORT_A: process (clk)
begin
   if (clk'event and clk = '1') then
      if (ena = '1') then
         if (wea = '1') then
            RAM(conv_integer(addra)) := dia;
         end if;
         doa <= RAM(conv_integer(addra));
      end if;
   end if;
end process;

PORT_B: process (clk)
begin
   if (clk'event and clk = '1') then
      if (enb = '1') then
         if (web = '1') then
            RAM(conv_integer(addrb)) := dib;
         end if;
         dob <= RAM(conv_integer(addrb));
      end if;
   end if;
end process;

  
end syn; 

