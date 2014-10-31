/*******************************************************************************
 *
 *  NetFPGA-10G http://www.netfpga.org
 *
 *  File:
 *        nf10_10g_interface.v
 *
 *  Library:
 *        hw/std/pcores/nf10_10g_interface_v1_20_a
 *
 *  Module:
 *        nf10_10g_interface
 *
 *  Author:
 *        James Hongyi Zeng
 *
 *  Modified :
 *        Neelakandan Manihatty Bojan (to add registers on 25th February 2014)
 *
 *  Description:
 *        This is the combination of AXI interface, 10G MAC and XAUI
 *        C_XAUI_REVERSE=1 means the XAUI GTX lanes are reversed. This
 *        is used on NetFPGA-10G board Port 0, 1, 2. Please consult
 *        board schematic first before modifying the default value.
 *
 *                        / rx_queue (AXI Master)
 *        XAUI - 10G MAC
 *                        \ tx_queue (AXI Slave)
 *
 *  Copyright notice:
 *        Copyright (C) 2010, 2011 The Board of Trustees of The Leland Stanford
 *                                 Junior University
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

`uselib lib=unisims_ver
`uselib lib=proc_common_v3_00_a

module nf10_10g_interface
#(
    parameter C_FAMILY              = "virtex5",
    // Master AXI Stream Data Width
    parameter C_M_AXIS_DATA_WIDTH=64,
    parameter C_S_AXIS_DATA_WIDTH=64,
    parameter C_XAUI_REVERSE=0,
    parameter C_XGMAC_CONFIGURATION = {5'b01000, 64'h0583000000000000},
    parameter C_XAUI_CONFIGURATION = 7'b0,
    parameter C_M_AXIS_TUSER_WIDTH=128,
    parameter C_S_AXIS_TUSER_WIDTH=128,
    parameter C_DEFAULT_VALUE_ENABLE = 0,
    parameter C_DEFAULT_SRC_PORT = 0,
    parameter C_DEFAULT_DST_PORT = 0,

    // AXI Data Width
    parameter C_S_AXI_DATA_WIDTH    = 32,          
    parameter C_S_AXI_ADDR_WIDTH    = 32,          
    parameter C_USE_WSTRB           = 0,
    parameter C_DPHASE_TIMEOUT      = 0,
    parameter C_BASEADDR            = 32'hFFFFFFFF,
    parameter C_HIGHADDR            = 32'h00000000,
    parameter C_S_AXI_ACLK_FREQ_HZ  = 100
)
(
    // Part 1: System side signals
    // Global Ports
    input axi_aclk,
    input axi_resetn,

    input dclk,   //DRP Clock 50MHz
    input refclk, //GTX Clock 156.25MHz

    // Master Stream Ports
    output [C_M_AXIS_DATA_WIDTH - 1:0] m_axis_tdata,
    output [((C_M_AXIS_DATA_WIDTH / 8)) - 1:0] m_axis_tstrb,
    output [C_M_AXIS_TUSER_WIDTH-1:0] m_axis_tuser, // Dummy AXI TUSER
    output m_axis_tvalid,
    input  m_axis_tready,
    output m_axis_tlast,

    // Slave Stream Ports
    input [C_S_AXIS_DATA_WIDTH - 1:0] s_axis_tdata,
    input [((C_S_AXIS_DATA_WIDTH / 8)) - 1:0] s_axis_tstrb,
    input [C_S_AXIS_TUSER_WIDTH-1:0] s_axis_tuser,
    input  s_axis_tvalid,
    output s_axis_tready,
    input  s_axis_tlast,

    // Signals for AXI_IP and IF_REG (Added by neels for testing)
    // Slave AXI Ports
    input                                     S_AXI_ACLK,
    //input                                     S_AXI_ARESETN,
    input      [C_S_AXI_ADDR_WIDTH-1 : 0]     S_AXI_AWADDR,
    input                                     S_AXI_AWVALID,
    input      [C_S_AXI_DATA_WIDTH-1 : 0]     S_AXI_WDATA,
    input      [C_S_AXI_DATA_WIDTH/8-1 : 0]   S_AXI_WSTRB,
    input                                     S_AXI_WVALID,
    input                                     S_AXI_BREADY,
    input      [C_S_AXI_ADDR_WIDTH-1 : 0]     S_AXI_ARADDR,
    input                                     S_AXI_ARVALID,
    input                                     S_AXI_RREADY,
    output                                    S_AXI_ARREADY,
    output     [C_S_AXI_DATA_WIDTH-1 : 0]     S_AXI_RDATA,
    output     [1 : 0]                        S_AXI_RRESP,
    output                                    S_AXI_RVALID,
    output                                    S_AXI_WREADY,
    output     [1 :0]                         S_AXI_BRESP,
    output                                    S_AXI_BVALID,
    output                                    S_AXI_AWREADY,



    // Part 2: PHY side signals
    // XAUI PHY Interface
    output        xaui_tx_l0_p,
    output        xaui_tx_l0_n,
    output        xaui_tx_l1_p,
    output        xaui_tx_l1_n,
    output        xaui_tx_l2_p,
    output        xaui_tx_l2_n,
    output        xaui_tx_l3_p,
    output        xaui_tx_l3_n,

    input         xaui_rx_l0_p,
    input         xaui_rx_l0_n,
    input         xaui_rx_l1_p,
    input         xaui_rx_l1_n,
    input         xaui_rx_l2_p,
    input         xaui_rx_l2_n,
    input         xaui_rx_l3_p,
    input         xaui_rx_l3_n
);

  localparam C_M_AXIS_DATA_WIDTH_INTERNAL=64;
  localparam C_S_AXIS_DATA_WIDTH_INTERNAL=64;

  localparam NUM_RW_REGS       = 1;
  localparam NUM_RO_REGS       = 17;

    wire                                            Bus2IP_Clk;
    wire                                            Bus2IP_Resetn;
    wire     [C_S_AXI_ADDR_WIDTH-1 : 0]             Bus2IP_Addr;
    wire     [0:0]                                  Bus2IP_CS;
    wire                                            Bus2IP_RNW;
    wire     [C_S_AXI_DATA_WIDTH-1 : 0]             Bus2IP_Data;
    wire     [C_S_AXI_DATA_WIDTH/8-1 : 0]           Bus2IP_BE;
    wire     [C_S_AXI_DATA_WIDTH-1 : 0]             IP2Bus_Data;
    wire                                            IP2Bus_RdAck;
    wire                                            IP2Bus_WrAck;
    wire                                            IP2Bus_Error;

  wire clk156, txoutclk;

  wire [63:0] xgmii_rxd, xgmii_txd;
  wire [ 7:0] xgmii_rxc, xgmii_txc;

  wire [63 : 0] tx_data;
  wire [7 : 0]  tx_data_valid;
  wire          tx_start;
  wire          tx_ack;

  wire [63 : 0] rx_data;
  wire [7 : 0]  rx_data_valid;

  wire          rx_good_frame;
  wire          rx_bad_frame;

    // Master Stream Ports
    wire [C_M_AXIS_DATA_WIDTH_INTERNAL - 1:0] m_axis_tdata_internal;
    wire [((C_M_AXIS_DATA_WIDTH_INTERNAL / 8)) - 1:0] m_axis_tstrb_internal;
    wire [C_M_AXIS_TUSER_WIDTH-1:0] m_axis_tuser_internal; // Dummy AXI TUSER
    wire m_axis_tvalid_internal;
    wire  m_axis_tready_internal;
    wire m_axis_tlast_internal;

    // Slave Stream Ports
    wire [C_S_AXIS_DATA_WIDTH_INTERNAL - 1:0] s_axis_tdata_internal;
    wire [((C_S_AXIS_DATA_WIDTH_INTERNAL / 8)) - 1:0] s_axis_tstrb_internal;
    wire [C_S_AXIS_TUSER_WIDTH-1:0] s_axis_tuser_internal;
    wire  s_axis_tvalid_internal;
    wire  s_axis_tready_internal;


    wire  s_axis_tlast_internal;

//    wire  drop_pkt;
    wire info_fifo_rd_en;
    wire info_fifo_wr_en;
    wire fifo_wr_en;
reg [31:0] tx_enqueued_pkts, tx_enqueued_bytes;

// read-write and read-only regiters declaration
  wire     [NUM_RW_REGS*C_S_AXI_DATA_WIDTH-1 : 0] rw_regs;
  wire     [NUM_RO_REGS*C_S_AXI_DATA_WIDTH-1 : 0] ro_regs;


  reg      [C_S_AXI_DATA_WIDTH-1 : 0]             tx_dequeued_pkts;	
  reg      [C_S_AXI_DATA_WIDTH-1 : 0]             drop_pkt_counter;	
  wire                                            rst_cntrs;

// rx_queues  
  
  reg      [C_S_AXI_DATA_WIDTH-1 : 0]             good_frames_counter;
  reg      [C_S_AXI_DATA_WIDTH-1 : 0]             bad_frames_counter;
  reg [31:0] bytes_from_mac_ff;
  reg [31:0] num_rx, rx_enqueued_bytes_ff;
  wire [31:0] bytes_from_mac;
  reg [31:0] rx_enqueued_pkts; 
  wire [31:0] rx_enqueued_bytes;
  reg [31:0] rx_dequeued_pkts, rx_dequeued_bytes;
  reg [31:0] rx_bytes_in_queue, rx_pkts_in_queue;
  reg [31:0] rx_pkts_dropped, rx_bytes_dropped;

// tx_queues  
  wire  tx_dequeued_pkt;
  wire  tx_pkts_enqueued_signal;
  wire  [15:0] tx_bytes_enqueued;
  reg [31:0] tx_dequeued_bytes_ff,tx_dequeued_bytes_ff_d, tx_dequeued_bytes_ff_dd;
  wire [31:0] tx_dequeued_bytes;
  reg [31:0] tx_bytes_in_queue, tx_pkts_in_queue;
  reg [31:0] tx_pkts_dropped, tx_bytes_dropped;

  wire be;


  wire reset = ~axi_resetn;
  assign m_axis_tuser_internal = {(C_M_AXIS_TUSER_WIDTH){1'b0}};


  // =============================================================================
  // Module Instantiation
  // =============================================================================

  // Put system clocks on global routing
  BUFG clk156_bufg (
    .I(txoutclk),
    .O(clk156));

  xaui_block
  #(.WRAPPER_SIM_GTXRESET_SPEEDUP(1),
    .REVERSE_LANES(C_XAUI_REVERSE)
   ) xaui_block
  (
    .reset         (reset),
    .reset156      (reset),
    .clk156        (clk156),
    .dclk          (dclk),
    .refclk        (refclk),
    .txoutclk      (txoutclk),

    .xgmii_txd     (xgmii_txd),
    .xgmii_txc     (xgmii_txc),
    .xgmii_rxd     (xgmii_rxd),
    .xgmii_rxc     (xgmii_rxc),

    .xaui_tx_l0_p  (xaui_tx_l0_p),
    .xaui_tx_l0_n  (xaui_tx_l0_n),
    .xaui_tx_l1_p  (xaui_tx_l1_p),
    .xaui_tx_l1_n  (xaui_tx_l1_n),
    .xaui_tx_l2_p  (xaui_tx_l2_p),
    .xaui_tx_l2_n  (xaui_tx_l2_n),
    .xaui_tx_l3_p  (xaui_tx_l3_p),
    .xaui_tx_l3_n  (xaui_tx_l3_n),
    .xaui_rx_l0_p  (xaui_rx_l0_p),
    .xaui_rx_l0_n  (xaui_rx_l0_n),
    .xaui_rx_l1_p  (xaui_rx_l1_p),
    .xaui_rx_l1_n  (xaui_rx_l1_n),
    .xaui_rx_l2_p  (xaui_rx_l2_p),
    .xaui_rx_l2_n  (xaui_rx_l2_n),
    .xaui_rx_l3_p  (xaui_rx_l3_p),
    .xaui_rx_l3_n  (xaui_rx_l3_n),

    .txlock        (clk156_locked),
    .signal_detect (4'b1111),
    .drp_i         (16'h0),
    .drp_addr      (7'b0),
    .drp_en        (2'b0),
    .drp_we        (2'b0),
    .drp_o         (),
    .drp_rdy       (),
    .configuration_vector (C_XAUI_CONFIGURATION),
    .status_vector ()
  );


   ////////////////////////
   // Instantiate the MAC
   ////////////////////////
   xgmac xgmac
     (
      .reset                (reset),

      .tx_underrun          (1'b0),
      .tx_data              (tx_data),
      .tx_data_valid        (tx_data_valid),
      .tx_start             (tx_start),
      .tx_ack               (tx_ack),
      .tx_ifg_delay         (8'b0),
      .tx_statistics_vector (),
      .tx_statistics_valid  (),
      .pause_val            (16'h0),
      .pause_req            (1'b0),

      .rx_data              (rx_data),
      .rx_data_valid        (rx_data_valid),
      .rx_good_frame        (rx_good_frame),
      .rx_bad_frame         (rx_bad_frame),
      .rx_statistics_vector (),
      .rx_statistics_valid  (),

      .configuration_vector (C_XGMAC_CONFIGURATION),

      .tx_clk0(clk156),
      .tx_dcm_lock(clk156_locked),
      .xgmii_txd(xgmii_txd),
      .xgmii_txc(xgmii_txc),

      .rx_clk0(clk156),
      .rx_dcm_lock(clk156_locked),
      .xgmii_rxd(xgmii_rxd),
      .xgmii_rxc(xgmii_rxc)
      );

    ////////////////////////////////
    // Instantiate the AXI Converter
    ////////////////////////////////
    rx_queue #(
       .AXI_DATA_WIDTH(C_M_AXIS_DATA_WIDTH_INTERNAL)
    )rx_queue (
       // AXI side
       .tdata(m_axis_tdata_internal),
       .tstrb(m_axis_tstrb_internal),
       .tvalid(m_axis_tvalid_internal),
       .tlast(m_axis_tlast_internal),
       .tready(m_axis_tready_internal),
       .clk(axi_aclk),
       .reset(~axi_resetn),
       .fifo_wr_en(fifo_wr_en),
       // MAC side
       .rx_data(rx_data),
       .rx_data_valid(rx_data_valid),
       .rx_good_frame(rx_good_frame),
       .rx_bad_frame(rx_bad_frame),
       .clk156(clk156)
    );

    tx_queue #(
       .AXI_DATA_WIDTH(C_S_AXIS_DATA_WIDTH_INTERNAL),
       .C_S_AXIS_TUSER_WIDTH(C_S_AXIS_TUSER_WIDTH)
    )
    tx_queue (
       // AXI side
       .tuser(s_axis_tuser_internal),
       .tdata(s_axis_tdata_internal),
       .tstrb(s_axis_tstrb_internal),
       .tvalid(s_axis_tvalid_internal),
       .tlast(s_axis_tlast_internal),
       .tready(s_axis_tready_internal),
       .tx_dequeued_pkt(tx_dequeued_pkt),
       .tx_pkts_enqueued_signal(tx_pkts_enqueued_signal),
       .tx_bytes_enqueued(tx_bytes_enqueued),
       .be(be),
       .clk(axi_aclk),
       .reset(~axi_resetn),
       // MAC side
       .tx_data(tx_data),
       .tx_data_valid(tx_data_valid),
       .tx_start(tx_start),
       .tx_ack(tx_ack),
       .clk156(clk156)
    );

    nf10_axis_converter
    #(.C_M_AXIS_DATA_WIDTH(C_M_AXIS_DATA_WIDTH),
      .C_S_AXIS_DATA_WIDTH(C_M_AXIS_DATA_WIDTH_INTERNAL),
      .C_DEFAULT_VALUE_ENABLE(C_DEFAULT_VALUE_ENABLE),
      .C_DEFAULT_SRC_PORT(C_DEFAULT_SRC_PORT),
      .C_DEFAULT_DST_PORT(C_DEFAULT_DST_PORT)
     ) converter_master
    (
    // Global Ports
    .axi_aclk(axi_aclk),
    .axi_resetn(axi_resetn),

    // Master Stream Ports
    .m_axis_tdata(m_axis_tdata),
    .m_axis_tstrb(m_axis_tstrb),
    .m_axis_tvalid(m_axis_tvalid),
    .m_axis_tready(m_axis_tready),
    .m_axis_tlast(m_axis_tlast),
	.m_axis_tuser(m_axis_tuser),

    // Slave Stream Ports
    .s_axis_tdata(m_axis_tdata_internal),
    .s_axis_tstrb(m_axis_tstrb_internal),
    .s_axis_tvalid(m_axis_tvalid_internal),
    .s_axis_tready(m_axis_tready_internal),
    .s_axis_tlast(m_axis_tlast_internal),
	.s_axis_tuser(m_axis_tuser_internal)
   );

    nf10_axis_converter
    #(.C_M_AXIS_DATA_WIDTH(C_S_AXIS_DATA_WIDTH_INTERNAL),
      .C_S_AXIS_DATA_WIDTH(C_S_AXIS_DATA_WIDTH)
     ) converter_slave
    (
    // Global Ports
    .axi_aclk(axi_aclk),
    .axi_resetn(axi_resetn),

    // Master Stream Ports
    .m_axis_tdata(s_axis_tdata_internal),
    .m_axis_tstrb(s_axis_tstrb_internal),
    .m_axis_tvalid(s_axis_tvalid_internal),
    .m_axis_tready(s_axis_tready_internal),
    .m_axis_tlast(s_axis_tlast_internal),
	 .m_axis_tuser(s_axis_tuser_internal),

    // Slave Stream Ports
    .s_axis_tdata(s_axis_tdata),
    .s_axis_tstrb(s_axis_tstrb),
    .s_axis_tvalid(s_axis_tvalid),
    .s_axis_tready(s_axis_tready),
    .s_axis_tlast(s_axis_tlast),
	.s_axis_tuser(s_axis_tuser)
   );

 // -- AXILITE IPIF
  axi_lite_ipif_1bar #
  (
    .C_S_AXI_DATA_WIDTH (C_S_AXI_DATA_WIDTH),
    .C_S_AXI_ADDR_WIDTH (C_S_AXI_ADDR_WIDTH),
    .C_USE_WSTRB        (C_USE_WSTRB),
    .C_DPHASE_TIMEOUT   (C_DPHASE_TIMEOUT),
    .C_BAR0_BASEADDR    (C_BASEADDR),
    .C_BAR0_HIGHADDR    (C_HIGHADDR)
  ) axi_lite_ipif_inst
  (
    .S_AXI_ACLK          ( S_AXI_ACLK     ),
    .S_AXI_ARESETN       ( axi_resetn     ),
    .S_AXI_AWADDR        ( S_AXI_AWADDR   ),
    .S_AXI_AWVALID       ( S_AXI_AWVALID  ),
    .S_AXI_WDATA         ( S_AXI_WDATA    ),
    .S_AXI_WSTRB         ( S_AXI_WSTRB    ),
    .S_AXI_WVALID        ( S_AXI_WVALID   ),
    .S_AXI_BREADY        ( S_AXI_BREADY   ),
    .S_AXI_ARADDR        ( S_AXI_ARADDR   ),
    .S_AXI_ARVALID       ( S_AXI_ARVALID  ),
    .S_AXI_RREADY        ( S_AXI_RREADY   ),
    .S_AXI_ARREADY       ( S_AXI_ARREADY  ),
    .S_AXI_RDATA         ( S_AXI_RDATA    ),
    .S_AXI_RRESP         ( S_AXI_RRESP    ),
    .S_AXI_RVALID        ( S_AXI_RVALID   ),
    .S_AXI_WREADY        ( S_AXI_WREADY   ),
    .S_AXI_BRESP         ( S_AXI_BRESP    ),
    .S_AXI_BVALID        ( S_AXI_BVALID   ),
    .S_AXI_AWREADY       ( S_AXI_AWREADY  ),
	
	// Controls to the IP/IPIF modules
    .Bus2IP_Clk          ( Bus2IP_Clk     ),
    .Bus2IP_Resetn       ( Bus2IP_Resetn  ),
    .Bus2IP_Addr         ( Bus2IP_Addr    ),
    .Bus2IP_RNW          ( Bus2IP_RNW     ),
    .Bus2IP_BE           ( Bus2IP_BE      ),
    .Bus2IP_CS           ( Bus2IP_CS      ),
    .Bus2IP_Data         ( Bus2IP_Data    ),
    .IP2Bus_Data         ( IP2Bus_Data    ),
    .IP2Bus_WrAck        ( IP2Bus_WrAck   ),
    .IP2Bus_RdAck        ( IP2Bus_RdAck   ),
    .IP2Bus_Error        ( IP2Bus_Error   )
  );

  // -- IPIF REGS
  ipif_regs #
  (
    .C_S_AXI_DATA_WIDTH (C_S_AXI_DATA_WIDTH),          
    .C_S_AXI_ADDR_WIDTH (C_S_AXI_ADDR_WIDTH),   
    .NUM_RW_REGS        (NUM_RW_REGS),
    .NUM_RO_REGS        (NUM_RO_REGS)
  ) ipif_regs_inst
  (   
    .Bus2IP_Clk     ( Bus2IP_Clk     ),
    .Bus2IP_Resetn  ( Bus2IP_Resetn  ), 
    .Bus2IP_Addr    ( Bus2IP_Addr    ),
    .Bus2IP_CS      ( Bus2IP_CS[0]   ),
    .Bus2IP_RNW     ( Bus2IP_RNW     ),
    .Bus2IP_Data    ( Bus2IP_Data    ),
    .Bus2IP_BE      ( Bus2IP_BE      ),
    .IP2Bus_Data    ( IP2Bus_Data    ),
    .IP2Bus_RdAck   ( IP2Bus_RdAck   ),
    .IP2Bus_WrAck   ( IP2Bus_WrAck   ),
    .IP2Bus_Error   ( IP2Bus_Error   ),
	
	.rw_regs        ( rw_regs ),
    .ro_regs        ( ro_regs )
  );

assign rst_cntrs = rw_regs[0];

assign ro_regs = {rx_bytes_dropped, rx_pkts_dropped, tx_bytes_in_queue, tx_pkts_in_queue, rx_bytes_in_queue, rx_pkts_in_queue, tx_dequeued_bytes, tx_dequeued_pkts, tx_enqueued_bytes, tx_enqueued_pkts,rx_dequeued_bytes, rx_dequeued_pkts, rx_enqueued_bytes,  rx_enqueued_pkts, bytes_from_mac, good_frames_counter, bad_frames_counter};


// rx_good_frame is received from MAC side,
// the following logic creates a pulse to compute the number of good frames received from mac

reg rx_good_frame_d1, rx_good_frame_d2;
always @(posedge clk156)
	if (~axi_resetn) begin
		rx_good_frame_d1 <= 0;
		rx_good_frame_d2 <= 0;
	end
        else if (rst_cntrs) begin
                rx_good_frame_d1 <= 0;
                rx_good_frame_d2 <= 0;
        end
	else begin
		rx_good_frame_d1 <= rx_good_frame;
		rx_good_frame_d2 <= rx_good_frame_d1;
	end

wire rx_good_frame_sig;
assign rx_good_frame_sig = rx_good_frame_d1 & ~rx_good_frame_d2;



// rx_bad_frame is received from MAC side,
// the following logic creates a pulse to compute the number of bad frames received

reg rx_bad_frame_d1, rx_bad_frame_d2;
always @(posedge clk156)
	if (~axi_resetn) begin
		rx_bad_frame_d1 <= 0;
		rx_bad_frame_d2 <= 0;
	end
        else if (rst_cntrs) begin
                rx_bad_frame_d1 <= 0;
                rx_bad_frame_d2 <= 0;
        end

	else begin
		rx_bad_frame_d1 <= rx_bad_frame;
		rx_bad_frame_d2 <= rx_bad_frame_d1;
	end

wire rx_bad_frame_sig;
assign rx_bad_frame_sig = rx_bad_frame_d1 & ~rx_bad_frame_d2;
	


reg tx_dequeued_pkt_d1, tx_dequeued_pkt_d2;
always @(posedge clk156)
        if (~axi_resetn) begin
                tx_dequeued_pkt_d1 <= 0;
                tx_dequeued_pkt_d2 <= 0;
        end
        else if (rst_cntrs) begin
                tx_dequeued_pkt_d1 <= 0;
                tx_dequeued_pkt_d2 <= 0;
        end
        else begin
                tx_dequeued_pkt_d1 <= tx_dequeued_pkt;
                tx_dequeued_pkt_d2 <= tx_dequeued_pkt_d1;
        end

wire tx_dequeued_pkt_sig;
assign tx_dequeued_pkt_sig = tx_dequeued_pkt_d1 & ~tx_dequeued_pkt_d2;


reg [31:0] num;

always @(*) begin//{
num = 'd0;

case(rx_data_valid)
8'b00000001 : num ='d1;
8'b00000011 : num ='d2;
8'b00000111 : num ='d3;
8'b00001111 : num ='d4;
8'b00011111 : num ='d5;
8'b00111111 : num ='d6;
8'b01111111 : num ='d7;
8'b11111111 : num ='d8;
default: num ='d0;
endcase 
end//}
	

always@(posedge clk156)
      if(~axi_resetn)
              bytes_from_mac_ff <= 'b0;
      else if(rst_cntrs)
              bytes_from_mac_ff <= 'b0;
       else
              bytes_from_mac_ff <= bytes_from_mac_ff+ num;

assign bytes_from_mac = bytes_from_mac_ff;


// rx_enqueued_bytes calculation

always @(*) begin//{
num_rx = 'd0;

case(rx_data_valid)
8'b00000001 : num_rx ='d1;
8'b00000011 : num_rx ='d2;
8'b00000111 : num_rx ='d3;
8'b00001111 : num_rx ='d4;
8'b00011111 : num_rx ='d5;
8'b00111111 : num_rx ='d6;
8'b01111111 : num_rx ='d7;
8'b11111111 : num_rx ='d8;
default: num_rx ='d0;
endcase
end//}


always@(posedge clk156)
      if(~axi_resetn)
              rx_enqueued_bytes_ff <= 'b0;
      else if(rst_cntrs)
              rx_enqueued_bytes_ff <= 'b0;
       else if (fifo_wr_en)
              rx_enqueued_bytes_ff <= rx_enqueued_bytes_ff+ num_rx;
	else
	      rx_enqueued_bytes_ff  <= rx_enqueued_bytes_ff; 
assign rx_enqueued_bytes = rx_enqueued_bytes_ff;


// tx_queue_dequeue calculation

reg [31:0] num_tx;
//reg [31:0] tx_dequeued_bytes_ff;
//wire [31:0] tx_dequeued_bytes;

always @(*) begin//{
num_tx = 'd0;

case(tx_data_valid)
8'b00000001 : num_tx ='d1;
8'b00000011 : num_tx ='d2;
8'b00000111 : num_tx ='d3;
8'b00001111 : num_tx ='d4;
8'b00011111 : num_tx ='d5;
8'b00111111 : num_tx ='d6;
8'b01111111 : num_tx ='d7;
8'b11111111 : num_tx ='d8;
default: num_tx ='d0;
endcase
end//}


always@(posedge clk156)
      if(~axi_resetn)
              tx_dequeued_bytes_ff <= 'b0;
      else if(rst_cntrs)
              tx_dequeued_bytes_ff <= 'b0;
       else if(be)
              tx_dequeued_bytes_ff <= tx_dequeued_bytes_ff+ num_tx;
	else
		tx_dequeued_bytes_ff <= tx_dequeued_bytes_ff;


//assign tx_dequeued_bytes = tx_dequeued_bytes_ff;


always @(posedge axi_aclk)
        if(~axi_resetn) begin//{
                tx_dequeued_bytes_ff_d <= 'b0;
		tx_dequeued_bytes_ff_dd <= 'b0;
		end//}
        else if(rst_cntrs) begin//{
                tx_dequeued_bytes_ff_d <= 'b0;
                tx_dequeued_bytes_ff_dd <= 'b0;
                end//}
        else    begin//{
                tx_dequeued_bytes_ff_d  <= tx_dequeued_bytes_ff;
                tx_dequeued_bytes_ff_dd <= tx_dequeued_bytes_ff_d;

		end//}


assign tx_dequeued_bytes = tx_dequeued_bytes_ff_dd;

//tx_packets enqueued

reg tx_pkts_enqueued_signal_d1, tx_pkts_enqueued_signal_d2;
always @(posedge axi_aclk)
        if (~axi_resetn) begin
                tx_pkts_enqueued_signal_d1 <= 0;
                tx_pkts_enqueued_signal_d2 <= 0;
        end
        else if (rst_cntrs) begin
                tx_pkts_enqueued_signal_d1 <= 0;
                tx_pkts_enqueued_signal_d2 <= 0;
        end

        else begin
                tx_pkts_enqueued_signal_d1 <= tx_pkts_enqueued_signal;
                tx_pkts_enqueued_signal_d2 <= tx_pkts_enqueued_signal_d1;
        end

wire tx_pkts_enqueued_signal_sig;
assign tx_pkts_enqueued_signal_sig = tx_pkts_enqueued_signal_d1 & ~tx_pkts_enqueued_signal_d2;


always @(posedge axi_aclk)
        if (~axi_resetn) begin
                tx_enqueued_pkts <= 0;
        end
        else if (rst_cntrs) begin
                tx_enqueued_pkts <= 0;
        end
	else if (tx_pkts_enqueued_signal_sig) begin
		tx_enqueued_pkts <= tx_enqueued_pkts + 'b1;
	end 
        else begin
                 tx_enqueued_pkts <= tx_enqueued_pkts;

        end


always @(posedge axi_aclk)
        if (~axi_resetn) begin
                tx_enqueued_bytes <= 0;
        end
        else if (rst_cntrs) begin
                tx_enqueued_bytes <= 0;
        end
        else begin
                tx_enqueued_bytes <= tx_enqueued_bytes + tx_bytes_enqueued;
        end

// Logic to compute the number of packets dequeued from the rx_queues 

always @(posedge axi_aclk)
         if (~axi_resetn) begin
                 rx_dequeued_pkts <= 0;
         end
         else if (rst_cntrs) begin
                 rx_dequeued_pkts <= 0;
         end

         else if (m_axis_tvalid & m_axis_tready & m_axis_tlast) begin
                 rx_dequeued_pkts <= rx_dequeued_pkts + 'b1;
         end
         else begin
                  rx_dequeued_pkts <= rx_dequeued_pkts;
 
         end


// FSM to compute the number of bytes dequeued from the rx_queues

localparam HUNT = 0;
localparam ADD = 1;

reg ps,ns;
reg [31:0] ntemp_rx_dequeued_bytes, nrx_dequeued_bytes;
reg [31:0] temp_rx_dequeued_bytes;

always @(*) begin//{
ns = ps;
ntemp_rx_dequeued_bytes = temp_rx_dequeued_bytes;
nrx_dequeued_bytes = rx_dequeued_bytes;
case(ps)
HUNT: if(m_axis_tready & m_axis_tvalid) begin//{
	ntemp_rx_dequeued_bytes =  m_axis_tuser[15:0];
	ns= ADD;
	end//}
ADD : if(m_axis_tready & m_axis_tvalid & m_axis_tlast) begin//{
        nrx_dequeued_bytes = nrx_dequeued_bytes + ntemp_rx_dequeued_bytes;
        ns= HUNT;
	end//}
default: ns = HUNT;
endcase

end//}

always @(posedge axi_aclk)
	if(~axi_resetn) begin//{
		ps <= HUNT;
		temp_rx_dequeued_bytes <= 'b0;  
		rx_dequeued_bytes <= 'b0;
		end//}
        else if(rst_cntrs) begin//{
                ps <= HUNT;
                temp_rx_dequeued_bytes <= 'b0;
                rx_dequeued_bytes <= 'b0;
                end//}
	else
		begin//{
		ps <= ns;
                temp_rx_dequeued_bytes <= ntemp_rx_dequeued_bytes;
                rx_dequeued_bytes <= nrx_dequeued_bytes;	
		end//}


// Logic to generate pulse for the fifo_wr_en signal
// Pulse generated is used for computing the rx_enqueued_pkts

reg fifo_wr_en_d1, fifo_wr_en_d2;
always @(posedge clk156)
        if (~axi_resetn) begin
                fifo_wr_en_d1 <= 0;
                fifo_wr_en_d2 <= 0;
        end
        else if (rst_cntrs) begin
                fifo_wr_en_d1 <= 0;
                fifo_wr_en_d2 <= 0;
        end

        else begin
                fifo_wr_en_d1 <= fifo_wr_en;
                fifo_wr_en_d2 <= fifo_wr_en_d1;
        end

wire fifo_wr_en_sig;
assign fifo_wr_en_sig = fifo_wr_en_d1 & ~fifo_wr_en_d2;


always@(posedge clk156)
	if(~axi_resetn)
		begin
			good_frames_counter <={C_S_AXI_DATA_WIDTH{1'b0}};
			bad_frames_counter  <={C_S_AXI_DATA_WIDTH{1'b0}};
			tx_dequeued_pkts <={C_S_AXI_DATA_WIDTH{1'b0}};
			rx_enqueued_pkts <= 'b0;
		end
        else if(rst_cntrs)
                begin
                        good_frames_counter <={C_S_AXI_DATA_WIDTH{1'b0}};
                        bad_frames_counter  <={C_S_AXI_DATA_WIDTH{1'b0}};
                        tx_dequeued_pkts <={C_S_AXI_DATA_WIDTH{1'b0}};
                        rx_enqueued_pkts <= 'b0;
                end

	else 
		begin
			if (rx_good_frame_sig) good_frames_counter <= good_frames_counter + 1'b1;
			if (rx_bad_frame_sig)  bad_frames_counter  <= bad_frames_counter + 1'b1;	
			if (tx_dequeued_pkt_sig) tx_dequeued_pkts <= tx_dequeued_pkts + 1'b1;
			if (fifo_wr_en_sig) rx_enqueued_pkts <= rx_enqueued_pkts + 'b1;
		end

	
// Logic for computing the number of packets and bytes in tx and rx queues, 
// number of packets and bytes dropped in rx queue   
	
always @(posedge axi_aclk)
        if(~axi_resetn) begin//{
        rx_pkts_dropped <= 'b0;
        rx_bytes_dropped <= 'b0;
        rx_bytes_in_queue <= 'b0;
        rx_pkts_in_queue  <= 'b0;
        tx_bytes_in_queue <= 'b0;
        tx_pkts_in_queue  <= 'b0;
        end//}
        else if(rst_cntrs) begin//{
        rx_pkts_dropped <= 'b0;
        rx_bytes_dropped <= 'b0;
        rx_bytes_in_queue <= 'b0;
        rx_pkts_in_queue  <= 'b0;
        tx_bytes_in_queue <= 'b0;
        tx_pkts_in_queue  <= 'b0;
        end//}

        else    begin//{
        rx_pkts_dropped <= (good_frames_counter + bad_frames_counter)-rx_enqueued_pkts;
        rx_bytes_dropped <= bytes_from_mac - rx_enqueued_bytes;
        rx_bytes_in_queue <= rx_enqueued_bytes-rx_dequeued_bytes;
        rx_pkts_in_queue  <= rx_enqueued_pkts - rx_dequeued_pkts;
        tx_bytes_in_queue <= tx_enqueued_bytes - tx_dequeued_bytes;
        tx_pkts_in_queue  <= tx_enqueued_pkts - tx_dequeued_pkts;
                end//}

	
endmodule
