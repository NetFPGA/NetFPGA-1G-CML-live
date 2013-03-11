/*******************************************************************************
 *
 *  NetFPGA-10G http://www.netfpga.org
 *
 *  File:
 *        decap_decision_maker.v
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

module decap_decision_maker
  #(
    // Master AXI Lite Data Width
    parameter DATA_WIDTH=32,
    parameter ADDR_WIDTH=32,
    parameter SRC_PORT_POS=16,
    parameter DST_PORT_POS=24,
    parameter C_S_AXIS_TUSER_WIDTH=128
    )
   (

    output [7:0] encap_proto,
    input [C_S_AXIS_TUSER_WIDTH-1:0] axis_tuser,
    output reg decap_begin,

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

   reg [1:0]                     write_state, write_state_next;
   reg [1:0]                     read_state, read_state_next;
   reg [ADDR_WIDTH-1:0]          read_addr, read_addr_next;
   reg [ADDR_WIDTH-1:0]          write_addr, write_addr_next;
   reg [1:0]                     BRESP_next;

   reg [31:0]                    ctrl_reg, ctrl_reg_next;
   wire decap_enable;
   wire [7:0] decap_ports;

   assign decap_enable = ctrl_reg[0];
   assign decap_ports = ctrl_reg[15:8];
   assign encap_proto = ctrl_reg[23:16];
   
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

           RDATA = ctrl_reg;

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
              ctrl_reg_next = WDATA;
              BRESP_next = AXI_RESP_OK;
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

         ctrl_reg <= 32'h00B20501;

      end
      else begin
         write_state <= write_state_next;
         read_state <= read_state_next;
         read_addr <= read_addr_next;
         write_addr <= write_addr_next;
         BRESP <= BRESP_next;

         ctrl_reg <= ctrl_reg_next;

      end
   end

   always @(*) begin
      decap_begin = 0;
      if(decap_enable ==1 && (axis_tuser[SRC_PORT_POS+7:SRC_PORT_POS]&decap_ports)!=0) begin
         decap_begin = 1;
      end
   end
endmodule
