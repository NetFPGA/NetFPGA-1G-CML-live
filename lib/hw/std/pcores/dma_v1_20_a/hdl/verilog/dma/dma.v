/*******************************************************************************
 *
 *  NetFPGA-1G-CML http://www.netfpga.org
 *
 *  File:
 *        dma.v
 *
 *  Library:
 *        hw/contrib/pcores/dma_v1_10_a
 *
 *  Module:
 *        dma
 *
 *  Author:
 *        Mario Flajslik
 *        James Hongyi Zeng	
 *        Jay Hirata
 *
 *  Description:
 *        Top level DMA module that wraps the dma_engine with the PCIe core,
 *        AXI lite master and AXI lite slave test registers.
 *
 *        Modified to support PCIe core for NetFPGA-1G-CML.
 *
 *  Copyright notice:
 *        Copyright (C) 2010, 2011 The Board of Trustees of The Leland Stanford
 *                                 Junior University
#        Copyright (C) 2013 Computer Measurement Laboratory, LLC
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

module dma
#(
    // Master AXI Stream Data Width
  parameter                              C_M_AXIS_DATA_WIDTH = 32,
  parameter                              C_S_AXIS_DATA_WIDTH = 32,
    parameter C_BASEADDR=32'hffffffff,
    parameter C_HIGHADDR=32'h0
)
  (
   input          reset_n,
     
   // PCIe
   input          pcie_clk_p, // 100 MHz
   input          pcie_clk_n, // 100 MHz
   output         pci_exp_0_txp,
   output         pci_exp_0_txn,
   input          pci_exp_0_rxp,
   input          pci_exp_0_rxn,
   output         pci_exp_1_txp,
   output         pci_exp_1_txn,
   input          pci_exp_1_rxp,
   input          pci_exp_1_rxn,
   output         pci_exp_2_txp,
   output         pci_exp_2_txn,
   input          pci_exp_2_rxp,
   input          pci_exp_2_rxn,
   output         pci_exp_3_txp,
   output         pci_exp_3_txn,
   input          pci_exp_3_rxp,
   input          pci_exp_3_rxn,


   // axi streaming data interface
   input          M_AXIS_ACLK,
   output [C_M_AXIS_DATA_WIDTH-1:0]  M_AXIS_TDATA,
   output [C_M_AXIS_DATA_WIDTH/8-1:0]   M_AXIS_TSTRB,
   output         M_AXIS_TVALID,
   output [127:0] M_AXIS_TUSER,
   input          M_AXIS_TREADY,
   output         M_AXIS_TLAST,
  
   input          S_AXIS_ACLK,
   input [C_S_AXIS_DATA_WIDTH-1:0]   S_AXIS_TDATA,
   input [C_S_AXIS_DATA_WIDTH/8-1:0]    S_AXIS_TSTRB,
   input          S_AXIS_TVALID,
   output         S_AXIS_TREADY,
   input [127:0]  S_AXIS_TUSER,
   input          S_AXIS_TLAST,

   // AXI lite master
   input          M_AXI_LITE_ACLK,
   input          M_AXI_LITE_ARESETN,
   output [31:0]  M_AXI_LITE_ARADDR,
   output         M_AXI_LITE_ARVALID,
   input          M_AXI_LITE_ARREADY,
   input [31:0]   M_AXI_LITE_RDATA,
   input [1:0]    M_AXI_LITE_RRESP,
   input          M_AXI_LITE_RVALID,
   output         M_AXI_LITE_RREADY,
   output [31:0]  M_AXI_LITE_AWADDR,
   output         M_AXI_LITE_AWVALID,
   input          M_AXI_LITE_AWREADY,
   output [31:0]  M_AXI_LITE_WDATA,
   output [3:0]   M_AXI_LITE_WSTRB,
   output         M_AXI_LITE_WVALID,
   input          M_AXI_LITE_WREADY,
   input [1:0]    M_AXI_LITE_BRESP,
   input          M_AXI_LITE_BVALID,
   output         M_AXI_LITE_BREADY, 
   
   // axi lite control/status interface
   input          S_AXI_ACLK,
   input          S_AXI_ARESETN,
   input [31:0]   S_AXI_AWADDR,
   input          S_AXI_AWVALID,
   output         S_AXI_AWREADY,
   input [31:0]   S_AXI_WDATA,
   input [3:0]    S_AXI_WSTRB,
   input          S_AXI_WVALID,
   output         S_AXI_WREADY,
   output [1:0]   S_AXI_BRESP,
   output         S_AXI_BVALID,
   input          S_AXI_BREADY,
   input [31:0]   S_AXI_ARADDR,
   input          S_AXI_ARVALID,
   output         S_AXI_ARREADY,
   output [31:0]  S_AXI_RDATA,
   output [1:0]   S_AXI_RRESP,
   output         S_AXI_RVALID,
   input          S_AXI_RREADY    
   );
   
   
   wire           pcie_clk;
   wire [3:0]     pci_exp_txp;
   wire [3:0]     pci_exp_txn;
   wire [3:0]     pci_exp_rxp;
   wire [3:0]     pci_exp_rxn;

   wire           trn_clk_c;
   //synthesis attribute max_fanout of trn_clk_c is "100000"
   wire           trn_reset_c;
   wire           trn_lnk_up_c;
   wire           trn_tsof_n_c;
   wire           trn_teof_n_c;
   wire           trn_tsrc_rdy_n_c;
   wire           trn_tdst_rdy_c;
   wire           trn_tsrc_dsc_n_c;
   wire           trn_terrfwd_n_c;
   wire           trn_tdst_dsc_n_c;
   wire [63:0]    trn_td_c;
   wire [7:0]     trn_trem_n_c;
   wire [3:0]     trn_tbuf_av_c;

   wire           trn_rsof_n_c;
   wire           trn_reof_c;
   wire           trn_rsrc_rdy_c;
   wire           trn_rsrc_dsc_n_c;
   wire           trn_rdst_rdy_n_c;
   wire           trn_rerrfwd_n_c;
   wire           trn_rnp_ok_n_c;
   wire [63:0]    trn_rd_c;
   wire [7:0]     trn_rrem_n_c;
   wire [6:0]     trn_rbar_hit_n_c;
   wire [7:0]     trn_rfc_nph_av_c;
   wire [11:0]    trn_rfc_npd_av_c;
   wire [7:0]     trn_rfc_ph_av_c;
   wire [11:0]    trn_rfc_pd_av_c;
   wire           trn_rcpl_streaming_n_c;

   wire [31:0]    cfg_do_c;
   wire           cfg_rd_wr_done_c;
   wire [31:0]    cfg_di_c;
   wire [3:0]     cfg_byte_en_n_c;
   wire [9:0]     cfg_dwaddr_c;
   wire           cfg_wr_en_n_c;
   wire           cfg_rd_en_n_c;
   wire           cfg_err_cor_n_c;
   wire           cfg_err_ur_n_c;
   wire           cfg_err_ecrc_n_c;
   wire           cfg_err_cpl_timeout_n_c;
   wire           cfg_err_cpl_abort_n_c;
   wire           cfg_err_cpl_unexpect_n_c;
   wire           cfg_err_posted_n_c;
   wire [47:0]    cfg_err_tlp_cpl_header_c;
   
   wire           cfg_err_cpl_rdy_c;
   wire           cfg_err_locked_n_c;
   wire           cfg_interrupt_n_c;
   wire           cfg_interrupt_rdy_c;
   wire           cfg_interrupt_assert_n_c;
   wire [7:0]     cfg_interrupt_di_c;
   wire [7:0]     cfg_interrupt_do_c;
   wire [2:0]     cfg_interrupt_mmenable_c;
   wire           cfg_interrupt_msienable_c;
   wire           cfg_to_turnoff_c;
   wire           cfg_pm_wake_n_c;
   wire [2:0]     cfg_pcie_link_state_n_c;
   wire           cfg_trn_pending_n_c;
   wire [7:0]     cfg_bus_number_c;
   wire [4:0]     cfg_device_number_c;
   wire [2:0]     cfg_function_number_c;
   wire [63:0]    cfg_dsn_c;
   wire [15:0]    cfg_status_c;
   wire [15:0]    cfg_command_c;
   wire [15:0]    cfg_dstatus_c;
   wire [15:0]    cfg_dcommand_c;
   wire [15:0]    cfg_lstatus_c;
   wire [15:0]    cfg_lcommand_c;

   // AXI lite master core interface
   wire           IP2Bus_MstRd_Req;
   wire           IP2Bus_MstWr_Req;
   wire [31:0]    IP2Bus_Mst_Addr;
   wire [3:0]     IP2Bus_Mst_BE;
   wire           IP2Bus_Mst_Lock;
   wire           IP2Bus_Mst_Reset;
   wire           Bus2IP_Mst_CmdAck;
   wire           Bus2IP_Mst_Cmplt;
   wire           Bus2IP_Mst_Error;
   wire           Bus2IP_Mst_Rearbitrate;
   wire           Bus2IP_Mst_Timeout;
   wire [31:0]    Bus2IP_MstRd_d;
   wire           Bus2IP_MstRd_src_rdy_n;
   wire [31:0]    IP2Bus_MstWr_d;
   wire           Bus2IP_MstWr_dst_rdy_n;


  wire [127:0]  tmp_m_tuser;
  wire [127:0]  tmp_s_tuser;
  wire [63:0]   M_AXIS_TDATA_DMA;    // AXI4-Stream (Ingress from PCIe) Master-Producer...
  wire [7:0] M_AXIS_TSTRB_DMA;
  wire [127:0]   M_AXIS_TUSER_DMA; 
  wire                                 M_AXIS_TLAST_DMA;
  wire                                 M_AXIS_TVALID_DMA;
  wire                                 M_AXIS_TREADY_DMA;

  wire  [63:0]   S_AXIS_TDATA_DMA;    // AXI4-Stream (Egress to PCIe) Slave-Consumer...
  wire  [7:0] S_AXIS_TSTRB_DMA;
  wire  [127:0]   S_AXIS_TUSER_DMA; 
  wire                                  S_AXIS_TLAST_DMA;
  wire                                  S_AXIS_TVALID_DMA;
  wire                                  S_AXIS_TREADY_DMA;


   assign {pci_exp_3_txp, pci_exp_2_txp, pci_exp_1_txp, pci_exp_0_txp} = pci_exp_txp;
   assign {pci_exp_3_txn, pci_exp_2_txn, pci_exp_1_txn, pci_exp_0_txn} = pci_exp_txn;
   assign pci_exp_rxp = {pci_exp_3_rxp, pci_exp_2_rxp, pci_exp_1_rxp, pci_exp_0_rxp};
   assign pci_exp_rxn = {pci_exp_3_rxn, pci_exp_2_rxn, pci_exp_1_rxn, pci_exp_0_rxn};


   IBUFDS_GTE2 refclk_ibuf (.O(pcie_clk), .I(pcie_clk_p), .IB(pcie_clk_n));  // 100 MHz

   reg              dma_rst;
   always @(posedge trn_clk_c)
     dma_rst <= trn_reset_c | ~trn_lnk_up_c;

    nf10_axis_converter 
    #(.C_M_AXIS_DATA_WIDTH(C_M_AXIS_DATA_WIDTH),
      .C_S_AXIS_DATA_WIDTH(64)
     ) converter_master
    (
    // Global Ports
    .axi_aclk(M_AXIS_ACLK),
    .axi_resetn(reset_n),
    
    // Master Stream Ports
    .m_axis_tdata(M_AXIS_TDATA),
    .m_axis_tstrb(M_AXIS_TSTRB),
    .m_axis_tvalid(M_AXIS_TVALID),
    .m_axis_tready(M_AXIS_TREADY),
    .m_axis_tlast(M_AXIS_TLAST),
	.m_axis_tuser(M_AXIS_TUSER),
    
    // Slave Stream Ports
    .s_axis_tdata(M_AXIS_TDATA_DMA),
    .s_axis_tstrb(M_AXIS_TSTRB_DMA),
    .s_axis_tvalid(M_AXIS_TVALID_DMA),
    .s_axis_tready(M_AXIS_TREADY_DMA),
    .s_axis_tlast(M_AXIS_TLAST_DMA),
	.s_axis_tuser(M_AXIS_TUSER_DMA)
   );

    nf10_axis_converter 
    #(.C_M_AXIS_DATA_WIDTH(64),
      .C_S_AXIS_DATA_WIDTH(C_S_AXIS_DATA_WIDTH)
     ) converter_slave
    (
    // Global Ports
    .axi_aclk(S_AXIS_ACLK),
    .axi_resetn(reset_n),
    
    // Master Stream Ports
    .m_axis_tdata(S_AXIS_TDATA_DMA),
    .m_axis_tstrb(S_AXIS_TSTRB_DMA),
    .m_axis_tvalid(S_AXIS_TVALID_DMA),
    .m_axis_tready(S_AXIS_TREADY_DMA),
    .m_axis_tlast(S_AXIS_TLAST_DMA),
	 .m_axis_tuser(S_AXIS_TUSER_DMA),
    
    // Slave Stream Ports
    .s_axis_tdata(S_AXIS_TDATA),
    .s_axis_tstrb(S_AXIS_TSTRB),
    .s_axis_tvalid(S_AXIS_TVALID),
    .s_axis_tready(S_AXIS_TREADY),
    .s_axis_tlast(S_AXIS_TLAST),
	.s_axis_tuser(S_AXIS_TUSER)
   );

   dma_engine u_dma 
     (
      .axi_clk(M_AXI_LITE_ACLK),
      .tx_clk(M_AXIS_ACLK),
      .rx_clk(S_AXIS_ACLK),
      .pcie_clk(trn_clk_c),                   
      .rst(dma_rst),

      // Tx Local-Link
      .trn_td(trn_td_c),                     
      .trn_trem_n(trn_trem_n_c),             
      .trn_tsof_n(trn_tsof_n_c),             
      .trn_teof_n(trn_teof_n_c),             
      .trn_tsrc_rdy_n(trn_tsrc_rdy_n_c),     
      .trn_tsrc_dsc_n(trn_tsrc_dsc_n_c),     
      .trn_tdst_rdy_n(~trn_tdst_rdy_c),
      .trn_tdst_dsc_n(trn_tdst_dsc_n_c),     
      .trn_terrfwd_n(trn_terrfwd_n_c),       
      .trn_tbuf_av(trn_tbuf_av_c),           

      // Rx Local-Link
      .trn_rd(trn_rd_c),                     
      .trn_rrem_n(trn_rrem_n_c),
      .trn_rsof_n(trn_rsof_n_c),             
      .trn_reof_n(~trn_reof_c),
      .trn_rsrc_rdy_n(~trn_rsrc_rdy_c),
      .trn_rsrc_dsc_n(trn_rsrc_dsc_n_c),     
      .trn_rdst_rdy_n(trn_rdst_rdy_n_c),     
      .trn_rerrfwd_n(trn_rerrfwd_n_c),       
      .trn_rnp_ok_n(trn_rnp_ok_n_c),         
      .trn_rbar_hit_n(trn_rbar_hit_n_c),     
      .trn_rfc_nph_av(trn_rfc_nph_av_c),     
      .trn_rfc_npd_av(trn_rfc_npd_av_c),     
      .trn_rfc_ph_av(trn_rfc_ph_av_c),       
      .trn_rfc_pd_av(trn_rfc_pd_av_c),       
      .trn_rcpl_streaming_n(trn_rcpl_streaming_n_c),          

      // Host ( CFG ) Interface
      .cfg_do(cfg_do_c),                                             
      .cfg_rd_wr_done_n(~cfg_rd_wr_done_c),
      .cfg_di(cfg_di_c),                                 
      .cfg_byte_en_n(cfg_byte_en_n_c),                   
      .cfg_dwaddr(cfg_dwaddr_c),                         
      .cfg_wr_en_n(cfg_wr_en_n_c),                       
      .cfg_rd_en_n(cfg_rd_en_n_c),                       

      .cfg_err_cor_n(cfg_err_cor_n_c),                   
      .cfg_err_ur_n(cfg_err_ur_n_c),                     
      .cfg_err_ecrc_n(cfg_err_ecrc_n_c),                 
      .cfg_err_cpl_timeout_n(cfg_err_cpl_timeout_n_c),   
      .cfg_err_cpl_abort_n(cfg_err_cpl_abort_n_c),       
      .cfg_err_cpl_unexpect_n(cfg_err_cpl_unexpect_n_c), 
      .cfg_err_posted_n(cfg_err_posted_n_c),             
      .cfg_err_tlp_cpl_header(cfg_err_tlp_cpl_header_c), 
      .cfg_err_cpl_rdy_n(~cfg_err_cpl_rdy_c),
      .cfg_err_locked_n(cfg_err_locked_n_c),             

      .cfg_interrupt_n(cfg_interrupt_n_c),               
      .cfg_interrupt_rdy_n(~cfg_interrupt_rdy_c),
      .cfg_interrupt_assert_n(cfg_interrupt_assert_n_c),                     
      .cfg_interrupt_di(cfg_interrupt_di_c),             
      .cfg_interrupt_do(cfg_interrupt_do_c),             
      .cfg_interrupt_mmenable(cfg_interrupt_mmenable_c),    
      .cfg_interrupt_msienable(cfg_interrupt_msienable_c),  

      .cfg_pm_wake_n(cfg_pm_wake_n_c),                      
      .cfg_pcie_link_state_n(cfg_pcie_link_state_n_c),      
      .cfg_to_turnoff_n(~cfg_to_turnoff_c),
      .cfg_trn_pending_n(cfg_trn_pending_n_c),              
      .cfg_dsn(cfg_dsn_c),                       
      .cfg_bus_number(cfg_bus_number_c),                
      .cfg_device_number(cfg_device_number_c),          
      .cfg_function_number(cfg_function_number_c),      
      .cfg_status(cfg_status_c),                        
      .cfg_command(cfg_command_c),                      
      .cfg_dstatus(cfg_dstatus_c),                      
      .cfg_dcommand(cfg_dcommand_c),                    
      .cfg_lstatus(cfg_lstatus_c),                      
      .cfg_lcommand(cfg_lcommand_c),

      // AXI lite master core interface
      .IP2Bus_MstRd_Req(IP2Bus_MstRd_Req),
      .IP2Bus_MstWr_Req(IP2Bus_MstWr_Req),
      .IP2Bus_Mst_Addr(IP2Bus_Mst_Addr),
      .IP2Bus_Mst_BE(IP2Bus_Mst_BE),
      .IP2Bus_Mst_Lock(IP2Bus_Mst_Lock),
      .IP2Bus_Mst_Reset(IP2Bus_Mst_Reset),
      .Bus2IP_Mst_CmdAck(Bus2IP_Mst_CmdAck),
      .Bus2IP_Mst_Cmplt(Bus2IP_Mst_Cmplt),
      .Bus2IP_Mst_Error(Bus2IP_Mst_Error),
      .Bus2IP_Mst_Rearbitrate(Bus2IP_Mst_Rearbitrate),
      .Bus2IP_Mst_Timeout(Bus2IP_Mst_Timeout),
      .Bus2IP_MstRd_d(Bus2IP_MstRd_d),
      .Bus2IP_MstRd_src_rdy_n(Bus2IP_MstRd_src_rdy_n),
      .IP2Bus_MstWr_d(IP2Bus_MstWr_d),
      .Bus2IP_MstWr_dst_rdy_n(Bus2IP_MstWr_dst_rdy_n),

      // MAC tx
      .M_AXIS_TDATA(M_AXIS_TDATA_DMA),
      .M_AXIS_TSTRB(M_AXIS_TSTRB_DMA),
      .M_AXIS_TVALID(M_AXIS_TVALID_DMA),
      .M_AXIS_TREADY(M_AXIS_TREADY_DMA),
      .M_AXIS_TLAST(M_AXIS_TLAST_DMA),
      .M_AXIS_TUSER(M_AXIS_TUSER_DMA),

      // MAC rx
      .S_AXIS_TDATA(S_AXIS_TDATA_DMA),
      .S_AXIS_TSTRB(S_AXIS_TSTRB_DMA),
      .S_AXIS_TVALID(S_AXIS_TVALID_DMA),
      .S_AXIS_TREADY(S_AXIS_TREADY_DMA),
      .S_AXIS_TUSER(S_AXIS_TUSER_DMA),
      .S_AXIS_TLAST(S_AXIS_TLAST_DMA)              
      );

    wire [63:0]     tx_tdata;
    wire [3:0]      tx_tuser;
    wire [7:0]      tx_tkeep;
    wire [63:0]     rx_tdata;
    reg             in_packet_reg;
    wire [21:0]     rx_tuser;
    wire [7:0]      rx_tkeep;

    assign tx_tdata[63:32]  = trn_td_c[31:0];
    assign tx_tdata[31:0]   = trn_td_c[63:32];
    assign tx_tuser[3]      = ~trn_tsrc_dsc_n_c;
    assign tx_tuser[1]      = ~trn_terrfwd_n_c;
    assign tx_tuser[2]      = 0;

    assign trn_tdst_dsc_n_c = 1'b0;

    assign trn_rd_c[63:32]  = rx_tdata[31:0];
    assign trn_rd_c[31:0]   = rx_tdata[63:32];

    always @(posedge trn_clk_c)
    begin
        if (trn_reset_c) begin
            in_packet_reg = 0;
        end else if (trn_rsrc_rdy_c & ~trn_rdst_rdy_n_c) begin
            in_packet_reg = ~trn_reof_c;
        end
    end

    assign trn_rsof_n_c = ~(trn_rsrc_rdy_c & ~in_packet_reg);
    assign trn_rsrc_dsc_n_c = 1;
    assign trn_rerrfwd_n_c = ~rx_tuser[1];
    assign trn_rbar_hit_n_c = ~rx_tuser[8:2];
    assign trn_rfc_nph_av_c = 0;
    assign trn_rfc_npd_av_c = 0;
    assign trn_rfc_ph_av_c = 0;
    assign trn_rfc_pd_av_c = 0;


    assign tx_tkeep = (trn_teof_n_c) ? 8'b11111111 : (trn_trem_n_c[3:0] == 4'b1111) ? 8'b00001111 : 8'b11111111;


    assign trn_rrem_n_c = (trn_reof_c) ? ((rx_tkeep[7:4] == 4'b1111) ? 8'b00000000 : 8'b00001111) : 8'b00000000;

    wire [5:0]          tx_buf_av;

    assign trn_tbuf_av_c    = (tx_buf_av != 0) ? 4'b1111 : 4'b0000;

    pcie_7x  pcie_7x_i (
      //----------------------------------------------------------------------------------------------------------------//
      // 1. PCI Express (pci_exp) Interface                                                                             //
      //----------------------------------------------------------------------------------------------------------------//
      // Tx
      .pci_exp_txn                                ( pci_exp_txn ),
      .pci_exp_txp                                ( pci_exp_txp ),
      // Rx
      .pci_exp_rxn                                ( pci_exp_rxn ),
      .pci_exp_rxp                                ( pci_exp_rxp ),
      //----------------------------------------------------------------------------------------------------------------//
      // 2. Clocking Interface - For Partial Reconfig Support                                                           //
      //----------------------------------------------------------------------------------------------------------------//
      //----------------------------------------------------------------------------------------------------------------//
      // 3. AXI-S Interface                                                                                             //
      //----------------------------------------------------------------------------------------------------------------//
      // Common
      .user_clk_out                               ( trn_clk_c ),
      .user_reset_out                             ( trn_reset_c ),
      .user_lnk_up                                ( trn_lnk_up_c ),
      .user_app_rdy                               ( ),
      // TX
      .tx_buf_av                                  ( tx_buf_av ),
      .tx_err_drop                                ( ),
      .tx_cfg_req                                 ( ),
      .s_axis_tx_tready                           ( trn_tdst_rdy_c ),
      .s_axis_tx_tdata                            ( tx_tdata ),
      .s_axis_tx_tkeep                            ( tx_tkeep),
      .s_axis_tx_tuser                            ( tx_tuser ),
      .s_axis_tx_tlast                            ( ~trn_teof_n_c ),
      .s_axis_tx_tvalid                           ( ~trn_tsrc_rdy_n_c ),
      .tx_cfg_gnt                                 ( 1'b1),
      // Rx
      .m_axis_rx_tdata                            ( rx_tdata ),
      .m_axis_rx_tkeep                            ( rx_tkeep),
      .m_axis_rx_tlast                            ( trn_reof_c ),
      .m_axis_rx_tvalid                           ( trn_rsrc_rdy_c ),
      .m_axis_rx_tready                           ( ~trn_rdst_rdy_n_c ),
      .m_axis_rx_tuser                            ( rx_tuser ),
      .rx_np_ok                                   ( ~trn_rnp_ok_n_c ),
      .rx_np_req                                  ( 1'b1 ),
      // Flow Control
      .fc_cpld                                    ( ),
      .fc_cplh                                    ( ),
      .fc_npd                                     ( ),
      .fc_nph                                     ( ),
      .fc_pd                                      ( ),
      .fc_ph                                      ( ),
      .fc_sel                                     ( 3'b000 ),
      //----------------------------------------------------------------------------------------------------------------//
      // 4. Configuration (CFG) Interface                                                                               //
      //----------------------------------------------------------------------------------------------------------------//
      //------------------------------------------------//
      // EP and RP                                      //
      //------------------------------------------------//
      .cfg_mgmt_do                                ( cfg_do_c ),
      .cfg_mgmt_rd_wr_done                        ( cfg_rd_wr_done_c ),
      .cfg_status                                 ( cfg_status_c ),
      .cfg_command                                ( cfg_command_c ),
      .cfg_dstatus                                ( cfg_dstatus_c ),
      .cfg_dcommand                               ( cfg_dcommand_c ),
      .cfg_lstatus                                ( cfg_lstatus_c ),
      .cfg_lcommand                               ( cfg_lcommand_c ),
      .cfg_dcommand2                              ( ),
      .cfg_pcie_link_state                        ( cfg_pcie_link_state_n_c ),
      .cfg_pmcsr_pme_en                           ( ),
      .cfg_pmcsr_powerstate                       ( ),
      .cfg_pmcsr_pme_status                       ( ),
      .cfg_received_func_lvl_rst                  ( ),
      // Management Interface
      .cfg_mgmt_di                                ( cfg_di_c ), //32'h0 ),
      .cfg_mgmt_byte_en                           ( ~cfg_byte_en_n_c ), //4'h0 ),
      .cfg_mgmt_dwaddr                            ( cfg_dwaddr_c ), //10'h0 ),
      .cfg_mgmt_wr_en                             ( ~cfg_wr_en_n_c ), //1'b0 ),
      .cfg_mgmt_rd_en                             ( ~cfg_rd_en_n_c ), //1'b0 ),
      .cfg_mgmt_wr_readonly                       ( cfg_wr_readonly_c ), //1'b0 ),
      // Error Reporting Interface
      .cfg_err_ecrc                               ( ~cfg_err_ecrc_n_c  ),
      .cfg_err_ur                                 ( ~cfg_err_ur_n_c ),
      .cfg_err_cpl_timeout                        ( ~cfg_err_cpl_timeout_n_c ),
      .cfg_err_cpl_unexpect                       ( ~cfg_err_cpl_unexpect_n_c ),
      .cfg_err_cpl_abort                          ( ~cfg_err_cpl_abort_n_c ), ///1'b0 ),
      .cfg_err_posted                             ( ~cfg_err_posted_n_c ),
      .cfg_err_cor                                ( ~cfg_err_cor_n_c ),
      .cfg_err_atomic_egress_blocked              ( 1'b0 ),
      .cfg_err_internal_cor                       ( 1'b0 ),
      .cfg_err_malformed                          ( 1'b0 ),
      .cfg_err_mc_blocked                         ( 1'b0 ),
      .cfg_err_poisoned                           ( 1'b0 ),
      .cfg_err_norecovery                         ( 1'b0 ),
      .cfg_err_tlp_cpl_header                     ( cfg_err_tlp_cpl_header_c ),
      .cfg_err_cpl_rdy                            ( cfg_err_cpl_rdy_c ),
      .cfg_err_locked                             ( ~cfg_err_locked_n_c ),
      .cfg_err_acs                                ( 1'b0 ),
      .cfg_err_internal_uncor                     ( 1'b0 ),
      .cfg_trn_pending                            ( ~cfg_trn_pending_n_c ),
      .cfg_pm_halt_aspm_l0s                       ( 1'b0 ),
      .cfg_pm_halt_aspm_l1                        ( 1'b0 ),
      .cfg_pm_force_state_en                      ( 1'b0 ),
      .cfg_pm_force_state                         ( 2'b00 ),
      .cfg_dsn                                    ( cfg_dsn_c ),
      //------------------------------------------------//
      // EP Only                                        //
      //------------------------------------------------//
      .cfg_interrupt                              ( ~cfg_interrupt_n_c),
      .cfg_interrupt_rdy                          ( cfg_interrupt_rdy_c ),
      .cfg_interrupt_assert                       ( ~cfg_interrupt_assert_n_c ),
      .cfg_interrupt_di                           ( cfg_interrupt_di_c ),
      .cfg_interrupt_do                           ( cfg_interrupt_do_c ),
      .cfg_interrupt_mmenable                     ( cfg_interrupt_mmenable_c ),
      .cfg_interrupt_msienable                    ( cfg_interrupt_msienable_c ),
      .cfg_interrupt_msixenable                   ( ),
      .cfg_interrupt_msixfm                       ( ),
      .cfg_interrupt_stat                         ( 1'b0 ),
      .cfg_pciecap_interrupt_msgnum               ( 5'b00000 ),
      .cfg_to_turnoff                             ( cfg_to_turnoff_c ),
      .cfg_turnoff_ok                             ( cfg_to_turnoff_c ),
      .cfg_bus_number                             ( cfg_bus_number_c ),
      .cfg_device_number                          ( cfg_device_number_c ),
      .cfg_function_number                        ( cfg_function_number_c ),
      .cfg_pm_wake                                ( ~cfg_pm_wake_n_c ),
      //------------------------------------------------//
      // RP Only                                        //
      //------------------------------------------------//
      .cfg_pm_send_pme_to                         ( 1'b0 ),
      .cfg_ds_bus_number                          ( 8'b0 ),
      .cfg_ds_device_number                       ( 5'b0 ),
      .cfg_ds_function_number                     ( 3'b0 ),
      .cfg_mgmt_wr_rw1c_as_rw                     ( 1'b0 ),
      .cfg_msg_received                           ( ),
      .cfg_msg_data                               ( ),
      .cfg_bridge_serr_en                         ( ),
      .cfg_slot_control_electromech_il_ctl_pulse  ( ),
      .cfg_root_control_syserr_corr_err_en        ( ),
      .cfg_root_control_syserr_non_fatal_err_en   ( ),
      .cfg_root_control_syserr_fatal_err_en       ( ),
      .cfg_root_control_pme_int_en                ( ),
      .cfg_aer_rooterr_corr_err_reporting_en      ( ),
      .cfg_aer_rooterr_non_fatal_err_reporting_en ( ),
      .cfg_aer_rooterr_fatal_err_reporting_en     ( ),
      .cfg_aer_rooterr_corr_err_received          ( ),
      .cfg_aer_rooterr_non_fatal_err_received     ( ),
      .cfg_aer_rooterr_fatal_err_received         ( ),
      .cfg_msg_received_err_cor                   ( ),
      .cfg_msg_received_err_non_fatal             ( ),
      .cfg_msg_received_err_fatal                 ( ),
      .cfg_msg_received_pm_as_nak                 ( ),
      .cfg_msg_received_pm_pme                    ( ),
      .cfg_msg_received_pme_to_ack                ( ),
      .cfg_msg_received_assert_int_a              ( ),
      .cfg_msg_received_assert_int_b              ( ),
      .cfg_msg_received_assert_int_c              ( ),
      .cfg_msg_received_assert_int_d              ( ),
      .cfg_msg_received_deassert_int_a            ( ),
      .cfg_msg_received_deassert_int_b            ( ),
      .cfg_msg_received_deassert_int_c            ( ),
      .cfg_msg_received_deassert_int_d            ( ),
      .cfg_msg_received_setslotpowerlimit         ( ),
      //----------------------------------------------------------------------------------------------------------------//
      // 5. Physical Layer Control and Status (PL) Interface                                                            //
      //----------------------------------------------------------------------------------------------------------------//
      .pl_directed_link_change                    ( 2'b00 ),
      .pl_directed_link_width                     ( 2'b00 ),
      .pl_directed_link_speed                     ( 1'b0 ),
      .pl_directed_link_auton                     ( 1'b0 ),
      .pl_upstream_prefer_deemph                  ( 1'b0 ),
      .pl_sel_lnk_rate                            ( ),
      .pl_sel_lnk_width                           ( ),
      .pl_ltssm_state                             ( ),
      .pl_lane_reversal_mode                      ( ),
      .pl_phy_lnk_up                              ( ),
      .pl_tx_pm_state                             ( ),
      .pl_rx_pm_state                             ( ),
      .pl_link_upcfg_cap                          ( ),
      .pl_link_gen2_cap                           ( ),
      .pl_link_partner_gen2_supported             ( ),
      .pl_initial_link_width                      ( ),
      .pl_directed_change_done                    ( ),
      //------------------------------------------------//
      // EP Only                                        //
      //------------------------------------------------//
      .pl_received_hot_rst                        ( ),
      //------------------------------------------------//
      // RP Only                                        //
      //------------------------------------------------//
      .pl_transmit_hot_rst                        ( 1'b0 ),
      .pl_downstream_deemph_source                ( 1'b0 ),
      //----------------------------------------------------------------------------------------------------------------//
      // 6. AER Interface                                                                                               //
      //----------------------------------------------------------------------------------------------------------------//
      .cfg_err_aer_headerlog                      ( 128'b0 ),
      .cfg_aer_interrupt_msgnum                   ( 5'b00000 ),
      .cfg_err_aer_headerlog_set                  ( ),
      .cfg_aer_ecrc_check_en                      ( ),
      .cfg_aer_ecrc_gen_en                        ( ),
      //----------------------------------------------------------------------------------------------------------------//
      // 7. VC interface                                                                                                //
      //----------------------------------------------------------------------------------------------------------------//
      .cfg_vc_tcvc_map                            ( ),
      //----------------------------------------------------------------------------------------------------------------//
      // 8. System  (SYS) Interface                                                                                     //
      //----------------------------------------------------------------------------------------------------------------//
      .sys_clk                                    ( pcie_clk ),
      .sys_rst_n                                  ( reset_n )
    );


   axi_master_lite u_axi_m
     (
      .m_axi_lite_aclk(M_AXI_LITE_ACLK),
      .m_axi_lite_aresetn(M_AXI_LITE_ARESETN),
      .md_error(),
      .m_axi_lite_araddr(M_AXI_LITE_ARADDR),
      .m_axi_lite_arvalid(M_AXI_LITE_ARVALID),
      .m_axi_lite_arready(M_AXI_LITE_ARREADY),
      .m_axi_lite_arprot(),
      .m_axi_lite_rdata(M_AXI_LITE_RDATA),
      .m_axi_lite_rresp(M_AXI_LITE_RRESP),
      .m_axi_lite_rvalid(M_AXI_LITE_RVALID),
      .m_axi_lite_rready(M_AXI_LITE_RREADY),
      .m_axi_lite_awaddr(M_AXI_LITE_AWADDR),
      .m_axi_lite_awvalid(M_AXI_LITE_AWVALID),
      .m_axi_lite_awready(M_AXI_LITE_AWREADY),
      .m_axi_lite_awprot(),
      .m_axi_lite_wdata(M_AXI_LITE_WDATA),
      .m_axi_lite_wstrb(M_AXI_LITE_WSTRB),
      .m_axi_lite_wvalid(M_AXI_LITE_WVALID),
      .m_axi_lite_wready(M_AXI_LITE_WREADY),
      .m_axi_lite_bresp(M_AXI_LITE_BRESP),
      .m_axi_lite_bvalid(M_AXI_LITE_BVALID),
      .m_axi_lite_bready(M_AXI_LITE_BREADY),      
      .ip2bus_mstrd_req(IP2Bus_MstRd_Req),
      .ip2bus_mstwr_req(IP2Bus_MstWr_Req),
      .ip2bus_mst_addr(IP2Bus_Mst_Addr),
      .ip2bus_mst_be(IP2Bus_Mst_BE),
      .ip2bus_mst_lock(IP2Bus_Mst_Lock),
      .ip2bus_mst_reset(IP2Bus_Mst_Reset),
      .bus2ip_mst_cmdack(Bus2IP_Mst_CmdAck),
      .bus2ip_mst_cmplt(Bus2IP_Mst_Cmplt),
      .bus2ip_mst_error(Bus2IP_Mst_Error),
      .bus2ip_mst_rearbitrate(Bus2IP_Mst_Rearbitrate),
      .bus2ip_mst_cmd_timeout(Bus2IP_Mst_Timeout),
      .bus2ip_mstrd_d(Bus2IP_MstRd_d),
      .bus2ip_mstrd_src_rdy_n(Bus2IP_MstRd_src_rdy_n),
      .ip2bus_mstwr_d(IP2Bus_MstWr_d),
      .bus2ip_mstwr_dst_rdy_n(Bus2IP_MstWr_dst_rdy_n)
      );


   axi4_lite_regs_test u_axi_test
     (
      .ACLK(S_AXI_ACLK),
      .ARESETN(S_AXI_ARESETN),
      .AWADDR(S_AXI_AWADDR),
      .AWVALID(S_AXI_AWVALID),
      .AWREADY(S_AXI_AWREADY),
      .WDATA(S_AXI_WDATA),
      .WSTRB(S_AXI_WSTRB),
      .WVALID(S_AXI_WVALID),
      .WREADY(S_AXI_WREADY),
      .BRESP(S_AXI_BRESP),
      .BVALID(S_AXI_BVALID),
      .BREADY(S_AXI_BREADY),
      .ARADDR(S_AXI_ARADDR),
      .ARVALID(S_AXI_ARVALID),
      .ARREADY(S_AXI_ARREADY),
      .RDATA(S_AXI_RDATA),
      .RRESP(S_AXI_RRESP),
      .RVALID(S_AXI_RVALID),
      .RREADY(S_AXI_RREADY)
      );

endmodule
