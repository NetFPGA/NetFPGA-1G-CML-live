/* 
 * 
 * File:
 *       gig_eth_mac_block.v
 *
 * Library:
 * 		 hw/std/pcores/nf7_1g_interface_v1_10_a
 *
 * Module:
 * 		gig_eth_mac_block
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
 *               ________________________________________
 *              |                                        |
 *              | BLOCK LEVEL WRAPPER                    |
 *              |                                        |
 *              |     ___________________                |
 *              |    |                   |               |
 *              |    | ETHERNET MAC      |               |
 *              |    | CORE              |   _______     |
 *              |    |                   |  |       |    |
 *            --|--->| Tx            Tx  |->|       |--->|
 *              |    | AXI           PHY |  |       |    |
 *              |    | I/F           I/F |  |       |    |
 *              |    |                   |  | PHY   |    |
 *              |    |                   |  | I/F   |    |
 *              |    |                   |  |       |    |
 *              |    | Rx            Rx  |  |       |    |
 *              |    | AXI           PHY |  |       |    |
 *            <-|----| I/F           I/F |<-|_______|<---|
 *              |    |                   |               |
 *              |    |___________________|               |
 *              |                                        |
 *              |________________________________________|
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

module gig_eth_mac_block (
	  input                gtx_clk,
	  input                gtx_clk90,

      // asynchronous reset
      input                glbl_rstn,

      // Receiver Interface
      //--------------------------
      //output      [27:0]   rx_statistics_vector,
      //output               rx_statistics_valid,

      output               rx_mac_aclk,
      output               rx_reset,
      output      [7:0]    rx_axis_mac_tdata,
      output               rx_axis_mac_tvalid,
      output               rx_axis_mac_tlast,
      output               rx_axis_mac_tuser,

      // Transmitter Interface
      //-----------------------------
      //input       [7:0]    tx_ifg_delay,
      //output      [31:0]   tx_statistics_vector,
      //output               tx_statistics_valid,

      output               tx_reset,
      input       [7:0]    tx_axis_mac_tdata,
      input                tx_axis_mac_tvalid,
      input                tx_axis_mac_tlast,
      input                tx_axis_mac_tuser,
      output               tx_axis_mac_tready,
      // MAC Control Interface
      //----------------------
      //input                pause_req,
      //input       [15:0]   pause_val,

      // Reference clock for IDELAYCTRL's
      input                refclk,

      // RGMII Interface
      //----------------
      output      [3:0]    rgmii_txd,
      output               rgmii_tx_ctl,
      output               rgmii_txc,
      input       [3:0]    rgmii_rxd,
      input                rgmii_rx_ctl,
      input                rgmii_rxc,
      //output               inband_link_status,
      //output      [1:0]    inband_clock_speed,
      //output               inband_duplex_status,

      // Configuration Vectors
      //---------------------
      // Run-time Configuration (takes effect between frames)
	  input  wire conf_tx_en,
	  input  wire conf_rx_en,
	  input  wire conf_tx_no_gen_crc,
	  input  wire conf_rx_no_chk_crc,
	  input  wire conf_tx_jumbo_en,
	  input  wire conf_rx_jumbo_en
      );

   parameter C_INCLUDE_IDELAYCTRL = 1;

   //---------------------------------------------------------------------------
   // internal signals used in this block level wrapper.
   //---------------------------------------------------------------------------

   wire           idelayctrl_reset_sync;     // Used to create a reset pulse in the IDELAYCTRL refclk domain.
   reg   [3:0]    idelay_reset_cnt;          // Counter to create a long IDELAYCTRL reset pulse.
   reg            idelayctrl_reset;          // The reset pulse for the IDELAYCTRL.

   wire           gmii_tx_en_int;            // Internal gmii_tx_en signal.
   wire           gmii_tx_er_int;            // Internal gmii_tx_er signal.
   wire  [7:0]    gmii_txd_int;              // Internal gmii_txd signal.
   wire           gmii_rx_dv_int;            // gmii_rx_dv registered in IOBs.
   wire           gmii_rx_er_int;            // gmii_rx_er registered in IOBs.
   wire  [7:0]    gmii_rxd_int;              // gmii_rxd registered in IOBs.

   (* KEEP = "TRUE" *)
   wire           rx_mac_aclk_int;       // Internal receive gmii/mii clock signal.

   wire           glbl_rst;
   wire           tx_reset_int;         // Synchronous reset in the MAC and gmii Tx domain
   wire           rx_reset_int;         // Synchronous reset in the MAC and gmii Rx domain

   // assign outputs
   assign rx_reset = rx_reset_int;
   assign tx_reset = tx_reset_int;
   // Assign the internal clock signals to output ports.
   assign rx_mac_aclk = rx_mac_aclk_int;

   assign glbl_rst = !glbl_rstn;

      //---------------------------------------------------------------------------
      // An IDELAYCTRL primitive needs to be instantiated for the Fixed Tap Delay
      // mode of the IDELAY.
      // All IDELAYs in Fixed Tap Delay mode and the IDELAYCTRL primitives have
      // to be LOC'ed in the UCF file.
      //---------------------------------------------------------------------------
   generate 
     if (C_INCLUDE_IDELAYCTRL == 1)
      IDELAYCTRL dlyctrl (
         .RDY              (),
         .REFCLK           (refclk),
         .RST              (idelayctrl_reset)
      );
   endgenerate 
   
      // Create a synchronous reset in the IDELAYCTRL refclk clock domain.
   generate 
     if (C_INCLUDE_IDELAYCTRL == 1)
      xilinx_reset_sync idelayctrl_reset_gen (
         .clk              (refclk),
         .enable           (1'b1),
         .reset_in         (glbl_rst),
         .reset_out        (idelayctrl_reset_sync)
      );
     else
       assign idelayctrl_reset_sync = 1;
   endgenerate 
   
      // Reset circuitry for the IDELAYCTRL reset.
   
      // The IDELAYCTRL must experience a pulse which is at least 50 ns in
      // duration.  This is ten clock cycles of the 200MHz refclk.  Here we
      // drive the reset pulse for 12 clock cycles.
      always @(posedge refclk)
      begin
         if (idelayctrl_reset_sync) begin
            idelay_reset_cnt     <= 4'b0000;
            idelayctrl_reset     <= 1'b1;
         end
         else begin
            case (idelay_reset_cnt)
               4'b0000 : idelay_reset_cnt <= 4'b0001;
               4'b0001 : idelay_reset_cnt <= 4'b0010;
               4'b0010 : idelay_reset_cnt <= 4'b0011;
               4'b0011 : idelay_reset_cnt <= 4'b0100;
               4'b0100 : idelay_reset_cnt <= 4'b0101;
               4'b0101 : idelay_reset_cnt <= 4'b0110;
               4'b0110 : idelay_reset_cnt <= 4'b0111;
               4'b0111 : idelay_reset_cnt <= 4'b1000;
               4'b1000 : idelay_reset_cnt <= 4'b1001;
               4'b1001 : idelay_reset_cnt <= 4'b1010;
               4'b1010 : idelay_reset_cnt <= 4'b1011;
               4'b1011 : idelay_reset_cnt <= 4'b1100;
               default : idelay_reset_cnt <= 4'b1100;
            endcase
            if (idelay_reset_cnt == 4'b1100) begin
               idelayctrl_reset  <= 1'b0;
            end
            else begin
               idelayctrl_reset  <= 1'b1;
            end
         end
      end

   //---------------------------------------------------------------------------
   // Instantiate RGMII Interface
   //---------------------------------------------------------------------------

   // Instantiate the RGMII physical interface logic
   xilinx_rgmii_v2_0_if rgmii_interface (
      // Synchronous resets
      .tx_reset         (tx_reset_int),
      .rx_reset         (rx_reset_int),

      // The following ports are the RGMII physical interface: these will be at
      // pins on the FPGA
      .rgmii_txd        (rgmii_txd),
      .rgmii_tx_ctl     (rgmii_tx_ctl),
      .rgmii_txc        (rgmii_txc),
      .rgmii_rxd        (rgmii_rxd),
      .rgmii_rx_ctl     (rgmii_rx_ctl),
      .rgmii_rxc        (rgmii_rxc),

      // The following signals are in the RGMII in-band status signals
      .link_status      (),
      .clock_speed      (),
      .duplex_status    (),

      // The following ports are the internal GMII connections from IOB logic
      // to the TEMAC core
      .txd_from_mac     (gmii_txd_int),
      .tx_en_from_mac   (gmii_tx_en_int),
      .tx_er_from_mac   (gmii_tx_er_int),
      .tx_clk           (gtx_clk),
      .tx_clk90         (gtx_clk90),
      .rxd_to_mac       (gmii_rxd_int),
      .rx_dv_to_mac     (gmii_rx_dv_int),
      .rx_er_to_mac     (gmii_rx_er_int),

      // Receiver clock for the MAC and Client Logic
      .rx_clk           (rx_mac_aclk_int)
      );

   // Error Insertion for testing error condition handling in Isim
   // Situation I: rx_er occur
   // wire gmii_rx_er_int_err_sig;
   // assign gmii_rx_er_int_err_sig = gmii_rxd_int == 8'h31;
   // Situation II: CRC error occur
   // wire [7:0] gmii_rxd_int_crc_err;
   // assign gmii_rxd_int_crc_err = (gmii_rxd_int == 8'h0E) ? 8'h00 : gmii_rxd_int;
      
   gig_eth_mac ucsd_gig_eth_mac (
      //Reset and Clock Signals
      .reset            (glbl_rst),
      .tx_clk           (gtx_clk),
      .rx_clk           (rx_mac_aclk_int),

      // GMII Interface
      .gmii_tx_data     (gmii_txd_int),
      .gmii_tx_en       (gmii_tx_en_int),
      .gmii_tx_er       (gmii_tx_er_int),
      .gmii_rx_data     (gmii_rxd_int),
      .gmii_rx_dvld     (gmii_rx_dv_int),
      .gmii_rx_er       (gmii_rx_er_int),
	  // Error Insertion for testing error condition handling
	  // Situation I: rx_er occur
	  // .gmii_rx_er       (gmii_rx_er_int_err_sig),
   	  // Situation II: CRC error occur
   	  // .gmii_rx_data     (gmii_rxd_int_crc_err),

      // Client Interface
      // TX
	  .tx_axis_mac_tdata  (tx_axis_mac_tdata),
	  .tx_axis_mac_tvalid (tx_axis_mac_tvalid),
	  .tx_axis_mac_tlast  (tx_axis_mac_tlast),
	  .tx_axis_mac_tready (tx_axis_mac_tready),
	  .tx_axis_mac_tuser  (tx_axis_mac_tuser),
	  // Error Insertion for testing error condition handling
	  // .tx_axis_mac_tuser  (tx_axis_mac_tlast),
      
      // RX
      .rx_axis_mac_tdata  (rx_axis_mac_tdata),
      .rx_axis_mac_tvalid (rx_axis_mac_tvalid),
      .rx_axis_mac_tlast  (rx_axis_mac_tlast),
      .rx_axis_mac_tuser  (rx_axis_mac_tuser),

      // Configuration
      .conf_tx_en         (conf_tx_en),
      .conf_rx_en         (conf_rx_en),
      .conf_tx_no_gen_crc (conf_tx_no_gen_crc),
      .conf_rx_no_chk_crc (conf_rx_no_chk_crc),
      .conf_tx_jumbo_en   (conf_tx_jumbo_en),
      .conf_rx_jumbo_en   (conf_rx_jumbo_en)
      );

endmodule
