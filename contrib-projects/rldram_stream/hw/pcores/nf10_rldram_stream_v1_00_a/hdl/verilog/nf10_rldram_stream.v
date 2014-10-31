/*******************************************************************************
*
*  NetFPGA-10G http://www.netfpga.org
*
*  File:
*        nf10_rldram_stream.v
*
*  Library:
*        nf10_rldram_axi_stream_v1_00_a
*
*  Module:
*        nf10_rldram_stream
*
*  Author:
*        Jong Hun Han
*
*  Description:
*
*
*  Copyright notice:
*        Copyright (C) 2014 University of Cambridge
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
`timescale 1ns / 1ps

`uselib lib=unisims_ver
`uselib lib=proc_common_v3_00_a

module nf10_rldram_stream
#(
   //AXI Stream Data Width
   parameter   C_M_AXIS_DATA_WIDTH     = 256,
   parameter   C_S_AXIS_DATA_WIDTH     = 256,
   parameter   C_M_AXIS_TUSER_WIDTH    = 128,
   parameter   C_S_AXIS_TUSER_WIDTH    = 128,

   parameter   C_FAMILY                = "virtex5",
   parameter   C_S_AXI_DATA_WIDTH      = 32,
   parameter   C_S_AXI_ADDR_WIDTH      = 32,
   parameter   C_USE_WSTRB             = 0,
   parameter   C_DPHASE_TIMEOUT        = 0,
   parameter   C_BASEADDR              = 32'hFFFFFFFF,
   parameter   C_HIGHADDR              = 32'h00000000,
   parameter   C_S_AXI_ACLK_FREQ_HZ    = 100,
               
   parameter   RL_DQ_WIDTH             = 72,
   parameter   DEV_DQ_WIDTH            = 36,  //Data width of the memory device
   parameter   NUM_OF_DEVS             = RL_DQ_WIDTH/DEV_DQ_WIDTH, //Number of memory devices
   parameter   NUM_OF_DKS              = (DEV_DQ_WIDTH == 36) ? 2*NUM_OF_DEVS : NUM_OF_DEVS,
   parameter   DEV_AD_WIDTH            = 20,  //Address width of the memory device
   parameter   RL_MRS_CONF             = 3'b011, //3'b001: mode1;  3'b010: mode2;  3'b011: mode3
   parameter   DEV_BA_WIDTH            = 3 //Bank address width of the memory device
)
(
   //Axi Stream Clock and Reset
   input                                           axi_aclk,
   input                                           axi_resetn,

   //Axi Slave Stream Ports
   input          [C_S_AXIS_DATA_WIDTH-1:0]        s_axis_tdata,
   input          [((C_S_AXIS_DATA_WIDTH/8))-1:0]  s_axis_tstrb,
   input          [C_S_AXIS_TUSER_WIDTH-1:0]       s_axis_tuser,
   input                                           s_axis_tvalid,
   output   reg                                    s_axis_tready,
   input                                           s_axis_tlast,

   //Master Stream Ports
   output         [C_M_AXIS_DATA_WIDTH-1:0]        m_axis_tdata,
   output         [((C_M_AXIS_DATA_WIDTH/8))-1:0]  m_axis_tstrb,
   output         [C_M_AXIS_TUSER_WIDTH-1:0]       m_axis_tuser,
   output                                          m_axis_tvalid,
   input                                           m_axis_tready,
   output                                          m_axis_tlast,
   
 //AXI-lite Slave Ports
   input                                           S_AXI_ACLK,
   input                                           S_AXI_ARESETN,
   input          [C_S_AXI_ADDR_WIDTH-1:0]         S_AXI_AWADDR,
   input                                           S_AXI_AWVALID,
   input          [C_S_AXI_DATA_WIDTH-1:0]         S_AXI_WDATA,
   input          [C_S_AXI_DATA_WIDTH/8-1:0]       S_AXI_WSTRB,
   input                                           S_AXI_WVALID,
   input                                           S_AXI_BREADY,
   input          [C_S_AXI_ADDR_WIDTH-1:0]         S_AXI_ARADDR,
   input                                           S_AXI_ARVALID,
   input                                           S_AXI_RREADY,
   output                                          S_AXI_ARREADY,
   output         [C_S_AXI_DATA_WIDTH-1:0]         S_AXI_RDATA,
   output         [1:0]                            S_AXI_RRESP,
   output                                          S_AXI_RVALID,
   output                                          S_AXI_WREADY,
   output         [1:0]                            S_AXI_BRESP,
   output                                          S_AXI_BVALID,
   output                                          S_AXI_AWREADY,

   output                                          init_done,

   input                                           clk90,
   //RLD2 memory signals
   output         [NUM_OF_DEVS-1:0]                RLD2_A_CK_P,
   output         [NUM_OF_DEVS-1:0]                RLD2_A_CK_N,
   output         [NUM_OF_DKS-1:0]                 RLD2_A_DK_P,
   output         [NUM_OF_DKS-1:0]                 RLD2_A_DK_N,
   input          [2*NUM_OF_DEVS-1:0]              RLD2_A_QK_P,
   input          [2*NUM_OF_DEVS-1:0]              RLD2_A_QK_N,
   output         [DEV_AD_WIDTH-1:0]               RLD2_A_A,
   output         [DEV_BA_WIDTH-1:0]               RLD2_A_BA,
   output         [NUM_OF_DEVS-1:0]                RLD2_A_CS_N,
   output                                          RLD2_A_WE_N,
   output                                          RLD2_A_REF_N,
   inout          [63:0]                           RLD2_A_DQ,
   input          [NUM_OF_DEVS-1:0]                RLD2_A_QVLD,

   output         [NUM_OF_DEVS-1:0]                RLD2_B_CK_P,
   output         [NUM_OF_DEVS-1:0]                RLD2_B_CK_N,
   output         [NUM_OF_DKS-1:0]                 RLD2_B_DK_P,
   output         [NUM_OF_DKS-1:0]                 RLD2_B_DK_N,
   input          [2*NUM_OF_DEVS-1:0]              RLD2_B_QK_P,
   input          [2*NUM_OF_DEVS-1:0]              RLD2_B_QK_N,
   output         [DEV_AD_WIDTH-1:0]               RLD2_B_A,
   output         [DEV_BA_WIDTH-1:0]               RLD2_B_BA,
   output         [NUM_OF_DEVS-1:0]                RLD2_B_CS_N,
   output                                          RLD2_B_WE_N,
   output                                          RLD2_B_REF_N,
   inout          [63:0]                           RLD2_B_DQ,
   input          [NUM_OF_DEVS-1:0]                RLD2_B_QVLD
);

function integer log2;
   input integer number;
   begin
      log2=0;
      while(2**log2<number) begin
         log2=log2+1;
      end
   end
endfunction // log2

wire                                init_done_0, init_done_1;
//----------------------- Wires ------------------------
wire                                Bus2IP_Clk;
wire                                Bus2IP_Resetn;
wire  [C_S_AXI_ADDR_WIDTH-1:0]      Bus2IP_Addr;

wire  [0:0]                         Bus2IP_CS;
wire                                Bus2IP_RNW;
wire  [C_S_AXI_DATA_WIDTH-1:0]      Bus2IP_Data;
wire  [C_S_AXI_DATA_WIDTH/8-1:0]    Bus2IP_BE;
wire  [C_S_AXI_DATA_WIDTH-1:0]      IP2Bus_Data;
wire                                IP2Bus_RdAck;
wire                                IP2Bus_WrAck;
wire                                IP2Bus_Error;

localparam	NUM_RW_REGS		= 1;
localparam	NUM_RO_REGS		= 4;

wire	[NUM_RW_REGS*C_S_AXI_DATA_WIDTH-1:0]	rw_regs;
wire	[NUM_RO_REGS*C_S_AXI_DATA_WIDTH-1:0]	ro_regs;

wire  [C_S_AXI_DATA_WIDTH-1:0] ro_reg_0, ro_reg_1, ro_reg_2, ro_reg_3;

assign ro_regs = {ro_reg_3,  ro_reg_2,  ro_reg_1, ro_reg_0};

wire  [7:0]    wgnd;

reg   [25:0]                  APADDR;
reg                           APVALID;
reg                           APP_WDF_WREN;
reg   [(RL_DQ_WIDTH*2)-1:0]   APP_WDF_DATA_0, APP_WDF_DATA_1;

wire                          APP_RDEN_0, APP_RDEN_1;
wire  [(RL_DQ_WIDTH*2)-1:0]   APP_RD_DATA_0, APP_RD_DATA_1;


`define  RLD_IDLE       0
`define  RLD_WR_TUSER   1
`define  RLD_WR_DATA    2
`define  RLD_WR_WAIT    3
`define  RLD_RD_DATA    4
`define  RLD_RD_WAIT    5
`define  RLD_WAIT       6

reg   [7:0]    RLDCurrentSt, RLDNextSt;

reg   [15:0]   reg_wr_pkt_cnt;
reg   [15:0]   reg_rd_pkt_cnt;

wire  [127:0]  m_fifo_hi_out_data, m_fifo_lo_out_data;
wire  [127:0]  m_fifo_hi_in_data, m_fifo_lo_in_data;
wire           m_fifo_hi_full, m_fifo_hi_empty;
wire           m_fifo_lo_full, m_fifo_lo_empty;
wire           m_fifo_hi_wren, m_fifo_lo_wren;

wire  [(RL_DQ_WIDTH*2)-1:0]  rld_wr_tuser_0, rld_wr_tuser_1, rld_wr_tdata_0, rld_wr_tdata_1;

wire           rlWdfFull_0, rlWdfEmpty_0, rlafFull_0, rlafEmpty_0, rlRdfEmpty_0;
wire           rlWdfFull_1, rlWdfEmpty_1, rlafFull_1, rlafEmpty_1, rlRdfEmpty_1;

reg   [3:0]    rld_wait_count;

localparam TUSERSTAMP = {16'h0123, 16'h4567, 16'h89ab, 16'hcdef, 16'hbabe, 16'hbabe, 16'h0ace, 16'h0ace};

//RLDRAM Local parameters
//Public parameters -- adjustable
localparam  SIMULATION_ONLY         = 1'b0; //If set (1'b1), it shortens the wait time
localparam  DUPLICATE_CONTROLS      = 1'b0; //Duplicate the ports for A, BA, WE# and REF#
localparam  RL_CK_PERIOD            = 16'd3003; //CK clock period of the RLDRAM in ps
//MRS (Mode Register Set command) parameters   
//Please check Micron RLDRAM-II datasheet for definitions of these parameters
localparam  RL_MRS_BURST_LENGTH     = 2'b00; //2'b00: BL2;  2'b01: BL4;  2'b10: BL8 (BL8 unsupported)
localparam  RL_MRS_ADDR_MUX         = 1'b0; //1'b0: non-muxed addr;  1'b1: muxed addr
localparam  RL_MRS_DLL_RESET        = 1'b1; //1'b0: Memory DLL reset; 1'b1: Memory DLL enabled
localparam  RL_MRS_IMPEDANCE_MATCH  = 1'b1; //1'b0: internal 50ohms output buffer impedance, 1'b1: external 
localparam  RL_MRS_ODT              = 1'b0; //1'b0: disable term;  1'b1: enable term
//Specific to FPGA/memory devices and capture method
localparam  RL_IO_TYPE              = 2'b00; //CIO=2'b00  SIO_CIO_HYBRID=2'b01  SIO=2'b10
localparam  DEVICE_ARCH             = 2'b01; //Virtex4=2'b00  Virtex5=2'b01
localparam  CAPTURE_METHOD          = 2'b01; //Direct Clocking=2'b00  SerDes=2'b01
localparam  CAL_ADDRESS             = {DEV_AD_WIDTH{1'b0}}; //Saved location to perform calibration
//End of public parameters

//Axi Master Stream FIFO
localparam  BUFFER_SIZE             = 4096; // Buffer size 4096B
localparam  BUFFER_SIZE_WIDTH       = log2(BUFFER_SIZE/(C_M_AXIS_DATA_WIDTH/8));

localparam  MAX_PACKET_SIZE         = 1600;
localparam  BUFFER_THRESHOLD        = (BUFFER_SIZE-MAX_PACKET_SIZE)/(C_M_AXIS_DATA_WIDTH/8);

assign init_done = init_done_0 & init_done_1;

assign rld_wr_tuser_0 = {APP_RD_DATA_0[143:142],s_axis_tuser[112+:16],APP_RD_DATA_0[125:124],s_axis_tuser[96+:16],
                         APP_RD_DATA_0[107:106],s_axis_tuser[80+:16] ,APP_RD_DATA_0[89:88]  ,s_axis_tuser[64+:16],
                         APP_RD_DATA_0[71:70]  ,s_axis_tuser[48+:16] ,APP_RD_DATA_0[53:52]  ,s_axis_tuser[32+:16],
                         APP_RD_DATA_0[35:34]  ,s_axis_tuser[16+:16] ,APP_RD_DATA_0[17:16]  ,s_axis_tuser[0+:16]};

assign rld_wr_tuser_1 = {APP_RD_DATA_1[143:142],16'h0123, APP_RD_DATA_1[125:124],16'h4567,
                         APP_RD_DATA_1[107:106],16'h89ab, APP_RD_DATA_1[89:88]  ,16'hcdef,
                         APP_RD_DATA_1[71:70]  ,16'hbabe, APP_RD_DATA_1[53:52]  ,16'hbabe,
                         APP_RD_DATA_1[35:34]  ,16'h0ace, APP_RD_DATA_1[17:16]  ,16'h0ace};

assign rld_wr_tdata_0 = {APP_RD_DATA_0[143:142],s_axis_tdata[112+:16],APP_RD_DATA_0[125:124],s_axis_tdata[96+:16],
                         APP_RD_DATA_0[107:106],s_axis_tdata[80+:16] ,APP_RD_DATA_0[89:88]  ,s_axis_tdata[64+:16],
                         APP_RD_DATA_0[71:70]  ,s_axis_tdata[48+:16] ,APP_RD_DATA_0[53:52]  ,s_axis_tdata[32+:16],
                         APP_RD_DATA_0[35:34]  ,s_axis_tdata[16+:16] ,APP_RD_DATA_0[17:16]  ,s_axis_tdata[0+:16]};

assign rld_wr_tdata_1 = {APP_RD_DATA_1[143:142],s_axis_tdata[240+:16],APP_RD_DATA_1[125:124],s_axis_tdata[224+:16],
                         APP_RD_DATA_1[107:106],s_axis_tdata[208+:16],APP_RD_DATA_1[89:88]  ,s_axis_tdata[192+:16],
                         APP_RD_DATA_1[71:70]  ,s_axis_tdata[176+:16],APP_RD_DATA_1[53:52]  ,s_axis_tdata[160+:16],
                         APP_RD_DATA_1[35:34]  ,s_axis_tdata[144+:16],APP_RD_DATA_1[17:16]  ,s_axis_tdata[128+:16]};

wire  [127:0]  APP_RD_HI = {APP_RD_DATA_1[126+:16],APP_RD_DATA_1[108+:16],APP_RD_DATA_1[90+:16] ,APP_RD_DATA_1[72+:16],
                            APP_RD_DATA_1[54+:16] ,APP_RD_DATA_1[36+:16], APP_RD_DATA_1[18+:16] ,APP_RD_DATA_1[0+:16]};

wire  [127:0]  APP_RD_LO = {APP_RD_DATA_0[126+:16],APP_RD_DATA_0[108+:16],APP_RD_DATA_0[90+:16] ,APP_RD_DATA_0[72+:16],
                            APP_RD_DATA_0[54+:16] ,APP_RD_DATA_0[36+:16], APP_RD_DATA_0[18+:16] ,APP_RD_DATA_0[0+:16]};

wire  clear_reg = (Bus2IP_Addr[15:0] == 16'h0000) && Bus2IP_CS && ~Bus2IP_RNW; //0x0000 Register for clearing read values.

//Axi Stream Slave input
always @(posedge axi_aclk)
   if (~axi_resetn)  RLDCurrentSt   <= 0;
   else              RLDCurrentSt   <= RLDNextSt;

always @(posedge axi_aclk)
   if (~axi_resetn)                    rld_wait_count <= 0;
   else if (RLDCurrentSt == `RLD_WAIT) rld_wait_count <= rld_wait_count + 1;
   else                                rld_wait_count <= 0;

reg   [23:0]   rld_wr_addr, rld_rd_addr;
always @(posedge axi_aclk)
   if (~axi_resetn)
      rld_wr_addr <= 0;
   else if (clear_reg)
      rld_wr_addr <= 0;
   else if (((RLDCurrentSt == `RLD_WR_TUSER) & s_axis_tvalid) || (s_axis_tvalid & s_axis_tready))
      rld_wr_addr <= rld_wr_addr + 1;
   else if (rld_rd_addr[13] && (RLDCurrentSt == `RLD_RD_WAIT))
      rld_wr_addr <= 0;

always @(posedge axi_aclk)
   if (~axi_resetn)
      rld_rd_addr <= 0;
   else if (clear_reg)
      rld_rd_addr <= 0;
   else if ((RLDCurrentSt == `RLD_RD_DATA) && APVALID)
      rld_rd_addr <= rld_rd_addr + 1;
   else if (rld_rd_addr[13] && (RLDCurrentSt == `RLD_RD_WAIT))
      rld_rd_addr <= 0;

reg   rlWdfEmpty_0_d;
always @(posedge axi_aclk)
   if (~axi_resetn)  rlWdfEmpty_0_d <= 0;
   else              rlWdfEmpty_0_d <= rlWdfEmpty_0;

wire  w_rlWdfEmpty_0_en = rlWdfEmpty_0 & ~rlWdfEmpty_0_d;

reg   rlWdfEmpty_1_d;
always @(posedge axi_aclk)
   if (~axi_resetn)  rlWdfEmpty_1_d <= 0;
   else              rlWdfEmpty_1_d <= rlWdfEmpty_1;

wire  w_rlWdfEmpty_1_en = rlWdfEmpty_1 & ~rlWdfEmpty_1_d;

reg   APP_RDEN_0_d;
always @(posedge axi_aclk)
   if (~axi_resetn)  APP_RDEN_0_d   <= 0;
   else              APP_RDEN_0_d   <= APP_RDEN_0;

wire  w_APP_RDEN_0_en = ~APP_RDEN_0 & APP_RDEN_0_d;

reg   APP_RDEN_1_d;
always @(posedge axi_aclk)
   if (~axi_resetn)  APP_RDEN_1_d   <= 0;
   else              APP_RDEN_1_d   <= APP_RDEN_1;

wire  w_APP_RDEN_1_en = ~APP_RDEN_1 & APP_RDEN_1_d;

reg   wr_pkt_ind;
always @(posedge axi_aclk)
   if (~axi_resetn)  wr_pkt_ind   <= 0;
   else              wr_pkt_ind   <= (RLDCurrentSt == `RLD_WR_TUSER);

wire  w_wr_pkt_ind = (RLDCurrentSt == `RLD_WR_TUSER) & ~wr_pkt_ind;

always @(posedge axi_aclk)
   if (~axi_resetn)         reg_wr_pkt_cnt <= 0;
   else if (clear_reg)      reg_wr_pkt_cnt <= 0;
   else if (w_wr_pkt_ind)   reg_wr_pkt_cnt <= reg_wr_pkt_cnt + 1;

always @(*) begin
   APADDR            <= 0;
   APVALID           <= 0;
   APP_WDF_WREN      <= 0;
   APP_WDF_DATA_1    <= 0;
   APP_WDF_DATA_0    <= 0;
   s_axis_tready     <= 0;
   RLDNextSt         <= `RLD_IDLE;
   case (RLDCurrentSt)
      `RLD_IDLE : begin
         APADDR            <= 0;
         APVALID           <= 0;
         APP_WDF_WREN      <= 0;
         APP_WDF_DATA_0    <= 0;
         APP_WDF_DATA_1    <= 0;
         s_axis_tready     <= 0;
         RLDNextSt         <= (s_axis_tvalid & ~(rlWdfFull_0 || rlWdfFull_1) & init_done) ? `RLD_WAIT : `RLD_IDLE;
      end
      `RLD_WAIT : begin
         APADDR            <= 0;
         APVALID           <= 0;
         APP_WDF_WREN      <= 0;
         APP_WDF_DATA_0    <= 0;
         APP_WDF_DATA_1    <= 0;
         s_axis_tready     <= 0;
         RLDNextSt         <= (&rld_wait_count) ? `RLD_WR_TUSER : (s_axis_tvalid) ? `RLD_WAIT : `RLD_IDLE;
      end
      `RLD_WR_TUSER : begin
         APADDR            <= {2'b0, rld_wr_addr[23:0]};
         APVALID           <= (~rlafFull_0 || ~rlafFull_1);
         APP_WDF_WREN      <= (~rlafFull_0 || ~rlafFull_1);
         APP_WDF_DATA_1    <= rld_wr_tuser_1;
         APP_WDF_DATA_0    <= rld_wr_tuser_0;
         s_axis_tready     <= 0;
         RLDNextSt         <= (s_axis_tvalid) ? `RLD_WR_DATA : `RLD_WR_TUSER;
      end
       `RLD_WR_DATA : begin
         APADDR            <= {2'b0, rld_wr_addr[23:0]};
         APVALID           <= (~rlafFull_0 || ~rlafFull_1);
         APP_WDF_WREN      <= (~rlafFull_0 || ~rlafFull_1);
         APP_WDF_DATA_1    <= rld_wr_tdata_1;
         APP_WDF_DATA_0    <= rld_wr_tdata_0;
         s_axis_tready     <= (~rlafFull_0 || ~rlafFull_1);
         RLDNextSt         <= (s_axis_tlast) ? `RLD_WR_WAIT : `RLD_WR_DATA;
      end
       `RLD_WR_WAIT : begin
         APADDR            <= 0;
         APVALID           <= 0;
         APP_WDF_WREN      <= 0;
         APP_WDF_DATA_1    <= 0;
         APP_WDF_DATA_0    <= 0;
         s_axis_tready     <= 0;
         RLDNextSt         <= (w_rlWdfEmpty_0_en || w_rlWdfEmpty_1_en) ? `RLD_RD_DATA : `RLD_WR_WAIT;
      end
       `RLD_RD_DATA : begin
         APADDR            <= {2'b01, rld_rd_addr[23:0]};
         APVALID           <= (~rlafFull_0 || ~rlafFull_1);
         APP_WDF_WREN      <= 0;
         APP_WDF_DATA_1    <= 0;
         APP_WDF_DATA_0    <= 0;
         s_axis_tready     <= 0;
         RLDNextSt         <= ((rld_rd_addr+1) == rld_wr_addr) ? `RLD_RD_WAIT : `RLD_RD_DATA;
      end
      `RLD_RD_WAIT : begin
         APADDR            <= 0;
         APVALID           <= 0;
         APP_WDF_WREN      <= 0;
         APP_WDF_DATA_1    <= 0;
         APP_WDF_DATA_0    <= 0;
         s_axis_tready     <= 0;
         RLDNextSt         <= (w_APP_RDEN_0_en || w_APP_RDEN_1_en) ? `RLD_IDLE : `RLD_RD_WAIT;
      end
   endcase
end

wire  tuserstamp_en = (TUSERSTAMP == m_fifo_hi_out_data);

reg   tuserstamp_en_d;
always @(posedge axi_aclk)
   if (~axi_resetn)  tuserstamp_en_d   <= 0;
   else              tuserstamp_en_d   <= tuserstamp_en;

wire  w_tuserstamp_en = ~tuserstamp_en & tuserstamp_en_d;

always @(posedge axi_aclk)
   if (~axi_resetn)           reg_rd_pkt_cnt <= 0;
   else if (clear_reg)        reg_rd_pkt_cnt <= 0;
   else if (w_tuserstamp_en)  reg_rd_pkt_cnt <= reg_rd_pkt_cnt + 1;

reg   [127:0]   m_tuser;
always @(posedge axi_aclk)
   if (~axi_resetn)        m_tuser  <= 0;
   else if (tuserstamp_en) m_tuser  <= m_fifo_lo_out_data;

wire  m_fifo_rden = tuserstamp_en || (m_axis_tvalid & m_axis_tready);

reg   tuser_mask;
always @(posedge axi_aclk)
   if (~axi_resetn)  tuser_mask  <= 0;
   else              tuser_mask  <= m_axis_tready;

wire  w_tuser_mask = m_axis_tvalid & ~tuser_mask;

assign   m_axis_tvalid  = ~(m_fifo_hi_empty || m_fifo_lo_empty) & ~tuserstamp_en;
assign   m_axis_tuser   = (w_tuser_mask) ? m_tuser : 0;
assign   m_axis_tdata   = (m_axis_tvalid) ? {m_fifo_hi_out_data, m_fifo_lo_out_data} : 0;

assign   m_fifo_hi_in_data = (init_done) ? APP_RD_HI : 0;
assign   m_fifo_hi_wren    = (init_done) ? APP_RDEN_1 : 0;

assign   m_fifo_lo_in_data = (init_done) ? APP_RD_LO : 0;
assign   m_fifo_lo_wren    = (init_done) ? APP_RDEN_0 : 0;

fallthrough_small_fifo
#(
   .WIDTH               ( C_M_AXIS_DATA_WIDTH/2    ),
   .MAX_DEPTH_BITS      ( BUFFER_SIZE_WIDTH        ),
   .PROG_FULL_THRESHOLD ( BUFFER_THRESHOLD         ))
master_fifo_hi
(
   //Outputs
   .dout          (  m_fifo_hi_out_data            ),
   .full          (),
   .nearly_full   (),
   .prog_full     (  m_fifo_hi_full                ),
   .empty         (  m_fifo_hi_empty               ),
   //Inputs
   .din           (  m_fifo_hi_in_data             ),
   .wr_en         (  m_fifo_hi_wren                ),
   .rd_en         (  m_fifo_rden                   ),
   .reset         (  ~axi_resetn                   ),
   .clk           (  axi_aclk                      ));

fallthrough_small_fifo
#(
   .WIDTH               ( C_M_AXIS_DATA_WIDTH/2    ),
   .MAX_DEPTH_BITS      ( BUFFER_SIZE_WIDTH        ),
   .PROG_FULL_THRESHOLD ( BUFFER_THRESHOLD         ))
master_fifo_lo
(
   //Outputs
   .dout          (  m_fifo_lo_out_data            ),
   .full          (),
   .nearly_full   (),
   .prog_full     (  m_fifo_lo_full                ),
   .empty         (  m_fifo_lo_empty               ),
   //Inputs
   .din           (  m_fifo_lo_in_data             ),
   .wr_en         (  m_fifo_lo_wren                ),
   .rd_en         (  m_fifo_rden                   ),
   .reset         (  ~axi_resetn                   ),
   .clk           (  axi_aclk                      ));

reg   [10:0]   packet_count;
always @(posedge axi_aclk)
   if (~axi_resetn) begin
      packet_count   <= 0;
   end
   else if (m_axis_tvalid & m_axis_tready) begin
      packet_count   <= packet_count + 1;
   end
   else begin
      packet_count   <= 0;
   end

wire  [31:0] wm_strb = (m_tuser[4:0] == 0)  ? 32'hffffffff  : (m_tuser[4:0] == 1)  ? 32'h1         :
                       (m_tuser[4:0] == 2)  ? 32'h3         : (m_tuser[4:0] == 3)  ? 32'h7         :
                       (m_tuser[4:0] == 4)  ? 32'hf         : (m_tuser[4:0] == 5)  ? 32'h1f        :
                       (m_tuser[4:0] == 6)  ? 32'h3f        : (m_tuser[4:0] == 7)  ? 32'h7f        :
                       (m_tuser[4:0] == 8)  ? 32'hff        : (m_tuser[4:0] == 9)  ? 32'h1ff       :
                       (m_tuser[4:0] == 10) ? 32'h3ff       : (m_tuser[4:0] == 11) ? 32'h7ff       :
                       (m_tuser[4:0] == 12) ? 32'hfff       : (m_tuser[4:0] == 13) ? 32'h1fff      :
                       (m_tuser[4:0] == 14) ? 32'h3fff      : (m_tuser[4:0] == 15) ? 32'h7fff      :
                       (m_tuser[4:0] == 16) ? 32'hffff      : (m_tuser[4:0] == 17) ? 32'h1ffff     :
                       (m_tuser[4:0] == 18) ? 32'h3ffff     : (m_tuser[4:0] == 19) ? 32'h7ffff     :
                       (m_tuser[4:0] == 20) ? 32'hfffff     : (m_tuser[4:0] == 21) ? 32'h1fffff    :
                       (m_tuser[4:0] == 22) ? 32'h3fffff    : (m_tuser[4:0] == 23) ? 32'h7fffff    :
                       (m_tuser[4:0] == 24) ? 32'hffffff    : (m_tuser[4:0] == 25) ? 32'h1ffffff   :
                       (m_tuser[4:0] == 26) ? 32'h3ffffff   : (m_tuser[4:0] == 27) ? 32'h7ffffff   :
                       (m_tuser[4:0] == 28) ? 32'hfffffff   : (m_tuser[4:0] == 29) ? 32'h1fffffff  :
                       (m_tuser[4:0] == 30) ? 32'h3fffffff  : (m_tuser[4:0] == 31) ? 32'h7fffffff  : 32'hffffffff;

wire  carry = ~(|m_tuser[4:0]);

wire  [10:0]   packet_row_no = m_tuser[15:5] - carry;

assign m_axis_tlast  = (packet_count == packet_row_no);
assign m_axis_tstrb  = (m_axis_tvalid) ? (m_axis_tlast) ? wm_strb : 32'hffffffff : 0;

assign ro_reg_0 = rld_wr_addr;
assign ro_reg_1 = rld_rd_addr;
assign ro_reg_2 = {reg_rd_pkt_cnt, reg_wr_pkt_cnt};
assign ro_reg_3 = {30'b0, init_done_1, init_done_0};

// RLDRAM-2 Controller and User Application        
rld_mem_interface_top  #(
   .SIMULATION_ONLY        (  SIMULATION_ONLY         ),// if set, it shortens the wait time
   .RL_DQ_WIDTH            (  RL_DQ_WIDTH             ),
   .DEV_DQ_WIDTH           (  DEV_DQ_WIDTH            ),// data width of the memory device
   .DEV_AD_WIDTH           (  DEV_AD_WIDTH            ),// address width of the memory device
   .DEV_BA_WIDTH           (  DEV_BA_WIDTH            ),// bank address width of the memory device
   .DUPLICATE_CONTROLS     (  DUPLICATE_CONTROLS      ),// Duplicate the ports for A, BA, WE# and REF#
   .RL_CK_PERIOD           (  RL_CK_PERIOD            ),// CK clock period of the RLDRAM in ps
   // MRS (Mode Register Set command) parameters   
   .RL_MRS_CONF            (  RL_MRS_CONF             ),// 3'b001: mode1;  3'b010: mode2;  3'b011: mode3
   .RL_MRS_BURST_LENGTH    (  RL_MRS_BURST_LENGTH     ),// 2'b00: BL2;  2'b01: BL4;  2'b10: BL8
   .RL_MRS_ADDR_MUX        (  RL_MRS_ADDR_MUX         ),// 1'b0: non-muxed addr;  1'b1: muxed addr
   .RL_MRS_DLL_RESET       (  RL_MRS_DLL_RESET        ),
   .RL_MRS_IMPEDANCE_MATCH (  RL_MRS_IMPEDANCE_MATCH  ),// internal 50ohms output buffer impedance
   .RL_MRS_ODT             (  RL_MRS_ODT              ),// 1'b0: disable term;  1'b1: enable term
   // specific to FPGA/memory devices and capture method
   .RL_IO_TYPE             (  RL_IO_TYPE              ),// CIO=2'b00  SIO_CIO_HYBRID=2'b01  SIO=2'b10
   .DEVICE_ARCH            (  DEVICE_ARCH             ),// Virtex4=2'b00  Virtex5=2'b01
   .CAPTURE_METHOD         (  CAPTURE_METHOD          ),// Direct Clocking=2'b00  SerDes=2'b01
   .CAL_ADDRESS            (  CAL_ADDRESS             ))
ml561_top0(
   // globals
   .sysReset               (  axi_resetn              ),
   .sysClk_in              (  axi_aclk                ),
   .refClk_in              (  axi_aclk                ),
   .clk33                  (  1'b0                    ),
   .Clk90_in               (  clk90                   ),
   // RLDRAM interface signals
   .RLD2_CK_P              (  RLD2_A_CK_P             ),
   .RLD2_CK_N              (  RLD2_A_CK_N             ),
   .RLD2_CS_N              (  RLD2_A_CS_N             ),
   .RLD2_REF_N             (  RLD2_A_REF_N            ),
   .RLD2_WE_N              (  RLD2_A_WE_N             ),      
   .RLD2_A                 (  RLD2_A_A                ),
   .RLD2_BA                (  RLD2_A_BA               ),
   .RLD2_DM                (   ),      
   .RLD2_QK_P              (  RLD2_A_QK_P             ),
   .RLD2_QK_N              (  RLD2_A_QK_N             ),
   .RLD2_DK_P              (  RLD2_A_DK_P             ),
   .RLD2_DK_N              (  RLD2_A_DK_N             ),      
   .RLD2_QVLD              (  RLD2_A_QVLD             ),      
   .RLD2_DQ                (  {wgnd[7:6],RLD2_A_DQ[63:48],
                               wgnd[5:4],RLD2_A_DQ[47:32],
                               wgnd[3:2],RLD2_A_DQ[31:16],
                               wgnd[1:0],RLD2_A_DQ[15:0]}),
   // observation points
   //.PASS_FAIL(  ),  
   .dip                    (  1'b0                    ),
   .FPGA3_7SEG             (                          ),
   .DBG_LED                (                          ),
   .FPGA3_TEST_HDR         (                          ),
   .axi_addr               (  APADDR                  ),
   .axi_en                 (  APVALID                 ),
   .axi_wr                 (  APP_WDF_WREN            ),
   .axi_wr_data            (  APP_WDF_DATA_0          ),
   .axi_rd                 (  APP_RDEN_0              ),
   .axi_rd_data            (  APP_RD_DATA_0           ),
   .Init_Done              (  init_done_0             ),
   .rlWdfFull		         (  rlWdfFull_0 		      ),
   .rlWdfEmpty		         (	rlWdfEmpty_0		      ),
   .rlafFull		         (	rlafFull_0  		      ),
   .rlafEmpty		         (	rlafEmpty_0 		      ),
   .rlRdfEmpty             (  rlRdfEmpty_0            ));


// RLDRAM-2 Controller and User Application        
rld_mem_interface_top  #(
   .SIMULATION_ONLY        (  SIMULATION_ONLY         ),// if set, it shortens the wait time
   .RL_DQ_WIDTH            (  RL_DQ_WIDTH             ),
   .DEV_DQ_WIDTH           (  DEV_DQ_WIDTH            ),// data width of the memory device
   .DEV_AD_WIDTH           (  DEV_AD_WIDTH            ),// address width of the memory device
   .DEV_BA_WIDTH           (  DEV_BA_WIDTH            ),// bank address width of the memory device
   .DUPLICATE_CONTROLS     (  DUPLICATE_CONTROLS      ),// Duplicate the ports for A, BA, WE# and REF#
   .RL_CK_PERIOD           (  RL_CK_PERIOD            ),// CK clock period of the RLDRAM in ps
   // MRS (Mode Register Set command) parameters   
   .RL_MRS_CONF            (  RL_MRS_CONF             ),// 3'b001: mode1;  3'b010: mode2;  3'b011: mode3
   .RL_MRS_BURST_LENGTH    (  RL_MRS_BURST_LENGTH     ),// 2'b00: BL2;  2'b01: BL4;  2'b10: BL8
   .RL_MRS_ADDR_MUX        (  RL_MRS_ADDR_MUX         ),// 1'b0: non-muxed addr;  1'b1: muxed addr
   .RL_MRS_DLL_RESET       (  RL_MRS_DLL_RESET        ),
   .RL_MRS_IMPEDANCE_MATCH (  RL_MRS_IMPEDANCE_MATCH  ),// internal 50ohms output buffer impedance
   .RL_MRS_ODT             (  RL_MRS_ODT              ),// 1'b0: disable term;  1'b1: enable term
   // specific to FPGA/memory devices and capture method
   .RL_IO_TYPE             (  RL_IO_TYPE              ),// CIO=2'b00  SIO_CIO_HYBRID=2'b01  SIO=2'b10
   .DEVICE_ARCH            (  DEVICE_ARCH             ),// Virtex4=2'b00  Virtex5=2'b01
   .CAPTURE_METHOD         (  CAPTURE_METHOD          ),// Direct Clocking=2'b00  SerDes=2'b01
   .CAL_ADDRESS            (  CAL_ADDRESS             ))
ml561_top1(
   // globals
   .sysReset               (  axi_resetn              ),
   .sysClk_in              (  axi_aclk                ),
   .refClk_in              (  axi_aclk                ),
   .clk33                  (  1'b0                    ),
   .Clk90_in               (  clk90                   ),
   // RLDRAM interface signals
   .RLD2_CK_P              (  RLD2_B_CK_P             ),
   .RLD2_CK_N              (  RLD2_B_CK_N             ),
   .RLD2_CS_N              (  RLD2_B_CS_N             ),
   .RLD2_REF_N             (  RLD2_B_REF_N            ),
   .RLD2_WE_N              (  RLD2_B_WE_N             ),      
   .RLD2_A                 (  RLD2_B_A                ),
   .RLD2_BA                (  RLD2_B_BA               ),
   .RLD2_DM                (    ),      
   .RLD2_QK_P              (  RLD2_B_QK_P             ),
   .RLD2_QK_N              (  RLD2_B_QK_N             ),
   .RLD2_DK_P              (  RLD2_B_DK_P             ),
   .RLD2_DK_N              (  RLD2_B_DK_N             ),      
   .RLD2_QVLD              (  RLD2_B_QVLD             ),      
   .RLD2_DQ                (  {wgnd[7:6],RLD2_B_DQ[63:48],
                               wgnd[5:4],RLD2_B_DQ[47:32],
                               wgnd[3:2],RLD2_B_DQ[31:16],
                               wgnd[1:0],RLD2_B_DQ[15:0]}),
   // observation points
   //.PASS_FAIL(  ),  
   .dip                    (  1'b0                    ),
   .FPGA3_7SEG             (                          ),
   .DBG_LED                (                          ),
   .FPGA3_TEST_HDR         (                          ),
   .axi_addr               (  APADDR                  ),
   .axi_en                 (  APVALID                 ),
   .axi_wr                 (  APP_WDF_WREN            ),
   .axi_wr_data            (  APP_WDF_DATA_1          ),
   .axi_rd                 (  APP_RDEN_1              ),
   .axi_rd_data            (  APP_RD_DATA_1           ),
   .Init_Done              (  init_done_1             ),
   .rlWdfFull		         (	rlWdfFull_1 		      ),
   .rlWdfEmpty		         (	rlWdfEmpty_1		      ),
   .rlafFull		         (	rlafFull_1  		      ),
   .rlafEmpty		         (	rlafEmpty_1 		      ),
   .rlRdfEmpty             (  rlRdfEmpty_1            ));

// -- AXILITE IPIF
axi_lite_ipif_1bar
#(
	.C_S_AXI_DATA_WIDTH	   (  C_S_AXI_DATA_WIDTH	   ),
	.C_S_AXI_ADDR_WIDTH	   (  C_S_AXI_ADDR_WIDTH	   ),
	.C_USE_WSTRB			   (  C_USE_WSTRB			      ),
	.C_DPHASE_TIMEOUT		   (  C_DPHASE_TIMEOUT		   ),
	.C_BAR0_BASEADDR		   (  C_BASEADDR				   ),
	.C_BAR0_HIGHADDR		   (  C_HIGHADDR				   ))
axi_lite_ipif_inst
(
	.S_AXI_ACLK					(  S_AXI_ACLK			      ),
	.S_AXI_ARESETN				(  S_AXI_ARESETN		      ),
	.S_AXI_AWADDR				(  S_AXI_AWADDR		      ),
	.S_AXI_AWVALID				(  S_AXI_AWVALID		      ),
	.S_AXI_WDATA				(  S_AXI_WDATA		         ),
	.S_AXI_WSTRB				(  S_AXI_WSTRB		         ),
	.S_AXI_WVALID				(  S_AXI_WVALID		      ),
	.S_AXI_BREADY				(  S_AXI_BREADY		      ),
	.S_AXI_ARADDR				(  S_AXI_ARADDR		      ),
	.S_AXI_ARVALID				(  S_AXI_ARVALID		      ),
	.S_AXI_RREADY				(  S_AXI_RREADY		      ),
	.S_AXI_ARREADY				(  S_AXI_ARREADY		      ),
	.S_AXI_RDATA				(  S_AXI_RDATA		         ),
	.S_AXI_RRESP				(  S_AXI_RRESP		         ),
	.S_AXI_RVALID				(  S_AXI_RVALID		      ),
	.S_AXI_WREADY				(  S_AXI_WREADY		      ),
	.S_AXI_BRESP				(  S_AXI_BRESP		         ),
	.S_AXI_BVALID				(  S_AXI_BVALID		      ),
	.S_AXI_AWREADY				(  S_AXI_AWREADY		      ),

	//	Controls	to	the	IP/IPIF	modules
	.Bus2IP_Clk					(  Bus2IP_Clk			      ),
	.Bus2IP_Resetn				(  Bus2IP_Resetn		      ),
	.Bus2IP_Addr				(  Bus2IP_Addr		         ),
	.Bus2IP_RNW					(  Bus2IP_RNW			      ),
	.Bus2IP_BE					(  Bus2IP_BE			      ),
	.Bus2IP_CS					(  Bus2IP_CS			      ),
	.Bus2IP_Data				(  Bus2IP_Data		         ),
	.IP2Bus_Data				(  IP2Bus_Data		         ),
	.IP2Bus_WrAck				(  IP2Bus_WrAck		      ),
	.IP2Bus_RdAck				(  IP2Bus_RdAck		      ),
	.IP2Bus_Error				(  IP2Bus_Error		      ));


// -- IPIF REGS
ipif_regs
#(
	.C_S_AXI_DATA_WIDTH		(  C_S_AXI_DATA_WIDTH	   ),	
	.C_S_AXI_ADDR_WIDTH		(  C_S_AXI_ADDR_WIDTH	   ),
	.NUM_RW_REGS				(  NUM_RW_REGS		      	),
	.NUM_RO_REGS				(  NUM_RO_REGS			      ))
ipif_regs_inst
(			
	.Bus2IP_Clk					(  Bus2IP_Clk				   ),
	.Bus2IP_Resetn				(  Bus2IP_Resetn			   ),	
	.Bus2IP_Addr				(  Bus2IP_Addr			      ),
	.Bus2IP_CS					(  Bus2IP_CS[0]			   ),
	.Bus2IP_RNW					(  Bus2IP_RNW				   ),
	.Bus2IP_Data				(  Bus2IP_Data			      ),
	.Bus2IP_BE					(  Bus2IP_BE				   ),
	.IP2Bus_Data				(  IP2Bus_Data			      ),
	.IP2Bus_RdAck				(  IP2Bus_RdAck			   ),
	.IP2Bus_WrAck				(  IP2Bus_WrAck			   ),
	.IP2Bus_Error				(  IP2Bus_Error			   ),

	.rw_regs						(  rw_regs					   ),
	.ro_regs						(  ro_regs					   ));


endmodule
