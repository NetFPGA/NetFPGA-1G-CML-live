################################################################################
#
#  NetFPGA-1G-CML http://www.netfpga.org
#
#  File:
#        Makefile
#
#  Project:
#        loopback_test_nf7
#
#  Author:
#        Jack Meador
#
#  Description:
#        all : Build software-initialized bitfile in bitfiles/download.bit
#        download : Transfer software-initialized bitfile to NetFPGA-7 PCB 
#        sim : Rebuild software and run full system simulation
#        run : Rebuild software and download elf to programmed PCB via MDM
#
#  Copyright notice:
#        Copyright (C) 2013 Computer Measurement Laboratory, LLC
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

SYSTEM = system
HW = hw
SW = sw/embedded

all:
	$(MAKE) -C $(HW) bits
	$(MAKE) -C $(HW) exporttosdk
	$(MAKE) -C $(SW)
	cp $(SW)/result/download.bit bitfiles/download.bit

sim:
	$(MAKE) -C $(SW)
	$(MAKE) -C $(HW) sim

download: bitfiles/download.bit
	cp $(SW)/result/download.bit bitfiles/download.bit
	impact -batch nf7/program.bat

download_test: bitfiles/loopback_test_nf7.bit
	cp bitfiles/loopback_test_nf7.bit bitfiles/download.bit
	impact -batch nf7/program.bat

run:
	$(MAKE) -C $(SW)
	xmd -tcl nf7/xmd-run.tcl

simclean:
	$(MAKE) -C $(HW) simclean

clean:
	$(MAKE) -C $(HW) clean
	$(MAKE) -C $(SW) clean
	rm -f bitfiles/download.bit *.log
