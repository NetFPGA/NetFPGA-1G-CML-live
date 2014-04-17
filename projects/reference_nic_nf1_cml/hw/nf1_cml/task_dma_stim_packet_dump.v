/*******************************************************************************
*
*  NetFPGA-10G http://www.netfpga.org
*
*  File:
*        task_dma_stim_packet_dump.v
*
*  Project:
*        reference_nic
*
*  Module:
*        system_axisim_tx_tb, system_axisim_txrx_tb
*
*  Author:
*        Jong
*
*  Description:
*        System testbench for reference_nic tx path
*
*  Copyright notice:
*
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

task dma_stim_packet_dump;

	input [8*64-1:0] file_in;
	integer	file, r;

	reg	[8*64:0]	line;
	reg	[255:0]	packetdata;
	reg	[31:0]	packetstrb;
	reg	[127:0]	packettuser;
	reg	[11:0]	nf0packetlen, nf1packetlen, nf2packetlen, nf3packetlen;
	reg	[7:0]		nf0packetcnt, nf1packetcnt, nf2packetcnt, nf3packetcnt;
	reg	[3:0]		currentport;

	begin
		nf0packetlen = 0; nf1packetlen = 0; nf2packetlen = 0; nf3packetlen = 0; 
		nf0packetcnt = 0; nf1packetcnt = 0; nf2packetcnt = 0; nf3packetcnt = 0; 
		currentport = 0;

		$display("Start %s DMA data dump at [%t].\n", file_in, $realtime);
	
		file = $fopen(file_in, "r");		

		$fgets(line, file);

			while (line != 0) begin

				r = $sscanf(line,"%h, %h, %h", packetdata, packetstrb, packettuser);

				if (r == 3) begin
					if (packettuser[23:16] == 8'h02) begin
						nf0packetcnt = (nf0packetlen != 0) ? nf0packetcnt + 1 : nf0packetcnt;
						nf0packetlen = 0;
						dma_nf0_packet_data[{nf0packetcnt,nf0packetlen}] = packetdata;
						dma_nf0_packet_tuser[{nf0packetcnt,nf0packetlen}] = packettuser;
						currentport = 0;
					end
					else if (packettuser[23:16] == 8'h08) begin
						nf1packetcnt = (nf1packetlen != 0) ? nf1packetcnt + 1 : nf1packetcnt;
						nf1packetlen = 0;
						dma_nf1_packet_data[{nf1packetcnt,nf1packetlen}] = packetdata;
						dma_nf1_packet_tuser[{nf1packetcnt,nf1packetlen}] = packettuser;
						currentport = 1;
					end
					else if (packettuser[23:16] == 8'h20) begin
						nf2packetcnt = (nf2packetlen != 0) ? nf2packetcnt + 1 : nf2packetcnt;
						nf2packetlen = 0;
						dma_nf2_packet_data[{nf2packetcnt,nf2packetlen}] = packetdata;
						dma_nf2_packet_tuser[{nf2packetcnt,nf2packetlen}] = packettuser;
						currentport = 2;
					end
					else if (packettuser[23:16] == 8'h80) begin
						nf3packetcnt = (nf3packetlen != 0) ? nf3packetcnt + 1 : nf3packetcnt;
						nf3packetlen = 0;
						dma_nf3_packet_data[{nf3packetcnt,nf3packetlen}]	= packetdata;
						dma_nf3_packet_tuser[{nf3packetcnt,nf3packetlen}]	= packettuser;
						currentport														= 3;
					end
					else if (packettuser[23:16] == 8'h00) begin
						if (currentport == 0) begin
							nf0packetlen = nf0packetlen + 1;
							dma_nf0_packet_data[{nf0packetcnt,nf0packetlen}]	= packetdata;
							dma_nf0_packet_tuser[{nf0packetcnt,nf0packetlen}]	= packettuser;
							currentport														= 0;
						end
						else if (currentport == 1) begin
							nf1packetlen = nf1packetlen + 1;
							dma_nf1_packet_data[{nf1packetcnt,nf1packetlen}] = packetdata;
							dma_nf1_packet_tuser[{nf1packetcnt,nf1packetlen}] = packettuser;
							currentport = 1;
						end
						else if (currentport == 2) begin
							nf2packetlen = nf2packetlen + 1;
							dma_nf2_packet_data[{nf2packetcnt,nf2packetlen}] = packetdata;
							dma_nf2_packet_tuser[{nf2packetcnt,nf2packetlen}] = packettuser;
							currentport = 2;
						end
						else if (currentport == 3) begin
							nf3packetlen = nf3packetlen + 1;
							dma_nf3_packet_data[{nf3packetcnt,nf3packetlen}] = packetdata;
							dma_nf3_packet_tuser[{nf3packetcnt,nf3packetlen}] = packettuser;
							currentport = 3;
						end
					end
				end
				$fgets(line, file);

			end
		$fclose(file);

	end
endtask
