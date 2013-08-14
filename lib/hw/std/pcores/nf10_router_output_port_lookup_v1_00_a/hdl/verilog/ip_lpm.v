/*******************************************************************************
 * 
 *  NetFPGA-10G http://www.netfpga.org
 *
 *  File:
 *        eth_parser.v
 *
 *  Library:
 *        std/pcores/nf10_router_output_port_lookup_v1_00_a
 *
 *  Module:
 *        ip_lpm
 *
 *  Author:
 *        grg, Gianni Antichi
 *
 *  Description:
 *        
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

  module ip_lpm
    #(parameter C_S_AXIS_DATA_WIDTH=256,
      parameter NUM_QUEUES = 8,
      parameter LUT_DEPTH = 32,
      parameter LUT_DEPTH_BITS = log2(LUT_DEPTH)
      )
   (// --- Interface to the previous stage
    input  [C_S_AXIS_DATA_WIDTH-1:0]   tdata,

    // --- Interface to arp_lut
    output reg [31:0]                  next_hop_ip,
    output reg [NUM_QUEUES-1:0]        lpm_output_port,
    output reg                         lpm_vld,
    output reg                         lpm_hit,

    input			       arp_done,
    output			       dest_fifo_nearly_full,

    // --- Interface to preprocess block
    input                              word_IP_DST_HI,
    input                              word_IP_DST_LO,

    // --- Interface to registers
    // --- Read port
    input  [LUT_DEPTH_BITS-1:0]        lpm_rd_addr,          // address in table to read
    input                              lpm_rd_req,           // request a read
    output [31:0]                      lpm_rd_ip,            // ip to match in the CAM
    output [31:0]                      lpm_rd_mask,          // subnet mask
    output [NUM_QUEUES-1:0]            lpm_rd_oq,            // output queue
    output [31:0]                      lpm_rd_next_hop_ip,   // ip addr of next hop
    output                             lpm_rd_ack,           // pulses high

    // --- Write port
    input [LUT_DEPTH_BITS-1:0]         lpm_wr_addr,
    input                              lpm_wr_req,
    input [NUM_QUEUES-1:0]             lpm_wr_oq,
    input [31:0]                       lpm_wr_next_hop_ip,   // ip addr of next hop
    input [31:0]                       lpm_wr_ip,            // data to match in the CAM
    input [31:0]                       lpm_wr_mask,
    output                             lpm_wr_ack,

    // --- Misc
    input                              reset,
    input                              clk
   );


   function integer log2;
      input integer number;
      begin
         log2=0;
         while(2**log2<number) begin
            log2=log2+1;
         end
      end
   endfunction // log2


   localparam				 WAIT = 1;
   localparam				 PROCESS = 2;

   //---------------------- Wires and regs----------------------------

   wire                                  cam_busy;
   wire                                  cam_match;
   wire [LUT_DEPTH-1:0]                  cam_match_addr;
   wire [31:0]                           cam_cmp_din, cam_cmp_data_mask;
   wire [31:0]                           cam_din, cam_data_mask;
   wire                                  cam_we;
   wire [LUT_DEPTH_BITS-1:0]             cam_wr_addr;

   wire [NUM_QUEUES-1:0]                 lookup_port_result;
   wire [31:0]                           next_hop_ip_result;

   reg                                   dst_ip_vld;
   reg [31:0]                            dst_ip;
   wire [31:0]                           lpm_rd_mask_inverted;

   reg					 rd_dest;
   reg 					 dst_ip_ready;
   wire [31:0]				 dst_ip_fifo;
   wire					 dest_fifo_empty;
  
   reg [1:0]				 state,state_next;
   //------------------------- Modules-------------------------------
   assign                                lpm_rd_mask = ~lpm_rd_mask_inverted;

   // 1 cycle read latency, 16 cycles write latency
   // priority encoded for the smallest address.
   tcam tcam
     (
      // Outputs
      .BUSY                             (cam_busy),
      .MATCH                            (cam_match),
      .MATCH_ADDR                       (cam_match_addr),
      // Inputs
      .CLK                              (clk),
      .CMP_DIN                          (cam_cmp_din),
      .DIN                              (cam_din),
      .CMP_DATA_MASK                    (cam_cmp_data_mask),
      .DATA_MASK                        (cam_data_mask),
      .WE                               (cam_we),
      .WR_ADDR                          (cam_wr_addr));

   unencoded_cam_lut_sm
     #(.CMP_WIDTH          (32),                // IPv4 addr width
       .DATA_WIDTH         (32+NUM_QUEUES),     // next hop ip and output queue
       .LUT_DEPTH          (LUT_DEPTH),
       .DEFAULT_DATA       (1)
      ) cam_lut_sm
       (// --- Interface for lookups
        .lookup_req          (dst_ip_ready),
        .lookup_cmp_data     (dst_ip_fifo),
        .lookup_cmp_dmask    (32'h0),
        .lookup_ack          (lpm_vld_result),
        .lookup_hit          (lpm_hit_result),
        .lookup_data         ({lookup_port_result, next_hop_ip_result}),

        // --- Interface to registers
        // --- Read port
        .rd_addr             (lpm_rd_addr),                        // address in table to read
        .rd_req              (lpm_rd_req),                         // request a read
        .rd_data             ({lpm_rd_oq, lpm_rd_next_hop_ip}),    // data found for the entry
        .rd_cmp_data         (lpm_rd_ip),                          // matching data for the entry
        .rd_cmp_dmask        (lpm_rd_mask_inverted),               // don't cares entry
        .rd_ack              (lpm_rd_ack),                         // pulses high

        // --- Write port
        .wr_addr             (lpm_wr_addr),
        .wr_req              (lpm_wr_req),
        .wr_data             ({lpm_wr_oq, lpm_wr_next_hop_ip}),    // data found for the entry
        .wr_cmp_data         (lpm_wr_ip),                          // matching data for the entry
        .wr_cmp_dmask        (~lpm_wr_mask),                       // don't cares for the entry
        .wr_ack              (lpm_wr_ack),

        // --- CAM interface
        .cam_busy            (cam_busy),
        .cam_match           (cam_match),
        .cam_match_addr      (cam_match_addr),
        .cam_cmp_din         (cam_cmp_din),
        .cam_din             (cam_din),
        .cam_we              (cam_we),
        .cam_wr_addr         (cam_wr_addr),
        .cam_cmp_data_mask   (cam_cmp_data_mask),
        .cam_data_mask       (cam_data_mask),

        // --- Misc
        .reset               (reset),
        .clk                 (clk));

   //------------------------- Logic --------------------------------


   fallthrough_small_fifo #(.WIDTH(32), .MAX_DEPTH_BITS  (2))
      dest_fifo
        (.din           (dst_ip), // Data in
         .wr_en         (dst_ip_vld),             // Write enable
         .rd_en         (rd_dest),       // Read the next word
         .dout          (dst_ip_fifo),
         .full          (),
         .nearly_full   (dest_fifo_nearly_full),
         .prog_full     (),
         .empty         (dest_fifo_empty),
         .reset         (reset),
         .clk           (clk)
         );


    always @(*) begin
	rd_dest = 0;
	dst_ip_ready = 0;
	state_next = state;

	case(state)

		WAIT: begin
			if(!dest_fifo_empty) begin
				rd_dest = 1;
				dst_ip_ready = 1;
				state_next = PROCESS;
			end
		end
	
		PROCESS: begin
			if(arp_done)
				state_next = WAIT;
		end
	endcase
     end		


   always @(posedge clk) begin
	if(reset)
		state <= WAIT;
	else
		state <= state_next;
   end



   /*****************************************************************
    * find the dst IP address and do the lookup
    *****************************************************************/
   always @(posedge clk) begin
      if(reset) begin
         dst_ip <= 0;
         dst_ip_vld <= 0;
      end
      else begin
         if(word_IP_DST_HI) begin
            //dst_ip[15:0] <= tdata[255:240];
            dst_ip[31:16] <= tdata[15:0];
         end
         if(word_IP_DST_LO) begin
            //dst_ip[31:16]  <= tdata[15:0];
            dst_ip[15:0]  <= tdata[255:240];
            dst_ip_vld <= 1;
         end
         else begin
            dst_ip_vld <= 0;
         end
      end // else: !if(reset)
   end // always @ (posedge clk)

   /*****************************************************************
    * latch the outputs
    *****************************************************************/
   always @(posedge clk) begin
      lpm_output_port <= lookup_port_result;
      next_hop_ip     <= (next_hop_ip_result == 0) ? dst_ip_fifo : next_hop_ip_result;
      lpm_hit         <= lpm_hit_result;

      if(reset) begin
         lpm_vld <= 0;
      end
      else begin
         lpm_vld <= lpm_vld_result;
      end // else: !if(reset)
   end // always @ (posedge clk)
endmodule // ip_lpm



