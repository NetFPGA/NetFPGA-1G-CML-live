################################################################################
#
#  NetFPGA-10G http://www.netfpga.org
#
#  File:
#        Makefile
#
#  Library:
#        hw/std/pcores/nf7_1g_interface_v1_10_a
#
#  Author:
#        Jack Meador, Computer Measurement Laboratory, LLC
#
#  Description:
#        make install : Build 1G version of Xilinx TEMAC for NetFPGA-10G library
#        Two versions of the TEMAC are built: the "trimac" version includes
#        both an AXI4 register interface and a PHY MDIO interface. The "trimac_lite"
#        version includes neither. Either is accessible via the C_INCLUDE_CTRL
#        parameter in the EDK.
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

TRIMAC_WORK:= trimac_work
TRIMAC_LITE_WORK:= trimac_lite_work

install: trimac trimac_lite ucsd_mac
	@echo "///////////////////////////////////////////";
	@echo "//nf7_1g_interface installed";
	@echo "///////////////////////////////////////////";

trimac: xco/trimac.xco
	@mkdir -p $(TRIMAC_WORK); mkdir -p hdl/verilog/xilinx/trimac; mkdir -p netlist; mkdir -p simhdl/verilog;
	@cd $(TRIMAC_WORK) &&	coregen -b ../xco/trimac.xco
	@cp $(TRIMAC_WORK)/trimac.ngc netlist
	@cp $(TRIMAC_WORK)/trimac/example_design/trimac_fifo_block.v hdl/verilog/xilinx/trimac
	@cp $(TRIMAC_WORK)/trimac/example_design/trimac_block.v hdl/verilog/xilinx/trimac
	@cp $(TRIMAC_WORK)/trimac/example_design/physical/trimac_rgmii_v2_0_if.v hdl/verilog/xilinx/trimac
	@cp $(TRIMAC_WORK)/trimac/example_design/common/trimac_sync_block.v hdl/verilog/xilinx/trimac
	@cp $(TRIMAC_WORK)/trimac/example_design/common/trimac_reset_sync.v hdl/verilog/xilinx/trimac
	@cp $(TRIMAC_WORK)/trimac/example_design/fifo/trimac_ten_100_1g_eth_fifo.v hdl/verilog/xilinx/trimac
	@cp $(TRIMAC_WORK)/trimac/example_design/fifo/trimac_rx_client_fifo.v hdl/verilog/xilinx/trimac
	@cp $(TRIMAC_WORK)/trimac/example_design/fifo/trimac_tx_client_fifo.v hdl/verilog/xilinx/trimac
	@cp $(TRIMAC_WORK)/trimac/example_design/trimac_mod.v hdl/verilog/xilinx/trimac
	@cp $(TRIMAC_WORK)/trimac/example_design/axi_ipif/* hdl/verilog/xilinx/trimac
	@cp $(TRIMAC_WORK)/trimac.v simhdl/verilog
	@patch hdl/verilog/xilinx/trimac/trimac_rgmii_v2_0_if.v hdl/verilog/xilinx/trimac/trimac_rgmii_v2_0_if.diff
	@patch hdl/verilog/xilinx/trimac/trimac_fifo_block.v hdl/verilog/xilinx/trimac/trimac_fifo_block.diff
	@patch hdl/verilog/xilinx/trimac/trimac_block.v hdl/verilog/xilinx/trimac/trimac_block.diff

trimac_lite: xco/trimac_lite.xco
	@mkdir -p $(TRIMAC_LITE_WORK); mkdir -p netlist; mkdir -p simhdl/verilog;
	@cd $(TRIMAC_LITE_WORK) &&	coregen -b ../xco/trimac_lite.xco
	@cp $(TRIMAC_LITE_WORK)/trimac_lite.ngc netlist
	@cp $(TRIMAC_LITE_WORK)/trimac_lite/example_design/trimac_lite_fifo_block.v hdl/verilog/xilinx/trimac_lite
	@cp $(TRIMAC_LITE_WORK)/trimac_lite/example_design/trimac_lite_block.v hdl/verilog/xilinx/trimac_lite
	@cp $(TRIMAC_LITE_WORK)/trimac_lite/example_design/physical/trimac_lite_rgmii_v2_0_if.v hdl/verilog/xilinx/trimac_lite
	@cp $(TRIMAC_LITE_WORK)/trimac_lite/example_design/common/trimac_lite_sync_block.v hdl/verilog/xilinx/trimac_lite
	@cp $(TRIMAC_LITE_WORK)/trimac_lite/example_design/common/trimac_lite_reset_sync.v hdl/verilog/xilinx/trimac_lite
	@cp $(TRIMAC_LITE_WORK)/trimac_lite/example_design/fifo/trimac_lite_ten_100_1g_eth_fifo.v hdl/verilog/xilinx/trimac_lite
	@cp $(TRIMAC_LITE_WORK)/trimac_lite/example_design/fifo/trimac_lite_rx_client_fifo.v hdl/verilog/xilinx/trimac_lite
	@cp $(TRIMAC_LITE_WORK)/trimac_lite/example_design/fifo/trimac_lite_tx_client_fifo.v hdl/verilog/xilinx/trimac_lite
	@cp $(TRIMAC_LITE_WORK)/trimac_lite/example_design/trimac_lite_mod.v hdl/verilog/xilinx/trimac_lite
	@cp $(TRIMAC_LITE_WORK)/trimac_lite.v simhdl/verilog
	@patch hdl/verilog/xilinx/trimac_lite/trimac_lite_fifo_block.v hdl/verilog/xilinx/trimac_lite/trimac_lite_fifo_block.diff
	@patch hdl/verilog/xilinx/trimac_lite/trimac_lite_block.v hdl/verilog/xilinx/trimac_lite/trimac_lite_block.diff

ucsd_mac: trimac_lite
	@cp $(TRIMAC_LITE_WORK)/trimac_lite/example_design/physical/trimac_lite_rgmii_v2_0_if.v hdl/verilog/ucsd/xilinx_rgmii_v2_0_if.v
	@cp $(TRIMAC_LITE_WORK)/trimac_lite/example_design/common/trimac_lite_sync_block.v hdl/verilog/ucsd/xilinx_sync_block.v
	@cp $(TRIMAC_LITE_WORK)/trimac_lite/example_design/common/trimac_lite_reset_sync.v hdl/verilog/ucsd/xilinx_reset_sync.v
	@cp $(TRIMAC_LITE_WORK)/trimac_lite/example_design/fifo/trimac_lite_ten_100_1g_eth_fifo.v hdl/verilog/ucsd/xilinx_ten_100_1g_eth_fifo.v
	@cp $(TRIMAC_LITE_WORK)/trimac_lite/example_design/fifo/trimac_lite_rx_client_fifo.v hdl/verilog/ucsd/xilinx_rx_client_fifo.v
	@cp $(TRIMAC_LITE_WORK)/trimac_lite/example_design/fifo/trimac_lite_tx_client_fifo.v hdl/verilog/ucsd/xilinx_tx_client_fifo.v
	@patch hdl/verilog/ucsd/xilinx_rgmii_v2_0_if.v hdl/verilog/ucsd/xilinx_rgmii_v2_0_if.diff
	@patch hdl/verilog/ucsd/xilinx_sync_block.v hdl/verilog/ucsd/xilinx_sync_block.diff
	@patch hdl/verilog/ucsd/xilinx_reset_sync.v hdl/verilog/ucsd/xilinx_reset_sync.diff
	@patch hdl/verilog/ucsd/xilinx_ten_100_1g_eth_fifo.v hdl/verilog/ucsd/xilinx_ten_100_1g_eth_fifo.diff
	@patch hdl/verilog/ucsd/xilinx_rx_client_fifo.v hdl/verilog/ucsd/xilinx_rx_client_fifo.diff
	@patch hdl/verilog/ucsd/xilinx_tx_client_fifo.v hdl/verilog/ucsd/xilinx_tx_client_fifo.diff

clean:
	@rm -rf $(TRIMAC_LITE_WORK);
	@rm -rf $(TRIMAC_WORK);
	@rm -rf hdl/verilog/xilinx/*/*.v
	@rm -rf hdl/verilog/ucsd/xilinx*.v
	@rm -rf netlist
	@rm -rf simhdl
	@echo "/////////////////////////////////////////";
	@echo "//nf7_1g_interface removed";
	@echo "/////////////////////////////////////////";
