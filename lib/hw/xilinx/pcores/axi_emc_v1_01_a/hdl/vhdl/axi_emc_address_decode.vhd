-------------------------------------------------------------------------------
--  emc_emc_address_decoder - entity/architecture pair
-------------------------------------------------------------------------------
--
-- ************************************************************************
-- ** DISCLAIMER OF LIABILITY                                            **
-- **                                                                    **
-- ** This file contains proprietary and confidential information of     **
-- ** Xilinx, Inc. ("Xilinx"), that is distributed under a license       **
-- ** from Xilinx, and may be used, copied and/or disclosed only         **
-- ** pursuant to the terms of a valid license agreement with Xilinx.    **
-- **                                                                    **
-- ** XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION              **
-- ** ("MATERIALS") "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER         **
-- ** EXPRESSED, IMPLIED, OR STATUTORY, INCLUDING WITHOUT                **
-- ** LIMITATION, ANY WARRANTY WITH RESPECT TO NONINFRINGEMENT,          **
-- ** MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE. Xilinx      **
-- ** does not warrant that functions included in the Materials will     **
-- ** meet the requirements of Licensee, or that the operation of the    **
-- ** Materials will be uninterrupted or error-free, or that defects     **
-- ** in the Materials will be corrected. Furthermore, Xilinx does       **
-- ** not warrant or make any representations regarding use, or the      **
-- ** results of the use, of the Materials in terms of correctness,      **
-- ** accuracy, reliability or otherwise.                                **
-- **                                                                    **
-- ** Xilinx products are not designed or intended to be fail-safe,      **
-- ** or for use in any application requiring fail-safe performance,     **
-- ** such as life-support or safety devices or systems, Class III       **
-- ** medical devices, nuclear facilities, applications related to       **
-- ** the deployment of airbags, or any other applications that could    **
-- ** lead to death, personal injury or severe property or               **
-- ** environmental damage (individually and collectively, "critical     **
-- ** applications"). Customer assumes the sole risk and liability       **
-- ** of any use of Xilinx products in critical applications,            **
-- ** subject only to applicable laws and regulations governing          **
-- ** limitations on product liability.                                  **
-- **                                                                    **
-- ** Copyright 1995-2011 Xilinx, Inc.                                   **
-- ** All rights reserved.                                               **
-- **                                                                    **
-- ** This disclaimer and copyright notice must be retained as part      **
-- ** of this file at all times.                                         **
-- ************************************************************************
--
-------------------------------------------------------------------------------
-- Filename:        emc_emc_address_decoder.vhd
-- Version:         v1.01.a
-- Description:     This is the address decoder logic file for axi emc core.
-------------------------------------------------------------------------------
-- Structure:
--              axi_emc.vhd
--                  -- axi_emc_native_interface.vhd
--                     -- axi_emc_addr_gen.vhd
--                     -- axi_emc_address_decode.vhd
--                  -- emc.vhd
--                      -- ipic_if.vhd
--                      -- addr_counter_mux.vhd
--                      -- counters.vhd
--                      -- select_param.vhd
--                      -- mem_state_machine.vhd
--                      -- mem_steer.vhd
--                      -- io_registers.vhd
-------------------------------------------------------------------------------
-- Author:      SK
--
-- History:
--  SK          10/02/10     --  
-- ^^^^^^
--  -- Created the new version v1.01.a
-------------------------------------------------------------------------------
-- Naming Conventions:
--      active low signals:                     "*_n"
--      clock signals:                          "clk", "clk_div#", "clk_#x"
--      reset signals:                          "rst", "rst_n"
--      generics:                               "C_*"
--      user defined types:                     "*_TYPE"
--      state machine next state:               "*_ns"
--      state machine current state:            "*_cs"
--      combinatorial signals:                  "*_cmb"
--      pipelined or register delay signals:    "*_d#"
--      counter signals:                        "*cnt*"
--      clock enable signals:                   "*_ce"
--      internal version of output port         "*_i"
--      device pins:                            "*_pin"
--      ports:                                  - Names begin with Uppercase
--      processes:                              "*_PROCESS"
--      component instantiations:               "<ENTITY_>I_<#|FUNC>
-------------------------------------------------------------------------------
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;
use IEEE.std_logic_misc.or_reduce;

library proc_common_v3_00_a;
use proc_common_v3_00_a.proc_common_pkg.all;
use proc_common_v3_00_a.proc_common_pkg.clog2;
use proc_common_v3_00_a.proc_common_pkg.max2;
use proc_common_v3_00_a.ipif_pkg.all;
use proc_common_v3_00_a.family_support.all;
use proc_common_v3_00_a.counter_f;

entity axi_emc_address_decode is
   generic(
        C_S_AXI_ADDR_WIDTH      : integer range 32 to 32 := 32;
        C_ADDR_DECODE_BITS      : integer;
        C_ARD_ADDR_RANGE_ARRAY  : SLV64_ARRAY_TYPE       :=
        (
          X"0000_0000_1000_0000", -- IP user0 base address
          X"0000_0000_1000_0FFF", -- IP user0 high address

          X"0000_0000_1000_1000", -- IP user1 base address
          X"0000_0000_1000_1FFF"  -- IP user1 high address
        );
        C_ARD_NUM_CE_ARRAY      : INTEGER_ARRAY_TYPE     :=
        (
          0=> 1,         -- User0 CE Number-- only 1 is allowed per addr range
          1=> 1          -- User1 CE Number-- only 1 is allowed per addr range
         );
        C_FAMILY                : string                 := "virtex6"
        );
   port(
        Bus2IP_Clk              : in  std_logic;
        Bus2IP_Resetn           : in  std_logic;

        Enable_CS               : in std_logic;
        Enable_RdCE             : in std_logic;
        Enable_WrCE             : in std_logic;

        Rst_CS                  : in std_logic;
        Rst_Wr_CE               : in std_logic;
        Rst_Rd_CE               : in std_logic;

        Addr_SM_PS_IDLE         : in std_logic;

        Addr_int                : in std_logic_vector
                                     ((C_S_AXI_ADDR_WIDTH-1) downto 0);

        RNW                     : in  std_logic;
	RdFIFO_Space_two_int    : in std_logic;

        Bus2IP_CS               : out std_logic_vector
                              ((((C_ARD_ADDR_RANGE_ARRAY'LENGTH)/2)-1)downto 0);
        Bus2IP_RdCE             : out std_logic_vector
                                  ((calc_num_ce(C_ARD_NUM_CE_ARRAY)-1)downto 0);
        Bus2IP_WrCE             : out std_logic_vector
                                  ((calc_num_ce(C_ARD_NUM_CE_ARRAY)-1)downto 0);
        ORed_cs                 : out std_logic
        );
end entity axi_emc_address_decode;
-------------------------

   ---------------------------
-- architecture section starts
   ---------------------------
architecture imp of axi_emc_address_decode is
--------------------
-- constant declaration
-- Reset Active State
constant ACTIVE_LOW_RESET : std_logic := '0';
------------------------------------

-- local type declarations
   type decode_bit_array_type is Array(natural range 0 to (
                           (C_ARD_ADDR_RANGE_ARRAY'LENGTH)/2)-1) of
                           integer;

   type short_addr_array_type is Array(natural range 0 to
                           C_ARD_ADDR_RANGE_ARRAY'LENGTH-1) of
                           std_logic_vector(0 to(C_ADDR_DECODE_BITS-1));

   ----------------------------------------------------------------------------
-- This function converts a 64 bit address range array to a AWIDTH bit
-- address range array.
   ----------------------------------------------------------------------------
   function slv64_2_slv_awidth(slv64_addr_array   : SLV64_ARRAY_TYPE;
                               awidth             : integer)
                        return short_addr_array_type is

    variable temp_addr   : std_logic_vector(0 to 63);
    variable slv_array   : short_addr_array_type;
    begin
        for array_index in 0 to slv64_addr_array'length-1 loop
            temp_addr := slv64_addr_array(array_index);
            slv_array(array_index) := temp_addr((64-awidth) to 63);
        end loop;
    --coverage off
        return(slv_array);
    --coverage on
   end function slv64_2_slv_awidth;
   ----------------------------------------------------------------------------
   function Addr_Bits (x,y : std_logic_vector(0 to C_ADDR_DECODE_BITS-1))
                    return integer is
    variable addr_nor : std_logic_vector(0 to C_ADDR_DECODE_BITS-1);
    begin
        addr_nor := x xor y;
        for i in 0 to C_ADDR_DECODE_BITS-1 loop
            if addr_nor(i)='1' then
                return i;
            end if;
        end loop;
    --coverage off
        return(C_ADDR_DECODE_BITS);
    --coverage on
   end function Addr_Bits;
   ----------------------------------------------------------------------------
   function Get_Addr_Bits (baseaddrs : short_addr_array_type)
                        return decode_bit_array_type is

   variable num_bits : decode_bit_array_type;
   begin
        for i in 0 to ((baseaddrs'length)/2)-1 loop

            num_bits(i) :=  Addr_Bits (baseaddrs(i*2),
                                       baseaddrs(i*2+1));
        end loop;
    --coverage off
        return(num_bits);
    --coverage on
   end function Get_Addr_Bits;
   ----------------------------------------------------------------------------
-- NEEDED_ADDR_BITS
-- Function Description:
-- This function calculates the number of address bits required
-- to support the CE generation logic. This is determined by
-- multiplying the number of CEs for an address space by the
-- data width of the address space (in bytes). Each address
-- space entry is processed and the biggest of the spaces is
-- used to set the number of address bits required to be latched
-- and used for CE decoding. A minimum value of 1 is returned by
-- this function.
   ----------------------------------------------------------------------------
   function needed_addr_bits (ce_array   : INTEGER_ARRAY_TYPE)
                            return integer is

   constant NUM_CE_ENTRIES     : integer := ce_array'length;
   variable biggest            : integer := 2;
   variable req_ce_addr_size   : integer := 0;
   variable num_addr_bits      : integer := 0;
   begin
        for i in 0 to NUM_CE_ENTRIES-1 loop
            req_ce_addr_size := ce_array(i) * 4;
            if (req_ce_addr_size > biggest) Then
                biggest := req_ce_addr_size;
            end if;
        end loop;
        num_addr_bits := clog2(biggest);
    --coverage off
        return(num_addr_bits);
    --coverage on
   end function NEEDED_ADDR_BITS;
   ----------------------------------------------------------------------------
-- Function calc_start_ce_index
--
-- This function is used to process the array specifying the number of Chip
-- Enables required for a Base Address specification. The CE Size array is
-- input to the function and an integer index representing the index of the
-- target module in the ce_num_array. An integer is returned reflecting the
-- starting index of the assigned Chip Enables within the CE, RdCE, and
-- WrCE Buses.
   ----------------------------------------------------------------------------
   function calc_start_ce_index (ce_num_array : INTEGER_ARRAY_TYPE;
                               index        : integer) return integer is
   Variable ce_num_sum : integer := 0;
   begin
        If (index = 0) Then
             ce_num_sum := 0;
        else
             for i in 0 to index-1 loop
                  ce_num_sum := ce_num_sum + ce_num_array(i);
             End loop;
        End if;
    --coverage off
   return(ce_num_sum);
    --coverage on
   end function calc_start_ce_index;
------------------------
-- Constant Declarations
------------------------
-- convert 64 bit address array into 32 bit address array
   constant ARD_ADDR_RANGE_ARRAY : short_addr_array_type :=
                                   slv64_2_slv_awidth(C_ARD_ADDR_RANGE_ARRAY,
                                                      C_ADDR_DECODE_BITS);
-- get the number of address pairs given in the ARD ADDR RANGE array
   constant NUM_BASE_ADDRS       : integer :=(C_ARD_ADDR_RANGE_ARRAY'length)/2;
-- 1 decode for 1 address pair from ARD ADDRESS RANGE array, by this
-- get total decode bits
   constant DECODE_BITS          : decode_bit_array_type :=
                                    Get_Addr_Bits(ARD_ADDR_RANGE_ARRAY);

   constant NUM_CE_SIGNALS       : integer :=
                                    calc_num_ce(C_ARD_NUM_CE_ARRAY);
   constant NUM_S_H_ADDR_BITS    : integer :=
                                    needed_addr_bits(C_ARD_NUM_CE_ARRAY);
----------------------
-- Signal Declarations
----------------------
   signal pselect_hit_i    : std_logic_vector
                            (0 to ((C_ARD_ADDR_RANGE_ARRAY'LENGTH)/2)-1);

   signal int_pselect      : std_logic_vector
                            (0 to ((C_ARD_ADDR_RANGE_ARRAY'LENGTH)/2)-1);

   signal CE_reg           : std_logic_vector
                            (0 to (NUM_CE_SIGNALS-1));

   signal pselect_hit_reg  : std_logic_vector
                            (0 to (NUM_CE_SIGNALS-1));

   signal cs_out_i         : std_logic_vector
                            (0 to ((C_ARD_ADDR_RANGE_ARRAY'LENGTH)/2)-1);
   signal ce_expnd_i       : std_logic_vector(0 to NUM_CE_SIGNALS-1);
   signal rdce_out_i       : std_logic_vector(0 to NUM_CE_SIGNALS-1);
   signal wrce_out_i       : std_logic_vector(0 to NUM_CE_SIGNALS-1);
   signal wrce_clear_int   : std_logic;
   signal rdce_clear_int   : std_logic;

   signal ored_ce_int      : std_logic;
   signal decode_addr_int  : std_logic_vector(0 to C_ADDR_DECODE_BITS-1);

   signal cs_reg           : std_logic_vector
                            (0 to ((C_ARD_ADDR_RANGE_ARRAY'LENGTH)/2)-1)
                           :=(others => '0');
   signal cs_clear_int     : std_logic;
----------------------
begin -- architecture imp
----------------------
   decode_addr_int <= Addr_int((C_ADDR_DECODE_BITS-1) downto 0);

   wrce_clear_int  <= not(Bus2IP_Resetn) or Rst_Wr_CE;
   rdce_clear_int  <= not(Bus2IP_Resetn) or Rst_Rd_CE;
   cs_clear_int    <= not(Bus2IP_Resetn) or Rst_CS;
---------------------------------
-- Universal Address Decode Block
---------------------------------
   MEM_DECODE_GEN: for bar_index in 0 to NUM_BASE_ADDRS-1 generate
-- get the individual number of CE's
   constant CE_INDEX_START : integer
                        := calc_start_ce_index(C_ARD_NUM_CE_ARRAY,bar_index);
   constant CE_ADDR_SIZE: Integer --range 0 to 15
                        := clog2(C_ARD_NUM_CE_ARRAY(bar_index));
   constant OFFSET      : integer := 2;
   signal temp_avalid : std_logic;
   ------
   begin
   ------
    temp_avalid <= (Addr_SM_PS_IDLE and (Enable_CS));-- or S_AXI_MEM_AWVALID));
         ------------------------------
      -- generate multiple chip selects
         ------------------------------
      MULTI_CS_GEN : if C_ARD_ADDR_RANGE_ARRAY'length > 2 generate
          -- Instantiate the basic Base Address Decoders
          MEM_SELECT_I: entity proc_common_v3_00_a.pselect_f
              generic map
              (
                  C_AB     => DECODE_BITS(bar_index),
                  C_AW     => C_ADDR_DECODE_BITS,
                  C_BAR    => ARD_ADDR_RANGE_ARRAY(bar_index*2),
                  C_FAMILY => C_FAMILY
              )
              port map
              (
                  A        => decode_addr_int,              -- [in]
                  AValid   => temp_avalid,                  -- [in]
                  CS       => pselect_hit_i(bar_index)      -- [out]
              );
      end generate MULTI_CS_GEN;

      ONE_CS_GEN : if C_ARD_ADDR_RANGE_ARRAY'length = 2 generate
          pselect_hit_i(bar_index) <= Addr_SM_PS_IDLE;
      end generate ONE_CS_GEN;

      --------
      -- CS_REG_P:-- register Bus2IP_CS signals
      --------
      CS_REG_P : process(Bus2IP_Clk)
      begin
        if(Bus2IP_Clk'EVENT and Bus2IP_Clk = '1')then
            if(Addr_SM_PS_IDLE='1')then
                cs_reg(bar_index) <= pselect_hit_i(bar_index);
            end if;
        end if;
      end process CS_REG_P;
      --------
      -- CS_OUT_P:-- register Bus2IP_CS signals
      --------
      CS_OUT_P : process(Bus2IP_Clk)
      begin
        if(Bus2IP_Clk'EVENT and Bus2IP_Clk = '1')then
	    if(cs_clear_int='1')then
                cs_out_i(bar_index) <= '0';
            elsif((Addr_SM_PS_IDLE='1') and (Enable_CS='1'))then
                cs_out_i(bar_index) <= pselect_hit_i(bar_index);
            end if;
        end if;
      end process CS_OUT_P;
      --------------
      -- RDCE_REG_P: Register RdCE signal generation logic
      --------------
      RDCE_REG_P: process(Bus2IP_Clk)
      begin
        if(Bus2IP_Clk'EVENT and Bus2IP_Clk = '1')then
           if(rdce_clear_int='1') then
              rdce_out_i(bar_index) <= '0';
           elsif((Addr_SM_PS_IDLE='1') and 
	         (RNW='1')             and 
		 (Enable_CS='1')
		 )then
              rdce_out_i(bar_index) <= pselect_hit_i(bar_index);
           elsif(Enable_RdCE='1')then
              rdce_out_i(bar_index) <= cs_reg(bar_index);
           end if;
        end if;
      end process RDCE_REG_P;
      ---------------
      -- WRCE_REG_P: Register WrCE signal generation logic
      ---------------
      WRCE_REG_P: process(Bus2IP_Clk)
      begin
        if(Bus2IP_Clk'EVENT and Bus2IP_Clk = '1')then
           if(wrce_clear_int='1') then
              wrce_out_i(bar_index) <= '0';
           elsif((Addr_SM_PS_IDLE='1') and 
	         (RNW='0')             and 
		 (Enable_CS='1')
                )then
              wrce_out_i(bar_index) <= pselect_hit_i(bar_index);
           elsif(Enable_WrCE='1')then
              wrce_out_i(bar_index) <= cs_reg(bar_index);
           end if;
        end if;
      end process WRCE_REG_P;

 end generate MEM_DECODE_GEN;
-----------------------------
-- Assign registered output signals
BUS2IP_CS_GEN: for i in 0 to (NUM_BASE_ADDRS-1) generate
        Bus2IP_CS(i)       <= cs_out_i(i);
end generate BUS2IP_CS_GEN;
-----------------------------
BUS2IP_RDCE_GEN: for i in 0 to (NUM_BASE_ADDRS-1) generate
        Bus2IP_RdCE(i)     <= rdce_out_i(i)   and 
	                      (not Rst_Rd_CE) and 
			      RdFIFO_Space_two_int;
end generate BUS2IP_RDCE_GEN;
-----------------------------
BUS2IP_WRCE_GEN: for i in 0 to (NUM_BASE_ADDRS-1) generate
        Bus2IP_WrCE(i)     <= wrce_out_i(i);
end generate BUS2IP_WRCE_GEN;
-----------------------------
ored_ce_int <= or_reduce(rdce_out_i) when (RNW='1')
               else
               or_reduce(wrce_out_i);

  ORed_cs   <= or_reduce(cs_out_i);

end architecture imp;
