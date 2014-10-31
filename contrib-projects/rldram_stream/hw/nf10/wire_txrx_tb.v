/*******************************************************************************
*
*  NetFPGA-10G http://www.netfpga.org
*
*  File:
*        wire_txrx_tb.v
*
*  Project:
*        rldram_stream 
*
*  Module:
*        system_axisim_txrx_tb
*
*  Author:
*        Jong Hun HAN
*
*  Description:
*        System testbench for rldram_stream txrx path
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

	wire	[255:0]	in_arbiter_data0	= system_axisim_tb.dut.nf10_input_arbiter_0.s_axis_tdata_0;
	wire	[31:0]	in_arbiter_strb0	= system_axisim_tb.dut.nf10_input_arbiter_0.s_axis_tstrb_0;
	wire	[127:0]	in_arbiter_user0	= system_axisim_tb.dut.nf10_input_arbiter_0.s_axis_tuser_0;
	wire				in_arbiter_valid0	= system_axisim_tb.dut.nf10_input_arbiter_0.s_axis_tvalid_0;
	wire				in_arbiter_last0	= system_axisim_tb.dut.nf10_input_arbiter_0.s_axis_tlast_0;
	wire				in_arbiter_ready0	= system_axisim_tb.dut.nf10_input_arbiter_0.s_axis_tready_0;
	wire	[255:0]	in_arbiter_data1	= system_axisim_tb.dut.nf10_input_arbiter_0.s_axis_tdata_1;
	wire	[31:0]	in_arbiter_strb1	= system_axisim_tb.dut.nf10_input_arbiter_0.s_axis_tstrb_1;
	wire	[127:0]	in_arbiter_user1	= system_axisim_tb.dut.nf10_input_arbiter_0.s_axis_tuser_1;
	wire				in_arbiter_valid1	= system_axisim_tb.dut.nf10_input_arbiter_0.s_axis_tvalid_1;
	wire				in_arbiter_last1	= system_axisim_tb.dut.nf10_input_arbiter_0.s_axis_tlast_1;
	wire				in_arbiter_ready1	= system_axisim_tb.dut.nf10_input_arbiter_0.s_axis_tready_1;
	wire	[255:0]	in_arbiter_data2	= system_axisim_tb.dut.nf10_input_arbiter_0.s_axis_tdata_2;
	wire	[31:0]	in_arbiter_strb2	= system_axisim_tb.dut.nf10_input_arbiter_0.s_axis_tstrb_2;
	wire	[127:0]	in_arbiter_user2	= system_axisim_tb.dut.nf10_input_arbiter_0.s_axis_tuser_2;
	wire				in_arbiter_valid2	= system_axisim_tb.dut.nf10_input_arbiter_0.s_axis_tvalid_2;
	wire				in_arbiter_last2	= system_axisim_tb.dut.nf10_input_arbiter_0.s_axis_tlast_2;
	wire				in_arbiter_ready2	= system_axisim_tb.dut.nf10_input_arbiter_0.s_axis_tready_2;
	wire	[255:0]	in_arbiter_data3	= system_axisim_tb.dut.nf10_input_arbiter_0.s_axis_tdata_3;
	wire	[31:0]	in_arbiter_strb3	= system_axisim_tb.dut.nf10_input_arbiter_0.s_axis_tstrb_3;
	wire	[127:0]	in_arbiter_user3	= system_axisim_tb.dut.nf10_input_arbiter_0.s_axis_tuser_3;
	wire				in_arbiter_valid3	= system_axisim_tb.dut.nf10_input_arbiter_0.s_axis_tvalid_3;
	wire				in_arbiter_last3	= system_axisim_tb.dut.nf10_input_arbiter_0.s_axis_tlast_3;
	wire				in_arbiter_ready3	= system_axisim_tb.dut.nf10_input_arbiter_0.s_axis_tready_3;

	//Internal loop connection
initial begin	
	force	system_axisim_tb.dut.nf10_input_arbiter_0.s_axis_tdata_0			= nf0_if_data;
	force	system_axisim_tb.dut.nf10_input_arbiter_0.s_axis_tstrb_0			= nf0_if_strb;
	force	system_axisim_tb.dut.nf10_input_arbiter_0.s_axis_tuser_0			= {nf0_if_user[127:24],1'b0,nf0_if_user[23:17],nf0_if_user[15:0]};
	force	system_axisim_tb.dut.nf10_input_arbiter_0.s_axis_tvalid_0		= nf0_if_valid;
	force	system_axisim_tb.dut.nf10_input_arbiter_0.s_axis_tlast_0			= nf0_if_last;
	force	system_axisim_tb.dut.nf10_bram_output_queues_0.m_axis_tready_0	= in_arbiter_ready0;

	force	system_axisim_tb.dut.nf10_input_arbiter_0.s_axis_tdata_1			= nf1_if_data;
	force	system_axisim_tb.dut.nf10_input_arbiter_0.s_axis_tstrb_1			= nf1_if_strb;
	force	system_axisim_tb.dut.nf10_input_arbiter_0.s_axis_tuser_1			= {nf1_if_user[127:24],1'b0,nf1_if_user[23:17],nf1_if_user[15:0]};
	force	system_axisim_tb.dut.nf10_input_arbiter_0.s_axis_tvalid_1		= nf1_if_valid;
	force	system_axisim_tb.dut.nf10_input_arbiter_0.s_axis_tlast_1			= nf1_if_last;
	force	system_axisim_tb.dut.nf10_bram_output_queues_0.m_axis_tready_1	= in_arbiter_ready1;

	force	system_axisim_tb.dut.nf10_input_arbiter_0.s_axis_tdata_2			= nf2_if_data;
	force	system_axisim_tb.dut.nf10_input_arbiter_0.s_axis_tstrb_2			= nf2_if_strb;
	force	system_axisim_tb.dut.nf10_input_arbiter_0.s_axis_tuser_2			= {nf2_if_user[127:24],1'b0,nf2_if_user[23:17],nf2_if_user[15:0]};
	force	system_axisim_tb.dut.nf10_input_arbiter_0.s_axis_tvalid_2		= nf2_if_valid;
	force	system_axisim_tb.dut.nf10_input_arbiter_0.s_axis_tlast_2			= nf2_if_last;
	force	system_axisim_tb.dut.nf10_bram_output_queues_0.m_axis_tready_2	= in_arbiter_ready2;

	force	system_axisim_tb.dut.nf10_input_arbiter_0.s_axis_tdata_3			= nf3_if_data;
	force	system_axisim_tb.dut.nf10_input_arbiter_0.s_axis_tstrb_3			= nf3_if_strb;
	force	system_axisim_tb.dut.nf10_input_arbiter_0.s_axis_tuser_3			= {nf3_if_user[127:24],1'b0,nf3_if_user[23:17],nf3_if_user[15:0]};
	force	system_axisim_tb.dut.nf10_input_arbiter_0.s_axis_tvalid_3		= nf3_if_valid;
	force	system_axisim_tb.dut.nf10_input_arbiter_0.s_axis_tlast_3			= nf3_if_last;
	force	system_axisim_tb.dut.nf10_bram_output_queues_0.m_axis_tready_3	= in_arbiter_ready3;
end

