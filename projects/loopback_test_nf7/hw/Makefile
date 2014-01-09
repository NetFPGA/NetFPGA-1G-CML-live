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
#        This Makefile is a configurable wrapper for the
#        standard Xilinx system.make and system_incl.make.
#        These standard makefiles are first automatically generated from
#        the EDK system.xmp and system.mhs then instantiated here.
#
#        For more information about how Xilinx EDK works, please visit
#        http://www.xilinx.com/support/documentation/dt_edk.htm
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


bits: system.make
	$(MAKE) -f system.make bits

exporttosdk: system.make
	$(MAKE) -f system.make exporttosdk

chipscope: system.make
	$(MAKE) -f system.make netlist
	ngcbuild -i implementation/system.ngc implementation/system_all.ngc
	inserter -insert Chipscope/ucsd.cdc -ngcbuild -dd implementation -i implementation/system_all.ngc implementation/system.ngc
	$(MAKE) -f system.make bits 

sim: system.make
	mkdir -p simulation/behavioral
	cp nf7/system_tb.v simulation/behavioral
	$(MAKE) -f system.make sim

system.make system_incl.make: genmakes.tcl system.xmp system.mhs
	xps -nw -scr genmakes.tcl

genmakes.tcl:
	echo "xload xmp system.xmp" > genmakes.tcl
	echo "xset parallel_synthesis yes" >> genmakes.tcl
	echo "exit" >> genmakes.tcl

clean: system.make
	$(MAKE) -f system.make clean
	rm -rf *.log *.make platgen.opt bootloops/ __xps _xmsgs simgen.opt etc simulation pcores genmakes.tcl

simclean: system.make
	$(MAKE) -f system.make simclean
