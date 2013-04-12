-------------------------------------------------------------------------------
-- uartlite_core - entity/architecture pair
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
-- Filename:        uartlite_core.vhd
-- Version:         v1.01.a
-- Description:     UART Lite core for implementing UART logic
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
-- ~~~~~~
--  20/09/20    SK 
--  - Updated the version as AXI Lite IPIF version is updated. 
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

library axi_uartlite_v1_01_a;
-- baudrate refered from axi_uartlite_v1_01_a
use axi_uartlite_v1_01_a.baudrate;
-- uartlite_rx refered from axi_uartlite_v1_01_a
use axi_uartlite_v1_01_a.uartlite_rx;
-- uartlite_tx refered from axi_uartlite_v1_01_a
use axi_uartlite_v1_01_a.uartlite_tx;

-------------------------------------------------------------------------------
-- Port Declaration
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Definition of Generics :
-------------------------------------------------------------------------------
-- UART Lite generics
--  C_DATA_BITS           -- The number of data bits in the serial frame
--  C_S_AXI_ACLK_FREQ_HZ  -- System clock frequency driving UART lite
--                           peripheral in Hz
--  C_BAUDRATE            -- Baud rate of UART Lite in bits per second
--  C_USE_PARITY          -- Determines whether parity is used or not
--  C_ODD_PARITY          -- If parity is used determines whether parity
--                           is even or odd
-- System generics
--  C_FAMILY              -- Xilinx FPGA Family
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Definition of Ports :
-------------------------------------------------------------------------------
-- System Signals
--  Clk                   --  Clock signal
--  Rst                   --  Reset signal
-- Slave attachment interface
--  bus2ip_data           --  bus2ip data signal
--  bus2ip_rdce           --  bus2ip read CE
--  bus2ip_wrce           --  bus2ip write CE
--  ip2bus_rdack          --  ip2bus read acknowledgement
--  ip2bus_wrack          --  ip2bus write acknowledgement
--  ip2bus_error          --  ip2bus error
--  SIn_DBus              --  ip2bus data
-- UART Lite interface
--  RX                    --  Receive Data
--  TX                    --  Transmit Data
--  Interrupt             --  UART Interrupt
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--                  Entity Section
-------------------------------------------------------------------------------
entity uartlite_core is
  generic
   (
    C_FAMILY            : string               := "virtex6";
    C_S_AXI_ACLK_FREQ_HZ: integer              := 100_000_000;
    C_BAUDRATE          : integer              := 9600;
    C_DATA_BITS         : integer range 5 to 8 := 8;
    C_USE_PARITY        : integer range 0 to 1 := 0;
    C_ODD_PARITY        : integer range 0 to 1 := 0
   );
  port
   (
    Clk          : in  std_logic;
    Reset        : in  std_logic;
    -- IPIF signals
    bus2ip_data  : in  std_logic_vector(0 to 7);
    bus2ip_rdce  : in  std_logic_vector(0 to 3);
    bus2ip_wrce  : in  std_logic_vector(0 to 3);
    bus2ip_cs    : in  std_logic;
    ip2bus_rdack : out std_logic;
    ip2bus_wrack : out std_logic;
    ip2bus_error : out std_logic;
    SIn_DBus     : out std_logic_vector(0 to 7);
    -- UART signals
    RX           : in  std_logic;
    TX           : out std_logic;
    Interrupt    : out std_logic
   );
end entity uartlite_core;

-------------------------------------------------------------------------------
-- Architecture Section
-------------------------------------------------------------------------------
architecture RTL of uartlite_core is

    ---------------------------------------------------------------------------
    -- function declarations
    ---------------------------------------------------------------------------

    function CALC_RATIO ( C_S_AXI_ACLK_FREQ_HZ : integer;
                          C_BAUDRATE         : integer ) return Integer is
                          
       constant C_BAUDRATE_16_BY_2: integer := (16 * C_BAUDRATE) / 2;
       constant REMAINDER         : integer := 
                                    C_S_AXI_ACLK_FREQ_HZ rem (16 * C_BAUDRATE);
       constant RATIO             : integer := 
                                     C_S_AXI_ACLK_FREQ_HZ / (16 * C_BAUDRATE);   

    begin
        if (C_BAUDRATE_16_BY_2 < REMAINDER) then
            return (RATIO + 1);
        else  
            return RATIO;
        end if;
    end function CALC_RATIO;

   
    ---------------------------------------------------------------------------
    -- Constant declarations
    ---------------------------------------------------------------------------

    constant RATIO : integer := CALC_RATIO( C_S_AXI_ACLK_FREQ_HZ, C_BAUDRATE);

    ---------------------------------------------------------------------------
    -- Signal declarations
    ---------------------------------------------------------------------------
    -- Read Only
    signal status_reg : std_logic_vector(0 to 7) := (others => '0');

    -- bit 7 rx_Data_Present
    -- bit 6 rx_Buffer_Full
    -- bit 5 tx_Buffer_Empty
    -- bit 4 tx_Buffer_Full
    -- bit 3 enable_interrupts
    -- bit 2 Overrun Error
    -- bit 1 Frame Error
    -- bit 0 Parity Error (If C_USE_PARITY is true, otherwise '0')

    -- Write Only
    -- Below mentioned bits belong to Control Register and are declared as
    -- signals below
    -- bit 0-2 Dont'Care
    -- bit 3   enable_interrupts
    -- bit 4-5 Dont'Care
    -- bit 6   Reset_RX_FIFO
    -- bit 7   Reset_TX_FIFO

    signal en_16x_Baud         : std_logic;
    signal enable_interrupts   : std_logic;
    signal reset_RX_FIFO       : std_logic;
    signal rx_Data             : std_logic_vector(0 to C_DATA_BITS-1);
    signal rx_Data_Present     : std_logic;
    signal rx_Buffer_Full      : std_logic;
    signal rx_Frame_Error      : std_logic;
    signal rx_Overrun_Error    : std_logic;
    signal rx_Parity_Error     : std_logic;
    signal clr_Status          : std_logic;
    signal reset_TX_FIFO       : std_logic;
    signal tx_Buffer_Full      : std_logic;
    signal tx_Buffer_Empty     : std_logic;
    signal tx_Buffer_Empty_Pre : std_logic;

begin  -- architecture IMP

    ---------------------------------------------------------------------------
    -- Generating the acknowledgement and error signals
    ---------------------------------------------------------------------------

    ip2bus_rdack <= bus2ip_rdce(0) or bus2ip_rdce(2) or bus2ip_rdce(1) 
                    or bus2ip_rdce(3);

    ip2bus_wrack <= bus2ip_wrce(1) or bus2ip_wrce(3) or bus2ip_wrce(0) 
                    or bus2ip_wrce(2);

    ip2bus_error <= ((bus2ip_rdce(0) and not rx_Data_Present) or
                     (bus2ip_wrce(1) and tx_Buffer_Full) );
    -------------------------------------------------------------------------
    -- BAUD_RATE_I : Instansiating the baudrate module
    -------------------------------------------------------------------------
    BAUD_RATE_I : entity axi_uartlite_v1_01_a.baudrate
        generic map
         (
          C_RATIO      => RATIO
         )
        port map
         (
          Clk          => Clk,
          Reset        => Reset,
          EN_16x_Baud  => en_16x_Baud
         );

    -------------------------------------------------------------------------
    -- Status register handling
    -------------------------------------------------------------------------
    status_reg(7) <= rx_Data_Present;
    status_reg(6) <= rx_Buffer_Full;
    status_reg(5) <= tx_Buffer_Empty;
    status_reg(4) <= tx_Buffer_Full;
    status_reg(3) <= enable_interrupts;

    -------------------------------------------------------------------------
    -- CLEAR_STATUS_REG : Process to clear status register
    -------------------------------------------------------------------------
    CLEAR_STATUS_REG : process (Clk) is
    begin  -- process Ctrl_Reg_DFF
        if Clk'event and Clk = '1' then
            if Reset = '1' then
                clr_Status <= '0';
            else
                clr_Status <= bus2ip_rdce(2);
            end if;
        end if;
    end process CLEAR_STATUS_REG;

    -------------------------------------------------------------------------
    -- Process to register rx_Overrun_Error
    -------------------------------------------------------------------------
    RX_OVERRUN_ERROR_DFF: Process (Clk) is
    begin
        if (Clk'event and Clk = '1') then
            if ((Reset = '1') or (clr_Status = '1')) then
                status_reg(2) <= '0';
            elsif (rx_Overrun_Error = '1') then
                status_reg(2) <= '1';
            end if;
        end if;
    end process RX_OVERRUN_ERROR_DFF;

    -------------------------------------------------------------------------
    -- Process to register rx_Frame_Error
    -------------------------------------------------------------------------
    RX_FRAME_ERROR_DFF: Process (Clk) is
    begin
        if (Clk'event and Clk = '1') then
            if (Reset = '1') then
                status_reg(1) <= '0';
            else
                if (clr_Status = '1') then
                    status_reg(1) <= '0';
                elsif (rx_Frame_Error = '1') then
                    status_reg(1) <= '1';
                end if;
            end if;
        end if;
    end process RX_FRAME_ERROR_DFF;

    -------------------------------------------------------------------------
    -- If C_USE_PARITY = 1, register rx_Parity_Error
    -------------------------------------------------------------------------
    USING_PARITY : if (C_USE_PARITY = 1) generate
        RX_PARITY_ERROR_DFF: Process (Clk) is
        begin
            if (Clk'event and Clk = '1') then
                if (Reset = '1') then
                    status_reg(0) <= '0';
                else
                   if (clr_Status = '1') then
                       status_reg(0) <= '0';
                   elsif (rx_Parity_Error = '1') then
                       status_reg(0) <= '1';
                   end if;
                end if;
             end if;
        end process RX_PARITY_ERROR_DFF;
    end generate USING_PARITY;

    -------------------------------------------------------------------------
    -- NO_PARITY : If C_USE_PARITY = 0, rx_Parity_Error bit is not present
    -------------------------------------------------------------------------
    NO_PARITY : if (C_USE_PARITY = 0) generate
        status_reg(0) <= '0';
    end generate NO_PARITY;

    -------------------------------------------------------------------------
    -- CTRL_REG_DFF : Control Register Handling 
    -------------------------------------------------------------------------
    CTRL_REG_DFF : process (Clk) is
    begin  -- process Ctrl_Reg_DFF
        if Clk'event and Clk = '1' then -- rising clock edge
            if Reset = '1' then         -- synchronous reset (active high)
                reset_TX_FIFO     <= '1';
                reset_RX_FIFO     <= '1';
                enable_interrupts <= '0';
            elsif (bus2ip_wrce(3) = '1') then
                reset_RX_FIFO     <= bus2ip_data(6);
                reset_TX_FIFO     <= bus2ip_data(7);
                enable_interrupts <= bus2ip_data(3);
            else
                reset_TX_FIFO <= '0';
                reset_RX_FIFO <= '0';
            end if;
        end if;
    end process CTRL_REG_DFF;

    -------------------------------------------------------------------------
    -- Interrupt handling
    -------------------------------------------------------------------------
    TX_BUFFER_EMPTY_DFF_I: Process (Clk) is
    begin
        if (Clk'event and Clk = '1') then -- rising clock edge
            if Reset = '1' then           -- synchronous reset (active high)
                tx_Buffer_Empty_Pre <= '0';
            else
               if (bus2ip_wrce(1) = '1') then
                   tx_Buffer_Empty_Pre <= '0';
               else
                   tx_Buffer_Empty_Pre <= tx_Buffer_Empty;
               end if;
            end if;
        end if;
    end process TX_BUFFER_EMPTY_DFF_I;

    -------------------------------------------------------------------------
    -- Interrupt register handling
    -------------------------------------------------------------------------
    INTERRUPT_DFF: process (Clk) is
    begin 
        if Clk'event and Clk = '1' then
            if Reset = '1' then         -- synchronous reset (active high)
                Interrupt <= '0';
            else 
                Interrupt <= enable_interrupts and 
                             (rx_Data_Present or (tx_Buffer_Empty and 
                                             not tx_Buffer_Empty_Pre));
            end if;
        end if;
    end process INTERRUPT_DFF;

    -------------------------------------------------------------------------
    -- READ_MUX : Read bus interface handling
    -------------------------------------------------------------------------
    READ_MUX : process (status_reg, bus2ip_rdce(2), bus2ip_rdce(0), rx_Data) is
    begin  -- process Read_Mux
        if (bus2ip_rdce(2) = '1') then
            SIn_DBus <= status_reg;
        elsif (bus2ip_rdce(0) = '1') then
            SIn_DBus((8-C_DATA_BITS) to 7) <= rx_Data;
        else
            SIn_DBus <= (others => '0');
        end if;
    end process READ_MUX;

    -------------------------------------------------------------------------
    -- UARTLITE_RX_I : Instansiating the receive module
    -------------------------------------------------------------------------
    UARTLITE_RX_I : entity axi_uartlite_v1_01_a.uartlite_rx
      generic map
       (
        C_FAMILY         => C_FAMILY,
        C_DATA_BITS      => C_DATA_BITS,
        C_USE_PARITY     => C_USE_PARITY,
        C_ODD_PARITY     => C_ODD_PARITY
       )
      port map
       (
        Clk              => Clk,
        Reset            => Reset,
        EN_16x_Baud      => en_16x_Baud,
        RX               => RX,
        Read_RX_FIFO     => bus2ip_rdce(0),
        Reset_RX_FIFO    => reset_RX_FIFO,
        RX_Data          => rx_Data,
        RX_Data_Present  => rx_Data_Present,
        RX_Buffer_Full   => rx_Buffer_Full,
        RX_Frame_Error   => rx_Frame_Error,
        RX_Overrun_Error => rx_Overrun_Error,
        RX_Parity_Error  => rx_Parity_Error
       );

    -------------------------------------------------------------------------
    -- UARTLITE_TX_I : Instansiating the transmit module
    -------------------------------------------------------------------------
    UARTLITE_TX_I : entity axi_uartlite_v1_01_a.uartlite_tx
      generic map
       (
        C_FAMILY        => C_FAMILY,
        C_DATA_BITS     => C_DATA_BITS,
        C_USE_PARITY    => C_USE_PARITY,
        C_ODD_PARITY    => C_ODD_PARITY
       )
      port map
       (
        Clk             => Clk,
        Reset           => Reset,
        EN_16x_Baud     => en_16x_Baud,
        TX              => TX,
        Write_TX_FIFO   => bus2ip_wrce(1),
        Reset_TX_FIFO   => reset_TX_FIFO,
        TX_Data         => bus2ip_data(8-C_DATA_BITS to 7),
        TX_Buffer_Full  => tx_Buffer_Full,
        TX_Buffer_Empty => tx_Buffer_Empty
       );

end architecture RTL;