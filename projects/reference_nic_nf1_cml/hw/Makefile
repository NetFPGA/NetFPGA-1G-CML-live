################################################################################
#
#  NetFPGA-1G-CML https://github.com/cmlab/netfpga-1g-cml
#
#  File:
#        HW Makefile
#
#  Project:
#        reference_nic_nf1_cml
#
#  Author:
#        Jack Meador
#        David Van Arnem
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

-include system_incl.make

GIT_COMMIT = $(shell git log --abbrev=8 -1 --pretty=format:"%h")
PROJECT_NAME = reference_nic_nf1_cml

SYSTEM_FUSE = sh system_fuse.sh
AXISIM_FUSE = sh system_axisim_fuse.sh

AXISIM_MHS = $(patsubst %.mhs, %_axisim.mhs, $(MHSFILE))
AXISIM_CMD = $(patsubst %_system, %_system_axisim, $(SIM_CMD))
AXISIM_EXE = ./isim_system_axisim

PATH := $(PATH):$(PYTHONPATH)

# Default Packet length for run.py
PKTLEN = 16
PKTNO = 2 

init_bram: bits
	$(MAKE) -f system.make init_bram

bits: system.make
	$(MAKE) -f system.make bits

exporttosdk: system.make
	$(MAKE) -f system.make exporttosdk

axi_model: system.make $(BRAMINIT_ELF_SIM_FILES)
	@echo "*********************************************"
	@echo "Creating AXI simulation models..."
	@echo "*********************************************"
	$(NF_ROOT)/tools/scripts/nf1_cml_sim_autosubst.py -i $(MHSFILE) -o $(AXISIM_MHS)
	simgen $(SIMGEN_OPTIONS) -m behavioral $(AXISIM_MHS)

test:
	echo $(PROJECT_SEARCHPATHOPT)

regs:
	psf2Edward -inp $(SYSTEM).xmp -exit_on_error -edwver 1.2 -xml $(SDK_EXPORT_DIR)/$(SYSTEM).xml $(GLOBAL_SEARCHPATHOPT)
	appguru -hw $(SDK_EXPORT_DIR)/$(SYSTEM).xml -app empty_application $(PROJECT_SEARCHPATHOPT)../sw/ -od $(SDK_EXPORT_DIR)/../empty_application
	@mkdir -p $(SDK_EXPORT_DIR)/../libs
	libgen -mhs $(MHSFILE) -p $(DEVICE) $(PROJECT_SEARCHPATHOPT) $(PROJECT_SEARCHPATHOPT)../sw/ -lib -od $(SDK_EXPORT_DIR)/../libs $(SDK_EXPORT_DIR)/../empty_application/$(SYSTEM).mss
	@mkdir -p $(SDK_EXPORT_DIR)/../../../host/include/
	@cp -rf $(SDK_EXPORT_DIR)/../libs/microblaze_0/include/* $(SDK_EXPORT_DIR)/../../../host/include/
	@cp -rf $(SDK_EXPORT_DIR)/../libs/microblaze_0/libsrc $(SDK_EXPORT_DIR)/../../../host/include/
	@rm -rf $(SDK_EXPORT_DIR)/../empty_application
	@rm -rf $(SDK_EXPORT_DIR)/../libs
	cd ../sw/host/include/  && cp ../../../../../tools/scripts/xparam2regdefines.py . && python xparam2regdefines.py
	cd ../sw/host/include/  && rm -f xparam2regdefines.py && mv reg_defines.h ../
	cd ../sw/host && cp ../../../../tools/scripts/python_parser.py . && python python_parser.py
	cd ../sw/host && rm -f python_parser.py && mv reg_defines.py ../../lib/Python/reg_defines_reference_nic_nf1_cml.py 

sim: axi_model regs
	./../test/$(TESTNAME)/run.py
	cp nf1_cml/system_axisim_tb.v simulation/behavioral
	cp nf1_cml/system_axisim_fuse.sh simulation/behavioral
	cd simulation/behavioral && $(AXISIM_FUSE)
	cd simulation/behavioral && $(AXISIM_CMD) -tclbatch ../../nf1_cml/noninteractive_sim.tcl
	$(NF_ROOT)/tools/scripts/nf10_sim_reconcile_axi_logs.py
	$(NF_ROOT)/tools/scripts/nf10_sim_registers_axi_logs.py

simgui: axi_model regs
	./../test/$(TESTNAME)/run.py
	cp nf1_cml/system_axisim_tb.v simulation/behavioral
	cp nf1_cml/system_axisim_fuse.sh simulation/behavioral
	cd simulation/behavioral && $(AXISIM_FUSE)
	cd simulation/behavioral && $(AXISIM_CMD) -gui -tclbatch system_axisim_setup.tcl
	$(NF_ROOT)/tools/scripts/nf10_sim_reconcile_axi_logs.py
	$(NF_ROOT)/tools/scripts/nf10_sim_registers_axi_logs.py

simtx: checkpktlen axi_model
	./../test/$(TESTNAME)/run.py --packet_length $(PKTLEN) --packet_no $(PKTNO)
	cp nf1_cml/system_axisim_tx_tb.v simulation/behavioral/system_axisim_tb.v
	cp nf1_cml/system_axisim_fuse.sh simulation/behavioral
	cd simulation/behavioral && $(AXISIM_FUSE)
	cd simulation/behavioral && $(AXISIM_EXE) -tclbatch ../../nf1_cml/noninteractive_sim.tcl

simtxgui: checkpktlen axi_model
	./../test/$(TESTNAME)/run.py --packet_length $(PKTLEN) --packet_no $(PKTNO)
	@echo "" > nf1_cml_interface_0_stim.axi
	@echo "" > nf1_cml_interface_1_stim.axi
	@echo "" > nf1_cml_interface_2_stim.axi
	@echo "" > nf1_cml_interface_3_stim.axi
	cp nf1_cml/system_axisim_tx_tb.v simulation/behavioral/system_axisim_tb.v
	cp nf1_cml/system_axisim_fuse.sh simulation/behavioral
	cd simulation/behavioral && $(AXISIM_FUSE)
	cd simulation/behavioral && $(AXISIM_EXE) -gui -tclbatch system_axisim_setup.tcl

simrx: checkpktlen axi_model
	./../test/$(TESTNAME)/run.py --packet_length $(PKTLEN) --packet_no $(PKTNO)
	@echo "" > dma_0_stim.axi
	cp nf1_cml/system_axisim_rx_tb.v simulation/behavioral/system_axisim_tb.v
	cp nf1_cml/system_axisim_fuse.sh simulation/behavioral
	cd simulation/behavioral && $(AXISIM_FUSE)
	cd simulation/behavioral && $(AXISIM_EXE) -tclbatch ../../nf1_cml/noninteractive_sim.tcl

simrxgui: checkpktlen axi_model
	./../test/$(TESTNAME)/run.py --packet_length $(PKTLEN) --packet_no $(PKTNO)
	@echo "" > dma_0_stim.axi
	cp nf1_cml/system_axisim_rx_tb.v simulation/behavioral/system_axisim_tb.v
	cp nf1_cml/system_axisim_fuse.sh simulation/behavioral
	cd simulation/behavioral && $(AXISIM_FUSE)
	cd simulation/behavioral && $(AXISIM_EXE) -gui -tclbatch system_axisim_setup.tcl

simtxrx: checkpktlen axi_model
	./../test/$(TESTNAME)/run.py --packet_length $(PKTLEN) --packet_no $(PKTNO)
	@echo "" > nf1_cml_interface_0_stim.axi
	@echo "" > nf1_cml_interface_1_stim.axi
	@echo "" > nf1_cml_interface_2_stim.axi
	@echo "" > nf1_cml_interface_3_stim.axi
	cp nf1_cml/system_axisim_txrx_tb.v simulation/behavioral/system_axisim_tb.v
	cp nf1_cml/system_axisim_fuse.sh simulation/behavioral
	cd simulation/behavioral && $(AXISIM_FUSE)
	cd simulation/behavioral && $(AXISIM_EXE) -tclbatch ../../nf1_cml/noninteractive_sim.tcl

simtxrxgui: checkpktlen axi_model
	./../test/$(TESTNAME)/run.py --packet_length $(PKTLEN) --packet_no $(PKTNO)
	@echo "" > nf10_10g_interface_0_stim.axi
	@echo "" > nf10_10g_interface_1_stim.axi
	@echo "" > nf10_10g_interface_2_stim.axi
	@echo "" > nf10_10g_interface_3_stim.axi
	cp nf1_cml/system_axisim_txrx_tb.v simulation/behavioral/system_axisim_tb.v
	cp nf1_cml/system_axisim_fuse.sh simulation/behavioral
	cd simulation/behavioral && $(AXISIM_FUSE)
	cd simulation/behavioral && $(AXISIM_EXE) -gui -tclbatch system_axisim_setup.tcl

checkpktlen: 
	@if [ "$(PKTLEN)" = "" ]; then echo "Please follow command line './make simrxgui PKTLEN=10 PKTLNO=2'"; fi
	@echo "Run with default packet payload length and no! $(PKTLETN) $(PKTNO)"

system.make system_incl.make: rom_data.txt
	echo exit|xps -nw system.xmp

#################################################################
# Identification information added. 
##################################################################
rom_data.txt:
	sh ../../../tools/scripts/epoch.sh
	echo 16028001 >> rom_data.txt
	echo `../../../run_tag.sh` >> rom_data.txt
	echo 0000030f >> rom_data.txt
	echo 00000000 >> rom_data.txt
	echo 00000000 >> rom_data.txt
	echo 00000000 >> rom_data.txt
	echo 00000000 >> rom_data.txt
	echo 00000000 >> rom_data.txt
	echo 00000000 >> rom_data.txt
	echo 00000000 >> rom_data.txt
	echo 00000000 >> rom_data.txt
	echo 00000000 >> rom_data.txt
	echo 00000000 >> rom_data.txt
	echo 00000000 >> rom_data.txt

clean: hwclean regsclean simclean
	rm -f _impact.cmd
	rm -rf __xps
	rm -rf blockdiagram
	rm -rf bootloops
	rm -rf etc
	rm -f *.opt
	rm -f *.log
	rm -f *.make
	rm -f system.mss

hwclean: netlistclean bitsclean
	rm -rf implementation synthesis xst hdl
	rm -rf xst.srp $(SYSTEM).srp
	rm -f __xps/ise/_xmsgs/bitinit.xmsgs

netlistclean:
	rm -f $(POSTSYN_NETLIST)
	rm -f platgen.log
	rm -f __xps/ise/_xmsgs/platgen.xmsgs
	rm -f $(BMM_FILE)

bitsclean:
	rm -f $(SYSTEM_BIT)
	rm -f implementation/$(SYSTEM).ncd
	rm -f implementation/$(SYSTEM)_bd.bmm
	rm -f implementation/$(SYSTEM)_map.ncd
	rm -f implementation/download.bit
	rm -f __xps/$(SYSTEM)_routed

regsclean:
	rm -rf $(SDK_EXPORT_DIR)/../../../host/include/
	rm -f $(SDK_EXPORT_DIR)/../../../host/reg_defines.h
	rm -f ../lib/Python/reg_defines_*.*

simclean:
	rm -rf simulation
	rm -rf *[0-9]_{stim,expected,log}.axi $(AXISIM_MHS)
	rm -f simgen.log
	rm -rf __xps
	rm -f *.axi
	rm -f portconfig.sim
	rm -f seed
	rm -rf bootloops
	rm -rf etc
	rm -f *.opt
	rm -f *.log
	rm -f *.make
	rm -rf ../test/nf1_cml
	rm -rf ../test/pcores
	rm -f ../test/Makefile
	rm -f ../test/*.mhs
	rm -f ../test/system.xmp
	rm -rf ../test/data
	rm -rf ../test/etc
	rm -rf ../test/*.log
	rm -rf ../test/simulation
	rm -rf ../test/*.make
	rm -rf ../test/__xps
	rm -rf ../test/*.opt
	rm -rf ../test/bootloops
	rm -rf ../test/*.axi
	rm -rf ../test/seed
	rm -rf ../test/*.sim

smallbits.mcs: implementation/system.ncd
	cd implementation/ && bitgen -w -g USR_ACCESS:$(GIT_COMMIT) -g UserID:$(GIT_COMMIT) -g StartupClk:Cclk -g Compress -g ConfigRate:3 -g BPI_sync_mode:Type2 -g ExtMasterCclk_en:div-1 -g BPI_1st_read_cycle:1 -g BPI_page_size:1 system.ncd smallbits.bit
	cd implementation/ && promgen -w -p mcs -c FF -bpi_dc parallel -data_width 16 -o smallbits.mcs -s 131072 -u 00000000 smallbits.bit
	cp implementation/smallbits.mcs .

bin: init_bram
	cd implementation/ && impact -batch ../create_bin.cmd

progflash: smallbits.mcs
	impact -batch program_flash.cmd

$(MICROBLAZE_0_BOOTLOOP): $(MICROBLAZE_BOOTLOOP_LE)
	mkdir -p $(BOOTLOOP_DIR)
	cp -f $(MICROBLAZE_BOOTLOOP_LE) $(MICROBLAZE_0_BOOTLOOP)
