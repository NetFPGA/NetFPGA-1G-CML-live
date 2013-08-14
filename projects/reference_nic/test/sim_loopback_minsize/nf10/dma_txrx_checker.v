/*******************************************************************************
*
*  NetFPGA-10G http://www.netfpga.org
*
*  File:
*        dma_txrx_checker.v
*
*  Project:
*        reference_nic
*
*  Module:
*        system_axisim_txrx_tb
*
*  Author:
*        Jong HAN
*
*  Description:
*        System testbench for reference_nic txrx path
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

	wire	nic_outlook_clk	= system_axisim_tb.dut.nf10_nic_output_port_lookup_0.axi_aclk;

	wire	[255:0]	nic_outlook_data		= system_axisim_tb.dut.nf10_nic_output_port_lookup_0.m_axis_tdata;
	wire	[31:0]	nic_outlook_strb		= system_axisim_tb.dut.nf10_nic_output_port_lookup_0.m_axis_tstrb;
	wire	[127:0]	nic_outlook_user		= system_axisim_tb.dut.nf10_nic_output_port_lookup_0.m_axis_tuser;
	wire				nic_outlook_valid	= system_axisim_tb.dut.nf10_nic_output_port_lookup_0.m_axis_tvalid;
	wire				nic_outlook_ready	= system_axisim_tb.dut.nf10_nic_output_port_lookup_0.m_axis_tready;
	wire				nic_outlook_last		= system_axisim_tb.dut.nf10_nic_output_port_lookup_0.m_axis_tlast;

	reg	[11:0]	nf0_rx_packet_len, nf1_rx_packet_len, nf2_rx_packet_len, nf3_rx_packet_len;
	reg	[7:0]		nf0_rx_packet_cnt, nf1_rx_packet_cnt, nf2_rx_packet_cnt, nf3_rx_packet_cnt;
	reg	[7:0]		nic_outlook_nfno;

	always @(*) 
		if (nic_outlook_user != 0) nic_outlook_nfno = nic_outlook_user[23:16];

	always @(posedge nic_outlook_clk or negedge RESET)
		if (~RESET) begin
			nf0_rx_packet_len <= 0;
			nf0_rx_packet_cnt	<= 0;
			nf1_rx_packet_len <= 0;
			nf1_rx_packet_cnt	<= 0;
			nf2_rx_packet_len <= 0;
			nf2_rx_packet_cnt	<= 0;
			nf3_rx_packet_len <= 0;
			nf3_rx_packet_cnt	<= 0;
	end
		else if (nic_outlook_valid & nic_outlook_ready & nic_outlook_last) begin
			nf0_rx_packet_len	<= 0;
			nf0_rx_packet_cnt	<= (nic_outlook_nfno == 8'h01) ? nf0_rx_packet_cnt + 1 : nf0_rx_packet_cnt;
			nf1_rx_packet_len	<= 0;
			nf1_rx_packet_cnt	<= (nic_outlook_nfno == 8'h04) ? nf1_rx_packet_cnt + 1 : nf1_rx_packet_cnt;
			nf2_rx_packet_len	<= 0;
			nf2_rx_packet_cnt	<= (nic_outlook_nfno == 8'h10) ? nf2_rx_packet_cnt + 1 : nf2_rx_packet_cnt;
			nf3_rx_packet_len	<= 0;
			nf3_rx_packet_cnt	<= (nic_outlook_nfno == 8'h40) ? nf3_rx_packet_cnt + 1 : nf3_rx_packet_cnt;
		end
		else if (nic_outlook_valid & nic_outlook_ready) begin
			nf0_rx_packet_len	<= (nic_outlook_nfno == 8'h01) ? nf0_rx_packet_len + 1 : nf0_rx_packet_len;
			nf1_rx_packet_len	<= (nic_outlook_nfno == 8'h04) ? nf1_rx_packet_len + 1 : nf1_rx_packet_len;
			nf2_rx_packet_len	<= (nic_outlook_nfno == 8'h10) ? nf2_rx_packet_len + 1 : nf2_rx_packet_len;
			nf3_rx_packet_len	<= (nic_outlook_nfno == 8'h40) ? nf3_rx_packet_len + 1 : nf3_rx_packet_len;
		end

	always @(negedge nic_outlook_clk)
		if (nic_outlook_valid & nic_outlook_ready & (nic_outlook_nfno == 8'h01)) begin
			if (dma_nf0_packet_data[{nf0_rx_packet_cnt,nf0_rx_packet_len}] != nic_outlook_data) begin
				$display("FAIL : DMA Rx data differ NF0 data at [%t]!\n", $realtime);
				$display("%d th Rx Packet, %d th Packet length:\n", nf0_rx_packet_cnt, nf0_rx_packet_len);
				$display("NF0 : %h\n", dma_nf0_packet_data[{nf0_rx_packet_cnt,nf0_rx_packet_len}]);
				$display("DMA : %h\n\n", nic_outlook_data);
			end
			else if (nic_outlook_last) begin
				$display("PASS : DMA Rx data differ NF0 data at [%t]!\n", $realtime);
				$display("%d th Rx Packet, %d th Packet length:\n", nf0_rx_packet_cnt, nf0_rx_packet_len);
				$display("NF0 : %h\n", dma_nf0_packet_data[{nf0_rx_packet_cnt,nf0_rx_packet_len}]);
				$display("DMA : %h\n\n", nic_outlook_data);
			end
		end

	always @(negedge nic_outlook_clk)
		if (nic_outlook_valid & nic_outlook_ready & (nic_outlook_nfno == 8'h04)) begin
			if (dma_nf1_packet_data[{nf1_rx_packet_cnt,nf1_rx_packet_len}] != nic_outlook_data) begin
				$display("FAIL : DMA Rx data differ NF1 data at [%t]!\n", $realtime);
				$display("%d th Rx Packet, %d th Packet length:\n", nf1_rx_packet_cnt, nf1_rx_packet_len);
				$display("NF1 : %h\n", dma_nf1_packet_data[{nf1_rx_packet_cnt,nf1_rx_packet_len}]);
				$display("DMA : %h\n\n", nic_outlook_data);
			end
			else if (nic_outlook_last) begin
				$display("PASS : DMA Rx data differ NF1 data at [%t]!\n", $realtime);
				$display("%d th Rx Packet, %d th Packet length:\n", nf1_rx_packet_cnt, nf1_rx_packet_len);
				$display("NF1 : %h\n", dma_nf1_packet_data[{nf1_rx_packet_cnt,nf1_rx_packet_len}]);
				$display("DMA : %h\n\n", nic_outlook_data);
			end
		end

	always @(negedge nic_outlook_clk)
		if (nic_outlook_valid & nic_outlook_ready & (nic_outlook_nfno == 8'h10)) begin
			if (dma_nf2_packet_data[{nf2_rx_packet_cnt,nf2_rx_packet_len}] != nic_outlook_data) begin
				$display("FAIL : DMA Rx data differ NF2 data at [%t]!\n", $realtime);
				$display("%d th Rx Packet, %d th Packet length:\n", nf2_rx_packet_cnt, nf2_rx_packet_len);
				$display("NF2 : %h\n", dma_nf2_packet_data[{nf2_rx_packet_cnt,nf2_rx_packet_len}]);
				$display("DMA : %h\n\n", nic_outlook_data);
			end
			else if (nic_outlook_last) begin
				$display("PASS : DMA Rx data differ NF2 data at [%t]!\n", $realtime);
				$display("%d th Rx Packet, %d th Packet length:\n", nf2_rx_packet_cnt, nf2_rx_packet_len);
				$display("NF2 : %h\n", dma_nf2_packet_data[{nf2_rx_packet_cnt,nf2_rx_packet_len}]);
				$display("DMA : %h\n\n", nic_outlook_data);
			end
		end

	always @(negedge nic_outlook_clk)
		if (nic_outlook_valid & nic_outlook_ready & (nic_outlook_nfno == 8'h40)) begin
			if (dma_nf3_packet_data[{nf3_rx_packet_cnt,nf3_rx_packet_len}] != nic_outlook_data) begin
				$display("FAIL : DMA Rx data differ NF3 data at [%t]!\n", $realtime);
				$display("%d th Rx Packet, %d th Packet length:\n", nf3_rx_packet_cnt, nf3_rx_packet_len);
				$display("NF3 : %h\n", dma_nf3_packet_data[{nf3_rx_packet_cnt,nf3_rx_packet_len}]);
				$display("DMA : %h\n\n", nic_outlook_data);
			end
			else if (nic_outlook_last) begin
				$display("PASS : DMA Rx data differ NF3 data at [%t]!\n", $realtime);
				$display("%d th Rx Packet, %d th Packet length:\n", nf3_rx_packet_cnt, nf3_rx_packet_len);
				$display("NF3 : %h\n", dma_nf3_packet_data[{nf3_rx_packet_cnt,nf3_rx_packet_len}]);
				$display("DMA : %h\n\n", nic_outlook_data);
			end
		end

