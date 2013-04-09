-------------------------------------------------------------------------------
-- axi_uartlite - entity/architecture pair
-------------------------------------------------------------------------------
--
-- ***************************************************************************
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
-- Copyright 2010 Xilinx, Inc.
-- All rights reserved.
--
-- This disclaimer and copyright notice must be retained as part
-- of this file at all times.
-- ***************************************************************************
--
-------------------------------------------------------------------------------
-- Filename:        axi_uartlite.vhd
-- Version:         v1.01.a
-- Description:     AXI UART Lite Interface
--
-- VHDL-Standard:   VHDL'93
-------------------------------------------------------------------------------
-- Structure:   This section shows the hierarchical structure of axi_uartlite.
--
--              axi_uartlite.vhd
--                 --axi_lite_ipif.vhd
--                 --uartlite_core.vhd
--                    --uartlite_tx.vhd
--                    --uartlite_rx.vhd
--                    --baudrate.vhd
-------------------------------------------------------------------------------
-- Author:          USM
--
--  USM     07/22/09
-- ^^^^^^
--  - Initial release of v1.00.a
-- ~~~~~~
--  20/09/20    SK 
--  - 1. Updated the version as AXI Lite IPIF version is updated. 
--  - 2. constant C_DPHASE_TIMEOUT value changed from 4 to 0
-- ^^^^^^
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

library proc_common_v3_00_a;
-- SLV64_ARRAY_TYPE refered from ipif_pkg
use proc_common_v3_00_a.ipif_pkg.SLV64_ARRAY_TYPE;
-- INTEGER_ARRAY_TYPE refered from ipif_pkg
use proc_common_v3_00_a.ipif_pkg.INTEGER_ARRAY_TYPE;
-- calc_num_ce comoponent refered from ipif_pkg
use proc_common_v3_00_a.ipif_pkg.calc_num_ce;

library axi_lite_ipif_v1_01_a;
-- axi_lite_ipif refered from axi_lite_ipif_v1_01_a
    use axi_lite_ipif_v1_01_a.axi_lite_ipif;

library axi_uartlite_v1_01_a;
-- uartlite_core refered from axi_uartlite_v1_01_a
use axi_uartlite_v1_01_a.uartlite_core;

-------------------------------------------------------------------------------
-- Port Declaration
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Definition of Generics :
-------------------------------------------------------------------------------
-- System generics
--  C_FAMILY              -- Xilinx FPGA Family
--  C_S_AXI_ACLK_FREQ_HZ  -- System clock frequency driving UART lite
--                           peripheral in Hz
-- AXI generics
--  C_BASEADDR            -- Base address of the core
--  C_HIGHADDR            -- Permits alias of address space
--                           by making greater than xFFF
--  C_S_AXI_ADDR_WIDTH    -- Width of AXI Address Bus (in bits)
--  C_S_AXI_DATA_WIDTH    -- Width of the AXI Data Bus (in bits)
--
-- UART Lite generics
--  C_BAUDRATE            -- Baud rate of UART Lite in bits per second
--  C_DATA_BITS           -- The number of data bits in the serial frame
--  C_USE_PARITY          -- Determines whether parity is used or not
--  C_ODD_PARITY          -- If parity is used determines whether parity
--                           is even or odd
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Definition of Ports :
-------------------------------------------------------------------------------
--System signals
-- S_AXI_ACLK            -- AXI Clock
-- S_AXI_ARESETN         -- AXI Reset
-- Interrupt             --  UART Interrupt
--AXI signals
-- S_AXI_AWADDR          -- AXI Write address
-- S_AXI_AWVALID         -- Write address valid
-- S_AXI_AWREADY         -- Write address ready
-- S_AXI_WDATA           -- Write data
-- S_AXI_WSTRB           -- Write strobes
-- S_AXI_WVALID          -- Write valid
-- S_AXI_WREADY          -- Write ready
-- S_AXI_BRESP           -- Write response
-- S_AXI_BVALID          -- Write response valid
-- S_AXI_BREADY          -- Response ready
-- S_AXI_ARADDR          -- Read address
-- S_AXI_ARVALID         -- Read address valid
-- S_AXI_ARREADY         -- Read address ready
-- S_AXI_RDATA           -- Read data
-- S_AXI_RRESP           -- Read response
-- S_AXI_RVALID          -- Read valid
-- S_AXI_RREADY          -- Read ready
--UARTLite Interface Signals
--  RX                   --  Receive Data
--  TX                   --  Transmit Data
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--                  Entity Section
-------------------------------------------------------------------------------
entity axi_uartlite is
  generic
   (
--  -- System Parameter
    C_FAMILY              : string                        := "virtex6";
    C_S_AXI_ACLK_FREQ_HZ  : integer                       := 100_000_000;
--  -- AXI Parameters
    C_BASEADDR            : std_logic_vector(31 downto 0) := X"FFFF_FFFF";
    C_HIGHADDR            : std_logic_vector(31 downto 0) := X"0000_0000";
    C_S_AXI_ADDR_WIDTH    : integer range 32 to 36        := 32;
    C_S_AXI_DATA_WIDTH    : integer range 32 to 128       := 32;
--  -- UARTLite Parameters
    C_BAUDRATE            : integer                       := 9600;
    C_DATA_BITS           : integer range 5 to 8          := 8;
    C_USE_PARITY          : integer range 0 to 1          := 0;
    C_ODD_PARITY          : integer range 0 to 1          := 0
   );
  port
   (

-- System signals
      S_AXI_ACLK            : in  std_logic;
      S_AXI_ARESETN         : in  std_logic;
      Interrupt             : out std_logic;

-- AXI signals
      S_AXI_AWADDR          : in  std_logic_vector
                              (C_S_AXI_ADDR_WIDTH-1 downto 0);
      S_AXI_AWVALID         : in  std_logic;
      S_AXI_AWREADY         : out std_logic;
      S_AXI_WDATA           : in  std_logic_vector
                              (C_S_AXI_DATA_WIDTH-1 downto 0);
      S_AXI_WSTRB           : in  std_logic_vector
                              ((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
      S_AXI_WVALID          : in  std_logic;
      S_AXI_WREADY          : out std_logic;
      S_AXI_BRESP           : out std_logic_vector(1 downto 0);
      S_AXI_BVALID          : out std_logic;
      S_AXI_BREADY          : in  std_logic;
      S_AXI_ARADDR          : in  std_logic_vector
                              (C_S_AXI_ADDR_WIDTH-1 downto 0);
      S_AXI_ARVALID         : in  std_logic;
      S_AXI_ARREADY         : out std_logic;
      S_AXI_RDATA           : out std_logic_vector
                              (C_S_AXI_DATA_WIDTH-1 downto 0);
      S_AXI_RRESP           : out std_logic_vector(1 downto 0);
      S_AXI_RVALID          : out std_logic;
      S_AXI_RREADY          : in  std_logic;

-- UARTLite Interface Signals
      RX                    : in  std_logic;
      TX                    : out std_logic
   );

-------------------------------------------------------------------------------
-- Attributes
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
  -- Fan-Out attributes for XST
-------------------------------------------------------------------------------

    ATTRIBUTE MAX_FANOUT                   : string;
    ATTRIBUTE MAX_FANOUT  of S_AXI_ACLK    : signal is "10000";
    ATTRIBUTE MAX_FANOUT  of S_AXI_ARESETN : signal is "10000";

end entity axi_uartlite;

-------------------------------------------------------------------------------
-- Architecture Section
-------------------------------------------------------------------------------

architecture RTL of axi_uartlite is

    --------------------------------------------------------------------------
    -- Constant declarations
    --------------------------------------------------------------------------

    constant ZEROES                 : std_logic_vector(31 downto 0)
                                    := X"00000000";

    constant C_ARD_ADDR_RANGE_ARRAY : SLV64_ARRAY_TYPE :=
            (
              -- UARTLite registers Base Address
              ZEROES & C_BASEADDR,
              ZEROES & (C_BASEADDR or X"0000000F")
            );

    constant C_ARD_NUM_CE_ARRAY     : INTEGER_ARRAY_TYPE :=
            (
              0 => 4
            );

    constant C_S_AXI_MIN_SIZE       : std_logic_vector(31 downto 0)
                                    := X"0000000F";

    constant C_USE_WSTRB            : integer := 0;

    constant C_DPHASE_TIMEOUT       : integer := 0;

    --------------------------------------------------------------------------
    -- Signal declarations
    --------------------------------------------------------------------------
    signal bus2ip_clk    : std_logic;
    signal bus2ip_reset  : std_logic;
    signal bus2ip_resetn : std_logic;
    signal ip2bus_data   : std_logic_vector((C_S_AXI_DATA_WIDTH-1)  downto 0)
                           := (others  => '0');
    signal ip2bus_error  : std_logic := '0';
    signal ip2bus_wrack  : std_logic := '0';
    signal ip2bus_rdack  : std_logic := '0';
    signal bus2ip_data   : std_logic_vector
                           (C_S_AXI_DATA_WIDTH - 1 downto 0);
    signal bus2ip_cs     : std_logic_vector
                           (((C_ARD_ADDR_RANGE_ARRAY'LENGTH)/2)-1 downto 0);
    signal bus2ip_rdce   : std_logic_vector
                           (calc_num_ce(C_ARD_NUM_CE_ARRAY)-1 downto 0);
    signal bus2ip_wrce   : std_logic_vector
                           (calc_num_ce(C_ARD_NUM_CE_ARRAY)-1 downto 0);

begin  -- architecture IMP

    --------------------------------------------------------------------------
    -- RESET signal assignment - IPIC RESET is active low
    --------------------------------------------------------------------------

         bus2ip_reset <= not bus2ip_resetn;

    --------------------------------------------------------------------------
    -- ip2bus_data assignment - as core is using maximum upto 8 bits
    --------------------------------------------------------------------------

    ip2bus_data((C_S_AXI_DATA_WIDTH-1)  downto 8) <= (others => '0');

    --------------------------------------------------------------------------
    -- Instansiating the UART core
    --------------------------------------------------------------------------
    UARTLITE_CORE_I : entity axi_uartlite_v1_01_a.uartlite_core
      generic map
       (
        C_FAMILY             => C_FAMILY,
        C_S_AXI_ACLK_FREQ_HZ => C_S_AXI_ACLK_FREQ_HZ,
        C_BAUDRATE           => C_BAUDRATE,
        C_DATA_BITS          => C_DATA_BITS,
        C_USE_PARITY         => C_USE_PARITY,
        C_ODD_PARITY         => C_ODD_PARITY
       )
      port map
       (
        Clk          => bus2ip_clk,
        Reset        => bus2ip_reset,
        bus2ip_data  => bus2ip_data(7 downto 0),
        bus2ip_rdce  => bus2ip_rdce(3 downto 0),
        bus2ip_wrce  => bus2ip_wrce(3 downto 0),
        bus2ip_cs    => bus2ip_cs(0),
        ip2bus_rdack => ip2bus_rdack,
        ip2bus_wrack => ip2bus_wrack,
        ip2bus_error => ip2bus_error,
        SIn_DBus     => ip2bus_data(7 downto 0),
        RX           => RX,
        TX           => TX,
        Interrupt    => Interrupt
       );

    --------------------------------------------------------------------------
    -- Instantiate AXI lite IPIF
    --------------------------------------------------------------------------
    AXI_LITE_IPIF_I : entity axi_lite_ipif_v1_01_a.axi_lite_ipif
      generic map
       (
        C_FAMILY                  => C_FAMILY,
        C_S_AXI_ADDR_WIDTH        => C_S_AXI_ADDR_WIDTH,
        C_S_AXI_DATA_WIDTH        => C_S_AXI_DATA_WIDTH,
        C_S_AXI_MIN_SIZE          => C_S_AXI_MIN_SIZE,
        C_USE_WSTRB               => C_USE_WSTRB,
        C_DPHASE_TIMEOUT          => C_DPHASE_TIMEOUT,
        C_ARD_ADDR_RANGE_ARRAY    => C_ARD_ADDR_RANGE_ARRAY,
        C_ARD_NUM_CE_ARRAY        => C_ARD_NUM_CE_ARRAY
       )
     port map
       (
        S_AXI_ACLK          =>  S_AXI_ACLK,
        S_AXI_ARESETN       =>  S_AXI_ARESETN,
        S_AXI_AWADDR        =>  S_AXI_AWADDR,
        S_AXI_AWVALID       =>  S_AXI_AWVALID,
        S_AXI_AWREADY       =>  S_AXI_AWREADY,
        S_AXI_WDATA         =>  S_AXI_WDATA,
        S_AXI_WSTRB         =>  S_AXI_WSTRB,
        S_AXI_WVALID        =>  S_AXI_WVALID,
        S_AXI_WREADY        =>  S_AXI_WREADY,
        S_AXI_BRESP         =>  S_AXI_BRESP,
        S_AXI_BVALID        =>  S_AXI_BVALID,
        S_AXI_BREADY        =>  S_AXI_BREADY,
        S_AXI_ARADDR        =>  S_AXI_ARADDR,
        S_AXI_ARVALID       =>  S_AXI_ARVALID,
        S_AXI_ARREADY       =>  S_AXI_ARREADY,
        S_AXI_RDATA         =>  S_AXI_RDATA,
        S_AXI_RRESP         =>  S_AXI_RRESP,
        S_AXI_RVALID        =>  S_AXI_RVALID,
        S_AXI_RREADY        =>  S_AXI_RREADY,

     -- IP Interconnect (IPIC) port signals
        Bus2IP_Clk     => bus2ip_clk,
        Bus2IP_Resetn  => bus2ip_resetn,
        IP2Bus_Data    => ip2bus_data,
        IP2Bus_WrAck   => ip2bus_wrack,
        IP2Bus_RdAck   => ip2bus_rdack,
        IP2Bus_Error   => ip2bus_error,
        Bus2IP_Addr    => open,
        Bus2IP_Data    => bus2ip_data,
        Bus2IP_RNW     => open,
        Bus2IP_BE      => open,
        Bus2IP_CS      => bus2ip_cs,
        Bus2IP_RdCE    => bus2ip_rdce,
        Bus2IP_WrCE    => bus2ip_wrce
       );

end architecture RTL;