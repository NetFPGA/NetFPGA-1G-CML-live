/*******************************************************************************
*
*  NetFPGA-10G http://www.netfpga.org
*
*  File:
*        nf10_identifier.v
*
*  Project:
*
*
*  Module:
*
*
*  Author:
*        Jong HAN
*
*  Changes:
*        2014/10/30 Jay Hirata - Make identifier device independent
*
*  Description:
*        Identifying a module.
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

module nf10_identifier
#(
    // Master AXI Stream Data Width
    parameter   C_FAMILY                    = "virtex5",
    parameter   C_S_AXI_DATA_WIDTH          = 32,
    parameter   C_S_AXI_ADDR_WIDTH          = 32,
    parameter   C_USE_WSTRB                 = 0,
    parameter   C_DPHASE_TIMEOUT            = 0,
    parameter   C_BASEADDR                  = 32'hFFFFFFFF,
    parameter   C_HIGHADDR                  = 32'h00000000,
    parameter   C_INFO_FILE                 = "NONE",
    parameter   C_S_AXI_ACLK_FREQ_HZ        = 100
)
(
    // Slave AXI Ports
    input                                   S_AXI_ACLK,
    input                                   S_AXI_ARESETN,
    input   [C_S_AXI_ADDR_WIDTH-1:0]        S_AXI_AWADDR,
    input                                   S_AXI_AWVALID,
    input   [C_S_AXI_DATA_WIDTH-1:0]        S_AXI_WDATA,
    input   [C_S_AXI_DATA_WIDTH/8-1:0]      S_AXI_WSTRB,
    input                                   S_AXI_WVALID,
    input                                   S_AXI_BREADY,
    input   [C_S_AXI_ADDR_WIDTH-1:0]        S_AXI_ARADDR,
    input                                   S_AXI_ARVALID,
    input                                   S_AXI_RREADY,
    output                                  S_AXI_ARREADY,
    output  [C_S_AXI_DATA_WIDTH-1:0]        S_AXI_RDATA,
    output  [1:0]                           S_AXI_RRESP,
    output                                  S_AXI_RVALID,
    output                                  S_AXI_WREADY,
    output  [1:0]                           S_AXI_BRESP,
    output                                  S_AXI_BVALID,
    output                                  S_AXI_AWREADY
);

/* Read Only Memory */
localparam  ROM_WIDTH = 32;
localparam  ROM_ADDR_WIDTH = 4;

reg [ROM_WIDTH - 1 : 0] info_rom [(2 ** ROM_ADDR_WIDTH) - 1 : 0];

initial
    $readmemh(C_INFO_FILE, info_rom, 0, 15);

/* IPIF signals */
wire                                        Bus2IP_Clk;
wire                                        Bus2IP_Resetn;
wire        [C_S_AXI_ADDR_WIDTH-1:0]        Bus2IP_Addr;
wire        [0:0]                           Bus2IP_CS;
wire                                        Bus2IP_RNW;
wire        [C_S_AXI_DATA_WIDTH-1:0]        Bus2IP_Data;
wire        [C_S_AXI_DATA_WIDTH/8-1:0]      Bus2IP_BE;
reg         [C_S_AXI_DATA_WIDTH-1:0]        IP2Bus_Data;
reg                                         IP2Bus_RdAck;
reg                                         IP2Bus_WrAck;
wire                                        IP2Bus_Error = 0;

wire w_wren = (Bus2IP_CS && ~Bus2IP_RNW);
wire w_rden = (Bus2IP_CS && Bus2IP_RNW);

always @(posedge S_AXI_ACLK)
    if (~S_AXI_ARESETN)
        IP2Bus_WrAck   <= 0;
    else if (~Bus2IP_CS)
        IP2Bus_WrAck   <= 0;
    else if (w_wren)
        IP2Bus_WrAck   <= 1;

always @(posedge Bus2IP_Clk)
    if (w_rden) begin
        IP2Bus_Data <= info_rom[Bus2IP_Addr[5:2]];
        IP2Bus_RdAck <= 1;
    end else begin
        IP2Bus_Data <= 32'h00000000;
        IP2Bus_RdAck <= 0;
    end

// -- AXILITE IPIF
axi_lite_ipif_1bar
#(
    .C_S_AXI_DATA_WIDTH                     ( C_S_AXI_DATA_WIDTH ),
    .C_S_AXI_ADDR_WIDTH                     ( C_S_AXI_ADDR_WIDTH ),
    .C_USE_WSTRB                            ( C_USE_WSTRB ),
    .C_DPHASE_TIMEOUT                       ( C_DPHASE_TIMEOUT ),
    .C_BAR0_BASEADDR                        ( C_BASEADDR ),
    .C_BAR0_HIGHADDR                        ( C_HIGHADDR )
) axi_lite_ipif_inst (
    .S_AXI_ACLK                             ( S_AXI_ACLK ),
    .S_AXI_ARESETN                          ( S_AXI_ARESETN ),
    .S_AXI_AWADDR                           ( S_AXI_AWADDR ),
    .S_AXI_AWVALID                          ( S_AXI_AWVALID ),
    .S_AXI_WDATA                            ( S_AXI_WDATA ),
    .S_AXI_WSTRB                            ( S_AXI_WSTRB ),
    .S_AXI_WVALID                           ( S_AXI_WVALID ),
    .S_AXI_BREADY                           ( S_AXI_BREADY ),
    .S_AXI_ARADDR                           ( S_AXI_ARADDR ),
    .S_AXI_ARVALID                          ( S_AXI_ARVALID ),
    .S_AXI_RREADY                           ( S_AXI_RREADY ),
    .S_AXI_ARREADY                          ( S_AXI_ARREADY ),
    .S_AXI_RDATA                            ( S_AXI_RDATA ),
    .S_AXI_RRESP                            ( S_AXI_RRESP ),
    .S_AXI_RVALID                           ( S_AXI_RVALID ),
    .S_AXI_WREADY                           ( S_AXI_WREADY ),
    .S_AXI_BRESP                            ( S_AXI_BRESP ),
    .S_AXI_BVALID                           ( S_AXI_BVALID ),
    .S_AXI_AWREADY                          ( S_AXI_AWREADY ),

    // Controls to the IP/IPIF modules
    .Bus2IP_Clk                             ( Bus2IP_Clk ),
    .Bus2IP_Resetn                          ( Bus2IP_Resetn ),
    .Bus2IP_Addr                            ( Bus2IP_Addr ),
    .Bus2IP_RNW                             ( Bus2IP_RNW ),
    .Bus2IP_BE                              ( Bus2IP_BE ),
    .Bus2IP_CS                              ( Bus2IP_CS ),
    .Bus2IP_Data                            ( Bus2IP_Data ),
    .IP2Bus_Data                            ( IP2Bus_Data ),
    .IP2Bus_WrAck                           ( IP2Bus_WrAck ),
    .IP2Bus_RdAck                           ( IP2Bus_RdAck ),
    .IP2Bus_Error                           ( IP2Bus_Error )
);

endmodule
