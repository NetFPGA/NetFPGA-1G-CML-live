/*******************************************************************************
 *
 *  NetFPGA-10G http://www.netfpga.org
 *
 *  File:
 *        nf10_endianess_manager.v
 *
 *  Library:
 *        hw/contrib/pcores/nf10_endianess_manager_v1_00_a
 *
 *  Module:
 *        nf10_endianess_manager
 *
 *  Author:
 *        Gianni Antichi
 *
 *  Description:
 *        Little Endian to Big Endian conversion library.
 *
 *  Copyright notice:
 *        Copyright (C) 2010, 2011 The Board of Trustees of The Leland Stanford
 *                                 Junior University
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

module nf10_endianess_manager
#(
        parameter       C_S_AXIS_TDATA_WIDTH = 256,
        parameter       C_M_AXIS_TDATA_WIDTH = 256,
        parameter       C_M_AXIS_TUSER_WIDTH = 128,
        parameter       C_S_AXIS_TUSER_WIDTH = 128
)
(
	input                                         ACLK,
	input                                         ARESETN,

	output     [(C_M_AXIS_TDATA_WIDTH/8)-1:0]     M_AXIS_TSTRB,
	output     [C_M_AXIS_TUSER_WIDTH-1:0]         M_AXIS_TUSER,
	input      [(C_S_AXIS_TDATA_WIDTH/8)-1:0]     S_AXIS_TSTRB,
	input      [C_S_AXIS_TUSER_WIDTH-1:0]         S_AXIS_TUSER,
	
        output                                        S_AXIS_TREADY,
	input      [C_S_AXIS_TDATA_WIDTH-1:0]         S_AXIS_TDATA,
	input                                         S_AXIS_TLAST,
	input                                         S_AXIS_TVALID,

	output                                        M_AXIS_TVALID,
	output     [C_M_AXIS_TDATA_WIDTH-1:0]         M_AXIS_TDATA,
	output                                        M_AXIS_TLAST,
	input                                         M_AXIS_TREADY,

        output     [(C_M_AXIS_TDATA_WIDTH/8)-1:0]     M_AXIS_TSTRB_INT,
        output     [C_M_AXIS_TUSER_WIDTH-1:0]         M_AXIS_TUSER_INT,
        input      [(C_S_AXIS_TDATA_WIDTH/8)-1:0]     S_AXIS_TSTRB_INT,
        input      [C_S_AXIS_TUSER_WIDTH-1:0]         S_AXIS_TUSER_INT,

        output                                        S_AXIS_TREADY_INT,
        input      [C_S_AXIS_TDATA_WIDTH-1:0]         S_AXIS_TDATA_INT,
        input                                         S_AXIS_TLAST_INT,
        input                                         S_AXIS_TVALID_INT,

        output                                        M_AXIS_TVALID_INT,
        output     [C_M_AXIS_TDATA_WIDTH-1:0]         M_AXIS_TDATA_INT,
        output                                        M_AXIS_TLAST_INT,
        input                                         M_AXIS_TREADY_INT



);

  /* ------------------------------------------
   *  little endian ---> big endian 
   *  ----------------------------------------- */

  bridge
  #(
     .C_AXIS_DATA_WIDTH (C_M_AXIS_TDATA_WIDTH),
     .C_AXIS_TUSER_WIDTH (C_M_AXIS_TUSER_WIDTH)
   ) le_be_bridge
   (
   // Global Ports
   	.clk(ACLK),
        .reset(~ARESETN),
   // little endian signals
        .s_axis_tready(S_AXIS_TREADY),
        .s_axis_tdata(S_AXIS_TDATA),
        .s_axis_tlast(S_AXIS_TLAST),
        .s_axis_tvalid(S_AXIS_TVALID),
        .s_axis_tuser(S_AXIS_TUSER),
        .s_axis_tstrb(S_AXIS_TSTRB),
   // big endian signals
	.m_axis_tready(M_AXIS_TREADY_INT),
        .m_axis_tdata(M_AXIS_TDATA_INT),
        .m_axis_tlast(M_AXIS_TLAST_INT),
        .m_axis_tvalid(M_AXIS_TVALID_INT),
        .m_axis_tuser(M_AXIS_TUSER_INT),
        .m_axis_tstrb(M_AXIS_TSTRB_INT)
   );

  
  /* ------------------------------------------
   *  big endian ---> little endian 
   *  ----------------------------------------- */

  bridge
  #(
    .C_AXIS_DATA_WIDTH (C_S_AXIS_TDATA_WIDTH),
    .C_AXIS_TUSER_WIDTH (C_S_AXIS_TUSER_WIDTH)
  ) be_le_bridge
   (
     // Global Ports
	.clk(ACLK),
        .reset(~ARESETN),
     // big endian signals
	.s_axis_tready(S_AXIS_TREADY_INT),
        .s_axis_tdata(S_AXIS_TDATA_INT),
        .s_axis_tlast(S_AXIS_TLAST_INT),
        .s_axis_tvalid(S_AXIS_TVALID_INT),
        .s_axis_tuser(S_AXIS_TUSER_INT),
        .s_axis_tstrb(S_AXIS_TSTRB_INT),
     // little endian signals
        .m_axis_tready(M_AXIS_TREADY),
        .m_axis_tdata(M_AXIS_TDATA),
        .m_axis_tlast(M_AXIS_TLAST),
        .m_axis_tvalid(M_AXIS_TVALID),
        .m_axis_tuser(M_AXIS_TUSER),
        .m_axis_tstrb(M_AXIS_TSTRB)
    );
   
endmodule
