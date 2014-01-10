/////////////////////////////////////////////////////////////////////////////////////
//
//  NetFPGA-1G-CML http://www.netfpga.org
//
//  File:
//       system_tb.v 
//
//  Project:
//       loopback_test_nf1_cml
//
//  Author:
//       Jack Meador
//
//  Description:
//       Simulation Testbench for loopback test
//
//  Copyright notice:
//        Copyright (C) 2013 Computer Measurement Laboratory, LLC
//
//  Licence:
//        This file is part of the NetFPGA 10G development base package.
//
//        This file is free code: you can redistribute it and/or modify it under
//        the terms of the GNU Lesser General Public License version 2.1 as
//        published by the Free Software Foundation.
//
//        This package is distributed in the hope that it will be useful, but
//        WITHOUT ANY WARRANTY; without even the implied warranty of
//        MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
//        Lesser General Public License for more details.
//
//        You should have received a copy of the GNU Lesser General Public
//        License along with the NetFPGA source package.  If not, see
//        http://www.gnu.org/licenses/.
//

//-----------------------------------------------------------------------------
// system_tb.v
//-----------------------------------------------------------------------------

`timescale 1 ps / 100 fs

`uselib lib=unisims_ver

// START USER CODE (Do not remove this line)

// User: Put your directives here. Code in this
//       section will not be overwritten.

// END USER CODE (Do not remove this line)

module system_tb
  (
  );

  // START USER CODE (Do not remove this line)

  // User: Put your signals here. Code in this
  //       section will not be overwritten.

  // END USER CODE (Do not remove this line)


  // Internal signals

  reg clk_in_p;
  reg clk_in_n;
  wire mdc;
  wire mdio;
  wire phy_rstn_1;
  wire phy_rstn_2;
  wire phy_rstn_3;
  wire phy_rstn_4;
  reg reset;
  reg rgmii_rx_ctl_1;
  reg rgmii_rx_ctl_2;
  reg rgmii_rx_ctl_3;
  reg rgmii_rx_ctl_4;
  reg rgmii_rxc_1;
  reg rgmii_rxc_2;
  reg rgmii_rxc_3;
  reg rgmii_rxc_4;
  reg [3:0] rgmii_rxd_1;
  reg [3:0] rgmii_rxd_2;
  reg [3:0] rgmii_rxd_3;
  reg [3:0] rgmii_rxd_4;
  wire rgmii_tx_ctl_1;
  wire rgmii_tx_ctl_2;
  wire rgmii_tx_ctl_3;
  wire rgmii_tx_ctl_4;
  wire rgmii_txc_1;
  wire rgmii_txc_2;
  wire rgmii_txc_3;
  wire rgmii_txc_4;
  wire [3:0] rgmii_txd_1;
  wire [3:0] rgmii_txd_2;
  wire [3:0] rgmii_txd_3;
  wire [3:0] rgmii_txd_4;
  reg uart_rx;
  wire uart_tx;

  system
    dut (
      .reset ( reset ),
      .clk_in_p ( clk_in_p ),
      .clk_in_n ( clk_in_n ),
      .uart_tx ( uart_tx ),
      .uart_rx ( uart_rx ),
      .mdc ( mdc ),
      .mdio ( mdio ),
      .phy_rstn_1 ( phy_rstn_1 ),
      .phy_rstn_2 ( phy_rstn_2 ),
      .phy_rstn_3 ( phy_rstn_3 ),
      .phy_rstn_4 ( phy_rstn_4 ),
      .rgmii_txd_1 ( rgmii_txd_1 ),
      .rgmii_tx_ctl_1 ( rgmii_tx_ctl_1 ),
      .rgmii_txc_1 ( rgmii_txc_1 ),
      .rgmii_rxd_1 ( rgmii_rxd_1 ),
      .rgmii_rx_ctl_1 ( rgmii_rx_ctl_1 ),
      .rgmii_rxc_1 ( rgmii_rxc_1 ),
      .rgmii_txd_2 ( rgmii_txd_2 ),
      .rgmii_tx_ctl_2 ( rgmii_tx_ctl_2 ),
      .rgmii_txc_2 ( rgmii_txc_2 ),
      .rgmii_rxd_2 ( rgmii_rxd_2 ),
      .rgmii_rx_ctl_2 ( rgmii_rx_ctl_2 ),
      .rgmii_rxc_2 ( rgmii_rxc_2 ),
      .rgmii_txd_3 ( rgmii_txd_3 ),
      .rgmii_tx_ctl_3 ( rgmii_tx_ctl_3 ),
      .rgmii_txc_3 ( rgmii_txc_3 ),
      .rgmii_rxd_3 ( rgmii_rxd_3 ),
      .rgmii_rx_ctl_3 ( rgmii_rx_ctl_3 ),
      .rgmii_rxc_3 ( rgmii_rxc_3 ),
      .rgmii_txd_4 ( rgmii_txd_4 ),
      .rgmii_tx_ctl_4 ( rgmii_tx_ctl_4 ),
      .rgmii_txc_4 ( rgmii_txc_4 ),
      .rgmii_rxd_4 ( rgmii_rxd_4 ),
      .rgmii_rx_ctl_4 ( rgmii_rx_ctl_4 ),
      .rgmii_rxc_4 ( rgmii_rxc_4 )
    );

  // START USER CODE (Do not remove this line)

   always
   begin
      clk_in_p <= 0;
      clk_in_n <= 1;
      #2500;
      clk_in_p <= 1;
      clk_in_n <= 0;
      #2500;
   end

  initial
   begin
      reset <= 1;
      #300000;
      reset <= 0;
   end

  // eth1 <-> eth2 
  always @(rgmii_txd_1)
    begin
    rgmii_rxd_2 <= rgmii_txd_1;   
    end
  always @(rgmii_tx_ctl_1)
    begin
    rgmii_rx_ctl_2 <= rgmii_tx_ctl_1;   
    end
  always @(rgmii_txc_1)
    begin
    rgmii_rxc_2 <= rgmii_txc_1;   
    end
  always @(rgmii_txd_2)
    begin
    rgmii_rxd_1 <= rgmii_txd_2;   
    end
  always @(rgmii_tx_ctl_2)
    begin
    rgmii_rx_ctl_1 <= rgmii_tx_ctl_2;   
    end
  always @(rgmii_txc_2)
    begin
    rgmii_rxc_1 <= rgmii_txc_2;   
    end

  // eth3 <-> eth4 
  always @(rgmii_txd_3)
    begin
    rgmii_rxd_4 <= rgmii_txd_3;   
    end
  always @(rgmii_tx_ctl_3)
    begin
    rgmii_rx_ctl_4 <= rgmii_tx_ctl_3;   
    end
  always @(rgmii_txc_3)
    begin
    rgmii_rxc_4 <= rgmii_txc_3;   
    end
  always @(rgmii_txd_4)
    begin
    rgmii_rxd_3 <= rgmii_txd_4;   
    end
  always @(rgmii_tx_ctl_4)
    begin
    rgmii_rx_ctl_3 <= rgmii_tx_ctl_4;   
    end
  always @(rgmii_txc_4)
    begin
    rgmii_rxc_3 <= rgmii_txc_4;   
    end

  // END USER CODE (Do not remove this line)

endmodule

