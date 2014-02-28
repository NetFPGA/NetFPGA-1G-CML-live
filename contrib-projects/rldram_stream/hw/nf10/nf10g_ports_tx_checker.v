/*******************************************************************************
*
*  NetFPGA-10G http://www.netfpga.org
*
*  File:
*        nf10g_ports_tx_checker.v
*
*  Project:
*        rldram_stream 
*
*  Module:
*        system_axisim_tx_tb, system_axisim_txrx_tb
*
*  Author:
*        Jong Hun HAN
*
*  Description:
*        System testbench for rldram_stream _tx_ path
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

always @(posedge bram_axis_clk or negedge RESET)
		if (~RESET) begin
			nf0_tx_packet_len <= 0;
			nf0_tx_packet_cnt	<= 0;
		end
		else if (nf0_if_valid & nf0_if_ready & nf0_if_last) begin
			nf0_tx_packet_len	<= 0;
			nf0_tx_packet_cnt	<= nf0_tx_packet_cnt + 1;
		end
		else if (nf0_if_valid & nf0_if_ready) begin
			nf0_tx_packet_len	<= nf0_tx_packet_len + 1;
		end

	always @(negedge bram_axis_clk)
		if (nf0_if_valid) begin
			if (dma_nf0_packet_data[{nf0_tx_packet_cnt,nf0_tx_packet_len}] != nf0_if_data) begin
				$display("FAIL : nf0 port Tx data differ from DMA data at [%t]!\n", $realtime);
				$display("%d th Tx Packet, %d th Packet length:\n", nf0_tx_packet_cnt, nf0_tx_packet_len);
				$display("DMA : %h\n", dma_nf0_packet_data[{nf0_tx_packet_cnt,nf0_tx_packet_len}]);
				$display("NF0 : %h\n\n", nf0_if_data);
			end
			else if (nf0_if_last) begin
				$display("PASS : nf0 port Tx data differ from DMA data [%t]!\n", $realtime);
				$display("%d th Tx Packet, %d th Packet length:\n", nf0_tx_packet_cnt, nf0_tx_packet_len);
				$display("DMA : %h\n", dma_nf0_packet_data[{nf0_tx_packet_cnt,nf0_tx_packet_len}]);
				$display("NF0 : %h\n\n", nf0_if_data);
			end
		end

	always @(posedge bram_axis_clk or negedge RESET)
		if (~RESET) begin
			nf1_tx_packet_len <= 0;
			nf1_tx_packet_cnt	<= 0;
		end
		else if (nf1_if_valid & nf1_if_ready & nf1_if_last) begin
			nf1_tx_packet_len	<= 0;
			nf1_tx_packet_cnt	<= nf1_tx_packet_cnt + 1;
		end
		else if (nf1_if_valid & nf1_if_ready) begin
			nf1_tx_packet_len	<= nf1_tx_packet_len + 1;
		end

	always @(negedge bram_axis_clk)
		if (nf1_if_valid) begin
			if (dma_nf1_packet_data[{nf1_tx_packet_cnt,nf1_tx_packet_len}] != nf1_if_data) begin
				$display("FAIL : nf1 port Tx data differ from DMA data at [%t]!\n", $realtime);
				$display("%d th Tx Packet, %d th Packet length:\n", nf1_tx_packet_cnt, nf1_tx_packet_len);
				$display("DMA : %h\n", dma_nf1_packet_data[{nf1_tx_packet_cnt,nf1_tx_packet_len}]);
				$display("NF1 : %h\n\n", nf1_if_data);
			end
			else if (nf1_if_last) begin
				$display("PASS : nf1 port Tx data differ from DMA data [%t]!\n", $realtime);
				$display("%d th Tx Packet, %d th Packet length:\n", nf1_tx_packet_cnt, nf1_tx_packet_len);
				$display("DMA : %h\n", dma_nf1_packet_data[{nf1_tx_packet_cnt,nf1_tx_packet_len}]);
				$display("NF1 : %h\n\n", nf1_if_data);
			end
		end

	always @(posedge bram_axis_clk or negedge RESET)
		if (~RESET) begin
			nf2_tx_packet_len <= 0;
			nf2_tx_packet_cnt	<= 0;
		end
		else if (nf2_if_valid & nf2_if_ready & nf2_if_last) begin
			nf2_tx_packet_len	<= 0;
			nf2_tx_packet_cnt	<= nf2_tx_packet_cnt + 1;
		end
		else if (nf2_if_valid & nf2_if_ready) begin
			nf2_tx_packet_len	<= nf2_tx_packet_len + 1;
		end


	always @(negedge bram_axis_clk)
		if (nf2_if_valid) begin
			if (dma_nf2_packet_data[{nf2_tx_packet_cnt,nf2_tx_packet_len}] != nf2_if_data) begin
				$display("FAIL : nf2 port Tx data differ from DMA data at [%t]!\n", $realtime);
				$display("%d th Tx Packet, %d th Packet length:\n", nf2_tx_packet_cnt, nf2_tx_packet_len);
				$display("DMA : %h\n", dma_nf2_packet_data[{nf2_tx_packet_cnt,nf2_tx_packet_len}]);
				$display("NF2 : %h\n\n", nf2_if_data);
			end
			else if (nf2_if_last) begin
				$display("PASS : nf2 port Tx data differ from DMA data [%t]!\n", $realtime);
				$display("%d th Tx Packet, %d th Packet length:\n", nf2_tx_packet_cnt, nf2_tx_packet_len);
				$display("DMA : %h\n", dma_nf2_packet_data[{nf2_tx_packet_cnt,nf2_tx_packet_len}]);
				$display("NF2 : %h\n\n", nf2_if_data);
			end
		end

	always @(posedge bram_axis_clk or negedge RESET)
		if (~RESET) begin
			nf3_tx_packet_len <= 0;
			nf3_tx_packet_cnt	<= 0;
		end
		else if (nf3_if_valid & nf3_if_ready & nf3_if_last) begin
			nf3_tx_packet_len	<= 0;
			nf3_tx_packet_cnt	<= nf3_tx_packet_cnt + 1;
		end
		else if (nf3_if_valid & nf3_if_ready) begin
			nf3_tx_packet_len	<= nf3_tx_packet_len + 1;
		end


	always @(negedge bram_axis_clk)
		if (nf3_if_valid) begin
			if (dma_nf3_packet_data[{nf3_tx_packet_cnt,nf3_tx_packet_len}] != nf3_if_data) begin
				$display("FAIL : nf3 port Tx data differ from DMA data at [%t]!\n", $realtime);
				$display("%d th Tx Packet, %d th Packet length:\n", nf3_tx_packet_cnt, nf3_tx_packet_len);
				$display("DMA : %h\n", dma_nf3_packet_data[{nf3_tx_packet_cnt,nf3_tx_packet_len}]);
				$display("NF3 : %h\n\n", nf3_if_data);
			end
			else if (nf3_if_last) begin
				$display("PASS : nf3 port Tx data differ from DMA data [%t]!\n", $realtime);
				$display("%d th Tx Packet, %d th Packet length:\n", nf3_tx_packet_cnt, nf3_tx_packet_len);
				$display("DMA : %h\n", dma_nf3_packet_data[{nf3_tx_packet_cnt,nf3_tx_packet_len}]);
				$display("NF3 : %h\n\n", nf3_if_data);
			end
		end


