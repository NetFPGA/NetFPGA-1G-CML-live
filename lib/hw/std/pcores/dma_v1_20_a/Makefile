################################################################################
#
#  NetFPGA-10G http://www.netfpga.org
#
#  File:
#        Makefile
#
#  Library:
#        hw/contrib/pcores/dma_v1_20_a
#
#  Author:
#        Mario Flajslik
#        Jack Meador, Computer Measurement Laboratory, LLC
#
#  Description:
#        make install : Copy Xilinx files into NetFPGA-10G library
#
#        For more information about how Xilinx EDK works, please visit
#        http://www.xilinx.com/support/documentation/dt_edk.htm
#
#  Copyright notice:
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

SV_DIR = hdl/SystemVerilog

SV_SRCS = $(SV_DIR)/axi.v $(SV_DIR)/lib.v $(SV_DIR)/pcie_rd_q.v $(SV_DIR)/pcie_rx.v $(SV_DIR)/pcie_tx_q.v $(SV_DIR)/pcie_tx_wr.v $(SV_DIR)/rx_ctrl.v $(SV_DIR)/tx_ctrl.v $(SV_DIR)/cfg.v $(SV_DIR)/dma.v $(SV_DIR)/mem.v $(SV_DIR)/pcie_rx_cm.v $(SV_DIR)/pcie_rx_wr.v $(SV_DIR)/pcie_tx_rd.v $(SV_DIR)/pcie_wr_q.v $(SV_DIR)/small_async_fifo.v $(SV_DIR)/dma_defs.vh $(SV_DIR)/iface.v $(SV_DIR)/pcie_cm_q.v $(SV_DIR)/pcie_rx_rd.v $(SV_DIR)/pcie_tx_cm.v $(SV_DIR)/pcie_tx.v $(SV_DIR)/stats.v

.PHONY: all clean

all: hdl/verilog/xilinx/pcie_7x.v netlist/dma_engine.edf

hdl/verilog/xilinx/pcie_7x.v: data/pcie_generate.tcl
	@vivado -mode tcl -source data/pcie_generate.tcl
	@mkdir -p hdl/verilog/xilinx
	@cp vivado_work/pcie_7x.srcs/sources_1/ip/pcie_7x/source/* hdl/verilog/xilinx
	@cp vivado_work/pcie_7x.srcs/sources_1/ip/pcie_7x/synth/*.v hdl/verilog/xilinx

netlist/dma_engine.edf: $(SV_SRCS) data/dma_sv_compile.tcl
	@vivado -mode tcl -source data/dma_sv_compile.tcl

clean:
	rm -rf vivado_work .Xil fsm_encoding.os vivado*.jou vivado*.log hdl/verilog/xilinx

