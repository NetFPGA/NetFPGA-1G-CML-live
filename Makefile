################################################################################
#
#  NetFPGA-10G http://www.netfpga.org
#
#  File:
#        Makefile
#
#  Description:
#        make cores : Copy Xilinx files into NetFPGA-10G library
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



NF10_SCRIPTS_DIR  = tools/scripts
XILINX_HW_LIB_DIR = $(XILINX_EDK)/hw/XilinxProcessorIPLib/pcores
XILINX_SW_LIB_DIR = $(XILINX_EDK)/sw/XilinxProcessorIPLib/drivers

NF10_HW_LIB_DIR_XILINX   = lib/hw/xilinx/pcores
HW_LIB_DIR_INSTANCES_XILINX := $(shell cd $(NF10_HW_LIB_DIR_XILINX) && find . -maxdepth 1 -type d)
HW_LIB_DIR_INSTANCES_XILINX := $(basename $(patsubst ./%,%,$(HW_LIB_DIR_INSTANCES_XILINX)))

NF10_HW_LIB_DIR_STD   = lib/hw/std/pcores
HW_LIB_DIR_INSTANCES_STD := $(shell cd $(NF10_HW_LIB_DIR_STD) && find . -maxdepth 1 -type d)
HW_LIB_DIR_INSTANCES_STD := $(basename $(patsubst ./%,%,$(HW_LIB_DIR_INSTANCES_STD)))

NF10_SW_LIB_DIR_STD   = lib/sw/std/drivers
SW_LIB_DIR_INSTANCES_STD := $(shell cd $(NF10_SW_LIB_DIR_STD) && find . -maxdepth 1 -type d)
SW_LIB_DIR_INSTANCES_STD := $(basename $(patsubst ./%,%,$(SW_LIB_DIR_INSTANCES_STD)))

NF10_HW_LIB_DIR_CONTRIB   = lib/hw/contrib/pcores
HW_LIB_DIR_INSTANCES_CONTRIB := $(shell cd $(NF10_HW_LIB_DIR_CONTRIB) && find . -maxdepth 1 -type d)
HW_LIB_DIR_INSTANCES_CONTRIB := $(basename $(patsubst ./%,%,$(HW_LIB_DIR_INSTANCES_CONTRIB)))

NF10_SW_LIB_DIR_CONTRIB   = lib/sw/contrib/drivers
SW_LIB_DIR_INSTANCES_CONTRIB := $(shell cd $(NF10_SW_LIB_DIR_CONTRIB) && find . -maxdepth 1 -type d)
SW_LIB_DIR_INSTANCES_CONTRIB := $(basename $(patsubst ./%,%,$(SW_LIB_DIR_INSTANCES_CONTRIB)))

cores: xilinx std contrib scripts
clean: xilinxclean stdclean contribclean scriptsclean

# Make only the cores used by the NF1-CML projects
# These are done separately to prevent build errors that occur when doing "make cores"
# without ISE 13.4 installed
cml_cores: scripts
	if test -f $(NF10_HW_LIB_DIR_CONTRIB)/mdio_ctrl_v1_00_a/Makefile; \
		then $(MAKE) -C $(NF10_HW_LIB_DIR_CONTRIB)/mdio_ctrl_v1_00_a; \
	fi; \
	if test -f $(NF10_HW_LIB_DIR_CONTRIB)/nf1_cml_interface_v1_00_a/Makefile; \
		then $(MAKE) -C $(NF10_HW_LIB_DIR_CONTRIB)/nf1_cml_interface_v1_00_a; \
	fi; \
	if test -f $(NF10_HW_LIB_DIR_CONTRIB)/nf10_endianess_manager_v1_00_a/Makefile; \
		then $(MAKE) -C $(NF10_HW_LIB_DIR_CONTRIB)/nf10_endianess_manager_v1_00_a; \
	fi; \
	if test -f $(NF10_HW_LIB_DIR_CONTRIB)/version_id_v1_00_a/Makefile; \
		then $(MAKE) -C $(NF10_HW_LIB_DIR_CONTRIB)/version_id_v1_00_a; \
	fi; \
	if test -f $(NF10_HW_LIB_DIR_STD)/dma_v1_20_a/Makefile; \
		then $(MAKE) -C $(NF10_HW_LIB_DIR_STD)/dma_v1_20_a; \
	fi; \
	if test -f $(NF10_HW_LIB_DIR_STD)/nf10_axis_gen_check_v1_00_a/Makefile; \
		then $(MAKE) -C $(NF10_HW_LIB_DIR_STD)/nf10_axis_gen_check_v1_00_a; \
	fi; \
	if test -f $(NF10_HW_LIB_DIR_STD)/nf10_bram_output_queues_v1_00_a/Makefile; \
		then $(MAKE) -C $(NF10_HW_LIB_DIR_STD)/nf10_bram_output_queues_v1_00_a; \
	fi; \
	if test -f $(NF10_HW_LIB_DIR_STD)/nf10_input_arbiter_v1_00_a/Makefile; \
		then $(MAKE) -C $(NF10_HW_LIB_DIR_STD)/nf10_input_arbiter_v1_00_a; \
	fi; \
	if test -f $(NF10_HW_LIB_DIR_STD)/nf10_nic_output_port_lookup_v1_00_a/Makefile; \
		then $(MAKE) -C $(NF10_HW_LIB_DIR_STD)/nf10_nic_output_port_lookup_v1_00_a; \
	fi; \
	if test -f $(NF10_HW_LIB_DIR_STD)/nf10_router_output_port_lookup_v1_00_a/Makefile; \
		then $(MAKE) -C $(NF10_HW_LIB_DIR_STD)/nf10_router_output_port_lookup_v1_00_a; \
	fi; \
	if test -f $(NF10_HW_LIB_DIR_STD)/nf10_switch_output_port_lookup_v1_00_a/Makefile; \
		then $(MAKE) -C $(NF10_HW_LIB_DIR_STD)/nf10_switch_output_port_lookup_v1_00_a; \
	fi; \
	if test -f $(NF10_HW_LIB_DIR_STD)/nf10_switch_output_prot_lookup_v1_10_a/Makefile; \
		then $(MAKE) -C $(NF10_HW_LIB_DIR_STD)/nf10_switch_output_prot_lookup_v1_10_a; \
	fi;

xilinx: check-env
	for lib in $(HW_LIB_DIR_INSTANCES_XILINX) ; do \
		if test -f $(NF10_HW_LIB_DIR_XILINX)/$$lib/Makefile; \
			then $(MAKE) -C $(NF10_HW_LIB_DIR_XILINX)/$$lib; \
		fi; \
	done;
	@echo "/////////////////////////////////////////";
	@echo "//Xilinx EDK cores installed.";
	@echo "/////////////////////////////////////////";


xilinxclean:
	for lib in $(HW_LIB_DIR_INSTANCES_XILINX) ; do \
		if test -f $(NF10_HW_LIB_DIR_XILINX)/$$lib/Makefile; \
			then $(MAKE) -C $(NF10_HW_LIB_DIR_XILINX)/$$lib clean; \
		fi; \
	done;
	@echo "/////////////////////////////////////////";
	@echo "//Xilinx EDK cores cleaned.";
	@echo "/////////////////////////////////////////";

std:
	for lib in $(HW_LIB_DIR_INSTANCES_STD) ; do \
		if test -f $(NF10_HW_LIB_DIR_STD)/$$lib/Makefile; \
			then $(MAKE) -C $(NF10_HW_LIB_DIR_STD)/$$lib; \
		fi; \
	done;
	for lib in $(SW_LIB_DIR_INSTANCES_STD) ; do \
		if test -f $(NF10_SW_LIB_DIR_STD)/$$lib/Makefile; \
			then $(MAKE) -C $(NF10_SW_LIB_DIR_STD)/$$lib; \
		fi; \
	done;
	@echo "/////////////////////////////////////////";
	@echo "//NF10 standard cores installed.";
	@echo "/////////////////////////////////////////";

stdclean:
	for lib in $(HW_LIB_DIR_INSTANCES_STD) ; do \
		if test -f $(NF10_HW_LIB_DIR_STD)/$$lib/Makefile; \
			then $(MAKE) -C $(NF10_HW_LIB_DIR_STD)/$$lib clean; \
		fi; \
	done;
	for lib in $(SW_LIB_DIR_INSTANCES_STD) ; do \
		if test -f $(NF10_SW_LIB_DIR_STD)/$$lib/Makefile; \
			then $(MAKE) -C $(NF10_SW_LIB_DIR_STD)/$$lib clean; \
		fi; \
	done;
	@echo "/////////////////////////////////////////";
	@echo "//NF10 standard cores cleaned.";
	@echo "/////////////////////////////////////////";

contrib:
	for lib in $(HW_LIB_DIR_INSTANCES_CONTRIB) ; do \
		if test -f $(NF10_HW_LIB_DIR_CONTRIB)/$$lib/Makefile; \
			then $(MAKE) -C $(NF10_HW_LIB_DIR_CONTRIB)/$$lib; \
		fi; \
	done;
	for lib in $(SW_LIB_DIR_INSTANCES_CONTRIB) ; do \
		if test -f $(NF10_SW_LIB_DIR_CONTRIB)/$$lib/Makefile; \
			then $(MAKE) -C $(NF10_SW_LIB_DIR_CONTRIB)/$$lib; \
		fi; \
	done;
	@echo "/////////////////////////////////////////";
	@echo "//NF10 contributed cores installed.";
	@echo "/////////////////////////////////////////";

contribclean:
	for lib in $(HW_LIB_DIR_INSTANCES_CONTRIB) ; do \
		if test -f $(NF10_HW_LIB_DIR_CONTRIB)/$$lib/Makefile; \
			then $(MAKE) -C $(NF10_HW_LIB_DIR_CONTRIB)/$$lib clean; \
		fi; \
	done;
	for lib in $(SW_LIB_DIR_INSTANCES_CONTRIB) ; do \
		if test -f $(NF10_SW_LIB_DIR_CONTRIB)/$$lib/Makefile; \
			then $(MAKE) -C $(NF10_SW_LIB_DIR_CONTRIB)/$$lib clean; \
		fi; \
	done;
	@echo "/////////////////////////////////////////";
	@echo "//NF10 contributed cores cleaned.";
	@echo "/////////////////////////////////////////";

scripts:
	$(MAKE) -C $(NF10_SCRIPTS_DIR)


scriptsclean:
	$(MAKE) -C $(NF10_SCRIPTS_DIR) clean

hwtestlib:
	cd tools/lib/ && make

hwtestlibclean:
	cd tools/lib/ && make clean

check-env:
ifndef XILINX_EDK
    $(error XILINX_EDK is undefined)
endif

