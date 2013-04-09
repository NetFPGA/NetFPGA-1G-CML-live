// -- (c) Copyright 2010 - 2011 Xilinx, Inc. All rights reserved.
// --
// -- This file contains confidential and proprietary information
// -- of Xilinx, Inc. and is protected under U.S. and 
// -- international copyright and other intellectual property
// -- laws.
// --
// -- DISCLAIMER
// -- This disclaimer is not a license and does not grant any
// -- rights to the materials distributed herewith. Except as
// -- otherwise provided in a valid license issued to you by
// -- Xilinx, and to the maximum extent permitted by applicable
// -- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// -- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// -- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// -- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// -- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// -- (2) Xilinx shall not be liable (whether in contract or tort,
// -- including negligence, or under any other theory of
// -- liability) for any loss or damage of any kind or nature
// -- related to, arising under or in connection with these
// -- materials, including for any direct, or any indirect,
// -- special, incidental, or consequential loss or damage
// -- (including loss of data, profits, goodwill, or any type of
// -- loss or damage suffered as a result of any action brought
// -- by a third party) even if such damage or loss was
// -- reasonably foreseeable or Xilinx had been advised of the
// -- possibility of the same.
// --
// -- CRITICAL APPLICATIONS
// -- Xilinx products are not designed or intended to be fail-
// -- safe, or for use in any application requiring fail-safe
// -- performance, such as life-support or safety devices or
// -- systems, Class III medical devices, nuclear facilities,
// -- applications related to the deployment of airbags, or any
// -- other applications that could lead to death, personal
// -- injury, or severe property or environmental damage
// -- (individually and collectively, "Critical
// -- Applications"). Customer assumes the sole risk and
// -- liability of any use of Xilinx products in Critical
// -- Applications, subject only to applicable laws and
// -- regulations governing limitations on product liability.
// --
// -- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// -- PART OF THIS FILE AT ALL TIMES.
//-----------------------------------------------------------------------------
//
// AXI data fifo module:    
//   5-channel memory-mapped AXI4 interfaces.
//   SRL or BRAM based FIFO on AXI W and/or R channels.
//   FIFO to accommodate various data flow rates through the AXI interconnect
//
// Verilog-standard:  Verilog 2001
//-----------------------------------------------------------------------------
//
// Structure:
//   axi_data_fifo
//     axic_fifo
//       fifo_gen
//
//-----------------------------------------------------------------------------

`timescale 1ps/1ps

module axi_data_fifo #
  (
   parameter         C_FAMILY                    = "none",
   parameter integer C_AXI_ID_WIDTH              = 4,
   parameter integer C_AXI_ADDR_WIDTH            = 32,
   parameter integer C_AXI_DATA_WIDTH            = 32,
   parameter integer C_AXI_SUPPORTS_USER_SIGNALS = 0,
   parameter integer C_AXI_AWUSER_WIDTH          = 1,
   parameter integer C_AXI_ARUSER_WIDTH          = 1,
   parameter integer C_AXI_WUSER_WIDTH           = 1,
   parameter integer C_AXI_RUSER_WIDTH           = 1,
   parameter integer C_AXI_BUSER_WIDTH           = 1,
   parameter integer C_AXI_WRITE_FIFO_DEPTH      = 0,      // Range: (0, 32, 512)
   parameter         C_AXI_WRITE_FIFO_TYPE       = "lut",  // "lut" = LUT (SRL) based,
                                                           // "bram" = BRAM based
   parameter integer C_AXI_WRITE_FIFO_DELAY      = 0,      // 0 = No, 1 = Yes (FUTURE FEATURE)
                       // Indicates whether AWVALID and WVALID assertion is delayed until:
                       //   a. the corresponding WLAST is stored in the FIFO, or
                       //   b. no WLAST is stored and the FIFO is full.
                       // 0 means AW channel is pass-through and 
                       //   WVALID is asserted whenever FIFO is not empty.
   parameter integer C_AXI_READ_FIFO_DEPTH       = 0,      // Range: (0, 32, 512)
   parameter         C_AXI_READ_FIFO_TYPE        = "lut",  // "lut" = LUT (SRL) based,
                                                           // "bram" = BRAM based
   parameter integer C_AXI_READ_FIFO_DELAY       = 0)      // 0 = No, 1 = Yes (FUTURE FEATURE)
                       // Indicates whether ARVALID assertion is delayed until the 
                       //   the remaining vacancy of the FIFO is at least the burst length
                       //   as indicated by ARLEN.
                       // 0 means AR channel is pass-through.
   // System Signals
  (input wire ACLK,
   input wire ARESETN,

   // Slave Interface Write Address Ports
   input  wire [C_AXI_ID_WIDTH-1:0]     S_AXI_AWID,
   input  wire [C_AXI_ADDR_WIDTH-1:0]   S_AXI_AWADDR,
   input  wire [8-1:0]                  S_AXI_AWLEN,
   input  wire [3-1:0]                  S_AXI_AWSIZE,
   input  wire [2-1:0]                  S_AXI_AWBURST,
   input  wire [2-1:0]                  S_AXI_AWLOCK,
   input  wire [4-1:0]                  S_AXI_AWCACHE,
   input  wire [3-1:0]                  S_AXI_AWPROT,
   input  wire [4-1:0]                  S_AXI_AWREGION,
   input  wire [4-1:0]                  S_AXI_AWQOS,
   input  wire [C_AXI_AWUSER_WIDTH-1:0] S_AXI_AWUSER,
   input  wire                          S_AXI_AWVALID,
   output wire                          S_AXI_AWREADY,

   // Slave Interface Write Data Ports
   input  wire [C_AXI_DATA_WIDTH-1:0]   S_AXI_WDATA,
   input  wire [C_AXI_DATA_WIDTH/8-1:0] S_AXI_WSTRB,
   input  wire                          S_AXI_WLAST,
   input  wire [C_AXI_WUSER_WIDTH-1:0]  S_AXI_WUSER,
   input  wire                          S_AXI_WVALID,
   output wire                          S_AXI_WREADY,

   // Slave Interface Write Response Ports
   output wire [C_AXI_ID_WIDTH-1:0]     S_AXI_BID,
   output wire [2-1:0]                  S_AXI_BRESP,
   output wire [C_AXI_BUSER_WIDTH-1:0]  S_AXI_BUSER,
   output wire                          S_AXI_BVALID,
   input  wire                          S_AXI_BREADY,

   // Slave Interface Read Address Ports
   input  wire [C_AXI_ID_WIDTH-1:0]     S_AXI_ARID,
   input  wire [C_AXI_ADDR_WIDTH-1:0]   S_AXI_ARADDR,
   input  wire [8-1:0]                  S_AXI_ARLEN,
   input  wire [3-1:0]                  S_AXI_ARSIZE,
   input  wire [2-1:0]                  S_AXI_ARBURST,
   input  wire [2-1:0]                  S_AXI_ARLOCK,
   input  wire [4-1:0]                  S_AXI_ARCACHE,
   input  wire [3-1:0]                  S_AXI_ARPROT,
   input  wire [4-1:0]                  S_AXI_ARREGION,
   input  wire [4-1:0]                  S_AXI_ARQOS,
   input  wire [C_AXI_ARUSER_WIDTH-1:0] S_AXI_ARUSER,
   input  wire                          S_AXI_ARVALID,
   output wire                          S_AXI_ARREADY,

   // Slave Interface Read Data Ports
   output wire [C_AXI_ID_WIDTH-1:0]     S_AXI_RID,
   output wire [C_AXI_DATA_WIDTH-1:0]   S_AXI_RDATA,
   output wire [2-1:0]                  S_AXI_RRESP,
   output wire                          S_AXI_RLAST,
   output wire [C_AXI_RUSER_WIDTH-1:0]  S_AXI_RUSER,
   output wire                          S_AXI_RVALID,
   input  wire                          S_AXI_RREADY,
   
   // Master Interface Write Address Port
   output wire [C_AXI_ID_WIDTH-1:0]     M_AXI_AWID,
   output wire [C_AXI_ADDR_WIDTH-1:0]   M_AXI_AWADDR,
   output wire [8-1:0]                  M_AXI_AWLEN,
   output wire [3-1:0]                  M_AXI_AWSIZE,
   output wire [2-1:0]                  M_AXI_AWBURST,
   output wire [2-1:0]                  M_AXI_AWLOCK,
   output wire [4-1:0]                  M_AXI_AWCACHE,
   output wire [3-1:0]                  M_AXI_AWPROT,
   output wire [4-1:0]                  M_AXI_AWREGION,
   output wire [4-1:0]                  M_AXI_AWQOS,
   output wire [C_AXI_AWUSER_WIDTH-1:0] M_AXI_AWUSER,
   output wire                          M_AXI_AWVALID,
   input  wire                          M_AXI_AWREADY,
   
   // Master Interface Write Data Ports
   output wire [C_AXI_DATA_WIDTH-1:0]   M_AXI_WDATA,
   output wire [C_AXI_DATA_WIDTH/8-1:0] M_AXI_WSTRB,
   output wire                          M_AXI_WLAST,
   output wire [C_AXI_WUSER_WIDTH-1:0]  M_AXI_WUSER,
   output wire                          M_AXI_WVALID,
   input  wire                          M_AXI_WREADY,
   
   // Master Interface Write Response Ports
   input  wire [C_AXI_ID_WIDTH-1:0]     M_AXI_BID,
   input  wire [2-1:0]                  M_AXI_BRESP,
   input  wire [C_AXI_BUSER_WIDTH-1:0]  M_AXI_BUSER,
   input  wire                          M_AXI_BVALID,
   output wire                          M_AXI_BREADY,
   
   // Master Interface Read Address Port
   output wire [C_AXI_ID_WIDTH-1:0]     M_AXI_ARID,
   output wire [C_AXI_ADDR_WIDTH-1:0]   M_AXI_ARADDR,
   output wire [8-1:0]                  M_AXI_ARLEN,
   output wire [3-1:0]                  M_AXI_ARSIZE,
   output wire [2-1:0]                  M_AXI_ARBURST,
   output wire [2-1:0]                  M_AXI_ARLOCK,
   output wire [4-1:0]                  M_AXI_ARCACHE,
   output wire [3-1:0]                  M_AXI_ARPROT,
   output wire [4-1:0]                  M_AXI_ARREGION,
   output wire [4-1:0]                  M_AXI_ARQOS,
   output wire [C_AXI_ARUSER_WIDTH-1:0] M_AXI_ARUSER,
   output wire                          M_AXI_ARVALID,
   input  wire                          M_AXI_ARREADY,
   
   // Master Interface Read Data Ports
   input  wire [C_AXI_ID_WIDTH-1:0]     M_AXI_RID,
   input  wire [C_AXI_DATA_WIDTH-1:0]   M_AXI_RDATA,
   input  wire [2-1:0]                  M_AXI_RRESP,
   input  wire                          M_AXI_RLAST,
   input  wire [C_AXI_RUSER_WIDTH-1:0]  M_AXI_RUSER,
   input  wire                          M_AXI_RVALID,
   output wire                          M_AXI_RREADY);
  
  /////////////////////////////////////////////////////////////////////////////
  // Functions
  /////////////////////////////////////////////////////////////////////////////
  // Log2.
  function integer log2;
    input integer value;
  begin
    for (log2=0; value>1; log2=log2+1) begin
      value = value >> 1;
    end
  end
  endfunction

  wire reset;
  assign reset = ~ARESETN;

  // Log2 of FIFO_DEPTHS
  localparam integer C_AXI_WRITE_FIFO_DEPTH_LOG = log2(C_AXI_WRITE_FIFO_DEPTH);
  localparam integer C_AXI_READ_FIFO_DEPTH_LOG  = log2(C_AXI_READ_FIFO_DEPTH);

  // Write Data Port bit positions
  localparam integer C_WUSER_RIGHT   = 0;
  localparam integer C_WUSER_LEN     = C_AXI_SUPPORTS_USER_SIGNALS*C_AXI_WUSER_WIDTH;
  localparam integer C_WLAST_RIGHT   = C_WUSER_RIGHT + C_WUSER_LEN;
  localparam integer C_WLAST_LEN     = 1;
  localparam integer C_WSTRB_RIGHT   = C_WLAST_RIGHT + C_WLAST_LEN;
  localparam integer C_WSTRB_LEN     = C_AXI_DATA_WIDTH/8;
  localparam integer C_WDATA_RIGHT   = C_WSTRB_RIGHT + C_WSTRB_LEN;
  localparam integer C_WDATA_LEN     = C_AXI_DATA_WIDTH;
  localparam integer C_W_SIZE        = C_WDATA_RIGHT + C_WDATA_LEN;

  // Write Data Port FIFO data read and write
  wire [C_W_SIZE-1:0] s_w_data;
  wire [C_W_SIZE-1:0] m_w_data;

  // Read Data Ports bit positions
  localparam integer C_RUSER_RIGHT   = 0;
  localparam integer C_RUSER_LEN     = C_AXI_SUPPORTS_USER_SIGNALS*C_AXI_RUSER_WIDTH;
  localparam integer C_RLAST_RIGHT   = C_RUSER_RIGHT + C_RUSER_LEN;
  localparam integer C_RLAST_LEN     = 1;
  localparam integer C_RRESP_RIGHT   = C_RLAST_RIGHT + C_RLAST_LEN;
  localparam integer C_RRESP_LEN     = 2;
  localparam integer C_RDATA_RIGHT   = C_RRESP_RIGHT + C_RRESP_LEN;
  localparam integer C_RDATA_LEN     = C_AXI_DATA_WIDTH;
  localparam integer C_RID_RIGHT     = C_RDATA_RIGHT + C_RDATA_LEN;
  localparam integer C_RID_LEN       = C_AXI_ID_WIDTH;
  localparam integer C_R_SIZE        = C_RID_RIGHT + C_RID_LEN;

  // Read Data Ports FIFO data read and write
  wire [C_R_SIZE-1:0] s_r_data;
  wire [C_R_SIZE-1:0] m_r_data;
  
  // Write address port
  assign M_AXI_AWID     = S_AXI_AWID;
  assign M_AXI_AWADDR   = S_AXI_AWADDR;
  assign M_AXI_AWLEN    = S_AXI_AWLEN;
  assign M_AXI_AWSIZE   = S_AXI_AWSIZE;
  assign M_AXI_AWBURST  = S_AXI_AWBURST;
  assign M_AXI_AWLOCK   = S_AXI_AWLOCK;
  assign M_AXI_AWCACHE  = S_AXI_AWCACHE;
  assign M_AXI_AWPROT   = S_AXI_AWPROT;
  assign M_AXI_AWREGION = S_AXI_AWREGION;
  assign M_AXI_AWQOS    = S_AXI_AWQOS;
  assign M_AXI_AWUSER   = S_AXI_AWUSER;
  assign M_AXI_AWVALID  = S_AXI_AWVALID;
  assign S_AXI_AWREADY  = M_AXI_AWREADY;

  // Write Response Port
  assign S_AXI_BID      = M_AXI_BID;
  assign S_AXI_BRESP    = M_AXI_BRESP;
  assign S_AXI_BUSER    = M_AXI_BUSER;
  assign S_AXI_BVALID   = M_AXI_BVALID;
  assign M_AXI_BREADY   = S_AXI_BREADY;

  // Read Address Port
  assign M_AXI_ARID     = S_AXI_ARID;
  assign M_AXI_ARADDR   = S_AXI_ARADDR;
  assign M_AXI_ARLEN    = S_AXI_ARLEN;
  assign M_AXI_ARSIZE   = S_AXI_ARSIZE;
  assign M_AXI_ARBURST  = S_AXI_ARBURST;
  assign M_AXI_ARLOCK   = S_AXI_ARLOCK;
  assign M_AXI_ARCACHE  = S_AXI_ARCACHE;
  assign M_AXI_ARPROT   = S_AXI_ARPROT;
  assign M_AXI_ARREGION = S_AXI_ARREGION;
  assign M_AXI_ARQOS    = S_AXI_ARQOS;
  assign M_AXI_ARUSER   = S_AXI_ARUSER;
  assign M_AXI_ARVALID  = S_AXI_ARVALID;
  assign S_AXI_ARREADY  = M_AXI_ARREADY;
  
  generate

    // Write Data Port
    if (C_AXI_WRITE_FIFO_DEPTH != 0) begin : gen_fifo_write_ch
      if (C_AXI_SUPPORTS_USER_SIGNALS == 1) begin : gen_async_w_user
        assign s_w_data     = {S_AXI_WDATA, S_AXI_WSTRB, S_AXI_WLAST, S_AXI_WUSER};
        assign M_AXI_WUSER = m_w_data[C_WUSER_RIGHT+:C_WUSER_LEN];
      end
      else begin : gen_asynch_w_no_user
        assign s_w_data     = {S_AXI_WDATA, S_AXI_WSTRB, S_AXI_WLAST};
        assign M_AXI_WUSER  = {C_AXI_WUSER_WIDTH{1'b0}};
      end

      assign M_AXI_WDATA    = m_w_data[C_WDATA_RIGHT+:C_WDATA_LEN];
      assign M_AXI_WSTRB    = m_w_data[C_WSTRB_RIGHT+:C_WSTRB_LEN];
      assign M_AXI_WLAST    = m_w_data[C_WLAST_RIGHT+:C_WLAST_LEN];

      axic_fifo #
        (
         .C_FAMILY          (C_FAMILY),
         .C_FIFO_WIDTH      (C_W_SIZE),
         .C_FIFO_TYPE       (C_AXI_WRITE_FIFO_TYPE),
         .C_FIFO_DEPTH_LOG  (C_AXI_WRITE_FIFO_DEPTH_LOG)
         )
        write_data_fifo
          (
           .ACLK    (ACLK),
           .ARESET  (reset),
           .S_MESG  (s_w_data),
           .S_VALID (S_AXI_WVALID),
           .S_READY (S_AXI_WREADY),
           .M_MESG  (m_w_data),
           .M_VALID (M_AXI_WVALID),
           .M_READY (M_AXI_WREADY)
           );
    
    end else begin : gen_bypass_write_ch
      assign M_AXI_WDATA    = S_AXI_WDATA;
      assign M_AXI_WSTRB    = S_AXI_WSTRB;
      assign M_AXI_WLAST    = S_AXI_WLAST;
      assign M_AXI_WUSER    = S_AXI_WUSER;
      assign M_AXI_WVALID   = S_AXI_WVALID;
      assign S_AXI_WREADY   = M_AXI_WREADY;
    end

    // Read Data Port
    if (C_AXI_READ_FIFO_DEPTH != 0) begin : gen_fifo_read_ch
      if (C_AXI_SUPPORTS_USER_SIGNALS == 1) begin : gen_async_r_user
        assign m_r_data     = {M_AXI_RID, M_AXI_RDATA, M_AXI_RRESP, M_AXI_RLAST, M_AXI_RUSER};
        assign S_AXI_RUSER  = s_r_data[C_RUSER_RIGHT+:C_RUSER_LEN];
      end
      else begin : gen_asynch_r_no_user
        assign m_r_data     = {M_AXI_RID, M_AXI_RDATA, M_AXI_RRESP, M_AXI_RLAST};
        assign S_AXI_RUSER  = {C_AXI_RUSER_WIDTH{1'b0}};
      end

      assign S_AXI_RID      = s_r_data[C_RID_RIGHT+:C_RID_LEN];
      assign S_AXI_RDATA    = s_r_data[C_RDATA_RIGHT+:C_RDATA_LEN];
      assign S_AXI_RRESP    = s_r_data[C_RRESP_RIGHT+:C_RRESP_LEN];
      assign S_AXI_RLAST    = s_r_data[C_RLAST_RIGHT+:C_RLAST_LEN];

      axic_fifo #
        (
         .C_FAMILY          (C_FAMILY),
         .C_FIFO_WIDTH      (C_R_SIZE),
         .C_FIFO_TYPE       (C_AXI_READ_FIFO_TYPE),
         .C_FIFO_DEPTH_LOG  (C_AXI_READ_FIFO_DEPTH_LOG)
         )
        read_data_fifo
          (
           .ACLK    (ACLK),
           .ARESET  (reset),
           .S_MESG  (m_r_data),
           .S_VALID (M_AXI_RVALID),
           .S_READY (M_AXI_RREADY),
           .M_MESG  (s_r_data),
           .M_VALID (S_AXI_RVALID),
           .M_READY (S_AXI_RREADY)
           );
    
    end else begin : gen_bypass_read_ch
      assign S_AXI_RID      = M_AXI_RID;
      assign S_AXI_RDATA    = M_AXI_RDATA;
      assign S_AXI_RRESP    = M_AXI_RRESP;
      assign S_AXI_RLAST    = M_AXI_RLAST;
      assign S_AXI_RUSER    = M_AXI_RUSER;
      assign S_AXI_RVALID   = M_AXI_RVALID;
      assign M_AXI_RREADY   = S_AXI_RREADY;
    end

  endgenerate

endmodule
