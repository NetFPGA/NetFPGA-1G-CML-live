/*******************************************************************************
*
*  NetFPGA-10G http://www.netfpga.org
*
*  File:
*        system_axisim_rx_tb.v
*
*  Project:
*        reference_nic
*
*  Module:
*        system_axisim_rx_tb, system_axisim_tx_tb, system_axisim_txrx_tb
*
*  Author:
*        Jong HAN
*
*  Description:
*        System testbench for reference_nic tx, rx, txrx path
*
*  Copyright notice:
*        Copyright (C) 2013 University of Cambridge
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

	//DMA Stim packet_ dump for comparing
	reg	[255:0]	dma_nf0_packet_data[0:65536], dma_nf1_packet_data[0:65536],
						dma_nf2_packet_data[0:65536], dma_nf3_packet_data[0:65536];
	reg	[127:0]	dma_nf0_packet_tuser[0:65536], dma_nf1_packet_tuser[0:65536],
						dma_nf2_packet_tuser[0:65536], dma_nf3_packet_tuser[0:65536];

	reg	[255:0]	if10g_nf0_packet_data[0:65536], if10g_nf1_packet_data[0:65536],
						if10g_nf2_packet_data[0:65536], if10g_nf3_packet_data[0:65536];
	reg	[127:0]	if10g_nf0_packet_tuser[0:65536], if10g_nf1_packet_tuser[0:65536],
						if10g_nf2_packet_tuser[0:65536], if10g_nf3_packet_tuser[0:65536];

	wire				bram_axis_clk	= system_axisim_tb.dut.nf10_bram_output_queues_0.axi_aclk;

	wire	[255:0]	nf0_if_data	= system_axisim_tb.dut.nf10_bram_output_queues_0.m_axis_tdata_0;
	wire	[31:0]	nf0_if_strb	= system_axisim_tb.dut.nf10_bram_output_queues_0.m_axis_tstrb_0;
	wire	[127:0]	nf0_if_user	= system_axisim_tb.dut.nf10_bram_output_queues_0.m_axis_tuser_0;
	wire				nf0_if_last	= system_axisim_tb.dut.nf10_bram_output_queues_0.m_axis_tlast_0;
	wire				nf0_if_valid	= system_axisim_tb.dut.nf10_bram_output_queues_0.m_axis_tvalid_0;
	wire				nf0_if_ready	= system_axisim_tb.dut.nf10_bram_output_queues_0.m_axis_tready_0;

	reg	[11:0]	nf0_tx_packet_len;
	reg	[7:0]		nf0_tx_packet_cnt;

	wire	[255:0]	nf1_if_data	= system_axisim_tb.dut.nf10_bram_output_queues_0.m_axis_tdata_1;
	wire	[31:0]	nf1_if_strb	= system_axisim_tb.dut.nf10_bram_output_queues_0.m_axis_tstrb_1;
	wire	[127:0]	nf1_if_user	= system_axisim_tb.dut.nf10_bram_output_queues_0.m_axis_tuser_1;
	wire				nf1_if_last	= system_axisim_tb.dut.nf10_bram_output_queues_0.m_axis_tlast_1;
	wire				nf1_if_valid	= system_axisim_tb.dut.nf10_bram_output_queues_0.m_axis_tvalid_1;
	wire				nf1_if_ready	= system_axisim_tb.dut.nf10_bram_output_queues_0.m_axis_tready_1;

	reg	[11:0]	nf1_tx_packet_len;
	reg	[7:0]		nf1_tx_packet_cnt;

	wire	[255:0]	nf2_if_data	= system_axisim_tb.dut.nf10_bram_output_queues_0.m_axis_tdata_2;
	wire	[31:0]	nf2_if_strb	= system_axisim_tb.dut.nf10_bram_output_queues_0.m_axis_tstrb_2;
	wire	[127:0]	nf2_if_user	= system_axisim_tb.dut.nf10_bram_output_queues_0.m_axis_tuser_2;
	wire				nf2_if_last	= system_axisim_tb.dut.nf10_bram_output_queues_0.m_axis_tlast_2;
	wire				nf2_if_valid	= system_axisim_tb.dut.nf10_bram_output_queues_0.m_axis_tvalid_2;
	wire				nf2_if_ready	= system_axisim_tb.dut.nf10_bram_output_queues_0.m_axis_tready_2;

	reg	[11:0]	nf2_tx_packet_len;
	reg	[7:0]		nf2_tx_packet_cnt;

	wire	[255:0]	nf3_if_data	= system_axisim_tb.dut.nf10_bram_output_queues_0.m_axis_tdata_3;
	wire	[31:0]	nf3_if_strb	= system_axisim_tb.dut.nf10_bram_output_queues_0.m_axis_tstrb_3;
	wire	[127:0]	nf3_if_user	= system_axisim_tb.dut.nf10_bram_output_queues_0.m_axis_tuser_3;
	wire				nf3_if_last	= system_axisim_tb.dut.nf10_bram_output_queues_0.m_axis_tlast_3;
	wire				nf3_if_valid	= system_axisim_tb.dut.nf10_bram_output_queues_0.m_axis_tvalid_3;
	wire				nf3_if_ready	= system_axisim_tb.dut.nf10_bram_output_queues_0.m_axis_tready_3;

	reg	[11:0]	nf3_tx_packet_len;
	reg	[7:0]		nf3_tx_packet_cnt;

