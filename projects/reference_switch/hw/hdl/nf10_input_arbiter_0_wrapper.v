//-----------------------------------------------------------------------------
// nf10_input_arbiter_0_wrapper.v
//-----------------------------------------------------------------------------

module nf10_input_arbiter_0_wrapper
  (
    axi_aclk,
    axi_resetn,
    m_axis_tdata,
    m_axis_tstrb,
    m_axis_tuser,
    m_axis_tvalid,
    m_axis_tready,
    m_axis_tlast,
    s_axis_tdata_0,
    s_axis_tstrb_0,
    s_axis_tuser_0,
    s_axis_tvalid_0,
    s_axis_tready_0,
    s_axis_tlast_0,
    s_axis_tdata_1,
    s_axis_tstrb_1,
    s_axis_tuser_1,
    s_axis_tvalid_1,
    s_axis_tready_1,
    s_axis_tlast_1,
    s_axis_tdata_2,
    s_axis_tstrb_2,
    s_axis_tuser_2,
    s_axis_tvalid_2,
    s_axis_tready_2,
    s_axis_tlast_2,
    s_axis_tdata_3,
    s_axis_tstrb_3,
    s_axis_tuser_3,
    s_axis_tvalid_3,
    s_axis_tready_3,
    s_axis_tlast_3,
    s_axis_tdata_4,
    s_axis_tstrb_4,
    s_axis_tuser_4,
    s_axis_tvalid_4,
    s_axis_tready_4,
    s_axis_tlast_4
  );
  input axi_aclk;
  input axi_resetn;
  output [255:0] m_axis_tdata;
  output [31:0] m_axis_tstrb;
  output [127:0] m_axis_tuser;
  output m_axis_tvalid;
  input m_axis_tready;
  output m_axis_tlast;
  input [255:0] s_axis_tdata_0;
  input [31:0] s_axis_tstrb_0;
  input [127:0] s_axis_tuser_0;
  input s_axis_tvalid_0;
  output s_axis_tready_0;
  input s_axis_tlast_0;
  input [255:0] s_axis_tdata_1;
  input [31:0] s_axis_tstrb_1;
  input [127:0] s_axis_tuser_1;
  input s_axis_tvalid_1;
  output s_axis_tready_1;
  input s_axis_tlast_1;
  input [255:0] s_axis_tdata_2;
  input [31:0] s_axis_tstrb_2;
  input [127:0] s_axis_tuser_2;
  input s_axis_tvalid_2;
  output s_axis_tready_2;
  input s_axis_tlast_2;
  input [255:0] s_axis_tdata_3;
  input [31:0] s_axis_tstrb_3;
  input [127:0] s_axis_tuser_3;
  input s_axis_tvalid_3;
  output s_axis_tready_3;
  input s_axis_tlast_3;
  input [255:0] s_axis_tdata_4;
  input [31:0] s_axis_tstrb_4;
  input [127:0] s_axis_tuser_4;
  input s_axis_tvalid_4;
  output s_axis_tready_4;
  input s_axis_tlast_4;

  nf10_input_arbiter
    #(
      .C_M_AXIS_DATA_WIDTH ( 256 ),
      .C_S_AXIS_DATA_WIDTH ( 256 ),
      .C_M_AXIS_TUSER_WIDTH ( 128 ),
      .C_S_AXIS_TUSER_WIDTH ( 128 )
    )
    nf10_input_arbiter_0 (
      .axi_aclk ( axi_aclk ),
      .axi_resetn ( axi_resetn ),
      .m_axis_tdata ( m_axis_tdata ),
      .m_axis_tstrb ( m_axis_tstrb ),
      .m_axis_tuser ( m_axis_tuser ),
      .m_axis_tvalid ( m_axis_tvalid ),
      .m_axis_tready ( m_axis_tready ),
      .m_axis_tlast ( m_axis_tlast ),
      .s_axis_tdata_0 ( s_axis_tdata_0 ),
      .s_axis_tstrb_0 ( s_axis_tstrb_0 ),
      .s_axis_tuser_0 ( s_axis_tuser_0 ),
      .s_axis_tvalid_0 ( s_axis_tvalid_0 ),
      .s_axis_tready_0 ( s_axis_tready_0 ),
      .s_axis_tlast_0 ( s_axis_tlast_0 ),
      .s_axis_tdata_1 ( s_axis_tdata_1 ),
      .s_axis_tstrb_1 ( s_axis_tstrb_1 ),
      .s_axis_tuser_1 ( s_axis_tuser_1 ),
      .s_axis_tvalid_1 ( s_axis_tvalid_1 ),
      .s_axis_tready_1 ( s_axis_tready_1 ),
      .s_axis_tlast_1 ( s_axis_tlast_1 ),
      .s_axis_tdata_2 ( s_axis_tdata_2 ),
      .s_axis_tstrb_2 ( s_axis_tstrb_2 ),
      .s_axis_tuser_2 ( s_axis_tuser_2 ),
      .s_axis_tvalid_2 ( s_axis_tvalid_2 ),
      .s_axis_tready_2 ( s_axis_tready_2 ),
      .s_axis_tlast_2 ( s_axis_tlast_2 ),
      .s_axis_tdata_3 ( s_axis_tdata_3 ),
      .s_axis_tstrb_3 ( s_axis_tstrb_3 ),
      .s_axis_tuser_3 ( s_axis_tuser_3 ),
      .s_axis_tvalid_3 ( s_axis_tvalid_3 ),
      .s_axis_tready_3 ( s_axis_tready_3 ),
      .s_axis_tlast_3 ( s_axis_tlast_3 ),
      .s_axis_tdata_4 ( s_axis_tdata_4 ),
      .s_axis_tstrb_4 ( s_axis_tstrb_4 ),
      .s_axis_tuser_4 ( s_axis_tuser_4 ),
      .s_axis_tvalid_4 ( s_axis_tvalid_4 ),
      .s_axis_tready_4 ( s_axis_tready_4 ),
      .s_axis_tlast_4 ( s_axis_tlast_4 )
    );

endmodule

