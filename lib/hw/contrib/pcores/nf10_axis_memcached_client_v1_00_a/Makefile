################################################################################
#
#  NetFPGA-10G http://www.netfpga.org
#
#  File:
#        Makefile
#
#  Library:
#        hw/std/pcores/nf10_axis_memcached_client_v1_00_a
#
#  Author:
#        Michaela Blott
#
#  Description:
#        Unit test makefile.
#
#  Copyright notice:
#        Copyright (C) 2010, 2011 Xilinx, Inc.
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

COREGEN_DIR:= coregen

install: hdl/vhdl/async_fifo_1_16.vhd hdl/vhdl/async_fifo_32_129.vhd

hdl/vhdl/async_fifo_1_16.vhd: xco/async_fifo_1_16.xco
	@mkdir -p netlist
	@mkdir -p $(COREGEN_DIR);
	@cd $(COREGEN_DIR) && touch coregen.cgp && coregen -p coregen.cgp -b ../xco/async_fifo_1_16.xco
	@cp $(COREGEN_DIR)/async_fifo_1_16.vhd hdl/vhdl/
	@cp $(COREGEN_DIR)/async_fifo_1_16.ngc netlist/
	@echo "//////////////////////////////////////////////////";
	@echo "// Xilinx ASYNC_FIFO_1_16 core installed.";
	@echo "//////////////////////////////////////////////////";
	@rm -rf $(COREGEN_DIR);

hdl/vhdl/async_fifo_32_129.vhd: xco/async_fifo_32_129.xco
	@mkdir -p netlist
	@mkdir -p $(COREGEN_DIR);
	@cd $(COREGEN_DIR) && touch coregen.cgp && coregen -p coregen.cgp -b ../xco/async_fifo_32_129.xco
	@cp $(COREGEN_DIR)/async_fifo_32_129.vhd hdl/vhdl/
	@cp $(COREGEN_DIR)/async_fifo_32_129.ngc netlist/
	@echo "//////////////////////////////////////////////////";
	@echo "// Xilinx ASYNC_FIFO_32_129 core installed.";
	@echo "//////////////////////////////////////////////////";
	@rm -rf $(COREGEN_DIR);


unittest:
	hdl/vhdl/nf10_axis_memcached_client_tb.sh

clean:
	rm -rf hdl/vhdl/unittest_build

.PHONY: unittest clean
