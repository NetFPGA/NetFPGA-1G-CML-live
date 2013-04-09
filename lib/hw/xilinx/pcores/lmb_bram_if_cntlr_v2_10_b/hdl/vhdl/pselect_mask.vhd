-------------------------------------------------------------------------------
-- $Id: pselect_mask.vhd,v 1.3 2008/10/02 07:47:46 rolandp Exp $
-------------------------------------------------------------------------------
-- DISCLAIMER OF LIABILITY
--
-- This file contains proprietary and confidential information of
-- Xilinx, Inc. ("Xilinx"), that is distributed under a license
-- from Xilinx, and may be used, copied and/or disclosed only
-- pursuant to the terms of a valid license agreement with Xilinx.
--
-- XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION
-- ("MATERIALS") "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
-- EXPRESSED, IMPLIED, OR STATUTORY, INCLUDING WITHOUT
-- LIMITATION, ANY WARRANTY WITH RESPECT TO NONINFRINGEMENT,
-- MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE. Xilinx
-- does not warrant that functions included in the Materials will
-- meet the requirements of Licensee, or that the operation of the
-- Materials will be uninterrupted or error-free, or that defects
-- in the Materials will be corrected. Furthermore, Xilinx does
-- not warrant or make any representations regarding use, or the
-- results of the use, of the Materials in terms of correctness,
-- accuracy, reliability or otherwise.
--
-- Xilinx products are not designed or intended to be fail-safe,
-- or for use in any application requiring fail-safe performance,
-- such as life-support or safety devices or systems, Class III
-- medical devices, nuclear facilities, applications related to
-- the deployment of airbags, or any other applications that could
-- lead to death, personal injury or severe property or
-- environmental damage (individually and collectively, "critical
-- applications"). Customer assumes the sole risk and liability
-- of any use of Xilinx products in critical applications,
-- subject only to applicable laws and regulations governing
-- limitations on product liability.
--
-- Copyright 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009 Xilinx, Inc.
-- All rights reserved.
--
-- This disclaimer and copyright notice must be retained as part
-- of this file at all times.
--
-------------------------------------------------------------------------------
-- Filename:        pselect_mask.vhd
--
-- Description:     
--                  
-- VHDL-Standard:   VHDL'93
-------------------------------------------------------------------------------
-- Structure:   
--              pselect_mask.vhd
--
-------------------------------------------------------------------------------
-- Author:          goran
-- Revision:        $Revision: 1.3 $
-- Date:            $Date: 2008/10/02 07:47:46 $
--
-- History:
--   goran  2002-02-06    First Version
--
-------------------------------------------------------------------------------
-- Naming Conventions:
--      active low signals:                     "*_n"
--      clock signals:                          "clk", "clk_div#", "clk_#x" 
--      reset signals:                          "rst", "rst_n" 
--      generics:                               "C_*" 
--      user defined types:                     "*_TYPE" 
--      state machine next state:               "*_ns" 
--      state machine current state:            "*_cs" 
--      combinatorial signals:                  "*_com" 
--      pipelined or register delay signals:    "*_d#" 
--      counter signals:                        "*cnt*"
--      clock enable signals:                   "*_ce" 
--      internal version of output port         "*_i"
--      device pins:                            "*_pin" 
--      ports:                                  - Names begin with Uppercase 
--      processes:                              "*_PROCESS" 
--      component instantiations:               "<ENTITY_>I_<#|FUNC>
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

library Unisim;
use Unisim.all;

-----------------------------------------------------------------------------
-- Entity section
-----------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Definition of Generics:
--          C_AB            -- number of address bits to decode
--          C_AW            -- width of address bus
--          C_BAR           -- base address of peripheral (peripheral select
--                             is asserted when the C_AB most significant
--                             address bits match the C_AB most significant
--                             C_BAR bits
-- Definition of Ports:
--          A               -- address input
--          AValid          -- address qualifier
--          PS              -- peripheral select
-------------------------------------------------------------------------------

entity pselect_mask is

  generic (
    C_AW   : integer                   := 32;
    C_BAR  : std_logic_vector(0 to 31) := "00000000000000100000000000000000";
    C_MASK : std_logic_vector(0 to 31) := "00000000000001111100000000000000"
    );
  port (
    A     : in  std_logic_vector(0 to C_AW-1);
    Valid : in  std_logic;
    CS    : out std_logic
    );

end entity pselect_mask;

-----------------------------------------------------------------------------
-- Architecture section
-----------------------------------------------------------------------------

library unisim;
use unisim.all;

architecture imp of pselect_mask is

--  component LUT4
--    generic(
--      INIT : bit_vector := X"0000"
--      );
--    port (
--      O  : out std_logic;
--      I0 : in  std_logic := '0';
--      I1 : in  std_logic := '0';
--      I2 : in  std_logic := '0';
--      I3 : in  std_logic := '0');
--  end component;

--  component MUXCY is
--    port (
--      O  : out std_logic;
--      CI : in  std_logic;
--      DI : in  std_logic;
--      S  : in  std_logic
--      );
--  end component MUXCY;

  function Nr_Of_Ones (S : std_logic_vector) return natural is
    variable tmp : natural := 0;
  begin  -- function Nr_Of_Ones
    for I in S'range loop
      if (S(I) = '1') then
        tmp := tmp + 1;
      end if;
    end loop;  -- I
    return tmp;
  end function Nr_Of_Ones;

  function fix_AB (B : boolean; I : integer) return integer is
  begin  -- function fix_AB
    if (not B) then
      return I + 1;
    else
      return I;
    end if;
  end function fix_AB;

  constant Nr      : integer := Nr_Of_Ones(C_MASK);
  constant Use_CIN : boolean := ((Nr mod 4) = 0);
  constant AB      : integer := fix_AB(Use_CIN, Nr);
  
  attribute INIT : string;

  constant NUM_LUTS    : integer := (AB-1)/4+1;
--   signal   lut_out     : std_logic_vector(0 to NUM_LUTS-1);
--   signal   carry_chain : std_logic_vector(0 to NUM_LUTS);

  -- function to initialize LUT within pselect 
  type int4 is array (3 downto 0) of integer;
  function pselect_init_lut(i        : integer;
                            AB       : integer;
                            NUM_LUTS : integer;
                            C_AW     : integer;
                            C_BAR    : std_logic_vector(0 to 31)) 
    return bit_vector is
    variable init_vector : bit_vector(15 downto 0) := X"0001";
    variable j           : integer                 := 0;
    variable val_in      : int4;
  begin
    for j in 0 to 3 loop
      if i < NUM_LUTS-1 or j <= ((AB-1) mod 4) then
        val_in(j) := conv_integer(C_BAR(i*4+j));
      else val_in(j) := 0;
      end if;
    end loop;
    init_vector := To_bitvector(conv_std_logic_vector(2**(val_in(3)*8+
                                                          val_in(2)*4+val_in(1)*2+val_in(0)*1),16));
    return init_vector;
  end pselect_init_lut;

  signal A_Bus : std_logic_vector(0 to AB);
  signal BAR   : std_logic_vector(0 to AB);

-------------------------------------------------------------------------------
-- Begin architecture section
-------------------------------------------------------------------------------
begin  -- VHDL_RTL

  Make_Busses : process (A,Valid) is
    variable tmp : natural;
  begin  -- process Make_Busses
    tmp   := 0;
    A_Bus <= (others => '0');
    BAR   <= (others => '0');
    for I in C_MASK'range loop
      if (C_MASK(I) = '1') then
        A_Bus(tmp) <= A(I);
        BAR(tmp)   <= C_BAR(I);
        tmp        := tmp + 1;
      end if;
    end loop;  -- I
    if (not Use_CIN) then
      BAR(tmp) <= '1';
      A_Bus(tmp) <= Valid;
    end if;
  end process Make_Busses;


--  More_Than_3_Bits : if (AB > 3) generate

--    Using_CIn: if (Use_CIN) generate
--      carry_chain(0) <= Valid;      
--    end generate Using_CIn;

--    No_CIn: if (not Use_CIN) generate
--      carry_chain(0) <= '1';
--    end generate No_CIn;

--    GEN_DECODE : for i in 0 to NUM_LUTS-1 generate
--      signal lut_in : std_logic_vector(3 downto 0);
--    begin
--      GEN_LUT_INPUTS : for j in 0 to 3 generate
--        -- Generate to assign address bits to LUT4 inputs
--        GEN_INPUT : if i < NUM_LUTS-1 or j <= ((AB-1) mod 4) generate
--          lut_in(j) <= A_Bus(i*4+j);
--        end generate;
--        -- Generate to assign zeros to remaining LUT4 inputs
--        GEN_ZEROS : if not(i < NUM_LUTS-1 or j <= ((AB-1) mod 4)) generate
--          lut_in(j) <= '0';
--        end generate;
--      end generate;

---------------------------------------------------------------------------------
---- RTL version without LUT instantiation for XST
---------------------------------------------------------------------------------

--      lut_out(i) <= (lut_in(0) xnor BAR(i*4+0)) and
--                     (lut_in(1) xnor BAR(i*4+1)) and
--                     (lut_in(2) xnor BAR(i*4+2)) and
--                     (lut_in(3) xnor BAR(i*4+3));

---------------------------------------------------------------------------------
---- Structural version with LUT instantiation for Synplicity (when RLOC is
----  desired for placing LUT
---------------------------------------------------------------------------------

----    LUT4_I : LUT4
----      generic map(
----        -- Function init_lut is used to generate INIT value for LUT4
----        INIT => pselect_init_lut(i,C_AB,NUM_LUTS,C_AW,C_BAR)
----        )
----      port map (
----        O  => lut_out(i),  -- [out]
----        I0 => lut_in(0),   -- [in]
----        I1 => lut_in(1),   -- [in]
----        I2 => lut_in(2),   -- [in]
----        I3 => lut_in(3));  -- [in]

---------------------------------------------------------------------------------

--      MUXCY_I : MUXCY
--        port map (
--          O  => carry_chain(i+1),       --[out]
--          CI => carry_chain(i),         --[in]
--          DI => '0',                    --[in]
--          S  => lut_out(i)              --[in]
--          );    
--    end generate;
--    CS <= carry_chain(NUM_LUTS);        -- assign end of carry chain to output
--  end generate More_Than_3_Bits;

--  Less_than_4_bits: if (AB < 4) generate
    CS <= Valid when A_Bus=BAR else '0';
--  end generate Less_than_4_bits;
end imp;

