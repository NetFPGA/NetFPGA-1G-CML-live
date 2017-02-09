`timescale 1ps/1ps

/*******************************************************************************
 *
 *  NetFPGA-1G-CML http://www.netfpga.org
 *
 *  File:
 *        pseudo_xpm_cdc_single.v
 *
 *  Library:
 *        hw/std/pcores/dma_v1_20_a
 *
 *  Module:
 *        xpm_cdc_single
 *
 *  Author:
 *        Jack Meador
 *
 *  Description:
 * 
 *        This module substitutes for the xpm_cdc_single synchronizer macro
 *        available in the Vivado Design Suite, but not found in ISE/EDK.
 * 
 *        It is included here to help keep the legacy NetFPGA dma design
 *        forward-compatible with contemporary pcie_7x cores. It is only 
 *        intended to support the dma functionality required by legacy 
 *        NetFPGA ISE/EDK designs. 
 * 
 *  Copyright notice:
 *        Copyright (C) 2017 Computer Measurement Laboratory, LLC
 *
 *  Licence:
 *        This file is part of the NetFPGA_1G_CML ISE/EDK development base package.
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


module xpm_cdc_single #(
  parameter DEST_SYNC_FF  = 2,          // number of sync stages
  parameter SRC_INPUT_REG = 0           // parameter included but not supported here
  ) (
  input src_clk,                        // not used here
  input src_in,
  input dest_clk,
  output dest_out
  );

reg [DEST_SYNC_FF-1:0] syncflops;

assign dest_out = syncflops[DEST_SYNC_FF-1];

// sync flops
always @(posedge dest_clk) begin
        syncflops<= {syncflops[DEST_SYNC_FF-2:0], src_in};
        end

endmodule
