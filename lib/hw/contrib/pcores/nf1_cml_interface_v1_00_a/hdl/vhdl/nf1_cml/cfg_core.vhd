-- 
-- File:
--       cfg_core.vhd
--
-- Library:
-- 		 hw/contrib/pcores/nf1_cml_interface_v1_10_a
--
-- Module:
-- 	        register interface core	
--
-- Author:
-- 		Jay Hirata
-- 
-- Description:
--              Register interface customized for use with Xilinx Tri-mode Ethernet MAC
--              This is used by C_MAC_SEL = 0 in nf1_cml_interface 
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
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;

entity cfg_core is
    generic (
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
        clk                             : in    std_logic;
        rst_n                           : in    std_logic;
        din                             : in    std_logic_vector(31 downto 0);
        rdce                            : in    std_logic_vector(7 downto 0);
        wrce                            : in    std_logic_vector(7 downto 0);
        rdack                           : out   std_logic;
        wrack                           : out   std_logic;
        dout                            : out   std_logic_vector(31 downto 0);

        tx_cfg                          : out   std_logic_vector(79 downto 0);
        rx_cfg                          : out   std_logic_vector(79 downto 0)
    );
end entity;

architecture rtl of cfg_core is

    signal tx_cfg_reg                   : std_logic_vector(79 downto 0) := (others => '0');
    signal rx_cfg_reg                   : std_logic_vector(79 downto 0) := (others => '0');

    constant REG_IDX_TX_CTRL            : integer   := 3;
    constant REG_IDX_TX_PAUSE_HI        : integer   := 1;
    constant REG_IDX_TX_PAUSE_LO        : integer   := 0;

    constant REG_IDX_RX_CTRL            : integer   := 7;
    constant REG_IDX_RX_PAUSE_HI        : integer   := 5;
    constant REG_IDX_RX_PAUSE_LO        : integer   := 4;

    constant tx_pause_mac_addr          : std_logic_vector(47 downto 0) := std_logic_vector(to_unsigned(C_TX_PAUSE_MAC_ADDR, 48));
    constant tx_max_frame_size          : std_logic_vector(15 downto 0) := std_logic_vector(to_unsigned(C_TX_MAX_FRAME_SIZE, 16));
    constant tx_max_frame_en            : std_logic_vector(0 downto 0)  := std_logic_vector(to_unsigned(C_TX_MAX_FRAME_EN, 1));
    constant tx_speed                   : std_logic_vector(1 downto 0)  := std_logic_vector(to_unsigned(C_TX_SPEED, 2));
    constant tx_ifg_adjust_en           : std_logic_vector(0 downto 0)  := std_logic_vector(to_unsigned(C_TX_IFG_ADJUST_EN, 1));
    constant tx_hd_en                   : std_logic_vector(0 downto 0)  := std_logic_vector(to_unsigned(C_TX_HD_EN, 1));
    constant tx_fc_en                   : std_logic_vector(0 downto 0)  := std_logic_vector(to_unsigned(C_TX_FC_EN, 1));
    constant tx_jumbo_en                : std_logic_vector(0 downto 0)  := std_logic_vector(to_unsigned(C_TX_JUMBO_EN, 1));
    constant tx_fcs_en                  : std_logic_vector(0 downto 0)  := std_logic_vector(to_unsigned(C_TX_FCS_EN, 1));
    constant tx_vlan_en                 : std_logic_vector(0 downto 0)  := std_logic_vector(to_unsigned(C_TX_VLAN_EN, 1));
    constant tx_en                      : std_logic_vector(0 downto 0)  := std_logic_vector(to_unsigned(C_TX_EN, 1));
    constant tx_reset                   : std_logic_vector(0 downto 0)  := std_logic_vector(to_unsigned(C_TX_RESET, 1));
    constant rx_pause_mac_addr          : std_logic_vector(47 downto 0) := std_logic_vector(to_unsigned(C_RX_PAUSE_MAC_ADDR, 48));
    constant rx_max_frame_size          : std_logic_vector(15 downto 0) := std_logic_vector(to_unsigned(C_RX_MAX_FRAME_SIZE, 16));
    constant rx_max_frame_en            : std_logic_vector(0 downto 0)  := std_logic_vector(to_unsigned(C_RX_MAX_FRAME_EN, 1));
    constant rx_speed                   : std_logic_vector(1 downto 0)  := std_logic_vector(to_unsigned(C_RX_SPEED, 2));
    constant rx_promiscuous_en          : std_logic_vector(0 downto 0)  := std_logic_vector(to_unsigned(C_RX_PROMISCUOUS_EN, 1));
    constant rx_control_len_chk_dis     : std_logic_vector(0 downto 0)  := std_logic_vector(to_unsigned(C_RX_CONTROL_LEN_CHK_DIS, 1));
    constant rx_len_type_chk_dis        : std_logic_vector(0 downto 0)  := std_logic_vector(to_unsigned(C_RX_LEN_TYPE_CHK_DIS, 1));
    constant rx_hd_en                   : std_logic_vector(0 downto 0)  := std_logic_vector(to_unsigned(C_RX_HD_EN, 1));
    constant rx_fc_en                   : std_logic_vector(0 downto 0)  := std_logic_vector(to_unsigned(C_RX_FC_EN, 1));
    constant rx_jumbo_en                : std_logic_vector(0 downto 0)  := std_logic_vector(to_unsigned(C_RX_JUMBO_EN, 1));
    constant rx_fcs_en                  : std_logic_vector(0 downto 0)  := std_logic_vector(to_unsigned(C_RX_FCS_EN, 1));
    constant rx_vlan_en                 : std_logic_vector(0 downto 0)  := std_logic_vector(to_unsigned(C_RX_VLAN_EN, 1));
    constant rx_en                      : std_logic_vector(0 downto 0)  := std_logic_vector(to_unsigned(C_RX_EN, 1));
    constant rx_reset                   : std_logic_vector(0 downto 0)  := std_logic_vector(to_unsigned(C_RX_RESET, 1));

begin

    process (clk)
    begin
        if rising_edge (clk) then
            if (rst_n = '0') then
                rdack       <= '0';
                wrack       <= '0';
                dout        <= (others => '0');

                tx_cfg_reg  <=
                    tx_pause_mac_addr &
                    tx_max_frame_size &
                    '0' &       -- reserved
                    tx_max_frame_en &
                    tx_speed &
                    '0' &       -- reserved
                    tx_ifg_adjust_en &
                    "000" &      -- reserved
                    tx_hd_en &
                    tx_fc_en &
                    tx_jumbo_en &
                    tx_fcs_en &
                    tx_vlan_en &
                    tx_en &
                    tx_reset;

                rx_cfg_reg  <=
                    rx_pause_mac_addr &
                    rx_max_frame_size &
                    '0' &       -- reserved
                    rx_max_frame_en &
                    rx_speed &
                    rx_promiscuous_en &
                    '0' &       -- reserved
                    rx_control_len_chk_dis &
                    rx_len_type_chk_dis &
                    '0' &       -- reserved
                    rx_hd_en &
                    rx_fc_en &
                    rx_jumbo_en &
                    rx_fcs_en &
                    rx_vlan_en &
                    rx_en &
                    rx_reset;

            else
                rdack       <= '0';
                wrack       <= '0';
                tx_cfg_reg  <= tx_cfg_reg;
                rx_cfg_reg  <= rx_cfg_reg;

                if (wrce(REG_IDX_TX_CTRL) = '1') then
                    wrack       <= '1';
                    -- don't set reserved bits or TX_SPEED (speed doesn't change yet in this core)
                    tx_cfg_reg(31 downto 0)     <=
                        din(31 downto 16) & '0' & din(14) &
                        tx_speed & "000" & din(8) & '0' & din(6 downto 0);

                elsif (wrce(REG_IDX_TX_PAUSE_HI) = '1') then
                    wrack       <= '1';
                    tx_cfg_reg(79 downto 64)    <= din(15 downto 0);

                elsif (wrce(REG_IDX_TX_PAUSE_LO) = '1') then
                    wrack       <= '1';
                    tx_cfg_reg(63 downto 32)    <= din;

                elsif (wrce(REG_IDX_RX_CTRL) = '1') then
                    wrack       <= '1';
                    -- don't set reserved bits or RX_SPEED
                    rx_cfg_reg(31 downto 0)     <=
                        din(31 downto 16) & '0' & din(14) &
                        rx_speed & din(11) & '0' &
                        din(9 downto 8) & '0' & din(6 downto 0);

                elsif (wrce(REG_IDX_RX_PAUSE_HI) = '1') then
                    wrack       <= '1';
                    rx_cfg_reg(79 downto 64)    <= din(15 downto 0);

                elsif (wrce(REG_IDX_RX_PAUSE_LO) = '1') then
                    rx_cfg_reg(63 downto 32)    <= din;

                end if;


                if (rdce(REG_IDX_TX_CTRL) = '1') then
                    rdack   <= '1';
                    dout    <= tx_cfg_reg(31 downto 0);

                elsif (rdce(REG_IDX_TX_PAUSE_HI) = '1') then
                    rdack   <= '1';
                    dout    <= x"0000" & tx_cfg_reg(79 downto 64);

                elsif (rdce(REG_IDX_TX_PAUSE_LO) = '1') then
                    rdack   <= '1';
                    dout    <= tx_cfg_reg(63 downto 32);

                elsif (rdce(REG_IDX_RX_CTRL) = '1') then
                    rdack   <= '1';
                    dout    <= rx_cfg_reg(31 downto 0);

                elsif (rdce(REG_IDX_RX_PAUSE_HI) = '1') then
                    rdack   <= '1';
                    dout    <= x"0000" & rx_cfg_reg(79 downto 64);

                elsif (rdce(REG_IDX_RX_PAUSE_LO) = '1') then
                    rdack   <= '1';
                    dout    <= rx_cfg_reg(63 downto 32);

                else
                    dout    <= (others => '0');

                end if;

            end if;
        end if;
    end process;

    tx_cfg  <= tx_cfg_reg;
    rx_cfg  <= rx_cfg_reg;

end rtl;

