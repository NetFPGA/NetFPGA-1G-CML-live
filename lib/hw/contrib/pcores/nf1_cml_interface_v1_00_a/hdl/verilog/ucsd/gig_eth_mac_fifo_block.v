/* 
 * 
 * File:
 *       gig_eth_mac_wrapper.v
 *
 * Library:
 * 		 hw/std/pcores/nf1_cml_interface_v1_10_a
 *
 * Module:
 * 		gig_eth_mac_wrapper
 *
 * Author:
 * 		Tinghui Wang, Digilent Inc.
 * 
 * Description:
 * 		This wrapper instantiates a 1G ethernet MAC based on
 * 		ucsd 1GE Mac in NetFPGA repository. The PHY interface
 * 		is changed to RGMII and the client interface is modified
 * 		to AXIS interface in the same specification as Xilinx
 * 		TEMAC. PHY MDIO and AXI register access is not available.
 *
 *         _________________________________________________________
 *        |                                                         |
 *        |                FIFO BLOCK LEVEL WRAPPER                 |
 *        |                                                         |
 *        |   _____________________       ______________________    |
 *        |  |  _________________  |     |                      |   |
 *        |  | |                 | |     |                      |   |
 *  -------->| |   TX AXI FIFO   | |---->| Tx               Tx  |--------->
 *        |  | |                 | |     | AXI-S            PHY |   |
 *        |  | |_________________| |     | I/F              I/F |   |
 *        |  |                     |     |                      |   |
 *  AXI   |  |     10/100/1G       |     |   UCSD GIG Ethernet  |   |
 * Stream |  |    ETHERNET FIFO    |     |      MAC CORE        |   | PHY I/F
 *        |  |                     |     |    BLOCK WRAPPER     |   |
 *        |  |  _________________  |     |                      |   |
 *        |  | |                 | |     |                      |   |
 *  <--------| |   RX AXI FIFO   | |<----| Rx               Rx  |<---------
 *        |  | |                 | |     | AXI-S            PHY |   |
 *        |  | |_________________| |     | I/F              I/F |   |
 *        |  |_____________________|     |______________________|   |
 *        |                                                         |
 *        |_________________________________________________________|
 *
 *
 * Copyright notice:
 * 		Copyright (C) 2013 Digilent Inc.
 *
 * License:
 *        This file is part of the NetFPGA 10G development base package.
 *
 *        This file is free code: you can redistribute it and/or modify it under
 *        the terms of the GNU Lesser General Public License version 2.1 as
 *        published by the Free Software Foundation.
 *
 *        This package is distributed in the hope that it will be useful, but
 *        WITHOUT ANY WARRANTY; without even the implied warranty of
 *        MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *        Lesser General Public License for more details.
 *
 *        You should have received a copy of the GNU Lesser General Public
 *        License along with the NetFPGA source package.  If not, see
 *        http://www.gnu.org/licenses/.
 *
 */

module gig_eth_mac_fifo_block (
	  input                gtx_clk,
	  input                gtx_clk90,

      // asynchronous reset
      input                glbl_rstn,

      // Reference clock for IDELAYCTRL's
      input                refclk,

      // Receiver Statistics Interface
      //---------------------------------------
      //output               rx_mac_aclk,
      //output               rx_reset,
      //output [27:0]        rx_statistics_vector,
      //output               rx_statistics_valid,

      // Receiver (AXI-S) Interface
      //----------------------------------------
      input                rx_fifo_clock,
      input                rx_fifo_resetn,
      output [7:0]         rx_axis_fifo_tdata,
      output               rx_axis_fifo_tvalid,
      input                rx_axis_fifo_tready,
      output               rx_axis_fifo_tlast,

      // Transmitter Statistics Interface
      //------------------------------------------
      //output               tx_reset,
      //input  [7:0]         tx_ifg_delay,
      //output [31:0]        tx_statistics_vector,
      //output               tx_statistics_valid,

      // Transmitter (AXI-S) Interface
      //-------------------------------------------
      input                tx_fifo_clock,
      input                tx_fifo_resetn,
      input  [7:0]         tx_axis_fifo_tdata,
      input                tx_axis_fifo_tvalid,
      output               tx_axis_fifo_tready,
      input                tx_axis_fifo_tlast,

      // MAC Control Interface
      //------------------------
      //input                pause_req,
      //input  [15:0]        pause_val,

      // RGMII Interface
      //------------------
      output [3:0]         rgmii_txd,
      output               rgmii_tx_ctl,
      output               rgmii_txc,
      input  [3:0]         rgmii_rxd,
      input                rgmii_rx_ctl,
      input                rgmii_rxc,

      // RGMII Inband Status Registers
      //--------------------------------
      //output               inband_link_status,
      //output [1:0]         inband_clock_speed,
      //output               inband_duplex_status,

      // Configuration Vectors
      //-----------------------
      // Run-time Configuration (takes effect between frames)
	  input  wire conf_tx_en,
	  input  wire conf_rx_en,
	  input  wire conf_tx_no_gen_crc,
	  input  wire conf_rx_no_chk_crc,
	  input  wire conf_tx_jumbo_en,
	  input  wire conf_rx_jumbo_en
      //input  [79:0]        rx_configuration_vector,
      //input  [79:0]        tx_configuration_vector
   );

   parameter C_INCLUDE_IDELAYCTRL=1;

  //----------------------------------------------------------------------------
  // Internal signals used in this fifo block level wrapper.
  //----------------------------------------------------------------------------

  // Note: KEEP attributes preserve signal names so they can be displayed in
  //            simulator wave windows

  wire       rx_mac_aclk_int;    // MAC Rx clock

  // MAC receiver client I/F
  (* KEEP = "TRUE" *)
  wire [7:0] rx_axis_mac_tdata;

  (* KEEP = "TRUE" *)
  wire       rx_axis_mac_tvalid;

  (* KEEP = "TRUE" *)
  wire       rx_axis_mac_tlast;

  (* KEEP = "TRUE" *)
  wire       rx_axis_mac_tuser;

  // MAC transmitter client I/F
  (* KEEP = "TRUE" *)
  wire [7:0] tx_axis_mac_tdata;

  (* KEEP = "TRUE" *)
  wire       tx_axis_mac_tvalid;

  (* KEEP = "TRUE" *)
  wire       tx_axis_mac_tready;

  (* KEEP = "TRUE" *)
  wire       tx_axis_mac_tlast;

  (* KEEP = "TRUE" *)
  wire       tx_axis_mac_tuser;

  //----------------------------------------------------------------------------
  // Connect the output clock signals
  //----------------------------------------------------------------------------

   assign rx_mac_aclk          = rx_mac_aclk_int;
   assign tx_reset             = tx_reset_int;

   //----------------------------------------------------------------------------
   // Instantiate the Tri-Mode EMAC Block wrapper
   //----------------------------------------------------------------------------
   gig_eth_mac_block #(C_INCLUDE_IDELAYCTRL) gig_eth_mac_block
      (
      .gtx_clk                      (gtx_clk),
      .gtx_clk90                    (gtx_clk90),
      // asynchronous reset
      .glbl_rstn                    (glbl_rstn),

      // Receiver Interface
      .rx_mac_aclk                  (rx_mac_aclk_int),
      .rx_reset                     (rx_reset_int),
      .rx_axis_mac_tdata            (rx_axis_mac_tdata),
      .rx_axis_mac_tvalid           (rx_axis_mac_tvalid),
      .rx_axis_mac_tlast            (rx_axis_mac_tlast),
      .rx_axis_mac_tuser            (rx_axis_mac_tuser),

      // Transmitter Interface
      .tx_reset                     (tx_reset_int),
      .tx_axis_mac_tdata            (tx_axis_mac_tdata ),
      .tx_axis_mac_tvalid           (tx_axis_mac_tvalid),
      .tx_axis_mac_tlast            (tx_axis_mac_tlast),
      .tx_axis_mac_tuser            (tx_axis_mac_tuser),
      .tx_axis_mac_tready           (tx_axis_mac_tready),

      // Reference clock for IDELAYCTRL's
      .refclk                       (refclk),

      // RGMII Interface
      .rgmii_txd                    (rgmii_txd),
      .rgmii_tx_ctl                 (rgmii_tx_ctl),
      .rgmii_txc                    (rgmii_txc),
      .rgmii_rxd                    (rgmii_rxd),
      .rgmii_rx_ctl                 (rgmii_rx_ctl),
      .rgmii_rxc                    (rgmii_rxc),

	  // Configuration Options 
      .conf_tx_en         (conf_tx_en),
      .conf_rx_en         (conf_rx_en),
      .conf_tx_no_gen_crc (conf_tx_no_gen_crc),
      .conf_rx_no_chk_crc (conf_rx_no_chk_crc),
      .conf_tx_jumbo_en   (conf_tx_jumbo_en),
      .conf_rx_jumbo_en   (conf_rx_jumbo_en)
   );


   //----------------------------------------------------------------------------
   // Instantiate the user side FIFO
   //----------------------------------------------------------------------------
   // locally reset sync the mac generated resets - the resets are already fully sync
   // so adding a reset sync shouldn't change that
   xilinx_reset_sync rx_mac_reset_gen (
      .clk              (rx_mac_aclk_int),
      .enable           (1'b1),
      .reset_in         (rx_reset_int),
      .reset_out        (rx_mac_reset)
   );

   xilinx_reset_sync tx_mac_reset_gen (
      .clk              (gtx_clk),
      .enable           (1'b1),
      .reset_in         (tx_reset_int),
      .reset_out        (tx_mac_reset)
   );

   // create inverted mac resets as the FIFO expects AXI compliant resets
   assign tx_mac_resetn = !tx_mac_reset;
   assign rx_mac_resetn = !rx_mac_reset;

   xilinx_ten_100_1g_eth_fifo #
   (
      .FULL_DUPLEX_ONLY       (1)
   )
   user_side_FIFO
   (
      // Transmit FIFO MAC TX Interface
      .tx_fifo_aclk           (tx_fifo_clock),
      .tx_fifo_resetn         (tx_fifo_resetn),
      .tx_axis_fifo_tdata     (tx_axis_fifo_tdata),
      .tx_axis_fifo_tvalid    (tx_axis_fifo_tvalid),
      .tx_axis_fifo_tlast     (tx_axis_fifo_tlast),
      .tx_axis_fifo_tready    (tx_axis_fifo_tready),

      .tx_mac_aclk            (gtx_clk),
      .tx_mac_resetn          (tx_mac_resetn),
      .tx_axis_mac_tdata      (tx_axis_mac_tdata),
      .tx_axis_mac_tvalid     (tx_axis_mac_tvalid),
      .tx_axis_mac_tlast      (tx_axis_mac_tlast),
      .tx_axis_mac_tready     (tx_axis_mac_tready),
      .tx_axis_mac_tuser      (tx_axis_mac_tuser),

      .tx_fifo_overflow       (),
      .tx_fifo_status         (),
      .tx_collision           (1'b0),
      .tx_retransmit          (1'b0),

      .rx_fifo_aclk           (rx_fifo_clock),
      .rx_fifo_resetn         (rx_fifo_resetn),
      .rx_axis_fifo_tdata     (rx_axis_fifo_tdata),
      .rx_axis_fifo_tvalid    (rx_axis_fifo_tvalid),
      .rx_axis_fifo_tlast     (rx_axis_fifo_tlast),
      .rx_axis_fifo_tready    (rx_axis_fifo_tready),

      .rx_mac_aclk            (rx_mac_aclk_int),
      .rx_mac_resetn          (rx_mac_resetn),
      .rx_axis_mac_tdata      (rx_axis_mac_tdata),
      .rx_axis_mac_tvalid     (rx_axis_mac_tvalid),
      .rx_axis_mac_tlast      (rx_axis_mac_tlast),
      .rx_axis_mac_tready     (),               // not used as MAC cannot throttle
      .rx_axis_mac_tuser      (rx_axis_mac_tuser),

      .rx_fifo_status         (),
      .rx_fifo_overflow       ()
  );


endmodule
