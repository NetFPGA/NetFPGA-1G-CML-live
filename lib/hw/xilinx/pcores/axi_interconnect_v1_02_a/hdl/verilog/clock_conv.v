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
// Clock converter module
//   Asynchronous clock converter when asynchronous M:N conversion
//   Bypass when synchronous and ratio between S and M clock is 1:1
//   Synchronous clock converter (S:M or M:S must be integer ratio)  
//
// Verilog-standard:  Verilog 2001
//--------------------------------------------------------------------------
//
// Structure:
//   clock_conv
//     fifo_gen
//     clock_sync_accel
//     clock_sync_decel
//
// PROTECTED NAMES:
//   Instance names "asyncfifo_*" are pattern-matched in core-level UCF.
//   Signal names "*_resync" are pattern-matched in core-level UCF.
//
//--------------------------------------------------------------------------

`timescale 1ps/1ps

module clock_conv #
  (parameter         C_FAMILY = "virtex6",                  // FPGA Family. Current version: virtex6 or spartan6.
   parameter integer C_AXI_ID_WIDTH = 5,                    // Width of all ID signals on SI and MI side.
                                                            // Range: >= 1.
   parameter integer C_AXI_ADDR_WIDTH = 32,                 // Width of S_AXI_AWADDR, S_AXI_ARADDR, M_AXI_AWADDR and 
                                                            // M_AXI_ARADDR.
                                                            // Range: 32.
   parameter         C_AXI_DATA_WIDTH = {16{32'h00000020}}, // Width of WDATA and RDATA (either side).
                                                            // Format: Bit32; 
                                                            // Range: 'h00000020, 'h00000040, 'h00000080, 'h00000100.
   parameter         C_S_AXI_ACLK_RATIO = 32'h00000001,     // Clock frequency ratio of SI w.r.t. MI. 
   parameter         C_M_AXI_ACLK_RATIO = 32'h00000001,     // (Slowest of all clock inputs should have ratio=1.)
                                                            // S:M or M:S must be integer ratio.
                                                            // Format: Bit32; Range: >='h00000001.
   parameter         C_AXI_IS_ACLK_ASYNC = 1'b1,            // Indicates whether S and M clocks are asynchronous.
                                                            // FUTURE FEATURE
                                                            // Format: Bit1. Range = 1'b0.
   parameter         C_AXI_PROTOCOL = 32'h00000000,         // Protocol of this SI/MI slot.
   parameter integer C_AXI_SUPPORTS_USER_SIGNALS  = 1,      // 1 = Propagate all USER signals, 0 = Do not propagate.
   parameter integer C_AXI_AWUSER_WIDTH = 1,                // Width of AWUSER signals. 
                                                            // Range: >= 1.
   parameter integer C_AXI_ARUSER_WIDTH = 1,                // Width of ARUSER signals. 
                                                            // Range: >= 1.
   parameter integer C_AXI_WUSER_WIDTH = 1,                 // Width of WUSER signals. 
                                                            // Range: >= 1.
   parameter integer C_AXI_RUSER_WIDTH = 1,                 // Width of RUSER signals. 
                                                            // Range: >= 1.
   parameter integer C_AXI_BUSER_WIDTH = 1,                 // Width of BUSER signals. 
                                                            // Range: >= 1.
   parameter integer C_AXI_SUPPORTS_WRITE = 1,              // Implement AXI write channels
   parameter integer C_AXI_SUPPORTS_READ = 1               // Implement AXI read channels
  )

  (
   // Global Signals
   input  wire                            INTERCONNECT_ACLK,
   input  wire                            INTERCONNECT_ARESETN,
   input  wire                            LOCAL_ARESETN,
   output wire                            INTERCONNECT_RESET_OUT_N,
   output wire                            S_AXI_RESET_OUT_N,
   output wire                            M_AXI_RESET_OUT_N,

   // Slave Interface System Signals
   (* KEEP = "TRUE" *) input  wire        S_AXI_ACLK,

   // Slave Interface Write Address Ports
   input  wire [C_AXI_ID_WIDTH-1:0]       S_AXI_AWID,
   input  wire [C_AXI_ADDR_WIDTH-1:0]     S_AXI_AWADDR,
   input  wire [8-1:0]                    S_AXI_AWLEN,
   input  wire [3-1:0]                    S_AXI_AWSIZE,
   input  wire [2-1:0]                    S_AXI_AWBURST,
   input  wire [2-1:0]                    S_AXI_AWLOCK,
   input  wire [4-1:0]                    S_AXI_AWCACHE,
   input  wire [3-1:0]                    S_AXI_AWPROT,
   input  wire [4-1:0]                    S_AXI_AWREGION,
   input  wire [4-1:0]                    S_AXI_AWQOS,
   input  wire [C_AXI_AWUSER_WIDTH-1:0]   S_AXI_AWUSER,
   input  wire                            S_AXI_AWVALID,
   output wire                            S_AXI_AWREADY,

   // Slave Interface Write Data Ports
   input  wire [C_AXI_DATA_WIDTH-1:0]     S_AXI_WDATA,
   input  wire [C_AXI_DATA_WIDTH/8-1:0]   S_AXI_WSTRB,
   input  wire                            S_AXI_WLAST,
   input  wire [C_AXI_WUSER_WIDTH-1:0]    S_AXI_WUSER,
   input  wire                            S_AXI_WVALID,
   output wire                            S_AXI_WREADY,

   // Slave Interface Write Response Ports
   output wire [C_AXI_ID_WIDTH-1:0]       S_AXI_BID,
   output wire [2-1:0]                    S_AXI_BRESP,
   output wire [C_AXI_BUSER_WIDTH-1:0]    S_AXI_BUSER,
   output wire                            S_AXI_BVALID,
   input  wire                            S_AXI_BREADY,

   // Slave Interface Read Address Ports
   input  wire [C_AXI_ID_WIDTH-1:0]       S_AXI_ARID,
   input  wire [C_AXI_ADDR_WIDTH-1:0]     S_AXI_ARADDR,
   input  wire [8-1:0]                    S_AXI_ARLEN,
   input  wire [3-1:0]                    S_AXI_ARSIZE,
   input  wire [2-1:0]                    S_AXI_ARBURST,
   input  wire [2-1:0]                    S_AXI_ARLOCK,
   input  wire [4-1:0]                    S_AXI_ARCACHE,
   input  wire [3-1:0]                    S_AXI_ARPROT,
   input  wire [4-1:0]                    S_AXI_ARREGION,
   input  wire [4-1:0]                    S_AXI_ARQOS,
   input  wire [C_AXI_ARUSER_WIDTH-1:0]   S_AXI_ARUSER,
   input  wire                            S_AXI_ARVALID,
   output wire                            S_AXI_ARREADY,

   // Slave Interface Read Data Ports
   output wire [C_AXI_ID_WIDTH-1:0]       S_AXI_RID,
   output wire [C_AXI_DATA_WIDTH-1:0]     S_AXI_RDATA,
   output wire [2-1:0]                    S_AXI_RRESP,
   output wire                            S_AXI_RLAST,
   output wire [C_AXI_RUSER_WIDTH-1:0]    S_AXI_RUSER,
   output wire                            S_AXI_RVALID,
   input  wire                            S_AXI_RREADY,
   
   // Master Interface System Signals
   (* KEEP = "TRUE" *) input  wire        M_AXI_ACLK,

   // Master Interface Write Address Port
   output wire [C_AXI_ID_WIDTH-1:0]       M_AXI_AWID,
   output wire [C_AXI_ADDR_WIDTH-1:0]     M_AXI_AWADDR,
   output wire [8-1:0]                    M_AXI_AWLEN,
   output wire [3-1:0]                    M_AXI_AWSIZE,
   output wire [2-1:0]                    M_AXI_AWBURST,
   output wire [2-1:0]                    M_AXI_AWLOCK,
   output wire [4-1:0]                    M_AXI_AWCACHE,
   output wire [3-1:0]                    M_AXI_AWPROT,
   output wire [4-1:0]                    M_AXI_AWREGION,
   output wire [4-1:0]                    M_AXI_AWQOS,
   output wire [C_AXI_AWUSER_WIDTH-1:0]   M_AXI_AWUSER,
   output wire                            M_AXI_AWVALID,  
   input  wire                            M_AXI_AWREADY,

   // Master Interface Write Data Ports
   output wire [C_AXI_DATA_WIDTH-1:0]     M_AXI_WDATA,
   output wire [C_AXI_DATA_WIDTH/8-1:0]   M_AXI_WSTRB,
   output wire                            M_AXI_WLAST,
   output wire [C_AXI_WUSER_WIDTH-1:0]    M_AXI_WUSER,
   output wire                            M_AXI_WVALID,
   input  wire                            M_AXI_WREADY,

   // Master Interface Write Response Ports
   input  wire [C_AXI_ID_WIDTH-1:0]       M_AXI_BID,
   input  wire [2-1:0]                    M_AXI_BRESP,
   input  wire [C_AXI_BUSER_WIDTH-1:0]    M_AXI_BUSER,
   input  wire                            M_AXI_BVALID,
   output wire                            M_AXI_BREADY,

   // Master Interface Read Address Port
   output wire [C_AXI_ID_WIDTH-1:0]       M_AXI_ARID,
   output wire [C_AXI_ADDR_WIDTH-1:0]     M_AXI_ARADDR,
   output wire [8-1:0]                    M_AXI_ARLEN,
   output wire [3-1:0]                    M_AXI_ARSIZE,
   output wire [2-1:0]                    M_AXI_ARBURST,
   output wire [2-1:0]                    M_AXI_ARLOCK,
   output wire [4-1:0]                    M_AXI_ARCACHE,
   output wire [3-1:0]                    M_AXI_ARPROT,
   output wire [4-1:0]                    M_AXI_ARREGION,
   output wire [4-1:0]                    M_AXI_ARQOS,
   output wire [C_AXI_ARUSER_WIDTH-1:0]   M_AXI_ARUSER,
   output wire                            M_AXI_ARVALID,
   input  wire                            M_AXI_ARREADY,

   // Master Interface Read Data Ports
   input  wire [C_AXI_ID_WIDTH-1:0]       M_AXI_RID,
   input  wire [C_AXI_DATA_WIDTH-1:0]     M_AXI_RDATA,
   input  wire [2-1:0]                    M_AXI_RRESP,
   input  wire                            M_AXI_RLAST,
   input  wire [C_AXI_RUSER_WIDTH-1:0]    M_AXI_RUSER,
   input  wire                            M_AXI_RVALID,
   output wire                            M_AXI_RREADY);

  function integer f_ceil_log2
    (
     input integer x
     );
    integer acc;
    begin
      acc=0;
      while ((2**acc) < x)
        acc = acc + 1;
      f_ceil_log2 = acc;
    end
  endfunction

  localparam P_AXILITE = 32'h00000002;
  localparam integer P_LIGHT_WT = 0;
  localparam integer P_FULLY_REG = 1;

  
  // Sample cycle ratio
  localparam  P_SI_LT_MI = (C_S_AXI_ACLK_RATIO < C_M_AXI_ACLK_RATIO);
  localparam integer P_ROUNDING_OFFSET = P_SI_LT_MI ? (C_S_AXI_ACLK_RATIO/2) : (C_M_AXI_ACLK_RATIO/2);
  localparam integer P_ACLK_RATIO = P_SI_LT_MI ? ((C_M_AXI_ACLK_RATIO + P_ROUNDING_OFFSET) / C_S_AXI_ACLK_RATIO) : ((C_S_AXI_ACLK_RATIO + P_ROUNDING_OFFSET) / C_M_AXI_ACLK_RATIO);
  localparam integer P_LOAD_CNT = (P_ACLK_RATIO > 2) ? (P_ACLK_RATIO - 3) : 0;
  localparam integer P_ACLK_RATIO_LOG = f_ceil_log2(P_ACLK_RATIO);
  
  reg [P_ACLK_RATIO_LOG:0] sync_cnt;
  reg slow_div2;
  reg slow_div2_d1;
  reg sample;
  wire fast_aclk;
  wire slow_aclk;
  wire fast_areset;
  wire slow_areset;
  reg  reset_wait;
  reg [1:0] accel_reset;
  
  // Write Address Port bit positions
  localparam integer C_AWUSER_RIGHT   = 0;
  localparam integer C_AWUSER_LEN     = C_AXI_SUPPORTS_USER_SIGNALS*C_AXI_AWUSER_WIDTH;
  localparam integer C_AWQOS_RIGHT    = C_AWUSER_RIGHT + C_AWUSER_LEN;
  localparam integer C_AWQOS_LEN      = 4;
  localparam integer C_AWREGION_RIGHT = C_AWQOS_RIGHT + C_AWQOS_LEN;
  localparam integer C_AWREGION_LEN   = 4;
  localparam integer C_AWPROT_RIGHT   = C_AWREGION_RIGHT + C_AWREGION_LEN;
  localparam integer C_AWPROT_LEN     = 3;
  localparam integer C_AWCACHE_RIGHT  = C_AWPROT_RIGHT + C_AWPROT_LEN;
  localparam integer C_AWCACHE_LEN    = 4;
  localparam integer C_AWLOCK_RIGHT   = C_AWCACHE_RIGHT + C_AWCACHE_LEN;
  localparam integer C_AWLOCK_LEN     = 2;
  localparam integer C_AWBURST_RIGHT  = C_AWLOCK_RIGHT + C_AWLOCK_LEN;
  localparam integer C_AWBURST_LEN    = 2;
  localparam integer C_AWSIZE_RIGHT   = C_AWBURST_RIGHT + C_AWBURST_LEN;
  localparam integer C_AWSIZE_LEN     = 3;
  localparam integer C_AWLEN_RIGHT    = C_AWSIZE_RIGHT + C_AWSIZE_LEN;
  localparam integer C_AWLEN_LEN      = 8;
  localparam integer C_AWADDR_RIGHT   = C_AWLEN_RIGHT + C_AWLEN_LEN;
  localparam integer C_AWADDR_LEN     = C_AXI_ADDR_WIDTH;
  localparam integer C_AWID_RIGHT     = C_AWADDR_RIGHT + C_AWADDR_LEN;
  localparam integer C_AWID_LEN       = C_AXI_ID_WIDTH;
  localparam integer C_AW_SIZE        = C_AWID_RIGHT + C_AWID_LEN;

  // Write Address Port FIFO data read and write
  wire [C_AW_SIZE-1:0] s_aw_data ;
  wire [C_AW_SIZE-1:0] m_aw_data ;

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

  // Write Response Port bit positions
  localparam integer C_BUSER_RIGHT   = 0;
  localparam integer C_BUSER_LEN     = C_AXI_SUPPORTS_USER_SIGNALS*C_AXI_BUSER_WIDTH;
  localparam integer C_BRESP_RIGHT   = C_BUSER_RIGHT + C_BUSER_LEN;
  localparam integer C_BRESP_LEN     = 2;
  localparam integer C_BID_RIGHT     = C_BRESP_RIGHT + C_BRESP_LEN;
  localparam integer C_BID_LEN       = C_AXI_ID_WIDTH;
  localparam integer C_B_SIZE        = C_BID_RIGHT + C_BID_LEN;

  // Write Response Port FIFO data read and write
  wire [C_B_SIZE-1:0] s_b_data;
  wire [C_B_SIZE-1:0] m_b_data;

  // Read Address Port bit positions
  localparam integer C_ARUSER_RIGHT   = 0;
  localparam integer C_ARUSER_LEN     = C_AXI_SUPPORTS_USER_SIGNALS*C_AXI_ARUSER_WIDTH;
  localparam integer C_ARQOS_RIGHT    = C_ARUSER_RIGHT + C_ARUSER_LEN;
  localparam integer C_ARQOS_LEN      = 4;
  localparam integer C_ARREGION_RIGHT = C_ARQOS_RIGHT + C_ARQOS_LEN;
  localparam integer C_ARREGION_LEN   = 4;
  localparam integer C_ARPROT_RIGHT   = C_ARREGION_RIGHT + C_ARREGION_LEN;
  localparam integer C_ARPROT_LEN     = 3;
  localparam integer C_ARCACHE_RIGHT  = C_ARPROT_RIGHT + C_ARPROT_LEN;
  localparam integer C_ARCACHE_LEN    = 4;
  localparam integer C_ARLOCK_RIGHT   = C_ARCACHE_RIGHT + C_ARCACHE_LEN;
  localparam integer C_ARLOCK_LEN     = 2;
  localparam integer C_ARBURST_RIGHT  = C_ARLOCK_RIGHT + C_ARLOCK_LEN;
  localparam integer C_ARBURST_LEN    = 2;
  localparam integer C_ARSIZE_RIGHT   = C_ARBURST_RIGHT + C_ARBURST_LEN;
  localparam integer C_ARSIZE_LEN     = 3;
  localparam integer C_ARLEN_RIGHT    = C_ARSIZE_RIGHT + C_ARSIZE_LEN;
  localparam integer C_ARLEN_LEN      = 8;
  localparam integer C_ARADDR_RIGHT   = C_ARLEN_RIGHT + C_ARLEN_LEN;
  localparam integer C_ARADDR_LEN     = C_AXI_ADDR_WIDTH;
  localparam integer C_ARID_RIGHT     = C_ARADDR_RIGHT + C_ARADDR_LEN;
  localparam integer C_ARID_LEN       = C_AXI_ID_WIDTH;
  localparam integer C_AR_SIZE        = C_ARID_RIGHT + C_ARID_LEN;

  // Read Address Port FIFO data read and write
  wire [C_AR_SIZE-1:0] s_ar_data;
  wire [C_AR_SIZE-1:0] m_ar_data;

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

  // Reset resynchronization signals
  wire interconnect_areset_i;
  (* shift_extract="no", iob="false", equivalent_register_removal = "no" *) reg [2:0] m_axi_reset_resync;
  (* shift_extract="no", iob="false", equivalent_register_removal = "no" *) reg [2:0] s_axi_reset_resync;
  (* shift_extract="no", iob="false", equivalent_register_removal = "no" *) reg [2:0] interconnect_reset_resync;
  (* shift_extract="no" *) reg  [2:0] interconnect_reset_pipe;
  (* shift_extract="no" *) reg  [2:0] m_axi_reset_pipe;
  (* shift_extract="no" *) reg  [2:0] s_axi_reset_pipe;
  (* KEEP = "TRUE", shift_extract="no", iob="false", equivalent_register_removal = "no" *) reg m_async_conv_reset /* synthesis syn_keep = 1 */;
  (* KEEP = "TRUE", shift_extract="no", iob="false", equivalent_register_removal = "no" *) reg s_async_conv_reset /* synthesis syn_keep = 1 */;
  
  wire async_conv_reset;
  wire s_axi_reset_out_i; 
  wire m_axi_reset_out_i; 

  ////////////////////////////////////////////////////////////////////////////////
  // AXI Reset Signal Resynchronization
  ////////////////////////////////////////////////////////////////////////////////
  
  assign interconnect_areset_i = ~INTERCONNECT_ARESETN;
  
  assign INTERCONNECT_RESET_OUT_N = ~interconnect_reset_pipe[2];
  always @(posedge INTERCONNECT_ACLK or posedge interconnect_areset_i) begin
    if (interconnect_areset_i) begin
      interconnect_reset_resync <= 3'b111;
    end else begin
      interconnect_reset_resync <= {interconnect_reset_resync[1:0], 1'b0};
    end
  end
  always @(posedge INTERCONNECT_ACLK) begin
    if (interconnect_reset_resync[2]) begin
      interconnect_reset_pipe <= 3'b111;
    end else begin
      interconnect_reset_pipe <= {interconnect_reset_pipe[1:0], 1'b0};
    end
  end
  
  assign async_conv_reset = m_async_conv_reset | s_async_conv_reset;
  always @(posedge S_AXI_ACLK) begin
    s_async_conv_reset <= s_axi_reset_out_i;
  end
  always @(posedge M_AXI_ACLK) begin
    m_async_conv_reset <= m_axi_reset_out_i;
  end
  
  
  generate
    if ((C_AXI_IS_ACLK_ASYNC == 1'b1) ||
        (P_ACLK_RATIO > 1)) begin : gen_reset_resync
      
      assign M_AXI_RESET_OUT_N = ~m_axi_reset_pipe[2];
      assign m_axi_reset_out_i = m_axi_reset_pipe[2];
      always @(posedge M_AXI_ACLK or posedge interconnect_areset_i) begin
        if (interconnect_areset_i) begin
          m_axi_reset_resync <= 3'b111;
        end else begin
          m_axi_reset_resync <= {m_axi_reset_resync[1:0], 1'b0};
        end
      end
      always @(posedge M_AXI_ACLK) begin
        if (m_axi_reset_resync[2]) begin
          m_axi_reset_pipe <= 3'b111;
        end else begin
          m_axi_reset_pipe <= {m_axi_reset_pipe[1:0], 1'b0};
        end
      end
      
      assign S_AXI_RESET_OUT_N = ~s_axi_reset_pipe[2];
      assign s_axi_reset_out_i = s_axi_reset_pipe[2];
      always @(posedge S_AXI_ACLK or posedge interconnect_areset_i) begin
        if (interconnect_areset_i) begin
          s_axi_reset_resync <= 3'b111;
        end else begin
          s_axi_reset_resync <= {s_axi_reset_resync[1:0], 1'b0};
        end
      end
      always @(posedge S_AXI_ACLK) begin
        if (s_axi_reset_resync[2]) begin
          s_axi_reset_pipe <= 3'b111;
        end else begin
          s_axi_reset_pipe <= {s_axi_reset_pipe[1:0], 1'b0};
        end
      end
      
    end else begin : gen_no_reset_resync
      assign M_AXI_RESET_OUT_N = LOCAL_ARESETN;
      assign S_AXI_RESET_OUT_N = LOCAL_ARESETN;
      assign m_axi_reset_out_i = 1'b0;
      assign s_axi_reset_out_i = 1'b0;
    end  
  
    // Sample-cycle strobe generator
    if ((P_ACLK_RATIO > 1) && ~C_AXI_IS_ACLK_ASYNC) begin : gen_sample
      assign {fast_aclk, slow_aclk} = P_SI_LT_MI ? {M_AXI_ACLK, S_AXI_ACLK} : {S_AXI_ACLK, M_AXI_ACLK};
      assign {fast_areset, slow_areset} = P_SI_LT_MI ? {m_axi_reset_pipe[2], s_axi_reset_pipe[2]} : {s_axi_reset_pipe[2], m_axi_reset_pipe[2]};
      always @(posedge slow_aclk) begin
        if (slow_areset) begin
          slow_div2 <= 1'b0;
        end else begin
          #100 slow_div2 <= ~slow_div2;  // For simulation, avoid sampling new value during corresponding cycle of fast_aclk.
        end
      end
      always @(posedge fast_aclk) begin
        if (fast_areset) begin
          slow_div2_d1 <= 1'b0;
          sync_cnt <= {(P_ACLK_RATIO_LOG+1){1'b1}};
          sample <= 1'b0;
          accel_reset <= 2'b11;
          reset_wait <= 1'b1;
        end else begin
          if (slow_div2_d1) begin  // Do not allow accel to come out of reset until slow_div2 pulses begin arriving from slow clock domain
            reset_wait <= 1'b0;
          end
          if (sample) begin  // De-assert reset to accel after 2 more sample cycles
            accel_reset <= {accel_reset[0], reset_wait};
          end
          if (P_ACLK_RATIO == 2) begin
            sample <= slow_div2_d1 ^ slow_div2;
          end else begin
            sample <= (sync_cnt == 0);
            if (slow_div2_d1 ^ slow_div2) begin
              sync_cnt <= P_LOAD_CNT;
            end else begin
              sync_cnt <= sync_cnt - 1;
            end
          end
          slow_div2_d1 <= slow_div2;
        end
      end
    end  // gen_sample
  
  
  ////////////////////////////////////////////////////////////////////////////////
  // AXI write channels
  ////////////////////////////////////////////////////////////////////////////////
    if (C_AXI_SUPPORTS_WRITE && (
              (C_AXI_IS_ACLK_ASYNC == 1'b1) ||
              (P_ACLK_RATIO > 1)
            )) begin : gen_conv_write_ch

      // Write Address Port
      if (C_AXI_SUPPORTS_USER_SIGNALS == 1) begin : gen_aw_user
        assign s_aw_data    = {S_AXI_AWID, S_AXI_AWADDR, S_AXI_AWLEN, S_AXI_AWSIZE, 
                               S_AXI_AWBURST, S_AXI_AWLOCK, S_AXI_AWCACHE, S_AXI_AWPROT, 
                               S_AXI_AWREGION, S_AXI_AWQOS, S_AXI_AWUSER};
        assign M_AXI_AWUSER = m_aw_data[C_AWUSER_RIGHT+:C_AWUSER_LEN];
      end
      else begin : gen_aw_no_user
        assign s_aw_data    = {S_AXI_AWID, S_AXI_AWADDR, S_AXI_AWLEN, S_AXI_AWSIZE, 
                               S_AXI_AWBURST, S_AXI_AWLOCK, S_AXI_AWCACHE, S_AXI_AWPROT, 
                               S_AXI_AWREGION, S_AXI_AWQOS};
        assign M_AXI_AWUSER = {C_AXI_AWUSER_WIDTH{1'b0}};
      end

      assign M_AXI_AWID     = m_aw_data[C_AWID_RIGHT+:C_AWID_LEN];
      assign M_AXI_AWADDR   = m_aw_data[C_AWADDR_RIGHT+:C_AWADDR_LEN];
      assign M_AXI_AWLEN    = m_aw_data[C_AWLEN_RIGHT+:C_AWLEN_LEN];
      assign M_AXI_AWSIZE   = m_aw_data[C_AWSIZE_RIGHT+:C_AWSIZE_LEN];
      assign M_AXI_AWBURST  = m_aw_data[C_AWBURST_RIGHT+:C_AWBURST_LEN];
      assign M_AXI_AWLOCK   = m_aw_data[C_AWLOCK_RIGHT+:C_AWLOCK_LEN];
      assign M_AXI_AWCACHE  = m_aw_data[C_AWCACHE_RIGHT+:C_AWCACHE_LEN];
      assign M_AXI_AWPROT   = m_aw_data[C_AWPROT_RIGHT+:C_AWPROT_LEN];
      assign M_AXI_AWREGION = m_aw_data[C_AWREGION_RIGHT+:C_AWREGION_LEN];
      assign M_AXI_AWQOS    = m_aw_data[C_AWQOS_RIGHT+:C_AWQOS_LEN];

      if (C_AXI_IS_ACLK_ASYNC) begin : gen_aw_async
        fifo_gen #(
          .C_FAMILY(C_FAMILY),
          .C_COMMON_CLOCK(0),
          .C_FIFO_DEPTH_LOG(5),
          .C_FIFO_WIDTH(C_AW_SIZE),
          .C_FIFO_TYPE("lut")
          )
        asyncfifo_aw (
          .clk(1'b0),
          .rst(async_conv_reset),
          .wr_clk(S_AXI_ACLK),
          .wr_en(S_AXI_AWVALID),
          .wr_ready(S_AXI_AWREADY),
          .wr_data(s_aw_data),
          .rd_clk(M_AXI_ACLK),
          .rd_en(M_AXI_AWREADY),
          .rd_valid(M_AXI_AWVALID),
          .rd_data(m_aw_data));
      end else if (P_SI_LT_MI) begin : gen_aw_accel
        clock_sync_accel #
          (
           .C_FAMILY(C_FAMILY),
           .C_DATA_WIDTH(C_AW_SIZE),
           .C_MODE(P_LIGHT_WT)
           )
        aw_accel
          (
           .ACLK(M_AXI_ACLK),
           .ARESET(accel_reset[1]),
           .SAMPLE(sample),
           .S_PAYLOAD_DATA(s_aw_data),
           .S_VALID(S_AXI_AWVALID),
           .S_READY(S_AXI_AWREADY),
           .M_PAYLOAD_DATA(m_aw_data),
           .M_VALID(M_AXI_AWVALID),
           .M_READY(M_AXI_AWREADY)
           );
      end else begin : gen_aw_decel
        clock_sync_decel #
          (
           .C_FAMILY(C_FAMILY),
           .C_DATA_WIDTH(C_AW_SIZE),
           .C_MODE(P_LIGHT_WT)
           )
        aw_decel
          (
           .ACLK(S_AXI_ACLK),
           .ARESET(accel_reset[1]),
           .SAMPLE(sample),
           .S_PAYLOAD_DATA(s_aw_data),
           .S_VALID(S_AXI_AWVALID),
           .S_READY(S_AXI_AWREADY),
           .M_PAYLOAD_DATA(m_aw_data),
           .M_VALID(M_AXI_AWVALID),
           .M_READY(M_AXI_AWREADY)
           );
      end

      // Write Data Port
      if (C_AXI_SUPPORTS_USER_SIGNALS == 1) begin : gen_w_user
        assign s_w_data     = {S_AXI_WDATA, S_AXI_WSTRB, S_AXI_WLAST, S_AXI_WUSER};
        assign M_AXI_WUSER = m_w_data[C_WUSER_RIGHT+:C_WUSER_LEN];
      end
      else begin : gen_w_no_user
        assign s_w_data     = {S_AXI_WDATA, S_AXI_WSTRB, S_AXI_WLAST};
        assign M_AXI_WUSER  = {C_AXI_WUSER_WIDTH{1'b0}};
      end

      assign M_AXI_WDATA    = m_w_data[C_WDATA_RIGHT+:C_WDATA_LEN];
      assign M_AXI_WSTRB    = m_w_data[C_WSTRB_RIGHT+:C_WSTRB_LEN];
      assign M_AXI_WLAST    = m_w_data[C_WLAST_RIGHT+:C_WLAST_LEN];

      if (C_AXI_IS_ACLK_ASYNC) begin : gen_w_async
        fifo_gen #(
          .C_FAMILY(C_FAMILY),
          .C_COMMON_CLOCK(0),
          .C_FIFO_DEPTH_LOG(5),
          .C_FIFO_WIDTH(C_W_SIZE),
          .C_FIFO_TYPE("lut")
          )
        asyncfifo_w (
          .clk(1'b0),
          .rst(async_conv_reset),
          .wr_clk(S_AXI_ACLK),
          .wr_en(S_AXI_WVALID),
          .wr_ready(S_AXI_WREADY),
          .wr_data(s_w_data),
          .rd_clk(M_AXI_ACLK),
          .rd_en(M_AXI_WREADY),
          .rd_valid(M_AXI_WVALID),
          .rd_data(m_w_data));
      end else if (P_SI_LT_MI) begin : gen_w_accel
        clock_sync_accel #
          (
           .C_FAMILY(C_FAMILY),
           .C_DATA_WIDTH(C_W_SIZE),
           .C_MODE((C_AXI_PROTOCOL == P_AXILITE) ? P_LIGHT_WT : P_FULLY_REG)
           )
        w_accel
          (
           .ACLK(M_AXI_ACLK),
           .ARESET(accel_reset[1]),
           .SAMPLE(sample),
           .S_PAYLOAD_DATA(s_w_data),
           .S_VALID(S_AXI_WVALID),
           .S_READY(S_AXI_WREADY),
           .M_PAYLOAD_DATA(m_w_data),
           .M_VALID(M_AXI_WVALID),
           .M_READY(M_AXI_WREADY)
           );
      end else begin : gen_w_decel
        clock_sync_decel #
          (
           .C_FAMILY(C_FAMILY),
           .C_DATA_WIDTH(C_W_SIZE),
           .C_MODE((C_AXI_PROTOCOL == P_AXILITE) ? P_LIGHT_WT : P_FULLY_REG)
           )
        w_decel
          (
           .ACLK(S_AXI_ACLK),
           .ARESET(accel_reset[1]),
           .SAMPLE(sample),
           .S_PAYLOAD_DATA(s_w_data),
           .S_VALID(S_AXI_WVALID),
           .S_READY(S_AXI_WREADY),
           .M_PAYLOAD_DATA(m_w_data),
           .M_VALID(M_AXI_WVALID),
           .M_READY(M_AXI_WREADY)
           );
      end

      // Write Response Port
      if (C_AXI_SUPPORTS_USER_SIGNALS == 1) begin : gen_b_user
        assign m_b_data     = {M_AXI_BID, M_AXI_BRESP, M_AXI_BUSER};
        assign S_AXI_BUSER  = s_b_data[C_BUSER_RIGHT+:C_BUSER_LEN];
      end
      else begin : gen_b_no_user
        assign m_b_data     = {M_AXI_BID, M_AXI_BRESP};
        assign S_AXI_BUSER  = {C_AXI_BUSER_WIDTH{1'b0}};
      end

      assign S_AXI_BID      = s_b_data[C_BID_RIGHT+:C_BID_LEN];
      assign S_AXI_BRESP    = s_b_data[C_BRESP_RIGHT+:C_BRESP_LEN];

      if (C_AXI_IS_ACLK_ASYNC) begin : gen_b_async
        fifo_gen #(
          .C_FAMILY(C_FAMILY),
          .C_COMMON_CLOCK(0),
          .C_FIFO_DEPTH_LOG(5),
          .C_FIFO_WIDTH(C_B_SIZE),
          .C_FIFO_TYPE("lut")
          )
        asyncfifo_b (
          .clk(1'b0),
          .rst(async_conv_reset),
          .wr_clk(M_AXI_ACLK),
          .wr_en(M_AXI_BVALID),
          .wr_ready(M_AXI_BREADY),
          .wr_data(m_b_data),
          .rd_clk(S_AXI_ACLK),
          .rd_en(S_AXI_BREADY),
          .rd_valid(S_AXI_BVALID),
          .rd_data(s_b_data));
      end else if (~P_SI_LT_MI) begin : gen_b_accel
        clock_sync_accel #
          (
           .C_FAMILY(C_FAMILY),
           .C_DATA_WIDTH(C_B_SIZE),
           .C_MODE(P_LIGHT_WT)
           )
        b_accel
          (
           .ACLK(S_AXI_ACLK),
           .ARESET(accel_reset[1]),
           .SAMPLE(sample),
           .S_PAYLOAD_DATA(m_b_data),
           .S_VALID(M_AXI_BVALID),
           .S_READY(M_AXI_BREADY),
           .M_PAYLOAD_DATA(s_b_data),
           .M_VALID(S_AXI_BVALID),
           .M_READY(S_AXI_BREADY)
           );
      end else begin : gen_b_decel
        clock_sync_decel #
          (
           .C_FAMILY(C_FAMILY),
           .C_DATA_WIDTH(C_B_SIZE),
           .C_MODE(P_LIGHT_WT)
           )
        b_decel
          (
           .ACLK(M_AXI_ACLK),
           .ARESET(accel_reset[1]),
           .SAMPLE(sample),
           .S_PAYLOAD_DATA(m_b_data),
           .S_VALID(M_AXI_BVALID),
           .S_READY(M_AXI_BREADY),
           .M_PAYLOAD_DATA(s_b_data),
           .M_VALID(S_AXI_BVALID),
           .M_READY(S_AXI_BREADY)
           );
      end

    end

    // No clock conversion, i.e. 1:1 
    else begin : gen_bypass_write_ch

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
      assign M_AXI_AWVALID  = S_AXI_AWVALID & (C_AXI_SUPPORTS_WRITE != 0);
      assign S_AXI_AWREADY  = M_AXI_AWREADY & (C_AXI_SUPPORTS_WRITE != 0);

      // Write Data Port
      assign M_AXI_WDATA    = S_AXI_WDATA;
      assign M_AXI_WSTRB    = S_AXI_WSTRB;
      assign M_AXI_WLAST    = S_AXI_WLAST;
      assign M_AXI_WUSER    = S_AXI_WUSER;
      assign M_AXI_WVALID   = S_AXI_WVALID & (C_AXI_SUPPORTS_WRITE != 0);
      assign S_AXI_WREADY   = M_AXI_WREADY & (C_AXI_SUPPORTS_WRITE != 0);

      // Write Response Port
      assign S_AXI_BID      = M_AXI_BID;
      assign S_AXI_BRESP    = M_AXI_BRESP;
      assign S_AXI_BUSER    = M_AXI_BUSER;
      assign S_AXI_BVALID   = M_AXI_BVALID & (C_AXI_SUPPORTS_WRITE != 0);
      assign M_AXI_BREADY   = S_AXI_BREADY & (C_AXI_SUPPORTS_WRITE != 0);
    end

    ////////////////////////////////////////////////////////////////////////////////
    // AXI read channels
    ////////////////////////////////////////////////////////////////////////////////

    if (C_AXI_SUPPORTS_READ && (
         (C_AXI_IS_ACLK_ASYNC == 1'b1) ||
         (P_ACLK_RATIO > 1)
       )) begin : gen_conv_read_ch

      // Read Address Port
      if (C_AXI_SUPPORTS_USER_SIGNALS == 1) begin : gen_ar_user
        assign s_ar_data    = {S_AXI_ARID, S_AXI_ARADDR, S_AXI_ARLEN, S_AXI_ARSIZE, 
                               S_AXI_ARBURST, S_AXI_ARLOCK, S_AXI_ARCACHE, S_AXI_ARPROT, 
                               S_AXI_ARREGION, S_AXI_ARQOS, S_AXI_ARUSER};
        assign M_AXI_ARUSER = m_ar_data[C_ARUSER_RIGHT+:C_ARUSER_LEN];
      end
      else begin : gen_ar_no_user
        assign s_ar_data    = {S_AXI_ARID, S_AXI_ARADDR, S_AXI_ARLEN, S_AXI_ARSIZE, 
                               S_AXI_ARBURST, S_AXI_ARLOCK, S_AXI_ARCACHE, S_AXI_ARPROT, 
                               S_AXI_ARREGION, S_AXI_ARQOS};
        
        assign M_AXI_ARUSER = {C_AXI_ARUSER_WIDTH{1'b0}};
      end

      assign M_AXI_ARID     = m_ar_data[C_ARID_RIGHT+:C_ARID_LEN];
      assign M_AXI_ARADDR   = m_ar_data[C_ARADDR_RIGHT+:C_ARADDR_LEN];
      assign M_AXI_ARLEN    = m_ar_data[C_ARLEN_RIGHT+:C_ARLEN_LEN];
      assign M_AXI_ARSIZE   = m_ar_data[C_ARSIZE_RIGHT+:C_ARSIZE_LEN];
      assign M_AXI_ARBURST  = m_ar_data[C_ARBURST_RIGHT+:C_ARBURST_LEN];
      assign M_AXI_ARLOCK   = m_ar_data[C_ARLOCK_RIGHT+:C_ARLOCK_LEN];
      assign M_AXI_ARCACHE  = m_ar_data[C_ARCACHE_RIGHT+:C_ARCACHE_LEN];
      assign M_AXI_ARPROT   = m_ar_data[C_ARPROT_RIGHT+:C_ARPROT_LEN];
      assign M_AXI_ARREGION = m_ar_data[C_ARREGION_RIGHT+:C_ARREGION_LEN];
      assign M_AXI_ARQOS    = m_ar_data[C_ARQOS_RIGHT+:C_ARQOS_LEN];

      if (C_AXI_IS_ACLK_ASYNC) begin : gen_ar_async
        fifo_gen #(
          .C_FAMILY(C_FAMILY),
          .C_COMMON_CLOCK(0),
          .C_FIFO_DEPTH_LOG(5),
          .C_FIFO_WIDTH(C_AR_SIZE),
          .C_FIFO_TYPE("lut")
          )
        asyncfifo_ar (
          .clk(1'b0),
          .rst(async_conv_reset),
          .wr_clk(S_AXI_ACLK),
          .wr_en(S_AXI_ARVALID),
          .wr_ready(S_AXI_ARREADY),
          .wr_data(s_ar_data),
          .rd_clk(M_AXI_ACLK),
          .rd_en(M_AXI_ARREADY),
          .rd_valid(M_AXI_ARVALID),
          .rd_data(m_ar_data));
      end else if (P_SI_LT_MI) begin : gen_ar_accel
        clock_sync_accel #
          (
           .C_FAMILY(C_FAMILY),
           .C_DATA_WIDTH(C_AR_SIZE),
           .C_MODE(P_LIGHT_WT)
           )
        ar_accel
          (
           .ACLK(M_AXI_ACLK),
           .ARESET(accel_reset[1]),
           .SAMPLE(sample),
           .S_PAYLOAD_DATA(s_ar_data),
           .S_VALID(S_AXI_ARVALID),
           .S_READY(S_AXI_ARREADY),
           .M_PAYLOAD_DATA(m_ar_data),
           .M_VALID(M_AXI_ARVALID),
           .M_READY(M_AXI_ARREADY)
           );
      end else begin : gen_ar_decel
        clock_sync_decel #
          (
           .C_FAMILY(C_FAMILY),
           .C_DATA_WIDTH(C_AR_SIZE),
           .C_MODE(P_LIGHT_WT)
           )
        ar_decel
          (
           .ACLK(S_AXI_ACLK),
           .ARESET(accel_reset[1]),
           .SAMPLE(sample),
           .S_PAYLOAD_DATA(s_ar_data),
           .S_VALID(S_AXI_ARVALID),
           .S_READY(S_AXI_ARREADY),
           .M_PAYLOAD_DATA(m_ar_data),
           .M_VALID(M_AXI_ARVALID),
           .M_READY(M_AXI_ARREADY)
           );
      end

      // Read Data Port
      if (C_AXI_SUPPORTS_USER_SIGNALS == 1) begin : gen_r_user
        assign m_r_data     = {M_AXI_RID, M_AXI_RDATA, M_AXI_RRESP, M_AXI_RLAST, M_AXI_RUSER};
        assign S_AXI_RUSER  = s_r_data[C_RUSER_RIGHT+:C_RUSER_LEN];
      end
      else begin : gen_r_no_user
        assign m_r_data     = {M_AXI_RID, M_AXI_RDATA, M_AXI_RRESP, M_AXI_RLAST};
        assign S_AXI_RUSER  = {C_AXI_RUSER_WIDTH{1'b0}};
      end

      assign S_AXI_RID      = s_r_data[C_RID_RIGHT+:C_RID_LEN];
      assign S_AXI_RDATA    = s_r_data[C_RDATA_RIGHT+:C_RDATA_LEN];
      assign S_AXI_RRESP    = s_r_data[C_RRESP_RIGHT+:C_RRESP_LEN];
      assign S_AXI_RLAST    = s_r_data[C_RLAST_RIGHT+:C_RLAST_LEN];

      if (C_AXI_IS_ACLK_ASYNC) begin : gen_r_async
        fifo_gen #(
          .C_FAMILY(C_FAMILY),
          .C_COMMON_CLOCK(0),
          .C_FIFO_DEPTH_LOG(5),
          .C_FIFO_WIDTH(C_R_SIZE),
          .C_FIFO_TYPE("lut")
          )
        asyncfifo_r (
          .clk(1'b0),
          .rst(async_conv_reset),
          .wr_clk(M_AXI_ACLK),
          .wr_en(M_AXI_RVALID),
          .wr_ready(M_AXI_RREADY),
          .wr_data(m_r_data),
          .rd_clk(S_AXI_ACLK),
          .rd_en(S_AXI_RREADY),
          .rd_valid(S_AXI_RVALID),
          .rd_data(s_r_data));
      end else if (~P_SI_LT_MI) begin : gen_r_accel
        clock_sync_accel #
          (
           .C_FAMILY(C_FAMILY),
           .C_DATA_WIDTH(C_R_SIZE),
           .C_MODE((C_AXI_PROTOCOL == P_AXILITE) ? P_LIGHT_WT : P_FULLY_REG)
           )
        r_accel
          (
           .ACLK(S_AXI_ACLK),
           .ARESET(accel_reset[1]),
           .SAMPLE(sample),
           .S_PAYLOAD_DATA(m_r_data),
           .S_VALID(M_AXI_RVALID),
           .S_READY(M_AXI_RREADY),
           .M_PAYLOAD_DATA(s_r_data),
           .M_VALID(S_AXI_RVALID),
           .M_READY(S_AXI_RREADY)
           );
      end else begin : gen_r_decel
        clock_sync_decel #
          (
           .C_FAMILY(C_FAMILY),
           .C_DATA_WIDTH(C_R_SIZE),
           .C_MODE((C_AXI_PROTOCOL == P_AXILITE) ? P_LIGHT_WT : P_FULLY_REG)
           )
        r_decel
          (
           .ACLK(M_AXI_ACLK),
           .ARESET(accel_reset[1]),
           .SAMPLE(sample),
           .S_PAYLOAD_DATA(m_r_data),
           .S_VALID(M_AXI_RVALID),
           .S_READY(M_AXI_RREADY),
           .M_PAYLOAD_DATA(s_r_data),
           .M_VALID(S_AXI_RVALID),
           .M_READY(S_AXI_RREADY)
           );
      end

    end

    // No clock conversion, i.e. 1:1 
    else begin : gen_bypass_read_ch

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
      assign M_AXI_ARVALID  = S_AXI_ARVALID & (C_AXI_SUPPORTS_READ != 0);
      assign S_AXI_ARREADY  = M_AXI_ARREADY & (C_AXI_SUPPORTS_READ != 0);

      // Read Data Port
      assign S_AXI_RID      = M_AXI_RID;
      assign S_AXI_RDATA    = M_AXI_RDATA;
      assign S_AXI_RRESP    = M_AXI_RRESP;
      assign S_AXI_RLAST    = M_AXI_RLAST;
      assign S_AXI_RUSER    = M_AXI_RUSER;
      assign S_AXI_RVALID   = M_AXI_RVALID & (C_AXI_SUPPORTS_READ != 0);
      assign M_AXI_RREADY   = S_AXI_RREADY & (C_AXI_SUPPORTS_READ != 0);
    end

  endgenerate

endmodule
