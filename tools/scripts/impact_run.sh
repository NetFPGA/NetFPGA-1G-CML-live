#!/bin/bash

################################################################################
#
#  NetFPGA-10G http://www.netfpga.org
#
#  File:
#        impact_run.sh
#
#  Project:
#        
#
#  Module:
#        
#
#  Author:
#        Jong HAN
#
#  Description:
#        
#
#  Copyright notice:
#        Copyright (C) 2013 University of Cambridge
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

xilinxtool=`echo $XILINX`

rm -rf impact_cpld.cmd
rm -rf impact.cmd

if [ -z $xilinxtool ]; then
	echo
	echo 'Setup Xilinx tools.'
	echo
	exit 1
fi

PATH=$XILINX/bin/lin64:$XILINX/../../ISE_DS/common/bin/lin64:$PATH

export PATH

NF_DESIGN_DIR=$NF_ROOT/projects/reference_nic/

if [ "$NF_ROOT" == "" -o "$NF_DESIGN_DIR" == "" ]; then
	echo
	echo NF_ROOT or NF_DESIGN_DIR variable is not defined.
	echo
	echo NF_ROOT needs to point to the top level of the NF10 repository
	echo should it be ~/NetFPGA-10G-live \?
	echo
	exit 1
fi

if [ -z $1 ]; then
	echo
	echo 'Nothing input for bit file.'
	echo
	echo $0' <bitfile_name.bit> for loading a bit file only.' 
	echo
	echo $0' <bitfile_name.bit> <cpld.jed> for loading bit and cpld files.'
	exit 1
fi

if [ -e "$1" -a -e "$2" ]; then
	sed s:CPLDFILE_NAME_HERE:$2: <$NF_ROOT/tools/scripts/impact_fpga_cpld.cmd.template > $NF_ROOT/tools/scripts/impact_cpld.cmd
	sed s:BITFILE_NAME_HERE:$1: <$NF_ROOT/tools/scripts/impact_cpld.cmd > $NF_ROOT/tools/scripts/impact.cmd
elif [ -e "$1" -a -z "$2" ]; then
	sed s:BITFILE_NAME_HERE:$1: <$NF_ROOT/tools/scripts/impact_fpga.cmd.template > $NF_ROOT/tools/scripts/impact.cmd
else
	echo
	echo bitfile $1 not found
	echo
	exit 1 
fi

#Remove nf10 kernel driver.
nfdriver=`lsmod | grep nf10`

if [ -n "$nfdriver" ]; then
	rmmod nf10
fi

#Program FPGA
impact -batch $NF_ROOT/tools/scripts/impact.cmd

#Restore PCIe configuration
#$NF_ROOT/tools/scripts/pci_save_restore.sh restore dma
$NF_ROOT/tools/scripts/pci_rescan_run.sh

#Load nf10 kernel driver.
if [ -e $NF_DESIGN_DIR/sw/host/driver/nf10.ko ]; then
	echo "(Re)loading $NF_DESIGN_DIR/sw/host/driver/nf10.ko"
	insmod $NF_DESIGN_DIR/sw/host/driver/nf10.ko
else
	echo $0": no project specific driver found - trying reference_nic"
	if [ -e $NF_ROOT/projects/reference_nic/sw/host/driver/nf10.ko ]; then
		insmod $NF_ROOT/projects/reference_nic/sw/host/driver/nf10.ko
	else
		echo $0 failed.
		echo No reference_nic kernel driver 
		echo AND
		echo No project kernel driver
		echo
		exit 1 
	fi
fi

rm -rf impact_cpld.cmd
rm -rf impact.cmd
