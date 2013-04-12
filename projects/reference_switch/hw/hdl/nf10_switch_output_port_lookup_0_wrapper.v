//-----------------------------------------------------------------------------
// nf10_switch_output_port_lookup_0_wrapper.v
//-----------------------------------------------------------------------------

module nf10_switch_output_port_lookup_0_wrapper
  (
    S_AXI_ACLK,
    S_AXI_ARESETN,
    M_AXIS_TDATA,
    M_AXIS_TSTRB,
    M_AXIS_TUSER,
    M_AXIS_TVALID,
    M_AXIS_TREADY,
    M_AXIS_TLAST,
    S_AXIS_TDATA,
    S_AXIS_TSTRB,
    S_AXIS_TUSER,
    S_AXIS_TVALID,
    S_AXIS_TREADY,
    S_AXIS_TLAST,
    S_AXI_AWADDR,
    S_AXI_AWVALID,
    S_AXI_WDATA,
    S_AXI_WSTRB,
    S_AXI_WVALID,
    S_AXI_BREADY,
    S_AXI_ARADDR,
    S_AXI_ARVALID,
    S_AXI_RREADY,
    S_AXI_ARREADY,
    S_AXI_RDATA,
    S_AXI_RRESP,
    S_AXI_RVALID,
    S_AXI_WREADY,
    S_AXI_BRESP,
    S_AXI_BVALID,
    S_AXI_AWREADY
  );
  input S_AXI_ACLK;
  input S_AXI_ARESETN;
  output [255:0] M_AXIS_TDATA;
  output [31:0] M_AXIS_TSTRB;
  output [127:0] M_AXIS_TUSER;
  output M_AXIS_TVALID;
  input M_AXIS_TREADY;
  output M_AXIS_TLAST;
  input [255:0] S_AXIS_TDATA;
  input [31:0] S_AXIS_TSTRB;
  input [127:0] S_AXIS_TUSER;
  input S_AXIS_TVALID;
  output S_AXIS_TREADY;
  input S_AXIS_TLAST;
  input [31:0] S_AXI_AWADDR;
  input S_AXI_AWVALID;
  input [31:0] S_AXI_WDATA;
  input [3:0] S_AXI_WSTRB;
  input S_AXI_WVALID;
  input S_AXI_BREADY;
  input [31:0] S_AXI_ARADDR;
  input S_AXI_ARVALID;
  input S_AXI_RREADY;
  output S_AXI_ARREADY;
  output [31:0] S_AXI_RDATA;
  output [1:0] S_AXI_RRESP;
  output S_AXI_RVALID;
  output S_AXI_WREADY;
  output [1:0] S_AXI_BRESP;
  output S_AXI_BVALID;
  output S_AXI_AWREADY;

  nf10_switch_output_port_lookup
    #(
      .C_S_AXI_DATA_WIDTH ( 32 ),
      .C_S_AXI_ADDR_WIDTH ( 32 ),
      .C_BASEADDR ( 32'h74800000 ),
      .C_HIGHADDR ( 32'h7480ffff ),
      .C_FAMILY ( "virtex5" ),
      .C_S_AXI_ACLK_FREQ_HZ ( 160000000 ),
      .C_M_AXIS_DATA_WIDTH ( 256 ),
      .C_S_AXIS_DATA_WIDTH ( 256 ),
      .C_M_AXIS_TUSER_WIDTH ( 128 ),
      .C_S_AXIS_TUSER_WIDTH ( 128 )
    )
    nf10_switch_output_port_lookup_0 (
      .S_AXI_ACLK ( S_AXI_ACLK ),
      .S_AXI_ARESETN ( S_AXI_ARESETN ),
      .M_AXIS_TDATA ( M_AXIS_TDATA ),
      .M_AXIS_TSTRB ( M_AXIS_TSTRB ),
      .M_AXIS_TUSER ( M_AXIS_TUSER ),
      .M_AXIS_TVALID ( M_AXIS_TVALID ),
      .M_AXIS_TREADY ( M_AXIS_TREADY ),
      .M_AXIS_TLAST ( M_AXIS_TLAST ),
      .S_AXIS_TDATA ( S_AXIS_TDATA ),
      .S_AXIS_TSTRB ( S_AXIS_TSTRB ),
      .S_AXIS_TUSER ( S_AXIS_TUSER ),
      .S_AXIS_TVALID ( S_AXIS_TVALID ),
      .S_AXIS_TREADY ( S_AXIS_TREADY ),
      .S_AXIS_TLAST ( S_AXIS_TLAST ),
      .S_AXI_AWADDR ( S_AXI_AWADDR ),
      .S_AXI_AWVALID ( S_AXI_AWVALID ),
      .S_AXI_WDATA ( S_AXI_WDATA ),
      .S_AXI_WSTRB ( S_AXI_WSTRB ),
      .S_AXI_WVALID ( S_AXI_WVALID ),
      .S_AXI_BREADY ( S_AXI_BREADY ),
      .S_AXI_ARADDR ( S_AXI_ARADDR ),
      .S_AXI_ARVALID ( S_AXI_ARVALID ),
      .S_AXI_RREADY ( S_AXI_RREADY ),
      .S_AXI_ARREADY ( S_AXI_ARREADY ),
      .S_AXI_RDATA ( S_AXI_RDATA ),
      .S_AXI_RRESP ( S_AXI_RRESP ),
      .S_AXI_RVALID ( S_AXI_RVALID ),
      .S_AXI_WREADY ( S_AXI_WREADY ),
      .S_AXI_BRESP ( S_AXI_BRESP ),
      .S_AXI_BVALID ( S_AXI_BVALID ),
      .S_AXI_AWREADY ( S_AXI_AWREADY )
    );

endmodule

