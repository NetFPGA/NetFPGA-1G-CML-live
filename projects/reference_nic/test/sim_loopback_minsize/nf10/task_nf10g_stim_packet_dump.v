/*******************************************************************************
*
*  NetFPGA-10G http://www.netfpga.org
*
*  File:
*        task_nf10g_stim_packet_dump.v
*
*  Project:
*        reference_nic
*
*  Module:
*        system_axisim_rx_tb, system_axisim_txrx_tb
*
*  Author:
*        Jong
*
*  Description:
*        System testbench for reference_nic rx path
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

task nf10g_0_stim_packet_dump;
	
	input [8*64-1:0]	file_in;
	input	[7:0]			port_no;

	integer	file, r;

	reg	[8*64-1:0]	line;
	reg	[255:0]		packetdata;
	reg	[31:0]		packetstrb;
	reg	[127:0]		packettuser;
	reg	[11:0]		nfpacketlen;
	reg	[7:0]			nfpacketcnt;

	begin
		nfpacketlen = 0; nfpacketcnt = 0;

		$display("Start %s data dump at [%t].\n", file_in, $realtime);
	
		file = $fopen(file_in, "r");		

		$fgets(line, file);

			while (line != 0) begin

				r = $sscanf(line,"%h, %h, %h", packetdata, packetstrb, packettuser);

				if (r == 3) begin
					if (packettuser[23:16] == port_no) begin
						nfpacketcnt = (nfpacketlen != 0) ? nfpacketcnt + 1 : nfpacketcnt;
						nfpacketlen = 0;
						if10g_nf0_packet_data[{nfpacketcnt,nfpacketlen}] = packetdata;
						if10g_nf0_packet_tuser[{nfpacketcnt,nfpacketlen}] = packettuser;
						$display("%s data at [%t]:\n", file_in, $realtime);
						$display("ADDR : %d, %d \n", nfpacketcnt,nfpacketlen);
						$display("TDATA : %h \n", if10g_nf0_packet_data[{nfpacketcnt,nfpacketlen}]);
						$display("TUSER : %h \n", if10g_nf0_packet_tuser[{nfpacketcnt,nfpacketlen}]);
					end
					else if (packettuser[23:16] == 8'h00) begin
						nfpacketlen = nfpacketlen + 1;
						if10g_nf0_packet_data[{nfpacketcnt,nfpacketlen}] = packetdata;
						if10g_nf0_packet_tuser[{nfpacketcnt,nfpacketlen}] = packettuser;
						$display("%s data at [%t]:\n", file_in, $realtime);
						$display("ADDR : %d, %d \n", nfpacketcnt,nfpacketlen);
						$display("TDATA : %h \n", if10g_nf0_packet_data[{nfpacketcnt,nfpacketlen}]);
						$display("TUSER : %h \n", if10g_nf0_packet_tuser[{nfpacketcnt,nfpacketlen}]);
					end
				end
				$fgets(line, file);

			end
		$fclose(file);

	end
endtask

task nf10g_1_stim_packet_dump;
	
	input [8*64-1:0]	file_in;
	input	[7:0]			port_no;

	integer	file, r;

	reg	[8*64-1:0]	line;
	reg	[255:0]		packetdata;
	reg	[31:0]		packetstrb;
	reg	[127:0]		packettuser;
	reg	[11:0]		nfpacketlen;
	reg	[7:0]			nfpacketcnt;

	begin
		nfpacketlen = 0; nfpacketcnt = 0;

		$display("Start %s data dump at [%t].\n", file_in, $realtime);
	
		file = $fopen(file_in, "r");		

		$fgets(line, file);

			while (line != 0) begin

				r = $sscanf(line,"%h, %h, %h", packetdata, packetstrb, packettuser);

				if (r == 3) begin
					if (packettuser[23:16] == port_no) begin
						nfpacketcnt = (nfpacketlen != 0) ? nfpacketcnt + 1 : nfpacketcnt;
						nfpacketlen = 0;
						if10g_nf1_packet_data[{nfpacketcnt,nfpacketlen}] = packetdata;
						if10g_nf1_packet_tuser[{nfpacketcnt,nfpacketlen}] = packettuser;
						$display("%s data at [%t]:\n", file_in, $realtime);
						$display("ADDR : %d, %d \n", nfpacketcnt,nfpacketlen);
						$display("TDATA : %h \n", if10g_nf1_packet_data[{nfpacketcnt,nfpacketlen}]);
						$display("TUSER : %h \n", if10g_nf1_packet_tuser[{nfpacketcnt,nfpacketlen}]);
					end
					else if (packettuser[23:16] == 8'h00) begin
						nfpacketlen = nfpacketlen + 1;
						if10g_nf1_packet_data[{nfpacketcnt,nfpacketlen}] = packetdata;
						if10g_nf1_packet_tuser[{nfpacketcnt,nfpacketlen}] = packettuser;
						$display("%s data at [%t]:\n", file_in, $realtime);
						$display("ADDR : %d, %d \n", nfpacketcnt,nfpacketlen);
						$display("TDATA : %h \n", if10g_nf1_packet_data[{nfpacketcnt,nfpacketlen}]);
						$display("TUSER : %h \n", if10g_nf1_packet_tuser[{nfpacketcnt,nfpacketlen}]);
					end
				end
				$fgets(line, file);

			end
		$fclose(file);

	end
endtask

task nf10g_2_stim_packet_dump;
	
	input [8*64-1:0]	file_in;
	input	[7:0]			port_no;

	integer	file, r;

	reg	[8*64-1:0]	line;
	reg	[255:0]		packetdata;
	reg	[31:0]		packetstrb;
	reg	[127:0]		packettuser;
	reg	[11:0]		nfpacketlen;
	reg	[7:0]			nfpacketcnt;

	begin
		nfpacketlen = 0; nfpacketcnt = 0;

		$display("Start %s data dump at [%t].\n", file_in, $realtime);
	
		file = $fopen(file_in, "r");		

		$fgets(line, file);

			while (line != 0) begin

				r = $sscanf(line,"%h, %h, %h", packetdata, packetstrb, packettuser);

				if (r == 3) begin
					if (packettuser[23:16] == port_no) begin
						nfpacketcnt = (nfpacketlen != 0) ? nfpacketcnt + 1 : nfpacketcnt;
						nfpacketlen = 0;
						if10g_nf2_packet_data[{nfpacketcnt,nfpacketlen}] = packetdata;
						if10g_nf2_packet_tuser[{nfpacketcnt,nfpacketlen}] = packettuser;
						$display("%s data at [%t]:\n", file_in, $realtime);
						$display("ADDR : %d, %d \n", nfpacketcnt,nfpacketlen);
						$display("TDATA : %h \n", if10g_nf2_packet_data[{nfpacketcnt,nfpacketlen}]);
						$display("TUSER : %h \n", if10g_nf2_packet_tuser[{nfpacketcnt,nfpacketlen}]);
					end
					else if (packettuser[23:16] == 8'h00) begin
						nfpacketlen = nfpacketlen + 1;
						if10g_nf2_packet_data[{nfpacketcnt,nfpacketlen}] = packetdata;
						if10g_nf2_packet_tuser[{nfpacketcnt,nfpacketlen}] = packettuser;
						$display("%s data at [%t]:\n", file_in, $realtime);
						$display("ADDR : %d, %d \n", nfpacketcnt,nfpacketlen);
						$display("TDATA : %h \n", if10g_nf2_packet_data[{nfpacketcnt,nfpacketlen}]);
						$display("TUSER : %h \n", if10g_nf2_packet_tuser[{nfpacketcnt,nfpacketlen}]);
					end
				end
				$fgets(line, file);

			end
		$fclose(file);

	end
endtask

task nf10g_3_stim_packet_dump;
	
	input [8*64-1:0]	file_in;
	input	[7:0]			port_no;

	integer	file, r;

	reg	[8*64-1:0]	line;
	reg	[255:0]		packetdata;
	reg	[31:0]		packetstrb;
	reg	[127:0]		packettuser;
	reg	[11:0]		nfpacketlen;
	reg	[7:0]			nfpacketcnt;

	begin
		nfpacketlen = 0; nfpacketcnt = 0;

		$display("Start %s data dump at [%t].\n", file_in, $realtime);
	
		file = $fopen(file_in, "r");		

		$fgets(line, file);

			while (line != 0) begin

				r = $sscanf(line,"%h, %h, %h", packetdata, packetstrb, packettuser);

				if (r == 3) begin
					if (packettuser[23:16] == port_no) begin
						nfpacketcnt = (nfpacketlen != 0) ? nfpacketcnt + 1 : nfpacketcnt;
						nfpacketlen = 0;
						if10g_nf3_packet_data[{nfpacketcnt,nfpacketlen}] = packetdata;
						if10g_nf3_packet_tuser[{nfpacketcnt,nfpacketlen}] = packettuser;
						`ifdef DEBUG
							$display("%s data at [%t]:\n", file_in, $realtime);
							$display("ADDR : %d, %d \n", nfpacketcnt,nfpacketlen);
							$display("TDATA : %h \n", if10g_nf3_packet_data[{nfpacketcnt,nfpacketlen}]);
							$display("TUSER : %h \n", if10g_nf3_packet_tuser[{nfpacketcnt,nfpacketlen}]);
						`endif
					end
					else if (packettuser[23:16] == 8'h00) begin
						nfpacketlen = nfpacketlen + 1;
						if10g_nf3_packet_data[{nfpacketcnt,nfpacketlen}] = packetdata;
						if10g_nf3_packet_tuser[{nfpacketcnt,nfpacketlen}] = packettuser;
						`ifdef DEBUG
							$display("%s data at [%t]:\n", file_in, $realtime);
							$display("ADDR : %d, %d \n", nfpacketcnt,nfpacketlen);
							$display("TDATA : %h \n", if10g_nf3_packet_data[{nfpacketcnt,nfpacketlen}]);
							$display("TUSER : %h \n", if10g_nf3_packet_tuser[{nfpacketcnt,nfpacketlen}]);
						`endif
					end
				end
				$fgets(line, file);

			end
		$fclose(file);

	end
endtask


