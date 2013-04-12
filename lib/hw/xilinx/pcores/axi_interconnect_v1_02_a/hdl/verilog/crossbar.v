// -- (c) Copyright 2009 - 2011 Xilinx, Inc. All rights reserved.
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
// File name: crossbar.v
//
// Description: 
//   This module is a M-master to N-slave AXI crossbar switch.
//   The interface of this module consists of a vectored slave and master interface
//     in which all slots are sized and synchronized to the native width and clock 
//     of the interconnect, and are all AXI4 protocol.
//   All width, clock and protocol conversions are done outside this block, as are
//     any pipeline registers or data FIFOs.
//   This module contains all arbitration, decoders and channel multiplexing logic.
//     It also contains the diagnostic registers and control interface.
//
//-----------------------------------------------------------------------------
//
// Structure:
//    crossbar
//      si_transactor
//        addr_decoder
//          comparator_static
//        mux_enc
//        axic_srl_fifo
//        arbiter_resp
//      splitter
//      wdata_router
//        axic_reg_srl_fifo
//      wdata_mux
//        axic_reg_srl_fifo
//        mux_enc
//      addr_decoder
//        comparator_static
//      axic_srl_fifo
//      axi_register_slice
//      addr_arbiter
//        mux_enc
//      decerr_slave
//      
//-----------------------------------------------------------------------------
`timescale 1ps/1ps
`default_nettype none

module crossbar #
  (
   parameter integer C_MAX_NUM_SLOTS = 16,
   parameter integer C_NUM_ADDR_RANGES = 16,
   parameter         C_FAMILY                       = "none", 
                       // FPGA Family. Current version: virtex6 or spartan6.
   parameter integer C_NUM_SLAVE_SLOTS              =   1, 
                       // Number of Slave Interface (SI) slots for connecting 
                       // to master IP. Range: 1-16.
   parameter integer C_NUM_MASTER_SLOTS             =   1, 
                       // Number of Master Interface (MI) slots for connecting 
                       // to slave IP. Range: 1-16.
   parameter integer C_AXI_ID_WIDTH                   = 1, 
                       // Width of ID signals propagated by the Interconnect.
                       // Width of ID signals produced on all MI slots.
                       // Range: >= 1.
   parameter integer C_AXI_ADDR_WIDTH                 = 32, 
                       // Width of S_AXI_AWADDR, S_AXI_ARADDR, M_AXI_AWADDR and 
                       // M_AXI_ARADDR for all SI/MI slots.
                       // Range: 32.
   parameter integer C_INTERCONNECT_DATA_WIDTH = 32, 
                       // Data width of the internal interconnect write and read 
                       // data paths.
                       // Range: 32, 64, 128, 256.
   parameter integer C_AXI_DATA_MAX_WIDTH             = 256, 
                       // Largest value supported for any DATA_WIDTH.
   parameter [511:0] C_M_AXI_DATA_WIDTH               = {16{32'h00000020}}, 
                       // Width of M_AXI_WDATA and M_AXI_RDATA for each MI slot.
                       // Format: C_NUM_MASTER_SLOTS{Bit32};
                       // Range: 'h00000020, 'h00000040, 'h00000080, 'h00000100.
                       // Used to determine whether W-channel gets reg-slice.
   parameter [511:0] C_S_AXI_PROTOCOL                 = {16{32'h00000000}}, 
                       // Indicates whether connected master is 
                       // Full-AXI4 ('h00000000),
                       // AXI3 ('h00000001) or 
                       // Axi4Lite ('h00000002), for each SI slot.
                       // Format: C_NUM_MASTER_SLOTS{Bit32}.
   parameter [511:0] C_M_AXI_PROTOCOL                 = {16{32'h00000000}}, 
                       // Indicates whether connected slave is
                       // Full-AXI4 ('h00000000),
                       // AXI3 ('h00000001) or 
                       // Axi4Lite ('h00000002), for each SI slot.
                       // Format: C_NUM_SLAVE_SLOTS{Bit32}.
   parameter [16383:0] C_M_AXI_BASE_ADDR                 = {256{64'hFFFFFFFF_FFFFFFFF}}, 
                       // Base address of each range of each MI slot. 
                       // For unused ranges, set base address to 'hFFFFFFFF.
                       // Format: C_NUM_MASTER_SLOTS{16{Bit64}}.
   parameter [16383:0] C_M_AXI_HIGH_ADDR                 = {256{64'h00000000_00000000}}, 
                       // High address of each range of each MI slot. 
                       // For unused ranges, set high address to 'h00000000.
                       // Format: C_NUM_MASTER_SLOTS{16{Bit64}}.
   parameter [1023:0] C_S_AXI_BASE_ID                  = {16{64'h00000000_00000000}},
                       // Base ID of each SI slot. 
                       // Format: C_NUM_SLAVE_SLOTS{Bit64};
                       // Range: 0 to 2**C_AXI_ID_WIDTH-1.
   parameter [1023:0] C_S_AXI_HIGH_ID                  = {16{64'h00000000_00000000}},
                       // High ID of each SI slot. 
                       // Format: C_NUM_SLAVE_SLOTS{Bit64};
                       // Range: 0 to 2**C_AXI_ID_WIDTH-1.
   parameter         C_S_AXI_IS_INTERCONNECT = 16'b00000000_00000000, 
                       // Indicates whether connected master is an end-point
                       // master (0) or an interconnect (1), for each SI slot.
                       // Format: C_NUM_SLAVE_SLOTS{Bit1}.
   parameter         C_S_AXI_SUPPORTS_WRITE           = 16'b11111111_11111111, 
                       // Indicates whether each SI supports write transactions.
                       // Format: C_NUM_SLAVE_SLOTS{Bit1}.
   parameter         C_S_AXI_SUPPORTS_READ            = 16'b11111111_11111111, 
                       // Indicates whether each SI supports read transactions.
                       // Format: C_NUM_SLAVE_SLOTS{Bit1}.
   parameter         C_M_AXI_SUPPORTS_WRITE           = 16'b11111111_11111111, 
                       // Indicates whether each MI supports write transactions.
                       // Format: C_NUM_MASTER_SLOTS{Bit1}.
   parameter         C_M_AXI_SUPPORTS_READ            = 16'b11111111_11111111, 
                       // Indicates whether each MI supports read transactions.
                       // Format: C_NUM_MASTER_SLOTS{Bit1}.
   parameter integer C_AXI_SUPPORTS_USER_SIGNALS = 0,
                       // 1 = Propagate all USER signals, 0 = Dont propagate.
   parameter integer C_AXI_AWUSER_WIDTH = 1,
                       // Width of AWUSER signals for all SI slots and MI slots. 
                       // Range: >= 1.
   parameter integer C_AXI_ARUSER_WIDTH = 1,
                       // Width of ARUSER signals for all SI slots and MI slots. 
                       // Range: >= 1.
   parameter integer C_AXI_WUSER_WIDTH = 1,
                       // Width of WUSER signals for all SI slots and MI slots. 
                       // Range: >= 1.
   parameter integer C_AXI_RUSER_WIDTH = 1,
                       // Width of RUSER signals for all SI slots and MI slots. 
                       // Range: >= 1.
   parameter integer C_AXI_BUSER_WIDTH = 1,
                       // Width of BUSER signals for all SI slots and MI slots. 
                       // Range: >= 1.
   parameter [511:0] C_AXI_CONNECTIVITY               = {16{32'hFFFFFFFF}},
                       // Multi-pathway connectivity from each SI slot (N) to each 
                       // MI slot (M):
                       // 0 = no pathway required; 1 = pathway required.
                       // Format: C_NUM_MASTER_SLOTS{Bit32}; 
                       // Range: C_NUM_SLAVE_SLOTS{Bit1}.
   parameter         C_S_AXI_SINGLE_THREAD                 = 16'b00000000_00000000, 
                       // 0 = Implement separate command queues per ID thread.
                       // 1 = Force corresponding SI slot to be single-threaded.
   parameter         C_M_AXI_SUPPORTS_REORDERING = 16'b11111111_11111111,
                       // Indicates whether the slave connected to each MI slot 
                       // supports response reordering.
                       // Format: C_NUM_MASTER_SLOTS{Bit1}; 
   parameter [511:0] C_S_AXI_WRITE_ACCEPTANCE = {16{32'h00000020}},
                       // Maximum number of active write transactions that each SI 
                       // slot can accept.
                       // Format: C_NUM_SLAVE_SLOTS{Bit32}; Range: 'h1-'h20.
                       // Not used in this module; using C_W_ACCEPT_WIDTH instead.
   parameter [511:0] C_S_AXI_READ_ACCEPTANCE = {16{32'h00000020}},
                       // Maximum number of active read transactions that each SI 
                       // slot can accept.
                       // Format: C_NUM_SLAVE_SLOTS{Bit32}; Range: 'h1-'h20.
                       // Not used in this module; using C_R_ACCEPT_WIDTH instead.
   parameter [511:0] C_M_AXI_WRITE_ISSUING = {16{32'h00000020}},
                       // Maximum number of data-active write transactions that 
                       // each MI slot can generate at any one time.
                       // Format: C_NUM_MASTER_SLOTS{Bit32}; Range: 'h1-'h20.
                       // Not used in this module; using C_W_ISSUE_WIDTH instead.
   parameter [511:0] C_M_AXI_READ_ISSUING = {16{32'h00000020}},
                       // Maximum number of active read transactions that 
                       // each MI slot can generate at any one time.
                       // Format: C_NUM_MASTER_SLOTS{Bit32}; Range: 'h1-'h20.
                       // Not used in this module; using C_R_ISSUE_WIDTH instead.
//   parameter         C_S_AXI_ARB_METHOD = "priority", // Reserved for future
//                       // Arbitration method.
//                       // Format: String; 
//                       // Range: "priority" ("tdm" not yet implemented).
   parameter [511:0] C_S_AXI_ARB_PRIORITY             = {16{32'h00000000}},
                       // Arbitration priority among each SI slot. 
                       // Higher values indicate higher priority.
                       // Format: C_NUM_SLAVE_SLOTS{Bit32};
                       // Range: 'h0-'hF.
//   parameter [511:0] C_S_AXI_ARB_TDM_SLOTS            = {16{32'h00000000}}, // Reserved for future
//                       // Maximum number of consecutive TDM arbitration slots 
//                       // allocated among each SI slot.
//                       // Format: C_NUM_SLAVE_SLOTS{Bit32});
//   parameter integer C_S_AXI_ARB_TDM_TOTAL            = 0, // Reserved for future
//                       // Total number of TDM arbitration slots during which all 
//                       // TDM masters must be serviced.
//                       // (Must be >= sum of all C_S_AXI_ARB_TDM_SLOTS.)
   parameter         C_M_AXI_SECURE                   = 16'b00000000_00000000,
                       // Indicates whether each MI slot connects to a secure slave 
                       // (allows only TrustZone secure access).
                       // Format: C_NUM_MASTER_SLOTS{Bit1}.
   parameter integer C_USE_CTRL_PORT = 0,
                       // Indicates whether diagnostic information is accessible 
                       // via the S_AXI_CTRL interface.
   parameter integer C_USE_INTERRUPT = 1,
                       // If CTRL interface enabled, indicates whether interrupts 
                       // are generated.
   parameter integer C_RANGE_CHECK                    = 0,
                       // 1 = Implement DECERR detection and response handler.
                       // 0 = Pass all transactions without error-checking.
   parameter integer C_S_AXI_CTRL_ADDR_WIDTH = 32,
                       // ADDR width of CTRL interface.
   parameter integer C_S_AXI_CTRL_DATA_WIDTH = 32,
                       // DATA width of CTRL interface.
   parameter [17*32-1:0] C_W_ISSUE_WIDTH  = {17{32'h00000000}},
   parameter [17*32-1:0] C_R_ISSUE_WIDTH  = {17{32'h00000000}},
   parameter [16*32-1:0] C_W_ACCEPT_WIDTH = {16{32'h00000000}},
   parameter [16*32-1:0] C_R_ACCEPT_WIDTH = {16{32'h00000000}},
   parameter integer C_DEBUG          = 1
   )
  (
   // Global Signals
   input  wire                                                    INTERCONNECT_ACLK,
   input  wire                                                    ARESETN,
   output wire                                                    IRQ,
   // Slave Interface Write Address Ports
   input  wire [C_NUM_SLAVE_SLOTS*C_AXI_ID_WIDTH-1:0]           S_AXI_AWID,
   input  wire [C_NUM_SLAVE_SLOTS*C_AXI_ADDR_WIDTH-1:0]           S_AXI_AWADDR,
   input  wire [C_NUM_SLAVE_SLOTS*8-1:0]                          S_AXI_AWLEN,
   input  wire [C_NUM_SLAVE_SLOTS*3-1:0]                          S_AXI_AWSIZE,
   input  wire [C_NUM_SLAVE_SLOTS*2-1:0]                          S_AXI_AWBURST,
   input  wire [C_NUM_SLAVE_SLOTS*2-1:0]                          S_AXI_AWLOCK,
   input  wire [C_NUM_SLAVE_SLOTS*4-1:0]                          S_AXI_AWCACHE,
   input  wire [C_NUM_SLAVE_SLOTS*3-1:0]                          S_AXI_AWPROT,
   input  wire [C_NUM_SLAVE_SLOTS*4-1:0]                          S_AXI_AWQOS,
   input  wire [C_NUM_SLAVE_SLOTS*C_AXI_AWUSER_WIDTH-1:0]         S_AXI_AWUSER,
   input  wire [C_NUM_SLAVE_SLOTS-1:0]                            S_AXI_AWVALID,
   output wire [C_NUM_SLAVE_SLOTS-1:0]                            S_AXI_AWREADY,
   // Slave Interface Write Data Ports
   input  wire [C_NUM_SLAVE_SLOTS*C_AXI_DATA_MAX_WIDTH-1:0]     S_AXI_WDATA,
   input  wire [C_NUM_SLAVE_SLOTS*C_AXI_DATA_MAX_WIDTH/8-1:0]   S_AXI_WSTRB,
   input  wire [C_NUM_SLAVE_SLOTS-1:0]                            S_AXI_WLAST,
   input  wire [C_NUM_SLAVE_SLOTS*C_AXI_WUSER_WIDTH-1:0]          S_AXI_WUSER,
   input  wire [C_NUM_SLAVE_SLOTS-1:0]                            S_AXI_WVALID,
   output wire [C_NUM_SLAVE_SLOTS-1:0]                            S_AXI_WREADY,
   // Slave Interface Write Response Ports
   output wire [C_NUM_SLAVE_SLOTS*C_AXI_ID_WIDTH-1:0]           S_AXI_BID,
   output wire [C_NUM_SLAVE_SLOTS*2-1:0]                          S_AXI_BRESP,
   output wire [C_NUM_SLAVE_SLOTS*C_AXI_BUSER_WIDTH-1:0]          S_AXI_BUSER,
   output wire [C_NUM_SLAVE_SLOTS-1:0]                            S_AXI_BVALID,
   input  wire [C_NUM_SLAVE_SLOTS-1:0]                            S_AXI_BREADY,
   // Slave Interface Read Address Ports
   input  wire [C_NUM_SLAVE_SLOTS*C_AXI_ID_WIDTH-1:0]           S_AXI_ARID,
   input  wire [C_NUM_SLAVE_SLOTS*C_AXI_ADDR_WIDTH-1:0]           S_AXI_ARADDR,
   input  wire [C_NUM_SLAVE_SLOTS*8-1:0]                          S_AXI_ARLEN,
   input  wire [C_NUM_SLAVE_SLOTS*3-1:0]                          S_AXI_ARSIZE,
   input  wire [C_NUM_SLAVE_SLOTS*2-1:0]                          S_AXI_ARBURST,
   input  wire [C_NUM_SLAVE_SLOTS*2-1:0]                          S_AXI_ARLOCK,
   input  wire [C_NUM_SLAVE_SLOTS*4-1:0]                          S_AXI_ARCACHE,
   input  wire [C_NUM_SLAVE_SLOTS*3-1:0]                          S_AXI_ARPROT,
   input  wire [C_NUM_SLAVE_SLOTS*4-1:0]                          S_AXI_ARQOS,
   input  wire [C_NUM_SLAVE_SLOTS*C_AXI_ARUSER_WIDTH-1:0]         S_AXI_ARUSER,
   input  wire [C_NUM_SLAVE_SLOTS-1:0]                            S_AXI_ARVALID,
   output wire [C_NUM_SLAVE_SLOTS-1:0]                            S_AXI_ARREADY,
   // Slave Interface Read Data Ports
   output wire [C_NUM_SLAVE_SLOTS*C_AXI_ID_WIDTH-1:0]           S_AXI_RID,
   output wire [C_NUM_SLAVE_SLOTS*C_AXI_DATA_MAX_WIDTH-1:0]     S_AXI_RDATA,
   output wire [C_NUM_SLAVE_SLOTS*2-1:0]                          S_AXI_RRESP,
   output wire [C_NUM_SLAVE_SLOTS-1:0]                            S_AXI_RLAST,
   output wire [C_NUM_SLAVE_SLOTS*C_AXI_RUSER_WIDTH-1:0]          S_AXI_RUSER,
   output wire [C_NUM_SLAVE_SLOTS-1:0]                            S_AXI_RVALID,
   input  wire [C_NUM_SLAVE_SLOTS-1:0]                            S_AXI_RREADY,
   // Master Interface Write Address Port
   output wire [C_NUM_MASTER_SLOTS*C_AXI_ID_WIDTH-1:0]          M_AXI_AWID,
   output wire [C_NUM_MASTER_SLOTS*C_AXI_ADDR_WIDTH-1:0]          M_AXI_AWADDR,
   output wire [C_NUM_MASTER_SLOTS*8-1:0]                         M_AXI_AWLEN,
   output wire [C_NUM_MASTER_SLOTS*3-1:0]                         M_AXI_AWSIZE,
   output wire [C_NUM_MASTER_SLOTS*2-1:0]                         M_AXI_AWBURST,
   output wire [C_NUM_MASTER_SLOTS*2-1:0]                         M_AXI_AWLOCK,
   output wire [C_NUM_MASTER_SLOTS*4-1:0]                         M_AXI_AWCACHE,
   output wire [C_NUM_MASTER_SLOTS*3-1:0]                         M_AXI_AWPROT,
   output wire [C_NUM_MASTER_SLOTS*4-1:0]                         M_AXI_AWREGION,
   output wire [C_NUM_MASTER_SLOTS*4-1:0]                         M_AXI_AWQOS,
   output wire [C_NUM_MASTER_SLOTS*C_AXI_AWUSER_WIDTH-1:0]        M_AXI_AWUSER,
   output wire [C_NUM_MASTER_SLOTS-1:0]                           M_AXI_AWVALID,
   input  wire [C_NUM_MASTER_SLOTS-1:0]                           M_AXI_AWREADY,
   // Master Interface Write Data Ports
   output wire [C_NUM_MASTER_SLOTS*C_AXI_DATA_MAX_WIDTH-1:0]    M_AXI_WDATA,
   output wire [C_NUM_MASTER_SLOTS*C_AXI_DATA_MAX_WIDTH/8-1:0]  M_AXI_WSTRB,
   output wire [C_NUM_MASTER_SLOTS-1:0]                           M_AXI_WLAST,
   output wire [C_NUM_MASTER_SLOTS*C_AXI_WUSER_WIDTH-1:0]         M_AXI_WUSER,
   output wire [C_NUM_MASTER_SLOTS-1:0]                           M_AXI_WVALID,
   input  wire [C_NUM_MASTER_SLOTS-1:0]                           M_AXI_WREADY,
   // Master Interface Write Response Ports
   input  wire [C_NUM_MASTER_SLOTS*C_AXI_ID_WIDTH-1:0]          M_AXI_BID,
   input  wire [C_NUM_MASTER_SLOTS*2-1:0]                         M_AXI_BRESP,
   input  wire [C_NUM_MASTER_SLOTS*C_AXI_BUSER_WIDTH-1:0]         M_AXI_BUSER,
   input  wire [C_NUM_MASTER_SLOTS-1:0]                           M_AXI_BVALID,
   output wire [C_NUM_MASTER_SLOTS-1:0]                           M_AXI_BREADY,
   // Master Interface Read Address Port
   output wire [C_NUM_MASTER_SLOTS*C_AXI_ID_WIDTH-1:0]          M_AXI_ARID,
   output wire [C_NUM_MASTER_SLOTS*C_AXI_ADDR_WIDTH-1:0]          M_AXI_ARADDR,
   output wire [C_NUM_MASTER_SLOTS*8-1:0]                         M_AXI_ARLEN,
   output wire [C_NUM_MASTER_SLOTS*3-1:0]                         M_AXI_ARSIZE,
   output wire [C_NUM_MASTER_SLOTS*2-1:0]                         M_AXI_ARBURST,
   output wire [C_NUM_MASTER_SLOTS*2-1:0]                         M_AXI_ARLOCK,
   output wire [C_NUM_MASTER_SLOTS*4-1:0]                         M_AXI_ARCACHE,
   output wire [C_NUM_MASTER_SLOTS*3-1:0]                         M_AXI_ARPROT,
   output wire [C_NUM_MASTER_SLOTS*4-1:0]                         M_AXI_ARREGION,
   output wire [C_NUM_MASTER_SLOTS*4-1:0]                         M_AXI_ARQOS,
   output wire [C_NUM_MASTER_SLOTS*C_AXI_ARUSER_WIDTH-1:0]        M_AXI_ARUSER,
   output wire [C_NUM_MASTER_SLOTS-1:0]                           M_AXI_ARVALID,
   input  wire [C_NUM_MASTER_SLOTS-1:0]                           M_AXI_ARREADY,
   // Master Interface Read Data Ports
   input  wire [C_NUM_MASTER_SLOTS*C_AXI_ID_WIDTH-1:0]          M_AXI_RID,
   input  wire [C_NUM_MASTER_SLOTS*C_AXI_DATA_MAX_WIDTH-1:0]    M_AXI_RDATA,
   input  wire [C_NUM_MASTER_SLOTS*2-1:0]                         M_AXI_RRESP,
   input  wire [C_NUM_MASTER_SLOTS-1:0]                           M_AXI_RLAST,
   input wire [C_NUM_MASTER_SLOTS*C_AXI_RUSER_WIDTH-1:0]         M_AXI_RUSER,
   input  wire [C_NUM_MASTER_SLOTS-1:0]                           M_AXI_RVALID,
   output wire [C_NUM_MASTER_SLOTS-1:0]                           M_AXI_RREADY,
   // Diagnostic AxiLite Slave Interface
   input wire [(C_S_AXI_CTRL_ADDR_WIDTH-1):0]                     S_AXI_CTRL_AWADDR,
   input wire                                                     S_AXI_CTRL_AWVALID,
   output wire                                                    S_AXI_CTRL_AWREADY,
   input wire [(C_S_AXI_CTRL_DATA_WIDTH-1):0]                     S_AXI_CTRL_WDATA,
   input wire                                                     S_AXI_CTRL_WVALID,
   output wire                                                    S_AXI_CTRL_WREADY,
   output wire [1:0]                                              S_AXI_CTRL_BRESP,
   output wire                                                    S_AXI_CTRL_BVALID,
   input wire                                                     S_AXI_CTRL_BREADY,
   input wire [(C_S_AXI_CTRL_ADDR_WIDTH-1):0]                     S_AXI_CTRL_ARADDR,
   input wire                                                     S_AXI_CTRL_ARVALID,
   output wire                                                    S_AXI_CTRL_ARREADY,
   output wire [(C_S_AXI_CTRL_DATA_WIDTH-1):0]                    S_AXI_CTRL_RDATA,
   output wire [1:0]                                              S_AXI_CTRL_RRESP,
   output wire                                                    S_AXI_CTRL_RVALID,
   input wire                                                     S_AXI_CTRL_RREADY
   );
   
  localparam P_AXI4 = 32'h0;
  localparam P_AXI3 = 32'h1;
  localparam P_AXILITE = 32'h2;
  localparam P_ADDR_DECODE = C_RANGE_CHECK || (C_NUM_MASTER_SLOTS>1) || (f_num_addr_ranges(0)>1);
  localparam P_NUM_MASTER_SLOTS_LOG = f_ceil_log2(C_NUM_MASTER_SLOTS);
  localparam P_NUM_SLAVE_SLOTS_LOG = f_ceil_log2((C_NUM_SLAVE_SLOTS>1) ? C_NUM_SLAVE_SLOTS : 2);
  localparam P_ST_AWMESG_WIDTH = 2+4+4 + C_AXI_AWUSER_WIDTH;
  localparam P_AA_AWMESG_WIDTH = C_AXI_ID_WIDTH + C_AXI_ADDR_WIDTH + 8+3+2+3+4 + P_ST_AWMESG_WIDTH;
  localparam P_ST_ARMESG_WIDTH = 2+4+4 + C_AXI_ARUSER_WIDTH;
  localparam P_AA_ARMESG_WIDTH = C_AXI_ID_WIDTH + C_AXI_ADDR_WIDTH + 8+3+2+3+4 + P_ST_ARMESG_WIDTH;
  localparam P_ST_BMESG_WIDTH = 2 + C_AXI_BUSER_WIDTH;
  localparam P_ST_RMESG_WIDTH = 2 + C_AXI_RUSER_WIDTH + C_INTERCONNECT_DATA_WIDTH;
  localparam P_WR_WMESG_WIDTH = C_INTERCONNECT_DATA_WIDTH + C_INTERCONNECT_DATA_WIDTH/8 + C_AXI_WUSER_WIDTH;
  localparam P_BYPASS  = 32'h00000000;
  localparam P_FWD_REV = 32'h00000001;
  localparam P_SIMPLE  = 32'h00000007;
  localparam P_M_AXI_SUPPORTS_READ = {1'b1, C_M_AXI_SUPPORTS_READ[0+:C_NUM_MASTER_SLOTS]};
  localparam P_M_AXI_SUPPORTS_WRITE = {1'b1, C_M_AXI_SUPPORTS_WRITE[0+:C_NUM_MASTER_SLOTS]};
  localparam [17*32-1:0] P_SI_WRITE_CONNECTIVITY = P_ADDR_DECODE ? f_si_write_connectivity(0) : {17{32'hFFFFFFFF}};
  localparam [17*32-1:0] P_SI_READ_CONNECTIVITY = P_ADDR_DECODE ? f_si_read_connectivity(0) : {17{32'hFFFFFFFF}};
  localparam [16*32-1:0] P_MI_WRITE_CONNECTIVITY = P_ADDR_DECODE ? f_mi_write_connectivity(0) : {16{32'hFFFFFFFF}};
  localparam [16*32-1:0] P_MI_READ_CONNECTIVITY = P_ADDR_DECODE ? f_mi_read_connectivity(0) : {16{32'hFFFFFFFF}};

  //---------------------------------------------------------------------------
  // Functions
  //---------------------------------------------------------------------------
  // Ceiling of log2(x)
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

  // Isolate thread bits of input S_ID and add to BASE_ID (RNG00) to form MI-side ID value
  //   only for end-point SI-slots
  function [C_AXI_ID_WIDTH-1:0] f_extend_ID
    (
     input [C_AXI_ID_WIDTH-1:0] s_id,
     input integer slot
     );
    begin
      f_extend_ID = C_S_AXI_BASE_ID[slot*64+:C_AXI_ID_WIDTH] | (s_id & (C_S_AXI_BASE_ID[slot*64+:C_AXI_ID_WIDTH] ^ C_S_AXI_HIGH_ID[slot*64+:C_AXI_ID_WIDTH]));
    end
  endfunction

  // Connectivity array transposed and masked by MI write capability
  function [16*32-1:0] f_mi_write_connectivity
    (
      input integer null_arg
     );
    integer si_slot;
    integer mi_slot;
    reg  [16*32-1:0]  result;
    begin
      result = {16{32'hFFFFFFFF}};
      for (si_slot=0; si_slot<C_NUM_SLAVE_SLOTS; si_slot=si_slot+1) begin
        for (mi_slot=0; mi_slot<C_NUM_MASTER_SLOTS; mi_slot=mi_slot+1) begin
          result[si_slot*32+mi_slot] = C_AXI_CONNECTIVITY[mi_slot*32+si_slot] & C_M_AXI_SUPPORTS_WRITE[mi_slot];
        end
      end
    f_mi_write_connectivity = result;
    end
  endfunction

  // Connectivity array transposed and masked by MI read capability
  function [16*32-1:0] f_mi_read_connectivity
    (
      input integer null_arg
     );
    integer si_slot;
    integer mi_slot;
    reg  [16*32-1:0]  result;
    begin
      result = {16{32'hFFFFFFFF}};
      for (si_slot=0; si_slot<C_NUM_SLAVE_SLOTS; si_slot=si_slot+1) begin
        for (mi_slot=0; mi_slot<C_NUM_MASTER_SLOTS; mi_slot=mi_slot+1) begin
          result[si_slot*32+mi_slot] = C_AXI_CONNECTIVITY[mi_slot*32+si_slot] & C_M_AXI_SUPPORTS_READ[mi_slot];
        end
      end
    f_mi_read_connectivity = result;
    end
  endfunction

  // Connectivity array masked by SI write capability
  //   augmented with extra row for error handler with full connectivity
  function [17*32-1:0] f_si_write_connectivity
    (
      input integer null_arg
     );
    integer mi_slot;
    integer si;
    reg  [17*32-1:0]  result;
    begin
      result = {17{32'hFFFFFFFF}};
      for (mi_slot=0; mi_slot<C_NUM_MASTER_SLOTS; mi_slot=mi_slot+1) begin
        for (si=0; si<C_NUM_SLAVE_SLOTS; si=si+1) begin
          result[mi_slot*32+si] = C_AXI_CONNECTIVITY[mi_slot*32+si] & C_S_AXI_SUPPORTS_WRITE[si];
        end
      end
    f_si_write_connectivity = result;
    end
  endfunction

  // Connectivity array masked by SI read capability
  //   augmented with extra row for error handler with full connectivity
  function [17*32-1:0] f_si_read_connectivity
    (
      input integer null_arg
     );
    integer mi_slot;
    integer si;
    reg  [17*32-1:0]  result;
    begin
      result = {17{32'hFFFFFFFF}};
      for (mi_slot=0; mi_slot<C_NUM_MASTER_SLOTS; mi_slot=mi_slot+1) begin
        for (si=0; si<C_NUM_SLAVE_SLOTS; si=si+1) begin
          result[mi_slot*32+si] = C_AXI_CONNECTIVITY[mi_slot*32+si] & C_S_AXI_SUPPORTS_READ[si];
        end
      end
    f_si_read_connectivity = result;
    end
  endfunction

  // Count number of valid address ranges for MI-slot #0
  function integer f_num_addr_ranges
    (
      input integer null_arg
    );
    integer range_cnt;
    integer rng;
    integer rng_size;
    begin
      range_cnt = 0;
      for (rng=0; rng<C_NUM_ADDR_RANGES; rng=rng+1) begin
        range_cnt = range_cnt + (C_M_AXI_BASE_ADDR[rng*64+:C_AXI_ADDR_WIDTH] <= C_M_AXI_HIGH_ADDR[rng*64+:C_AXI_ADDR_WIDTH]);
      end
      f_num_addr_ranges = range_cnt;
    end
  endfunction
  
  genvar gen_si_slot;
  genvar gen_mi_slot;
  wire [C_NUM_SLAVE_SLOTS*P_ST_AWMESG_WIDTH-1:0]                  si_st_awmesg          ;
  wire [C_NUM_SLAVE_SLOTS*P_ST_AWMESG_WIDTH-1:0]                  st_tmp_awmesg         ;
  wire [C_NUM_SLAVE_SLOTS*P_AA_AWMESG_WIDTH-1:0]                  tmp_aa_awmesg         ;
  wire [P_AA_AWMESG_WIDTH-1:0]                                    aa_mi_awmesg          ;
  wire [C_NUM_SLAVE_SLOTS*C_AXI_ID_WIDTH-1:0]                     st_aa_awid            ;
  wire [C_NUM_SLAVE_SLOTS*C_AXI_ADDR_WIDTH-1:0]                   st_aa_awaddr          ;
  wire [C_NUM_SLAVE_SLOTS*8-1:0]                                  st_aa_awlen           ;
  wire [C_NUM_SLAVE_SLOTS*3-1:0]                                  st_aa_awsize          ;
  wire [C_NUM_SLAVE_SLOTS*2-1:0]                                  st_aa_awlock          ;
  wire [C_NUM_SLAVE_SLOTS*3-1:0]                                  st_aa_awprot          ;
  wire [C_NUM_SLAVE_SLOTS*4-1:0]                                  st_aa_awregion        ;
  wire [C_NUM_SLAVE_SLOTS*4-1:0]                                  st_aa_awerror         ;
  wire [C_NUM_SLAVE_SLOTS*(C_NUM_MASTER_SLOTS+1)-1:0]             st_aa_awtarget_hot    ;
  wire [C_NUM_SLAVE_SLOTS*(P_NUM_MASTER_SLOTS_LOG+1)-1:0]         st_aa_awtarget_enc    ;
  wire [P_NUM_SLAVE_SLOTS_LOG*1-1:0]                              aa_wm_awgrant_enc     ;
  wire [(C_NUM_MASTER_SLOTS+1)-1:0]                               aa_mi_awtarget_hot    ;
  wire [C_NUM_SLAVE_SLOTS*1-1:0]                                  st_aa_awvalid_qual    ;
  wire [C_NUM_SLAVE_SLOTS*1-1:0]                                  st_ss_awvalid         ;
  wire [C_NUM_SLAVE_SLOTS*1-1:0]                                  st_ss_awready         ;
  wire [C_NUM_SLAVE_SLOTS*1-1:0]                                  ss_wr_awvalid         ;
  wire [C_NUM_SLAVE_SLOTS*1-1:0]                                  ss_wr_awready         ;
  wire [C_NUM_SLAVE_SLOTS*1-1:0]                                  ss_aa_awvalid         ;
  wire [C_NUM_SLAVE_SLOTS*1-1:0]                                  ss_aa_awready         ;
  wire [(C_NUM_MASTER_SLOTS+1)*1-1:0]                             sa_wm_awvalid         ;
  wire [(C_NUM_MASTER_SLOTS+1)*1-1:0]                             sa_wm_awready         ;
  wire [(C_NUM_MASTER_SLOTS+1)*1-1:0]                             mi_awvalid            ;
  wire [(C_NUM_MASTER_SLOTS+1)*1-1:0]                             mi_awready            ;
  wire                                                            aa_sa_awvalid         ;
  wire                                                            aa_sa_awready         ;
  wire                                                            aa_mi_arready         ;
  wire                                                            mi_awvalid_en         ;
  wire                                                            sa_wm_awvalid_en      ;
  wire                                                            sa_wm_awready_mux     ;
  wire [C_NUM_SLAVE_SLOTS*P_ST_ARMESG_WIDTH-1:0]                  si_st_armesg          ;
  wire [C_NUM_SLAVE_SLOTS*P_ST_ARMESG_WIDTH-1:0]                  st_tmp_armesg         ;
  wire [C_NUM_SLAVE_SLOTS*P_AA_ARMESG_WIDTH-1:0]                  tmp_aa_armesg         ;
  wire [P_AA_ARMESG_WIDTH-1:0]                                    aa_mi_armesg          ;
  wire [C_NUM_SLAVE_SLOTS*C_AXI_ID_WIDTH-1:0]                     st_aa_arid            ;
  wire [C_NUM_SLAVE_SLOTS*C_AXI_ADDR_WIDTH-1:0]                   st_aa_araddr          ;
  wire [C_NUM_SLAVE_SLOTS*8-1:0]                                  st_aa_arlen           ;
  wire [C_NUM_SLAVE_SLOTS*3-1:0]                                  st_aa_arsize          ;
  wire [C_NUM_SLAVE_SLOTS*2-1:0]                                  st_aa_arlock          ;
  wire [C_NUM_SLAVE_SLOTS*3-1:0]                                  st_aa_arprot          ;
  wire [C_NUM_SLAVE_SLOTS*4-1:0]                                  st_aa_arregion        ;
  wire [C_NUM_SLAVE_SLOTS*4-1:0]                                  st_aa_arerror         ;
  wire [C_NUM_SLAVE_SLOTS*(C_NUM_MASTER_SLOTS+1)-1:0]             st_aa_artarget_hot    ;
  wire [(C_NUM_MASTER_SLOTS+1)-1:0]                               aa_mi_artarget_hot    ;
  wire [C_NUM_SLAVE_SLOTS*1-1:0]                                  st_aa_arvalid_qual    ;
  wire [C_NUM_SLAVE_SLOTS*1-1:0]                                  st_aa_arvalid         ;
  wire [C_NUM_SLAVE_SLOTS*1-1:0]                                  st_aa_arready         ;
  wire [(C_NUM_MASTER_SLOTS+1)*1-1:0]                             mi_arvalid            ;
  wire [(C_NUM_MASTER_SLOTS+1)*1-1:0]                             mi_arready            ;
  wire                                                            aa_mi_arvalid         ;
  wire                                                            mi_awready_mux        ;
  wire [C_NUM_SLAVE_SLOTS*P_ST_BMESG_WIDTH-1:0]                   st_si_bmesg           ;
  wire [(C_NUM_MASTER_SLOTS+1)*P_ST_BMESG_WIDTH-1:0]              st_mr_bmesg           ;
  wire [(C_NUM_MASTER_SLOTS+1)*C_AXI_ID_WIDTH-1:0]                st_mr_bid             ;
  wire [(C_NUM_MASTER_SLOTS+1)*2-1:0]                             st_mr_bresp           ;
  wire [(C_NUM_MASTER_SLOTS+1)*C_AXI_BUSER_WIDTH-1:0]             st_mr_buser           ;
  wire [(C_NUM_MASTER_SLOTS+1)*1-1:0]                             st_mr_bvalid          ;
  wire [(C_NUM_MASTER_SLOTS+1)*1-1:0]                             st_mr_bready          ;
  wire [C_NUM_SLAVE_SLOTS*(C_NUM_MASTER_SLOTS+1)-1:0]             st_tmp_bready         ;
  wire [C_NUM_SLAVE_SLOTS*(C_NUM_MASTER_SLOTS+1)-1:0]             st_tmp_bid_target     ;
  wire [(C_NUM_MASTER_SLOTS+1)*C_NUM_SLAVE_SLOTS-1:0]             tmp_mr_bid_target     ;
  wire [(C_NUM_MASTER_SLOTS+1)*1-1:0]                             bid_match             ;
  wire [(C_NUM_MASTER_SLOTS+1)*C_AXI_ID_WIDTH-1:0]                mi_bid                ;
  wire [(C_NUM_MASTER_SLOTS+1)*2-1:0]                             mi_bresp              ;
  wire [(C_NUM_MASTER_SLOTS+1)*C_AXI_BUSER_WIDTH-1:0]             mi_buser              ;
  wire [(C_NUM_MASTER_SLOTS+1)*1-1:0]                             mi_bvalid             ;
  wire [(C_NUM_MASTER_SLOTS+1)*1-1:0]                             mi_bready             ;
  wire [C_NUM_SLAVE_SLOTS*(C_NUM_MASTER_SLOTS+1)-1:0]             bready_carry          ;
  wire [C_NUM_SLAVE_SLOTS*P_ST_RMESG_WIDTH-1:0]                   st_si_rmesg           ;
  wire [(C_NUM_MASTER_SLOTS+1)*P_ST_RMESG_WIDTH-1:0]              st_mr_rmesg           ;
  wire [(C_NUM_MASTER_SLOTS+1)*C_AXI_ID_WIDTH-1:0]                st_mr_rid             ;
  wire [(C_NUM_MASTER_SLOTS+1)*C_INTERCONNECT_DATA_WIDTH-1:0]     st_mr_rdata           ;
  wire [(C_NUM_MASTER_SLOTS+1)*C_AXI_RUSER_WIDTH-1:0]             st_mr_ruser           ;
  wire [(C_NUM_MASTER_SLOTS+1)*1-1:0]                             st_mr_rlast           ;
  wire [(C_NUM_MASTER_SLOTS+1)*2-1:0]                             st_mr_rresp           ;
  wire [(C_NUM_MASTER_SLOTS+1)*1-1:0]                             st_mr_rvalid          ;
  wire [(C_NUM_MASTER_SLOTS+1)*1-1:0]                             st_mr_rready          ;
  wire [C_NUM_SLAVE_SLOTS*(C_NUM_MASTER_SLOTS+1)-1:0]             st_tmp_rready         ;
  wire [C_NUM_SLAVE_SLOTS*(C_NUM_MASTER_SLOTS+1)-1:0]             st_tmp_rid_target     ;
  wire [(C_NUM_MASTER_SLOTS+1)*C_NUM_SLAVE_SLOTS-1:0]             tmp_mr_rid_target     ;
  wire [(C_NUM_MASTER_SLOTS+1)*1-1:0]                             rid_match             ;
  wire [(C_NUM_MASTER_SLOTS+1)*C_AXI_ID_WIDTH-1:0]                mi_rid                ;
  wire [(C_NUM_MASTER_SLOTS+1)*C_AXI_DATA_MAX_WIDTH-1:0]          mi_rdata              ;
  wire [(C_NUM_MASTER_SLOTS+1)*C_AXI_RUSER_WIDTH-1:0]             mi_ruser              ;
  wire [(C_NUM_MASTER_SLOTS+1)*1-1:0]                             mi_rlast              ;
  wire [(C_NUM_MASTER_SLOTS+1)*2-1:0]                             mi_rresp              ;
  wire [(C_NUM_MASTER_SLOTS+1)*1-1:0]                             mi_rvalid             ;
  wire [(C_NUM_MASTER_SLOTS+1)*1-1:0]                             mi_rready             ;
  wire [C_NUM_SLAVE_SLOTS*(C_NUM_MASTER_SLOTS+1)-1:0]             rready_carry          ;
  wire [C_NUM_SLAVE_SLOTS*P_WR_WMESG_WIDTH-1:0]                   si_wr_wmesg           ;
  wire [C_NUM_SLAVE_SLOTS*P_WR_WMESG_WIDTH-1:0]                   wr_wm_wmesg           ;
  wire [C_NUM_SLAVE_SLOTS*1-1:0]                                  wr_wm_wlast           ;
  wire [C_NUM_SLAVE_SLOTS*(C_NUM_MASTER_SLOTS+1)-1:0]             wr_tmp_wvalid         ;
  wire [C_NUM_SLAVE_SLOTS*(C_NUM_MASTER_SLOTS+1)-1:0]             wr_tmp_wready         ;
  wire [(C_NUM_MASTER_SLOTS+1)*C_NUM_SLAVE_SLOTS-1:0]             tmp_wm_wvalid         ;
  wire [(C_NUM_MASTER_SLOTS+1)*C_NUM_SLAVE_SLOTS-1:0]             tmp_wm_wready         ;
  wire [(C_NUM_MASTER_SLOTS+1)*P_WR_WMESG_WIDTH-1:0]              wm_mr_wmesg              ;
  wire [(C_NUM_MASTER_SLOTS+1)*C_INTERCONNECT_DATA_WIDTH-1:0]          wm_mr_wdata              ;
  wire [(C_NUM_MASTER_SLOTS+1)*C_INTERCONNECT_DATA_WIDTH/8-1:0]        wm_mr_wstrb              ;
  wire [(C_NUM_MASTER_SLOTS+1)*C_AXI_WUSER_WIDTH-1:0]             wm_mr_wuser              ;
  wire [(C_NUM_MASTER_SLOTS+1)*1-1:0]                             wm_mr_wlast              ;
  wire [(C_NUM_MASTER_SLOTS+1)*1-1:0]                             wm_mr_wvalid             ;
  wire [(C_NUM_MASTER_SLOTS+1)*1-1:0]                             wm_mr_wready             ;
  wire [(C_NUM_MASTER_SLOTS+1)*C_INTERCONNECT_DATA_WIDTH-1:0]          mi_wdata              ;
  wire [(C_NUM_MASTER_SLOTS+1)*C_INTERCONNECT_DATA_WIDTH/8-1:0]        mi_wstrb              ;
  wire [(C_NUM_MASTER_SLOTS+1)*C_AXI_WUSER_WIDTH-1:0]             mi_wuser              ;
  wire [(C_NUM_MASTER_SLOTS+1)*1-1:0]                             mi_wlast              ;
  wire [(C_NUM_MASTER_SLOTS+1)*1-1:0]                             mi_wvalid             ;
  wire [(C_NUM_MASTER_SLOTS+1)*1-1:0]                             mi_wready             ;
  wire [(C_NUM_MASTER_SLOTS+1)*1-1:0]                             w_cmd_push            ;
  wire [(C_NUM_MASTER_SLOTS+1)*1-1:0]                             w_cmd_pop             ;
  wire [(C_NUM_MASTER_SLOTS+1)*1-1:0]                             r_cmd_push            ;
  wire [(C_NUM_MASTER_SLOTS+1)*1-1:0]                             r_cmd_pop             ;
  wire [(C_NUM_MASTER_SLOTS+1)*1-1:0]                             mi_awmaxissuance      ;
  wire [(C_NUM_MASTER_SLOTS+1)*1-1:0]                             mi_armaxissuance      ;
  reg  [(C_NUM_MASTER_SLOTS+1)*8-1:0]                             w_issuance_cnt        ;
  reg  [(C_NUM_MASTER_SLOTS+1)*8-1:0]                             r_issuance_cnt        ;
  reg  [8-1:0]                                                    debug_aw_trans_seq    ;
  reg  [8-1:0]                                                    debug_ar_trans_seq    ;
  wire [(C_NUM_MASTER_SLOTS+1)*8-1:0]                             debug_w_trans_seq     ;
  reg  [(C_NUM_MASTER_SLOTS+1)*8-1:0]                             debug_w_beat_cnt      ;

  wire reset;
  assign reset = ~ARESETN;

generate
  if ((C_NUM_MASTER_SLOTS==1) && (C_NUM_SLAVE_SLOTS==1) && (P_ADDR_DECODE==0)) begin : gen_passthru
      
    assign M_AXI_AWID[0+:C_AXI_ID_WIDTH]                = f_extend_ID(S_AXI_AWID[0+:C_AXI_ID_WIDTH], 0);
    assign M_AXI_AWADDR[0+:C_AXI_ADDR_WIDTH]            = S_AXI_AWADDR[0+:C_AXI_ADDR_WIDTH];
    assign M_AXI_AWLEN[0+:8]                            = S_AXI_AWLEN[0+:8];
    assign M_AXI_AWSIZE[0+:3]                           = S_AXI_AWSIZE[0+:3];
    assign M_AXI_AWBURST[0+:2]                          = S_AXI_AWBURST[0+:2];
    assign M_AXI_AWLOCK[0+:2]                           = S_AXI_AWLOCK[0+:2];
    assign M_AXI_AWCACHE[0+:4]                          = S_AXI_AWCACHE[0+:4];
    assign M_AXI_AWPROT[0+:3]                           = S_AXI_AWPROT[0+:3];
    assign M_AXI_AWREGION[0+:4]                         = 4'b0;
    assign M_AXI_AWQOS[0+:4]                            = S_AXI_AWQOS[0+:4];
    assign M_AXI_AWUSER[0+:C_AXI_AWUSER_WIDTH]          = S_AXI_AWUSER[0+:C_AXI_AWUSER_WIDTH];
    assign M_AXI_AWVALID[0+:1]                          = S_AXI_AWVALID[0+:1];
    assign S_AXI_AWREADY[0+:1]                          = M_AXI_AWREADY[0+:1];
    assign M_AXI_WDATA[0+:C_AXI_DATA_MAX_WIDTH]         = S_AXI_WDATA[0+:C_AXI_DATA_MAX_WIDTH];
    assign M_AXI_WSTRB[0+:C_AXI_DATA_MAX_WIDTH/8]       = S_AXI_WSTRB[0+:C_AXI_DATA_MAX_WIDTH/8];
    assign M_AXI_WLAST[0+:1]                            = S_AXI_WLAST[0+:1];
    assign M_AXI_WUSER[0+:C_AXI_WUSER_WIDTH]            = S_AXI_WUSER[0+:C_AXI_WUSER_WIDTH];
    assign M_AXI_WVALID[0+:1]                           = S_AXI_WVALID[0+:1];
    assign S_AXI_WREADY[0+:1]                           = M_AXI_WREADY[0+:1];
    assign S_AXI_BID[0+:C_AXI_ID_WIDTH]                 = M_AXI_BID[0+:C_AXI_ID_WIDTH];
    assign S_AXI_BRESP[0+:2]                            = M_AXI_BRESP[0+:2];
    assign S_AXI_BUSER[0+:C_AXI_BUSER_WIDTH]            = M_AXI_BUSER[0+:C_AXI_BUSER_WIDTH];
    assign S_AXI_BVALID[0+:1]                           = M_AXI_BVALID[0+:1];
    assign M_AXI_BREADY[0+:1]                           = S_AXI_BREADY[0+:1];
    assign M_AXI_ARID[0+:C_AXI_ID_WIDTH]                = f_extend_ID(S_AXI_ARID[0+:C_AXI_ID_WIDTH], 0);
    assign M_AXI_ARADDR[0+:C_AXI_ADDR_WIDTH]            = S_AXI_ARADDR[0+:C_AXI_ADDR_WIDTH];
    assign M_AXI_ARLEN[0+:8]                            = S_AXI_ARLEN[0+:8];
    assign M_AXI_ARSIZE[0+:3]                           = S_AXI_ARSIZE[0+:3];
    assign M_AXI_ARBURST[0+:2]                          = S_AXI_ARBURST[0+:2];
    assign M_AXI_ARLOCK[0+:2]                           = S_AXI_ARLOCK[0+:2];
    assign M_AXI_ARCACHE[0+:4]                          = S_AXI_ARCACHE[0+:4];
    assign M_AXI_ARPROT[0+:3]                           = S_AXI_ARPROT[0+:3];
    assign M_AXI_ARREGION[0+:4]                         = 4'b0;
    assign M_AXI_ARQOS[0+:4]                            = S_AXI_ARQOS[0+:4];
    assign M_AXI_ARUSER[0+:C_AXI_ARUSER_WIDTH]          = S_AXI_ARUSER[0+:C_AXI_ARUSER_WIDTH];
    assign M_AXI_ARVALID[0+:1]                          = S_AXI_ARVALID[0+:1];
    assign S_AXI_ARREADY[0+:1]                          = M_AXI_ARREADY[0+:1];
    assign S_AXI_RID[0+:C_AXI_ID_WIDTH]                 = M_AXI_RID[0+:C_AXI_ID_WIDTH];
    assign S_AXI_RDATA[0+:C_AXI_DATA_MAX_WIDTH]         = M_AXI_RDATA[0+:C_AXI_DATA_MAX_WIDTH];
    assign S_AXI_RRESP[0+:2]                            = M_AXI_RRESP[0+:2];
    assign S_AXI_RLAST[0+:1]                            = M_AXI_RLAST[0+:1];
    assign S_AXI_RUSER[0+:C_AXI_RUSER_WIDTH]            = M_AXI_RUSER[0+:C_AXI_RUSER_WIDTH];
    assign S_AXI_RVALID[0+:1]                           = M_AXI_RVALID[0+:1];
    assign M_AXI_RREADY[0+:1]                           = S_AXI_RREADY[0+:1];
    
  end else begin : gen_crossbar
    
    for (gen_si_slot=0; gen_si_slot<C_NUM_SLAVE_SLOTS; gen_si_slot=gen_si_slot+1) begin : gen_slave_slots
      if (C_S_AXI_SUPPORTS_READ[gen_si_slot]) begin : gen_si_read
        si_transactor #  // "ST": SI Transactor (read channel)
          (
           .C_FAMILY                (C_FAMILY),
           .C_SI                    (gen_si_slot),
           .C_NUM_M                 (C_NUM_MASTER_SLOTS),
           .C_NUM_M_LOG             (P_NUM_MASTER_SLOTS_LOG),
           .C_ACCEPTANCE_LOG        (C_R_ACCEPT_WIDTH[gen_si_slot*32+:6]),
           .C_ID_WIDTH              (C_AXI_ID_WIDTH),
           .C_ADDR_WIDTH            (C_AXI_ADDR_WIDTH),
           .C_AMESG_WIDTH           (P_ST_ARMESG_WIDTH),
           .C_RMESG_WIDTH           (P_ST_RMESG_WIDTH),
           .C_NUM_ADDR_RANGES       (C_NUM_ADDR_RANGES),
           .C_BASE_ID               (C_S_AXI_BASE_ID[gen_si_slot*64+:64]),
           .C_HIGH_ID               (C_S_AXI_HIGH_ID[gen_si_slot*64+:64]),
           .C_IS_INTERCONNECT       (C_S_AXI_IS_INTERCONNECT[gen_si_slot]),
           .C_SINGLE_THREAD         (C_S_AXI_SINGLE_THREAD[gen_si_slot]),
           .C_M_PROTOCOL            (C_M_AXI_PROTOCOL),
           .C_BASE_ADDR             (C_M_AXI_BASE_ADDR),
           .C_HIGH_ADDR             (C_M_AXI_HIGH_ADDR),
           .C_TARGET_QUAL           (P_MI_READ_CONNECTIVITY[gen_si_slot*32+:32]),
           .C_M_AXI_SECURE          (C_M_AXI_SECURE),
           .C_RANGE_CHECK           (C_RANGE_CHECK),
           .C_ADDR_DECODE           (P_ADDR_DECODE),
           .C_DEBUG                 (C_DEBUG)
           )
          si_transactor_ar
            (
             .ACLK                  (INTERCONNECT_ACLK),
             .ARESET                (reset),
             .S_AID                 (f_extend_ID(S_AXI_ARID[gen_si_slot*C_AXI_ID_WIDTH+:C_AXI_ID_WIDTH], gen_si_slot)),
             .S_AADDR               (S_AXI_ARADDR[gen_si_slot*C_AXI_ADDR_WIDTH+:C_AXI_ADDR_WIDTH]),
             .S_ALEN                (S_AXI_ARLEN[gen_si_slot*8+:8]),
             .S_ASIZE               (S_AXI_ARSIZE[gen_si_slot*3+:3]),
             .S_ABURST              (S_AXI_ARBURST[gen_si_slot*2+:2]),
             .S_ALOCK               (S_AXI_ARLOCK[gen_si_slot*2+:2]),
             .S_APROT               (S_AXI_ARPROT[gen_si_slot*3+:3]),
             .S_AMESG               (si_st_armesg[gen_si_slot*P_ST_ARMESG_WIDTH+:P_ST_ARMESG_WIDTH]),
             .S_AVALID              (S_AXI_ARVALID[gen_si_slot]),
             .S_AREADY              (S_AXI_ARREADY[gen_si_slot]),
             .M_AID                 (st_aa_arid[gen_si_slot*C_AXI_ID_WIDTH+:C_AXI_ID_WIDTH]),
             .M_AADDR               (st_aa_araddr[gen_si_slot*C_AXI_ADDR_WIDTH+:C_AXI_ADDR_WIDTH]),
             .M_ALEN                (st_aa_arlen[gen_si_slot*8+:8]),
             .M_ASIZE               (st_aa_arsize[gen_si_slot*3+:3]),
             .M_ALOCK               (st_aa_arlock[gen_si_slot*2+:2]),
             .M_APROT               (st_aa_arprot[gen_si_slot*3+:3]),
             .M_AREGION             (st_aa_arregion[gen_si_slot*4+:4]),
             .M_AMESG               (st_tmp_armesg[gen_si_slot*P_ST_ARMESG_WIDTH+:P_ST_ARMESG_WIDTH]),
             .M_ATARGET_HOT         (st_aa_artarget_hot[gen_si_slot*(C_NUM_MASTER_SLOTS+1)+:(C_NUM_MASTER_SLOTS+1)]),
             .M_ATARGET_ENC         (),
             .M_AERROR              (st_aa_arerror[gen_si_slot*4+:4]),
             .M_AVALID_QUAL         (st_aa_arvalid_qual[gen_si_slot]),
             .M_AVALID              (st_aa_arvalid[gen_si_slot]),
             .M_AREADY              (st_aa_arready[gen_si_slot]),
             .S_RID                 (S_AXI_RID[gen_si_slot*C_AXI_ID_WIDTH+:C_AXI_ID_WIDTH]),
             .S_RMESG               (st_si_rmesg[gen_si_slot*P_ST_RMESG_WIDTH+:P_ST_RMESG_WIDTH]),
             .S_RLAST               (S_AXI_RLAST[gen_si_slot]),
             .S_RVALID              (S_AXI_RVALID[gen_si_slot]),
             .S_RREADY              (S_AXI_RREADY[gen_si_slot]),
             .M_RID                 (st_mr_rid),
             .M_RLAST               (st_mr_rlast),
             .M_RMESG               (st_mr_rmesg),
             .M_RVALID              (st_mr_rvalid),
             .M_RREADY              (st_tmp_rready[gen_si_slot*(C_NUM_MASTER_SLOTS+1)+:(C_NUM_MASTER_SLOTS+1)]),
             .M_RTARGET             (st_tmp_rid_target[gen_si_slot*(C_NUM_MASTER_SLOTS+1)+:(C_NUM_MASTER_SLOTS+1)]),
             .DEBUG_TRANS_SEQ       (C_DEBUG ? debug_ar_trans_seq : 8'h0)
             );
        
        assign si_st_armesg[gen_si_slot*P_ST_ARMESG_WIDTH+:P_ST_ARMESG_WIDTH] = {
          S_AXI_ARUSER[gen_si_slot*C_AXI_ARUSER_WIDTH+:C_AXI_ARUSER_WIDTH],
          S_AXI_ARQOS[gen_si_slot*4+:4],
          S_AXI_ARCACHE[gen_si_slot*4+:4],
          S_AXI_ARBURST[gen_si_slot*2+:2]
          };
        assign tmp_aa_armesg[gen_si_slot*P_AA_ARMESG_WIDTH+:P_AA_ARMESG_WIDTH] = {
          st_tmp_armesg[gen_si_slot*P_ST_ARMESG_WIDTH+:P_ST_ARMESG_WIDTH],
          st_aa_arregion[gen_si_slot*4+:4],
          st_aa_arprot[gen_si_slot*3+:3],
          st_aa_arlock[gen_si_slot*2+:2],
          st_aa_arsize[gen_si_slot*3+:3],
          st_aa_arlen[gen_si_slot*8+:8],
          st_aa_araddr[gen_si_slot*C_AXI_ADDR_WIDTH+:C_AXI_ADDR_WIDTH],
          st_aa_arid[gen_si_slot*C_AXI_ID_WIDTH+:C_AXI_ID_WIDTH]
          };
        assign S_AXI_RRESP[gen_si_slot*2+:2] = st_si_rmesg[gen_si_slot*P_ST_RMESG_WIDTH+:2];
        assign S_AXI_RUSER[gen_si_slot*C_AXI_RUSER_WIDTH+:C_AXI_RUSER_WIDTH] = st_si_rmesg[gen_si_slot*P_ST_RMESG_WIDTH+2 +: C_AXI_RUSER_WIDTH];
        assign S_AXI_RDATA[gen_si_slot*C_AXI_DATA_MAX_WIDTH+:C_AXI_DATA_MAX_WIDTH] = st_si_rmesg[gen_si_slot*P_ST_RMESG_WIDTH+2+C_AXI_RUSER_WIDTH +: C_INTERCONNECT_DATA_WIDTH];
      end else begin : gen_no_si_read
        assign S_AXI_ARREADY[gen_si_slot] = 1'b0;
        assign st_aa_arvalid[gen_si_slot] = 1'b0;
        assign st_aa_arvalid_qual[gen_si_slot] = 1'b1;
        assign tmp_aa_armesg[gen_si_slot*P_AA_ARMESG_WIDTH+:P_AA_ARMESG_WIDTH] = 0;
        assign S_AXI_RRESP[gen_si_slot*2+:2] = 0;
        assign S_AXI_RUSER[gen_si_slot*C_AXI_RUSER_WIDTH+:C_AXI_RUSER_WIDTH] = 0;
        assign S_AXI_RDATA[gen_si_slot*C_AXI_DATA_MAX_WIDTH+:C_AXI_DATA_MAX_WIDTH] = 0;
        assign S_AXI_RVALID[gen_si_slot] = 1'b0;
        assign st_tmp_rready[gen_si_slot*(C_NUM_MASTER_SLOTS+1)+:(C_NUM_MASTER_SLOTS+1)] = 0;
        assign st_aa_artarget_hot[gen_si_slot*(C_NUM_MASTER_SLOTS+1)+:(C_NUM_MASTER_SLOTS+1)] = 0;
      end  // gen_si_read
        
      if (C_S_AXI_SUPPORTS_WRITE[gen_si_slot]) begin : gen_si_write
        si_transactor #  // "ST": SI Transactor (write channel)
          (
           .C_FAMILY                (C_FAMILY),
           .C_SI                    (gen_si_slot),
           .C_NUM_M                 (C_NUM_MASTER_SLOTS),
           .C_NUM_M_LOG             (P_NUM_MASTER_SLOTS_LOG),
           .C_ACCEPTANCE_LOG        (C_W_ACCEPT_WIDTH[gen_si_slot*32+:6]),
           .C_ID_WIDTH              (C_AXI_ID_WIDTH),
           .C_ADDR_WIDTH            (C_AXI_ADDR_WIDTH),
           .C_AMESG_WIDTH           (P_ST_AWMESG_WIDTH),
           .C_RMESG_WIDTH           (P_ST_BMESG_WIDTH),
           .C_NUM_ADDR_RANGES       (C_NUM_ADDR_RANGES),
           .C_BASE_ID               (C_S_AXI_BASE_ID[gen_si_slot*64+:64]),
           .C_HIGH_ID               (C_S_AXI_HIGH_ID[gen_si_slot*64+:64]),
           .C_IS_INTERCONNECT       (C_S_AXI_IS_INTERCONNECT[gen_si_slot]),
           .C_SINGLE_THREAD         (C_S_AXI_SINGLE_THREAD[gen_si_slot]),
           .C_M_PROTOCOL            (C_M_AXI_PROTOCOL),
           .C_BASE_ADDR             (C_M_AXI_BASE_ADDR),
           .C_HIGH_ADDR             (C_M_AXI_HIGH_ADDR),
           .C_TARGET_QUAL           (P_MI_WRITE_CONNECTIVITY[gen_si_slot*32+:32]),
           .C_M_AXI_SECURE          (C_M_AXI_SECURE),
           .C_RANGE_CHECK           (C_RANGE_CHECK),
           .C_ADDR_DECODE           (P_ADDR_DECODE),
           .C_DEBUG                 (0)
           )
          si_transactor_aw
            (
             .ACLK                  (INTERCONNECT_ACLK),
             .ARESET                (reset),
             .S_AID                 (f_extend_ID(S_AXI_AWID[gen_si_slot*C_AXI_ID_WIDTH+:C_AXI_ID_WIDTH], gen_si_slot)),
             .S_AADDR               (S_AXI_AWADDR[gen_si_slot*C_AXI_ADDR_WIDTH+:C_AXI_ADDR_WIDTH]),
             .S_ALEN                (S_AXI_AWLEN[gen_si_slot*8+:8]),
             .S_ASIZE               (S_AXI_AWSIZE[gen_si_slot*3+:3]),
             .S_ABURST              (S_AXI_AWBURST[gen_si_slot*2+:2]),
             .S_ALOCK               (S_AXI_AWLOCK[gen_si_slot*2+:2]),
             .S_APROT               (S_AXI_AWPROT[gen_si_slot*3+:3]),
             .S_AMESG               (si_st_awmesg[gen_si_slot*P_ST_AWMESG_WIDTH+:P_ST_AWMESG_WIDTH]),
             .S_AVALID              (S_AXI_AWVALID[gen_si_slot]),
             .S_AREADY              (S_AXI_AWREADY[gen_si_slot]),
             .M_AID                 (st_aa_awid[gen_si_slot*C_AXI_ID_WIDTH+:C_AXI_ID_WIDTH]),
             .M_AADDR               (st_aa_awaddr[gen_si_slot*C_AXI_ADDR_WIDTH+:C_AXI_ADDR_WIDTH]),
             .M_ALEN                (st_aa_awlen[gen_si_slot*8+:8]),
             .M_ASIZE               (st_aa_awsize[gen_si_slot*3+:3]),
             .M_ALOCK               (st_aa_awlock[gen_si_slot*2+:2]),
             .M_APROT               (st_aa_awprot[gen_si_slot*3+:3]),
             .M_AREGION             (st_aa_awregion[gen_si_slot*4+:4]),
             .M_AMESG               (st_tmp_awmesg[gen_si_slot*P_ST_AWMESG_WIDTH+:P_ST_AWMESG_WIDTH]),
             .M_ATARGET_HOT         (st_aa_awtarget_hot[gen_si_slot*(C_NUM_MASTER_SLOTS+1)+:(C_NUM_MASTER_SLOTS+1)]),
             .M_ATARGET_ENC         (st_aa_awtarget_enc[gen_si_slot*(P_NUM_MASTER_SLOTS_LOG+1)+:(P_NUM_MASTER_SLOTS_LOG+1)]),
             .M_AERROR              (st_aa_awerror[gen_si_slot*4+:4]),
             .M_AVALID_QUAL         (st_aa_awvalid_qual[gen_si_slot]),
             .M_AVALID              (st_ss_awvalid[gen_si_slot]),
             .M_AREADY              (st_ss_awready[gen_si_slot]),
             .S_RID                 (S_AXI_BID[gen_si_slot*C_AXI_ID_WIDTH+:C_AXI_ID_WIDTH]),
             .S_RMESG               (st_si_bmesg[gen_si_slot*P_ST_BMESG_WIDTH+:P_ST_BMESG_WIDTH]),
             .S_RLAST               (),
             .S_RVALID              (S_AXI_BVALID[gen_si_slot]),
             .S_RREADY              (S_AXI_BREADY[gen_si_slot]),
             .M_RID                 (st_mr_bid),
             .M_RLAST               ({(C_NUM_MASTER_SLOTS+1){1'b1}}),
             .M_RMESG               (st_mr_bmesg),
             .M_RVALID              (st_mr_bvalid),
             .M_RREADY              (st_tmp_bready[gen_si_slot*(C_NUM_MASTER_SLOTS+1)+:(C_NUM_MASTER_SLOTS+1)]),
             .M_RTARGET             (st_tmp_bid_target[gen_si_slot*(C_NUM_MASTER_SLOTS+1)+:(C_NUM_MASTER_SLOTS+1)]),
             .DEBUG_TRANS_SEQ       (8'h0)
             );
        
        // Note: Concatenation of mesg signals is from MSB to LSB; assignments that chop mesg signals appear in opposite order.
        assign si_st_awmesg[gen_si_slot*P_ST_AWMESG_WIDTH+:P_ST_AWMESG_WIDTH] = {
          S_AXI_AWUSER[gen_si_slot*C_AXI_AWUSER_WIDTH+:C_AXI_AWUSER_WIDTH],
          S_AXI_AWQOS[gen_si_slot*4+:4],
          S_AXI_AWCACHE[gen_si_slot*4+:4],
          S_AXI_AWBURST[gen_si_slot*2+:2]
          };
        assign tmp_aa_awmesg[gen_si_slot*P_AA_AWMESG_WIDTH+:P_AA_AWMESG_WIDTH] = {
          st_tmp_awmesg[gen_si_slot*P_ST_AWMESG_WIDTH+:P_ST_AWMESG_WIDTH],
          st_aa_awregion[gen_si_slot*4+:4],
          st_aa_awprot[gen_si_slot*3+:3],
          st_aa_awlock[gen_si_slot*2+:2],
          st_aa_awsize[gen_si_slot*3+:3],
          st_aa_awlen[gen_si_slot*8+:8],
          st_aa_awaddr[gen_si_slot*C_AXI_ADDR_WIDTH+:C_AXI_ADDR_WIDTH],
          st_aa_awid[gen_si_slot*C_AXI_ID_WIDTH+:C_AXI_ID_WIDTH]
          };
        assign S_AXI_BRESP[gen_si_slot*2+:2] = st_si_bmesg[gen_si_slot*P_ST_BMESG_WIDTH+:2];
        assign S_AXI_BUSER[gen_si_slot*C_AXI_BUSER_WIDTH+:C_AXI_BUSER_WIDTH] = st_si_bmesg[gen_si_slot*P_ST_BMESG_WIDTH+2 +: C_AXI_BUSER_WIDTH];
                       
        // AW SI-transactor transfer completes upon completion of both W-router address acceptance (command push) and AW arbitration
        splitter #  // "SS": Splitter from SI-Transactor (write channel)
          (
            .C_NUM_M                (2)
          )
          splitter_aw_si
          (
             .ACLK                  (INTERCONNECT_ACLK),
             .ARESET                (reset),
             .S_VALID              (st_ss_awvalid[gen_si_slot]),
             .S_READY              (st_ss_awready[gen_si_slot]),
             .M_VALID              ({ss_wr_awvalid[gen_si_slot], ss_aa_awvalid[gen_si_slot]}),
             .M_READY              ({ss_wr_awready[gen_si_slot], ss_aa_awready[gen_si_slot]})
          );
      
        wdata_router #  // "WR": Write data Router
          (
           .C_FAMILY                   (C_FAMILY),
           .C_NUM_MASTER_SLOTS         (C_NUM_MASTER_SLOTS+1),
           .C_SELECT_WIDTH             (P_NUM_MASTER_SLOTS_LOG+1),
           .C_WMESG_WIDTH               (P_WR_WMESG_WIDTH),
           .C_FIFO_DEPTH_LOG           (C_W_ACCEPT_WIDTH[gen_si_slot*32+:6])
           )
          wdata_router_w
            (
             .ACLK    (INTERCONNECT_ACLK),
             .ARESET  (reset),
             // Write transfer input from the current SI-slot
             .S_WMESG  (si_wr_wmesg[gen_si_slot*P_WR_WMESG_WIDTH+:P_WR_WMESG_WIDTH]),
             .S_WLAST  (S_AXI_WLAST[gen_si_slot]),
             .S_WVALID (S_AXI_WVALID[gen_si_slot]),
             .S_WREADY (S_AXI_WREADY[gen_si_slot]),
             // Vector of write transfer outputs to each MI-slot's W-mux
             .M_WMESG  (wr_wm_wmesg[gen_si_slot*(P_WR_WMESG_WIDTH)+:P_WR_WMESG_WIDTH]),
             .M_WLAST  (wr_wm_wlast[gen_si_slot]),
             .M_WVALID (wr_tmp_wvalid[gen_si_slot*(C_NUM_MASTER_SLOTS+1)+:(C_NUM_MASTER_SLOTS+1)]),
             .M_WREADY (wr_tmp_wready[gen_si_slot*(C_NUM_MASTER_SLOTS+1)+:(C_NUM_MASTER_SLOTS+1)]),
             // AW command push from local SI-slot
             .S_ASELECT (st_aa_awtarget_enc[gen_si_slot*(P_NUM_MASTER_SLOTS_LOG+1)+:(P_NUM_MASTER_SLOTS_LOG+1)]),  // Target MI-slot
             .S_AVALID  (ss_wr_awvalid[gen_si_slot]),
             .S_AREADY  (ss_wr_awready[gen_si_slot])
             );
             
        assign si_wr_wmesg[gen_si_slot*P_WR_WMESG_WIDTH+:P_WR_WMESG_WIDTH] = {
          S_AXI_WUSER[gen_si_slot*C_AXI_WUSER_WIDTH+:C_AXI_WUSER_WIDTH],
          S_AXI_WSTRB[gen_si_slot*C_AXI_DATA_MAX_WIDTH/8+:C_INTERCONNECT_DATA_WIDTH/8],
          S_AXI_WDATA[gen_si_slot*C_AXI_DATA_MAX_WIDTH+:C_INTERCONNECT_DATA_WIDTH]
        };        
      end else begin : gen_no_si_write
        assign S_AXI_AWREADY[gen_si_slot] = 1'b0;
        assign ss_aa_awvalid[gen_si_slot] = 1'b0;
        assign st_aa_awvalid_qual[gen_si_slot] = 1'b1;
        assign tmp_aa_awmesg[gen_si_slot*P_AA_AWMESG_WIDTH+:P_AA_AWMESG_WIDTH] = 0;
        assign S_AXI_BRESP[gen_si_slot*2+:2] = 0;
        assign S_AXI_BUSER[gen_si_slot*C_AXI_BUSER_WIDTH+:C_AXI_BUSER_WIDTH] = 0;
        assign S_AXI_BVALID[gen_si_slot] = 1'b0;
        assign st_tmp_bready[gen_si_slot*(C_NUM_MASTER_SLOTS+1)+:(C_NUM_MASTER_SLOTS+1)] = 0;
        assign S_AXI_WREADY[gen_si_slot] = 1'b0;
        assign wr_wm_wmesg[gen_si_slot*(P_WR_WMESG_WIDTH)+:P_WR_WMESG_WIDTH] = 0;
        assign wr_wm_wlast[gen_si_slot] = 1'b0;
        assign wr_tmp_wvalid[gen_si_slot*(C_NUM_MASTER_SLOTS+1)+:(C_NUM_MASTER_SLOTS+1)] = 0;
        assign st_aa_awtarget_hot[gen_si_slot*(C_NUM_MASTER_SLOTS+1)+:(C_NUM_MASTER_SLOTS+1)] = 0;
      end  // gen_si_write
    end  // gen_slave_slots
    
    for (gen_mi_slot=0; gen_mi_slot<C_NUM_MASTER_SLOTS+1; gen_mi_slot=gen_mi_slot+1) begin : gen_master_slots
      if (P_M_AXI_SUPPORTS_READ[gen_mi_slot]) begin : gen_mi_read
        if (C_NUM_SLAVE_SLOTS>1) begin : gen_rid_decoder
          addr_decoder #
            (
              .C_FAMILY          (C_FAMILY),
              .C_NUM_TARGETS     (C_NUM_SLAVE_SLOTS),
              .C_NUM_TARGETS_LOG (P_NUM_SLAVE_SLOTS_LOG),
              .C_NUM_RANGES      (1),
              .C_ADDR_WIDTH      (C_AXI_ID_WIDTH),
              .C_TARGET_ENC      (0),
              .C_TARGET_HOT      (1),
              .C_REGION_ENC      (0),
              .C_BASE_ADDR       (C_S_AXI_BASE_ID),
              .C_HIGH_ADDR       (C_S_AXI_HIGH_ID),
              .C_TARGET_QUAL     (P_SI_READ_CONNECTIVITY[gen_mi_slot*32+:32]),
              .C_RESOLUTION      (0)
            ) 
            rid_decoder_inst 
            (
              .ADDR             (st_mr_rid[gen_mi_slot*C_AXI_ID_WIDTH+:C_AXI_ID_WIDTH]),        
              .TARGET_HOT       (tmp_mr_rid_target[gen_mi_slot*C_NUM_SLAVE_SLOTS+:C_NUM_SLAVE_SLOTS]),  
              .TARGET_ENC       (),  
              .MATCH            (rid_match[gen_mi_slot]),       
              .REGION           ()      
            );
        end else begin : gen_no_rid_decoder
          assign tmp_mr_rid_target[gen_mi_slot] = 1'b1;  // All response transfers route to solo SI-slot.
          assign rid_match[gen_mi_slot] = 1'b1;
        end
        
        assign st_mr_rmesg[gen_mi_slot*P_ST_RMESG_WIDTH+:P_ST_RMESG_WIDTH] = {
          st_mr_rdata[gen_mi_slot*C_INTERCONNECT_DATA_WIDTH+:C_INTERCONNECT_DATA_WIDTH],
          st_mr_ruser[gen_mi_slot*C_AXI_RUSER_WIDTH+:C_AXI_RUSER_WIDTH], 
          st_mr_rresp[gen_mi_slot*2+:2]
          }; 
      end else begin : gen_no_mi_read
        assign tmp_mr_rid_target[gen_mi_slot*C_NUM_SLAVE_SLOTS+:C_NUM_SLAVE_SLOTS] = 0;
        assign rid_match[gen_mi_slot] = 1'b0;
        assign st_mr_rmesg[gen_mi_slot*P_ST_RMESG_WIDTH+:P_ST_RMESG_WIDTH] = 0;
      end  // gen_mi_read
      
      if (P_M_AXI_SUPPORTS_WRITE[gen_mi_slot]) begin : gen_mi_write
        if (C_NUM_SLAVE_SLOTS>1) begin : gen_bid_decoder
          addr_decoder #
            (
              .C_FAMILY          (C_FAMILY),
              .C_NUM_TARGETS     (C_NUM_SLAVE_SLOTS),
              .C_NUM_TARGETS_LOG (P_NUM_SLAVE_SLOTS_LOG),
              .C_NUM_RANGES      (1),
              .C_ADDR_WIDTH      (C_AXI_ID_WIDTH),
              .C_TARGET_ENC      (0),
              .C_TARGET_HOT      (1),
              .C_REGION_ENC      (0),
              .C_BASE_ADDR      (C_S_AXI_BASE_ID),
              .C_HIGH_ADDR      (C_S_AXI_HIGH_ID),
              .C_TARGET_QUAL     (P_SI_WRITE_CONNECTIVITY[gen_mi_slot*32+:32]),
              .C_RESOLUTION      (0)
            ) 
            bid_decoder_inst 
            (
              .ADDR             (st_mr_bid[gen_mi_slot*C_AXI_ID_WIDTH+:C_AXI_ID_WIDTH]),        
              .TARGET_HOT       (tmp_mr_bid_target[gen_mi_slot*C_NUM_SLAVE_SLOTS+:C_NUM_SLAVE_SLOTS]),  
              .TARGET_ENC       (),  
              .MATCH            (bid_match[gen_mi_slot]),       
              .REGION           ()      
            );
        end else begin : gen_no_bid_decoder
          assign tmp_mr_bid_target[gen_mi_slot] = 1'b1;  // All response transfers route to solo SI-slot.
          assign bid_match[gen_mi_slot] = 1'b1;
        end
      
        wdata_mux #  // "WM": Write data Mux, per MI-slot (incl error-handler)
          (
           .C_FAMILY                   (C_FAMILY),
           .C_NUM_SLAVE_SLOTS         (C_NUM_SLAVE_SLOTS),
           .C_SELECT_WIDTH     (P_NUM_SLAVE_SLOTS_LOG),
           .C_WMESG_WIDTH               (P_WR_WMESG_WIDTH),
           .C_FIFO_DEPTH_LOG           (C_W_ISSUE_WIDTH[gen_mi_slot*32+:6])
           )
          wdata_mux_w
            (
             .ACLK    (INTERCONNECT_ACLK),
             .ARESET  (reset),
             // Vector of write transfer inputs from each SI-slot's W-router
             .S_WMESG  (wr_wm_wmesg),
             .S_WLAST  (wr_wm_wlast),
             .S_WVALID (tmp_wm_wvalid[gen_mi_slot*C_NUM_SLAVE_SLOTS+:C_NUM_SLAVE_SLOTS]),
             .S_WREADY (tmp_wm_wready[gen_mi_slot*C_NUM_SLAVE_SLOTS+:C_NUM_SLAVE_SLOTS]),
             // Write transfer output to the current MI-slot
             .M_WMESG  (wm_mr_wmesg[gen_mi_slot*P_WR_WMESG_WIDTH+:P_WR_WMESG_WIDTH]),
             .M_WLAST  (wm_mr_wlast[gen_mi_slot]),
             .M_WVALID (wm_mr_wvalid[gen_mi_slot]),
             .M_WREADY (wm_mr_wready[gen_mi_slot]),
             // AW command push from AW arbiter output
             .S_ASELECT (aa_wm_awgrant_enc),  // SI-slot selected by arbiter
             .S_AVALID  (sa_wm_awvalid[gen_mi_slot]),
             .S_AREADY  (sa_wm_awready[gen_mi_slot])
             );
             
        if (C_DEBUG) begin : gen_debug_w
          // DEBUG WRITE BEAT COUNTER
          always @(posedge INTERCONNECT_ACLK) begin
            if (reset) begin
              debug_w_beat_cnt[gen_mi_slot*8+:8] <= 0;
            end else begin
              if (mi_wvalid[gen_mi_slot] & mi_wready[gen_mi_slot]) begin
                if (mi_wlast[gen_mi_slot]) begin
                  debug_w_beat_cnt[gen_mi_slot*8+:8] <= 0;
                end else begin
                  debug_w_beat_cnt[gen_mi_slot*8+:8] <= debug_w_beat_cnt[gen_mi_slot*8+:8] + 1;
                end
              end
            end
          end  // clocked process
  
          // DEBUG W-CHANNEL TRANSACTION SEQUENCE QUEUE
          axic_srl_fifo #
            (
             .C_FAMILY          (C_FAMILY),
             .C_FIFO_WIDTH      (8),
             .C_FIFO_DEPTH_LOG  (C_W_ISSUE_WIDTH[gen_mi_slot*32+:6]),
             .C_USE_FULL        (0)
             )
            debug_w_seq_fifo
              (
               .ACLK    (INTERCONNECT_ACLK),
               .ARESET  (reset),
               .S_MESG  (debug_aw_trans_seq),
               .S_VALID (sa_wm_awvalid[gen_mi_slot]),
               .S_READY (),
               .M_MESG  (debug_w_trans_seq[gen_mi_slot*8+:8]),
               .M_VALID (),
               .M_READY (mi_wvalid[gen_mi_slot] & mi_wready[gen_mi_slot] & mi_wlast[gen_mi_slot])
               );
        end  // gen_debug_w
             
        assign wm_mr_wdata[gen_mi_slot*C_INTERCONNECT_DATA_WIDTH+:C_INTERCONNECT_DATA_WIDTH] = wm_mr_wmesg[gen_mi_slot*P_WR_WMESG_WIDTH +: C_INTERCONNECT_DATA_WIDTH];
        assign wm_mr_wstrb[gen_mi_slot*C_INTERCONNECT_DATA_WIDTH/8+:C_INTERCONNECT_DATA_WIDTH/8] = wm_mr_wmesg[gen_mi_slot*P_WR_WMESG_WIDTH+C_INTERCONNECT_DATA_WIDTH +: C_INTERCONNECT_DATA_WIDTH/8];
        assign wm_mr_wuser[gen_mi_slot*C_AXI_WUSER_WIDTH+:C_AXI_WUSER_WIDTH] = wm_mr_wmesg[gen_mi_slot*P_WR_WMESG_WIDTH+C_INTERCONNECT_DATA_WIDTH+C_INTERCONNECT_DATA_WIDTH/8 +: C_AXI_WUSER_WIDTH];
        assign st_mr_bmesg[gen_mi_slot*P_ST_BMESG_WIDTH+:P_ST_BMESG_WIDTH] = {
          st_mr_buser[gen_mi_slot*C_AXI_BUSER_WIDTH+:C_AXI_BUSER_WIDTH],
          st_mr_bresp[gen_mi_slot*2+:2]
          }; 
      end else begin : gen_no_mi_write
        assign tmp_mr_bid_target[gen_mi_slot*C_NUM_SLAVE_SLOTS+:C_NUM_SLAVE_SLOTS] = 0;
        assign bid_match[gen_mi_slot] = 1'b0;
        assign wm_mr_wvalid[gen_mi_slot] = 0;
        assign wm_mr_wlast[gen_mi_slot] = 0;
        assign wm_mr_wdata[gen_mi_slot*C_INTERCONNECT_DATA_WIDTH+:C_INTERCONNECT_DATA_WIDTH] = 0;
        assign wm_mr_wstrb[gen_mi_slot*C_INTERCONNECT_DATA_WIDTH/8+:C_INTERCONNECT_DATA_WIDTH/8] = 0;
        assign wm_mr_wuser[gen_mi_slot*C_AXI_WUSER_WIDTH+:C_AXI_WUSER_WIDTH] = 0;
        assign st_mr_bmesg[gen_mi_slot*P_ST_BMESG_WIDTH+:P_ST_BMESG_WIDTH] = 0;
        assign tmp_wm_wready[gen_mi_slot*C_NUM_SLAVE_SLOTS+:C_NUM_SLAVE_SLOTS] = 0;
        assign sa_wm_awready[gen_mi_slot] = 0;
      end  // gen_mi_write
      
      for (gen_si_slot=0; gen_si_slot<C_NUM_SLAVE_SLOTS; gen_si_slot=gen_si_slot+1) begin : gen_trans_si
        // Transpose handshakes from W-router (SxM) to W-mux (MxS).
        assign tmp_wm_wvalid[gen_mi_slot*C_NUM_SLAVE_SLOTS+gen_si_slot] = wr_tmp_wvalid[gen_si_slot*(C_NUM_MASTER_SLOTS+1)+gen_mi_slot];
        assign wr_tmp_wready[gen_si_slot*(C_NUM_MASTER_SLOTS+1)+gen_mi_slot] = tmp_wm_wready[gen_mi_slot*C_NUM_SLAVE_SLOTS+gen_si_slot];
        // Transpose response enables from ID decoders (MxS) to si_transactors (SxM).
        assign st_tmp_bid_target[gen_si_slot*(C_NUM_MASTER_SLOTS+1)+gen_mi_slot] = tmp_mr_bid_target[gen_mi_slot*C_NUM_SLAVE_SLOTS+gen_si_slot];
        assign st_tmp_rid_target[gen_si_slot*(C_NUM_MASTER_SLOTS+1)+gen_mi_slot] = tmp_mr_rid_target[gen_mi_slot*C_NUM_SLAVE_SLOTS+gen_si_slot];
      end  // gen_trans_si
      
      assign bready_carry[gen_mi_slot] =  st_tmp_bready[gen_mi_slot];
      assign rready_carry[gen_mi_slot] =  st_tmp_rready[gen_mi_slot];
      for (gen_si_slot=1; gen_si_slot<C_NUM_SLAVE_SLOTS; gen_si_slot=gen_si_slot+1) begin : gen_resp_carry_si
        assign bready_carry[gen_si_slot*(C_NUM_MASTER_SLOTS+1)+gen_mi_slot] =  // Generate M_BREADY if ...
          bready_carry[(gen_si_slot-1)*(C_NUM_MASTER_SLOTS+1)+gen_mi_slot] |  // For any SI-slot (OR carry-chain across all SI-slots), ...
          st_tmp_bready[gen_si_slot*(C_NUM_MASTER_SLOTS+1)+gen_mi_slot];  // The write SI transactor indicates BREADY for that MI-slot.
        assign rready_carry[gen_si_slot*(C_NUM_MASTER_SLOTS+1)+gen_mi_slot] =  // Generate M_RREADY if ...
          rready_carry[(gen_si_slot-1)*(C_NUM_MASTER_SLOTS+1)+gen_mi_slot] |  // For any SI-slot (OR carry-chain across all SI-slots), ...
          st_tmp_rready[gen_si_slot*(C_NUM_MASTER_SLOTS+1)+gen_mi_slot];  // The write SI transactor indicates RREADY for that MI-slot.
      end  // gen_resp_carry_si
           
      // ENHANCEMENT?: Conditionally generate if C_*_ISSUING > 0, otherwise issuing is unlimited.
      assign w_cmd_push[gen_mi_slot] = mi_awvalid[gen_mi_slot] && mi_awready[gen_mi_slot] && C_M_AXI_SUPPORTS_WRITE[gen_mi_slot];
      assign r_cmd_push[gen_mi_slot] = mi_arvalid[gen_mi_slot] && mi_arready[gen_mi_slot] && C_M_AXI_SUPPORTS_READ[gen_mi_slot];
      assign w_cmd_pop[gen_mi_slot] = st_mr_bvalid[gen_mi_slot] && st_mr_bready[gen_mi_slot] && C_M_AXI_SUPPORTS_WRITE[gen_mi_slot] && (|w_issuance_cnt[gen_mi_slot*8+:(C_W_ISSUE_WIDTH[gen_mi_slot*32+:6]+1)]);
      assign r_cmd_pop[gen_mi_slot] = st_mr_rvalid[gen_mi_slot] && st_mr_rready[gen_mi_slot] && st_mr_rlast[gen_mi_slot] && C_M_AXI_SUPPORTS_READ[gen_mi_slot] && (|r_issuance_cnt[gen_mi_slot*8+:(C_R_ISSUE_WIDTH[gen_mi_slot*32+:6]+1)]);
      // Disqualify arbitration of SI-slot if targeted MI-slot has reached its issuance limit.
      assign mi_awmaxissuance[gen_mi_slot] = w_issuance_cnt[gen_mi_slot*8+C_W_ISSUE_WIDTH[gen_mi_slot*32+:6]];  // counter MSB
      assign mi_armaxissuance[gen_mi_slot] = r_issuance_cnt[gen_mi_slot*8+C_R_ISSUE_WIDTH[gen_mi_slot*32+:6]];  // counter MSB
      
      always @(posedge INTERCONNECT_ACLK) begin
        if (reset) begin
          w_issuance_cnt[gen_mi_slot*8+:8] <= 0;  // Some high-order bits remain constant 0
          r_issuance_cnt[gen_mi_slot*8+:8] <= 0;  // Some high-order bits remain constant 0
        end else begin
          if (w_cmd_push[gen_mi_slot] && ~w_cmd_pop[gen_mi_slot]) begin
            w_issuance_cnt[gen_mi_slot*8+:(C_W_ISSUE_WIDTH[gen_mi_slot*32+:6]+1)] <= w_issuance_cnt[gen_mi_slot*8+:(C_W_ISSUE_WIDTH[gen_mi_slot*32+:6]+1)] + 1;
          end else if (w_cmd_pop[gen_mi_slot] && ~w_cmd_push[gen_mi_slot]) begin
            w_issuance_cnt[gen_mi_slot*8+:(C_W_ISSUE_WIDTH[gen_mi_slot*32+:6]+1)] <= w_issuance_cnt[gen_mi_slot*8+:(C_W_ISSUE_WIDTH[gen_mi_slot*32+:6]+1)] - 1;
          end
          if (r_cmd_push[gen_mi_slot] && ~r_cmd_pop[gen_mi_slot]) begin
            r_issuance_cnt[gen_mi_slot*8+:(C_R_ISSUE_WIDTH[gen_mi_slot*32+:6]+1)] <= r_issuance_cnt[gen_mi_slot*8+:(C_R_ISSUE_WIDTH[gen_mi_slot*32+:6]+1)] + 1;
          end else if (r_cmd_pop[gen_mi_slot] && ~r_cmd_push[gen_mi_slot]) begin
            r_issuance_cnt[gen_mi_slot*8+:(C_R_ISSUE_WIDTH[gen_mi_slot*32+:6]+1)] <= r_issuance_cnt[gen_mi_slot*8+:(C_R_ISSUE_WIDTH[gen_mi_slot*32+:6]+1)] - 1;
          end
        end
      end  // Clocked process

      // Reg-slice must break combinatorial path from M_BID and M_RID inputs to M_BREADY and M_RREADY outputs.
      //   (See m_rready_i and m_resp_en combinatorial assignments in si_transactor.)
      //   Reg-slice incurs +1 latency, but no bubble-cycles.
      axi_register_slice #  // "MR": MI-side R/B-channel Reg-slice, per MI-slot (pass-through if only 1 SI-slot configured)
        (
          .C_FAMILY                         (C_FAMILY),
          .C_AXI_ID_WIDTH                   (C_AXI_ID_WIDTH),
          .C_AXI_ADDR_WIDTH                 (1),
          .C_AXI_DATA_WIDTH                 (C_INTERCONNECT_DATA_WIDTH),
          .C_AXI_SUPPORTS_USER_SIGNALS      (C_AXI_SUPPORTS_USER_SIGNALS),
          .C_AXI_AWUSER_WIDTH               (1),
          .C_AXI_ARUSER_WIDTH               (1),
          .C_AXI_WUSER_WIDTH                (C_AXI_WUSER_WIDTH),
          .C_AXI_RUSER_WIDTH                (C_AXI_RUSER_WIDTH),
          .C_AXI_BUSER_WIDTH                (C_AXI_BUSER_WIDTH),
          .C_REG_CONFIG_AW                  (P_BYPASS),
          .C_REG_CONFIG_AR                  (P_BYPASS),
          .C_REG_CONFIG_W                   ((P_M_AXI_SUPPORTS_WRITE[gen_mi_slot] & (C_M_AXI_PROTOCOL[gen_mi_slot*32+:32]!=P_AXILITE) &
                                              (C_M_AXI_DATA_WIDTH[gen_mi_slot*32+:32] != C_INTERCONNECT_DATA_WIDTH)) ? P_FWD_REV : P_BYPASS),
          .C_REG_CONFIG_R                   (P_M_AXI_SUPPORTS_READ[gen_mi_slot] ? ((C_M_AXI_PROTOCOL[gen_mi_slot*32+:32]==P_AXILITE) ? P_SIMPLE : P_FWD_REV) : P_BYPASS),
          .C_REG_CONFIG_B                   (P_M_AXI_SUPPORTS_WRITE[gen_mi_slot] ? P_SIMPLE : P_BYPASS)
        )
        reg_slice_mi 
        (
          .ARESETN                     (ARESETN),
          .ACLK                       (INTERCONNECT_ACLK),
          .S_AXI_AWID                       ({C_AXI_ID_WIDTH{1'b0}}),
          .S_AXI_AWADDR                     ({1{1'b0}}),
          .S_AXI_AWLEN                      ({8{1'b0}}),
          .S_AXI_AWSIZE                     ({3{1'b0}}),
          .S_AXI_AWBURST                    ({2{1'b0}}),
          .S_AXI_AWLOCK                     ({2{1'b0}}),
          .S_AXI_AWCACHE                    ({4{1'b0}}),
          .S_AXI_AWPROT                     ({3{1'b0}}),
          .S_AXI_AWREGION                   ({4{1'b0}}),
          .S_AXI_AWQOS                      ({4{1'b0}}),
          .S_AXI_AWUSER                     ({1{1'b0}}),
          .S_AXI_AWVALID                    ({1{1'b0}}),
          .S_AXI_AWREADY                    (),
          .S_AXI_WID                        ({C_AXI_ID_WIDTH{1'b0}}),
          .S_AXI_WDATA                      (wm_mr_wdata[gen_mi_slot*C_INTERCONNECT_DATA_WIDTH+:C_INTERCONNECT_DATA_WIDTH]),
          .S_AXI_WSTRB                      (wm_mr_wstrb[gen_mi_slot*C_INTERCONNECT_DATA_WIDTH/8+:C_INTERCONNECT_DATA_WIDTH/8]),
          .S_AXI_WLAST                      (wm_mr_wlast[gen_mi_slot]),
          .S_AXI_WUSER                      (wm_mr_wuser[gen_mi_slot*C_AXI_WUSER_WIDTH+:C_AXI_WUSER_WIDTH]),
          .S_AXI_WVALID                     (wm_mr_wvalid[gen_mi_slot]),
          .S_AXI_WREADY                     (wm_mr_wready[gen_mi_slot]),
          .S_AXI_BID                        (st_mr_bid[gen_mi_slot*C_AXI_ID_WIDTH+:C_AXI_ID_WIDTH]         ),
          .S_AXI_BRESP                      (st_mr_bresp[gen_mi_slot*2+:2]                                 ),
          .S_AXI_BUSER                      (st_mr_buser[gen_mi_slot*C_AXI_BUSER_WIDTH+:C_AXI_BUSER_WIDTH] ),
          .S_AXI_BVALID                     (st_mr_bvalid[gen_mi_slot*1+:1]                                ),
          .S_AXI_BREADY                     (st_mr_bready[gen_mi_slot*1+:1]                                ),
          .S_AXI_ARID                       ({C_AXI_ID_WIDTH{1'b0}}),
          .S_AXI_ARADDR                     ({1{1'b0}}),
          .S_AXI_ARLEN                      ({8{1'b0}}),
          .S_AXI_ARSIZE                     ({3{1'b0}}),
          .S_AXI_ARBURST                    ({2{1'b0}}),
          .S_AXI_ARLOCK                     ({2{1'b0}}),
          .S_AXI_ARCACHE                    ({4{1'b0}}),
          .S_AXI_ARPROT                     ({3{1'b0}}),
          .S_AXI_ARREGION                   ({4{1'b0}}),
          .S_AXI_ARQOS                      ({4{1'b0}}),
          .S_AXI_ARUSER                     ({1{1'b0}}),
          .S_AXI_ARVALID                    ({1{1'b0}}),
          .S_AXI_ARREADY                    (),
          .S_AXI_RID                        (st_mr_rid[gen_mi_slot*C_AXI_ID_WIDTH+:C_AXI_ID_WIDTH]                          ),
          .S_AXI_RDATA                      (st_mr_rdata[gen_mi_slot*C_INTERCONNECT_DATA_WIDTH+:C_INTERCONNECT_DATA_WIDTH]  ),
          .S_AXI_RRESP                      (st_mr_rresp[gen_mi_slot*2+:2]                                                  ),
          .S_AXI_RLAST                      (st_mr_rlast[gen_mi_slot*1+:1]                                                  ),
          .S_AXI_RUSER                      (st_mr_ruser[gen_mi_slot*C_AXI_RUSER_WIDTH+:C_AXI_RUSER_WIDTH]                  ),
          .S_AXI_RVALID                     (st_mr_rvalid[gen_mi_slot*1+:1]                                                 ),
          .S_AXI_RREADY                     (st_mr_rready[gen_mi_slot*1+:1]                                                 ),
          .M_AXI_AWID                       (),
          .M_AXI_AWADDR                     (),
          .M_AXI_AWLEN                      (),
          .M_AXI_AWSIZE                     (),
          .M_AXI_AWBURST                    (),
          .M_AXI_AWLOCK                     (),
          .M_AXI_AWCACHE                    (),
          .M_AXI_AWPROT                     (),
          .M_AXI_AWREGION                   (),
          .M_AXI_AWQOS                      (),
          .M_AXI_AWUSER                     (),
          .M_AXI_AWVALID                    (),
          .M_AXI_AWREADY                    ({1{1'b0}}),
          .M_AXI_WID                        (),
          .M_AXI_WDATA                      (mi_wdata[gen_mi_slot*C_INTERCONNECT_DATA_WIDTH+:C_INTERCONNECT_DATA_WIDTH]),
          .M_AXI_WSTRB                      (mi_wstrb[gen_mi_slot*C_INTERCONNECT_DATA_WIDTH/8+:C_INTERCONNECT_DATA_WIDTH/8]),
          .M_AXI_WLAST                      (mi_wlast[gen_mi_slot]),
          .M_AXI_WUSER                      (mi_wuser[gen_mi_slot*C_AXI_WUSER_WIDTH+:C_AXI_WUSER_WIDTH]),
          .M_AXI_WVALID                     (mi_wvalid[gen_mi_slot]),
          .M_AXI_WREADY                     (mi_wready[gen_mi_slot]),
          .M_AXI_BID                        (mi_bid[gen_mi_slot*C_AXI_ID_WIDTH+:C_AXI_ID_WIDTH]                          ),
          .M_AXI_BRESP                      (mi_bresp[gen_mi_slot*2+:2]                                                  ),
          .M_AXI_BUSER                      (mi_buser[gen_mi_slot*C_AXI_BUSER_WIDTH+:C_AXI_BUSER_WIDTH]                  ),
          .M_AXI_BVALID                     (mi_bvalid[gen_mi_slot*1+:1]                                                 ),
          .M_AXI_BREADY                     (mi_bready[gen_mi_slot*1+:1]                                                 ),
          .M_AXI_ARID                       (),
          .M_AXI_ARADDR                     (),
          .M_AXI_ARLEN                      (),
          .M_AXI_ARSIZE                     (),
          .M_AXI_ARBURST                    (),
          .M_AXI_ARLOCK                     (),
          .M_AXI_ARCACHE                    (),
          .M_AXI_ARPROT                     (),
          .M_AXI_ARREGION                   (),
          .M_AXI_ARQOS                      (),
          .M_AXI_ARUSER                     (),
          .M_AXI_ARVALID                    (),
          .M_AXI_ARREADY                    ({1{1'b0}}),
          .M_AXI_RID                        (mi_rid[gen_mi_slot*C_AXI_ID_WIDTH+:C_AXI_ID_WIDTH]                          ),
          .M_AXI_RDATA                      (mi_rdata[gen_mi_slot*C_AXI_DATA_MAX_WIDTH+:C_INTERCONNECT_DATA_WIDTH]  ),
          .M_AXI_RRESP                      (mi_rresp[gen_mi_slot*2+:2]                                                  ),
          .M_AXI_RLAST                      (mi_rlast[gen_mi_slot*1+:1]                                                  ),
          .M_AXI_RUSER                      (mi_ruser[gen_mi_slot*C_AXI_RUSER_WIDTH+:C_AXI_RUSER_WIDTH]                  ),
          .M_AXI_RVALID                     (mi_rvalid[gen_mi_slot*1+:1]                                                 ),
          .M_AXI_RREADY                     (mi_rready[gen_mi_slot*1+:1]                                                 )
        );
    end  // gen_master_slots (Next gen_mi_slot)
  
    // Highest row of *ready_carry contains accumulated OR across all SI-slots, for each MI-slot.
    assign st_mr_bready = bready_carry[(C_NUM_SLAVE_SLOTS-1)*(C_NUM_MASTER_SLOTS+1) +: C_NUM_MASTER_SLOTS+1]; 
    assign st_mr_rready = rready_carry[(C_NUM_SLAVE_SLOTS-1)*(C_NUM_MASTER_SLOTS+1) +: C_NUM_MASTER_SLOTS+1]; 
    // Assign MI-side B, R and W channel ports (exclude error handler signals).
    assign mi_bid[0+:C_NUM_MASTER_SLOTS*C_AXI_ID_WIDTH] = M_AXI_BID;
    assign mi_bvalid[0+:C_NUM_MASTER_SLOTS] = M_AXI_BVALID; 
    assign mi_bresp[0+:C_NUM_MASTER_SLOTS*2] = M_AXI_BRESP;
    assign mi_buser[0+:C_NUM_MASTER_SLOTS*C_AXI_BUSER_WIDTH] = M_AXI_BUSER;
    assign M_AXI_BREADY = mi_bready[0+:C_NUM_MASTER_SLOTS];
    assign mi_rid[0+:C_NUM_MASTER_SLOTS*C_AXI_ID_WIDTH] = M_AXI_RID;
    assign mi_rlast[0+:C_NUM_MASTER_SLOTS] = M_AXI_RLAST; 
    assign mi_rvalid[0+:C_NUM_MASTER_SLOTS] = M_AXI_RVALID; 
    assign mi_rresp[0+:C_NUM_MASTER_SLOTS*2] = M_AXI_RRESP;
    assign mi_ruser[0+:C_NUM_MASTER_SLOTS*C_AXI_RUSER_WIDTH] = M_AXI_RUSER;
    assign mi_rdata[0+:C_NUM_MASTER_SLOTS*C_AXI_DATA_MAX_WIDTH] = M_AXI_RDATA;
    assign M_AXI_RREADY = mi_rready[0+:C_NUM_MASTER_SLOTS];
    assign M_AXI_WLAST = mi_wlast[0+:C_NUM_MASTER_SLOTS];
    assign M_AXI_WVALID = mi_wvalid[0+:C_NUM_MASTER_SLOTS];
    assign M_AXI_WUSER = mi_wuser[0+:C_NUM_MASTER_SLOTS*C_AXI_WUSER_WIDTH];
    assign mi_wready[0+:C_NUM_MASTER_SLOTS] = M_AXI_WREADY;
    for (gen_mi_slot=0; gen_mi_slot<C_NUM_MASTER_SLOTS; gen_mi_slot=gen_mi_slot+1) begin : gen_mi_w
      assign M_AXI_WDATA[gen_mi_slot*C_AXI_DATA_MAX_WIDTH+:C_AXI_DATA_MAX_WIDTH] = mi_wdata[gen_mi_slot*C_INTERCONNECT_DATA_WIDTH+:C_INTERCONNECT_DATA_WIDTH];
      assign M_AXI_WSTRB[gen_mi_slot*C_AXI_DATA_MAX_WIDTH/8+:C_AXI_DATA_MAX_WIDTH/8] = mi_wstrb[gen_mi_slot*C_INTERCONNECT_DATA_WIDTH/8+:C_INTERCONNECT_DATA_WIDTH/8];
    end

    addr_arbiter #  // "AA": Addr Arbiter (AW channel)
      (
       .C_FAMILY                (C_FAMILY),
       .C_NUM_M                 (C_NUM_MASTER_SLOTS+1),
       .C_NUM_S                 (C_NUM_SLAVE_SLOTS),
       .C_NUM_S_LOG             (P_NUM_SLAVE_SLOTS_LOG),
       .C_MESG_WIDTH            (P_AA_AWMESG_WIDTH),
       .C_ARB_PRIORITY          (C_S_AXI_ARB_PRIORITY)
       )
      addr_arbiter_aw
        (
         .ACLK                  (INTERCONNECT_ACLK),
         .ARESET                (reset),
         // Vector of SI-side AW command request inputs
         .S_MESG                (tmp_aa_awmesg),
         .S_TARGET_HOT          (st_aa_awtarget_hot),
         .S_VALID               (ss_aa_awvalid),
         .S_VALID_QUAL          (st_aa_awvalid_qual),
         .S_READY               (ss_aa_awready),
         // Granted AW command output
         .M_MESG                (aa_mi_awmesg),
         .M_TARGET_HOT          (aa_mi_awtarget_hot),  // MI-slot targeted by granted command
         .M_GRANT_ENC           (aa_wm_awgrant_enc),  // SI-slot index of granted command
         .M_VALID               (aa_sa_awvalid),
         .M_READY               (aa_sa_awready),
         .ISSUANCE_LIMIT        (mi_awmaxissuance)
         );
         
    // Broadcast AW transfer payload to all MI-slots
    assign M_AXI_AWID        = {C_NUM_MASTER_SLOTS{aa_mi_awmesg[0+:C_AXI_ID_WIDTH]}};
    assign M_AXI_AWADDR      = {C_NUM_MASTER_SLOTS{aa_mi_awmesg[C_AXI_ID_WIDTH+:C_AXI_ADDR_WIDTH]}};
    assign M_AXI_AWLEN       = {C_NUM_MASTER_SLOTS{aa_mi_awmesg[C_AXI_ID_WIDTH+C_AXI_ADDR_WIDTH +:8]}};
    assign M_AXI_AWSIZE      = {C_NUM_MASTER_SLOTS{aa_mi_awmesg[C_AXI_ID_WIDTH+C_AXI_ADDR_WIDTH+8 +:3]}};
    assign M_AXI_AWLOCK      = {C_NUM_MASTER_SLOTS{aa_mi_awmesg[C_AXI_ID_WIDTH+C_AXI_ADDR_WIDTH+8+3 +:2]}};
    assign M_AXI_AWPROT      = {C_NUM_MASTER_SLOTS{aa_mi_awmesg[C_AXI_ID_WIDTH+C_AXI_ADDR_WIDTH+8+3+2 +:3]}};
    assign M_AXI_AWREGION    = {C_NUM_MASTER_SLOTS{aa_mi_awmesg[C_AXI_ID_WIDTH+C_AXI_ADDR_WIDTH+8+3+2+3 +:4]}};
    assign M_AXI_AWBURST     = {C_NUM_MASTER_SLOTS{aa_mi_awmesg[C_AXI_ID_WIDTH+C_AXI_ADDR_WIDTH+8+3+2+3+4 +:2]}};
    assign M_AXI_AWCACHE     = {C_NUM_MASTER_SLOTS{aa_mi_awmesg[C_AXI_ID_WIDTH+C_AXI_ADDR_WIDTH+8+3+2+3+4+2 +:4]}};
    assign M_AXI_AWQOS       = {C_NUM_MASTER_SLOTS{aa_mi_awmesg[C_AXI_ID_WIDTH+C_AXI_ADDR_WIDTH+8+3+2+3+4+2+4 +:4]}};
    assign M_AXI_AWUSER      = {C_NUM_MASTER_SLOTS{aa_mi_awmesg[C_AXI_ID_WIDTH+C_AXI_ADDR_WIDTH+8+3+2+3+4+2+4+4 +:C_AXI_AWUSER_WIDTH]}};
         
    addr_arbiter #  // "AA": Addr Arbiter (AR channel)
      (
       .C_FAMILY                (C_FAMILY),
       .C_NUM_M                 (C_NUM_MASTER_SLOTS+1),
       .C_NUM_S                 (C_NUM_SLAVE_SLOTS),
       .C_NUM_S_LOG             (P_NUM_SLAVE_SLOTS_LOG),
       .C_MESG_WIDTH            (P_AA_ARMESG_WIDTH),
       .C_ARB_PRIORITY          (C_S_AXI_ARB_PRIORITY)
       )
      addr_arbiter_ar
        (
         .ACLK                  (INTERCONNECT_ACLK),
         .ARESET                (reset),
         // Vector of SI-side AR command request inputs
         .S_MESG                (tmp_aa_armesg),
         .S_TARGET_HOT          (st_aa_artarget_hot),
         .S_VALID_QUAL          (st_aa_arvalid_qual),
         .S_VALID               (st_aa_arvalid),
         .S_READY               (st_aa_arready),
         // Granted AR command output
         .M_MESG                (aa_mi_armesg),
         .M_TARGET_HOT          (aa_mi_artarget_hot),  // MI-slot targeted by granted command
         .M_GRANT_ENC           (),
         .M_VALID               (aa_mi_arvalid),  // SI-slot index of granted command
         .M_READY               (aa_mi_arready),
         .ISSUANCE_LIMIT        (mi_armaxissuance)
         );
  
    if (C_DEBUG) begin : gen_debug_trans_seq
      // DEBUG WRITE TRANSACTION SEQUENCE COUNTER
      always @(posedge INTERCONNECT_ACLK) begin
        if (reset) begin
          debug_aw_trans_seq <= 1;
        end else begin
          if (aa_sa_awvalid && aa_sa_awready) begin
            debug_aw_trans_seq <= debug_aw_trans_seq + 1;
          end
        end
      end
  
      // DEBUG READ TRANSACTION SEQUENCE COUNTER
      always @(posedge INTERCONNECT_ACLK) begin
        if (reset) begin
          debug_ar_trans_seq <= 1;
        end else begin
          if (aa_mi_arvalid && aa_mi_arready) begin
            debug_ar_trans_seq <= debug_ar_trans_seq + 1;
          end
        end
      end
    end  // gen_debug_trans_seq

    // Broadcast AR transfer payload to all MI-slots
    assign M_AXI_ARID        = {C_NUM_MASTER_SLOTS{aa_mi_armesg[0+:C_AXI_ID_WIDTH]}};
    assign M_AXI_ARADDR      = {C_NUM_MASTER_SLOTS{aa_mi_armesg[C_AXI_ID_WIDTH+:C_AXI_ADDR_WIDTH]}};
    assign M_AXI_ARLEN       = {C_NUM_MASTER_SLOTS{aa_mi_armesg[C_AXI_ID_WIDTH+C_AXI_ADDR_WIDTH +:8]}};
    assign M_AXI_ARSIZE      = {C_NUM_MASTER_SLOTS{aa_mi_armesg[C_AXI_ID_WIDTH+C_AXI_ADDR_WIDTH+8 +:3]}};
    assign M_AXI_ARLOCK      = {C_NUM_MASTER_SLOTS{aa_mi_armesg[C_AXI_ID_WIDTH+C_AXI_ADDR_WIDTH+8+3 +:2]}};
    assign M_AXI_ARPROT      = {C_NUM_MASTER_SLOTS{aa_mi_armesg[C_AXI_ID_WIDTH+C_AXI_ADDR_WIDTH+8+3+2 +:3]}};
    assign M_AXI_ARREGION    = {C_NUM_MASTER_SLOTS{aa_mi_armesg[C_AXI_ID_WIDTH+C_AXI_ADDR_WIDTH+8+3+2+3 +:4]}};
    assign M_AXI_ARBURST     = {C_NUM_MASTER_SLOTS{aa_mi_armesg[C_AXI_ID_WIDTH+C_AXI_ADDR_WIDTH+8+3+2+3+4 +:2]}};
    assign M_AXI_ARCACHE     = {C_NUM_MASTER_SLOTS{aa_mi_armesg[C_AXI_ID_WIDTH+C_AXI_ADDR_WIDTH+8+3+2+3+4+2 +:4]}};
    assign M_AXI_ARQOS       = {C_NUM_MASTER_SLOTS{aa_mi_armesg[C_AXI_ID_WIDTH+C_AXI_ADDR_WIDTH+8+3+2+3+4+2+4 +:4]}};
    assign M_AXI_ARUSER      = {C_NUM_MASTER_SLOTS{aa_mi_armesg[C_AXI_ID_WIDTH+C_AXI_ADDR_WIDTH+8+3+2+3+4+2+4+4 +:C_AXI_ARUSER_WIDTH]}};
         
    // AW arbiter command transfer completes upon completion of both M-side AW-channel transfer and W-mux address acceptance (command push).
    splitter #  // "SA": Splitter for Write Addr Arbiter
      (
        .C_NUM_M                (2)
      )
      splitter_aw_mi
      (
         .ACLK                  (INTERCONNECT_ACLK),
         .ARESET                (reset),
         .S_VALID              (aa_sa_awvalid),
         .S_READY              (aa_sa_awready),
         .M_VALID              ({mi_awvalid_en, sa_wm_awvalid_en}),
         .M_READY              ({mi_awready_mux, sa_wm_awready_mux})
      );
      
    assign mi_awvalid = aa_mi_awtarget_hot & {C_NUM_MASTER_SLOTS+1{mi_awvalid_en}};
    assign mi_awready_mux = |(aa_mi_awtarget_hot & mi_awready);
    assign M_AXI_AWVALID = mi_awvalid[0+:C_NUM_MASTER_SLOTS];  // Slot C_NUM_MASTER_SLOTS+1 is the error handler
    assign mi_awready[0+:C_NUM_MASTER_SLOTS] = M_AXI_AWREADY;
    assign sa_wm_awvalid = aa_mi_awtarget_hot & {C_NUM_MASTER_SLOTS+1{sa_wm_awvalid_en}};
    assign sa_wm_awready_mux = |(aa_mi_awtarget_hot & sa_wm_awready);
    
    assign mi_arvalid = aa_mi_artarget_hot & {C_NUM_MASTER_SLOTS+1{aa_mi_arvalid}};
    assign aa_mi_arready = |(aa_mi_artarget_hot & mi_arready);
    assign M_AXI_ARVALID = mi_arvalid[0+:C_NUM_MASTER_SLOTS];  // Slot C_NUM_MASTER_SLOTS+1 is the error handler
    assign mi_arready[0+:C_NUM_MASTER_SLOTS] = M_AXI_ARREADY;
    
    // MI-slot # C_NUM_MASTER_SLOTS is the error handler
    if (C_RANGE_CHECK) begin : gen_decerr_slave
      decerr_slave #
        (
         .C_AXI_ID_WIDTH                 (C_AXI_ID_WIDTH),
         .C_AXI_DATA_WIDTH               (C_INTERCONNECT_DATA_WIDTH),
         .C_AXI_RUSER_WIDTH                (C_AXI_RUSER_WIDTH),
         .C_AXI_BUSER_WIDTH                (C_AXI_BUSER_WIDTH)
        )
        decerr_slave_inst
          (
           .S_AXI_ACLK (INTERCONNECT_ACLK),
           .S_AXI_ARESET (reset),
           .S_AXI_AWID (aa_mi_awmesg[0+:C_AXI_ID_WIDTH]),
           .S_AXI_AWVALID (mi_awvalid[C_NUM_MASTER_SLOTS]),
           .S_AXI_AWREADY (mi_awready[C_NUM_MASTER_SLOTS]),
           .S_AXI_WLAST (mi_wlast[C_NUM_MASTER_SLOTS]),
           .S_AXI_WVALID (mi_wvalid[C_NUM_MASTER_SLOTS]),
           .S_AXI_WREADY (mi_wready[C_NUM_MASTER_SLOTS]),
           .S_AXI_BID (mi_bid[C_NUM_MASTER_SLOTS*C_AXI_ID_WIDTH+:C_AXI_ID_WIDTH]),
           .S_AXI_BRESP (mi_bresp[C_NUM_MASTER_SLOTS*2+:2]),
           .S_AXI_BUSER (mi_buser[C_NUM_MASTER_SLOTS*C_AXI_BUSER_WIDTH+:C_AXI_BUSER_WIDTH]),
           .S_AXI_BVALID (mi_bvalid[C_NUM_MASTER_SLOTS]),
           .S_AXI_BREADY (mi_bready[C_NUM_MASTER_SLOTS]),
           .S_AXI_ARID (aa_mi_armesg[0+:C_AXI_ID_WIDTH]),
           .S_AXI_ARLEN (aa_mi_armesg[C_AXI_ID_WIDTH+C_AXI_ADDR_WIDTH +:8]),
           .S_AXI_ARVALID (mi_arvalid[C_NUM_MASTER_SLOTS]),
           .S_AXI_ARREADY (mi_arready[C_NUM_MASTER_SLOTS]),
           .S_AXI_RID (mi_rid[C_NUM_MASTER_SLOTS*C_AXI_ID_WIDTH+:C_AXI_ID_WIDTH]),
           .S_AXI_RDATA (mi_rdata[C_NUM_MASTER_SLOTS*C_AXI_DATA_MAX_WIDTH+:C_INTERCONNECT_DATA_WIDTH]),
           .S_AXI_RRESP (mi_rresp[C_NUM_MASTER_SLOTS*2+:2]),
           .S_AXI_RUSER (mi_ruser[C_NUM_MASTER_SLOTS*C_AXI_RUSER_WIDTH+:C_AXI_RUSER_WIDTH]),
           .S_AXI_RLAST (mi_rlast[C_NUM_MASTER_SLOTS]),
           .S_AXI_RVALID (mi_rvalid[C_NUM_MASTER_SLOTS]),
           .S_AXI_RREADY (mi_rready[C_NUM_MASTER_SLOTS])
         );
    end else begin : gen_no_decerr_slave
      assign mi_awready[C_NUM_MASTER_SLOTS] = 1'b0;
      assign mi_wready[C_NUM_MASTER_SLOTS] = 1'b0;
      assign mi_arready[C_NUM_MASTER_SLOTS] = 1'b0;
      assign mi_awready[C_NUM_MASTER_SLOTS] = 1'b0;
      assign mi_awready[C_NUM_MASTER_SLOTS] = 1'b0;
      assign mi_bid[C_NUM_MASTER_SLOTS*C_AXI_ID_WIDTH+:C_AXI_ID_WIDTH]                    = 0;
      assign mi_bresp[C_NUM_MASTER_SLOTS*2+:2]                                            = 0;
      assign mi_buser[C_NUM_MASTER_SLOTS*C_AXI_BUSER_WIDTH+:C_AXI_BUSER_WIDTH]            = 0;
      assign mi_bvalid[C_NUM_MASTER_SLOTS]                                                = 1'b0;
      assign mi_rid[C_NUM_MASTER_SLOTS*C_AXI_ID_WIDTH+:C_AXI_ID_WIDTH]                    = 0;
      assign mi_rdata[C_NUM_MASTER_SLOTS*C_AXI_DATA_MAX_WIDTH+:C_INTERCONNECT_DATA_WIDTH] = 0; 
      assign mi_rresp[C_NUM_MASTER_SLOTS*2+:2]                                            = 0; 
      assign mi_ruser[C_NUM_MASTER_SLOTS*C_AXI_RUSER_WIDTH+:C_AXI_RUSER_WIDTH]            = 0; 
      assign mi_rlast[C_NUM_MASTER_SLOTS]                                                  = 1'b0;
      assign mi_rvalid[C_NUM_MASTER_SLOTS]                                                 = 1'b0;
    end  // gen_decerr_slave
  end  // gen_crossbar
endgenerate

// Control slave port not yet implemented
generate
  if (C_USE_CTRL_PORT) begin : gen_ctrl_port
    assign S_AXI_CTRL_AWREADY = 0;
    assign S_AXI_CTRL_WREADY = 0;
    assign S_AXI_CTRL_BRESP = 0;
    assign S_AXI_CTRL_BVALID = 0;
    assign S_AXI_CTRL_ARREADY = 0;
    assign S_AXI_CTRL_RDATA = 0;
    assign S_AXI_CTRL_RRESP = 0;
    assign S_AXI_CTRL_RVALID = 0;
    assign IRQ = 0;
  end else begin : gen_no_ctrl_port
    assign S_AXI_CTRL_AWREADY = 0;
    assign S_AXI_CTRL_WREADY = 0;
    assign S_AXI_CTRL_BRESP = 0;
    assign S_AXI_CTRL_BVALID = 0;
    assign S_AXI_CTRL_ARREADY = 0;
    assign S_AXI_CTRL_RDATA = 0;
    assign S_AXI_CTRL_RRESP = 0;
    assign S_AXI_CTRL_RVALID = 0;
    assign IRQ = 0;
  end
endgenerate

endmodule

`default_nettype wire
