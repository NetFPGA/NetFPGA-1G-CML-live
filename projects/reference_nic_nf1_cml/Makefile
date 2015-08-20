################################################################################
#
#  NetFPGA-10G http://www.netfpga.org
#
#  File:
#        Makefile
#
#  Project:
#        nic
#
#  Author:
#        Mario Flajslik
#        Jay Hirata, Computer Measurement Laboratory, LLC
#
#  Description:
#        make all : Make BRAM initialized bitfile to bitfiles/
#
#        For more information about how Xilinx EDK works, please visit
#        http://www.xilinx.com/support/documentation/dt_edk.htm
#
#  Copyright notice:
#        Copyright (C) 2010, 2011 The Board of Trustees of The Leland Stanford
#                                 Junior University
#        Copyright (C) 2013, 2014 Computer Measurement Laboratory, LLC
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

SYSTEM = system
HW = hw
PROJECT_NAME = reference_nic_nf1_cml

all:
	$(MAKE) -C $(HW)
	mkdir -p bitfiles
	cp $(HW)/implementation/download.bit bitfiles/$(PROJECT_NAME).bit

download: bitfiles/$(PROJECT_NAME).bit
	cp bitfiles/$(PROJECT_NAME).bit bitfiles/download.bit
	impact -batch nf1_cml/program.bat
	rm -f bitfiles/download.bit

clean:
	$(MAKE) -C $(HW) clean
