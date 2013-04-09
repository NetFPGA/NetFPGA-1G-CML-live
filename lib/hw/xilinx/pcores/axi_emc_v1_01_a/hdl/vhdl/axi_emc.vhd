-------------------------------------------------------------------------------
-- $Id: axi_emc.vhd 
-------------------------------------------------------------------------------
-- axi_emc.vhd - Entity and architecture
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
--
-------------------------------------------------------------------------------
-- Filename:        axi_emc.vhd
-- Version:         v1.01.a
-- Description:     This is the top-level design file for the AXI External
--                  Memory Controller.
--
-- VHDL-Standard:   VHDL'93
-------------------------------------------------------------------------------
-- Structure:
--
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
-- History:
-- ~~~~~~
--  SK 10/02/10  -- created v1.01.a version    
-- ^^^^^^
-- 1. Replaced the AXI Lite IPIF interface with AXI4 lite native interface
-- 2. Replaced the AXI Slave Burst interface with AXI4 full native interface
-- 3. Reduced the core utilization to resolve CR 573074
-- ~~~~~~
--  SK 12/02/10 
-- ^^^^^^
-- 1. Added NO_REG_EN_GEN section to drive all the output signals in the register
--    interface to '0' when not selected.
-- ~~~~~~
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.conv_std_logic_vector;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_misc.all;
-- library unsigned is used for overloading of "=" which allows integer to
-- be compared to std_logic_vector
use ieee.std_logic_unsigned.all;


library proc_common_v3_00_a;
use proc_common_v3_00_a.proc_common_pkg.all;
use proc_common_v3_00_a.ipif_pkg.all;
use proc_common_v3_00_a.family.all;
use proc_common_v3_00_a.all;

library emc_common_v5_01_a;
    use emc_common_v5_01_a.all;

library axi_emc_v1_01_a;
    use axi_emc_v1_01_a.all;

-------------------------------------------------------------------------------
-- Port Declaration
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Definition of Generics:
--
--  C_NUM_BANKS_MEM                 -- Number of memory banks
--  C_MEM0_TYPE                     -- Type of Memory
--                                      0-> Sync SRAM
--                                      1-> Async SRAM
--                                      2-> Nor Flash
--                                      3-> Page Mode Nor Flash
--                                      4-> Cellar RAM/PSRAM
--  C_PARITY_TYPE_MEM_0             -- Type of Parity
--                                      0-> No Parity
--                                      1-> Odd Parity
--                                      2-> Even Parity
--  C_INCLUDE_NEGEDGE_IOREGS        -- Include negative edge IO registers
--  C_NUM_MASTERS                   -- Number of axi masters
--  C_MEM(0:3)_BASEADDR             -- Memory bank (0:3) base address
--  C_MEM(0:3)_HIGHADDR             -- Memory bank (0:3) high address
--  C_MEM(0:3)_WIDTH                -- Memory bank (0:3) data width
--  C_MAX_MEM_WIDTH                 -- Maximum data width of all memory banks
--
--  C_INCLUDE_DATAWIDTH_MATCHING_(0:3) --  Support data width matching for
--                                          memory bank (0:3)
--  C_SYNCH_MEM_(0:3)               -- Memory bank (0:3) type
--  C_SYNCH_PIPEDELAY_(0:3)         -- Memory bank (0:3) synchronous pipedelay
--  C_TCEDV_PS_MEM_(0:3)            -- Chip Enable to Data Valid Time
--                                  -- (Maximum of TCEDV and TAVDV applied
--                                     as read cycle start to first data valid)
--  C_TAVDV_PS_MEM_(0:3)            -- Address Valid to Data Valid Time
--                                  -- (Maximum of TCEDV and TAVDV applied
--                                     as read cycle start to first data valid)
--  C_THZCE_PS_MEM_(0:3)            -- Chip Enable High to Data Bus High
--                                     Impedance (Maximum of THZCE and THZOE
--                                     applied as Read Recovery before Write)
--  C_THZOE_PS_MEM_(0:3)            -- Output Enable High to Data Bus High
--                                     Impedance (Maximum of THZCE and THZOE
--                                     applied as Read Recovery before Write)
--  C_TWC_PS_MEM_(0:3)              -- Write Cycle Time
--                                     (Maximum of TWC and TWP applied as write
--                                     enable pulse width)
--  C_TWP_PS_MEM_(0:3)              -- Write Enable Minimum Pulse Width
--                                     (Maximum of TWC and TWP applied as write
--                                     enable pulse width)
--  C_TLZWE_PS_MEM_(0:3)            -- Write Enable High to Data Bus Low
--                                     Impedance (Applied as Write Recovery
--                                     before Read)
--  C_S_AXI_MEM_DWIDTH              --  axi Data Bus Width
--  C_S_AXI_MEM_AWIDTH              --  axi Address Width
--  C_AXI_CLK_PERIOD_PS             --  axi clock period to calculate wait
--                                         state pulse widths.
--
--
-- Definition of Ports:
-- Memory Signals
--  Mem_A                  -- Memory address inputs
--  Mem_DQ_I               -- Memory Input Data Bus
--  Mem_DQ_O               -- Memory Output Data Bus
--  Mem_DQ_T               -- Memory Data Output Enable
--  MEM_DQ_PARITY_I        -- Memory Parity Input Data Bus
--  MEM_DQ_PARITY_O        -- Memory Parity Output Data Bus
--  MEM_DQ_PARITY_T        -- Memory Parity Output Enable
--  Mem_CEN                -- Memory Chip Select
--  Mem_OEN                -- Memory Output Enable
--  Mem_WEN                -- Memory Write Enable
--  Mem_QWEN               -- Memory Qualified Write Enable
--  Mem_BEN                -- Memory Byte Enables
--  Mem_RPN                -- Memory Reset/Power Down
--  Mem_CE                 -- Memory chip enable
--  Mem_ADV_LDN            -- Memory counter advance/load (=0)
--  Mem_LBON               -- Memory linear/interleaved burst order (=0)
--  Mem_CKEN               -- Memory clock enable (=0)
--  Mem_RNW                -- Memory read not write
-------------------------------------------------------------------------------

entity axi_emc is
   -- Generics to be set by user
    generic (

        C_FAMILY                       : string := "virtex6";
        C_AXI_CLK_PERIOD_PS            : integer := 10000;

        ---- AXI REG Parameters
        C_S_AXI_REG_ADDR_WIDTH         : integer range 32 to 32 := 32;
        C_S_AXI_REG_DATA_WIDTH         : integer range 32 to 32 := 32;

        C_S_AXI_EN_REG                 : integer range 0 to 1   := 0;

        C_S_AXI_REG_BASEADDR           : std_logic_vector := x"FFFFFFFF";
        C_S_AXI_REG_HIGHADDR           : std_logic_vector := x"00000000";

        ---- AXI MEM Parameters
        C_S_AXI_MEM_ADDR_WIDTH         : integer range 32 to 32 := 32;
        C_S_AXI_MEM_DATA_WIDTH         : integer                := 32;--8,16,32,64
        C_S_AXI_MEM_ID_WIDTH           : integer range 1  to 16 := 4;

        C_S_AXI_MEM0_BASEADDR          : std_logic_vector := x"FFFFFFFF";
        C_S_AXI_MEM0_HIGHADDR          : std_logic_vector := x"00000000";
        C_S_AXI_MEM1_BASEADDR          : std_logic_vector := x"FFFFFFFF";
        C_S_AXI_MEM1_HIGHADDR          : std_logic_vector := x"00000000";
        C_S_AXI_MEM2_BASEADDR          : std_logic_vector := x"FFFFFFFF";
        C_S_AXI_MEM2_HIGHADDR          : std_logic_vector := x"00000000";
        C_S_AXI_MEM3_BASEADDR          : std_logic_vector := x"FFFFFFFF";
        C_S_AXI_MEM3_HIGHADDR          : std_logic_vector := x"00000000";

        -- EMC generics
        C_INCLUDE_NEGEDGE_IOREGS       : integer range 0 to 1   := 0;
        
        C_NUM_BANKS_MEM                : integer range 1 to 4   := 1;

        C_MEM0_TYPE                    : integer range 0 to 4  := 0;
        C_MEM1_TYPE                    : integer range 0 to 4  := 0;
        C_MEM2_TYPE                    : integer range 0 to 4  := 0;
        C_MEM3_TYPE                    : integer range 0 to 4  := 0;

        C_MEM0_WIDTH                   : integer := 32;--8,16,32,64 allowed
        C_MEM1_WIDTH                   : integer := 32;--8,16,32,64
        C_MEM2_WIDTH                   : integer := 32;--8,16,32,64
        C_MEM3_WIDTH                   : integer := 32;--8,16,32,64

        C_MAX_MEM_WIDTH                : integer := 32;--8,16,32,64

        -- parity type of memory 0-no parity, 1-odd parity, 2-even parity
        C_PARITY_TYPE_MEM_0            : integer range 0 to 2  := 0;
        C_PARITY_TYPE_MEM_1            : integer range 0 to 2  := 0;
        C_PARITY_TYPE_MEM_2            : integer range 0 to 2  := 0;
        C_PARITY_TYPE_MEM_3            : integer range 0 to 2  := 0;

        C_INCLUDE_DATAWIDTH_MATCHING_0 : integer range 0 to 1   := 0;
        C_INCLUDE_DATAWIDTH_MATCHING_1 : integer range 0 to 1   := 0;
        C_INCLUDE_DATAWIDTH_MATCHING_2 : integer range 0 to 1   := 0;
        C_INCLUDE_DATAWIDTH_MATCHING_3 : integer range 0 to 1   := 0;

        -- Memory read and write access times for all memory banks

        C_SYNCH_PIPEDELAY_0            : integer range 1 to 2   := 2;
        C_TCEDV_PS_MEM_0               : integer := 15000;
        C_TAVDV_PS_MEM_0               : integer := 15000;
        C_TPACC_PS_FLASH_0             : integer := 25000;
        C_THZCE_PS_MEM_0               : integer := 7000;
        C_THZOE_PS_MEM_0               : integer := 7000;
        C_TWC_PS_MEM_0                 : integer := 15000;
        C_TWP_PS_MEM_0                 : integer := 12000;
        C_TWPH_PS_MEM_0                : integer := 12000;
        C_TLZWE_PS_MEM_0               : integer := 0;

        C_SYNCH_PIPEDELAY_1            : integer range 1 to 2   := 2;
        C_TCEDV_PS_MEM_1               : integer := 15000;
        C_TAVDV_PS_MEM_1               : integer := 15000;
        C_TPACC_PS_FLASH_1             : integer := 25000;
        C_THZCE_PS_MEM_1               : integer := 7000;
        C_THZOE_PS_MEM_1               : integer := 7000;
        C_TWC_PS_MEM_1                 : integer := 15000;
        C_TWP_PS_MEM_1                 : integer := 12000;
        C_TWPH_PS_MEM_1                : integer := 12000;
        C_TLZWE_PS_MEM_1               : integer := 0;

        C_SYNCH_PIPEDELAY_2            : integer range 1 to 2   := 2;
        C_TCEDV_PS_MEM_2               : integer := 15000;
        C_TAVDV_PS_MEM_2               : integer := 15000;
        C_TPACC_PS_FLASH_2             : integer := 25000;
        C_THZCE_PS_MEM_2               : integer := 7000;
        C_THZOE_PS_MEM_2               : integer := 7000;
        C_TWC_PS_MEM_2                 : integer := 15000;
        C_TWP_PS_MEM_2                 : integer := 12000;
        C_TWPH_PS_MEM_2                : integer := 12000;
        C_TLZWE_PS_MEM_2               : integer := 0;

        C_SYNCH_PIPEDELAY_3            : integer range 1 to 2   := 2;
        C_TCEDV_PS_MEM_3               : integer := 15000;
        C_TAVDV_PS_MEM_3               : integer := 15000;
        C_TPACC_PS_FLASH_3             : integer := 25000;
        C_THZCE_PS_MEM_3               : integer := 7000;
        C_THZOE_PS_MEM_3               : integer := 7000;
        C_TWC_PS_MEM_3                 : integer := 15000;
        C_TWP_PS_MEM_3                 : integer := 12000;
        C_TWPH_PS_MEM_3                : integer := 12000;
        C_TLZWE_PS_MEM_3               : integer := 0

    );
    port (
--  -- AXI Slave signals ------------------------------------------------------
    -- AXI Global System Signals
    S_AXI_ACLK          : in  std_logic;
    S_AXI_ARESETN       : in  std_logic;
    RdClk               : in std_logic;

    -- AXI Lite Interface
--  -- AXI Write Address Channel Signals
    S_AXI_REG_AWADDR  : in  std_logic_vector
                            ((C_S_AXI_REG_ADDR_WIDTH-1) downto 0);
    S_AXI_REG_AWVALID : in  std_logic;
    S_AXI_REG_AWREADY : out std_logic;

--  -- AXI Write Channel Signals
    S_AXI_REG_WDATA   : in  std_logic_vector
                            ((C_S_AXI_REG_DATA_WIDTH-1) downto 0);
    S_AXI_REG_WSTRB   : in  std_logic_vector
                            (((C_S_AXI_REG_DATA_WIDTH/8)-1) downto 0);
    S_AXI_REG_WVALID  : in  std_logic;
    S_AXI_REG_WREADY  : out std_logic;

--  -- AXI Write Response Channel Signals
    S_AXI_REG_BRESP   : out std_logic_vector(1 downto 0);
    S_AXI_REG_BVALID  : out std_logic;
    S_AXI_REG_BREADY  : in  std_logic;
--  -- AXI Read Address Channel Signals
    S_AXI_REG_ARADDR  : in  std_logic_vector
                            ((C_S_AXI_REG_ADDR_WIDTH-1) downto 0);
    S_AXI_REG_ARVALID : in  std_logic;
    S_AXI_REG_ARREADY : out std_logic;
--   -- AXI Read Data Channel Signals
    S_AXI_REG_RDATA   : out std_logic_vector
                            ((C_S_AXI_REG_DATA_WIDTH-1) downto 0);
    S_AXI_REG_RRESP   : out std_logic_vector(1 downto 0);
    S_AXI_REG_RVALID  : out std_logic;
    S_AXI_REG_RREADY  : in  std_logic;

--  -- AXI Full Interface
--  -- AXI Write Address Channel Signals
    S_AXI_MEM_AWID    : in  std_logic_vector((C_S_AXI_MEM_ID_WIDTH-1)
                                                                downto 0);
    S_AXI_MEM_AWADDR  : in  std_logic_vector((C_S_AXI_MEM_ADDR_WIDTH-1)
                                                                downto 0);
    S_AXI_MEM_AWLEN   : in  std_logic_vector(7 downto 0);
    S_AXI_MEM_AWSIZE  : in  std_logic_vector(2 downto 0);
    S_AXI_MEM_AWBURST : in  std_logic_vector(1 downto 0);
    S_AXI_MEM_AWLOCK  : in  std_logic;
    S_AXI_MEM_AWCACHE : in  std_logic_vector(3 downto 0);
    S_AXI_MEM_AWPROT  : in  std_logic_vector(2 downto 0);
    S_AXI_MEM_AWVALID : in  std_logic;
    S_AXI_MEM_AWREADY : out std_logic;
--  -- AXI Write Channel Signals
    S_AXI_MEM_WDATA   : in  std_logic_vector((C_S_AXI_MEM_DATA_WIDTH-1)
                                                                downto 0);
    S_AXI_MEM_WSTRB   : in  std_logic_vector
                            (((C_S_AXI_MEM_DATA_WIDTH/8)-1) downto 0);
    S_AXI_MEM_WLAST   : in  std_logic;
    S_AXI_MEM_WVALID  : in  std_logic;
    S_AXI_MEM_WREADY  : out std_logic;
--  -- AXI Write Response Channel Signals
    S_AXI_MEM_BID     : out std_logic_vector((C_S_AXI_MEM_ID_WIDTH-1)
                                                                downto 0);
    S_AXI_MEM_BRESP   : out std_logic_vector(1 downto 0);
    S_AXI_MEM_BVALID  : out std_logic;
    S_AXI_MEM_BREADY  : in  std_logic;
--  -- AXI Read Address Channel Signals
    S_AXI_MEM_ARID    : in  std_logic_vector((C_S_AXI_MEM_ID_WIDTH-1) downto 0);
    S_AXI_MEM_ARADDR  : in  std_logic_vector((C_S_AXI_MEM_ADDR_WIDTH-1) downto 0);
    S_AXI_MEM_ARLEN   : in  std_logic_vector(7 downto 0);
    S_AXI_MEM_ARSIZE  : in  std_logic_vector(2 downto 0);
    S_AXI_MEM_ARBURST : in  std_logic_vector(1 downto 0);
    S_AXI_MEM_ARLOCK  : in  std_logic;
    S_AXI_MEM_ARCACHE : in  std_logic_vector(3 downto 0);
    S_AXI_MEM_ARPROT  : in  std_logic_vector(2 downto 0);
    S_AXI_MEM_ARVALID : in  std_logic;
    S_AXI_MEM_ARREADY : out std_logic;

--   -- AXI Read Data Channel Signals
    S_AXI_MEM_RID     : out std_logic_vector((C_S_AXI_MEM_ID_WIDTH-1)
                                                                downto 0);
    S_AXI_MEM_RDATA   : out std_logic_vector((C_S_AXI_MEM_DATA_WIDTH-1)
                                                                downto 0);
    S_AXI_MEM_RRESP   : out std_logic_vector(1 downto 0);
    S_AXI_MEM_RLAST   : out std_logic;
    S_AXI_MEM_RVALID  : out std_logic;
    S_AXI_MEM_RREADY  : in  std_logic;


    -- Memory signals
    Mem_DQ_I          : in  std_logic_vector((C_MAX_MEM_WIDTH-1) downto 0);
    Mem_DQ_O          : out std_logic_vector((C_MAX_MEM_WIDTH-1) downto 0);
    Mem_DQ_T          : out std_logic_vector((C_MAX_MEM_WIDTH-1) downto 0);

    MEM_DQ_PARITY_I   : in  std_logic_vector(((C_MAX_MEM_WIDTH/8)-1) downto 0);
    MEM_DQ_PARITY_O   : out std_logic_vector(((C_MAX_MEM_WIDTH/8)-1) downto 0);
    MEM_DQ_PARITY_T   : out std_logic_vector(((C_MAX_MEM_WIDTH/8)-1) downto 0);

    Mem_A             : out std_logic_vector((C_S_AXI_MEM_ADDR_WIDTH-1) downto 0);
    -- chip selects
    Mem_CE            : out std_logic_vector((C_NUM_BANKS_MEM-1) downto 0);
    Mem_CEN           : out std_logic_vector((C_NUM_BANKS_MEM-1) downto 0);
    -- read enable
    Mem_OEN           : out std_logic_vector((C_NUM_BANKS_MEM-1) downto 0);
    -- write enable
    Mem_WEN           : out std_logic;-- write enable
    -- byte enables
    Mem_BEN           : out std_logic_vector((C_MAX_MEM_WIDTH/8-1) downto 0);
    Mem_QWEN          : out std_logic_vector((C_MAX_MEM_WIDTH/8-1) downto 0);
    -- reset or power down
    Mem_RPN           : out std_logic;
    -- address valid active low
    Mem_ADV_LDN       : out std_logic;
    -- interleaved burst order
    Mem_LBON          : out std_logic;
    -- clock enable
    Mem_CKEN          : out std_logic;
    -- synch mem read not write signal
    Mem_RNW           : out std_logic;
    --
    Mem_CRE           : out std_logic
    );

     -- Fan-out attributes for XST
     attribute MAX_FANOUT                             : string;
     attribute MAX_FANOUT of S_AXI_ACLK               : signal is "10000";
     attribute MAX_FANOUT of S_AXI_ARESETN            : signal is "10000";
     attribute MAX_FANOUT of RdClk                    : signal is "10000";

     -- Added attribute to FIX CR CR204317. The following attribute prevent
     -- the tools from optimizing the tristate control down to a single
     -- registered signal and to pack input, output, and tri-state registers
     -- into the IOB.

     attribute EQUIVALENT_REGISTER_REMOVAL            : string;
     attribute EQUIVALENT_REGISTER_REMOVAL of Mem_DQ_T: signal is "no";
     attribute EQUIVALENT_REGISTER_REMOVAL of MEM_DQ_PARITY_T: signal is "no";


     attribute IOB                                    : string;
     attribute IOB of Mem_DQ_T                        : signal is "true";
     attribute IOB of Mem_DQ_I                        : signal is "true";
     attribute IOB of Mem_DQ_O                        : signal is "true";

     attribute IOB of MEM_DQ_PARITY_I                 : signal is "true";
     attribute IOB of MEM_DQ_PARITY_O                 : signal is "true";
     attribute IOB of MEM_DQ_PARITY_T                 : signal is "true";

     -- SIGIS attribute for specifying clocks,interrrupts,resets for EDK
     attribute SIGIS                                  : string;
     attribute SIGIS of S_AXI_ACLK                    : signal is "Clk" ;
     attribute SIGIS of S_AXI_ARESETN                 : signal is "Rst" ;
     attribute SIGIS of RdClk                         : signal is "Clk" ;

     -- Minimum size attribute for EDK
     attribute MIN_SIZE                               : string;
     attribute MIN_SIZE of C_S_AXI_MEM0_BASEADDR      : constant is "0x08";
     attribute MIN_SIZE of C_S_AXI_MEM1_BASEADDR      : constant is "0x08";
     attribute MIN_SIZE of C_S_AXI_MEM2_BASEADDR      : constant is "0x08";
     attribute MIN_SIZE of C_S_AXI_MEM3_BASEADDR      : constant is "0x08";

    -- Assignment attribute for EDK
    attribute ASSIGNMENT                             : string;
    attribute ASSIGNMENT of C_S_AXI_MEM0_BASEADDR    : constant is "REQUIRE";
    attribute ASSIGNMENT of C_S_AXI_MEM0_HIGHADDR    : constant is "REQUIRE";
    attribute ASSIGNMENT of C_S_AXI_MEM1_BASEADDR    : constant is "REQUIRE";
    attribute ASSIGNMENT of C_S_AXI_MEM1_HIGHADDR    : constant is "REQUIRE";
    attribute ASSIGNMENT of C_S_AXI_MEM2_BASEADDR    : constant is "REQUIRE";
    attribute ASSIGNMENT of C_S_AXI_MEM2_HIGHADDR    : constant is "REQUIRE";
    attribute ASSIGNMENT of C_S_AXI_MEM3_BASEADDR    : constant is "REQUIRE";
    attribute ASSIGNMENT of C_S_AXI_MEM3_HIGHADDR    : constant is "REQUIRE";
    attribute ASSIGNMENT of C_S_AXI_MEM_ADDR_WIDTH   : constant is "CONSTANT";

    -- ADDR_TYPE attribute for EDK
    attribute ADDR_TYPE                              : string;
    attribute ADDR_TYPE of C_S_AXI_MEM0_BASEADDR     : constant is "MEMORY";
    attribute ADDR_TYPE of C_S_AXI_MEM0_HIGHADDR     : constant is "MEMORY";
    attribute ADDR_TYPE of C_S_AXI_MEM1_BASEADDR     : constant is "MEMORY";
    attribute ADDR_TYPE of C_S_AXI_MEM1_HIGHADDR     : constant is "MEMORY";
    attribute ADDR_TYPE of C_S_AXI_MEM2_BASEADDR     : constant is "MEMORY";
    attribute ADDR_TYPE of C_S_AXI_MEM2_HIGHADDR     : constant is "MEMORY";
    attribute ADDR_TYPE of C_S_AXI_MEM3_BASEADDR     : constant is "MEMORY";
    attribute ADDR_TYPE of C_S_AXI_MEM3_HIGHADDR     : constant is "MEMORY";

 ------------------------------------------------------------------------------
 -- end of PSFUtil MPD attributes
 ------------------------------------------------------------------------------
end axi_emc;

-------------------------------------------------------------------------------
-- Architecture
-------------------------------------------------------------------------------
architecture implementation of axi_emc is

-------------------------------------------------------------------------------
-- Constant Declarations
-------------------------------------------------------------------------------

-- addresses for axi_slave_burst are  64-bits wide - create constants to
-- zero the most significant address bits
constant ZERO_ADDR_PAD  : std_logic_vector(0 to 64-C_S_AXI_MEM_ADDR_WIDTH-1)
                        := (others => '0');

-- four banks with SRAM, ASYNC SRAM, PSRAM, Cellular RAM, Flash memory
type MEM_TYPE_ARRAY_TYPE is array (0 to 3) of integer range 0 to 4;

type MEM_PARITY_ARRAY_TYPE is array (0 to 3) of integer range 0 to 2;
-----------------------------------------------------------------------------
-- Function: get_AXI_ARD_ADDR_RANGE_ARRAY
-- Purpose: Fill AXI_ARD_ADDR_RANGE_ARRAY based on input parameters
-----------------------------------------------------------------------------
function get_AXI_ARD_ADDR_RANGE_ARRAY return SLV64_ARRAY_TYPE is
variable axi_ard_addr_range_array_v : SLV64_ARRAY_TYPE
                                        (0 to C_NUM_BANKS_MEM*2-1);
begin
    if (C_NUM_BANKS_MEM = 1) then
       axi_ard_addr_range_array_v(0) := ZERO_ADDR_PAD&C_S_AXI_MEM0_BASEADDR;
       axi_ard_addr_range_array_v(1) := ZERO_ADDR_PAD&C_S_AXI_MEM0_HIGHADDR;
    elsif (C_NUM_BANKS_MEM = 2) then
       axi_ard_addr_range_array_v(0) := ZERO_ADDR_PAD&C_S_AXI_MEM0_BASEADDR;
       axi_ard_addr_range_array_v(1) := ZERO_ADDR_PAD&C_S_AXI_MEM0_HIGHADDR;
       axi_ard_addr_range_array_v(2) := ZERO_ADDR_PAD&C_S_AXI_MEM1_BASEADDR;
       axi_ard_addr_range_array_v(3) := ZERO_ADDR_PAD&C_S_AXI_MEM1_HIGHADDR;
    elsif (C_NUM_BANKS_MEM = 3) then
       axi_ard_addr_range_array_v(0) := ZERO_ADDR_PAD&C_S_AXI_MEM0_BASEADDR;
       axi_ard_addr_range_array_v(1) := ZERO_ADDR_PAD&C_S_AXI_MEM0_HIGHADDR;
       axi_ard_addr_range_array_v(2) := ZERO_ADDR_PAD&C_S_AXI_MEM1_BASEADDR;
       axi_ard_addr_range_array_v(3) := ZERO_ADDR_PAD&C_S_AXI_MEM1_HIGHADDR;
       axi_ard_addr_range_array_v(4) := ZERO_ADDR_PAD&C_S_AXI_MEM2_BASEADDR;
       axi_ard_addr_range_array_v(5) := ZERO_ADDR_PAD&C_S_AXI_MEM2_HIGHADDR;
    else
       axi_ard_addr_range_array_v(0) := ZERO_ADDR_PAD&C_S_AXI_MEM0_BASEADDR;
       axi_ard_addr_range_array_v(1) := ZERO_ADDR_PAD&C_S_AXI_MEM0_HIGHADDR;
       axi_ard_addr_range_array_v(2) := ZERO_ADDR_PAD&C_S_AXI_MEM1_BASEADDR;
       axi_ard_addr_range_array_v(3) := ZERO_ADDR_PAD&C_S_AXI_MEM1_HIGHADDR;
       axi_ard_addr_range_array_v(4) := ZERO_ADDR_PAD&C_S_AXI_MEM2_BASEADDR;
       axi_ard_addr_range_array_v(5) := ZERO_ADDR_PAD&C_S_AXI_MEM2_HIGHADDR;
       axi_ard_addr_range_array_v(6) := ZERO_ADDR_PAD&C_S_AXI_MEM3_BASEADDR;
       axi_ard_addr_range_array_v(7) := ZERO_ADDR_PAD&C_S_AXI_MEM3_HIGHADDR;
    end if;
    return axi_ard_addr_range_array_v;
end function get_AXI_ARD_ADDR_RANGE_ARRAY;

constant AXI_ARD_ADDR_RANGE_ARRAY : SLV64_ARRAY_TYPE
                                  := get_AXI_ARD_ADDR_RANGE_ARRAY;
-----------------------------------------------------------------------------
-- Function: get_axi_ard_num_ce_array
-- Purpose:  Fill AXI_NUM_CE_ARRAY based on input parameters
-----------------------------------------------------------------------------
function get_axi_ard_num_ce_array return INTEGER_ARRAY_TYPE is
variable axi_ard_num_ce_array_v : INTEGER_ARRAY_TYPE(0 to C_NUM_BANKS_MEM-1);
begin
    if (C_NUM_BANKS_MEM = 1) then
        axi_ard_num_ce_array_v(0) := 1;      -- memories have only 1 CE
    elsif (C_NUM_BANKS_MEM = 2) then
        axi_ard_num_ce_array_v(0) := 1;
        axi_ard_num_ce_array_v(1) := 1;
    elsif (C_NUM_BANKS_MEM = 3) then
        axi_ard_num_ce_array_v(0) := 1;
        axi_ard_num_ce_array_v(1) := 1;
        axi_ard_num_ce_array_v(2) := 1;
    else
        axi_ard_num_ce_array_v(0) := 1;
        axi_ard_num_ce_array_v(1) := 1;
        axi_ard_num_ce_array_v(2) := 1;
        axi_ard_num_ce_array_v(3) := 1;
    end if;
    return axi_ard_num_ce_array_v;
end function get_axi_ard_num_ce_array;

-------------------------------------------------------------------------------
-- constant declaration
-----------------------
constant AXI_ARD_NUM_CE_ARRAY             : INTEGER_ARRAY_TYPE
                                          := get_axi_ard_num_ce_array;

-- axi full read/write interconnect related parameters
constant C_S_AXI_MEM_SUPPORTS_WRITE       : integer := 1;
constant C_S_AXI_MEM_SUPPORTS_READ        : integer := 1;

-------------------------------------------------------------------------------
-- Signal and Type Declarations
-------------------------------------------------------------------------------
--IPIC request qualifier signals
signal ip2bus_rdack         : std_logic;
signal ip2bus_wrack         : std_logic;
signal ip2bus_addrack       : std_logic;
signal ip2bus_errack        : std_logic;
-- IPIC address, data signals
signal ip2bus_data          : std_logic_vector(0 to (C_S_AXI_MEM_DATA_WIDTH-1));
signal bus2ip_addr          : std_logic_vector(0 to (C_S_AXI_MEM_ADDR_WIDTH-1));
signal bus2ip_addr_temp     : std_logic_vector(0 to (C_S_AXI_MEM_ADDR_WIDTH-1));
-- lower two bits address to generate the byte level address
signal bus2ip_addr_reg      : std_logic_vector(0 to 2);

-- Bus2IP_* Signals
signal bus2ip_data          : std_logic_vector(0 to (C_S_AXI_MEM_DATA_WIDTH-1));
-- below little endian signals are for data & BE swapping
signal temp_bus2ip_data     : std_logic_vector((C_S_AXI_MEM_DATA_WIDTH-1) downto 0);
signal temp_ip2bus_data     : std_logic_vector((C_S_AXI_MEM_DATA_WIDTH-1) downto 0);
signal temp_bus2ip_be       : std_logic_vector(((C_S_AXI_MEM_DATA_WIDTH/8)-1) downto 0);
--
signal bus2ip_rnw           : std_logic;
signal bus2ip_rdreq_i       : std_logic;
signal bus2ip_wrreq_i       : std_logic;
--
signal bus2ip_cs_i          : std_logic;
----
signal bus2ip_cs            : std_logic_vector
                              (0 to ((AXI_ARD_ADDR_RANGE_ARRAY'LENGTH)/2)-1);
-- big endian bus2ip_cs is used for EMC to maintain its big-endian structure
----
signal temp_bus2ip_cs       : std_logic_vector
                              (((AXI_ARD_ADDR_RANGE_ARRAY'LENGTH)/2)-1 downto 0);
----
signal bus2ip_rdce          : std_logic_vector
                              (0 to calc_num_ce(AXI_ARD_NUM_CE_ARRAY)-1);
signal bus2ip_wrce          : std_logic_vector
                              (0 to calc_num_ce(AXI_ARD_NUM_CE_ARRAY)-1);
--
signal bus2ip_be            : std_logic_vector(0 to (C_S_AXI_MEM_DATA_WIDTH/8)-1);
signal bus2ip_burst         : std_logic;
-- External memory signals
signal mem_dq_o_i           : std_logic_vector(0 to (C_MAX_MEM_WIDTH-1));
signal mem_dq_i_i           : std_logic_vector(0 to (C_MAX_MEM_WIDTH-1));
signal mem_dq_t_i           : std_logic_vector(0 to (C_MAX_MEM_WIDTH-1));

signal mem_dq_parity_o_i    : std_logic_vector(0 to (C_MAX_MEM_WIDTH/8-1));
signal mem_dq_parity_t_i    : std_logic_vector(0 to (C_MAX_MEM_WIDTH/8-1));
signal mem_dq_parity_i_i    : std_logic_vector(0 to (C_MAX_MEM_WIDTH/8-1));
--
signal parity_error_adrss   : std_logic_vector(0 to (C_S_AXI_MEM_ADDR_WIDTH-1));
signal parity_error_MEM     : std_logic_vector(1 downto 0);
--
signal mem_cen_i            : std_logic_vector(0 to (C_NUM_BANKS_MEM-1));
signal mem_oen_i            : std_logic_vector(0 to (C_NUM_BANKS_MEM-1));
signal mem_wen_i            : std_logic;
signal mem_qwen_i           : std_logic_vector(0 to (C_MAX_MEM_WIDTH/8-1));
signal mem_ben_i            : std_logic_vector(0 to (C_MAX_MEM_WIDTH/8-1))
;
signal mem_adv_ldn_i        : std_logic;
signal mem_cken_i           : std_logic;
signal mem_ce_i             : std_logic_vector(0 to (C_NUM_BANKS_MEM-1));

signal mem_a_i              : std_logic_vector(0 to (C_S_AXI_MEM_ADDR_WIDTH-1));
signal bus2ip_burstlength   : std_logic_vector(0 to 7);

signal Type_of_xfer         : std_logic;
signal psram_page_mode      : std_logic;
signal bus2ip_reset         : std_logic;
signal temp_single_0        : std_logic;
signal temp_single_1        : std_logic;
signal temp_single_2        : std_logic;

signal or_reduced_rdce_d1 : std_logic;
signal or_reduced_wrce	  : std_logic;
signal bus2ip_wrreq_reg	  : std_logic;
signal original_wrce      : std_logic;

signal Bus2IP_RdReq_emc : std_logic;
signal Bus2IP_WrReq_emc : std_logic;

--*

--**
-------------------------------------------------------------------------------
-- not_all_psram: checks if any of the memory is of PSRAM type. PSRAM is assigned
----------------  with value 4, so check if MEM_TYPE = 4 and return 0 or 1.
function not_all_psram(input_array          : MEM_TYPE_ARRAY_TYPE;
                       num_real_elements    : integer)
                       return integer is
    variable sum : integer range 0 to 4 := 0;
    begin
        for i in 0 to num_real_elements -1 loop
           if input_array(i) = 4 then
             sum := sum + 1;
           end if;
        end loop;

        if sum = 0 then
            return 0;
        else
            return 1;
        end if;
end function not_all_psram;
-------------------------------------------------------------------------------
-- not_all_parity : check if any of the memory is assigned with PARITY bit
------------------ if any of the memory is assigned with parity, return 1.
function not_all_parity(input_array        : MEM_PARITY_ARRAY_TYPE;
                       num_real_elements   : integer)
                       return integer is
    variable sum : integer range 0 to 4 := 0;
    begin
        for i in 0 to num_real_elements -1 loop
           if input_array(i) /= 0 then
             sum := sum + 1;
           end if;
        end loop;

        if sum = 0 then
            return 0;
        else
            return 1;
        end if;
end function not_all_parity;
-------------------------------------------------------------------------------
-- sync_get_val: Check if the memory is SYNC memory type, if yes return 1.
---------------
function sync_get_val(x: integer) return integer is
begin
    if x = 0 then
      return 1;
    else
      return 0;
     end if;
end function sync_get_val;
-------------------------------------------------------------------------------
-- page_get_val: If Page Mode Flash or PSRAM, then return 1.
---------------
function page_get_val(x: integer) return integer is
begin
    if x = 3 or x = 4 then
      return 1;
    else
      return 0;
     end if;
end function page_get_val;
-------------------------------------------------------------------------------



constant MEM_TYPE_ARRAY : MEM_TYPE_ARRAY_TYPE :=
        (
            C_MEM0_TYPE,
            C_MEM1_TYPE,
            C_MEM2_TYPE,
            C_MEM3_TYPE
        );



constant MEM_PARITY_ARRAY : MEM_PARITY_ARRAY_TYPE :=
        (
            C_PARITY_TYPE_MEM_0,
            C_PARITY_TYPE_MEM_1,
            C_PARITY_TYPE_MEM_2,
            C_PARITY_TYPE_MEM_3
        );


constant GLOBAL_PSRAM_MEM    : integer range 0 to 1
                             := not_all_psram(MEM_TYPE_ARRAY,
                                              C_NUM_BANKS_MEM);

constant GLOBAL_PARITY_MEM   : integer range 0 to 1
                             := not_all_parity(MEM_PARITY_ARRAY,
                                               C_NUM_BANKS_MEM);
-- if SYNC memories are configured, then below parameter will be = 1
constant C_SYNCH_MEM_0          : integer :=sync_get_val(C_MEM0_TYPE);
constant C_SYNCH_MEM_1          : integer :=sync_get_val(C_MEM1_TYPE);
constant C_SYNCH_MEM_2          : integer :=sync_get_val(C_MEM2_TYPE);
constant C_SYNCH_MEM_3          : integer :=sync_get_val(C_MEM3_TYPE);
-- if Page Mode or PSRAM memories are configured,then below parameter will be= 1
constant C_PAGEMODE_FLASH_0     : integer :=page_get_val(C_MEM0_TYPE);
constant C_PAGEMODE_FLASH_1     : integer :=page_get_val(C_MEM1_TYPE);
constant C_PAGEMODE_FLASH_2     : integer :=page_get_val(C_MEM2_TYPE);
constant C_PAGEMODE_FLASH_3     : integer :=page_get_val(C_MEM3_TYPE);
--signal Mem_CRE_i : std_logic;
-------------------------------------------------------------------------------
-- Architecture
-------------------------------------------------------------------------------

begin -- architecture IMP


-- EMC memory read/write access times assignments
    Mem_A       <= mem_a_i      ;
    Mem_WEN     <= mem_wen_i    ;
    Mem_ADV_LDN <= mem_adv_ldn_i;
    Mem_CKEN    <= mem_cken_i   ;
   
    ---------------------------------------------------------------------------
     -- AXI EMC is little endian and EMC COMMON is still big endian, to make
     -- this interface work normally, we need to swap the Write and read data
     -- bytes comming from and going to external memory interface
    ---------------------------------------------------------------------------

    ENDIAN_CEN_BANKS_1 : if (C_NUM_BANKS_MEM = 1) generate
        Mem_CEN(0)     <= mem_cen_i(0);
        Mem_CE(0)      <= mem_ce_i(0);
    end generate ENDIAN_CEN_BANKS_1;

    ENDIAN_CEN_BANKS_2 : if (C_NUM_BANKS_MEM = 2) generate
        Mem_CEN(0)     <= mem_cen_i(0);
        Mem_CEN(1)     <= mem_cen_i(1);

        Mem_CE(0)      <= mem_ce_i(0);
        Mem_CE(1)      <= mem_ce_i(1);
    end generate ENDIAN_CEN_BANKS_2;

    ENDIAN_CEN_BANKS_3 : if (C_NUM_BANKS_MEM = 3) generate
        Mem_CEN(0)     <= mem_cen_i(0);
        Mem_CEN(1)     <= mem_cen_i(1);
        Mem_CEN(2)     <= mem_cen_i(2);

        Mem_CE(0)      <= mem_ce_i(0);
        Mem_CE(1)      <= mem_ce_i(1);
        Mem_CE(2)      <= mem_ce_i(2);
    end generate ENDIAN_CEN_BANKS_3;

    ENDIAN_CEN_BANKS_4 : if (C_NUM_BANKS_MEM = 4) generate
        Mem_CEN(0)     <= mem_cen_i(0);
        Mem_CEN(1)     <= mem_cen_i(1);
        Mem_CEN(2)     <= mem_cen_i(2);
        Mem_CEN(3)     <= mem_cen_i(3);

        Mem_CE(0)      <= mem_ce_i(0);
        Mem_CE(1)      <= mem_ce_i(1);
        Mem_CE(2)      <= mem_ce_i(2);
        Mem_CE(3)      <= mem_ce_i(3);
    end generate ENDIAN_CEN_BANKS_4;

    -- assign OutPut Enable signals (Read Enable Signals)
    ENDIAN_OEN_BANKS_1 : if (C_NUM_BANKS_MEM = 1) generate
        Mem_OEN(0)     <= mem_oen_i(0);
    end generate ENDIAN_OEN_BANKS_1;

    ENDIAN_OEN_BANKS_2 : if (C_NUM_BANKS_MEM = 2) generate
        Mem_OEN(0)     <= mem_oen_i(0);
        Mem_OEN(1)     <= mem_oen_i(1);
    end generate ENDIAN_OEN_BANKS_2;

    ENDIAN_OEN_BANKS_3 : if (C_NUM_BANKS_MEM = 3) generate
        Mem_OEN(0)     <= mem_oen_i(0);
        Mem_OEN(1)     <= mem_oen_i(1);
        Mem_OEN(2)     <= mem_oen_i(2);
    end generate ENDIAN_OEN_BANKS_3;

    ENDIAN_OEN_BANKS_4 : if (C_NUM_BANKS_MEM = 4) generate
        Mem_OEN(0)     <= mem_oen_i(0);
        Mem_OEN(1)     <= mem_oen_i(1);
        Mem_OEN(2)     <= mem_oen_i(2);
        Mem_OEN(3)     <= mem_oen_i(3);
    end generate ENDIAN_OEN_BANKS_4;

    -- data byte swapping for 8 bit memory
    ENDIAN_MEM_CONVERSION_8 : if (C_MAX_MEM_WIDTH = 8) generate
        -- output from memory core
        Mem_DQ_O(7 downto 0)  <= mem_dq_o_i (0 to 7);
        Mem_DQ_T(7 downto 0)  <= mem_dq_t_i (0 to 7);
        -- input to memory core
        mem_dq_i_i (0 to 7)   <= Mem_DQ_I (7 downto 0);

        Mem_QWEN              <= mem_qwen_i;
        Mem_BEN               <= mem_ben_i;

        -- o/p from memory
        MEM_DQ_PARITY_O       <= mem_dq_parity_o_i;
        MEM_DQ_PARITY_T       <= mem_dq_parity_t_i;
        -- i/p to memory
        mem_dq_parity_i_i     <= MEM_DQ_PARITY_I;

    end generate ENDIAN_MEM_CONVERSION_8;

    -- data byte swapping for 16 bit memory
    -- ENDIAN_MEM_CONVERSION_16: byte -by -byte swapping for 16 bit memory
    ---------------------------
    ENDIAN_MEM_CONVERSION_16 : if (C_MAX_MEM_WIDTH = 16) generate
        -- o/p to memory
        Mem_DQ_O(7 downto 0)  <= mem_dq_o_i (0 to 7);
        Mem_DQ_O(15 downto 8) <= mem_dq_o_i (8 to 15);

        Mem_DQ_T(7 downto 0)  <= mem_dq_t_i (0 to 7);
        Mem_DQ_T(15 downto 8) <= mem_dq_t_i (8 to 15);
        -- i/p from memory
        mem_dq_i_i (0 to 7)   <= Mem_DQ_I (7 downto 0);
        mem_dq_i_i (8 to 15)  <= Mem_DQ_I (15 downto 8);

        -- qualified write enabls
        Mem_QWEN(0)           <= mem_qwen_i(0);
        Mem_QWEN(1)           <= mem_qwen_i(1);
        -- byte enabls
        Mem_BEN(0)            <= mem_ben_i(0);
        Mem_BEN(1)            <= mem_ben_i(1);
        -- parity bits to memory
        MEM_DQ_PARITY_O(0)    <= mem_dq_parity_o_i(0);
        MEM_DQ_PARITY_O(1)    <= mem_dq_parity_o_i(1);

        MEM_DQ_PARITY_T(0)    <= mem_dq_parity_t_i(0);
        MEM_DQ_PARITY_T(1)    <= mem_dq_parity_t_i(1);
        -- parity bits from memory
        mem_dq_parity_i_i(0)  <= MEM_DQ_PARITY_I(0);
        mem_dq_parity_i_i(1)  <= MEM_DQ_PARITY_I(1);

     end generate ENDIAN_MEM_CONVERSION_16;

   -- data byte swapping for 32 bit memory
   -- ENDIAN_MEM_CONVERSION_32: byte -by -byte swapping for 32 bit memory
    ENDIAN_MEM_CONVERSION_32 : if (C_MAX_MEM_WIDTH = 32) generate
        -- o/p to memory
        Mem_DQ_O(7 downto 0)   <= mem_dq_o_i (0 to 7);
        Mem_DQ_O(15 downto 8)  <= mem_dq_o_i (8 to 15);
        Mem_DQ_O(23 downto 16) <= mem_dq_o_i (16 to 23);
        Mem_DQ_O(31 downto 24) <= mem_dq_o_i (24 to 31);

        Mem_DQ_T(7 downto 0)   <= mem_dq_t_i (0 to 7);
        Mem_DQ_T(15 downto 8)  <= mem_dq_t_i (8 to 15);
        Mem_DQ_T(23 downto 16) <= mem_dq_t_i (16 to 23);
        Mem_DQ_T(31 downto 24) <= mem_dq_t_i (24 to 31);
        -- i/p from memory
        mem_dq_i_i (0 to 7)    <= Mem_DQ_I (7 downto 0);
        mem_dq_i_i (8 to 15)   <= Mem_DQ_I (15 downto 8);
        mem_dq_i_i (16 to 23)  <= Mem_DQ_I (23 downto 16);
        mem_dq_i_i (24 to 31)  <= Mem_DQ_I (31 downto 24);
        -- qualified write enabls
        Mem_QWEN(0)    <= mem_qwen_i(0);
        Mem_QWEN(1)    <= mem_qwen_i(1);
        Mem_QWEN(2)    <= mem_qwen_i(2);
        Mem_QWEN(3)    <= mem_qwen_i(3);
        -- byte enabls
        Mem_BEN(0)    <= mem_ben_i(0);
        Mem_BEN(1)    <= mem_ben_i(1);
        Mem_BEN(2)    <= mem_ben_i(2);
        Mem_BEN(3)    <= mem_ben_i(3);
        -- parity bits to memory
        MEM_DQ_PARITY_O(0) <= mem_dq_parity_o_i(0);
        MEM_DQ_PARITY_O(1) <= mem_dq_parity_o_i(1);
        MEM_DQ_PARITY_O(2) <= mem_dq_parity_o_i(2);
        MEM_DQ_PARITY_O(3) <= mem_dq_parity_o_i(3);

        MEM_DQ_PARITY_T(0) <= mem_dq_parity_t_i(0);
        MEM_DQ_PARITY_T(1) <= mem_dq_parity_t_i(1);
        MEM_DQ_PARITY_T(2) <= mem_dq_parity_t_i(2);
        MEM_DQ_PARITY_T(3) <= mem_dq_parity_t_i(3);
        -- parity bits from memory
        mem_dq_parity_i_i(0) <= MEM_DQ_PARITY_I(0);
        mem_dq_parity_i_i(1) <= MEM_DQ_PARITY_I(1);
        mem_dq_parity_i_i(2) <= MEM_DQ_PARITY_I(2);
        mem_dq_parity_i_i(3) <= MEM_DQ_PARITY_I(3);

     end generate ENDIAN_MEM_CONVERSION_32;

   -- data byte swapping for 64 bit memory
   -- ENDIAN_MEM_CONVERSION_64: byte -by -byte swapping for 64 bit memory
    ENDIAN_MEM_CONVERSION_64 : if (C_MAX_MEM_WIDTH = 64) generate
        -- o/p to memory
        Mem_DQ_O(7 downto 0)   <= mem_dq_o_i (0 to 7);
        Mem_DQ_O(15 downto 8)  <= mem_dq_o_i (8 to 15);
        Mem_DQ_O(23 downto 16) <= mem_dq_o_i (16 to 23);
        Mem_DQ_O(31 downto 24) <= mem_dq_o_i (24 to 31);
        Mem_DQ_O(39 downto 32) <= mem_dq_o_i (32 to 39);
        Mem_DQ_O(47 downto 40) <= mem_dq_o_i (40 to 47);
        Mem_DQ_O(55 downto 48) <= mem_dq_o_i (48 to 55);
        Mem_DQ_O(63 downto 56) <= mem_dq_o_i (56 to 63);

        Mem_DQ_T(7 downto 0)   <= mem_dq_t_i (0 to 7);
        Mem_DQ_T(15 downto 8)  <= mem_dq_t_i (8 to 15);
        Mem_DQ_T(23 downto 16) <= mem_dq_t_i (16 to 23);
        Mem_DQ_T(31 downto 24) <= mem_dq_t_i (24 to 31);
        Mem_DQ_T(39 downto 32) <= mem_dq_t_i (32 to 39);
        Mem_DQ_T(47 downto 40) <= mem_dq_t_i (40 to 47);
        Mem_DQ_T(55 downto 48) <= mem_dq_t_i (48 to 55);
        Mem_DQ_T(63 downto 56) <= mem_dq_t_i (56 to 63);
        -- o/p from memory
        mem_dq_i_i (0 to 7)    <= Mem_DQ_I (7 downto 0);
        mem_dq_i_i (8 to 15)   <= Mem_DQ_I (15 downto 8);
        mem_dq_i_i (16 to 23)  <= Mem_DQ_I (23 downto 16);
        mem_dq_i_i (24 to 31)  <= Mem_DQ_I (31 downto 24);
        mem_dq_i_i (32 to 39)  <= Mem_DQ_I (39 downto 32);
        mem_dq_i_i (40 to 47)  <= Mem_DQ_I (47 downto 40);
        mem_dq_i_i (48 to 55)  <= Mem_DQ_I (55 downto 48);
        mem_dq_i_i (56 to 63)  <= Mem_DQ_I (63 downto 56);

        -- qualified write enabls
        Mem_QWEN(0)    <= mem_qwen_i(0);
        Mem_QWEN(1)    <= mem_qwen_i(1);
        Mem_QWEN(2)    <= mem_qwen_i(2);
        Mem_QWEN(3)    <= mem_qwen_i(3);
        Mem_QWEN(4)    <= mem_qwen_i(4);
        Mem_QWEN(5)    <= mem_qwen_i(5);
        Mem_QWEN(6)    <= mem_qwen_i(6);
        Mem_QWEN(7)    <= mem_qwen_i(7);
        -- byte enabls
        Mem_BEN(0)    <= mem_ben_i(0);
        Mem_BEN(1)    <= mem_ben_i(1);
        Mem_BEN(2)    <= mem_ben_i(2);
        Mem_BEN(3)    <= mem_ben_i(3);
        Mem_BEN(4)    <= mem_ben_i(4);
        Mem_BEN(5)    <= mem_ben_i(5);
        Mem_BEN(6)    <= mem_ben_i(6);
        Mem_BEN(7)    <= mem_ben_i(7);
        -- parity bits to memory
        MEM_DQ_PARITY_O(0) <= mem_dq_parity_o_i(0);
        MEM_DQ_PARITY_O(1) <= mem_dq_parity_o_i(1);
        MEM_DQ_PARITY_O(2) <= mem_dq_parity_o_i(2);
        MEM_DQ_PARITY_O(3) <= mem_dq_parity_o_i(3);
        MEM_DQ_PARITY_O(4) <= mem_dq_parity_o_i(4);
        MEM_DQ_PARITY_O(5) <= mem_dq_parity_o_i(5);
        MEM_DQ_PARITY_O(6) <= mem_dq_parity_o_i(6);
        MEM_DQ_PARITY_O(7) <= mem_dq_parity_o_i(7);

        MEM_DQ_PARITY_T(0) <= mem_dq_parity_t_i(0);
        MEM_DQ_PARITY_T(1) <= mem_dq_parity_t_i(1);
        MEM_DQ_PARITY_T(2) <= mem_dq_parity_t_i(2);
        MEM_DQ_PARITY_T(3) <= mem_dq_parity_t_i(3);
        MEM_DQ_PARITY_T(4) <= mem_dq_parity_t_i(4);
        MEM_DQ_PARITY_T(5) <= mem_dq_parity_t_i(5);
        MEM_DQ_PARITY_T(6) <= mem_dq_parity_t_i(6);
        MEM_DQ_PARITY_T(7) <= mem_dq_parity_t_i(7);

        -- parity bits from memory
        mem_dq_parity_i_i(0) <= MEM_DQ_PARITY_I(0);
        mem_dq_parity_i_i(1) <= MEM_DQ_PARITY_I(1);
        mem_dq_parity_i_i(2) <= MEM_DQ_PARITY_I(2);
        mem_dq_parity_i_i(3) <= MEM_DQ_PARITY_I(3);
        mem_dq_parity_i_i(4) <= MEM_DQ_PARITY_I(4);
        mem_dq_parity_i_i(5) <= MEM_DQ_PARITY_I(5);
        mem_dq_parity_i_i(6) <= MEM_DQ_PARITY_I(6);
        mem_dq_parity_i_i(7) <= MEM_DQ_PARITY_I(7);

   end generate ENDIAN_MEM_CONVERSION_64;

-------------------------------------------------------------------------------
-- NO_REG_EN_GEN: the below instantion is to make the output signals for
--                register interface driving '0'.
--------------
NO_REG_EN_GEN : if (C_S_AXI_EN_REG = 0) generate
-------------
begin
	-------------------------------------
	S_AXI_REG_AWREADY <= '0';
	S_AXI_REG_WREADY  <= '0';
	S_AXI_REG_BRESP   <= (others => '0');
	S_AXI_REG_BVALID  <= '0';
	S_AXI_REG_ARREADY <= '0';
	S_AXI_REG_RDATA   <= (others => '0');
	S_AXI_REG_RRESP   <= (others => '0');
	S_AXI_REG_RVALID  <= '0';
	-------------------------------------
end generate NO_REG_EN_GEN;
-------------------------------------------------------------------------------
-- EMC REGISTER  MODULE Instantiations
-------------------------------------------------------------------------------
-- REG_EN_GEN: Include the AXI Lite IPIF and register module
--------------
REG_EN_GEN : if (C_S_AXI_EN_REG = 1) generate
-------------

-- IPIC Used Sgnals
   constant RST_ACTIVE  : std_logic := '0';
   
   type MEM_PARITY_REG_ARRAY_TYPE is array((C_NUM_BANKS_MEM-1) downto 0) of
                        std_logic_vector((C_S_AXI_REG_DATA_WIDTH -1) downto 0);

   type MEM_PSRAM_REG_ARRAY_TYPE is array((C_NUM_BANKS_MEM-1)downto 0) of
                        std_logic_vector((C_S_AXI_REG_DATA_WIDTH -1) downto 0);

   signal PEAR_REG : MEM_PARITY_REG_ARRAY_TYPE;-- 4 parity regs of each 32 bit
   signal PCR_REG  : MEM_PSRAM_REG_ARRAY_TYPE; -- 4 psram regs of each 32 bit


   signal axi_lite_ip2bus_data_i    : std_logic_vector((C_S_AXI_REG_DATA_WIDTH-1)
                                                       downto 0);

   signal axi_lite_ip2bus_data1    : std_logic_vector((C_S_AXI_REG_DATA_WIDTH-1)
                                                       downto 0);
   signal axi_lite_ip2bus_data2    : std_logic_vector((C_S_AXI_REG_DATA_WIDTH-1)
                                                       downto 0);
   signal bus2ip_addr_lite_reg     : std_logic_vector((3+GLOBAL_PSRAM_MEM)
                                                       downto 2);

   signal arready_i : std_logic;
   signal awready_i : std_logic;
   signal rvalid    : std_logic;
 
   signal axi_lite_ip2bus_wrack_i : std_logic;
   signal axi_lite_ip2bus_rdack_i : std_logic;
   signal axi_lite_ip2bus_rdack1  : std_logic;
   signal axi_lite_ip2bus_rdack2  : std_logic;
                                
   signal axi_lite_ip2bus_wrack1  : std_logic;
   signal axi_lite_ip2bus_wrack2  : std_logic;

   signal read_reg_req  : std_logic;
   signal write_reg_req : std_logic;

   signal bus2ip_rdce_lite_cmb  : std_logic_vector(((C_NUM_BANKS_MEM-1)+(4*GLOBAL_PSRAM_MEM)) downto 0);
   signal bus2ip_wrce_lite_cmb  : std_logic_vector(((C_NUM_BANKS_MEM-1)+(4*GLOBAL_PSRAM_MEM)) downto 0);
   signal s_axi_reg_rresp_reg: std_logic_vector(1 downto 0);
   signal s_axi_reg_bresp_reg: std_logic_vector(1 downto 0);
   ------------------------
-----
begin
-------------------------------------------------------------------------------

-- * 
-------------------------------------------------------------------------------
PSRAM_PARITY_CE_LOCAL_REG_GEN : if (GLOBAL_PSRAM_MEM = 1) generate
-------------------------------
signal bus2ip_ce_lite_cmb    : std_logic_vector(7 downto 0);
-----
begin-- *
-----
--* to generate the WRCE and RDCE for register access.
      PSRAM_PARITY_NUM_BANKS_4_GEN: if (C_NUM_BANKS_MEM=4) generate
      begin
        BUS2IP_CE_GEN_P: process(
                                 bus2ip_addr_lite_reg(4 downto 2)
                                 )is
        -------- 
        variable bus2ip_addr_reg_4_2 : std_logic_vector(2 downto 0);
        --------
        begin 
        --
        bus2ip_addr_reg_4_2 := bus2ip_addr_lite_reg;
        --
                case bus2ip_addr_reg_4_2 is
                        when "000" => bus2ip_ce_lite_cmb <= "00000001";
                        when "001" => bus2ip_ce_lite_cmb <= "00000010";
                        when "010" => bus2ip_ce_lite_cmb <= "00000100";
                        when "011" => bus2ip_ce_lite_cmb <= "00001000";
                        when "100" => bus2ip_ce_lite_cmb <= "00010000";
                        when "101" => bus2ip_ce_lite_cmb <= "00100000";
                        when "110" => bus2ip_ce_lite_cmb <= "01000000";                 
                        when "111" => bus2ip_ce_lite_cmb <= "10000000";
                        -- coverage off
                        when others => bus2ip_ce_lite_cmb <= (others=> '0'); 
                        -- coverage on
                end case;
        end process BUS2IP_CE_GEN_P;
        --------------------------------------
        RDCE_GEN: for i in 7 downto 0 generate 
        -----
        begin
        -----
            bus2ip_rdce_lite_cmb(i) <= read_reg_req and bus2ip_ce_lite_cmb(i); 
        end generate RDCE_GEN;
        --------------------------------------
        WRCE_GEN: for i in 7 downto 0 generate 
        -----
        begin
        -----
            bus2ip_wrce_lite_cmb(i) <= S_AXI_REG_WVALID and 
                                       write_reg_req    and 
                                       bus2ip_ce_lite_cmb(i); 
        end generate WRCE_GEN;
        ----------------------------------------
      end generate PSRAM_PARITY_NUM_BANKS_4_GEN;
      ------------------------------------------

      PSRAM_PARITY_NUM_BANKS_3_GEN: if (C_NUM_BANKS_MEM=3) generate
      begin
      BUS2IP_CE_GEN_P: process(
                               bus2ip_addr_lite_reg(4 downto 2)
                               )is
        -------- 
        variable bus2ip_addr_reg_4_2 : std_logic_vector(2 downto 0);
        --------
        begin 
        --
        bus2ip_addr_reg_4_2 := bus2ip_addr_lite_reg;
        --
                case bus2ip_addr_reg_4_2 is
                        when "000" => bus2ip_ce_lite_cmb <= "00000001";
                        when "001" => bus2ip_ce_lite_cmb <= "00000010";
                        when "010" => bus2ip_ce_lite_cmb <= "00000100";
                        -- psram configuration registers
                        when "100" => bus2ip_ce_lite_cmb <= "00010000";
                        when "101" => bus2ip_ce_lite_cmb <= "00100000";
                        when "110" => bus2ip_ce_lite_cmb <= "01000000";                 
                        -- coverage off
                        when others => bus2ip_ce_lite_cmb <= (others=> '0'); 
                        -- coverage on
                end case;
        --    end if;
        -- end if;
        end process BUS2IP_CE_GEN_P;
        --------------------------------------
        RDCE_GEN: for i in (((C_NUM_BANKS_MEM-1)+(4*GLOBAL_PSRAM_MEM))) downto 0 
	                                                                generate 
        -----
        begin
        -----
            bus2ip_rdce_lite_cmb(i) <= read_reg_req and bus2ip_ce_lite_cmb(i); 
        end generate RDCE_GEN;
        --------------------------------------
        WRCE_GEN: for i in (((C_NUM_BANKS_MEM-1)+(4*GLOBAL_PSRAM_MEM))) downto 0 
	                                                                generate 
        -----
        begin
        -----
            bus2ip_wrce_lite_cmb(i) <= S_AXI_REG_WVALID and 
                                       write_reg_req    and 
                                       bus2ip_ce_lite_cmb(i); 
        end generate WRCE_GEN;
        ----------------------------------------
      end generate PSRAM_PARITY_NUM_BANKS_3_GEN;
      ------------------------------------------
      
      
      PSRAM_PARITY_NUM_BANKS_2_GEN: if (C_NUM_BANKS_MEM=2) generate
      begin
      BUS2IP_CE_GEN_P: process(
                                 bus2ip_addr_lite_reg(4 downto 2)
                               )is
        -------- 
        variable bus2ip_addr_reg_4_2 : std_logic_vector(2 downto 0);
        --------
        begin 
        --
        bus2ip_addr_reg_4_2 := bus2ip_addr_lite_reg;
        --
                case bus2ip_addr_reg_4_2 is
                        when "000" => bus2ip_ce_lite_cmb <= "00000001";
                        when "001" => bus2ip_ce_lite_cmb <= "00000010";
                        -- psram configuration registers
                        when "100" => bus2ip_ce_lite_cmb <= "00010000";
                        when "101" => bus2ip_ce_lite_cmb <= "00100000";
                        -- coverage off
                        when others => bus2ip_ce_lite_cmb <= (others=> '0'); 
                        -- coverage on
                end case;
        end process BUS2IP_CE_GEN_P;
        --------------------------------------
        --------------------------------------
        RDCE_GEN: for i in (((C_NUM_BANKS_MEM-1)+(4*GLOBAL_PSRAM_MEM))) downto 0 
	                                                                generate 
        -----
        begin
        -----
            bus2ip_rdce_lite_cmb(i) <= read_reg_req and bus2ip_ce_lite_cmb(i); 
        end generate RDCE_GEN;
        --------------------------------------
        WRCE_GEN: for i in (((C_NUM_BANKS_MEM-1)+(4*GLOBAL_PSRAM_MEM))) downto 0 
	                                                                generate 
        -----
        begin
        -----
            bus2ip_wrce_lite_cmb(i) <= S_AXI_REG_WVALID and 
                                       write_reg_req    and 
                                       bus2ip_ce_lite_cmb(i); 
        end generate WRCE_GEN;
        ----------------------------------------
        end generate PSRAM_PARITY_NUM_BANKS_2_GEN;

      PSRAM_PARITY_NUM_BANKS_1_GEN: if (C_NUM_BANKS_MEM=1) generate
      begin
      BUS2IP_CE_GEN_P: process--(S_AXI_ACLK) is
                                (
                                 bus2ip_addr_lite_reg(4 downto 2)
                                 )is
        -------- 
        variable bus2ip_addr_reg_4_2 : std_logic_vector(2 downto 0);
        --------
        begin 
        --
        bus2ip_addr_reg_4_2 := bus2ip_addr_lite_reg;
        --
                case bus2ip_addr_reg_4_2 is
                        when "000" => bus2ip_ce_lite_cmb <= "00000001";
                        -- psram configuration registers
                        when "100" => bus2ip_ce_lite_cmb <= "00010000";
                        -- coverage off
                        when others => bus2ip_ce_lite_cmb <= (others=> '0'); 
                        -- coverage on
                end case;
        end process BUS2IP_CE_GEN_P;
        --------------------------------------
        --------------------------------------
        RDCE_GEN: for i in (((C_NUM_BANKS_MEM-1)+(4*GLOBAL_PSRAM_MEM))) downto 0 generate 
        -----
        begin
        -----
            bus2ip_rdce_lite_cmb(i) <= read_reg_req and bus2ip_ce_lite_cmb(i); 
        end generate RDCE_GEN;
        --------------------------------------
        WRCE_GEN: for i in (((C_NUM_BANKS_MEM-1)+(4*GLOBAL_PSRAM_MEM))) downto 0 generate 
        -----
        begin
        -----
            bus2ip_wrce_lite_cmb(i) <= S_AXI_REG_WVALID and 
                                       write_reg_req    and 
                                       bus2ip_ce_lite_cmb(i); 
        end generate WRCE_GEN;
        ----------------------------------------
      end generate PSRAM_PARITY_NUM_BANKS_1_GEN;

end generate PSRAM_PARITY_CE_LOCAL_REG_GEN;
-------------------------------------------------------------------------------
NO_PSRAM_CE_LOCAL_REG_GEN : if (GLOBAL_PSRAM_MEM = 0) generate
---------------------------
-----
begin-- *
-----
--* to generate the WRCE and RDCE for register access.
    NUM_BANKS_4_GEN: if (C_NUM_BANKS_MEM=4) generate
    signal bus2ip_ce_lite_cmb : std_logic_vector((C_NUM_BANKS_MEM-1) downto 0);
    -----
    begin
    -----
        BUS2IP_CE_GEN_P: process
                                (
                                 bus2ip_addr_lite_reg(3 downto 2)
                                 ) is
        --------
        --variable bus2ip_addr_reg_3_2 : std_logic_vector(1 downto 0);
        --------
        begin 
        --
                case bus2ip_addr_lite_reg(3 downto 2) is
                        when "00" => bus2ip_ce_lite_cmb <= "0001";
                        when "01" => bus2ip_ce_lite_cmb <= "0010";
                        when "10" => bus2ip_ce_lite_cmb <= "0100";
                        when "11" => bus2ip_ce_lite_cmb <= "1000";
                        -- coverage off
                        when others => bus2ip_ce_lite_cmb <= (others=> '0'); 
                        -- coverage on
                end case;
        end process BUS2IP_CE_GEN_P;
        
        --------------------------------------
        RDCE_GEN: for i in C_NUM_BANKS_MEM-1 downto 0 generate 
        -----
        begin
        -----
            bus2ip_rdce_lite_cmb(i) <= read_reg_req and 
                                       bus2ip_ce_lite_cmb(i); 
        end generate RDCE_GEN;
        --------------------------------------
        WRCE_GEN: for i in C_NUM_BANKS_MEM-1 downto 0 generate 
        -----
        begin
        -----
            bus2ip_wrce_lite_cmb(i) <= S_AXI_REG_WVALID and 
                                       write_reg_req    and 
                                       bus2ip_ce_lite_cmb(i); 
        end generate WRCE_GEN;
        --------------------------------------

    end generate NUM_BANKS_4_GEN;
    ------------------------------------------

    NUM_BANKS_3_GEN: if (C_NUM_BANKS_MEM=3) generate
    signal bus2ip_ce_lite_cmb : std_logic_vector((C_NUM_BANKS_MEM-1) downto 0);
    -----
    begin
    -----
        BUS2IP_CE_GEN_P: process(
                                 bus2ip_addr_lite_reg(3 downto 2)
                                 ) is
        --------
        begin 
        --
                case bus2ip_addr_lite_reg(3 downto 2) is
                        when "00" => bus2ip_ce_lite_cmb <= "001";
                        when "01" => bus2ip_ce_lite_cmb <= "010";
                        when "10" => bus2ip_ce_lite_cmb <= "100";
                        -- coverage off
                        when others => bus2ip_ce_lite_cmb <= (others=> '0'); 
                        -- coverage on
                end case;
        end process BUS2IP_CE_GEN_P;
        --------------------------------------
        RDCE_GEN: for i in C_NUM_BANKS_MEM-1 downto 0 generate 
        -----
        begin
        -----
            bus2ip_rdce_lite_cmb(i) <= read_reg_req and 
                                       bus2ip_ce_lite_cmb(i); 
        end generate RDCE_GEN;
        --------------------------------------
        WRCE_GEN: for i in C_NUM_BANKS_MEM-1 downto 0 generate 
        -----
        begin
        -----
            bus2ip_wrce_lite_cmb(i) <= S_AXI_REG_WVALID and 
                                       write_reg_req    and 
                                       bus2ip_ce_lite_cmb(i); 
        end generate WRCE_GEN;
        --------------------------------------

    end generate NUM_BANKS_3_GEN;
    ------------------------------------------
    
    NUM_BANKS_2_GEN: if (C_NUM_BANKS_MEM=2) generate
    signal bus2ip_ce_lite_cmb : std_logic_vector((C_NUM_BANKS_MEM-1) downto 0);
    -----
    begin
    -----
        BUS2IP_CE_GEN_P: process(
                                 bus2ip_addr_lite_reg(3 downto 2)
                                 ) is
        --------
        begin 
        --
                case bus2ip_addr_lite_reg(3 downto 2) is
                        when "00" => bus2ip_ce_lite_cmb <= "01";
                        when "01" => bus2ip_ce_lite_cmb <= "10";
                        -- coverage off
                        when others => bus2ip_ce_lite_cmb <= (others=> '0'); 
                        -- coverage on
                end case;
        end process BUS2IP_CE_GEN_P;
        --------------------------------------
        RDCE_GEN: for i in C_NUM_BANKS_MEM-1 downto 0 generate 
        -----
        begin
        -----
            bus2ip_rdce_lite_cmb(i) <= read_reg_req and 
                                       bus2ip_ce_lite_cmb(i); 
        end generate RDCE_GEN;
        --------------------------------------
        WRCE_GEN: for i in C_NUM_BANKS_MEM-1 downto 0 generate 
        -----
        begin
        -----
            bus2ip_wrce_lite_cmb(i) <= S_AXI_REG_WVALID and 
                                       write_reg_req    and 
                                       bus2ip_ce_lite_cmb(i); 
        end generate WRCE_GEN;
        --------------------------------------

    end generate NUM_BANKS_2_GEN;
    ------------------------------------------

    NUM_BANKS_1_GEN: if (C_NUM_BANKS_MEM=1) generate
    signal bus2ip_ce_lite_cmb : std_logic;
    -----
    begin
    -----
        BUS2IP_CE_GEN_P: process(
                                 bus2ip_addr_lite_reg(3 downto 2)
                                 ) is
        --------
        begin 
        --
                case bus2ip_addr_lite_reg(3 downto 2) is
                        when "00" => bus2ip_ce_lite_cmb <= '1';
                        -- coverage off
                        when others => bus2ip_ce_lite_cmb <= '0'; 
                        -- coverage on
                end case;
        end process BUS2IP_CE_GEN_P;
        --------------------------------------
        RDCE_GEN: for i in C_NUM_BANKS_MEM-1 downto 0 generate 
        -----
        begin
        -----
            bus2ip_rdce_lite_cmb(i) <= read_reg_req and 
                                       bus2ip_ce_lite_cmb; 
        end generate RDCE_GEN;
        --------------------------------------
        WRCE_GEN: for i in C_NUM_BANKS_MEM-1 downto 0 generate 
        -----
        begin
        -----
            bus2ip_wrce_lite_cmb(i) <= S_AXI_REG_WVALID and 
                                       write_reg_req    and 
                                       bus2ip_ce_lite_cmb; 
        end generate WRCE_GEN;
        --------------------------------------

    end generate NUM_BANKS_1_GEN;
    --------------------------------------

end generate NO_PSRAM_CE_LOCAL_REG_GEN;
--*
 S_AXI_REG_AWREADY <= awready_i;
 S_AXI_REG_WREADY  <= write_reg_req;
 S_AXI_REG_BRESP   <= s_axi_reg_bresp_reg;

 S_AXI_REG_ARREADY <= arready_i;
 S_AXI_REG_RVALID  <= rvalid;
 S_AXI_REG_RRESP   <= s_axi_reg_rresp_reg;

 -- AWREADY is enabled only if valid write request and no read request 
 awready_i <= (not write_reg_req) and not (S_AXI_REG_ARVALID or read_reg_req or rvalid);
 
 -- ARREADY is enabled only if valid read request and no current write request 
 arready_i <= not(rvalid or read_reg_req) and not (write_reg_req);

-------------------------------------------------------------------------------
-- Process READ_REQUEST_P to generate read request
-------------------------------------------------------------------------------
      READ_REQUEST_P: process (S_AXI_ACLK) is
      begin
          if (S_AXI_ACLK'event and S_AXI_ACLK = '1') then
              if (S_AXI_ARESETN=RST_ACTIVE) then
                  read_reg_req <= '0';
              elsif (S_AXI_REG_ARVALID = '1' and arready_i = '1') then   
                  read_reg_req <= '1';
              elsif (axi_lite_ip2bus_rdack_i = '1') then
                  read_reg_req <= '0';
              end if;
          end if;
      end process READ_REQUEST_P;
-------------------------------------------------------------------------------
-- Process WRITE_REQUEST_P to generate Write request on the IPIC
-------------------------------------------------------------------------------
      WRITE_REQUEST_P: process (S_AXI_ACLK) is
      begin
          if (S_AXI_ACLK'event and S_AXI_ACLK = '1') then
              if (S_AXI_ARESETN=RST_ACTIVE) then
                  write_reg_req <= '0';
              elsif (S_AXI_REG_AWVALID = '1' and awready_i = '1') then   
                  write_reg_req <= '1';
              elsif (axi_lite_ip2bus_wrack_i = '1') then
                  write_reg_req <= '0';
              end if;
          end if;
      end process WRITE_REQUEST_P;
-------------------------------------------------------------------------------
-- Process ADDR_GEN_P to generate bus2ip_addr for read/write
-------------------------------------------------------------------------------
   PSRAM_PARITY_ADDR_REG_GEN : if (GLOBAL_PSRAM_MEM = 1) generate
   ------------------------
   -----
   begin-- *
   -----
      ADDR_GEN_P: process (S_AXI_ACLK) is
      begin
          if (S_AXI_ACLK'event and S_AXI_ACLK = '1') then
              if (S_AXI_ARESETN=RST_ACTIVE) then
                  bus2ip_addr_lite_reg(4 downto 2) <= (others=>'0');
              elsif (S_AXI_REG_ARVALID = '1' and arready_i = '1') then   
                  bus2ip_addr_lite_reg(4 downto 2) <= S_AXI_REG_ARADDR(4 downto 2);
              elsif (S_AXI_REG_AWVALID = '1' and awready_i = '1') then   
                  bus2ip_addr_lite_reg(4 downto 2) <= S_AXI_REG_AWADDR(4 downto 2);
              end if;
          end if;
      end process ADDR_GEN_P;
   
   end generate PSRAM_PARITY_ADDR_REG_GEN;
   ---------------------------------------
   NO_PSRAM_PARITY_ADDR_REG_GEN : if (GLOBAL_PSRAM_MEM = 0) generate
   ------------------------
   -----
   begin-- *
   -----
      ADDR_GEN_P: process (S_AXI_ACLK) is
      begin
          if (S_AXI_ACLK'event and S_AXI_ACLK = '1') then
              if (S_AXI_ARESETN=RST_ACTIVE) then
                  bus2ip_addr_lite_reg(3 downto 2) <= (others=>'0');
              elsif (S_AXI_REG_ARVALID = '1' and arready_i = '1') then   
                  bus2ip_addr_lite_reg(3 downto 2) <= S_AXI_REG_ARADDR(3 downto 2);
              elsif (S_AXI_REG_AWVALID = '1' and awready_i = '1') then   
                  bus2ip_addr_lite_reg(3 downto 2) <= S_AXI_REG_AWADDR(3 downto 2);
              end if;
          end if;
      end process ADDR_GEN_P;
   
   end generate NO_PSRAM_PARITY_ADDR_REG_GEN;
   ---------------------------------------
  --  -----------------------------------------------------------------------
  --  Process AXI_READ_OUTPUT_P to generate Write request on the IPIC
  --  -----------------------------------------------------------------------
      AXI_READ_OUTPUT_P: process (S_AXI_ACLK) is
      begin
          if (S_AXI_ACLK'event and S_AXI_ACLK = '1') then
              if (S_AXI_ARESETN=RST_ACTIVE) then
                  S_AXI_REG_RDATA  <= (others =>'0');
              elsif (axi_lite_ip2bus_rdack_i = '1') then
                  S_AXI_REG_RDATA  <= axi_lite_ip2bus_data_i;
              elsif(rvalid='0')then
                  S_AXI_REG_RDATA  <= (others =>'0');
              end if;
          end if;
      end process AXI_READ_OUTPUT_P;

  --  -----------------------------------------------------------------------
  --  Process READ_RVALID_P to generate Read valid
  --  -----------------------------------------------------------------------
      READ_RVALID_P: process (S_AXI_ACLK) is
      begin
          if (S_AXI_ACLK'event and S_AXI_ACLK = '1') then
              
              s_axi_reg_rresp_reg <= "00";
              
              if (S_AXI_ARESETN=RST_ACTIVE) then
                  rvalid <= '0';
              elsif (axi_lite_ip2bus_rdack_i = '1') then   
                  rvalid <= '1';
              elsif (S_AXI_REG_RREADY='1') then
                  rvalid <= '0';
              end if;
          end if;
      end process READ_RVALID_P;
--  -----------------------------------------------------------------------
  --  Process WRITE_BVALID_P to generate Write valid
  --  -----------------------------------------------------------------------
      WRITE_BVALID_P: process (S_AXI_ACLK) is
      begin
          if (S_AXI_ACLK'event and S_AXI_ACLK = '1') then
                 s_axi_reg_bresp_reg   <= "00";
              if (S_AXI_ARESETN=RST_ACTIVE) then
                  S_AXI_REG_BVALID  <= '0';
              elsif (axi_lite_ip2bus_wrack_i = '1') then   
                  S_AXI_REG_BVALID  <= '1';
              elsif (S_AXI_REG_BREADY='1') then
                  S_AXI_REG_BVALID  <= '0';
              end if;
          end if;
      end process WRITE_BVALID_P;
---------------------------------------------------------------------------------
 -----------------------------------------------------------------------------
                axi_lite_ip2bus_data_i  <= axi_lite_ip2bus_data1  or
                                           axi_lite_ip2bus_data2;

                axi_lite_ip2bus_rdack_i <= axi_lite_ip2bus_rdack1 or
                                           axi_lite_ip2bus_rdack2;
                
                axi_lite_ip2bus_wrack_i <= axi_lite_ip2bus_wrack1 or
                                           axi_lite_ip2bus_wrack2;

-----------------------------------------------------------------------------
-- PEAR_X_RD, Byte Parity Register Read Process
-----------------------------------------------------------------------------
-- Generation of Transfer Ack signal for one clock pulse
-----------------------------------------------------------------------------

NO_PARITY_ENABLED_REG_GEN : if (MEM_PARITY_ARRAY(0) = 0 and -- if all mentioned meories are not having
                                MEM_PARITY_ARRAY(1) = 0 and -- parity included, then there wont be any
                                MEM_PARITY_ARRAY(2) = 0 and -- local registers
                                MEM_PARITY_ARRAY(3) = 0) generate
-----
begin
------
             axi_lite_ip2bus_data1        <= (others => '0');
             axi_lite_ip2bus_rdack1       <= '0';
             axi_lite_ip2bus_wrack1       <= '0';

end generate NO_PARITY_ENABLED_REG_GEN;
---------------------------------------

-- PEAR_X_RD : If any of the memories are having parity enabled then local register may be
--             needed. 1-odd parity, 2-even parity
--------------
PARITY_ENABLED_REG_GEN : if  ( MEM_PARITY_ARRAY(0) /= 0 or -- if any of the memories are of
                               MEM_PARITY_ARRAY(1) /= 0 or -- having parity enables, then there
                               MEM_PARITY_ARRAY(2) /= 0 or -- is need of local registers
                               MEM_PARITY_ARRAY(3) /= 0
                             ) generate
 -----
 begin
 -----
   ------------------------------------------------------
   PERR_NUM_MEM_4_GEN: if C_NUM_BANKS_MEM = 4 generate
   ------------------
   begin
   -----
      
      FOUR_BANKS_PARITY_REG_RD_P : process (bus2ip_rdce_lite_cmb,
                                            PEAR_REG(0),
                                            PEAR_REG(1),
                                            PEAR_REG(2),
                                            PEAR_REG(3)
                                            ) is
      variable internal_bus2ip_rdack : std_logic_vector
           (((C_NUM_BANKS_MEM-1)+(4*GLOBAL_PSRAM_MEM)) downto 0);--(3 downto 0);
      -----
      begin
      -----
           internal_bus2ip_rdack := bus2ip_rdce_lite_cmb;
            -- defaults
           axi_lite_ip2bus_data1     <= (others => '0');
           axi_lite_ip2bus_rdack1    <= or_reduce(bus2ip_rdce_lite_cmb);
            case internal_bus2ip_rdack(3 downto 0) is 
               when "0001" => axi_lite_ip2bus_data1 <= PEAR_REG(0);
               when "0010" => axi_lite_ip2bus_data1 <= PEAR_REG(1);
               when "0100" => axi_lite_ip2bus_data1 <= PEAR_REG(2);
               when "1000" => axi_lite_ip2bus_data1 <= PEAR_REG(3);
               -- coverage off
               when others => null;
               -- coverage on
            end case;
      end process FOUR_BANKS_PARITY_REG_RD_P;
      ----------------------------------

      PARITY_ERR_REG_STORE_P: process (S_AXI_ACLK) is
      -----------------------
      -----  
      begin
      -----     
      --err_parity_bits := ip2bus_errack & parity_error_MEM;
      if (S_AXI_ACLK'EVENT and S_AXI_ACLK = '1') then
         if (S_AXI_ARESETN = '0') then
              for i in C_NUM_BANKS_MEM-1 downto 0 loop
                 PEAR_REG (i) <= (others => '0');
              end loop;
         else
            if (ip2bus_errack = '1') then
              case (parity_error_MEM) is
                when "00"     => PEAR_REG(0) <= parity_error_adrss;
                when "01"     => PEAR_REG(1) <= parity_error_adrss;
                when "10"     => PEAR_REG(2) <= parity_error_adrss;
                when "11"     => PEAR_REG(3) <= parity_error_adrss;
               -- coverage off
                when others   => NULL;
               -- coverage on
              end case;
            else
                PEAR_REG(0) <= PEAR_REG(0);
                PEAR_REG(1) <= PEAR_REG(1);
                PEAR_REG(2) <= PEAR_REG(2);
                PEAR_REG(3) <= PEAR_REG(3);
            end if;
          end if;
      end if;
      end process PARITY_ERR_REG_STORE_P;
   end generate PERR_NUM_MEM_4_GEN;
   ------------------------------------------------------

   ------------------------------------------------------      
   PERR_NUM_MEM_3_GEN: if C_NUM_BANKS_MEM = 3 generate
   ------------------
   begin
   -----
      THREE_BANKS_PARITY_REG_RD_P : process (bus2ip_rdce_lite_cmb,
                                             PEAR_REG(0),
                                             PEAR_REG(1),
                                             PEAR_REG(2)
                                             ) is
      variable internal_bus2ip_rdack : std_logic_vector
           (((C_NUM_BANKS_MEM-1)+(4*GLOBAL_PSRAM_MEM)) downto 0);--(3 downto 0);
      -----
      begin
      -----
            internal_bus2ip_rdack := bus2ip_rdce_lite_cmb;
            -- defaults
            axi_lite_ip2bus_rdack1    <= or_reduce(bus2ip_rdce_lite_cmb);
            axi_lite_ip2bus_data1     <= (others => '0');
            case internal_bus2ip_rdack(2 downto 0) is 
               when "001" => axi_lite_ip2bus_data1 <= PEAR_REG(0);
               when "010" => axi_lite_ip2bus_data1 <= PEAR_REG(1);
               when "100" => axi_lite_ip2bus_data1 <= PEAR_REG(2);
               -- coverage off
               when others => null;
               -- coverage on
            end case;
      end process THREE_BANKS_PARITY_REG_RD_P;
      ----------------------------------------
      
      PARITY_ERR_REG_STORE_P: process (S_AXI_ACLK) is
      -----------------------
      --variable err_parity_bits : std_logic_vector(2 downto 0);
      -----  
      begin
      -----     
      if (S_AXI_ACLK'EVENT and S_AXI_ACLK = '1') then
         if (S_AXI_ARESETN = '0') then
              for i in C_NUM_BANKS_MEM-1 downto 0 loop
                 PEAR_REG (i) <= (others => '0');
              end loop;
         else
            if (ip2bus_errack = '1') then
              case (parity_error_MEM) is
                when "00"     => PEAR_REG(0) <= parity_error_adrss;
                when "01"     => PEAR_REG(1) <= parity_error_adrss;
                when "10"     => PEAR_REG(2) <= parity_error_adrss;
               -- coverage off
                when others   => NULL;
               -- coverage on
              end case;
            else
                PEAR_REG(0) <= PEAR_REG(0);
                PEAR_REG(1) <= PEAR_REG(1);
                PEAR_REG(2) <= PEAR_REG(2);
            end if;
          end if;
      end if;
      end process PARITY_ERR_REG_STORE_P;
   end generate PERR_NUM_MEM_3_GEN;
   ------------------------------------------------------

   ------------------------------------------------------      
   PERR_NUM_MEM_2_GEN: if C_NUM_BANKS_MEM = 2 generate
   ------------------
   begin
   -----
      TWO_BANKS_PARITY_REG_RD_P : process (bus2ip_rdce_lite_cmb,
                                           PEAR_REG(0),
                                           PEAR_REG(1)
                                           ) is
      variable internal_bus2ip_rdack : std_logic_vector
           (((C_NUM_BANKS_MEM-1)+(4*GLOBAL_PSRAM_MEM)) downto 0);--(3 downto 0);
      -----
      begin
      -----
            internal_bus2ip_rdack := bus2ip_rdce_lite_cmb;
            -- defaults
            axi_lite_ip2bus_data1 <= (others => '0');
            axi_lite_ip2bus_rdack1    <= or_reduce(bus2ip_rdce_lite_cmb);
            case internal_bus2ip_rdack(1 downto 0) is 
               when "01" => axi_lite_ip2bus_data1 <= PEAR_REG(0);
               when "10" => axi_lite_ip2bus_data1 <= PEAR_REG(1);
               -- coverage off
               when others => null;
               -- coverage on
            end case;
      end process TWO_BANKS_PARITY_REG_RD_P;
      ----------------------------------------

      PARITY_ERR_REG_STORE_P: process (S_AXI_ACLK) is
      -----------------------
      --variable err_parity_bits : std_logic_vector(2 downto 0);
      -----  
      begin
      -----     
      if (S_AXI_ACLK'EVENT and S_AXI_ACLK = '1') then
         if (S_AXI_ARESETN = '0') then
              for i in C_NUM_BANKS_MEM-1 downto 0 loop
                 PEAR_REG (i) <= (others => '0');
              end loop;
         else
            if (ip2bus_errack = '1') then
              case (parity_error_MEM) is
                when "00"     => PEAR_REG(0) <= parity_error_adrss;
                when "01"     => PEAR_REG(1) <= parity_error_adrss;
                when others   => NULL;
              end case;
            else
                PEAR_REG(0) <= PEAR_REG(0);
                PEAR_REG(1) <= PEAR_REG(1);
            end if;
          end if;
      end if;
      end process PARITY_ERR_REG_STORE_P;
   end generate PERR_NUM_MEM_2_GEN;
   ------------------------------------------------------

   ------------------------------------------------------      
   PERR_NUM_MEM_1_GEN: if C_NUM_BANKS_MEM = 1 generate
   ------------------
      begin
      -----
      ONE_BANKS_PARITY_REG_RD_P : process (bus2ip_rdce_lite_cmb,
                                           PEAR_REG(0)
                                           ) is
      variable internal_bus2ip_rdack : std_logic;
      -----
      begin
      -----
            internal_bus2ip_rdack := or_reduce(bus2ip_rdce_lite_cmb);
            -- defaults
            axi_lite_ip2bus_data1     <= (others => '0');
            axi_lite_ip2bus_rdack1    <= or_reduce(bus2ip_rdce_lite_cmb);
            case internal_bus2ip_rdack is 
               when '1' => axi_lite_ip2bus_data1 <= PEAR_REG(0);
               -- coverage off
               when others => null;
               -- coverage on
            end case;
      end process ONE_BANKS_PARITY_REG_RD_P;
      ----------------------------------------

      PARITY_ERR_REG_STORE_P: process (S_AXI_ACLK) is
      -----------------------
      -----  
      begin
      -----     
      if (S_AXI_ACLK'EVENT and S_AXI_ACLK = '1') then
         if (S_AXI_ARESETN = '0') then
              for i in C_NUM_BANKS_MEM-1 downto 0 loop
                 PEAR_REG (i) <= (others => '0');
              end loop;
         else
            if (ip2bus_errack = '1') then
              case (parity_error_MEM) is
                when "00"     => PEAR_REG(0) <= parity_error_adrss;
               -- coverage off
                when others   => NULL;
               -- coverage on
              end case;
            else
                PEAR_REG(0) <= PEAR_REG(0);
            end if;
          end if;
      end if;
      end process PARITY_ERR_REG_STORE_P;
   end generate PERR_NUM_MEM_1_GEN;
   ------------------------------------------------------

end generate PARITY_ENABLED_REG_GEN;
------------------------------------

  -----------------------------------------------------------------------------
  -- PCR_X_RD, Byte Parity Register Read Process
  -----------------------------------------------------------------------------
  -- Generation of Transfer Ack signal for one clock pulse
  -----------------------------------------------------------------------------
NO_PSRAM_CONFIG_REG_GEN: if (GLOBAL_PSRAM_MEM = 0) generate
------------------------
   signal axi_lite_ip2bus_rdack2  : std_logic;

begin
-----
            axi_lite_ip2bus_data2        <= (others => '0');
            axi_lite_ip2bus_rdack2       <= '0';
            psram_page_mode              <= '1';
            Mem_CRE                      <= '0';
end generate NO_PSRAM_CONFIG_REG_GEN;
-------------------------------------

-- NO_PSRAM_CONFIG_REG_GEN : If any of the memories are defined with PSRAM, then there will
--               local register in the core.
----------------
PSRAM_CONFIG_REG_GEN: if (GLOBAL_PSRAM_MEM = 1) generate
--------------------
begin
-----

        PSRAM_CONFIG_REG_RD_PROCESS : process (bus2ip_rdce_lite_cmb,
                                               PCR_REG) is                    
        begin                                                    
        -- defaults                                              
        axi_lite_ip2bus_data2   <= (others => '0');              
        axi_lite_ip2bus_rdack2  <= or_reduce(bus2ip_rdce_lite_cmb(((C_NUM_BANKS_MEM-1)+(4*GLOBAL_PSRAM_MEM)) downto 0));                                                                  
        
        for i in C_NUM_BANKS_MEM-1 downto 0 loop                                     
              if( (bus2ip_rdce_lite_cmb(4+i)='1') and         
                  (MEM_TYPE_ARRAY(i)=4          )             
                 )then                                          
                 axi_lite_ip2bus_data2 <= PCR_REG(i);     
              end if;                                            
        end loop;                                                
        end process PSRAM_CONFIG_REG_RD_PROCESS;                              

        axi_lite_ip2bus_wrack2 <= or_reduce(bus2ip_wrce_lite_cmb(((C_NUM_BANKS_MEM-1)+(4*GLOBAL_PSRAM_MEM)) downto 0));

        PSRAM_CONFIG_REG_WR_PROCESS : process (S_AXI_ACLK) is
        begin
        if (S_AXI_ACLK'EVENT and S_AXI_ACLK = '1') then
           if (S_AXI_ARESETN = '0') then
                for i in C_NUM_BANKS_MEM-1 downto 0 loop
                   PCR_REG (i) <= X"0000_0024";
                end loop;
           else
              for i in C_NUM_BANKS_MEM-1 downto 0 loop
                 if((bus2ip_wrce_lite_cmb(4+i)='1') and
                    (MEM_TYPE_ARRAY(i) = 4   )
                    )then
                   PCR_REG(i) <= S_AXI_REG_WDATA;
                 else
                   PCR_REG(i) <= PCR_REG(i);    
                 end if;
              end loop;
           end if;
        end if;
        end process PSRAM_CONFIG_REG_WR_PROCESS;
        ----------------------------------------

      CRE_WR_PROCESS : process (S_AXI_ACLK) is
        begin
        -----
        if (S_AXI_ACLK'EVENT and S_AXI_ACLK = '1') then
                if (S_AXI_ARESETN = '0') then
                    Mem_CRE         <= '0';
                    psram_page_mode <= '1';
                else
        -- defaults
                    Mem_CRE         <= '0';
                    psram_page_mode <= '0';
                    for i in C_NUM_BANKS_MEM-1 downto 0 loop
                        if (temp_bus2ip_cs(i) = '1' ) then
                            Mem_CRE         <= PCR_REG(i)(25);
                            psram_page_mode <= PCR_REG(i)(31);
                        end if;
                    end loop;
                end if;
        end if;
      end process CRE_WR_PROCESS;
end generate PSRAM_CONFIG_REG_GEN;
-------------------------
end generate REG_EN_GEN;
-------------------------------------------------------------------------------

AXI_EMC_NATIVE_INTERFACE_I: entity axi_emc_v1_01_a.axi_emc_native_interface
   -- Generics to be set by user
    generic map(

        C_FAMILY                 => C_FAMILY                ,  
        C_S_AXI_MEM_ADDR_WIDTH   => C_S_AXI_MEM_ADDR_WIDTH  ,  
        C_S_AXI_MEM_DATA_WIDTH   => C_S_AXI_MEM_DATA_WIDTH  ,  
        C_S_AXI_MEM_ID_WIDTH     => C_S_AXI_MEM_ID_WIDTH    ,  
                                            
        C_S_AXI_MEM0_BASEADDR    => C_S_AXI_MEM0_BASEADDR   , 
        C_S_AXI_MEM0_HIGHADDR    => C_S_AXI_MEM0_HIGHADDR   , 
        C_S_AXI_MEM1_BASEADDR    => C_S_AXI_MEM1_BASEADDR   , 
        C_S_AXI_MEM1_HIGHADDR    => C_S_AXI_MEM1_HIGHADDR   , 
        C_S_AXI_MEM2_BASEADDR    => C_S_AXI_MEM2_BASEADDR   , 
        C_S_AXI_MEM2_HIGHADDR    => C_S_AXI_MEM2_HIGHADDR   , 
        C_S_AXI_MEM3_BASEADDR    => C_S_AXI_MEM3_BASEADDR   , 
        C_S_AXI_MEM3_HIGHADDR    => C_S_AXI_MEM3_HIGHADDR   ,
        AXI_ARD_ADDR_RANGE_ARRAY => AXI_ARD_ADDR_RANGE_ARRAY,
        AXI_ARD_NUM_CE_ARRAY     => AXI_ARD_NUM_CE_ARRAY    ,
        C_NUM_BANKS_MEM          => C_NUM_BANKS_MEM
        )
   port map(
    S_AXI_ACLK      =>  S_AXI_ACLK,    
    S_AXI_ARESETN   =>  S_AXI_ARESETN, 
--   -- AXI Write Address Channel Signals
    S_AXI_MEM_AWID               => S_AXI_MEM_AWID         ,
    S_AXI_MEM_AWADDR             => S_AXI_MEM_AWADDR       ,
    S_AXI_MEM_AWLEN              => S_AXI_MEM_AWLEN        ,
    S_AXI_MEM_AWSIZE             => S_AXI_MEM_AWSIZE       ,
    S_AXI_MEM_AWBURST            => S_AXI_MEM_AWBURST      ,
    S_AXI_MEM_AWLOCK             => S_AXI_MEM_AWLOCK       ,
    S_AXI_MEM_AWCACHE            => S_AXI_MEM_AWCACHE      ,
    S_AXI_MEM_AWPROT             => S_AXI_MEM_AWPROT       ,
    S_AXI_MEM_AWVALID            => S_AXI_MEM_AWVALID      ,
    S_AXI_MEM_AWREADY            => S_AXI_MEM_AWREADY      ,
--   -- AXI Write Channel Signals
    S_AXI_MEM_WDATA              => S_AXI_MEM_WDATA        ,
    S_AXI_MEM_WSTRB              => S_AXI_MEM_WSTRB        ,
    S_AXI_MEM_WLAST              => S_AXI_MEM_WLAST        ,
    S_AXI_MEM_WVALID             => S_AXI_MEM_WVALID       ,
    S_AXI_MEM_WREADY             => S_AXI_MEM_WREADY       ,
--   -- AXI Write Response Channel Signals                
    S_AXI_MEM_BID                => S_AXI_MEM_BID          ,
    S_AXI_MEM_BRESP              => S_AXI_MEM_BRESP        ,
    S_AXI_MEM_BVALID             => S_AXI_MEM_BVALID       ,
    S_AXI_MEM_BREADY             => S_AXI_MEM_BREADY       ,
--   -- AXI Read Address Channel Signals                  
    S_AXI_MEM_ARID               => S_AXI_MEM_ARID         ,
    S_AXI_MEM_ARADDR             => S_AXI_MEM_ARADDR       ,
    S_AXI_MEM_ARLEN              => S_AXI_MEM_ARLEN        ,
    S_AXI_MEM_ARSIZE             => S_AXI_MEM_ARSIZE       ,
    S_AXI_MEM_ARBURST            => S_AXI_MEM_ARBURST      ,
    S_AXI_MEM_ARLOCK             => S_AXI_MEM_ARLOCK       ,
    S_AXI_MEM_ARCACHE            => S_AXI_MEM_ARCACHE      ,
    S_AXI_MEM_ARPROT             => S_AXI_MEM_ARPROT       ,
    S_AXI_MEM_ARVALID            => S_AXI_MEM_ARVALID      ,
    S_AXI_MEM_ARREADY            => S_AXI_MEM_ARREADY      ,
--   -- AXI Read Data Channel Signals                    
    S_AXI_MEM_RID                => S_AXI_MEM_RID          ,
    S_AXI_MEM_RDATA              => S_AXI_MEM_RDATA        ,
    S_AXI_MEM_RRESP              => S_AXI_MEM_RRESP        ,
    S_AXI_MEM_RLAST              => S_AXI_MEM_RLAST        ,
    S_AXI_MEM_RVALID             => S_AXI_MEM_RVALID       ,
    S_AXI_MEM_RREADY             => S_AXI_MEM_RREADY       ,
-- IP Interconnect (IPIC) port signals ------------------------------------
      -- Controls to the IP/IPIF modules
    -- IP Interconnect (IPIC) port signals
    IP2Bus_Data                  => temp_ip2bus_data       ,
    IP2Bus_WrAck                 => IP2Bus_WrAck           ,
    IP2Bus_RdAck                 => IP2Bus_RdAck           ,
    IP2Bus_AddrAck               => IP2Bus_AddrAck         ,
    IP2Bus_Error                 => ip2bus_errack          ,
                                                  
    Bus2IP_Addr                  => bus2ip_addr_temp       ,
    Bus2IP_Data                  => temp_bus2ip_data       ,
    Bus2IP_RNW                   => Bus2IP_RNW             ,
    Bus2IP_BE                    => temp_bus2ip_be         ,
    Bus2IP_Burst                 => Bus2IP_Burst           ,
                                         
    Bus2IP_BurstLength           => bus2ip_burstlength     ,
    Bus2IP_RdReq                 => Bus2IP_RdReq_emc       ,
    Bus2IP_WrReq                 => Bus2IP_WrReq_emc       ,
    Bus2IP_CS                    => temp_bus2ip_cs         ,
                                                
    Bus2IP_RdCE                  => bus2ip_rdce            ,
    Bus2IP_WrCE                  => bus2ip_wrce            ,
    Type_of_xfer                 => Type_of_xfer
    );

    ---------------------------------------------------------------------------
     -- Miscellaneous assignments to match EMC controller to IPIC
    ---------------------------------------------------------------------------
    or_reduced_wrce <= or_reduce(bus2ip_wrce);
    RD_CE_PIPE_PROCESS : process(S_AXI_ACLK)
    begin
        if(S_AXI_ACLK'EVENT and S_AXI_ACLK = '1') then
                or_reduced_rdce_d1    <= or_reduce(bus2ip_rdce);
                bus2ip_wrreq_reg      <= or_reduced_wrce;
        end if;
    end process RD_CE_PIPE_PROCESS;
    original_wrce   <= or_reduced_wrce;
   
    bus2ip_wrreq_i  <= or_reduce(bus2ip_wrce);
    
    bus2ip_rdreq_i  <= or_reduce(bus2ip_rdce);
    bus2ip_cs_i     <= or_reduce(temp_bus2ip_cs);

    ---------------------------------------------------------------------------
     -- AXI EMC is little endian and EMC COMMON is still big endian, to make
     -- this interface work normally, we need to swap the Write and read data
     -- comming from and going to slave burst interface
    ---------------------------------------------------------------------------

    ENDIAN_BANKS_0 : if (C_NUM_BANKS_MEM = 1) generate
        bus2ip_cs(0)<= temp_bus2ip_cs(0);
    end generate ENDIAN_BANKS_0;

    ENDIAN_BANKS_1 : if (C_NUM_BANKS_MEM = 2) generate
        bus2ip_cs(0)<= temp_bus2ip_cs(0);
        bus2ip_cs(1)<= temp_bus2ip_cs(1);
    end generate ENDIAN_BANKS_1;

    ENDIAN_BANKS_2 : if (C_NUM_BANKS_MEM = 3) generate
        bus2ip_cs(0)<= temp_bus2ip_cs(0);
        bus2ip_cs(1)<= temp_bus2ip_cs(1);
        bus2ip_cs(2)<= temp_bus2ip_cs(2);
    end generate ENDIAN_BANKS_2;

    ENDIAN_BANKS_3 : if (C_NUM_BANKS_MEM = 4) generate
        bus2ip_cs(0)<= temp_bus2ip_cs(0);
        bus2ip_cs(1)<= temp_bus2ip_cs(1);
        bus2ip_cs(2)<= temp_bus2ip_cs(2);
        bus2ip_cs(3)<= temp_bus2ip_cs(3);
    end generate ENDIAN_BANKS_3;



    ENDIAN_CONVERSION_32 : if (C_S_AXI_MEM_DATA_WIDTH = 32) generate

        bus2ip_data(0 to 7)   <= temp_bus2ip_data(7 downto 0);
        bus2ip_data(8 to 15)  <= temp_bus2ip_data(15 downto 8);
        bus2ip_data(16 to 23) <= temp_bus2ip_data(23 downto 16);
        bus2ip_data(24 to 31) <= temp_bus2ip_data(31 downto 24);

        temp_ip2bus_data(7 downto 0)   <= ip2bus_data(0 to 7) ;
        temp_ip2bus_data(15 downto 8)  <= ip2bus_data(8 to 15) ;
        temp_ip2bus_data(23 downto 16) <= ip2bus_data(16 to 23);
        temp_ip2bus_data(31 downto 24) <= ip2bus_data(24 to 31);


        bus2ip_be(0) <= temp_bus2ip_be(0);
        bus2ip_be(1) <= temp_bus2ip_be(1);
        bus2ip_be(2) <= temp_bus2ip_be(2);
        bus2ip_be(3) <= temp_bus2ip_be(3);

        -- the below logic is to generate the lower 2 bits of address for 32
        -- bit data width
        temp_single_0 <= or_reduce(temp_bus2ip_be(1 downto 0));
        temp_single_1 <= or_reduce(temp_bus2ip_be(3 downto 0));


        bus2ip_addr_reg(2) <= ((not temp_bus2ip_be(0)) and 
                               (temp_bus2ip_be(1)
                                 OR 
                                 ((NOT temp_bus2ip_be(2)) and
                                     temp_bus2ip_be(3)    and
                                  (NOT temp_single_0)
                                 )
                               )
                              ) and Type_of_xfer;

        bus2ip_addr_reg(1) <= (((not temp_bus2ip_be(0)) and (not
                                temp_bus2ip_be(1))) and (temp_bus2ip_be(2) OR
                                temp_bus2ip_be(3)))and Type_of_xfer;

        bus2ip_addr <= bus2ip_addr_temp (0 to 29) & bus2ip_addr_reg (1 to 2);
     
     end generate ENDIAN_CONVERSION_32;


    ENDIAN_CONVERSION_64 : if (C_S_AXI_MEM_DATA_WIDTH = 64) generate


        bus2ip_data(0 to 7)   <= temp_bus2ip_data(7 downto 0);
        bus2ip_data(8 to 15)  <= temp_bus2ip_data(15 downto 8);
        bus2ip_data(16 to 23) <= temp_bus2ip_data(23 downto 16);
        bus2ip_data(24 to 31) <= temp_bus2ip_data(31 downto 24);

        bus2ip_data(32 to 39) <= temp_bus2ip_data(39 downto 32);
        bus2ip_data(40 to 47) <= temp_bus2ip_data(47 downto 40);
        bus2ip_data(48 to 55) <= temp_bus2ip_data(55 downto 48);
        bus2ip_data(56 to 63) <= temp_bus2ip_data(63 downto 56);

        temp_ip2bus_data(7 downto 0)   <= ip2bus_data(0 to 7) ;
        temp_ip2bus_data(15 downto 8)  <= ip2bus_data(8 to 15) ;
        temp_ip2bus_data(23 downto 16) <= ip2bus_data(16 to 23);
        temp_ip2bus_data(31 downto 24) <= ip2bus_data(24 to 31);

        temp_ip2bus_data(39 downto 32) <= ip2bus_data(32 to 39);
        temp_ip2bus_data(47 downto 40) <= ip2bus_data(40 to 47);
        temp_ip2bus_data(55 downto 48) <= ip2bus_data(48 to 55);
        temp_ip2bus_data(63 downto 56) <= ip2bus_data(56 to 63);


        bus2ip_be(0) <= temp_bus2ip_be(0);
        bus2ip_be(1) <= temp_bus2ip_be(1);
        bus2ip_be(2) <= temp_bus2ip_be(2);
        bus2ip_be(3) <= temp_bus2ip_be(3);
        bus2ip_be(4) <= temp_bus2ip_be(4);
        bus2ip_be(5) <= temp_bus2ip_be(5);
        bus2ip_be(6) <= temp_bus2ip_be(6);
        bus2ip_be(7) <= temp_bus2ip_be(7);

        -- the below logic is to generate the lower 3 bits of address for 64 bit
        -- data width
        temp_single_0 <= or_reduce(temp_bus2ip_be(1 downto 0));
        temp_single_1 <= or_reduce(temp_bus2ip_be(3 downto 0));
        temp_single_2 <= or_reduce(temp_bus2ip_be(5 downto 0));


        bus2ip_addr_reg(2) <=((not temp_bus2ip_be(0)) and (temp_bus2ip_be(1)
                                OR ((NOT temp_bus2ip_be(2)) and
                                     temp_bus2ip_be(3)      and
                                     (NOT temp_single_0))
                                OR ((NOT temp_bus2ip_be(4)) and
                                     temp_bus2ip_be(5)      and
                                     (NOT temp_single_1))
                                OR ((NOT temp_bus2ip_be(6)) and
                                     temp_bus2ip_be(7)      and
                                     (NOT temp_single_2)))) and Type_of_xfer;

        bus2ip_addr_reg(1) <=((((not temp_bus2ip_be(0)) and
                               (not temp_bus2ip_be(1))) and (temp_bus2ip_be(2)
                               OR temp_bus2ip_be(3))) OR
                               (((not temp_bus2ip_be(4)) and
                               (not temp_bus2ip_be(5))) and (temp_bus2ip_be(6)
                               OR temp_bus2ip_be(7)) and (NOT temp_single_0)))
			       and Type_of_xfer;


        bus2ip_addr_reg(0) <= (not (temp_bus2ip_be(0) or temp_bus2ip_be(1) or
                                   temp_bus2ip_be(2) or temp_bus2ip_be(3)))
				   and Type_of_xfer;

        bus2ip_addr <= bus2ip_addr_temp (0 to 28) &
                                                bus2ip_addr_reg (0 to 2)
                                                when bus2ip_cs_i = '1' else
                                                (others => '0');

     end generate ENDIAN_CONVERSION_64;



  -----------------------------------------------------------------------------
  --RESET_TOGGLE: convert active low to active hig reset to rest of the core.
  -----------------------------------------------------------------------------
  RESET_TOGGLE: process (S_AXI_ACLK) is
  begin
       if(S_AXI_ACLK'event and S_AXI_ACLK = '1') then
           bus2ip_reset <= not(S_AXI_ARESETN);
       end if;
  end process RESET_TOGGLE;



   EMC_CTRL_I: entity emc_common_v5_01_a.emc
        generic map(
            C_NUM_BANKS_MEM                => C_NUM_BANKS_MEM,
            C_IPIF_DWIDTH                  => C_S_AXI_MEM_DATA_WIDTH,
            C_IPIF_AWIDTH                  => C_S_AXI_MEM_ADDR_WIDTH,

            C_MEM0_BASEADDR                => C_S_AXI_MEM0_BASEADDR,
            C_MEM0_HIGHADDR                => C_S_AXI_MEM0_HIGHADDR,
            C_MEM1_BASEADDR                => C_S_AXI_MEM1_BASEADDR,
            C_MEM1_HIGHADDR                => C_S_AXI_MEM1_HIGHADDR,
            C_MEM2_BASEADDR                => C_S_AXI_MEM2_BASEADDR,
            C_MEM2_HIGHADDR                => C_S_AXI_MEM2_HIGHADDR,
            C_MEM3_BASEADDR                => C_S_AXI_MEM3_BASEADDR,
            C_MEM3_HIGHADDR                => C_S_AXI_MEM3_HIGHADDR,

            C_PAGEMODE_FLASH_0             => C_PAGEMODE_FLASH_0,
            C_PAGEMODE_FLASH_1             => C_PAGEMODE_FLASH_1,
            C_PAGEMODE_FLASH_2             => C_PAGEMODE_FLASH_2,
            C_PAGEMODE_FLASH_3             => C_PAGEMODE_FLASH_3,

            C_INCLUDE_NEGEDGE_IOREGS       => C_INCLUDE_NEGEDGE_IOREGS,

            C_MEM0_WIDTH                   => C_MEM0_WIDTH,
            C_MEM1_WIDTH                   => C_MEM1_WIDTH,
            C_MEM2_WIDTH                   => C_MEM2_WIDTH,
            C_MEM3_WIDTH                   => C_MEM3_WIDTH,
            C_MAX_MEM_WIDTH                => C_MAX_MEM_WIDTH,

            C_MEM0_TYPE                    => C_MEM0_TYPE,
            C_MEM1_TYPE                    => C_MEM1_TYPE,
            C_MEM2_TYPE                    => C_MEM2_TYPE,
            C_MEM3_TYPE                    => C_MEM3_TYPE,

            C_PARITY_TYPE_0                => C_PARITY_TYPE_MEM_0,
            C_PARITY_TYPE_1                => C_PARITY_TYPE_MEM_1,
            C_PARITY_TYPE_2                => C_PARITY_TYPE_MEM_2,
            C_PARITY_TYPE_3                => C_PARITY_TYPE_MEM_3,

            C_INCLUDE_DATAWIDTH_MATCHING_0 => C_INCLUDE_DATAWIDTH_MATCHING_0,
            C_INCLUDE_DATAWIDTH_MATCHING_1 => C_INCLUDE_DATAWIDTH_MATCHING_1,
            C_INCLUDE_DATAWIDTH_MATCHING_2 => C_INCLUDE_DATAWIDTH_MATCHING_2,
            C_INCLUDE_DATAWIDTH_MATCHING_3 => C_INCLUDE_DATAWIDTH_MATCHING_3,

            -- Memory read and write access times for all memory banks
            C_BUS_CLOCK_PERIOD_PS          => C_AXI_CLK_PERIOD_PS,

            C_SYNCH_MEM_0                  => C_SYNCH_MEM_0,
            C_SYNCH_PIPEDELAY_0            => C_SYNCH_PIPEDELAY_0,
            C_TCEDV_PS_MEM_0               => C_TCEDV_PS_MEM_0,
            C_TAVDV_PS_MEM_0               => C_TAVDV_PS_MEM_0,
            C_TPACC_PS_FLASH_0             => C_TPACC_PS_FLASH_0,
            C_THZCE_PS_MEM_0               => C_THZCE_PS_MEM_0,
            C_THZOE_PS_MEM_0               => C_THZOE_PS_MEM_0,
            C_TWC_PS_MEM_0                 => C_TWC_PS_MEM_0,
            C_TWP_PS_MEM_0                 => C_TWP_PS_MEM_0,
            C_TWPH_PS_MEM_0                => C_TWPH_PS_MEM_0,
            C_TLZWE_PS_MEM_0               => C_TLZWE_PS_MEM_0,

            C_SYNCH_MEM_1                  => C_SYNCH_MEM_1,
            C_SYNCH_PIPEDELAY_1            => C_SYNCH_PIPEDELAY_1,
            C_TCEDV_PS_MEM_1               => C_TCEDV_PS_MEM_1,
            C_TAVDV_PS_MEM_1               => C_TAVDV_PS_MEM_1,
            C_TPACC_PS_FLASH_1             => C_TPACC_PS_FLASH_1,
            C_THZCE_PS_MEM_1               => C_THZCE_PS_MEM_1,
            C_THZOE_PS_MEM_1               => C_THZOE_PS_MEM_1,
            C_TWC_PS_MEM_1                 => C_TWC_PS_MEM_1,
            C_TWP_PS_MEM_1                 => C_TWP_PS_MEM_1,
            C_TWPH_PS_MEM_1                => C_TWPH_PS_MEM_1,
            C_TLZWE_PS_MEM_1               => C_TLZWE_PS_MEM_1,

            C_SYNCH_MEM_2                  => C_SYNCH_MEM_2,
            C_SYNCH_PIPEDELAY_2            => C_SYNCH_PIPEDELAY_2,
            C_TCEDV_PS_MEM_2               => C_TCEDV_PS_MEM_2,
            C_TAVDV_PS_MEM_2               => C_TAVDV_PS_MEM_2,
            C_TPACC_PS_FLASH_2             => C_TPACC_PS_FLASH_2,
            C_THZCE_PS_MEM_2               => C_THZCE_PS_MEM_2,
            C_THZOE_PS_MEM_2               => C_THZOE_PS_MEM_2,
            C_TWC_PS_MEM_2                 => C_TWC_PS_MEM_2,
            C_TWP_PS_MEM_2                 => C_TWP_PS_MEM_2,
            C_TWPH_PS_MEM_2                => C_TWPH_PS_MEM_2,
            C_TLZWE_PS_MEM_2               => C_TLZWE_PS_MEM_2,

            C_SYNCH_MEM_3                  => C_SYNCH_MEM_3,
            C_SYNCH_PIPEDELAY_3            => C_SYNCH_PIPEDELAY_3,
            C_TCEDV_PS_MEM_3               => C_TCEDV_PS_MEM_3,
            C_TAVDV_PS_MEM_3               => C_TAVDV_PS_MEM_3,
            C_TPACC_PS_FLASH_3             => C_TPACC_PS_FLASH_3,
            C_THZCE_PS_MEM_3               => C_THZCE_PS_MEM_3,
            C_THZOE_PS_MEM_3               => C_THZOE_PS_MEM_3,
            C_TWC_PS_MEM_3                 => C_TWC_PS_MEM_3,
            C_TWP_PS_MEM_3                 => C_TWP_PS_MEM_3,
            C_TWPH_PS_MEM_3                => C_TWPH_PS_MEM_3,
            C_TLZWE_PS_MEM_3               => C_TLZWE_PS_MEM_3
        )
        port map (
            Bus2IP_Clk         => S_AXI_ACLK,
            RdClk              => RdClk,
            Bus2IP_Reset       => Bus2IP_Reset,

            -- Bus and IPIC Interface signals
            Bus2IP_Addr        => bus2ip_addr,
            Bus2IP_BE          => bus2ip_be,
            Bus2IP_Data        => bus2ip_data,
            Bus2IP_RNW         => bus2ip_rnw,
            Bus2IP_Burst       => bus2ip_burst,
            Bus2IP_WrReq       => bus2ip_wrreq_i,
            Bus2IP_RdReq       => bus2ip_rdreq_i,

            Bus2IP_RdReq_emc   => Bus2IP_RdReq_emc,
            Bus2IP_WrReq_emc   => Bus2IP_WrReq_emc,

            Bus2IP_Mem_CS      => bus2ip_cs,
            Bus2IP_BurstLength => bus2ip_burstlength,

            IP2Bus_Data        => ip2bus_data,
            IP2Bus_errAck      => ip2bus_errack,
            IP2Bus_retry       => open,
            IP2Bus_toutSup     => open,
            IP2Bus_RdAck       => ip2bus_rdack,
            IP2Bus_WrAck       => ip2bus_wrack,
            IP2Bus_AddrAck     => ip2bus_addrack,

            parity_error_adrss => parity_error_adrss, -- 32 bit
            parity_error_mem   => parity_error_MEM,   -- 2 bit
            Type_of_xfer       => Type_of_xfer,
            psram_page_mode    => psram_page_mode,

            original_wrce           => original_wrce,
            -- Memory signals
            Mem_A              => mem_a_i,
            Mem_DQ_I           => mem_dq_i_i,
            Mem_DQ_O           => mem_dq_o_i,
            Mem_DQ_T           => mem_dq_t_i,
            Mem_DQ_PRTY_I      => mem_dq_parity_i_i,
            Mem_DQ_PRTY_O      => mem_dq_parity_o_i,
            Mem_DQ_PRTY_T      => mem_dq_parity_t_i,
            Mem_CEN            => mem_cen_i,
            Mem_OEN            => mem_oen_i,
            Mem_WEN            => mem_wen_i,
            Mem_QWEN           => mem_qwen_i,
            Mem_BEN            => mem_ben_i,
            Mem_RPN            => Mem_RPN,
            Mem_CE             => mem_ce_i,
            Mem_ADV_LDN        => mem_adv_ldn_i,
            Mem_LBON           => Mem_LBON,
            Mem_CKEN           => mem_cken_i,
            Mem_RNW            => Mem_RNW
        );

end implementation;
