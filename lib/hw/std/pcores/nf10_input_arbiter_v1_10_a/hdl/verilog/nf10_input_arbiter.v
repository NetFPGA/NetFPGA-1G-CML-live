/*******************************************************************************
 *
 *  NetFPGA-10G http://www.netfpga.org
 *
 *  File:
 *        nf10_input_arbiter.v
 *
 *  Library:
 *        contrib/pcores/nf10_input_arbiter_v1_10_a
 *
 *  Module:
 *        nf10_input_arbiter
 *
 *  Author:
 *        Gianni Antichi
 *
 *  Description:
 *        
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
`uselib lib=nf10_proc_common_v1_00_a

module nf10_input_arbiter
#(
  parameter C_FAMILY              = "virtex5",
  parameter C_S_AXI_DATA_WIDTH    = 32,          
  parameter C_S_AXI_ADDR_WIDTH    = 32,          
  parameter C_USE_WSTRB           = 0,
  parameter C_DPHASE_TIMEOUT      = 0,
  parameter C_BASEADDR            = 32'hFFFFFFFF,
  parameter C_HIGHADDR            = 32'h00000000,
  parameter C_S_AXI_ACLK_FREQ_HZ  = 100,
  parameter C_M_AXIS_DATA_WIDTH	  = 256,
  parameter C_S_AXIS_DATA_WIDTH	  = 256,
  parameter C_M_AXIS_TUSER_WIDTH  = 128,
  parameter C_S_AXIS_TUSER_WIDTH  = 128,
  parameter NUM_QUEUES=5
)
(
  // Slave AXI Ports
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


  // Master Stream Ports (interface to data path)
  output [C_M_AXIS_DATA_WIDTH - 1:0] m_axis_tdata,
  output [((C_M_AXIS_DATA_WIDTH / 8)) - 1:0] m_axis_tstrb,
  output [C_M_AXIS_TUSER_WIDTH-1:0] m_axis_tuser,
  output m_axis_tvalid,
  input  m_axis_tready,
  output m_axis_tlast,

  // Slave Stream Ports (interface to RX queues)
  input [C_S_AXIS_DATA_WIDTH - 1:0] s_axis_tdata_0,
  input [((C_S_AXIS_DATA_WIDTH / 8)) - 1:0] s_axis_tstrb_0,
  input [C_S_AXIS_TUSER_WIDTH-1:0] s_axis_tuser_0,
  input  s_axis_tvalid_0,
  output s_axis_tready_0,
  input  s_axis_tlast_0,

  input [C_S_AXIS_DATA_WIDTH - 1:0] s_axis_tdata_1,
  input [((C_S_AXIS_DATA_WIDTH / 8)) - 1:0] s_axis_tstrb_1,
  input [C_S_AXIS_TUSER_WIDTH-1:0] s_axis_tuser_1,
  input  s_axis_tvalid_1,
  output s_axis_tready_1,
  input  s_axis_tlast_1,

  input [C_S_AXIS_DATA_WIDTH - 1:0] s_axis_tdata_2,
  input [((C_S_AXIS_DATA_WIDTH / 8)) - 1:0] s_axis_tstrb_2,
  input [C_S_AXIS_TUSER_WIDTH-1:0] s_axis_tuser_2,
  input  s_axis_tvalid_2,
  output s_axis_tready_2,
  input  s_axis_tlast_2,

  input [C_S_AXIS_DATA_WIDTH - 1:0] s_axis_tdata_3,
  input [((C_S_AXIS_DATA_WIDTH / 8)) - 1:0] s_axis_tstrb_3,
  input [C_S_AXIS_TUSER_WIDTH-1:0] s_axis_tuser_3,
  input  s_axis_tvalid_3,
  output s_axis_tready_3,
  input  s_axis_tlast_3,

  input [C_S_AXIS_DATA_WIDTH - 1:0] s_axis_tdata_4,
  input [((C_S_AXIS_DATA_WIDTH / 8)) - 1:0] s_axis_tstrb_4,
  input [C_S_AXIS_TUSER_WIDTH-1:0] s_axis_tuser_4,
  input  s_axis_tvalid_4,
  output s_axis_tready_4,
  input  s_axis_tlast_4,

  // misc
  input axi_aclk,
  input axi_resetn

);

  
  localparam NUM_RW_REGS       = 1;
  localparam NUM_RO_REGS       = 1;

  // -- Signals

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
  
  wire     [NUM_RW_REGS*C_S_AXI_DATA_WIDTH-1 : 0] rw_regs;
  wire     [NUM_RO_REGS*C_S_AXI_DATA_WIDTH-1 : 0] ro_regs;
  
  wire                                            pkt_fwd;
  reg      [C_S_AXI_DATA_WIDTH-1 : 0]             pkt_fwd_cntr;
  wire                                            rst_cntrs;
 
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
    .S_AXI_ACLK          ( axi_aclk       ),
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
  
  // -- Register assignments
  
  assign rst_cntrs = rw_regs[0]; 
  
  assign ro_regs = pkt_fwd_cntr;
  
  // -- input arbiter
  input_arbiter #
  (
    .C_M_AXIS_DATA_WIDTH  (C_M_AXIS_DATA_WIDTH),
    .C_S_AXIS_DATA_WIDTH  (C_S_AXIS_DATA_WIDTH),
    .C_M_AXIS_TUSER_WIDTH (C_M_AXIS_TUSER_WIDTH),
    .C_S_AXIS_TUSER_WIDTH (C_S_AXIS_TUSER_WIDTH),
    .NUM_QUEUES           (NUM_QUEUES)
  ) input_arbiter
  (
    // Global Ports
    .axi_aclk      (axi_aclk),
    .axi_resetn    (axi_resetn),

    // Master Stream Ports (interface OPL)
    .m_axis_tdata  (m_axis_tdata),
    .m_axis_tstrb  (m_axis_tstrb),
    .m_axis_tuser  (m_axis_tuser),
    .m_axis_tvalid (m_axis_tvalid), 
    .m_axis_tready (m_axis_tready),
    .m_axis_tlast  (m_axis_tlast),

    // Slave Stream Ports (interface to RX queues)

    .s_axis_tdata_0(s_axis_tdata_0),
    .s_axis_tstrb_0(s_axis_tstrb_0),
    .s_axis_tuser_0(s_axis_tuser_0),
    .s_axis_tvalid_0(s_axis_tvalid_0),
    .s_axis_tready_0(s_axis_tready_0),
    .s_axis_tlast_0(s_axis_tlast_0),

    .s_axis_tdata_1(s_axis_tdata_1),
    .s_axis_tstrb_1(s_axis_tstrb_1),
    .s_axis_tuser_1(s_axis_tuser_1),
    .s_axis_tvalid_1(s_axis_tvalid_1),
    .s_axis_tready_1(s_axis_tready_1),
    .s_axis_tlast_1(s_axis_tlast_1),

    .s_axis_tdata_2(s_axis_tdata_2),
    .s_axis_tstrb_2(s_axis_tstrb_2),
    .s_axis_tuser_2(s_axis_tuser_2),
    .s_axis_tvalid_2(s_axis_tvalid_2),
    .s_axis_tready_2(s_axis_tready_2),
    .s_axis_tlast_2(s_axis_tlast_2),

    .s_axis_tdata_3(s_axis_tdata_3),
    .s_axis_tstrb_3(s_axis_tstrb_3),
    .s_axis_tuser_3(s_axis_tuser_3),
    .s_axis_tvalid_3(s_axis_tvalid_3),
    .s_axis_tready_3(s_axis_tready_3),
    .s_axis_tlast_3(s_axis_tlast_3),

    .s_axis_tdata_4(s_axis_tdata_4),
    .s_axis_tstrb_4(s_axis_tstrb_4),
    .s_axis_tuser_4(s_axis_tuser_4),
    .s_axis_tvalid_4(s_axis_tvalid_4),
    .s_axis_tready_4(s_axis_tready_4),
    .s_axis_tlast_4(s_axis_tlast_4),

    .pkt_fwd       (pkt_fwd)
  );
  
  // LUT hit/miss counters
  always @ (posedge axi_aclk) begin
    if (~axi_resetn) begin
	  pkt_fwd_cntr  <= {C_S_AXI_DATA_WIDTH{1'b0}};
	end
	else if (rst_cntrs) begin
	  pkt_fwd_cntr <= {C_S_AXI_DATA_WIDTH{1'b0}};
	end
	else
	  if (pkt_fwd)  pkt_fwd_cntr  <= pkt_fwd_cntr + 1;
  end
  
endmodule
