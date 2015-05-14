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
#        Copyright (C) 2014, 2015 Computer Measurement Laboratory
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

DEPS = system.mhs system.xmp data/system.ucf

.PHONY: prep swprep hw clean

hw: prep
	$(MAKE) -f system.make bits

prep: system.make

swprep: prep
	$(MAKE) -f system.make exporttosdk

system.make: $(DEPS)
	echo "exit" | xps -nw system.xmp


clean: prep
	$(MAKE) -f system.make clean
	rm -rf \
			SDK/ \
			__xps/ \
			_impactbatch.log \
			bitinit.log \
			bootloops/ \
			clock_generator_0.log \
			etc/system.filters \
			etc/system.gui \
			platgen.opt \
			psf2Edward.log \
			system.bsb \
			system.log \
			system.make \
			system_incl.make \
			xdsgen.log

