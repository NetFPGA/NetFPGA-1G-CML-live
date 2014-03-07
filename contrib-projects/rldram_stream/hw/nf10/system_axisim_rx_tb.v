/*******************************************************************************
*
*  NetFPGA-10G http://www.netfpga.org
*
*  File:
*        system_axisim_rx_tb.v
*
*  Project:
*        rldram_stream 
*
*  Module:
*        system_axisim_rx_tb
*
*  Author:
*        Jong Hun HAN
*
*  Description:
*        System testbench for rldram_stream rx path
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


`timescale 1 ns / 1ps

`uselib lib=unisims_ver

// START USER CODE (Do not remove this line)

`include "./rldram2.v"

`define BOARD_SKEW #0.500 // put a 500 ps delay on the QK lines between FPGA and RAMs 

// User: Put your directives here. Code in this
//       section will not be overwritten.

// END USER CODE (Do not remove this line)

module system_axisim_tb
  (
  );

  // START USER CODE (Do not remove this line)

  // User: Put your signals here. Code in this
  //       section will not be overwritten.
  integer             i;

  // END USER CODE (Do not remove this line)

  reg RESET;
  wire RS232_Uart_1_sout;
  reg RS232_Uart_1_sin;
  reg CLK;
  reg refclk_A_p;
  reg refclk_A_n;
  reg refclk_B_p;
  reg refclk_B_n;
  reg refclk_C_p;
  reg refclk_C_n;
  reg refclk_D_p;
  reg refclk_D_n;
  wire MDC;
  wire MDIO;
  wire PHY_RST_N;
  wire [19:0] nf10_rldram_mmap_A_RLD2_A_pin;
  wire [2:0] nf10_rldram_mmap_A_RLD2_BA_pin;
  wire [1:0] nf10_rldram_mmap_A_RLD2_CK_N_pin;
  wire [1:0] nf10_rldram_mmap_A_RLD2_CK_P_pin;
  wire [1:0] nf10_rldram_mmap_A_RLD2_CS_N_pin;
  wire [3:0] nf10_rldram_mmap_A_RLD2_DK_N_pin;
  wire [3:0] nf10_rldram_mmap_A_RLD2_DK_P_pin;
  wire [63:0] nf10_rldram_mmap_A_RLD2_DQ;
  wire [3:0] nf10_rldram_mmap_A_RLD2_QK_N_pin;
  wire [3:0] nf10_rldram_mmap_A_RLD2_QK_P_pin;
  wire [1:0] nf10_rldram_mmap_A_RLD2_QVLD_pin;
  wire nf10_rldram_mmap_A_RLD2_REF_N_pin;
  wire nf10_rldram_mmap_A_RLD2_WE_N_pin;
  wire [19:0] nf10_rldram_mmap_B_RLD2_A_pin;
  wire [2:0] nf10_rldram_mmap_B_RLD2_BA_pin;
  wire [1:0] nf10_rldram_mmap_B_RLD2_CK_N_pin;
  wire [1:0] nf10_rldram_mmap_B_RLD2_CK_P_pin;
  wire [1:0] nf10_rldram_mmap_B_RLD2_CS_N_pin;
  wire [3:0] nf10_rldram_mmap_B_RLD2_DK_N_pin;
  wire [3:0] nf10_rldram_mmap_B_RLD2_DK_P_pin;
  wire [63:0] nf10_rldram_mmap_B_RLD2_DQ;
  wire [3:0] nf10_rldram_mmap_B_RLD2_QK_N_pin;
  wire [3:0] nf10_rldram_mmap_B_RLD2_QK_P_pin;
  wire [1:0] nf10_rldram_mmap_B_RLD2_QVLD_pin;
  wire nf10_rldram_mmap_B_RLD2_REF_N_pin;
  wire nf10_rldram_mmap_B_RLD2_WE_N_pin;

  system_axisim
    dut (
      .RESET ( RESET ),
      .RS232_Uart_1_sout ( RS232_Uart_1_sout ),
      .RS232_Uart_1_sin ( RS232_Uart_1_sin ),
      .CLK ( CLK ),
      .refclk_A_p ( refclk_A_p ),
      .refclk_A_n ( refclk_A_n ),
      .refclk_B_p ( refclk_B_p ),
      .refclk_B_n ( refclk_B_n ),
      .refclk_C_p ( refclk_C_p ),
      .refclk_C_n ( refclk_C_n ),
      .refclk_D_p ( refclk_D_p ),
      .refclk_D_n ( refclk_D_n ),
      .nf10_rldram_mmap_A_RLD2_CK_P_pin ( nf10_rldram_mmap_A_RLD2_CK_P_pin ),
      .nf10_rldram_mmap_A_RLD2_CK_N_pin ( nf10_rldram_mmap_A_RLD2_CK_N_pin ),
      .nf10_rldram_mmap_A_RLD2_DK_P_pin ( nf10_rldram_mmap_A_RLD2_DK_P_pin ),
      .nf10_rldram_mmap_A_RLD2_DK_N_pin ( nf10_rldram_mmap_A_RLD2_DK_N_pin ),
      .nf10_rldram_mmap_A_RLD2_QK_P_pin ( nf10_rldram_mmap_A_RLD2_QK_P_pin ),
      .nf10_rldram_mmap_A_RLD2_QK_N_pin ( nf10_rldram_mmap_A_RLD2_QK_N_pin ),
      .nf10_rldram_mmap_A_RLD2_A_pin ( nf10_rldram_mmap_A_RLD2_A_pin ),
      .nf10_rldram_mmap_A_RLD2_BA_pin ( nf10_rldram_mmap_A_RLD2_BA_pin ),
      .nf10_rldram_mmap_A_RLD2_CS_N_pin ( nf10_rldram_mmap_A_RLD2_CS_N_pin ),
      .nf10_rldram_mmap_A_RLD2_WE_N_pin ( nf10_rldram_mmap_A_RLD2_WE_N_pin ),
      .nf10_rldram_mmap_A_RLD2_REF_N_pin ( nf10_rldram_mmap_A_RLD2_REF_N_pin ),
      .nf10_rldram_mmap_A_RLD2_DQ ( nf10_rldram_mmap_A_RLD2_DQ ),
      .nf10_rldram_mmap_A_RLD2_QVLD_pin ( nf10_rldram_mmap_A_RLD2_QVLD_pin ),
      .nf10_rldram_mmap_B_RLD2_CK_P_pin ( nf10_rldram_mmap_B_RLD2_CK_P_pin ),
      .nf10_rldram_mmap_B_RLD2_CK_N_pin ( nf10_rldram_mmap_B_RLD2_CK_N_pin ),
      .nf10_rldram_mmap_B_RLD2_DK_P_pin ( nf10_rldram_mmap_B_RLD2_DK_P_pin ),
      .nf10_rldram_mmap_B_RLD2_DK_N_pin ( nf10_rldram_mmap_B_RLD2_DK_N_pin ),
      .nf10_rldram_mmap_B_RLD2_QK_P_pin ( nf10_rldram_mmap_B_RLD2_QK_P_pin ),
      .nf10_rldram_mmap_B_RLD2_QK_N_pin ( nf10_rldram_mmap_B_RLD2_QK_N_pin ),
      .nf10_rldram_mmap_B_RLD2_A_pin ( nf10_rldram_mmap_B_RLD2_A_pin ),
      .nf10_rldram_mmap_B_RLD2_BA_pin ( nf10_rldram_mmap_B_RLD2_BA_pin ),
      .nf10_rldram_mmap_B_RLD2_CS_N_pin ( nf10_rldram_mmap_B_RLD2_CS_N_pin ),
      .nf10_rldram_mmap_B_RLD2_WE_N_pin ( nf10_rldram_mmap_B_RLD2_WE_N_pin ),
      .nf10_rldram_mmap_B_RLD2_REF_N_pin ( nf10_rldram_mmap_B_RLD2_REF_N_pin ),
      .nf10_rldram_mmap_B_RLD2_DQ ( nf10_rldram_mmap_B_RLD2_DQ ),
      .nf10_rldram_mmap_B_RLD2_QVLD_pin ( nf10_rldram_mmap_B_RLD2_QVLD_pin ),
      .MDC ( MDC ),
      .MDIO ( MDIO ),
      .PHY_RST_N ( PHY_RST_N )
    );


  // START USER CODE (Do not remove this line)

  // User: Put your stimulus here. Code in this
  //       section will not be overwritten.

  // Part 1: Wire connection

  // Part 2: Reset
  initial begin
      RS232_Uart_1_sin = 1'b0;
      CLK   = 1'b0;

      refclk_A_p = 1'b0;
      refclk_A_n = 1'b1;
      refclk_B_p = 1'b0;
      refclk_B_n = 1'b1;
      refclk_C_p = 1'b0;
      refclk_C_n = 1'b1;
      refclk_D_p = 1'b0;
      refclk_D_n = 1'b1;

      $display("[%t] : System Reset Asserted...", $realtime);
      RESET = 1'b0;
      for (i = 0; i < 50; i = i + 1) begin
                 @(posedge CLK);
      end
      $display("[%t] : System Reset De-asserted...", $realtime);
      RESET = 1'b1;
  end

  // Part 3: Clock
  always #5  CLK = ~CLK;      // 100MHz
  always #3.2 refclk_A_p = ~refclk_A_p; // 156.25MHz
  always #3.2 refclk_A_n = ~refclk_A_n; // 156.25MHz
  always #3.2 refclk_B_p = ~refclk_B_p; // 156.25MHz
  always #3.2 refclk_B_n = ~refclk_B_n; // 156.25MHz
  always #3.2 refclk_C_p = ~refclk_C_p; // 156.25MHz
  always #3.2 refclk_C_n = ~refclk_C_n; // 156.25MHz
  always #3.2 refclk_D_p = ~refclk_D_p; // 156.25MHz
  always #3.2 refclk_D_n = ~refclk_D_n; // 156.25MHz

   // END USER CODE (Do not remove this line)
   wire [3:0] 	bRL_A_QK;
   wire [3:0] 	bRL_A_QK_N;
   wire [3:0] 	bRL_B_QK;
   wire [3:0] 	bRL_B_QK_N;

   assign  `BOARD_SKEW nf10_rldram_mmap_A_RLD2_QK_P_pin = bRL_A_QK[2*NUM_OF_DEVS-1:0];
   assign  `BOARD_SKEW nf10_rldram_mmap_A_RLD2_QK_N_pin = bRL_A_QK_N[2*NUM_OF_DEVS-1:0];

   assign  `BOARD_SKEW nf10_rldram_mmap_B_RLD2_QK_P_pin = bRL_B_QK[2*NUM_OF_DEVS-1:0];
   assign  `BOARD_SKEW nf10_rldram_mmap_B_RLD2_QK_N_pin = bRL_B_QK_N[2*NUM_OF_DEVS-1:0];

   //wire clk_200p = system_axisim_tb.dut.nf10_rldram_0.nf10_rldram_0.rldram_rd_data.clk_200_p;
   // RLDRAM-II memory models
   // needs to be downloaded from Micron's website (not included in XAPP852)
   parameter RL_DQ_WIDTH     = 72;
   parameter DEV_DQ_WIDTH    = 36;  // data width of the memory device
   parameter NUM_OF_DEVS     = RL_DQ_WIDTH/DEV_DQ_WIDTH;  // number of memory devices
   parameter NUM_OF_DKS      = (DEV_DQ_WIDTH == 36) ? 2*NUM_OF_DEVS : NUM_OF_DEVS;

   wire [7:0] wgnd;


	//DMA Stim packet dump for comparing
`include "../../nf10/wire_tb.v"

`include "../../nf10/dma_rx_checker.v"


initial begin
	#100;
	nf10g_0_stim_packet_dump("../../nf10_10g_interface_0_stim.axi",8'h01);
	nf10g_1_stim_packet_dump("../../nf10_10g_interface_1_stim.axi",8'h04);
	nf10g_2_stim_packet_dump("../../nf10_10g_interface_2_stim.axi",8'h10);
	nf10g_3_stim_packet_dump("../../nf10_10g_interface_3_stim.axi",8'h40);
end

`include "../../nf10/task_nf10g_stim_packet_dump.v"


rldram2 ram0 (
    .ck     ( nf10_rldram_mmap_A_RLD2_CK_P_pin[0] ),
    .ck_n   ( nf10_rldram_mmap_A_RLD2_CK_N_pin[0] ),
    .cs_n   ( nf10_rldram_mmap_A_RLD2_CS_N_pin[0] ),
    .we_n   ( nf10_rldram_mmap_A_RLD2_WE_N_pin ),
    .ref_n  ( nf10_rldram_mmap_A_RLD2_REF_N_pin ),
    .ba     ( nf10_rldram_mmap_A_RLD2_BA_pin[2:0] ),
    .a      ( nf10_rldram_mmap_A_RLD2_A_pin[19:0] ),
    .dm     ( 1'b0 ),
    .dk     ( nf10_rldram_mmap_A_RLD2_DK_P_pin[NUM_OF_DKS/2-1:0] ),
    .dk_n   ( nf10_rldram_mmap_A_RLD2_DK_N_pin[NUM_OF_DKS/2-1:0] ),
    .dq     ( {wgnd[7:6], nf10_rldram_mmap_A_RLD2_DQ[31:16], wgnd[5:4], nf10_rldram_mmap_A_RLD2_DQ[15:0]}),
    .qk     ( bRL_A_QK[2*NUM_OF_DEVS/2-1:0] ),
    .qk_n   ( bRL_A_QK_N[2*NUM_OF_DEVS/2-1:0] ),
    .qvld   ( nf10_rldram_mmap_A_RLD2_QVLD_pin[0] ),
// JTAG PORTS
    .tck    (1'b0),
    .tms    (1'b0),
    .tdi    (1'b0),
    .tdo    (  )
);

rldram2 ram1 (
    .ck     ( nf10_rldram_mmap_A_RLD2_CK_P_pin[1] ),
    .ck_n   ( nf10_rldram_mmap_A_RLD2_CK_N_pin[1] ),
    .cs_n   ( nf10_rldram_mmap_A_RLD2_CS_N_pin[1] ),
    .we_n   ( nf10_rldram_mmap_A_RLD2_WE_N_pin ),
    .ref_n  ( nf10_rldram_mmap_A_RLD2_REF_N_pin ),
    .ba     ( nf10_rldram_mmap_A_RLD2_BA_pin[2:0] ),
    .a      ( nf10_rldram_mmap_A_RLD2_A_pin[19:0] ),
    .dm     ( 1'b0 ),
    .dk     ( nf10_rldram_mmap_A_RLD2_DK_P_pin[NUM_OF_DKS-1:NUM_OF_DKS/2] ),
    .dk_n   ( nf10_rldram_mmap_A_RLD2_DK_N_pin[NUM_OF_DKS-1:NUM_OF_DKS/2] ),
    .dq     ( {wgnd[7:6], nf10_rldram_mmap_A_RLD2_DQ[63:48], wgnd[7:6], nf10_rldram_mmap_A_RLD2_DQ[47:32]}),
    .qk     ( bRL_A_QK[2*NUM_OF_DEVS-1:2*NUM_OF_DEVS/2] ),
    .qk_n   ( bRL_A_QK_N[2*NUM_OF_DEVS-1:2*NUM_OF_DEVS/2] ),
    .qvld   ( nf10_rldram_mmap_A_RLD2_QVLD_pin[1] ),
// JTAG PORTS
    .tck    (1'b0),
    .tms    (1'b0),
    .tdi    (1'b0),
    .tdo    (  )
);

rldram2 ram2 (
    .ck     ( nf10_rldram_mmap_B_RLD2_CK_P_pin[0] ),
    .ck_n   ( nf10_rldram_mmap_B_RLD2_CK_N_pin[0] ),
    .cs_n   ( nf10_rldram_mmap_B_RLD2_CS_N_pin[0] ),
    .we_n   ( nf10_rldram_mmap_B_RLD2_WE_N_pin ),
    .ref_n  ( nf10_rldram_mmap_B_RLD2_REF_N_pin ),
    .ba     ( nf10_rldram_mmap_B_RLD2_BA_pin[2:0] ),
    .a      ( nf10_rldram_mmap_B_RLD2_A_pin[19:0] ),
    .dm     ( 1'b0 ),
    .dk     ( nf10_rldram_mmap_B_RLD2_DK_P_pin[NUM_OF_DKS/2-1:0] ),
    .dk_n   ( nf10_rldram_mmap_B_RLD2_DK_N_pin[NUM_OF_DKS/2-1:0] ),
    .dq     ( {wgnd[7:6], nf10_rldram_mmap_B_RLD2_DQ[31:16], wgnd[5:4], nf10_rldram_mmap_B_RLD2_DQ[15:0]}),
    .qk     ( bRL_B_QK[2*NUM_OF_DEVS/2-1:0] ),
    .qk_n   ( bRL_B_QK_N[2*NUM_OF_DEVS/2-1:0] ),
    .qvld   ( nf10_rldram_mmap_B_RLD2_QVLD_pin[0] ),
// JTAG PORTS
    .tck    (1'b0),
    .tms    (1'b0),
    .tdi    (1'b0),
    .tdo    (  )
);

rldram2 ram3 (
    .ck     ( nf10_rldram_mmap_B_RLD2_CK_P_pin[1] ),
    .ck_n   ( nf10_rldram_mmap_B_RLD2_CK_N_pin[1] ),
    .cs_n   ( nf10_rldram_mmap_B_RLD2_CS_N_pin[1] ),
    .we_n   ( nf10_rldram_mmap_B_RLD2_WE_N_pin ),
    .ref_n  ( nf10_rldram_mmap_B_RLD2_REF_N_pin ),
    .ba     ( nf10_rldram_mmap_B_RLD2_BA_pin[2:0] ),
    .a      ( nf10_rldram_mmap_B_RLD2_A_pin[19:0] ),
    .dm     ( 1'b0 ),
    .dk     ( nf10_rldram_mmap_B_RLD2_DK_P_pin[NUM_OF_DKS-1:NUM_OF_DKS/2] ),
    .dk_n   ( nf10_rldram_mmap_B_RLD2_DK_N_pin[NUM_OF_DKS-1:NUM_OF_DKS/2] ),
    .dq     ( {wgnd[7:6], nf10_rldram_mmap_B_RLD2_DQ[63:48], wgnd[7:6], nf10_rldram_mmap_B_RLD2_DQ[47:32]}),
    .qk     ( bRL_B_QK[2*NUM_OF_DEVS-1:2*NUM_OF_DEVS/2] ),
    .qk_n   ( bRL_B_QK_N[2*NUM_OF_DEVS-1:2*NUM_OF_DEVS/2] ),
    .qvld   ( nf10_rldram_mmap_B_RLD2_QVLD_pin[1] ),
// JTAG PORTS
    .tck    (1'b0),
    .tms    (1'b0),
    .tdi    (1'b0),
    .tdo    (  )
);


endmodule

