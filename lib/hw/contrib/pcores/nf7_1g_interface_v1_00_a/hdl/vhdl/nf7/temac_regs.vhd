-- 
-- File:
--       temac_regs.vhd
--
-- Library:
-- 		hw/contrib/pcores/nf7_1g_interface_v1_10_a
--
-- Module:
-- 	        register interface wrapper 
--
-- Author:
-- 		Jay Hirata
-- 
-- Description:
--              Register interface customized for use with Xilinx Tri-mode Ethernet MAC
--              This is used by C_MAC_SEL = 0 in nf7_1g_interface.v 
--
-- Copyright notice:
-- 		Copyright (C) 2013 Computer Measurement Laboratory, LLC
--
-- License:
--        This file is part of the NetFPGA 10G development base package.
--
--        This file is free code: you can redistribute it and/or modify it under
--        the terms of the GNU Lesser General Public License version 2.1 as
--        published by the Free Software Foundation.
--
--        This package is distributed in the hope that it will be useful, but
--        WITHOUT ANY WARRANTY; without even the implied warranty of
--        MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
--        Lesser General Public License for more details.
--
--        You should have received a copy of the GNU Lesser General Public
--        License along with the NetFPGA source package.  If not, see
--        http://www.gnu.org/licenses/.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library proc_common_v3_00_a;
use proc_common_v3_00_a.ipif_pkg.SLV64_ARRAY_TYPE;
use proc_common_v3_00_a.ipif_pkg.INTEGER_ARRAY_TYPE;
use proc_common_v3_00_a.ipif_pkg.calc_num_ce;

library axi_lite_ipif_v1_01_a;
use axi_lite_ipif_v1_01_a.axi_lite_ipif;

library nf7_1g_interface_v1_00_a;
use nf7_1g_interface_v1_00_a.cfg_core;

entity temac_regs is
    generic (
        C_FAMILY                        : string            := "kintex7";
        C_S_AXI_ADDR_WIDTH              : integer           := 5;
        C_S_AXI_DATA_WIDTH              : integer range 32 to 128   := 32;
        -- Default tx vector
        C_TX_PAUSE_MAC_ADDR             : integer           := 0;
        C_TX_MAX_FRAME_SIZE             : integer           := 1518;
        C_TX_MAX_FRAME_EN               : integer           := 0;
        C_TX_SPEED                      : integer           := 2;
        C_TX_IFG_ADJUST_EN              : integer           := 0;
        C_TX_HD_EN                      : integer           := 0;
        C_TX_FC_EN                      : integer           := 0;
        C_TX_JUMBO_EN                   : integer           := 0;
        C_TX_FCS_EN                     : integer           := 0;
        C_TX_VLAN_EN                    : integer           := 0;
        C_TX_EN                         : integer           := 0;
        C_TX_RESET                      : integer           := 1;
        -- Default rx vector
        C_RX_PAUSE_MAC_ADDR             : integer           := 0;
        C_RX_MAX_FRAME_SIZE             : integer           := 1518;
        C_RX_MAX_FRAME_EN               : integer           := 0;
        C_RX_SPEED                      : integer           := 2;
        C_RX_PROMISCUOUS_EN             : integer           := 1;
        C_RX_CONTROL_LEN_CHK_DIS        : integer           := 0;
        C_RX_LEN_TYPE_CHK_DIS           : integer           := 0;
        C_RX_HD_EN                      : integer           := 0;
        C_RX_FC_EN                      : integer           := 0;
        C_RX_JUMBO_EN                   : integer           := 0;
        C_RX_FCS_EN                     : integer           := 0;
        C_RX_VLAN_EN                    : integer           := 0;
        C_RX_EN                         : integer           := 0;
        C_RX_RESET                      : integer           := 1
    );
    port (
        S_AXI_ACLK                      : in    std_logic;
        S_AXI_ARESETN                   : in    std_logic;
        S_AXI_AWADDR                    : in    std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
        S_AXI_AWVALID                   : in    std_logic;
        S_AXI_AWREADY                   : out   std_logic;
        S_AXI_WDATA                     : in    std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        S_AXI_WSTRB                     : in    std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
        S_AXI_WVALID                    : in    std_logic;
        S_AXI_WREADY                    : out   std_logic;
        S_AXI_BRESP                     : out   std_logic_vector(1 downto 0);
        S_AXI_BVALID                    : out   std_logic;
        S_AXI_BREADY                    : in    std_logic;
        S_AXI_ARADDR                    : in    std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
        S_AXI_ARVALID                   : in    std_logic;
        S_AXI_ARREADY                   : out   std_logic;
        S_AXI_RDATA                     : out   std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        S_AXI_RRESP                     : out   std_logic_vector(1 downto 0);
        S_AXI_RVALID                    : out   std_logic;
        S_AXI_RREADY                    : in    std_logic;

        tx_cfg_vector                   : out   std_logic_vector(79 downto 0);
        rx_cfg_vector                   : out   std_logic_vector(79 downto 0)
    );
end entity;

architecture rtl of temac_regs is

    constant ZEROS                      : std_logic_vector(31 downto 0) := (others => '0');
    constant C_S_AXI_MIN_SIZE           : std_logic_vector(31 downto 0) := x"0000001f";
    constant C_USE_WSTRB                : integer := 0;
    constant C_DPHASE_TIMEOUT           : integer := 8;
    constant C_ARD_ADDR_RANGE_ARRAY     : SLV64_ARRAY_TYPE := (
        ZEROS & x"00000000",
        ZEROS & x"0000001f"
    );
    constant C_ARD_NUM_CE_ARRAY         : INTEGER_ARRAY_TYPE := (
        0 => 8
    );

    signal bus2ip_clk                   : std_logic;
    signal bus2ip_reset                 : std_logic;
    signal bus2ip_resetn                : std_logic;
    signal ip2bus_data                  : std_logic_vector((C_S_AXI_DATA_WIDTH-1)  downto 0):= (others  => '0');
    signal ip2bus_error                 : std_logic := '0';
    signal ip2bus_wrack                 : std_logic := '0';
    signal ip2bus_rdack                 : std_logic := '0';
    signal bus2ip_data                  : std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);
    signal bus2ip_rdce                  : std_logic_vector(calc_num_ce(C_ARD_NUM_CE_ARRAY)-1 downto 0);
    signal bus2ip_wrce                  : std_logic_vector(calc_num_ce(C_ARD_NUM_CE_ARRAY)-1 downto 0);

begin

    axi_ipif_i : entity axi_lite_ipif_v1_01_a.axi_lite_ipif
    generic map (
        C_S_AXI_DATA_WIDTH              => C_S_AXI_DATA_WIDTH,
        C_S_AXI_ADDR_WIDTH              => C_S_AXI_ADDR_WIDTH,
        C_S_AXI_MIN_SIZE                => C_S_AXI_MIN_SIZE,
        C_USE_WSTRB                     => C_USE_WSTRB,
        C_DPHASE_TIMEOUT                => C_DPHASE_TIMEOUT,
        C_ARD_ADDR_RANGE_ARRAY          => C_ARD_ADDR_RANGE_ARRAY,
        C_ARD_NUM_CE_ARRAY              => C_ARD_NUM_CE_ARRAY,
        C_FAMILY                        => C_FAMILY
    )
    port map (
        --System signals
        S_AXI_ACLK                      => S_AXI_ACLK,
        S_AXI_ARESETN                   => S_AXI_ARESETN,
        S_AXI_AWADDR                    => S_AXI_AWADDR,
        S_AXI_AWVALID                   => S_AXI_AWVALID,
        S_AXI_AWREADY                   => S_AXI_AWREADY,
        S_AXI_WDATA                     => S_AXI_WDATA,
        S_AXI_WSTRB                     => S_AXI_WSTRB,
        S_AXI_WVALID                    => S_AXI_WVALID,
        S_AXI_WREADY                    => S_AXI_WREADY,
        S_AXI_BRESP                     => S_AXI_BRESP,
        S_AXI_BVALID                    => S_AXI_BVALID,
        S_AXI_BREADY                    => S_AXI_BREADY,
        S_AXI_ARADDR                    => S_AXI_ARADDR,
        S_AXI_ARVALID                   => S_AXI_ARVALID,
        S_AXI_ARREADY                   => S_AXI_ARREADY,
        S_AXI_RDATA                     => S_AXI_RDATA,
        S_AXI_RRESP                     => S_AXI_RRESP,
        S_AXI_RVALID                    => S_AXI_RVALID,
        S_AXI_RREADY                    => S_AXI_RREADY,
        -- Controls to the IP/IPIF modules
        Bus2IP_Clk                      => bus2ip_clk,
        Bus2IP_Resetn                   => bus2ip_resetn,
        Bus2IP_Addr                     => open,
        Bus2IP_RNW                      => open,
        Bus2IP_BE                       => open,
        Bus2IP_CS                       => open,
        Bus2IP_RdCE                     => bus2ip_rdce,
        Bus2IP_WrCE                     => bus2ip_wrce,
        Bus2IP_Data                     => bus2ip_data,
        IP2Bus_Data                     => ip2bus_data,
        IP2Bus_WrAck                    => ip2bus_wrack,
        IP2Bus_RdAck                    => ip2bus_rdack,
        IP2Bus_Error                    => ip2bus_error
    );

    DEFAULT_DATA_GEN : if (C_S_AXI_DATA_WIDTH /= 32) generate
        ip2bus_data(C_S_AXI_DATA_WIDTH - 1 downto 32)   <= (others => '0');
    end generate;

    cfg_core_i : entity nf7_1g_interface_v1_00_a.cfg_core
    generic map (
        -- Default tx vector
        C_TX_PAUSE_MAC_ADDR             => C_TX_PAUSE_MAC_ADDR,
        C_TX_MAX_FRAME_SIZE             => C_TX_MAX_FRAME_SIZE,
        C_TX_MAX_FRAME_EN               => C_TX_MAX_FRAME_EN,
        C_TX_SPEED                      => C_TX_SPEED,
        C_TX_IFG_ADJUST_EN              => C_TX_IFG_ADJUST_EN,
        C_TX_HD_EN                      => C_TX_HD_EN,
        C_TX_FC_EN                      => C_TX_FC_EN,
        C_TX_JUMBO_EN                   => C_TX_JUMBO_EN,
        C_TX_FCS_EN                     => C_TX_FCS_EN,
        C_TX_VLAN_EN                    => C_TX_VLAN_EN,
        C_TX_EN                         => C_TX_EN,
        C_TX_RESET                      => C_TX_RESET,
        -- Default rx vector
        C_RX_PAUSE_MAC_ADDR             => C_RX_PAUSE_MAC_ADDR,
        C_RX_MAX_FRAME_SIZE             => C_RX_MAX_FRAME_SIZE,
        C_RX_MAX_FRAME_EN               => C_RX_MAX_FRAME_EN,
        C_RX_SPEED                      => C_RX_SPEED,
        C_RX_PROMISCUOUS_EN             => C_RX_PROMISCUOUS_EN,
        C_RX_CONTROL_LEN_CHK_DIS        => C_RX_CONTROL_LEN_CHK_DIS,
        C_RX_LEN_TYPE_CHK_DIS           => C_RX_LEN_TYPE_CHK_DIS,
        C_RX_HD_EN                      => C_RX_HD_EN,
        C_RX_FC_EN                      => C_RX_FC_EN,
        C_RX_JUMBO_EN                   => C_RX_JUMBO_EN,
        C_RX_FCS_EN                     => C_RX_FCS_EN,
        C_RX_VLAN_EN                    => C_RX_VLAN_EN,
        C_RX_EN                         => C_RX_EN,
        C_RX_RESET                      => C_RX_RESET
    )
    port map (
        clk                             => bus2ip_clk,
        rst_n                           => bus2ip_resetn,
        din                             => bus2ip_data(31 downto 0),
        rdce                            => bus2ip_rdce(7 downto 0),
        wrce                            => bus2ip_wrce(7 downto 0),
        rdack                           => ip2bus_rdack,
        wrack                           => ip2bus_wrack,
        dout                            => ip2bus_data(31 downto 0),

        tx_cfg                          => tx_cfg_vector,
        rx_cfg                          => rx_cfg_vector
    );


end rtl;

