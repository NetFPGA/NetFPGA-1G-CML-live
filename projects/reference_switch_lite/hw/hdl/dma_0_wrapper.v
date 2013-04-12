//-----------------------------------------------------------------------------
// dma_0_wrapper.v
//-----------------------------------------------------------------------------

module dma_0_wrapper
  (
    reset_n,
    pcie_clk_p,
    pcie_clk_n,
    pci_exp_0_txp,
    pci_exp_0_txn,
    pci_exp_0_rxp,
    pci_exp_0_rxn,
    pci_exp_1_txp,
    pci_exp_1_txn,
    pci_exp_1_rxp,
    pci_exp_1_rxn,
    pci_exp_2_txp,
    pci_exp_2_txn,
    pci_exp_2_rxp,
    pci_exp_2_rxn,
    pci_exp_3_txp,
    pci_exp_3_txn,
    pci_exp_3_rxp,
    pci_exp_3_rxn,
    pci_exp_4_txp,
    pci_exp_4_txn,
    pci_exp_4_rxp,
    pci_exp_4_rxn,
    pci_exp_5_txp,
    pci_exp_5_txn,
    pci_exp_5_rxp,
    pci_exp_5_rxn,
    pci_exp_6_txp,
    pci_exp_6_txn,
    pci_exp_6_rxp,
    pci_exp_6_rxn,
    pci_exp_7_txp,
    pci_exp_7_txn,
    pci_exp_7_rxp,
    pci_exp_7_rxn,
    M_AXI_LITE_ACLK,
    M_AXI_LITE_ARESETN,
    M_AXI_LITE_AWADDR,
    M_AXI_LITE_AWVALID,
    M_AXI_LITE_AWREADY,
    M_AXI_LITE_WDATA,
    M_AXI_LITE_WSTRB,
    M_AXI_LITE_WVALID,
    M_AXI_LITE_WREADY,
    M_AXI_LITE_BRESP,
    M_AXI_LITE_BVALID,
    M_AXI_LITE_BREADY,
    M_AXI_LITE_ARADDR,
    M_AXI_LITE_ARVALID,
    M_AXI_LITE_ARREADY,
    M_AXI_LITE_RDATA,
    M_AXI_LITE_RRESP,
    M_AXI_LITE_RVALID,
    M_AXI_LITE_RREADY,
    S_AXI_ACLK,
    S_AXI_ARESETN,
    S_AXI_AWADDR,
    S_AXI_AWVALID,
    S_AXI_AWREADY,
    S_AXI_WDATA,
    S_AXI_WSTRB,
    S_AXI_WVALID,
    S_AXI_WREADY,
    S_AXI_BRESP,
    S_AXI_BVALID,
    S_AXI_BREADY,
    S_AXI_ARADDR,
    S_AXI_ARVALID,
    S_AXI_ARREADY,
    S_AXI_RDATA,
    S_AXI_RRESP,
    S_AXI_RVALID,
    S_AXI_RREADY,
    M_AXIS_ACLK,
    M_AXIS_TDATA,
    M_AXIS_TSTRB,
    M_AXIS_TUSER,
    M_AXIS_TVALID,
    M_AXIS_TREADY,
    M_AXIS_TLAST,
    S_AXIS_ACLK,
    S_AXIS_TDATA,
    S_AXIS_TSTRB,
    S_AXIS_TUSER,
    S_AXIS_TVALID,
    S_AXIS_TREADY,
    S_AXIS_TLAST
  );
  input reset_n;
  input pcie_clk_p;
  input pcie_clk_n;
  output pci_exp_0_txp;
  output pci_exp_0_txn;
  input pci_exp_0_rxp;
  input pci_exp_0_rxn;
  output pci_exp_1_txp;
  output pci_exp_1_txn;
  input pci_exp_1_rxp;
  input pci_exp_1_rxn;
  output pci_exp_2_txp;
  output pci_exp_2_txn;
  input pci_exp_2_rxp;
  input pci_exp_2_rxn;
  output pci_exp_3_txp;
  output pci_exp_3_txn;
  input pci_exp_3_rxp;
  input pci_exp_3_rxn;
  output pci_exp_4_txp;
  output pci_exp_4_txn;
  input pci_exp_4_rxp;
  input pci_exp_4_rxn;
  output pci_exp_5_txp;
  output pci_exp_5_txn;
  input pci_exp_5_rxp;
  input pci_exp_5_rxn;
  output pci_exp_6_txp;
  output pci_exp_6_txn;
  input pci_exp_6_rxp;
  input pci_exp_6_rxn;
  output pci_exp_7_txp;
  output pci_exp_7_txn;
  input pci_exp_7_rxp;
  input pci_exp_7_rxn;
  input M_AXI_LITE_ACLK;
  input M_AXI_LITE_ARESETN;
  output [31:0] M_AXI_LITE_AWADDR;
  output M_AXI_LITE_AWVALID;
  input M_AXI_LITE_AWREADY;
  output [31:0] M_AXI_LITE_WDATA;
  output [3:0] M_AXI_LITE_WSTRB;
  output M_AXI_LITE_WVALID;
  input M_AXI_LITE_WREADY;
  input [1:0] M_AXI_LITE_BRESP;
  input M_AXI_LITE_BVALID;
  output M_AXI_LITE_BREADY;
  output [31:0] M_AXI_LITE_ARADDR;
  output M_AXI_LITE_ARVALID;
  input M_AXI_LITE_ARREADY;
  input [31:0] M_AXI_LITE_RDATA;
  input [1:0] M_AXI_LITE_RRESP;
  input M_AXI_LITE_RVALID;
  output M_AXI_LITE_RREADY;
  input S_AXI_ACLK;
  input S_AXI_ARESETN;
  input [31:0] S_AXI_AWADDR;
  input S_AXI_AWVALID;
  output S_AXI_AWREADY;
  input [31:0] S_AXI_WDATA;
  input [3:0] S_AXI_WSTRB;
  input S_AXI_WVALID;
  output S_AXI_WREADY;
  output [1:0] S_AXI_BRESP;
  output S_AXI_BVALID;
  input S_AXI_BREADY;
  input [31:0] S_AXI_ARADDR;
  input S_AXI_ARVALID;
  output S_AXI_ARREADY;
  output [31:0] S_AXI_RDATA;
  output [1:0] S_AXI_RRESP;
  output S_AXI_RVALID;
  input S_AXI_RREADY;
  input M_AXIS_ACLK;
  output [255:0] M_AXIS_TDATA;
  output [31:0] M_AXIS_TSTRB;
  output [127:0] M_AXIS_TUSER;
  output M_AXIS_TVALID;
  input M_AXIS_TREADY;
  output M_AXIS_TLAST;
  input S_AXIS_ACLK;
  input [255:0] S_AXIS_TDATA;
  input [31:0] S_AXIS_TSTRB;
  input [127:0] S_AXIS_TUSER;
  input S_AXIS_TVALID;
  output S_AXIS_TREADY;
  input S_AXIS_TLAST;

  dma
    #(
      .C_M_AXIS_DATA_WIDTH ( 256 ),
      .C_S_AXIS_DATA_WIDTH ( 256 ),
      .C_BASEADDR ( 32'h7d400000 ),
      .C_HIGHADDR ( 32'h7d40ffff )
    )
    dma_0 (
      .reset_n ( reset_n ),
      .pcie_clk_p ( pcie_clk_p ),
      .pcie_clk_n ( pcie_clk_n ),
      .pci_exp_0_txp ( pci_exp_0_txp ),
      .pci_exp_0_txn ( pci_exp_0_txn ),
      .pci_exp_0_rxp ( pci_exp_0_rxp ),
      .pci_exp_0_rxn ( pci_exp_0_rxn ),
      .pci_exp_1_txp ( pci_exp_1_txp ),
      .pci_exp_1_txn ( pci_exp_1_txn ),
      .pci_exp_1_rxp ( pci_exp_1_rxp ),
      .pci_exp_1_rxn ( pci_exp_1_rxn ),
      .pci_exp_2_txp ( pci_exp_2_txp ),
      .pci_exp_2_txn ( pci_exp_2_txn ),
      .pci_exp_2_rxp ( pci_exp_2_rxp ),
      .pci_exp_2_rxn ( pci_exp_2_rxn ),
      .pci_exp_3_txp ( pci_exp_3_txp ),
      .pci_exp_3_txn ( pci_exp_3_txn ),
      .pci_exp_3_rxp ( pci_exp_3_rxp ),
      .pci_exp_3_rxn ( pci_exp_3_rxn ),
      .pci_exp_4_txp ( pci_exp_4_txp ),
      .pci_exp_4_txn ( pci_exp_4_txn ),
      .pci_exp_4_rxp ( pci_exp_4_rxp ),
      .pci_exp_4_rxn ( pci_exp_4_rxn ),
      .pci_exp_5_txp ( pci_exp_5_txp ),
      .pci_exp_5_txn ( pci_exp_5_txn ),
      .pci_exp_5_rxp ( pci_exp_5_rxp ),
      .pci_exp_5_rxn ( pci_exp_5_rxn ),
      .pci_exp_6_txp ( pci_exp_6_txp ),
      .pci_exp_6_txn ( pci_exp_6_txn ),
      .pci_exp_6_rxp ( pci_exp_6_rxp ),
      .pci_exp_6_rxn ( pci_exp_6_rxn ),
      .pci_exp_7_txp ( pci_exp_7_txp ),
      .pci_exp_7_txn ( pci_exp_7_txn ),
      .pci_exp_7_rxp ( pci_exp_7_rxp ),
      .pci_exp_7_rxn ( pci_exp_7_rxn ),
      .M_AXI_LITE_ACLK ( M_AXI_LITE_ACLK ),
      .M_AXI_LITE_ARESETN ( M_AXI_LITE_ARESETN ),
      .M_AXI_LITE_AWADDR ( M_AXI_LITE_AWADDR ),
      .M_AXI_LITE_AWVALID ( M_AXI_LITE_AWVALID ),
      .M_AXI_LITE_AWREADY ( M_AXI_LITE_AWREADY ),
      .M_AXI_LITE_WDATA ( M_AXI_LITE_WDATA ),
      .M_AXI_LITE_WSTRB ( M_AXI_LITE_WSTRB ),
      .M_AXI_LITE_WVALID ( M_AXI_LITE_WVALID ),
      .M_AXI_LITE_WREADY ( M_AXI_LITE_WREADY ),
      .M_AXI_LITE_BRESP ( M_AXI_LITE_BRESP ),
      .M_AXI_LITE_BVALID ( M_AXI_LITE_BVALID ),
      .M_AXI_LITE_BREADY ( M_AXI_LITE_BREADY ),
      .M_AXI_LITE_ARADDR ( M_AXI_LITE_ARADDR ),
      .M_AXI_LITE_ARVALID ( M_AXI_LITE_ARVALID ),
      .M_AXI_LITE_ARREADY ( M_AXI_LITE_ARREADY ),
      .M_AXI_LITE_RDATA ( M_AXI_LITE_RDATA ),
      .M_AXI_LITE_RRESP ( M_AXI_LITE_RRESP ),
      .M_AXI_LITE_RVALID ( M_AXI_LITE_RVALID ),
      .M_AXI_LITE_RREADY ( M_AXI_LITE_RREADY ),
      .S_AXI_ACLK ( S_AXI_ACLK ),
      .S_AXI_ARESETN ( S_AXI_ARESETN ),
      .S_AXI_AWADDR ( S_AXI_AWADDR ),
      .S_AXI_AWVALID ( S_AXI_AWVALID ),
      .S_AXI_AWREADY ( S_AXI_AWREADY ),
      .S_AXI_WDATA ( S_AXI_WDATA ),
      .S_AXI_WSTRB ( S_AXI_WSTRB ),
      .S_AXI_WVALID ( S_AXI_WVALID ),
      .S_AXI_WREADY ( S_AXI_WREADY ),
      .S_AXI_BRESP ( S_AXI_BRESP ),
      .S_AXI_BVALID ( S_AXI_BVALID ),
      .S_AXI_BREADY ( S_AXI_BREADY ),
      .S_AXI_ARADDR ( S_AXI_ARADDR ),
      .S_AXI_ARVALID ( S_AXI_ARVALID ),
      .S_AXI_ARREADY ( S_AXI_ARREADY ),
      .S_AXI_RDATA ( S_AXI_RDATA ),
      .S_AXI_RRESP ( S_AXI_RRESP ),
      .S_AXI_RVALID ( S_AXI_RVALID ),
      .S_AXI_RREADY ( S_AXI_RREADY ),
      .M_AXIS_ACLK ( M_AXIS_ACLK ),
      .M_AXIS_TDATA ( M_AXIS_TDATA ),
      .M_AXIS_TSTRB ( M_AXIS_TSTRB ),
      .M_AXIS_TUSER ( M_AXIS_TUSER ),
      .M_AXIS_TVALID ( M_AXIS_TVALID ),
      .M_AXIS_TREADY ( M_AXIS_TREADY ),
      .M_AXIS_TLAST ( M_AXIS_TLAST ),
      .S_AXIS_ACLK ( S_AXIS_ACLK ),
      .S_AXIS_TDATA ( S_AXIS_TDATA ),
      .S_AXIS_TSTRB ( S_AXIS_TSTRB ),
      .S_AXIS_TUSER ( S_AXIS_TUSER ),
      .S_AXIS_TVALID ( S_AXIS_TVALID ),
      .S_AXIS_TREADY ( S_AXIS_TREADY ),
      .S_AXIS_TLAST ( S_AXIS_TLAST )
    );

endmodule

