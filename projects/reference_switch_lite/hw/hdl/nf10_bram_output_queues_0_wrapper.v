//-----------------------------------------------------------------------------
// nf10_bram_output_queues_0_wrapper.v
//-----------------------------------------------------------------------------

module nf10_bram_output_queues_0_wrapper
  (
    axi_aclk,
    axi_resetn,
    s_axis_tdata,
    s_axis_tstrb,
    s_axis_tuser,
    s_axis_tvalid,
    s_axis_tready,
    s_axis_tlast,
    m_axis_tdata_0,
    m_axis_tstrb_0,
    m_axis_tuser_0,
    m_axis_tvalid_0,
    m_axis_tready_0,
    m_axis_tlast_0,
    m_axis_tdata_1,
    m_axis_tstrb_1,
    m_axis_tuser_1,
    m_axis_tvalid_1,
    m_axis_tready_1,
    m_axis_tlast_1,
    m_axis_tdata_2,
    m_axis_tstrb_2,
    m_axis_tuser_2,
    m_axis_tvalid_2,
    m_axis_tready_2,
    m_axis_tlast_2,
    m_axis_tdata_3,
    m_axis_tstrb_3,
    m_axis_tuser_3,
    m_axis_tvalid_3,
    m_axis_tready_3,
    m_axis_tlast_3,
    m_axis_tdata_4,
    m_axis_tstrb_4,
    m_axis_tuser_4,
    m_axis_tvalid_4,
    m_axis_tready_4,
    m_axis_tlast_4
  );
  input axi_aclk;
  input axi_resetn;
  input [255:0] s_axis_tdata;
  input [31:0] s_axis_tstrb;
  input [127:0] s_axis_tuser;
  input s_axis_tvalid;
  output s_axis_tready;
  input s_axis_tlast;
  output [255:0] m_axis_tdata_0;
  output [31:0] m_axis_tstrb_0;
  output [127:0] m_axis_tuser_0;
  output m_axis_tvalid_0;
  input m_axis_tready_0;
  output m_axis_tlast_0;
  output [255:0] m_axis_tdata_1;
  output [31:0] m_axis_tstrb_1;
  output [127:0] m_axis_tuser_1;
  output m_axis_tvalid_1;
  input m_axis_tready_1;
  output m_axis_tlast_1;
  output [255:0] m_axis_tdata_2;
  output [31:0] m_axis_tstrb_2;
  output [127:0] m_axis_tuser_2;
  output m_axis_tvalid_2;
  input m_axis_tready_2;
  output m_axis_tlast_2;
  output [255:0] m_axis_tdata_3;
  output [31:0] m_axis_tstrb_3;
  output [127:0] m_axis_tuser_3;
  output m_axis_tvalid_3;
  input m_axis_tready_3;
  output m_axis_tlast_3;
  output [255:0] m_axis_tdata_4;
  output [31:0] m_axis_tstrb_4;
  output [127:0] m_axis_tuser_4;
  output m_axis_tvalid_4;
  input m_axis_tready_4;
  output m_axis_tlast_4;

  nf10_bram_output_queues
    #(
      .C_M_AXIS_DATA_WIDTH ( 256 ),
      .C_S_AXIS_DATA_WIDTH ( 256 ),
      .C_M_AXIS_TUSER_WIDTH ( 128 ),
      .C_S_AXIS_TUSER_WIDTH ( 128 )
    )
    nf10_bram_output_queues_0 (
      .axi_aclk ( axi_aclk ),
      .axi_resetn ( axi_resetn ),
      .s_axis_tdata ( s_axis_tdata ),
      .s_axis_tstrb ( s_axis_tstrb ),
      .s_axis_tuser ( s_axis_tuser ),
      .s_axis_tvalid ( s_axis_tvalid ),
      .s_axis_tready ( s_axis_tready ),
      .s_axis_tlast ( s_axis_tlast ),
      .m_axis_tdata_0 ( m_axis_tdata_0 ),
      .m_axis_tstrb_0 ( m_axis_tstrb_0 ),
      .m_axis_tuser_0 ( m_axis_tuser_0 ),
      .m_axis_tvalid_0 ( m_axis_tvalid_0 ),
      .m_axis_tready_0 ( m_axis_tready_0 ),
      .m_axis_tlast_0 ( m_axis_tlast_0 ),
      .m_axis_tdata_1 ( m_axis_tdata_1 ),
      .m_axis_tstrb_1 ( m_axis_tstrb_1 ),
      .m_axis_tuser_1 ( m_axis_tuser_1 ),
      .m_axis_tvalid_1 ( m_axis_tvalid_1 ),
      .m_axis_tready_1 ( m_axis_tready_1 ),
      .m_axis_tlast_1 ( m_axis_tlast_1 ),
      .m_axis_tdata_2 ( m_axis_tdata_2 ),
      .m_axis_tstrb_2 ( m_axis_tstrb_2 ),
      .m_axis_tuser_2 ( m_axis_tuser_2 ),
      .m_axis_tvalid_2 ( m_axis_tvalid_2 ),
      .m_axis_tready_2 ( m_axis_tready_2 ),
      .m_axis_tlast_2 ( m_axis_tlast_2 ),
      .m_axis_tdata_3 ( m_axis_tdata_3 ),
      .m_axis_tstrb_3 ( m_axis_tstrb_3 ),
      .m_axis_tuser_3 ( m_axis_tuser_3 ),
      .m_axis_tvalid_3 ( m_axis_tvalid_3 ),
      .m_axis_tready_3 ( m_axis_tready_3 ),
      .m_axis_tlast_3 ( m_axis_tlast_3 ),
      .m_axis_tdata_4 ( m_axis_tdata_4 ),
      .m_axis_tstrb_4 ( m_axis_tstrb_4 ),
      .m_axis_tuser_4 ( m_axis_tuser_4 ),
      .m_axis_tvalid_4 ( m_axis_tvalid_4 ),
      .m_axis_tready_4 ( m_axis_tready_4 ),
      .m_axis_tlast_4 ( m_axis_tlast_4 )
    );

endmodule

