#!/usr/bin/env python

################################################################################
#
#  NetFPGA-10G http://www.netfpga.org
#
#  File:
#        nf10_coregen.py
#
#  Author:
#        Lucas Brasilino <lucas.brasilino@gmail.com>
#
#  Description:
#        Creates Peripheral Core templates for NF10 projects.
#
#  Copyright notice:
#        Copyright (C) 2014       Indiana University
#        Copyright (C) 2010, 2011 The Board of Trustees of The Leland Stanford
#                                 Junior University
#
#  Licence:
#        This file is part of the NetFPGA 10G development base package.
#
#        This file is free code: you can redistribute it and/or modify it under
#        the terms of the GNU Lesser General Public License version 2.1 as
#        published by the Free Software Foundation.
#
#        This package is distributed in the hope that it will be useful, but
#        WITHOUT ANY WARRANTY; without even the implied warranty of
#        MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#        Lesser General Public License for more details.
#
#        You should have received a copy of the GNU Lesser General Public
#        License along with the NetFPGA source package.  If not, see
#        http://www.gnu.org/licenses/.
#
#


import os, sys, getopt, getpass

class CoreGen(object):
    def __init__(self):
        self.name = "output_port_lookup" 
        self.version = "_v1_00_a"
        self.path = "."
        self.userlogic = "user_logic"
        self.author = getpass.getuser()

    def getOpt(self):
        try:
            opts, args = getopt.getopt(sys.argv[1:], 
                                       "h", ["help", "name=", "path=",
                                            "author=","userlogic="])
        except getopt.GetoptError:
            print sys.argv[0] +": invalid option\nUsage:",
            self.showHelp()
            sys.exit(1)
        for opt,arg in opts:
            if opt in ("-h", "--help"):
                self.showHelp()
                sys.exit(0)
            elif opt == "--name":
                self.name = arg
            elif opt == "--path":
                self.path = arg
            elif opt == "--author":
                self.author = arg
            elif opt == "--userlogic":
                self.userlogic = arg

    def showHelp(self):
        print "nf10_coregen.py [--help --name <pcore name> --path <pcore path> --author <author name> --userlogic <user_logic name>]"

    def createFileHeader(self,filename,desc="Some pcore file",fsuffix=".v"):
        return  "################################################################################\n\
#\n\
#  NetFPGA-10G http://www.netfpga.org\n\
#\n\
#  File:\n\
#        " + filename + fsuffix + " \n\
#\n\
#  Author:\n\
#        " + self.author + "\n\
#\n\
#  Description:\n\
#        " + desc + "\n\
#\n\
#  Copyright notice:\n\
#        Copyright (C) 2010, 2011 The Board of Trustees of The Leland Stanford\n\
#                                 Junior University\n\
#\n\
#  Licence:\n\
#        This file is part of the NetFPGA 10G development base package.\n\
#\n\
#        This file is free code: you can redistribute it and/or modify it under\n\
#        the terms of the GNU Lesser General Public License version 2.1 as\n\
#        published by the Free Software Foundation.\n\
#\n\
#        This package is distributed in the hope that it will be useful, but\n\
#        WITHOUT ANY WARRANTY; without even the implied warranty of\n\
#        MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU\n\
#        Lesser General Public License for more details.\n\
#\n\
#        You should have received a copy of the GNU Lesser General Public\n\
#        License along with the NetFPGA source package.  If not, see\n\
#        http://www.gnu.org/licenses/.\n\
#\n\
#\n\
"

    def createMPD(self):
        with open(self.dataCorePath + "/" + self.name + 
                  "_v2_1_0.mpd","w") as f:
            f.write(self.createFileHeader(filename=self.name + self.version,
                                          desc=self.name+"'s Microprocessor Peripheral Description File",
                                          fsuffix=".mpd") +

"BEGIN " + self.name + "\n\
\n\
## Peripheral Options\n\
OPTION IPTYPE = PERIPHERAL\n\
OPTION IMP_NETLIST = TRUE\n\
OPTION HDL = MIXED\n\
OPTION IP_GROUP = NetFPGA-10G\n\
OPTION DESC = " + self.name.lower().title().replace('_', ' ') + "\n\
OPTION LONG_DESC = " + self.name.lower().title().replace('_', ' ') + " Peripheral Core\n\
\n\
## Bus Interfaces\n\
BUS_INTERFACE BUS = M_AXIS, BUS_STD = AXIS, BUS_TYPE = INITIATOR\n\
BUS_INTERFACE BUS = S_AXIS, BUS_STD = AXIS, BUS_TYPE = TARGET\n\
BUS_INTERFACE BUS = S_AXI, BUS_STD = AXI, BUS_TYPE = SLAVE\n\
\n\
## AXILITE Parameters\n\
PARAMETER C_S_AXI_DATA_WIDTH = 32, DT = INTEGER, BUS = S_AXI, ASSIGNMENT = CONSTANT\n\
PARAMETER C_S_AXI_ADDR_WIDTH = 32, DT = INTEGER, BUS = S_AXI, ASSIGNMENT = CONSTANT\n\
PARAMETER C_BASEADDR = 0xffffffff, DT = std_logic_vector, PAIR = C_HIGHADDR, ADDRESS = BASE, BUS = S_AXI\n\
PARAMETER C_HIGHADDR = 0x00000000, DT = std_logic_vector, PAIR = C_BASEADDR, ADDRESS = HIGH, BUS = S_AXI\n\
PARAMETER C_S_AXI_PROTOCOL = AXI4LITE, DT = STRING, BUS = S_AXI, ASSIGNMENT = CONSTANT, TYPE = NON_HDL\n\
PARAMETER C_S_AXI_ACLK_FREQ_HZ = 100000000, DT = INTEGER, BUS = S_AXI, IO_IS = clk_freq, CLK_PORT = S_AXI_ACLK, CLK_UNIT = HZ, ASSIGNMENT = REQUIRE\n\
PARAMETER C_USE_WSTRB = 0, DT = INTEGER, RANGE = (0:1), BUS = S_AXI\n\
PARAMETER C_DPHASE_TIMEOUT = 8, DT = INTEGER, RANGE = (0:512), BUS = S_AXI\n\
\n\
## Generics for VHDL or Parameters for Verilog\n\
PARAMETER C_M_AXIS_DATA_WIDTH = 256, DT = INTEGER, RANGE = (8,32,64,128,256), BUS = M_AXIS:S_AXIS\n\
PARAMETER C_S_AXIS_DATA_WIDTH = 256, DT = INTEGER, RANGE = (8,32,64,128,256), BUS = M_AXIS:S_AXIS\n\
PARAMETER C_M_AXIS_TUSER_WIDTH = 128, DT = INTEGER, RANGE = (128), BUS = M_AXIS:S_AXIS\n\
PARAMETER C_S_AXIS_TUSER_WIDTH = 128, DT = INTEGER, RANGE = (128), BUS = M_AXIS:S_AXIS\n\
\n\
## Ports\n\
PORT s_axi_aclk = \"\", DIR = I, SIGIS = CLK, BUS = M_AXIS:S_AXIS:S_AXI\n\
PORT s_axi_aresetn = \"\", DIR = I, SIGIS = RST\n\
PORT s_axi_awaddr = AWADDR, DIR = I, VEC = [(C_S_AXI_ADDR_WIDTH-1):0], ENDIAN = LITTLE, BUS = S_AXI\n\
PORT s_axi_awvalid = AWVALID, DIR = I, BUS = S_AXI\n\
PORT s_axi_wdata = WDATA, DIR = I, VEC = [(C_S_AXI_DATA_WIDTH-1):0], ENDIAN = LITTLE, BUS = S_AXI\n\
PORT s_axi_wstrb = WSTRB, DIR = I, VEC = [((C_S_AXI_DATA_WIDTH/8)-1):0], ENDIAN = LITTLE, BUS = S_AXI\n\
PORT s_axi_wvalid = WVALID, DIR = I, BUS = S_AXI\n\
PORT s_axi_bready = BREADY, DIR = I, BUS = S_AXI\n\
PORT s_axi_araddr = ARADDR, DIR = I, VEC = [(C_S_AXI_ADDR_WIDTH-1):0], ENDIAN = LITTLE, BUS = S_AXI\n\
PORT s_axi_arvalid = ARVALID, DIR = I, BUS = S_AXI\n\
PORT s_axi_rready = RREADY, DIR = I, BUS = S_AXI\n\
PORT s_axi_arready = ARREADY, DIR = O, BUS = S_AXI\n\
PORT s_axi_rdata = RDATA, DIR = O, VEC = [(C_S_AXI_DATA_WIDTH-1):0], ENDIAN = LITTLE, BUS = S_AXI\n\
PORT s_axi_rresp = RRESP, DIR = O, VEC = [1:0], BUS = S_AXI\n\
PORT s_axi_rvalid = RVALID, DIR = O, BUS = S_AXI\n\
PORT s_axi_wready = WREADY, DIR = O, BUS = S_AXI\n\
PORT s_axi_bresp = BRESP, DIR = O, VEC = [1:0], BUS = S_AXI\n\
PORT s_axi_bvalid = BVALID, DIR = O, BUS = S_AXI\n\
PORT s_axi_awready = AWREADY, DIR = O, BUS = S_AXI\n\
\n\
PORT m_axis_tdata = TDATA, DIR = O, VEC = [C_M_AXIS_DATA_WIDTH-1:0], BUS = M_AXIS, ENDIAN = LITTLE\n\
PORT m_axis_tstrb = TSTRB, DIR = O, VEC = [(C_M_AXIS_DATA_WIDTH/8)-1:0], BUS = M_AXIS, ENDIAN = LITTLE\n\
PORT m_axis_tuser = TUSER, DIR = O, VEC = [C_M_AXIS_TUSER_WIDTH-1:0], BUS = M_AXIS, ENDIAN = LITTLE\n\
PORT m_axis_tvalid = TVALID, DIR = O, BUS = M_AXIS\n\
PORT m_axis_tready = TREADY, DIR = I, BUS = M_AXIS\n\
PORT m_axis_tlast = TLAST, DIR = O, BUS = M_AXIS\n\
\n\
PORT s_axis_tdata = TDATA, DIR = I, VEC = [C_S_AXIS_DATA_WIDTH-1:0], BUS = S_AXIS, ENDIAN = LITTLE\n\
PORT s_axis_tstrb = TSTRB, DIR = I, VEC = [(C_S_AXIS_DATA_WIDTH/8)-1:0], BUS = S_AXIS, ENDIAN = LITTLE\n\
PORT s_axis_tuser = TUSER, DIR = I, VEC = [C_S_AXIS_TUSER_WIDTH-1:0], BUS = S_AXIS, ENDIAN = LITTLE\n\
PORT s_axis_tvalid = TVALID, DIR = I, BUS = S_AXIS\n\
PORT s_axis_tready = TREADY, DIR = O, BUS = S_AXIS\n\
PORT s_axis_tlast = TLAST, DIR = I, BUS = S_AXIS\n\
\n\
end\n\
")

    def createPAO(self):
        with open(self.dataCorePath + "/" + self.name + 
                  "_v2_1_0.pao","w") as f:
            f.write(self.createFileHeader(filename=self.name+self.version,
                                          desc=self.name+"'s  Peripheral Analyze Order File",
                                          fsuffix=".pao") +

"lib proc_common_v3_00_a  all\n\
lib nf10_proc_common_v1_00_a  all\n\
lib axi_lite_ipif_v1_01_a  all\n\
lib " + self.name + "_v1_00_a " + self.userlogic + " verilog\n\
lib " + self.name + "_v1_00_a " + self.name + " verilog\n\
")

    def createUL(self):
        with open(self.verilogCorePath + "/" + self.userlogic + ".v","w") as f:
            f.write("/*\n" +
self.createFileHeader(filename=self.userlogic,
                      desc=self.name+"'s Verilog User Logic File") +
"*/\n" +
"module " + self.userlogic + "\n\
#(\n\
    // Master AXI Stream Data Width\n\
    parameter C_M_AXIS_DATA_WIDTH=256,\n\
    parameter C_S_AXIS_DATA_WIDTH=256,\n\
    parameter C_M_AXIS_TUSER_WIDTH=128,\n\
    parameter C_S_AXIS_TUSER_WIDTH=128,\n\
    parameter C_S_AXI_DATA_WIDTH=32,\n\
    // Register parameters\n\
    parameter NUM_RW_REGS = 0,\n\
    parameter NUM_WO_REGS = 0,\n\
    parameter NUM_RO_REGS = 0\n\
)\n\
(\n\
    // Global Ports\n\
    input axi_aclk,\n\
    input axi_aresetn,\n\
\n\
    // Master Stream Ports (interface to data path downstream)\n\
    output [C_M_AXIS_DATA_WIDTH - 1:0]         m_axis_tdata,\n\
    output [((C_M_AXIS_DATA_WIDTH / 8)) - 1:0] m_axis_tstrb,\n\
    output [C_M_AXIS_TUSER_WIDTH-1:0]          m_axis_tuser,\n\
    output                                     m_axis_tvalid,\n\
    input                                      m_axis_tready,\n\
    output                                     m_axis_tlast,\n\
\n\
    // Slave Stream Ports (interface to data path upstream)\n\
    input [C_S_AXIS_DATA_WIDTH - 1:0]          s_axis_tdata,\n\
    input [((C_S_AXIS_DATA_WIDTH / 8)) - 1:0]  s_axis_tstrb,\n\
    input [C_S_AXIS_TUSER_WIDTH-1:0]           s_axis_tuser,\n\
    input                                      s_axis_tvalid,\n\
    output                                     s_axis_tready,\n\
    input                                      s_axis_tlast,\n\
\n\
    // Registers\n\
    input  [NUM_WO_REGS*C_S_AXI_DATA_WIDTH-1:0]  wo_regs,\n\
    input  [NUM_RW_REGS*C_S_AXI_DATA_WIDTH-1:0]  rw_regs,\n\
    input  [NUM_RO_REGS*C_S_AXI_DATA_WIDTH-1:0]  ro_regs\n\
);\n\
\n\
   function integer log2;\n\
      input integer number;\n\
      begin\n\
         log2=0;\n\
         while(2**log2<number) begin\n\
            log2=log2+1;\n\
         end\n\
      end\n\
   endfunction // log2\n\
\n\
   // ------------- Regs/ wires -----------\n\
\n\
   wire                             in_fifo_nearly_full;\n\
   wire                             in_fifo_empty;\n\
   reg                              in_fifo_rd_en;\n\
   wire [C_M_AXIS_TUSER_WIDTH-1:0]  fifo_out_tuser;\n\
   wire [C_M_AXIS_DATA_WIDTH-1:0]   fifo_out_tdata;\n\
   wire [C_M_AXIS_DATA_WIDTH/8-1:0] fifo_out_tstrb;\n\
   wire  	                        fifo_out_tlast;\n\
   wire                             fifo_tvalid;\n\
   wire                             fifo_tlast;\n\
\n\
   // ------------ Modules -------------\n\
\n\
   fallthrough_small_fifo\n\
   #( .WIDTH(C_M_AXIS_DATA_WIDTH+C_M_AXIS_TUSER_WIDTH+C_M_AXIS_DATA_WIDTH/8+1),\n\
      .MAX_DEPTH_BITS(2)\n\
    )\n\
    input_fifo\n\
    ( // Outputs\n\
      .dout                         ({fifo_out_tlast, fifo_out_tuser, fifo_out_tstrb, fifo_out_tdata}),\n\
      .full                         (),\n\
      .nearly_full                  (in_fifo_nearly_full),\n\
	  .prog_full                    (),\n\
      .empty                        (in_fifo_empty),\n\
      // Inputs\n\
      .din                          ({s_axis_tlast, s_axis_tuser, s_axis_tstrb, s_axis_tdata}),\n\
      .wr_en                        (s_axis_tvalid & s_axis_tready),\n\
      .rd_en                        (in_fifo_rd_en),\n\
      .reset                        (~axi_aresetn),\n\
      .clk                          (axi_aclk));\n\
\n\
   // ------------- Logic ------------\n\
\n\
   assign s_axis_tready = !in_fifo_nearly_full;\n\
   assign m_axis_tuser = fifo_out_tuser;\n\
   assign m_axis_tdata = fifo_out_tdata;\n\
   assign m_axis_tlast = fifo_out_tlast;\n\
   assign m_axis_tstrb = fifo_out_tstrb;\n\
   assign m_axis_tvalid = ~in_fifo_empty;\n\
\n\
   always @(*) begin\n\
      in_fifo_rd_en = 0;\n\
\n\
      if (m_axis_tready && !in_fifo_empty) begin\n\
        in_fifo_rd_en = 1;\n\
      end\n\
   end\n\
\n\
endmodule\n\
")

    def createTopVerilog(self):
        with open(self.verilogCorePath + "/" + self.name + ".v","w") as f:
            f.write("/*\n" +
self.createFileHeader(filename=self.name,
                      desc=self.name+"'s Verilog Top Module File") +
"*/\n" +
"module " + self.name + "\n\
#(\n\
    // Master AXI Stream Data Width\n\
    parameter C_M_AXIS_DATA_WIDTH=256,\n\
    parameter C_S_AXIS_DATA_WIDTH=256,\n\
    parameter C_M_AXIS_TUSER_WIDTH=128,\n\
    parameter C_S_AXIS_TUSER_WIDTH=128,\n\
    parameter C_S_AXI_DATA_WIDTH=32,\n\
    parameter C_S_AXI_ADDR_WIDTH=32,\n\
    parameter C_USE_WSTRB=0,\n\
    parameter C_DPHASE_TIMEOUT=0,\n\
    parameter C_BASEADDR=32'hFFFFFFFF,\n\
    parameter C_HIGHADDR=32'h00000000,\n\
    parameter C_S_AXI_ACLK_FREQ_HZ=100\n\
)\n\
(\n\
    // Master Stream Ports (interface to data path downstream)\n\
    output [C_M_AXIS_DATA_WIDTH - 1:0]         m_axis_tdata,\n\
    output [((C_M_AXIS_DATA_WIDTH / 8)) - 1:0] m_axis_tstrb,\n\
    output [C_M_AXIS_TUSER_WIDTH-1:0]          m_axis_tuser,\n\
    output                                     m_axis_tvalid,\n\
    input                                      m_axis_tready,\n\
    output                                     m_axis_tlast,\n\
\n\
    // Slave Stream Ports (interface to data path upstream)\n\
    input [C_S_AXIS_DATA_WIDTH - 1:0]          s_axis_tdata,\n\
    input [((C_S_AXIS_DATA_WIDTH / 8)) - 1:0]  s_axis_tstrb,\n\
    input [C_S_AXIS_TUSER_WIDTH-1:0]           s_axis_tuser,\n\
    input                                      s_axis_tvalid,\n\
    output                                     s_axis_tready,\n\
    input                                      s_axis_tlast,\n\
\n\
    // AXI Lite control/status interface\n\
    input                                      s_axi_aclk,\n\
    input                                      s_axi_aresetn,\n\
    input  [C_S_AXI_ADDR_WIDTH-1:0]            s_axi_awaddr,\n\
    input                                      s_axi_awvalid,\n\
    output                                     s_axi_awready,\n\
    input  [C_S_AXI_DATA_WIDTH-1:0]            s_axi_wdata,\n\
    input  [((C_S_AXI_DATA_WIDTH / 8)) - 1:0]  s_axi_wstrb,\n\
    input                                      s_axi_wvalid,\n\
    output                                     s_axi_wready,\n\
    output [1:0]                               s_axi_bresp,\n\
    output                                     s_axi_bvalid,\n\
    input                                      s_axi_bready,\n\
    input  [C_S_AXI_ADDR_WIDTH-1:0]            s_axi_araddr,\n\
    input                                      s_axi_arvalid,\n\
    output                                     s_axi_arready,\n\
    output [C_S_AXI_DATA_WIDTH-1:0]            s_axi_rdata,\n\
    output [1:0]                               s_axi_rresp,\n\
    output                                     s_axi_rvalid,\n\
    input                                      s_axi_rready\n\
);\n\
\n\
   function integer log2;\n\
      input integer number;\n\
      begin\n\
         log2=0;\n\
         while(2**log2<number) begin\n\
            log2=log2+1;\n\
         end\n\
      end\n\
   endfunction // log2\n\
\n\
   // --------- Internal Parameters ------\n\
   localparam NUM_RW_REGS = 1;\n\
   localparam NUM_WO_REGS = 1;\n\
   localparam NUM_RO_REGS = 1;\n\
\n\
   // ------------- Regs/ wires -----------\n\
\n\
   wire [NUM_WO_REGS*C_S_AXI_DATA_WIDTH-1:0] wo_regs;\n\
   wire [NUM_RW_REGS*C_S_AXI_DATA_WIDTH-1:0] rw_regs;\n\
   wire [NUM_RO_REGS*C_S_AXI_DATA_WIDTH-1:0] ro_regs;\n\
\n\
   wire                                            Bus2IP_Clk;\n\
   wire                                            Bus2IP_Resetn;\n\
   wire     [C_S_AXI_ADDR_WIDTH-1 : 0]             Bus2IP_Addr;\n\
   wire                                            Bus2IP_CS;\n\
   wire                                            Bus2IP_RNW;\n\
   wire     [C_S_AXI_DATA_WIDTH-1 : 0]             Bus2IP_Data;\n\
   wire     [C_S_AXI_DATA_WIDTH/8-1 : 0]           Bus2IP_BE;\n\
   wire     [C_S_AXI_DATA_WIDTH-1 : 0]             IP2Bus_Data;\n\
   wire                                            IP2Bus_RdAck;\n\
   wire                                            IP2Bus_WrAck;\n\
   wire                                            IP2Bus_Error;\n\
\n\
   // ------------ Modules -------------\n\
\n\
 // -- AXILITE IPIF\n\
  axi_lite_ipif_1bar #\n\
  (\n\
   .C_S_AXI_DATA_WIDTH (C_S_AXI_DATA_WIDTH),\n\
   .C_S_AXI_ADDR_WIDTH (C_S_AXI_ADDR_WIDTH),\n\
    .C_USE_WSTRB        (C_USE_WSTRB),\n\
    .C_DPHASE_TIMEOUT   (C_DPHASE_TIMEOUT),\n\
   .C_BAR0_BASEADDR    (C_BASEADDR),\n\
   .C_BAR0_HIGHADDR    (C_HIGHADDR)\n\
  ) axi_lite_ipif\n\
  (\n\
    .S_AXI_ACLK          ( s_axi_aclk     ),\n\
    .S_AXI_ARESETN       ( s_axi_aresetn  ),\n\
    .S_AXI_AWADDR        ( s_axi_awaddr   ),\n\
    .S_AXI_AWVALID       ( s_axi_awvalid  ),\n\
    .S_AXI_WDATA         ( s_axi_wdata    ),\n\
    .S_AXI_WSTRB         ( s_axi_wstrb    ),\n\
    .S_AXI_WVALID        ( s_axi_wvalid   ),\n\
    .S_AXI_BREADY        ( s_axi_bready   ),\n\
    .S_AXI_ARADDR        ( s_axi_araddr   ),\n\
    .S_AXI_ARVALID       ( s_axi_arvalid  ),\n\
    .S_AXI_RREADY        ( s_axi_rready   ),\n\
    .S_AXI_ARREADY       ( s_axi_arready  ),\n\
    .S_AXI_RDATA         ( s_axi_rdata    ),\n\
    .S_AXI_RRESP         ( s_axi_rresp    ),\n\
    .S_AXI_RVALID        ( s_axi_rvalid   ),\n\
    .S_AXI_WREADY        ( s_axi_wready   ),\n\
    .S_AXI_BRESP         ( s_axi_bresp    ),\n\
    .S_AXI_BVALID        ( s_axi_bvalid   ),\n\
    .S_AXI_AWREADY       ( s_axi_awready  ),\n\
\n\
    // Controls to the IP/IPIF modules\n\
    .Bus2IP_Clk          ( Bus2IP_Clk     ),\n\
    .Bus2IP_Resetn       ( Bus2IP_Resetn  ),\n\
    .Bus2IP_Addr         ( Bus2IP_Addr    ),\n\
    .Bus2IP_RNW          ( Bus2IP_RNW     ),\n\
    .Bus2IP_BE           ( Bus2IP_BE      ),\n\
    .Bus2IP_CS           ( Bus2IP_CS      ),\n\
    .Bus2IP_Data         ( Bus2IP_Data    ),\n\
    .IP2Bus_Data         ( IP2Bus_Data    ),\n\
    .IP2Bus_WrAck        ( IP2Bus_WrAck   ),\n\
    .IP2Bus_RdAck        ( IP2Bus_RdAck   ),\n\
    .IP2Bus_Error        ( IP2Bus_Error   )\n\
  );\n\
\n\
  // -- IPIF REGS\n\
  ipif_regs #\n\
  (\n\
    .C_S_AXI_DATA_WIDTH (C_S_AXI_DATA_WIDTH),\n\
    .C_S_AXI_ADDR_WIDTH (C_S_AXI_ADDR_WIDTH),\n\
    .NUM_WO_REGS        (NUM_WO_REGS),\n\
    .NUM_RW_REGS        (NUM_RW_REGS),\n\
    .NUM_RO_REGS        (NUM_RO_REGS)\n\
  ) ipif_regs\n\
  (\n\
    .Bus2IP_Clk     ( Bus2IP_Clk     ),\n\
    .Bus2IP_Resetn  ( Bus2IP_Resetn  ),\n\
    .Bus2IP_Addr    ( Bus2IP_Addr    ),\n\
    .Bus2IP_CS      ( Bus2IP_CS      ),\n\
    .Bus2IP_RNW     ( Bus2IP_RNW     ),\n\
    .Bus2IP_Data    ( Bus2IP_Data    ),\n\
    .Bus2IP_BE      ( Bus2IP_BE      ),\n\
    .IP2Bus_Data    ( IP2Bus_Data    ),\n\
    .IP2Bus_RdAck   ( IP2Bus_RdAck   ),\n\
    .IP2Bus_WrAck   ( IP2Bus_WrAck   ),\n\
    .IP2Bus_Error   ( IP2Bus_Error   ),\n\
    \n\
    .wo_regs        ( wo_regs ),\n\
    .rw_regs        ( rw_regs ),\n\
    .ro_regs        ( ro_regs )\n\
  );\n\
\n\
   // " + self.userlogic + " (user_logic)\n\
   " + self.userlogic + " #\n\
   (\n\
     .C_M_AXIS_DATA_WIDTH  (C_M_AXIS_DATA_WIDTH),\n\
     .C_S_AXIS_DATA_WIDTH  (C_S_AXIS_DATA_WIDTH),\n\
     .C_M_AXIS_TUSER_WIDTH (C_M_AXIS_TUSER_WIDTH),\n\
     .C_S_AXIS_TUSER_WIDTH (C_S_AXIS_TUSER_WIDTH),\n\
\n\
     .NUM_WO_REGS          (NUM_WO_REGS),\n\
     .NUM_RW_REGS          (NUM_RW_REGS),\n\
     .NUM_RO_REGS          (NUM_RO_REGS)\n\
   )\n\
     " + self.userlogic + "\n\
       (\n\
         // Global Ports\n\
         .axi_aclk      (s_axi_aclk),\n\
         .axi_aresetn   (s_axi_aresetn),\n\
\n\
         // Master Stream Ports (interface to data path)\n\
         .m_axis_tdata  (m_axis_tdata),\n\
         .m_axis_tstrb  (m_axis_tstrb),\n\
         .m_axis_tuser  (m_axis_tuser),\n\
         .m_axis_tvalid (m_axis_tvalid),\n\
         .m_axis_tready (m_axis_tready),\n\
         .m_axis_tlast  (m_axis_tlast),\n\
\n\
         // Slave Stream Ports (interface to RX queues)\n\
         .s_axis_tdata  (s_axis_tdata),\n\
         .s_axis_tstrb  (s_axis_tstrb),\n\
         .s_axis_tuser  (s_axis_tuser),\n\
         .s_axis_tvalid (s_axis_tvalid),\n\
         .s_axis_tready (s_axis_tready),\n\
         .s_axis_tlast  (s_axis_tlast),\n\
\n\
         // Registers\n\
         .wo_regs       (wo_regs),\n\
         .rw_regs       (rw_regs),\n\
         .ro_regs       (ro_regs)\n\
       );\n\
\n\
endmodule\n\
")

    def makeDirectories(self):
        # Create Pcore directory
        self.fullCorePath = self.path + '/' + self.name + self.version
        if not os.path.exists(self.fullCorePath): 
            os.makedirs(self.fullCorePath)

	# Create data directory
	self.dataCorePath = self.fullCorePath + '/data'
	if not os.path.exists(self.dataCorePath): 
            os.makedirs(self.dataCorePath)

	# Create hdl/verilog path
	self.verilogCorePath = self.fullCorePath + '/hdl/verilog'
	if not os.path.exists(self.verilogCorePath): 
            os.makedirs(self.verilogCorePath)


    def createPcore(self):
        self.makeDirectories()
	self.createMPD()
	self.createPAO()
	self.createTopVerilog()
	self.createUL()

def main():
    core = CoreGen()
    try:
        core.getOpt()
    except getopt.GetoptError:
        core.showHelp()
        sys.exit(1)
    print "Pcore name: "+ core.name + "\n\
User Logic Name:" + core.userlogic + "\n\
Path:" + core.path + "\n\
Author:" + core.author
    core.createPcore()

if __name__ == '__main__':
    main()
