/*******************************************************************************
 *
 *  NetFPGA-1G-CML http://www.netfpga.org
 *
 *  File:
 *        nf1_cml_interface.v
 *
 *  Library:
 *        hw/contrib/pcores/nf1_cml_interface_v1_10_a
 *
 *  Module:
 *        nf1_cml_interface
 *
 *  Author:
 *        Adam Covington
 *        Jack Meador
 *        Jay Hirata
 *
 *  Description:
 *        Ethernet MAC wrapper parameterized to select one of three different 
 *        configurations.
 *
 *        C_MAC_SEL = 0 : Xilinx tri-mode Ethernet MAC with external registers
 *        C_MAC_SEL = 1 : Xilinx tri-mode Ethernet MAC with internal registers
 *        C_MAC_SEL = 2 : UCSD Ethernet MAC (default)
 *
 *  Copyright notice:
 *        Copyright (C) 2010, 2011 The Board of Trustees of The Leland Stanford
 *                                 Junior University
 *        Copyright (C) 2013 Computer Measurement Laboratory, LLC
 *
 *  Licence:
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

`uselib lib=nf10_axis_converter_v1_00_a

module nf1_cml_interface
#(
    // Master AXI Stream Data Width
    parameter C_FAMILY = "kintex7",
    parameter C_M_AXIS_DATA_WIDTH=64,
    parameter C_S_AXIS_DATA_WIDTH=64,
    parameter C_M_AXIS_TUSER_WIDTH=128,
    parameter C_S_AXIS_TUSER_WIDTH=128,
    parameter C_DEFAULT_VALUE_ENABLE = 0,
    parameter C_DEFAULT_SRC_PORT = 0,
    parameter C_DEFAULT_DST_PORT = 0,
    // Architecture configuration
    parameter C_MAC_SEL = 2,

    // The following is valid only when C_MAC_SEL = 1
    parameter C_S_AXI_ADDR_WIDTH = 32,
    parameter C_S_AXI_DATA_WIDTH = 32,
    parameter C_BASEADDR = 32'hffffffff,
    parameter C_HIGHADDR = 32'h00000000,

    // The following are valid only when C_MAC_SEL = 0
    parameter C_INCLUDE_IDELAYCTRL = 0,

    parameter C_TX_VLAN_EN = 0,
    parameter C_TX_FCS_EN = 0,
    parameter C_TX_JUMBO_EN = 0,
    parameter C_TX_FC_EN = 0,
    parameter C_TX_HD_EN = 0,
    parameter C_TX_IFG_ADJUST_EN = 0,
    parameter C_TX_MAX_FRAME_EN = 0,
    parameter C_TX_MAX_FRAME_SIZE = 1518,
    parameter C_TX_PAUSE_MAC_ADDR = 48'h000000000000,
    parameter C_TX_RESET = 0,
    parameter C_TX_EN = 1,

    parameter C_RX_VLAN_EN = 0,
    parameter C_RX_FCS_EN = 0,
    parameter C_RX_JUMBO_EN = 0,
    parameter C_RX_FC_EN = 0,
    parameter C_RX_HD_EN = 0,
    parameter C_RX_PROMISCUOUS_EN = 1'b0,
    parameter C_RX_LEN_TYPE_CHK_DIS = 0,
    parameter C_RX_CONTROL_LEN_CHK_DIS = 0,
    parameter C_RX_MAX_FRAME_EN = 0,
    parameter C_RX_MAX_FRAME_SIZE = 1518,
    parameter C_RX_PAUSE_MAC_ADDR = 48'h000000000000,
    parameter C_RX_RESET = 0,
    parameter C_RX_EN = 1
)
(
    // Clock and Reset
    input         glbl_rstn,
    input         gtx_clk,        
    input         gtx_clk90,      
    input         refclk,         
    input         axi_aclk,         

    // Master Stream Port for RX
    output [C_M_AXIS_DATA_WIDTH - 1:0]          m_axis_tdata,
    output [(C_M_AXIS_DATA_WIDTH / 8) - 1:0]    m_axis_tstrb,
    output [C_M_AXIS_TUSER_WIDTH - 1:0]         m_axis_tuser,
    output 				m_axis_tvalid,  
    input  				m_axis_tready,
    output 				m_axis_tlast,

    // Slave Stream Port for TX
    input [C_S_AXIS_DATA_WIDTH - 1:0]           s_axis_tdata,
    input [(C_S_AXIS_DATA_WIDTH / 8) - 1:0]     s_axis_tstrb,
    input [C_S_AXIS_TUSER_WIDTH - 1:0]          s_axis_tuser,
    input  				s_axis_tvalid,
    output 				s_axis_tready,
    input  				s_axis_tlast,

    // RGMII PHY Port 
    output [3:0]  rgmii_txd,
    output        rgmii_tx_ctl,
    output        rgmii_txc,
    input  [3:0]  rgmii_rxd,
    input         rgmii_rx_ctl,
    input         rgmii_rxc,


    input         s_axi_aclk,
    input         s_axi_aresetn,
    input  [31:0] s_axi_awaddr,
    input         s_axi_awvalid,
    output        s_axi_awready,
    input  [31:0] s_axi_wdata,
    input         s_axi_wvalid,
    output        s_axi_wready,
    output [1:0]  s_axi_bresp,
    output        s_axi_bvalid,
    input         s_axi_bready,
    input  [31:0] s_axi_araddr,
    input         s_axi_arvalid,
    output        s_axi_arready,
    output [31:0] s_axi_rdata,
    output [1:0]  s_axi_rresp,
    output        s_axi_rvalid,
    input         s_axi_rready

);

localparam C_M_AXIS_DATA_WIDTH_INTERNAL = 8;
localparam C_S_AXIS_DATA_WIDTH_INTERNAL = 8;

// local parameters
localparam  GIGABIT = 2'b10;

localparam C_TX_SPEED = GIGABIT;

localparam C_RX_SPEED = GIGABIT;
 
wire          axi_aclk_rstn;

// Master Stream Ports 0
wire [C_M_AXIS_DATA_WIDTH_INTERNAL - 1:0] 		m_axis_tdata_internal;
wire [((C_M_AXIS_DATA_WIDTH_INTERNAL / 8)) - 1:0] 	m_axis_tstrb_internal;
wire [C_M_AXIS_TUSER_WIDTH-1:0] 				m_axis_tuser_internal;
wire 							m_axis_tvalid_internal;
wire  						m_axis_tready_internal;
wire 							m_axis_tlast_internal;

// Slave Stream Ports 0
wire [C_S_AXIS_DATA_WIDTH_INTERNAL - 1:0] 		s_axis_tdata_internal;
wire [((C_S_AXIS_DATA_WIDTH_INTERNAL / 8)) - 1:0] 	s_axis_tstrb_internal;
wire [C_S_AXIS_TUSER_WIDTH-1:0] 				s_axis_tuser_internal;
wire  						s_axis_tvalid_internal;
wire  						s_axis_tready_internal;
wire  						s_axis_tlast_internal;

assign m_axis_tstrb_internal = {(C_M_AXIS_DATA_WIDTH_INTERNAL / 8){1'b1}};


// axi_aclk reset synchronizer
trimac_lite_reset_sync axi_aclk_sync (
    .clk              (axi_aclk),
    .enable           (1'b1),
    .reset_in         (glbl_rstn),
    .reset_out        (axi_aclk_rstn)
    );

generate 
if (C_MAC_SEL == 0)
  begin
  // instantiate Xilinx trimac block with external registers 
  wire [79:0] rx_configuration_vector;
  wire [79:0] tx_configuration_vector;
  trimac_lite_fifo_block #(C_INCLUDE_IDELAYCTRL) mac_fifo_block
      (
      .glbl_rstn                    (glbl_rstn),        // resets
      .rx_axi_rstn                  (1'b1),
      .tx_axi_rstn                  (1'b1),
  
      .gtx_clk                      (gtx_clk),          // 125 MHz clock
      .gtx_clk90                    (gtx_clk90),        // 125 MHz, 90 deg shift
      .refclk                       (refclk),           // IDELAYCTRL reference
  
      .rx_fifo_clock                (axi_aclk),          // RX AXI-S
      .rx_fifo_resetn               (axi_aclk_rstn),
      .rx_axis_fifo_tdata           (m_axis_tdata_internal),
      .rx_axis_fifo_tvalid          (m_axis_tvalid_internal),
      .rx_axis_fifo_tready          (m_axis_tready_internal),
      .rx_axis_fifo_tlast           (m_axis_tlast_internal),
  
      .tx_fifo_clock                (axi_aclk),          // TX AXI-S
      .tx_fifo_resetn               (axi_aclk_rstn),
      .tx_axis_fifo_tdata           (s_axis_tdata_internal),
      .tx_axis_fifo_tvalid          (s_axis_tvalid_internal),
      .tx_axis_fifo_tready          (s_axis_tready_internal),
      .tx_axis_fifo_tlast           (s_axis_tlast_internal),
  
  
      .rgmii_txd                    (rgmii_txd),        // RGMII to PHY
      .rgmii_tx_ctl                 (rgmii_tx_ctl),
      .rgmii_txc                    (rgmii_txc),
      .rgmii_rxd                    (rgmii_rxd),
      .rgmii_rx_ctl                 (rgmii_rx_ctl),
      .rgmii_rxc                    (rgmii_rxc),
  
      .rx_configuration_vector      (rx_configuration_vector),  // static configuration vectors
      .tx_configuration_vector      (tx_configuration_vector),
  
      .rx_mac_aclk                  (),         // receiver statistics - not used
      .rx_reset                     (),
      .rx_statistics_vector         (),
      .rx_statistics_valid          (),
  
      .tx_reset                     (),         // transmitter statistics - not used
      .tx_ifg_delay                 (8'h0),
      .tx_statistics_vector         (),
      .tx_statistics_valid          (),
  
      .pause_req                    (1'b0),     // control interface - not used
      .pause_val                    (16'h0),
  
      .inband_link_status           (),         // RGMII inband status - not used
      .inband_clock_speed           (),
      .inband_duplex_status         ()
  
   );

    wire [3:0]      s_axi_wstrb;
    assign s_axi_wstrb  = 4'b1111;

    temac_regs #(
        .C_FAMILY                       (C_FAMILY),
        .C_S_AXI_DATA_WIDTH             (C_S_AXI_DATA_WIDTH),
        .C_S_AXI_ADDR_WIDTH             (C_S_AXI_ADDR_WIDTH),
        // Default tx vector
        .C_TX_PAUSE_MAC_ADDR            (C_TX_PAUSE_MAC_ADDR),
        .C_TX_MAX_FRAME_SIZE            (C_TX_MAX_FRAME_SIZE),
        .C_TX_MAX_FRAME_EN              (C_TX_MAX_FRAME_EN),
        .C_TX_SPEED                     (C_TX_SPEED),
        .C_TX_IFG_ADJUST_EN             (C_TX_IFG_ADJUST_EN),
        .C_TX_HD_EN                     (C_TX_HD_EN),
        .C_TX_FC_EN                     (C_TX_FC_EN),
        .C_TX_JUMBO_EN                  (C_TX_JUMBO_EN),
        .C_TX_FCS_EN                    (C_TX_FCS_EN),
        .C_TX_VLAN_EN                   (C_TX_VLAN_EN),
        .C_TX_EN                        (C_TX_EN),
        .C_TX_RESET                     (C_TX_RESET),
        // Default rx vector
        .C_RX_PAUSE_MAC_ADDR            (C_RX_PAUSE_MAC_ADDR),
        .C_RX_MAX_FRAME_SIZE            (C_RX_MAX_FRAME_SIZE),
        .C_RX_MAX_FRAME_EN              (C_RX_MAX_FRAME_EN),
        .C_RX_SPEED                     (C_RX_SPEED),
        .C_RX_PROMISCUOUS_EN            (C_RX_PROMISCUOUS_EN),
        .C_RX_CONTROL_LEN_CHK_DIS       (C_RX_CONTROL_LEN_CHK_DIS),
        .C_RX_LEN_TYPE_CHK_DIS          (C_RX_LEN_TYPE_CHK_DIS),
        .C_RX_HD_EN                     (C_RX_HD_EN),
        .C_RX_FC_EN                     (C_RX_FC_EN),
        .C_RX_JUMBO_EN                  (C_RX_JUMBO_EN),
        .C_RX_FCS_EN                    (C_RX_FCS_EN),
        .C_RX_VLAN_EN                   (C_RX_VLAN_EN),
        .C_RX_EN                        (C_RX_EN),
        .C_RX_RESET                     (C_RX_RESET)
    ) temac_reg_i (
        .S_AXI_ACLK                     (s_axi_aclk),
        .S_AXI_ARESETN                  (s_axi_aresetn),
        .S_AXI_AWADDR                   (s_axi_awaddr),
        .S_AXI_AWVALID                  (s_axi_awvalid),
        .S_AXI_AWREADY                  (s_axi_awready),
        .S_AXI_WDATA                    (s_axi_wdata),
        .S_AXI_WSTRB                    (s_axi_wstrb),
        .S_AXI_WVALID                   (s_axi_wvalid),
        .S_AXI_WREADY                   (s_axi_wready),
        .S_AXI_BRESP                    (s_axi_bresp),
        .S_AXI_BVALID                   (s_axi_bvalid),
        .S_AXI_BREADY                   (s_axi_bready),
        .S_AXI_ARADDR                   (s_axi_araddr),
        .S_AXI_ARVALID                  (s_axi_arvalid),
        .S_AXI_ARREADY                  (s_axi_arready),
        .S_AXI_RDATA                    (s_axi_rdata),
        .S_AXI_RRESP                    (s_axi_rresp),
        .S_AXI_RVALID                   (s_axi_rvalid),
        .S_AXI_RREADY                   (s_axi_rready),

        .tx_cfg_vector                  (tx_configuration_vector),
        .rx_cfg_vector                  (rx_configuration_vector)
    );

  
  end
else if (C_MAC_SEL == 1)
  begin
  // instantiate Xilinx trimac block complete with internal registers
  trimac_fifo_block #(
       .C_BASE_ADDRESS              (C_BASEADDR),
       .C_INCLUDE_IDELAYCTRL        (C_INCLUDE_IDELAYCTRL)
   ) trimac_fifo_block (
    .glbl_rstn                    (glbl_rstn),        // resets
    .rx_axi_rstn                  (1'b1),
    .tx_axi_rstn                  (1'b1),

    .gtx_clk                      (gtx_clk),          // 125 MHz clock
    .gtx_clk90                    (gtx_clk90),        // 125 MHz, 90 deg shift
    .refclk                       (refclk),           // IDELAYCTRL reference

    .rx_fifo_clock                (axi_aclk),          // RX AXI-S
    .rx_fifo_resetn               (axi_aclk_rstn),
    .rx_axis_fifo_tdata           (m_axis_tdata_internal),
    .rx_axis_fifo_tvalid          (m_axis_tvalid_internal),
    .rx_axis_fifo_tready          (m_axis_tready_internal),
    .rx_axis_fifo_tlast           (m_axis_tlast_internal),

    .tx_fifo_clock                (axi_aclk),          // TX AXI-S
    .tx_fifo_resetn               (axi_aclk_rstn),
    .tx_axis_fifo_tdata           (s_axis_tdata_internal),
    .tx_axis_fifo_tvalid          (s_axis_tvalid_internal),
    .tx_axis_fifo_tready          (s_axis_tready_internal),
    .tx_axis_fifo_tlast           (s_axis_tlast_internal),

    .rgmii_txd                    (rgmii_txd),        // RGMII to PHY
    .rgmii_tx_ctl                 (rgmii_tx_ctl),
    .rgmii_txc                    (rgmii_txc),
    .rgmii_rxd                    (rgmii_rxd),
    .rgmii_rx_ctl                 (rgmii_rx_ctl),
    .rgmii_rxc                    (rgmii_rxc),

    .s_axi_aclk                   (s_axi_aclk),       // AXI-lite
    .s_axi_resetn                 (s_axi_aresetn),
    .s_axi_awaddr                 (s_axi_awaddr),
    .s_axi_awvalid                (s_axi_awvalid),
    .s_axi_awready                (s_axi_awready),
    .s_axi_wdata                  (s_axi_wdata),
    .s_axi_wvalid                 (s_axi_wvalid),
    .s_axi_wready                 (s_axi_wready),
    .s_axi_bresp                  (s_axi_bresp),
    .s_axi_bvalid                 (s_axi_bvalid),
    .s_axi_bready                 (s_axi_bready),
    .s_axi_araddr                 (s_axi_araddr),
    .s_axi_arvalid                (s_axi_arvalid),
    .s_axi_arready                (s_axi_arready),
    .s_axi_rdata                  (s_axi_rdata),
    .s_axi_rresp                  (s_axi_rresp),
    .s_axi_rvalid                 (s_axi_rvalid),
    .s_axi_rready                 (s_axi_rready),

    .rx_mac_aclk                  (),           // receiver statistics - not used
    .rx_reset                     (),
    .rx_statistics_vector         (),
    .rx_statistics_valid          (),

    .tx_reset                     (),           // transmitter statistics - not used
    .tx_ifg_delay                 (8'h0),
    .tx_statistics_vector         (),
    .tx_statistics_valid          (),

    .pause_req                    (1'b0),       // control interface - not used
    .pause_val                    (16'h0),

    .inband_link_status           (),           // RGMII inband status - not used
    .inband_clock_speed           (),
    .inband_duplex_status         (),

    .mdio                         (),   // MDIO - not used
    .mdc                          ()
   );
  end
else
  begin
  wire [79:0] rx_configuration_vector;
  wire [79:0] tx_configuration_vector;

   // Instantiate UCSD Gig Eth MAC
   gig_eth_mac_fifo_block #(C_INCLUDE_IDELAYCTRL) gig_eth_mac_fifo_block
      (
      .gtx_clk                      (gtx_clk),
      .gtx_clk90                    (gtx_clk90),
      // asynchronous reset
      .glbl_rstn                    (glbl_rstn),

      // Reference clock for IDELAYCTRL's
      .refclk                       (refclk),

      .rx_fifo_clock                (axi_aclk),          // RX AXI-S
      .rx_fifo_resetn               (axi_aclk_rstn),
      .rx_axis_fifo_tdata           (m_axis_tdata_internal),
      .rx_axis_fifo_tvalid          (m_axis_tvalid_internal),
      .rx_axis_fifo_tready          (m_axis_tready_internal),
      .rx_axis_fifo_tlast           (m_axis_tlast_internal),
  
      .tx_fifo_clock                (axi_aclk),          // TX AXI-S
      .tx_fifo_resetn               (axi_aclk_rstn),
      .tx_axis_fifo_tdata           (s_axis_tdata_internal),
      .tx_axis_fifo_tvalid          (s_axis_tvalid_internal),
      .tx_axis_fifo_tready          (s_axis_tready_internal),
      .tx_axis_fifo_tlast           (s_axis_tlast_internal),
  
  
      .rgmii_txd                    (rgmii_txd),        // RGMII to PHY
      .rgmii_tx_ctl                 (rgmii_tx_ctl),
      .rgmii_txc                    (rgmii_txc),
      .rgmii_rxd                    (rgmii_rxd),
      .rgmii_rx_ctl                 (rgmii_rx_ctl),
      .rgmii_rxc                    (rgmii_rxc),

	  // Configuration Options 
      .conf_tx_en       (tx_configuration_vector[1]),
      .conf_rx_en       (rx_configuration_vector[1]),
      .conf_tx_no_gen_crc (tx_configuration_vector[3]),
      .conf_rx_no_chk_crc (~rx_configuration_vector[3]),
      .conf_tx_jumbo_en   (tx_configuration_vector[4]),
      .conf_rx_jumbo_en   (rx_configuration_vector[4])
   );

    wire [3:0]      s_axi_wstrb;
    assign s_axi_wstrb  = 4'b1111;

    temac_regs #(
        .C_FAMILY                       (C_FAMILY),
        .C_S_AXI_DATA_WIDTH             (C_S_AXI_DATA_WIDTH),
        .C_S_AXI_ADDR_WIDTH             (C_S_AXI_ADDR_WIDTH),
        // Default tx vector
        .C_TX_PAUSE_MAC_ADDR            (C_TX_PAUSE_MAC_ADDR),
        .C_TX_MAX_FRAME_SIZE            (C_TX_MAX_FRAME_SIZE),
        .C_TX_MAX_FRAME_EN              (C_TX_MAX_FRAME_EN),
        .C_TX_SPEED                     (C_TX_SPEED),
        .C_TX_IFG_ADJUST_EN             (C_TX_IFG_ADJUST_EN),
        .C_TX_HD_EN                     (C_TX_HD_EN),
        .C_TX_FC_EN                     (C_TX_FC_EN),
        .C_TX_JUMBO_EN                  (C_TX_JUMBO_EN),
        .C_TX_FCS_EN                    (C_TX_FCS_EN),
        .C_TX_VLAN_EN                   (C_TX_VLAN_EN),
        .C_TX_EN                        (C_TX_EN),
        .C_TX_RESET                     (C_TX_RESET),
        // Default rx vector
        .C_RX_PAUSE_MAC_ADDR            (C_RX_PAUSE_MAC_ADDR),
        .C_RX_MAX_FRAME_SIZE            (C_RX_MAX_FRAME_SIZE),
        .C_RX_MAX_FRAME_EN              (C_RX_MAX_FRAME_EN),
        .C_RX_SPEED                     (C_RX_SPEED),
        .C_RX_PROMISCUOUS_EN            (C_RX_PROMISCUOUS_EN),
        .C_RX_CONTROL_LEN_CHK_DIS       (C_RX_CONTROL_LEN_CHK_DIS),
        .C_RX_LEN_TYPE_CHK_DIS          (C_RX_LEN_TYPE_CHK_DIS),
        .C_RX_HD_EN                     (C_RX_HD_EN),
        .C_RX_FC_EN                     (C_RX_FC_EN),
        .C_RX_JUMBO_EN                  (C_RX_JUMBO_EN),
        .C_RX_FCS_EN                    (C_RX_FCS_EN),
        .C_RX_VLAN_EN                   (C_RX_VLAN_EN),
        .C_RX_EN                        (C_RX_EN),
        .C_RX_RESET                     (C_RX_RESET)
    ) temac_reg_i (
        .S_AXI_ACLK                     (s_axi_aclk),
        .S_AXI_ARESETN                  (s_axi_aresetn),
        .S_AXI_AWADDR                   (s_axi_awaddr),
        .S_AXI_AWVALID                  (s_axi_awvalid),
        .S_AXI_AWREADY                  (s_axi_awready),
        .S_AXI_WDATA                    (s_axi_wdata),
        .S_AXI_WSTRB                    (s_axi_wstrb),
        .S_AXI_WVALID                   (s_axi_wvalid),
        .S_AXI_WREADY                   (s_axi_wready),
        .S_AXI_BRESP                    (s_axi_bresp),
        .S_AXI_BVALID                   (s_axi_bvalid),
        .S_AXI_BREADY                   (s_axi_bready),
        .S_AXI_ARADDR                   (s_axi_araddr),
        .S_AXI_ARVALID                  (s_axi_arvalid),
        .S_AXI_ARREADY                  (s_axi_arready),
        .S_AXI_RDATA                    (s_axi_rdata),
        .S_AXI_RRESP                    (s_axi_rresp),
        .S_AXI_RVALID                   (s_axi_rvalid),
        .S_AXI_RREADY                   (s_axi_rready),

        .tx_cfg_vector                  (tx_configuration_vector),
        .rx_cfg_vector                  (rx_configuration_vector)
    );

  end 
endgenerate 

    /* RX Path */
    nf10_axis_converter #(
        .C_M_AXIS_DATA_WIDTH    (C_M_AXIS_DATA_WIDTH),
        .C_S_AXIS_DATA_WIDTH    (C_M_AXIS_DATA_WIDTH_INTERNAL),
        .C_DEFAULT_VALUE_ENABLE (C_DEFAULT_VALUE_ENABLE),
        .C_DEFAULT_SRC_PORT     (C_DEFAULT_SRC_PORT),
        .C_DEFAULT_DST_PORT     (C_DEFAULT_DST_PORT)
    ) rx_path_converter (
        .axi_aclk               (axi_aclk),
        .axi_resetn             (axi_aclk_rstn),
        .m_axis_tdata           (m_axis_tdata),
        .m_axis_tstrb           (m_axis_tstrb),
        .m_axis_tvalid          (m_axis_tvalid),
        .m_axis_tready          (m_axis_tready),
        .m_axis_tlast           (m_axis_tlast),
        .m_axis_tuser           (m_axis_tuser),
        .s_axis_tdata           (m_axis_tdata_internal),
        .s_axis_tstrb           (m_axis_tstrb_internal),
        .s_axis_tvalid          (m_axis_tvalid_internal),
        .s_axis_tready          (m_axis_tready_internal),
        .s_axis_tlast           (m_axis_tlast_internal),
        .s_axis_tuser           (m_axis_tuser_internal)
    );

    /* TX Path */
    nf10_axis_converter #(
        .C_M_AXIS_DATA_WIDTH    (C_S_AXIS_DATA_WIDTH_INTERNAL),
        .C_S_AXIS_DATA_WIDTH    (C_S_AXIS_DATA_WIDTH)
    ) tx_path_converter (
        .axi_aclk               (axi_aclk),
        .axi_resetn             (axi_aclk_rstn),
        .m_axis_tdata           (s_axis_tdata_internal),
        .m_axis_tstrb           (s_axis_tstrb_internal),
        .m_axis_tvalid          (s_axis_tvalid_internal),
        .m_axis_tready          (s_axis_tready_internal),
        .m_axis_tlast           (s_axis_tlast_internal),
        .m_axis_tuser           (s_axis_tuser_internal),
        .s_axis_tdata           (s_axis_tdata),
        .s_axis_tstrb           (s_axis_tstrb),
        .s_axis_tvalid          (s_axis_tvalid),
        .s_axis_tready          (s_axis_tready),
        .s_axis_tlast           (s_axis_tlast),
        .s_axis_tuser           (s_axis_tuser)
    );


endmodule
