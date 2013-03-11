/*******************************************************************************
 *
 *  NetFPGA-10G http://www.netfpga.org
 *
 *  File:
 *        nf10_encap.v
 *
 *  Library:
 *        hw/contrib/pcores/nf10_encap_v1_00_a
 *
 *  Module:
 *        nf10_encap
 *
 *  Author:
 *        Yilong Geng
 *
 *  Description:
 *        Add additional Ethernet and IP header if needed.
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

module nf10_encap
#(
    //Master AXI Stream Data Width
    parameter C_M_AXIS_DATA_WIDTH=256,
    parameter C_S_AXIS_DATA_WIDTH=256,
    parameter C_M_AXIS_TUSER_WIDTH=128,
    parameter C_S_AXIS_TUSER_WIDTH=128,
    parameter TOTAL_LENGTH_POS=0,
    parameter SRC_PORT_POS=16,
    parameter DST_PORT_POS=24,
    parameter C_BASEADDR=32'hffffffff,
    parameter C_HIGHADDR=32'h0
)
(
    // Global Ports
    input axi_aclk,
    input axi_resetn,

    // Master Stream Ports (interface to data path)
    output reg [C_M_AXIS_DATA_WIDTH - 1:0] m_axis_tdata,
    output reg [((C_M_AXIS_DATA_WIDTH / 8)) - 1:0] m_axis_tstrb,
    output reg [C_M_AXIS_TUSER_WIDTH-1:0] m_axis_tuser,
    output reg m_axis_tvalid,
    input  m_axis_tready,
    output reg m_axis_tlast,

    // Slave Stream Ports (interface to RX queues)
    input [C_S_AXIS_DATA_WIDTH - 1:0] s_axis_tdata,
    input [((C_S_AXIS_DATA_WIDTH / 8)) - 1:0] s_axis_tstrb,
    input [C_S_AXIS_TUSER_WIDTH-1:0] s_axis_tuser,
    input  s_axis_tvalid,
    output s_axis_tready,
    input  s_axis_tlast,

    // axi lite control/status interface
    input          S_AXI_ACLK,
    input          S_AXI_ARESETN,
    input [31:0]   S_AXI_AWADDR,
    input          S_AXI_AWVALID,
    output         S_AXI_AWREADY,
    input [31:0]   S_AXI_WDATA,
    input [3:0]    S_AXI_WSTRB,
    input          S_AXI_WVALID,
    output         S_AXI_WREADY,
    output [1:0]   S_AXI_BRESP,
    output         S_AXI_BVALID,
    input          S_AXI_BREADY,
    input [31:0]   S_AXI_ARADDR,
    input          S_AXI_ARVALID,
    output         S_AXI_ARREADY,
    output [31:0]  S_AXI_RDATA,
    output [1:0]   S_AXI_RRESP,
    output         S_AXI_RVALID,
    input          S_AXI_RREADY
   
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

   // ------------ Internal Params --------
   localparam MODULE_HEADER      = 0;
   localparam IN_PACKET_ENCAP_BEGIN    = 1;
   localparam IN_PACKET_ENCAP_MIDDLE = 2;
   localparam IN_PACKET_ENCAP_END = 3;
   localparam IN_PACKET_NORMAL   = 4;

   //------------- Wires -----------------
   reg [271:0] tdata_queue;
   reg [33:0] tstrb_queue;
   reg [271:0] tdata_queue_next;
   reg [33:0] tstrb_queue_next;

   wire [271:0] ether_ip_header;
   wire encap_begin;

   wire in_fifo_empty;
   reg in_fifo_rd_en;

   wire [C_M_AXIS_DATA_WIDTH - 1:0] fifo_axis_tdata;
   wire [((C_M_AXIS_DATA_WIDTH / 8)) - 1:0] fifo_axis_tstrb;
   wire [C_M_AXIS_TUSER_WIDTH-1:0] fifo_axis_tuser;
   wire fifo_axis_tlast;

   reg [2:0] state;
   reg [2:0] state_next;

   // ------------ Modules ----------------

   fallthrough_small_fifo
        #( .WIDTH(C_M_AXIS_DATA_WIDTH+C_M_AXIS_TUSER_WIDTH+C_M_AXIS_DATA_WIDTH/8+1),
           .MAX_DEPTH_BITS(2))
      input_fifo
        (// Outputs
         .dout                           ({fifo_axis_tlast, fifo_axis_tuser, fifo_axis_tstrb, fifo_axis_tdata}),
         .full                           (),
         .nearly_full                    (in_fifo_nearly_full),
         .prog_full                      (),
         .empty                          (in_fifo_empty),
         // Inputs
         .din                            ({s_axis_tlast, s_axis_tuser, s_axis_tstrb, s_axis_tdata}),
         .wr_en                          (s_axis_tvalid & ~in_fifo_nearly_full),
         .rd_en                          (in_fifo_rd_en),
         .reset                          (~axi_resetn),
         .clk                            (axi_aclk));

   encap_header_lookup
      #(  .C_S_AXIS_TUSER_WIDTH(C_S_AXIS_TUSER_WIDTH),
          .SRC_PORT_POS(SRC_PORT_POS),
          .DST_PORT_POS(DST_PORT_POS)
       )
      header_lookup
         (
          .ether_ip_header(ether_ip_header),
          .axis_tuser(fifo_axis_tuser),
          .encap_begin(encap_begin),
          .ACLK(S_AXI_ACLK),
          .ARESETN(S_AXI_ARESETN),
          .AWADDR(S_AXI_AWADDR),
          .AWVALID(S_AXI_AWVALID),
          .AWREADY(S_AXI_AWREADY),
          .WDATA(S_AXI_WDATA),
          .WSTRB(S_AXI_WSTRB),
          .WVALID(S_AXI_WVALID),
          .WREADY(S_AXI_WREADY),
          .BRESP(S_AXI_BRESP),
          .BVALID(S_AXI_BVALID),
          .BREADY(S_AXI_BREADY),
          .ARADDR(S_AXI_ARADDR),
          .ARVALID(S_AXI_ARVALID),
          .ARREADY(S_AXI_ARREADY),
          .RDATA(S_AXI_RDATA),
          .RRESP(S_AXI_RRESP),
          .RVALID(S_AXI_RVALID),
          .RREADY(S_AXI_RREADY)
         );

   // ------------- Logic ----------------

   assign s_axis_tready = !in_fifo_nearly_full;

   always @(*) begin
      in_fifo_rd_en = 0;

      m_axis_tdata = 0;
      m_axis_tstrb = 0;
      m_axis_tuser = 0;
      m_axis_tvalid = 0;
      m_axis_tlast = 0;

      tdata_queue_next = tdata_queue;
      tstrb_queue_next = tstrb_queue;

      state_next = state;

      case(state)
	MODULE_HEADER: begin
	   if(~in_fifo_empty) begin
              if(encap_begin) begin
                 tdata_queue_next = ether_ip_header;
                 tstrb_queue_next = 34'b1111111111111111111111111111111111;
                 state_next = IN_PACKET_ENCAP_BEGIN;
              end
              else begin
                 state_next = IN_PACKET_NORMAL;
              end
           end
	end // case: MODULE_HEADER

        IN_PACKET_ENCAP_BEGIN: begin
           m_axis_tvalid = !in_fifo_empty;
           m_axis_tdata = tdata_queue[C_M_AXIS_DATA_WIDTH - 1:0];
           m_axis_tstrb = tstrb_queue[C_M_AXIS_DATA_WIDTH/8 - 1:0];
           m_axis_tuser[C_M_AXIS_TUSER_WIDTH-1:16] = fifo_axis_tuser[C_M_AXIS_TUSER_WIDTH-1:16];
           m_axis_tuser[15:0] = fifo_axis_tuser[15:0] + 34;

           if(m_axis_tvalid && m_axis_tready) begin
              in_fifo_rd_en = 1;
              tdata_queue_next[272-C_M_AXIS_DATA_WIDTH-1:0] = tdata_queue[271:C_M_AXIS_DATA_WIDTH];
              tdata_queue_next[271:271-C_M_AXIS_DATA_WIDTH+1] = fifo_axis_tdata;
              tstrb_queue_next[34-C_M_AXIS_DATA_WIDTH/8-1:0] = tstrb_queue[33:C_M_AXIS_DATA_WIDTH/8];
              tstrb_queue_next[33:33-C_M_AXIS_DATA_WIDTH/8+1] = fifo_axis_tstrb;
              state_next = IN_PACKET_ENCAP_MIDDLE;
           end
        end

        IN_PACKET_ENCAP_MIDDLE: begin
           m_axis_tvalid = !in_fifo_empty;
           m_axis_tdata = tdata_queue[C_M_AXIS_DATA_WIDTH - 1:0];
           m_axis_tstrb = tstrb_queue[C_M_AXIS_DATA_WIDTH/8 - 1:0];
           m_axis_tuser[C_M_AXIS_TUSER_WIDTH-1:0] = 0;

           if(m_axis_tvalid && m_axis_tready) begin
              in_fifo_rd_en = 1;
              tdata_queue_next[272-C_M_AXIS_DATA_WIDTH-1:0] = tdata_queue[271:C_M_AXIS_DATA_WIDTH];
              tdata_queue_next[271:272-C_M_AXIS_DATA_WIDTH] = fifo_axis_tdata;
              tstrb_queue_next[34-C_M_AXIS_DATA_WIDTH/8-1:0] = tstrb_queue[33:C_M_AXIS_DATA_WIDTH/8];
              tstrb_queue_next[33:34-C_M_AXIS_DATA_WIDTH/8] = fifo_axis_tstrb;
              if(fifo_axis_tlast) begin
                 state_next = IN_PACKET_ENCAP_END;
              end
           end
        end

        IN_PACKET_ENCAP_END: begin
           m_axis_tvalid = 1;
           m_axis_tdata = tdata_queue[C_M_AXIS_DATA_WIDTH - 1:0];
           m_axis_tstrb = tstrb_queue[C_M_AXIS_DATA_WIDTH/8 - 1:0];
           m_axis_tuser[C_M_AXIS_TUSER_WIDTH-1:0] = 0;
           
           if(m_axis_tready) begin

              tdata_queue_next[272-C_M_AXIS_DATA_WIDTH-1:0] = tdata_queue[271:C_M_AXIS_DATA_WIDTH];
              tdata_queue_next[271:272-C_M_AXIS_DATA_WIDTH] = 0;
              tstrb_queue_next[34-C_M_AXIS_DATA_WIDTH/8-1:0] = tstrb_queue[33:C_M_AXIS_DATA_WIDTH/8];
              tstrb_queue_next[33:34-C_M_AXIS_DATA_WIDTH/8] = 0;
              if(~tstrb_queue_next[0]) begin
                  m_axis_tlast = 1;
                  state_next = MODULE_HEADER;
              end

           end
        end

	IN_PACKET_NORMAL: begin
	   m_axis_tvalid = !in_fifo_empty;
           m_axis_tdata = fifo_axis_tdata;
           m_axis_tuser = fifo_axis_tuser;
           m_axis_tstrb = fifo_axis_tstrb;
           m_axis_tlast = fifo_axis_tlast;
           in_fifo_rd_en = m_axis_tvalid && m_axis_tready;
           if(m_axis_tvalid && m_axis_tlast && m_axis_tready) begin
              state_next = MODULE_HEADER;
           end
	end
      endcase // case (state)
   end // always @ (*)

   always @(posedge axi_aclk) begin
      if(~axi_resetn) begin
	 state <= MODULE_HEADER;
         tdata_queue <= 0;
         tstrb_queue <= 0;
      end
      else begin
	 state <= state_next;
         tdata_queue <= tdata_queue_next;
         tstrb_queue <= tstrb_queue_next;
      end
   end

endmodule // output_port_lookup
