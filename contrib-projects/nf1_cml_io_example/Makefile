################################################################################
#
#  NetFPGA-1G-CML http://www.netfpga.org
#
#  Project:
#        nf1_cml_io_example
#
#  Author:
#        Jay Hirata
#
#  Copyright notice:
#        Copyright (C) 2014 Computer Measurement Laboratory
#
#  Licence:
#        This file is part of the NetFPGA-1G-CML development base package.
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
################################################################################

.PHONY: hw fw program download all help clean


help:
	@echo "--------------------------------------------------------------------------------"
	@echo "NetFPGA-1G-CML IO Example"
	@echo "--------------------------------------------------------------------------------"
	@echo "	all         : Build hardware and firmware, then program the FPGA and download"
	@echo "	              firmware."
	@echo "	hw          : Build the hardware component of the project."
	@echo "	fw          : Build the firmware component of the project."
	@echo "	program     : Program the FPGA."
	@echo "	download    : Download the firmware to the FPGA. (Requires program first)"
	@echo "	clean       : Clean all generated files."
	@echo ""

hw:
	$(MAKE) -C hw/ hw

fw:
	$(MAKE) -C hw/ swprep
	$(MAKE) -C sw/embedded all


program: hw
	xmd -tcl ./tools/program.tcl


download: fw
	xmd -tcl ./tools/download.tcl

all: program download

clean:
	$(MAKE) -C hw clean
	$(MAKE) -C sw/embedded clean
