/*******************************************************************************
 *
 *  NetFPGA-10G http://www.netfpga.org
 *
 *  File:
 *        encap_header_lookup.v
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

module encap_header_lookup
  #(
    // Master AXI Lite Data Width
    parameter DATA_WIDTH=32,
    parameter ADDR_WIDTH=32,
    parameter SRC_PORT_POS=16,
    parameter DST_PORT_POS=24,
    parameter C_S_AXIS_TUSER_WIDTH=128
    )
   (

    output reg [271:0] ether_ip_header,
    input [C_S_AXIS_TUSER_WIDTH-1:0] axis_tuser,
    output reg encap_begin,

    input                        ACLK,
    input                        ARESETN,
    
    input [ADDR_WIDTH-1: 0]      AWADDR,
    input                        AWVALID,
    output reg                   AWREADY,
    
    input [DATA_WIDTH-1: 0]      WDATA,
    input [DATA_WIDTH/8-1: 0]    WSTRB,
    input                        WVALID,
    output reg                   WREADY,
    
    output reg [1:0]             BRESP,
    output reg                   BVALID,
    input                        BREADY,
    
    input [ADDR_WIDTH-1: 0]      ARADDR,
    input                        ARVALID,
    output reg                   ARREADY,
    
    output reg [DATA_WIDTH-1: 0] RDATA, 
    output reg [1:0]             RRESP,
    output reg                   RVALID,
    input                        RREADY
    );

   localparam AXI_RESP_OK = 2'b00;
   localparam AXI_RESP_SLVERR = 2'b10;
   
   localparam WRITE_IDLE = 0;
   localparam WRITE_RESPONSE = 1;
   localparam WRITE_DATA = 2;

   localparam READ_IDLE = 0;
   localparam READ_RESPONSE = 1;

   localparam IP_REG_0_0 = 8'h00;
   localparam IP_REG_0_1 = 8'h01;
   localparam MAC_REG_0_0 = 8'h02;
   localparam MAC_REG_0_1 = 8'h03;
   localparam MAC_REG_0_2 = 8'h04;
   localparam IP_CHECKSUM_0 = 8'h05;

   localparam IP_REG_1_0 = 8'h10;
   localparam IP_REG_1_1 = 8'h11;
   localparam MAC_REG_1_0 = 8'h12;
   localparam MAC_REG_1_1 = 8'h13;
   localparam MAC_REG_1_2 = 8'h14;
   localparam IP_CHECKSUM_1 = 8'h15;

   localparam IP_REG_2_0 = 8'h20;
   localparam IP_REG_2_1 = 8'h21;
   localparam MAC_REG_2_0 = 8'h22;
   localparam MAC_REG_2_1 = 8'h23;
   localparam MAC_REG_2_2 = 8'h24;
   localparam IP_CHECKSUM_2 = 8'h25;

   localparam IP_REG_3_0 = 8'h30;
   localparam IP_REG_3_1 = 8'h31;
   localparam MAC_REG_3_0 = 8'h32;
   localparam MAC_REG_3_1 = 8'h33;
   localparam MAC_REG_3_2 = 8'h34;
   localparam IP_CHECKSUM_3 = 8'h35;

   localparam CTRL_REG = 8'h40;


   reg [1:0]                     write_state, write_state_next;
   reg [1:0]                     read_state, read_state_next;
   reg [ADDR_WIDTH-1:0]          read_addr, read_addr_next;
   reg [ADDR_WIDTH-1:0]          write_addr, write_addr_next;
   reg [1:0]                     BRESP_next;

   reg [31:0]                    src_ip_reg_0, src_ip_reg_0_next;
   reg [31:0]                    dst_ip_reg_0, dst_ip_reg_0_next;
   reg [31:0]                    src_ip_reg_1, src_ip_reg_1_next;
   reg [31:0]                    dst_ip_reg_1, dst_ip_reg_1_next;
   reg [31:0]                    src_ip_reg_2, src_ip_reg_2_next;
   reg [31:0]                    dst_ip_reg_2, dst_ip_reg_2_next;
   reg [31:0]                    src_ip_reg_3, src_ip_reg_3_next;
   reg [31:0]                    dst_ip_reg_3, dst_ip_reg_3_next;

   reg [47:0]                    src_mac_reg_0, src_mac_reg_0_next;
   reg [47:0]                    dst_mac_reg_0, dst_mac_reg_0_next;
   reg [47:0]                    src_mac_reg_1, src_mac_reg_1_next;
   reg [47:0]                    dst_mac_reg_1, dst_mac_reg_1_next;
   reg [47:0]                    src_mac_reg_2, src_mac_reg_2_next;
   reg [47:0]                    dst_mac_reg_2, dst_mac_reg_2_next;
   reg [47:0]                    src_mac_reg_3, src_mac_reg_3_next;
   reg [47:0]                    dst_mac_reg_3, dst_mac_reg_3_next;

   reg [15:0]                    ip_checksum_reg_0, ip_checksum_reg_0_next;
   reg [15:0]                    ip_checksum_reg_1, ip_checksum_reg_1_next;
   reg [15:0]                    ip_checksum_reg_2, ip_checksum_reg_2_next;
   reg [15:0]                    ip_checksum_reg_3, ip_checksum_reg_3_next;

   reg [31:0]                    ctrl_reg, ctrl_reg_next;
   wire [7:0]                    encap_ports;
   wire [7:0]                    ip_tos;
   wire [7:0]                    ip_ttl;
   wire [7:0]                    ip_proto;

   assign ip_proto = ctrl_reg[7:0];
   assign ip_ttl = ctrl_reg[15:8];
   assign ip_tos = ctrl_reg[23:16];
   assign encap_ports = ctrl_reg[31:24];
   
   always @(*) begin
      read_state_next = read_state;   
      ARREADY = 1'b1;
      read_addr_next = read_addr;
      RDATA = 0; 
      RRESP = AXI_RESP_OK;
      RVALID = 1'b0;
      
      case(read_state)
        READ_IDLE: begin
           if(ARVALID) begin
              read_addr_next = ARADDR;
              read_state_next = READ_RESPONSE;
           end
        end        
        
        READ_RESPONSE: begin
           RVALID = 1'b1;
           ARREADY = 1'b0;

           if(read_addr[7:0] == IP_REG_0_0) begin
              RDATA = src_ip_reg_0;
           end
           else if(read_addr[7:0] == IP_REG_0_1) begin
              RDATA = dst_ip_reg_0;
           end

           else if(read_addr[7:0] == IP_REG_1_0) begin
              RDATA = src_ip_reg_1;
           end
           else if(read_addr[7:0] == IP_REG_1_1) begin
              RDATA = dst_ip_reg_1;
           end

           else if(read_addr[7:0] == IP_REG_2_0) begin
              RDATA = src_ip_reg_2;
           end
           else if(read_addr[7:0] == IP_REG_2_1) begin
              RDATA = dst_ip_reg_2;
           end

           else if(read_addr[7:0] == IP_REG_3_0) begin
              RDATA = src_ip_reg_3;
           end
           else if(read_addr[7:0] == IP_REG_3_1) begin
              RDATA = dst_ip_reg_3;
           end

           else if(read_addr[7:0] == MAC_REG_0_0) begin
              RDATA = src_mac_reg_0[31:0];
           end
           else if(read_addr[7:0] == MAC_REG_0_1) begin
              RDATA[15:0] = src_mac_reg_0[47:32];
              RDATA[31:16] = dst_mac_reg_0[15:0];
           end
           else if(read_addr[7:0] == MAC_REG_0_2) begin
              RDATA = dst_mac_reg_0[47:16];
           end

           else if(read_addr[7:0] == MAC_REG_1_0) begin
              RDATA = src_mac_reg_1[31:0];
           end
           else if(read_addr[7:0] == MAC_REG_1_1) begin
              RDATA[15:0] = src_mac_reg_1[47:32];
              RDATA[31:16] = dst_mac_reg_1[15:0];
           end
           else if(read_addr[7:0] == MAC_REG_1_2) begin
              RDATA = dst_mac_reg_1[47:16];
           end

           else if(read_addr[7:0] == MAC_REG_2_0) begin
              RDATA = src_mac_reg_2[31:0];
           end
           else if(read_addr[7:0] == MAC_REG_2_1) begin
              RDATA[15:0] = src_mac_reg_2[47:32];
              RDATA[31:16] = dst_mac_reg_2[15:0];
           end
           else if(read_addr[7:0] == MAC_REG_2_2) begin
              RDATA = dst_mac_reg_2[47:16];
           end

           else if(read_addr[7:0] == MAC_REG_3_0) begin
              RDATA = src_mac_reg_3[31:0];
           end
           else if(read_addr[7:0] == MAC_REG_3_1) begin
              RDATA[15:0] = src_mac_reg_3[47:32];
              RDATA[31:16] = dst_mac_reg_3[15:0];
           end
           else if(read_addr[7:0] == MAC_REG_3_2) begin
              RDATA = dst_mac_reg_3[47:16];
           end

           else if(read_addr[7:0] == IP_CHECKSUM_0) begin
              RDATA[15:0] = ip_checksum_reg_0;
              RDATA[31:16] = 16'b0;
           end
           else if(read_addr[7:0] == IP_CHECKSUM_1) begin
              RDATA[15:0] = ip_checksum_reg_1;
              RDATA[31:16] = 16'b0;
           end
           else if(read_addr[7:0] == IP_CHECKSUM_2) begin
              RDATA[15:0] = ip_checksum_reg_2;
              RDATA[31:16] = 16'b0;
           end
           else if(read_addr[7:0] == IP_CHECKSUM_3) begin
              RDATA[15:0] = ip_checksum_reg_3;
              RDATA[31:16] = 16'b0;
           end

           else if(read_addr[7:0] == CTRL_REG) begin
              RDATA = ctrl_reg;
           end

           else begin
              RRESP = AXI_RESP_SLVERR;
           end

           if(RREADY) begin
              read_state_next = READ_IDLE;
           end
        end
      endcase
   end
   
   always @(*) begin
      write_state_next = write_state;
      write_addr_next = write_addr;

      AWREADY = 1'b1;
      WREADY = 1'b0;
      BVALID = 1'b0;  
      BRESP_next = BRESP;

      src_ip_reg_0_next = src_ip_reg_0;
      dst_ip_reg_0_next = dst_ip_reg_0;
      src_ip_reg_1_next = src_ip_reg_1;
      dst_ip_reg_1_next = dst_ip_reg_1;
      src_ip_reg_2_next = src_ip_reg_2;
      dst_ip_reg_2_next = dst_ip_reg_2;
      src_ip_reg_3_next = src_ip_reg_3;
      dst_ip_reg_3_next = dst_ip_reg_3;

      src_mac_reg_0_next = src_mac_reg_0;
      dst_mac_reg_0_next = dst_mac_reg_0;
      src_mac_reg_1_next = src_mac_reg_1;
      dst_mac_reg_1_next = dst_mac_reg_1;
      src_mac_reg_2_next = src_mac_reg_2;
      dst_mac_reg_2_next = dst_mac_reg_2;
      src_mac_reg_3_next = src_mac_reg_3;
      dst_mac_reg_3_next = dst_mac_reg_3;

      ctrl_reg_next = ctrl_reg;

      case(write_state)
        WRITE_IDLE: begin
           write_addr_next = AWADDR;
           if(AWVALID) begin
              write_state_next = WRITE_DATA;
           end
        end
        WRITE_DATA: begin
           AWREADY = 1'b0;
           WREADY = 1'b1;
           if(WVALID) begin
              if(write_addr[7:0] == IP_REG_0_0) begin
                 src_ip_reg_0_next = WDATA;
                 BRESP_next = AXI_RESP_OK;
              end
              else if(write_addr[7:0] == IP_REG_0_1) begin
                 dst_ip_reg_0_next = WDATA;
                 BRESP_next = AXI_RESP_OK;
              end

              else if(write_addr[7:0] == IP_REG_1_0) begin
                 src_ip_reg_1_next = WDATA;
                 BRESP_next = AXI_RESP_OK;
              end
              else if(write_addr[7:0] == IP_REG_1_1) begin
                 dst_ip_reg_1_next = WDATA;
                 BRESP_next = AXI_RESP_OK;
              end

              else if(write_addr[7:0] == IP_REG_2_0) begin
                 src_ip_reg_2_next = WDATA;
                 BRESP_next = AXI_RESP_OK;
              end
              else if(write_addr[7:0] == IP_REG_2_1) begin
                 dst_ip_reg_2_next = WDATA;
                 BRESP_next = AXI_RESP_OK;
              end   

              else if(write_addr[7:0] == IP_REG_3_0) begin
                 src_ip_reg_3_next = WDATA;
                 BRESP_next = AXI_RESP_OK;
              end
              else if(write_addr[7:0] == IP_REG_3_1) begin
                 dst_ip_reg_3_next = WDATA;
                 BRESP_next = AXI_RESP_OK;
              end                 

              else if(write_addr[7:0] == MAC_REG_0_0) begin
                 src_mac_reg_0_next[31:0] = WDATA;
                 BRESP_next = AXI_RESP_OK;
              end
              else if(write_addr[7:0] == MAC_REG_0_1) begin
                 src_mac_reg_0_next[47:32] = WDATA[15:0];
                 dst_mac_reg_0_next[15:0] = WDATA[31:16];
                 BRESP_next = AXI_RESP_OK;
              end
              else if(write_addr[7:0] == MAC_REG_0_2) begin
                 dst_mac_reg_0_next[47:16] = WDATA;
                 BRESP_next = AXI_RESP_OK;
              end

              else if(write_addr[7:0] == MAC_REG_1_0) begin
                 src_mac_reg_1_next[31:0] = WDATA;
                 BRESP_next = AXI_RESP_OK;
              end
              else if(write_addr[7:0] == MAC_REG_1_1) begin
                 src_mac_reg_1_next[47:32] = WDATA[15:0];
                 dst_mac_reg_1_next[15:0] = WDATA[31:16];
                 BRESP_next = AXI_RESP_OK;
              end
              else if(write_addr[7:0] == MAC_REG_1_2) begin
                 dst_mac_reg_1_next[47:16] = WDATA;
                 BRESP_next = AXI_RESP_OK;
              end

              else if(write_addr[7:0] == MAC_REG_2_0) begin
                 src_mac_reg_2_next[31:0] = WDATA;
                 BRESP_next = AXI_RESP_OK;
              end
              else if(write_addr[7:0] == MAC_REG_2_1) begin
                 src_mac_reg_2_next[47:32] = WDATA[15:0];
                 dst_mac_reg_2_next[15:0] = WDATA[31:16];
                 BRESP_next = AXI_RESP_OK;
              end
              else if(write_addr[7:0] == MAC_REG_2_2) begin
                 dst_mac_reg_2_next[47:16] = WDATA;
                 BRESP_next = AXI_RESP_OK;
              end

              else if(write_addr[7:0] == MAC_REG_3_0) begin
                 src_mac_reg_3_next[31:0] = WDATA;
                 BRESP_next = AXI_RESP_OK;
              end
              else if(write_addr[7:0] == MAC_REG_3_1) begin
                 src_mac_reg_3_next[47:32] = WDATA[15:0];
                 dst_mac_reg_3_next[15:0] = WDATA[31:16];
                 BRESP_next = AXI_RESP_OK;
              end
              else if(write_addr[7:0] == MAC_REG_3_2) begin
                 dst_mac_reg_3_next[47:16] = WDATA;
                 BRESP_next = AXI_RESP_OK;
              end

              else if(write_addr[7:0] == IP_CHECKSUM_0) begin
                 ip_checksum_reg_0_next = WDATA[15:0];
                 BRESP_next = AXI_RESP_OK;
              end
              else if(write_addr[7:0] == IP_CHECKSUM_1) begin
                 ip_checksum_reg_1_next = WDATA[15:0];
                 BRESP_next = AXI_RESP_OK;
              end
              else if(write_addr[7:0] == IP_CHECKSUM_2) begin
                 ip_checksum_reg_2_next = WDATA[15:0];
                 BRESP_next = AXI_RESP_OK;
              end
              else if(write_addr[7:0] == IP_CHECKSUM_3) begin
                 ip_checksum_reg_3_next = WDATA[15:0];
                 BRESP_next = AXI_RESP_OK;
              end

              else if(write_addr[7:0] == CTRL_REG) begin
                 ctrl_reg_next = WDATA;
                 BRESP_next = AXI_RESP_OK;
              end
              
              else begin
                 BRESP_next = AXI_RESP_SLVERR;
              end
              write_state_next = WRITE_RESPONSE;
           end
        end
        WRITE_RESPONSE: begin
           AWREADY = 1'b0;
           BVALID = 1'b1;
           if(BREADY) begin                    
              write_state_next = WRITE_IDLE;
           end
        end
      endcase
   end

   always @(posedge ACLK) begin
      if(~ARESETN) begin
         write_state <= WRITE_IDLE;
         read_state <= READ_IDLE;
         read_addr <= 0;
         write_addr <= 0;
         BRESP <= AXI_RESP_OK;

         src_ip_reg_0 <= 32'h6401A8C0;
         dst_ip_reg_0 <= 32'h6501A8C0;
         src_ip_reg_1 <= 0;
         dst_ip_reg_1 <= 0;
         src_ip_reg_2 <= 0;
         dst_ip_reg_2 <= 0;
         src_ip_reg_3 <= 0;
         dst_ip_reg_3 <= 0;

         src_mac_reg_0 <= 48'h112233445566;
         dst_mac_reg_0 <= 48'h223344556677;
         src_mac_reg_1 <= 0;
         dst_mac_reg_1 <= 0;
         src_mac_reg_2 <= 0;
         dst_mac_reg_2 <= 0;
         src_mac_reg_3 <= 0;
         dst_mac_reg_3 <= 0;

         ip_checksum_reg_0 <= 0;
         ip_checksum_reg_1 <= 0;
         ip_checksum_reg_2 <= 0;
         ip_checksum_reg_3 <= 0;

         ctrl_reg <= 32'h0100ffb2;

      end
      else begin
         write_state <= write_state_next;
         read_state <= read_state_next;
         read_addr <= read_addr_next;
         write_addr <= write_addr_next;
         BRESP <= BRESP_next;

         src_ip_reg_0 <= src_ip_reg_0_next;
         dst_ip_reg_0 <= dst_ip_reg_0_next;
         src_ip_reg_1 <= src_ip_reg_1_next;
         dst_ip_reg_1 <= dst_ip_reg_1_next;
         src_ip_reg_2 <= src_ip_reg_2_next;
         dst_ip_reg_2 <= dst_ip_reg_2_next;
         src_ip_reg_3 <= src_ip_reg_3_next;
         dst_ip_reg_3 <= dst_ip_reg_3_next;

         src_mac_reg_0 <= src_mac_reg_0_next;
         dst_mac_reg_0 <= dst_mac_reg_0_next;
         src_mac_reg_1 <= src_mac_reg_1_next;
         dst_mac_reg_1 <= dst_mac_reg_1_next;
         src_mac_reg_2 <= src_mac_reg_2_next;
         dst_mac_reg_2 <= dst_mac_reg_2_next;
         src_mac_reg_3 <= src_mac_reg_3_next;
         dst_mac_reg_3 <= dst_mac_reg_3_next;

         ip_checksum_reg_0 <= ip_checksum_reg_0_next;
         ip_checksum_reg_1 <= ip_checksum_reg_1_next;
         ip_checksum_reg_2 <= ip_checksum_reg_2_next;
         ip_checksum_reg_3 <= ip_checksum_reg_3_next;

         ctrl_reg <= ctrl_reg_next;

      end
   end

   always @(*) begin
      encap_begin = 0;
      ether_ip_header = 0;

      if(axis_tuser[DST_PORT_POS] && encap_ports[0]) begin
         encap_begin = 1;
         ether_ip_header = {dst_ip_reg_0,src_ip_reg_0, ip_checksum_reg_0,ip_proto,ip_ttl,48'b0,ip_tos,8'b01000101,16'h0008,src_mac_reg_0,dst_mac_reg_0};
      end
      else if(axis_tuser[DST_PORT_POS+2] && encap_ports[2]) begin
         encap_begin = 1;
         ether_ip_header = {dst_ip_reg_1,src_ip_reg_1, ip_checksum_reg_1,ip_proto,ip_ttl,48'b0,ip_tos,8'b01000101,16'h0008,src_mac_reg_1,dst_mac_reg_1};
      end
      else if(axis_tuser[DST_PORT_POS+4] && encap_ports[4]) begin
         encap_begin = 1;
         ether_ip_header = {dst_ip_reg_2,src_ip_reg_2, ip_checksum_reg_2,ip_proto,ip_ttl,48'b0,ip_tos,8'b01000101,16'h0008,src_mac_reg_2,dst_mac_reg_2};
      end
      else if(axis_tuser[DST_PORT_POS+6] && encap_ports[6]) begin
         encap_begin = 1;
         ether_ip_header = {dst_ip_reg_3,src_ip_reg_3, ip_checksum_reg_3,ip_proto,ip_ttl,48'b0,ip_tos,8'b01000101,16'h0008,src_mac_reg_3,dst_mac_reg_3};
      end

   end
endmodule
