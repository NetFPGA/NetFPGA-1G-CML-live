################################################################################
#
#  NetFPGA-1G-CML http://www.netfpga.org
#
#  File:
#        HW Makefile
#
#  Project:
#        reference_switch_lite_nf1_cml
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
#        This file is part of the NetFPGA-10G development base package.
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

include system_incl.make

GIT_COMMIT = $(shell git log --abbrev=8 -1 --pretty=format:"%h")
PROJECT_NAME = reference_router_nf1_cml

bits: system.make
	$(MAKE) -f system.make bits

exporttosdk: system.make
	$(MAKE) -f system.make exporttosdk

sim: system.make
	mkdir -p simulation/behavioral
	cp nf7/system_tb.v simulation/behavioral
	$(MAKE) -f system.make sim

system.make system_incl.make: genmakes.tcl system.xmp system.mhs
	xps -nw -scr genmakes.tcl

genmakes.tcl:
	echo "xload xmp system.xmp" > genmakes.tcl
	echo "exit" >> genmakes.tcl

clean: system.make
	$(MAKE) -f system.make clean
	rm -rf *.log *.make platgen.opt bootloops/ __xps _xmsgs simgen.opt etc simulation pcores genmakes.tcl smallbits.mcs

simclean: system.make
	$(MAKE) -f system.make simclean

smallbits.mcs: implementation/system.ncd
	cd implementation/ && bitgen -w -g USR_ACCESS:$(GIT_COMMIT) -g UserID:$(GIT_COMMIT) -g StartupClk:Cclk -g Compress -g ConfigRate:3 -g BPI_sync_mode:Type2 -g ExtMasterCclk_en:div-1 -g BPI_1st_read_cycle:1 -g BPI_page_size:1 system.ncd smallbits.bit
	cd implementation/ && promgen -w -p mcs -c FF -bpi_dc parallel -data_width 16 -o smallbits.mcs -s 131072 -u 00000000 smallbits.bit
	cp implementation/smallbits.mcs .

progflash: smallbits.mcs
	impact -batch program_flash.cmd

regsclean:
	rm -rf $(SDK_EXPORT_DIR)/../../../host/include/
	rm -rf $(SDK_EXPORT_DIR)/../../../host/reg_defines.h
	rm -rf ../lib/Python/reg_defines_*.*

regs:  
	psf2Edward -inp $(SYSTEM).xmp -exit_on_error -edwver 1.2 -xml $(SDK_EXPORT_DIR)/$(SYSTEM).xml $(GLOBAL_SEARCHPATHOPT)
	appguru -hw $(SDK_EXPORT_DIR)/$(SYSTEM).xml -app empty_application $(PROJECT_SEARCHPATHOPT)../../../lib/sw/ -od $(SDK_EXPORT_DIR)/../empty_application
	@mkdir -p $(SDK_EXPORT_DIR)/../libs
	libgen -mhs $(MHSFILE) -p $(DEVICE) $(PROJECT_SEARCHPATHOPT) $(PROJECT_SEARCHPATHOPT)../../../lib/sw/ -lib -od $(SDK_EXPORT_DIR)/../libs $(SDK_EXPORT_DIR)/../empty_application/$(SYSTEM).mss
	@mkdir -p $(SDK_EXPORT_DIR)/../../../host/include/
	@cp -rf $(SDK_EXPORT_DIR)/../libs/microblaze_0/include/* $(SDK_EXPORT_DIR)/../../../host/include/
	@cp -rf $(SDK_EXPORT_DIR)/../libs/microblaze_0/libsrc $(SDK_EXPORT_DIR)/../../../host/include/
	@rm -rf $(SDK_EXPORT_DIR)/../empty_application
	@rm -rf $(SDK_EXPORT_DIR)/../libs
	cd ../sw/host/include/  && cp ../../../../../tools/scripts/xparam2regdefines.py . && python xparam2regdefines.py
	cd ../sw/host/include/  && rm -f xparam2regdefines.py && mv reg_defines.h ../
	cd ../sw/host && cp ../../../../tools/scripts/python_parser.py . && python python_parser.py
	cd ../sw/host && rm -f python_parser.py && mv reg_defines.py ../../lib/Python/reg_defines_$(PROJECT_NAME).py

#system_incl.make:
#	@echo exit|xps -nw system.xmp
