/*******************************************************************************
 *
 *  NetFPGA-10G http://www.netfpga.org
 *
 *  File:
 *        bridge.v
 *
 *  Library:
 *        /hw/contrib/pcores/endianess_manager_v1_00_a
 *
 *  Module:
 *        bridge
 *
 *  Author:
 *        Gianni Antichi
 *
 *  Description:
 *        little endian to big endian bridge
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


module bridge
#(
    parameter C_AXIS_DATA_WIDTH = 256,
    parameter C_AXIS_TUSER_WIDTH = 128,
    parameter NUM_QUEUES = 8,
    parameter NUM_QUEUES_WIDTH = log2(NUM_QUEUES)
)
(
    // Global Ports
    input clk,
    input reset,

    // little endian signals
    input [C_AXIS_DATA_WIDTH-1:0] s_axis_tdata,
    input [(C_AXIS_DATA_WIDTH/8)-1:0] s_axis_tstrb,
    input [C_AXIS_TUSER_WIDTH-1:0] s_axis_tuser,
    input  s_axis_tvalid,
    output reg s_axis_tready,
    input  s_axis_tlast,

    // big endian signals
    output reg [C_AXIS_DATA_WIDTH-1:0] m_axis_tdata,
    output reg[(C_AXIS_DATA_WIDTH/8)-1:0] m_axis_tstrb,
    output reg [C_AXIS_TUSER_WIDTH-1:0] m_axis_tuser,
    output reg  m_axis_tvalid,
    input m_axis_tready,
    output reg  m_axis_tlast

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

    genvar i;

  /* Generate control signals */
  
  always @(*) begin
    if (reset) begin
      m_axis_tuser = {C_AXIS_TUSER_WIDTH{1'b0}};
      m_axis_tvalid = 0;
      m_axis_tlast = 0;
      s_axis_tready = 0;
    end
    else begin
      m_axis_tuser = s_axis_tuser;
      m_axis_tvalid = s_axis_tvalid;
      m_axis_tlast = s_axis_tlast;
      s_axis_tready = m_axis_tready;
    end
  end

 generate
  for (i=0; i<(C_AXIS_DATA_WIDTH/8); i=i+1) begin: conversion
    always @(*) begin
     if (reset) begin
        m_axis_tdata[(i+1)*8-1:i*8] = 0;
        m_axis_tstrb[i] = 0;
      end
else begin
m_axis_tdata[(i+1)*8-1:i*8] = s_axis_tdata[((C_AXIS_DATA_WIDTH/8)-i)*8-1:((C_AXIS_DATA_WIDTH/8)-(i+1))*8];
        m_axis_tstrb[i] = s_axis_tstrb[(C_AXIS_DATA_WIDTH/8)-i-1];
end
    end
  end
  endgenerate

endmodule
