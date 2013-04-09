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
// File name: crossbar_sasd.v
//
// Description: 
//   This module is a M-master to N-slave AXI crossbar switch.
//   Single transaction issuance, single arbiter (both W&R), single data pathways.
//   The interface of this module consists of a vectored slave and master interface
//     in which all slots are sized and synchronized to the native width and clock 
//     of the interconnect, and are all AXI4 protocol.
//   All width, clock and protocol conversions are done outside this block, as are
//     any pipeline registers or data FIFOs.
//   This module contains all arbitration, decoders and channel multiplexing logic.
//     It also contains the diagnostic registers and control interface.
//
//--------------------------------------------------------------------------
//
// Structure:
//    crossbar_sasd
//      addr_arbiter_sasd
//        mux_enc
//      addr_decoder
//        comparator_static
//      splitter
//      mux_enc
//      axic_register_slice
//      decerr_slave
//      
//-----------------------------------------------------------------------------
`timescale 1ps/1ps
`default_nettype none

module crossbar_sasd #
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
   parameter [511:0] C_S_AXI_ID_WIDTH                 = {16{32'h00000000}}, 
                       // Effective width of S_AXI_AWID, S_AXI_BID, S_AXI_ARID 
                       // and S_AXI_RID for each SI slot.
                       // Format: C_NUM_SLAVE_SLOTS{Bit32}; 
                       // Range: 0 - C_AXI_ID_WIDTH.
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
                       // Range: 0 to 2**C_S_AXI_ID_WIDTH-1.
   parameter [1023:0] C_S_AXI_HIGH_ID                  = {16{64'h00000000_00000000}},
                       // High ID of each SI slot. 
                       // Format: C_NUM_SLAVE_SLOTS{Bit64};
                       // Range: 0 to 2**C_S_AXI_ID_WIDTH-1.
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
   parameter integer C_INTERCONNECT_R_REGISTER        = 0,
                       // Insert register slice on R channel in the crossbar.
                       // Range: 0-8.
   parameter integer C_USE_CTRL_PORT = 0,
                       // Indicates whether diagnostic information is accessible 
                       // via the S_AXI_CTRL interface.
   parameter integer C_USE_INTERRUPT = 1,
                       // If CTRL interface enabled, indicates whether interrupts 
                       // are generated.
   parameter integer C_RANGE_CHECK                    = 0,
                       // 1 = Always check address ranges (DECERR if no valid MI slot).
                       // 0 = Pass all transactions (no DECERR) when only 1 MI slot/range.
   parameter integer C_S_AXI_CTRL_ADDR_WIDTH = 32,
                       // ADDR width of CTRL interface.
   parameter integer C_S_AXI_CTRL_DATA_WIDTH = 32
                       // DATA width of CTRL interface.
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
  localparam P_NUM_MASTER_SLOTS_DE = C_RANGE_CHECK ? C_NUM_MASTER_SLOTS+1 : C_NUM_MASTER_SLOTS;
  localparam P_NUM_MASTER_SLOTS_LOG = (C_NUM_MASTER_SLOTS>1) ? f_ceil_log2(C_NUM_MASTER_SLOTS) : 1;
  localparam P_NUM_MASTER_SLOTS_DE_LOG = (P_NUM_MASTER_SLOTS_DE>1) ? f_ceil_log2(P_NUM_MASTER_SLOTS_DE) : 1;
  localparam P_NUM_SLAVE_SLOTS_LOG = (C_NUM_SLAVE_SLOTS>1) ? f_ceil_log2(C_NUM_SLAVE_SLOTS) : 1;
  localparam P_AXI_AUSER_WIDTH = (C_AXI_AWUSER_WIDTH > C_AXI_ARUSER_WIDTH) ? C_AXI_AWUSER_WIDTH : C_AXI_ARUSER_WIDTH;
  localparam P_AMESG_WIDTH = C_AXI_ID_WIDTH + C_AXI_ADDR_WIDTH + 8+3+2+3+2+4+4 + P_AXI_AUSER_WIDTH;
  localparam P_BMESG_WIDTH = 2 + C_AXI_BUSER_WIDTH;
  localparam P_RMESG_WIDTH = 1+2 + C_INTERCONNECT_DATA_WIDTH + C_AXI_RUSER_WIDTH;
  localparam P_WMESG_WIDTH = 1+1 + C_INTERCONNECT_DATA_WIDTH + C_INTERCONNECT_DATA_WIDTH/8 + C_AXI_WUSER_WIDTH;
  localparam P_M_AXI_SUPPORTS_READ = {1'b1, C_M_AXI_SUPPORTS_READ[0+:C_NUM_MASTER_SLOTS]};
  localparam P_M_AXI_SUPPORTS_WRITE = {1'b1, C_M_AXI_SUPPORTS_WRITE[0+:C_NUM_MASTER_SLOTS]};
  localparam         P_AXILITE_VAL = 2'b10;
  localparam integer P_NONSECURE_BIT = 1; 
  localparam         P_M_AXILITE_MASK = f_m_axilite(0);  // Mask of AxiLite MI-slots
  localparam         P_FIXED = 2'b00;
  localparam         P_ALL_AXILITE = (C_S_AXI_PROTOCOL[C_NUM_SLAVE_SLOTS*32-1:0]  == {C_NUM_SLAVE_SLOTS{ 32'h00000002}}) && 
                                     (C_M_AXI_PROTOCOL[C_NUM_MASTER_SLOTS*32-1:0] == {C_NUM_MASTER_SLOTS{32'h00000002}});
  localparam integer P_BYPASS = 0;
  localparam integer P_LIGHTWT = 7;
  localparam integer P_FULLY_REG = 1;
  localparam integer P_R_REG_CONFIG = C_INTERCONNECT_R_REGISTER == 8 ?  // "Automatic" reg-slice
        (C_RANGE_CHECK ? (P_ALL_AXILITE ? P_LIGHTWT : P_FULLY_REG) : P_BYPASS) :  // Bypass if no R-channel mux
        C_INTERCONNECT_R_REGISTER;

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
  
  // AxiLite protocol flag vector      
  function [C_NUM_MASTER_SLOTS-1:0] f_m_axilite
    (
      input integer null_arg
    );
    integer mi;
    begin
      for (mi=0; mi<C_NUM_MASTER_SLOTS; mi=mi+1) begin
        f_m_axilite[mi] = (C_M_AXI_PROTOCOL[mi*32+:2] == P_AXILITE_VAL);
      end
    end
  endfunction
  
  genvar gen_si_slot;
  genvar gen_mi_slot;
  wire [C_NUM_SLAVE_SLOTS*P_AMESG_WIDTH-1:0]                      si_awmesg          ;
  wire [C_NUM_SLAVE_SLOTS*P_AMESG_WIDTH-1:0]                      si_armesg          ;
  wire [P_AMESG_WIDTH-1:0]                                        aa_amesg         ;
  wire [C_AXI_ID_WIDTH-1:0]                                       mi_aid            ;
  wire [C_AXI_ADDR_WIDTH-1:0]                                     mi_aaddr          ;
  wire [8-1:0]                                                    mi_alen           ;
  wire [3-1:0]                                                    mi_asize          ;
  wire [2-1:0]                                                    mi_alock          ;
  wire [3-1:0]                                                    mi_aprot          ;
  wire [2-1:0]                                                    mi_aburst        ;
  wire [4-1:0]                                                    mi_acache        ;
  wire [4-1:0]                                                    mi_aqos        ;
  wire [P_AXI_AUSER_WIDTH-1:0]                                    mi_auser        ;
  wire [4-1:0]                                                    region        ;
  wire [C_NUM_SLAVE_SLOTS*1-1:0]                                  aa_grant_hot     ;
  wire [P_NUM_SLAVE_SLOTS_LOG-1:0]                                  aa_grant_enc     ;
  wire                                                            aa_grant_rnw ;
  wire [C_NUM_MASTER_SLOTS-1:0]                                   target_mi_hot    ;
  wire [P_NUM_MASTER_SLOTS_LOG-1:0]                                   target_mi_enc    ;
  reg  [P_NUM_MASTER_SLOTS_DE-1:0]                               m_atarget_hot    ;
  reg  [P_NUM_MASTER_SLOTS_DE_LOG-1:0]                               m_atarget_enc    ;
  wire                                                            match;
  wire                                                            mi_error         ;
  wire [P_NUM_MASTER_SLOTS_DE-1:0]                             mi_awvalid            ;
  wire [P_NUM_MASTER_SLOTS_DE-1:0]                             mi_awready            ;
  wire [P_NUM_MASTER_SLOTS_DE-1:0]                             mi_arvalid            ;
  wire [P_NUM_MASTER_SLOTS_DE-1:0]                             mi_arready            ;
  wire                                                            aa_awvalid         ;
  wire                                                            aa_awready         ;
  wire                                                            aa_arvalid         ;
  wire                                                            aa_arready         ;
  wire                                                            mi_awvalid_en;
  wire                                                            mi_awready_mux;
  wire                                                            mi_arvalid_en;
  wire                                                            mi_arready_mux;
  wire                                                            w_transfer_en;
  wire                                                            w_complete_mux;
  wire                                                            b_transfer_en;
  wire                                                            b_complete_mux;
  wire                                                            r_transfer_en;
  wire                                                            r_complete_mux;
  wire                                                            target_secure;
  wire                                                            target_axilite;
  wire                                                            target_write;
  wire                                                            target_read;
  
  wire [P_BMESG_WIDTH-1:0]                                        si_bmesg           ;
  wire [P_NUM_MASTER_SLOTS_DE*P_BMESG_WIDTH-1:0]                 mi_bmesg           ;
  wire [P_NUM_MASTER_SLOTS_DE*2-1:0]                             mi_bresp           ;
  wire [P_NUM_MASTER_SLOTS_DE*C_AXI_BUSER_WIDTH-1:0]             mi_buser           ;
  wire [2-1:0]                                                    si_bresp           ;
  wire [C_AXI_BUSER_WIDTH-1:0]                                    si_buser           ;
  wire [P_NUM_MASTER_SLOTS_DE-1:0]                             mi_bvalid          ;
  wire [P_NUM_MASTER_SLOTS_DE-1:0]                             mi_bready          ;
  wire                                                            aa_bvalid          ;
  wire                                                            aa_bready         ;
  wire                                                            si_bready         ;
  wire [C_NUM_SLAVE_SLOTS-1:0]                                    si_bvalid;
  
  wire [P_RMESG_WIDTH-1:0]                                        aa_rmesg           ;
  wire [P_RMESG_WIDTH-1:0]                                        sr_rmesg           ;
  wire [P_NUM_MASTER_SLOTS_DE*P_RMESG_WIDTH-1:0]                 mi_rmesg           ;
  wire [P_NUM_MASTER_SLOTS_DE*2-1:0]                             mi_rresp           ;
  wire [P_NUM_MASTER_SLOTS_DE*C_AXI_RUSER_WIDTH-1:0]             mi_ruser           ;
  wire [P_NUM_MASTER_SLOTS_DE*C_AXI_DATA_MAX_WIDTH-1:0]          mi_rdata              ;
  wire [P_NUM_MASTER_SLOTS_DE*1-1:0]                             mi_rlast              ;
  wire [2-1:0]                                                    si_rresp           ;
  wire [C_AXI_RUSER_WIDTH-1:0]                                    si_ruser           ;
  wire [C_AXI_DATA_MAX_WIDTH-1:0]                                 si_rdata              ;
  wire                                                            si_rlast              ;
  wire [P_NUM_MASTER_SLOTS_DE-1:0]                             mi_rvalid          ;
  wire [P_NUM_MASTER_SLOTS_DE-1:0]                             mi_rready          ;
  wire                                                            aa_rvalid          ;
  wire                                                            aa_rready         ;
  wire                                                            sr_rvalid          ;
  wire                                                            si_rready         ;
  wire                                                            sr_rready         ;
  wire [C_NUM_SLAVE_SLOTS-1:0]                                    si_rvalid;
  
  wire [C_NUM_SLAVE_SLOTS*P_WMESG_WIDTH-1:0]                      si_wmesg           ;
  wire [P_WMESG_WIDTH-1:0]                                        mi_wmesg           ;
  wire [C_INTERCONNECT_DATA_WIDTH-1:0]                            mi_wdata              ;
  wire [C_INTERCONNECT_DATA_WIDTH/8-1:0]                          mi_wstrb              ;
  wire [C_AXI_WUSER_WIDTH-1:0]                                    mi_wuser              ;
  wire [1-1:0]                                                    mi_wlast              ;
  wire [P_NUM_MASTER_SLOTS_DE-1:0]                             mi_wvalid          ;
  wire [P_NUM_MASTER_SLOTS_DE-1:0]                             mi_wready          ;
  wire                                                            aa_wvalid          ;
  wire                                                            aa_wready         ;
  wire [C_NUM_SLAVE_SLOTS-1:0]                                    si_wready;

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
    
    addr_arbiter_sasd #
      (
       .C_FAMILY                (C_FAMILY),
       .C_NUM_S                 (C_NUM_SLAVE_SLOTS),
       .C_NUM_S_LOG             (P_NUM_SLAVE_SLOTS_LOG),
       .C_AMESG_WIDTH            (P_AMESG_WIDTH),
       .C_GRANT_ENC             (1),
       .C_ARB_PRIORITY          (C_S_AXI_ARB_PRIORITY)
       )
      addr_arbiter_inst
        (
         .ACLK                  (INTERCONNECT_ACLK),
         .ARESET                (reset),
         // Vector of SI-side AW command request inputs
         .S_AWMESG                (si_awmesg),
         .S_ARMESG                (si_armesg),
         .S_AWVALID               (S_AXI_AWVALID),
         .S_AWREADY               (S_AXI_AWREADY),
         .S_ARVALID               (S_AXI_ARVALID),
         .S_ARREADY               (S_AXI_ARREADY),
         .M_GRANT_ENC           (aa_grant_enc),
         .M_GRANT_HOT           (aa_grant_hot),  // SI-slot 1-hot mask of granted command
         .M_GRANT_RNW             (aa_grant_rnw),
         .M_AMESG                (aa_amesg),  // Either S_AWMESG or S_ARMESG, as indicated by M_AWVALID and M_ARVALID.
         .M_AWVALID               (aa_awvalid),
         .M_AWREADY               (aa_awready),
         .M_ARVALID               (aa_arvalid),
         .M_ARREADY               (aa_arready)
         );
         
    if (P_ADDR_DECODE) begin : gen_addr_decoder
      addr_decoder #
        (
          .C_FAMILY          (C_FAMILY),
          .C_NUM_TARGETS     (C_NUM_MASTER_SLOTS),
          .C_NUM_TARGETS_LOG (P_NUM_MASTER_SLOTS_LOG),
          .C_NUM_RANGES      (C_NUM_ADDR_RANGES),
          .C_ADDR_WIDTH      (C_AXI_ADDR_WIDTH),
          .C_TARGET_ENC      (1),
          .C_TARGET_HOT      (1),
          .C_REGION_ENC      (1),
          .C_BASE_ADDR      (C_M_AXI_BASE_ADDR),
          .C_HIGH_ADDR      (C_M_AXI_HIGH_ADDR),
          .C_TARGET_QUAL     ({C_NUM_MASTER_SLOTS{1'b1}}),
          .C_RESOLUTION      (12)
        ) 
        addr_decoder_inst 
        (
          .ADDR             (mi_aaddr),        
          .TARGET_HOT       (target_mi_hot),  
          .TARGET_ENC       (target_mi_enc),  
          .MATCH            (match),       
          .REGION           (region)      
        );
    end else begin : gen_no_addr_decoder
      assign target_mi_hot = 1;
      assign match = 1'b1;
      assign region = 4'b0000;
    end
    
    // AW-channel arbiter command transfer completes upon completion of both M-side AW-channel transfer and B channel completion.
    splitter #  
      (
        .C_NUM_M                (3)
      )
      splitter_aw
      (
         .ACLK                  (INTERCONNECT_ACLK),
         .ARESET                (reset),
         .S_VALID              (aa_awvalid),
         .S_READY              (aa_awready),
         .M_VALID              ({mi_awvalid_en, w_transfer_en, b_transfer_en}),
         .M_READY              ({mi_awready_mux, w_complete_mux, b_complete_mux})
      );
    
    // AR-channel arbiter command transfer completes upon completion of both M-side AR-channel transfer and R channel completion.
    splitter #  
      (
        .C_NUM_M                (2)
      )
      splitter_ar
      (
         .ACLK                  (INTERCONNECT_ACLK),
         .ARESET                (reset),
         .S_VALID              (aa_arvalid),
         .S_READY              (aa_arready),
         .M_VALID              ({mi_arvalid_en, r_transfer_en}),
         .M_READY              ({mi_arready_mux, r_complete_mux})
      );
    
    assign target_secure = |(target_mi_hot & C_M_AXI_SECURE);
    assign target_axilite = |(target_mi_hot & P_M_AXILITE_MASK);
    assign target_write = |(target_mi_hot & C_M_AXI_SUPPORTS_WRITE);
    assign target_read = |(target_mi_hot & C_M_AXI_SUPPORTS_READ);
    assign mi_error = C_RANGE_CHECK &  // DECERR if error-detection enabled and either ...
      (~match ||  // the granted SI has an invalid address, or...
      (target_secure && mi_aprot[P_NONSECURE_BIT]) ||  // TrustZone violation, or ...
      (target_axilite && ((mi_alen != 0) || (mi_asize[1:0] == 2'b11) || (mi_asize[2] == 1'b1))) ||  // AxiLite violation, or ...
      (~aa_grant_rnw && ~target_write) ||
      (aa_grant_rnw && ~target_read));
      
    always @(posedge INTERCONNECT_ACLK) begin
      if (reset) begin
        m_atarget_hot <= 0;
      end else begin
        m_atarget_hot <= mi_error ? {1'b1, {C_NUM_MASTER_SLOTS{1'b0}}} : {1'b0, target_mi_hot};  // Select MI slot or decerr_slave
      end
      m_atarget_enc <= mi_error ? (P_NUM_MASTER_SLOTS_DE-1) : target_mi_enc;  // Select MI slot or decerr_slave
    end
    
    // Receive AWREADY from targeted MI.
    mux_enc # 
      (
       .C_FAMILY      (C_FAMILY),
       .C_RATIO       (P_NUM_MASTER_SLOTS_DE),
       .C_SEL_WIDTH   (P_NUM_MASTER_SLOTS_DE_LOG),
       .C_DATA_WIDTH  (1)
      ) mi_awready_mux_inst 
      (
       .S   (m_atarget_enc),
       .A   (mi_awready),
       .O   (mi_awready_mux),
       .OE  (mi_awvalid_en)
      ); 
      
    // Receive ARREADY from targeted MI.
    mux_enc # 
      (
       .C_FAMILY      (C_FAMILY),
       .C_RATIO       (P_NUM_MASTER_SLOTS_DE),
       .C_SEL_WIDTH   (P_NUM_MASTER_SLOTS_DE_LOG),
       .C_DATA_WIDTH  (1)
      ) mi_arready_mux_inst 
      (
       .S   (m_atarget_enc),
       .A   (mi_arready),
       .O   (mi_arready_mux),
       .OE  (mi_arvalid_en)
      ); 
      
    assign mi_awvalid = m_atarget_hot & {P_NUM_MASTER_SLOTS_DE{mi_awvalid_en}};  // Assert AWVALID on targeted MI.
    assign mi_arvalid = m_atarget_hot & {P_NUM_MASTER_SLOTS_DE{mi_arvalid_en}};  // Assert ARVALID on targeted MI.
    assign M_AXI_AWVALID = mi_awvalid[0+:C_NUM_MASTER_SLOTS];  // Propagate to MI slots.
    assign M_AXI_ARVALID = mi_arvalid[0+:C_NUM_MASTER_SLOTS];  // Propagate to MI slots.
    assign mi_awready[0+:C_NUM_MASTER_SLOTS] = M_AXI_AWREADY;  // Copy from MI slots.
    assign mi_arready[0+:C_NUM_MASTER_SLOTS] = M_AXI_ARREADY;  // Copy from MI slots.
    
    // Receive WREADY from targeted MI.
    mux_enc # 
      (
       .C_FAMILY      (C_FAMILY),
       .C_RATIO       (P_NUM_MASTER_SLOTS_DE),
       .C_SEL_WIDTH   (P_NUM_MASTER_SLOTS_DE_LOG),
       .C_DATA_WIDTH  (1)
      ) mi_wready_mux_inst 
      (
       .S   (m_atarget_enc),
       .A   (mi_wready),
       .O   (aa_wready),
       .OE  (w_transfer_en)
      ); 
      
    assign mi_wvalid = m_atarget_hot & {P_NUM_MASTER_SLOTS_DE{aa_wvalid}};  // Assert WVALID on targeted MI.
    assign si_wready = aa_grant_hot & {C_NUM_SLAVE_SLOTS{aa_wready}};  // Assert WREADY on granted SI.
    assign S_AXI_WREADY = si_wready;
    assign w_complete_mux = aa_wready & aa_wvalid & mi_wlast;  // W burst complete on on designated SI/MI.
    
    // Receive RREADY from granted SI.
    mux_enc # 
      (
       .C_FAMILY      (C_FAMILY),
       .C_RATIO       (C_NUM_SLAVE_SLOTS),
       .C_SEL_WIDTH   (P_NUM_SLAVE_SLOTS_LOG),
       .C_DATA_WIDTH  (1)
      ) si_rready_mux_inst 
      (
       .S   (aa_grant_enc),
       .A   (S_AXI_RREADY),
       .O   (si_rready),
       .OE  (r_transfer_en)
      ); 
      
    assign sr_rready = si_rready & r_transfer_en;
    assign mi_rready = m_atarget_hot & {P_NUM_MASTER_SLOTS_DE{aa_rready}};  // Assert RREADY on targeted MI.
    assign si_rvalid = aa_grant_hot & {C_NUM_SLAVE_SLOTS{sr_rvalid}};  // Assert RVALID on granted SI.
    assign S_AXI_RVALID = si_rvalid;
    assign r_complete_mux = sr_rready & sr_rvalid & si_rlast;  // R burst complete on on designated SI/MI.
    
    // Receive BREADY from granted SI.
    mux_enc # 
      (
       .C_FAMILY      (C_FAMILY),
       .C_RATIO       (C_NUM_SLAVE_SLOTS),
       .C_SEL_WIDTH   (P_NUM_SLAVE_SLOTS_LOG),
       .C_DATA_WIDTH  (1)
      ) si_bready_mux_inst 
      (
       .S   (aa_grant_enc),
       .A   (S_AXI_BREADY),
       .O   (si_bready),
       .OE  (b_transfer_en)
      ); 
      
    assign aa_bready = si_bready & b_transfer_en;
    assign mi_bready = m_atarget_hot & {P_NUM_MASTER_SLOTS_DE{aa_bready}};  // Assert BREADY on targeted MI.
    assign si_bvalid = aa_grant_hot & {C_NUM_SLAVE_SLOTS{aa_bvalid}};  // Assert BVALID on granted SI.
    assign S_AXI_BVALID = si_bvalid;
    assign b_complete_mux = aa_bready & aa_bvalid;  // B transfer complete on on designated SI/MI.
    
    for (gen_si_slot=0; gen_si_slot<C_NUM_SLAVE_SLOTS; gen_si_slot=gen_si_slot+1) begin : gen_si_amesg
      assign si_armesg[gen_si_slot*P_AMESG_WIDTH +: P_AMESG_WIDTH] = {  // Concatenate from MSB to LSB
        S_AXI_ARUSER[gen_si_slot*C_AXI_ARUSER_WIDTH +: C_AXI_ARUSER_WIDTH],
        S_AXI_ARQOS[gen_si_slot*4+:4],
        S_AXI_ARCACHE[gen_si_slot*4+:4],
        S_AXI_ARBURST[gen_si_slot*2+:2],
        S_AXI_ARPROT[gen_si_slot*3+:3],
        S_AXI_ARLOCK[gen_si_slot*2+:2],
        S_AXI_ARSIZE[gen_si_slot*3+:3],
        S_AXI_ARLEN[gen_si_slot*8+:8],
        S_AXI_ARADDR[gen_si_slot*C_AXI_ADDR_WIDTH +: C_AXI_ADDR_WIDTH],
        f_extend_ID(S_AXI_ARID[gen_si_slot*C_AXI_ID_WIDTH +: C_AXI_ID_WIDTH], gen_si_slot)
        };
      assign si_awmesg[gen_si_slot*P_AMESG_WIDTH +: P_AMESG_WIDTH] = {  // Concatenate from MSB to LSB
        S_AXI_AWUSER[gen_si_slot*C_AXI_AWUSER_WIDTH +: C_AXI_AWUSER_WIDTH],
        S_AXI_AWQOS[gen_si_slot*4+:4],
        S_AXI_AWCACHE[gen_si_slot*4+:4],
        S_AXI_AWBURST[gen_si_slot*2+:2],
        S_AXI_AWPROT[gen_si_slot*3+:3],
        S_AXI_AWLOCK[gen_si_slot*2+:2],
        S_AXI_AWSIZE[gen_si_slot*3+:3],
        S_AXI_AWLEN[gen_si_slot*8+:8],
        S_AXI_AWADDR[gen_si_slot*C_AXI_ADDR_WIDTH +: C_AXI_ADDR_WIDTH],
        f_extend_ID(S_AXI_AWID[gen_si_slot*C_AXI_ID_WIDTH+:C_AXI_ID_WIDTH], gen_si_slot)
        };
    end  // gen_si_amesg
      
    assign mi_aid        = aa_amesg[0 +: C_AXI_ID_WIDTH];
    assign mi_aaddr      = aa_amesg[C_AXI_ID_WIDTH +: C_AXI_ADDR_WIDTH];
    assign mi_alen       = aa_amesg[C_AXI_ID_WIDTH+C_AXI_ADDR_WIDTH +: 8];
    assign mi_asize      = aa_amesg[C_AXI_ID_WIDTH+C_AXI_ADDR_WIDTH+8 +: 3];
    assign mi_alock      = aa_amesg[C_AXI_ID_WIDTH+C_AXI_ADDR_WIDTH+8+3 +: 2];
    assign mi_aprot      = aa_amesg[C_AXI_ID_WIDTH+C_AXI_ADDR_WIDTH+8+3+2 +: 3];
    assign mi_aburst     = aa_amesg[C_AXI_ID_WIDTH+C_AXI_ADDR_WIDTH+8+3+2+3 +: 2];
    assign mi_acache     = aa_amesg[C_AXI_ID_WIDTH+C_AXI_ADDR_WIDTH+8+3+2+3+2 +: 4];
    assign mi_aqos       = aa_amesg[C_AXI_ID_WIDTH+C_AXI_ADDR_WIDTH+8+3+2+3+2+4 +: 4];
    assign mi_auser      = aa_amesg[C_AXI_ID_WIDTH+C_AXI_ADDR_WIDTH+8+3+2+3+2+4+4 +: P_AXI_AUSER_WIDTH];
    
    // Broadcast AW transfer payload to all MI-slots
    assign M_AXI_AWID        = {C_NUM_MASTER_SLOTS{mi_aid}};
    assign M_AXI_AWADDR      = {C_NUM_MASTER_SLOTS{mi_aaddr}};
    assign M_AXI_AWLEN       = {C_NUM_MASTER_SLOTS{mi_alen }};
    assign M_AXI_AWSIZE      = {C_NUM_MASTER_SLOTS{mi_asize}};
    assign M_AXI_AWLOCK      = {C_NUM_MASTER_SLOTS{mi_alock}};
    assign M_AXI_AWPROT      = {C_NUM_MASTER_SLOTS{mi_aprot}};
    assign M_AXI_AWREGION    = {C_NUM_MASTER_SLOTS{region}};
    assign M_AXI_AWBURST     = {C_NUM_MASTER_SLOTS{mi_aburst}};
    assign M_AXI_AWCACHE     = {C_NUM_MASTER_SLOTS{mi_acache}};
    assign M_AXI_AWQOS       = {C_NUM_MASTER_SLOTS{mi_aqos  }};
    assign M_AXI_AWUSER      = {C_NUM_MASTER_SLOTS{mi_auser[0+:C_AXI_AWUSER_WIDTH] }};
    
    // Broadcast AR transfer payload to all MI-slots
    assign M_AXI_ARID        = {C_NUM_MASTER_SLOTS{mi_aid}};
    assign M_AXI_ARADDR      = {C_NUM_MASTER_SLOTS{mi_aaddr}};                        
    assign M_AXI_ARLEN       = {C_NUM_MASTER_SLOTS{mi_alen }};                        
    assign M_AXI_ARSIZE      = {C_NUM_MASTER_SLOTS{mi_asize}};                        
    assign M_AXI_ARLOCK      = {C_NUM_MASTER_SLOTS{mi_alock}};                        
    assign M_AXI_ARPROT      = {C_NUM_MASTER_SLOTS{mi_aprot}};                        
    assign M_AXI_ARREGION    = {C_NUM_MASTER_SLOTS{region}};                          
    assign M_AXI_ARBURST     = {C_NUM_MASTER_SLOTS{mi_aburst}};                       
    assign M_AXI_ARCACHE     = {C_NUM_MASTER_SLOTS{mi_acache}};                       
    assign M_AXI_ARQOS       = {C_NUM_MASTER_SLOTS{mi_aqos  }};                       
    assign M_AXI_ARUSER      = {C_NUM_MASTER_SLOTS{mi_auser[0+:C_AXI_ARUSER_WIDTH] }};
    
    // W-channel MI handshakes
    assign M_AXI_WVALID = mi_wvalid[0+:C_NUM_MASTER_SLOTS];
    assign mi_wready[0+:C_NUM_MASTER_SLOTS] = M_AXI_WREADY;
    // Broadcast W transfer payload to all MI-slots
    assign M_AXI_WLAST = {C_NUM_MASTER_SLOTS{mi_wlast}};
    assign M_AXI_WUSER = {C_NUM_MASTER_SLOTS{mi_wuser}};
    for (gen_mi_slot=0; gen_mi_slot<C_NUM_MASTER_SLOTS; gen_mi_slot=gen_mi_slot+1) begin : gen_mi_wdata
      assign M_AXI_WDATA[gen_mi_slot*C_AXI_DATA_MAX_WIDTH+:C_AXI_DATA_MAX_WIDTH] = mi_wdata;
      assign M_AXI_WSTRB[gen_mi_slot*C_AXI_DATA_MAX_WIDTH/8+:C_AXI_DATA_MAX_WIDTH/8] = mi_wstrb;
    end
    
    // Broadcast R transfer payload to all SI-slots
    assign S_AXI_RLAST = {C_NUM_SLAVE_SLOTS{si_rlast}};
    assign S_AXI_RRESP = {C_NUM_SLAVE_SLOTS{si_rresp}};
    assign S_AXI_RUSER = {C_NUM_SLAVE_SLOTS{si_ruser}};
    for (gen_si_slot=0; gen_si_slot<C_NUM_SLAVE_SLOTS; gen_si_slot=gen_si_slot+1) begin : gen_si_rdata
      assign S_AXI_RDATA[gen_si_slot*C_AXI_DATA_MAX_WIDTH+:C_AXI_DATA_MAX_WIDTH] = si_rdata;
    end
    assign S_AXI_RID = {C_NUM_SLAVE_SLOTS{mi_aid}};
    
    // Broadcast B transfer payload to all SI-slots
    assign S_AXI_BRESP = {C_NUM_SLAVE_SLOTS{si_bresp}};
    assign S_AXI_BUSER = {C_NUM_SLAVE_SLOTS{si_buser}};
    assign S_AXI_BID = {C_NUM_SLAVE_SLOTS{mi_aid}};
    
    // W-channel SI mux
    if (C_NUM_SLAVE_SLOTS>1) begin : gen_wmux
      mux_enc # 
        (
         .C_FAMILY      (C_FAMILY),
         .C_RATIO       (C_NUM_SLAVE_SLOTS),
         .C_SEL_WIDTH   (P_NUM_SLAVE_SLOTS_LOG),
         .C_DATA_WIDTH  (P_WMESG_WIDTH)
        ) si_w_payload_mux_inst 
        (
         .S   (aa_grant_enc),
         .A   (si_wmesg),
         .O   (mi_wmesg),
         .OE  (1'b1)
        ); 
        
      for (gen_si_slot=0; gen_si_slot<C_NUM_SLAVE_SLOTS; gen_si_slot=gen_si_slot+1) begin : gen_wmesg
        assign si_wmesg[gen_si_slot*P_WMESG_WIDTH+:P_WMESG_WIDTH] = {  // Concatenate from MSB to LSB
          S_AXI_WUSER[gen_si_slot*C_AXI_WUSER_WIDTH+:C_AXI_WUSER_WIDTH],
          S_AXI_WSTRB[gen_si_slot*C_AXI_DATA_MAX_WIDTH/8+:C_INTERCONNECT_DATA_WIDTH/8],
          S_AXI_WDATA[gen_si_slot*C_AXI_DATA_MAX_WIDTH+:C_INTERCONNECT_DATA_WIDTH],
          S_AXI_WLAST[gen_si_slot*1+:1],
          S_AXI_WVALID[gen_si_slot*1+:1]
        };
      end  // gen_wmesg
      
      assign aa_wvalid = w_transfer_en & mi_wmesg[0];
      assign mi_wlast = mi_wmesg[1];
      assign mi_wdata = mi_wmesg[2 +: C_INTERCONNECT_DATA_WIDTH];
      assign mi_wstrb = mi_wmesg[2+C_INTERCONNECT_DATA_WIDTH +: C_INTERCONNECT_DATA_WIDTH/8];
      assign mi_wuser = mi_wmesg[2+C_INTERCONNECT_DATA_WIDTH+C_INTERCONNECT_DATA_WIDTH/8 +: C_AXI_WUSER_WIDTH];
    end else begin : gen_no_wmux
      assign aa_wvalid = w_transfer_en & S_AXI_WVALID;
      assign mi_wlast  = S_AXI_WLAST;
      assign mi_wdata  = S_AXI_WDATA[0+:C_INTERCONNECT_DATA_WIDTH];
      assign mi_wstrb  = S_AXI_WSTRB[0+:C_INTERCONNECT_DATA_WIDTH/8];
      assign mi_wuser  = S_AXI_WUSER;
    end  // gen_wmux
    
    // Receive RVALID from targeted MI.
    mux_enc # 
      (
       .C_FAMILY      (C_FAMILY),
       .C_RATIO       (P_NUM_MASTER_SLOTS_DE),
       .C_SEL_WIDTH   (P_NUM_MASTER_SLOTS_DE_LOG),
       .C_DATA_WIDTH  (1)
      ) mi_rvalid_mux_inst 
      (
       .S   (m_atarget_enc),
       .A   (mi_rvalid),
       .O   (aa_rvalid),
       .OE  (r_transfer_en)
      ); 
      
    // MI R-channel payload mux
    mux_enc # 
      (
       .C_FAMILY      (C_FAMILY),
       .C_RATIO       (P_NUM_MASTER_SLOTS_DE),
       .C_SEL_WIDTH   (P_NUM_MASTER_SLOTS_DE_LOG),
       .C_DATA_WIDTH  (P_RMESG_WIDTH)
      ) mi_rmesg_mux_inst 
      (
       .S   (m_atarget_enc),
       .A   (mi_rmesg),
       .O   (aa_rmesg),
       .OE  (1'b1)
      ); 
      
    axic_register_slice #
      (
       .C_FAMILY (C_FAMILY),
       .C_DATA_WIDTH (P_RMESG_WIDTH),
       .C_REG_CONFIG (P_R_REG_CONFIG)
       )
      reg_slice_r
      (
       // System Signals
       .ACLK(INTERCONNECT_ACLK),
       .ARESET(reset),

       // Slave side
       .S_PAYLOAD_DATA(aa_rmesg),
       .S_VALID(aa_rvalid),
       .S_READY(aa_rready),

       // Master side
       .M_PAYLOAD_DATA(sr_rmesg),
       .M_VALID(sr_rvalid),
       .M_READY(sr_rready)
       );

    assign mi_rvalid[0+:C_NUM_MASTER_SLOTS] = M_AXI_RVALID; 
    assign mi_rlast[0+:C_NUM_MASTER_SLOTS] = M_AXI_RLAST; 
    assign mi_rresp[0+:C_NUM_MASTER_SLOTS*2] = M_AXI_RRESP;
    assign mi_ruser[0+:C_NUM_MASTER_SLOTS*C_AXI_RUSER_WIDTH] = M_AXI_RUSER;
    assign mi_rdata[0+:C_NUM_MASTER_SLOTS*C_AXI_DATA_MAX_WIDTH] = M_AXI_RDATA;
    assign M_AXI_RREADY = mi_rready[0+:C_NUM_MASTER_SLOTS];
    
    for (gen_mi_slot=0; gen_mi_slot<P_NUM_MASTER_SLOTS_DE; gen_mi_slot=gen_mi_slot+1) begin : gen_rmesg
      assign mi_rmesg[gen_mi_slot*P_RMESG_WIDTH+:P_RMESG_WIDTH] = {  // Concatenate from MSB to LSB
        mi_ruser[gen_mi_slot*C_AXI_RUSER_WIDTH+:C_AXI_RUSER_WIDTH],
        mi_rdata[gen_mi_slot*C_AXI_DATA_MAX_WIDTH+:C_INTERCONNECT_DATA_WIDTH],
        mi_rresp[gen_mi_slot*2+:2],
        mi_rlast[gen_mi_slot*1+:1]
      };
    end  // gen_rmesg
    
    assign si_rlast = sr_rmesg[0];
    assign si_rresp = sr_rmesg[1 +: 2];
    assign si_rdata = sr_rmesg[1+2 +: C_INTERCONNECT_DATA_WIDTH];
    assign si_ruser = sr_rmesg[1+2+C_INTERCONNECT_DATA_WIDTH +: C_AXI_RUSER_WIDTH];
    
    // Receive BVALID from targeted MI.
    mux_enc # 
      (
       .C_FAMILY      (C_FAMILY),
       .C_RATIO       (P_NUM_MASTER_SLOTS_DE),
       .C_SEL_WIDTH   (P_NUM_MASTER_SLOTS_DE_LOG),
       .C_DATA_WIDTH  (1)
      ) mi_bvalid_mux_inst 
      (
       .S   (m_atarget_enc),
       .A   (mi_bvalid),
       .O   (aa_bvalid),
       .OE  (b_transfer_en)
      ); 
      
    // MI B-channel payload mux
    mux_enc # 
      (
       .C_FAMILY      (C_FAMILY),
       .C_RATIO       (P_NUM_MASTER_SLOTS_DE),
       .C_SEL_WIDTH   (P_NUM_MASTER_SLOTS_DE_LOG),
       .C_DATA_WIDTH  (P_BMESG_WIDTH)
      ) mi_bmesg_mux_inst 
      (
       .S   (m_atarget_enc),
       .A   (mi_bmesg),
       .O   (si_bmesg),
       .OE  (1'b1)
      ); 
      
    assign mi_bvalid[0+:C_NUM_MASTER_SLOTS] = M_AXI_BVALID; 
    assign mi_bresp[0+:C_NUM_MASTER_SLOTS*2] = M_AXI_BRESP;
    assign mi_buser[0+:C_NUM_MASTER_SLOTS*C_AXI_BUSER_WIDTH] = M_AXI_BUSER;
    assign M_AXI_BREADY = mi_bready[0+:C_NUM_MASTER_SLOTS];
    
    for (gen_mi_slot=0; gen_mi_slot<P_NUM_MASTER_SLOTS_DE; gen_mi_slot=gen_mi_slot+1) begin : gen_bmesg
      assign mi_bmesg[gen_mi_slot*P_BMESG_WIDTH+:P_BMESG_WIDTH] = {  // Concatenate from MSB to LSB
        mi_buser[gen_mi_slot*C_AXI_BUSER_WIDTH+:C_AXI_BUSER_WIDTH],
        mi_bresp[gen_mi_slot*2+:2]
      };
    end  // gen_bmesg
    
    assign si_bresp = si_bmesg[0 +: 2];
    assign si_buser = si_bmesg[2 +: C_AXI_BUSER_WIDTH];
    
    if (C_RANGE_CHECK) begin : gen_decerr
      // Highest MI-slot (index C_NUM_MASTER_SLOTS) is the error handler
      decerr_slave #
        (
         .C_AXI_ID_WIDTH                 (1),
         .C_AXI_DATA_WIDTH               (C_INTERCONNECT_DATA_WIDTH),
         .C_AXI_RUSER_WIDTH                (C_AXI_RUSER_WIDTH),
         .C_AXI_BUSER_WIDTH                (C_AXI_BUSER_WIDTH)
        )
        decerr_slave_inst
          (
           .S_AXI_ACLK (INTERCONNECT_ACLK),
           .S_AXI_ARESET (reset),
           .S_AXI_AWID (1'b0),
           .S_AXI_AWVALID (mi_awvalid[C_NUM_MASTER_SLOTS]),
           .S_AXI_AWREADY (mi_awready[C_NUM_MASTER_SLOTS]),
           .S_AXI_WLAST (mi_wlast),
           .S_AXI_WVALID (mi_wvalid[C_NUM_MASTER_SLOTS]),
           .S_AXI_WREADY (mi_wready[C_NUM_MASTER_SLOTS]),
           .S_AXI_BID (),
           .S_AXI_BRESP (mi_bresp[C_NUM_MASTER_SLOTS*2+:2]),
           .S_AXI_BUSER (mi_buser[C_NUM_MASTER_SLOTS*C_AXI_BUSER_WIDTH+:C_AXI_BUSER_WIDTH]),
           .S_AXI_BVALID (mi_bvalid[C_NUM_MASTER_SLOTS]),
           .S_AXI_BREADY (mi_bready[C_NUM_MASTER_SLOTS]),
           .S_AXI_ARID (1'b0),
           .S_AXI_ARLEN (mi_alen),
           .S_AXI_ARVALID (mi_arvalid[C_NUM_MASTER_SLOTS]),
           .S_AXI_ARREADY (mi_arready[C_NUM_MASTER_SLOTS]),
           .S_AXI_RID (),
           .S_AXI_RDATA (mi_rdata[C_NUM_MASTER_SLOTS*C_AXI_DATA_MAX_WIDTH+:C_INTERCONNECT_DATA_WIDTH]),
           .S_AXI_RRESP (mi_rresp[C_NUM_MASTER_SLOTS*2+:2]),
           .S_AXI_RUSER (mi_ruser[C_NUM_MASTER_SLOTS*C_AXI_RUSER_WIDTH+:C_AXI_RUSER_WIDTH]),
           .S_AXI_RLAST (mi_rlast[C_NUM_MASTER_SLOTS]),
           .S_AXI_RVALID (mi_rvalid[C_NUM_MASTER_SLOTS]),
           .S_AXI_RREADY (mi_rready[C_NUM_MASTER_SLOTS])
         );
    end  // gen_decerr

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
