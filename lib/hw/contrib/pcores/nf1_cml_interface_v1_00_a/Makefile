################################################################################
#
#  NetFPGA-1G-CML http://www.netfpga.org
#
#  File:
#        Makefile
#
#  Library:
#        hw/contrib/pcores/nf1_cml_interface_v1_10_a
#
#  Author:
#        Adam Covington
#        Jack Meador
#
#  Description:
#        make install : build trimac, trimac_lite and ucsd_mac
#        in preparation for use with nf1_cml_interface
#
#        For more information about how Xilinx EDK works, please visit
#        http://www.xilinx.com/support/documentation/dt_edk.htm
#
#  Copyright notice:
#        Copyright (C) 2010, 2011 The Board of Trustees of The Leland Stanford
#                                 Junior University
#        Copyright (C) 2013, Computer Measurement Laboratory, LLC
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

TRIMAC_WORK = trimac_work
TRIMAC_LITE_WORK = trimac_lite_work
XILINX_DIR = hdl/verilog/xilinx
UCSD_DIR = hdl/verilog/ucsd
UCSD_SRCS = $(UCSD_DIR)/CRC_chk.v $(UCSD_DIR)/CRC_gen.v $(UCSD_DIR)/gig_eth_mac_block.v $(UCSD_DIR)/gig_eth_mac_fifo_block.v $(UCSD_DIR)/gig_eth_mac_rx.v $(UCSD_DIR)/gig_eth_mac_tx.v $(UCSD_DIR)/gig_eth_mac.v 

.PHONY: install clean trimac trimac_lite ucsd_mac

install: trimac trimac_lite ucsd_mac
	@echo "///////////////////////////////////////////";
	@echo "//nf1_cml_interface installed";
	@echo "///////////////////////////////////////////";

trimac: netlist/trimac.ngc
netlist/trimac.ngc: xco/trimac.xco
	@mkdir -p $(TRIMAC_WORK); mkdir -p $(XILINX_DIR)/trimac; mkdir -p netlist; mkdir -p simhdl/verilog;
	@cd $(TRIMAC_WORK) &&	coregen -b ../xco/trimac.xco
	@cp $(TRIMAC_WORK)/trimac.ngc netlist
	@cp $(TRIMAC_WORK)/trimac/example_design/trimac_fifo_block.v $(XILINX_DIR)/trimac
	@cp $(TRIMAC_WORK)/trimac/example_design/trimac_block.v $(XILINX_DIR)/trimac
	@cp $(TRIMAC_WORK)/trimac/example_design/physical/trimac_rgmii_v2_0_if.v $(XILINX_DIR)/trimac
	@cp $(TRIMAC_WORK)/trimac/example_design/common/trimac_sync_block.v $(XILINX_DIR)/trimac
	@cp $(TRIMAC_WORK)/trimac/example_design/common/trimac_reset_sync.v $(XILINX_DIR)/trimac
	@cp $(TRIMAC_WORK)/trimac/example_design/fifo/trimac_ten_100_1g_eth_fifo.v $(XILINX_DIR)/trimac
	@cp $(TRIMAC_WORK)/trimac/example_design/fifo/trimac_rx_client_fifo.v $(XILINX_DIR)/trimac
	@cp $(TRIMAC_WORK)/trimac/example_design/fifo/trimac_tx_client_fifo.v $(XILINX_DIR)/trimac
	@cp $(TRIMAC_WORK)/trimac/example_design/trimac_mod.v $(XILINX_DIR)/trimac
	@cp $(TRIMAC_WORK)/trimac/example_design/axi_ipif/* $(XILINX_DIR)/trimac
	@cp $(TRIMAC_WORK)/trimac.v simhdl/verilog
	@patch $(XILINX_DIR)/trimac/trimac_rgmii_v2_0_if.v $(XILINX_DIR)/trimac/trimac_rgmii_v2_0_if.diff
	@patch $(XILINX_DIR)/trimac/trimac_fifo_block.v $(XILINX_DIR)/trimac/trimac_fifo_block.diff
	@patch $(XILINX_DIR)/trimac/trimac_block.v $(XILINX_DIR)/trimac/trimac_block.diff

ucsd_mac: trimac_lite $(UCSD_SRCS)
trimac_lite: netlist/trimac_lite.ngc
netlist/trimac_lite.ngc: xco/trimac_lite.xco
	@mkdir -p $(TRIMAC_LITE_WORK); mkdir -p netlist; mkdir -p simhdl/verilog;
	@cd $(TRIMAC_LITE_WORK) &&	coregen -b ../xco/trimac_lite.xco
	@cp $(TRIMAC_LITE_WORK)/trimac_lite.ngc netlist
	@cp $(TRIMAC_LITE_WORK)/trimac_lite/example_design/trimac_lite_fifo_block.v $(XILINX_DIR)/trimac_lite
	@cp $(TRIMAC_LITE_WORK)/trimac_lite/example_design/trimac_lite_block.v $(XILINX_DIR)/trimac_lite
	@cp $(TRIMAC_LITE_WORK)/trimac_lite/example_design/physical/trimac_lite_rgmii_v2_0_if.v $(XILINX_DIR)/trimac_lite
	@cp $(TRIMAC_LITE_WORK)/trimac_lite/example_design/common/trimac_lite_sync_block.v $(XILINX_DIR)/trimac_lite
	@cp $(TRIMAC_LITE_WORK)/trimac_lite/example_design/common/trimac_lite_reset_sync.v $(XILINX_DIR)/trimac_lite
	@cp $(TRIMAC_LITE_WORK)/trimac_lite/example_design/fifo/trimac_lite_ten_100_1g_eth_fifo.v $(XILINX_DIR)/trimac_lite
	@cp $(TRIMAC_LITE_WORK)/trimac_lite/example_design/fifo/trimac_lite_rx_client_fifo.v $(XILINX_DIR)/trimac_lite
	@cp $(TRIMAC_LITE_WORK)/trimac_lite/example_design/fifo/trimac_lite_tx_client_fifo.v $(XILINX_DIR)/trimac_lite
	@cp $(TRIMAC_LITE_WORK)/trimac_lite/example_design/trimac_lite_mod.v $(XILINX_DIR)/trimac_lite
	@cp $(TRIMAC_LITE_WORK)/trimac_lite.v simhdl/verilog
	@patch $(XILINX_DIR)/trimac_lite/trimac_lite_fifo_block.v $(XILINX_DIR)/trimac_lite/trimac_lite_fifo_block.diff
	@patch $(XILINX_DIR)/trimac_lite/trimac_lite_block.v $(XILINX_DIR)/trimac_lite/trimac_lite_block.diff
	@cp $(TRIMAC_LITE_WORK)/trimac_lite/example_design/physical/trimac_lite_rgmii_v2_0_if.v $(UCSD_DIR)/xilinx_rgmii_v2_0_if.v
	@cp $(TRIMAC_LITE_WORK)/trimac_lite/example_design/common/trimac_lite_sync_block.v $(UCSD_DIR)/xilinx_sync_block.v
	@cp $(TRIMAC_LITE_WORK)/trimac_lite/example_design/common/trimac_lite_reset_sync.v $(UCSD_DIR)/xilinx_reset_sync.v
	@cp $(TRIMAC_LITE_WORK)/trimac_lite/example_design/fifo/trimac_lite_ten_100_1g_eth_fifo.v $(UCSD_DIR)/xilinx_ten_100_1g_eth_fifo.v
	@cp $(TRIMAC_LITE_WORK)/trimac_lite/example_design/fifo/trimac_lite_rx_client_fifo.v $(UCSD_DIR)/xilinx_rx_client_fifo.v
	@cp $(TRIMAC_LITE_WORK)/trimac_lite/example_design/fifo/trimac_lite_tx_client_fifo.v $(UCSD_DIR)/xilinx_tx_client_fifo.v
	@patch $(UCSD_DIR)/xilinx_rgmii_v2_0_if.v $(UCSD_DIR)/xilinx_rgmii_v2_0_if.diff
	@patch $(UCSD_DIR)/xilinx_sync_block.v $(UCSD_DIR)/xilinx_sync_block.diff
	@patch $(UCSD_DIR)/xilinx_reset_sync.v $(UCSD_DIR)/xilinx_reset_sync.diff
	@patch $(UCSD_DIR)/xilinx_ten_100_1g_eth_fifo.v $(UCSD_DIR)/xilinx_ten_100_1g_eth_fifo.diff
	@patch $(UCSD_DIR)/xilinx_rx_client_fifo.v $(UCSD_DIR)/xilinx_rx_client_fifo.diff
	@patch $(UCSD_DIR)/xilinx_tx_client_fifo.v $(UCSD_DIR)/xilinx_tx_client_fifo.diff

clean:
	@rm -rf $(TRIMAC_LITE_WORK);
	@rm -rf $(TRIMAC_WORK);
	@rm -rf $(XILINX_DIR)/*/*.v
	@rm -rf $(UCSD_DIR)/xilinx*.v
	@rm -rf netlist
	@rm -rf simhdl
	@echo "/////////////////////////////////////////";
	@echo "//nf1_cml_interface removed";
	@echo "/////////////////////////////////////////";
