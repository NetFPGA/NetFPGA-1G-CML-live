#!/bin/bash

################################################################################
#
#  NetFPGA-10G http://www.netfpga.org
#
#  File:
#        pcie_rescan_run.sh
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

PcieBusPath=/sys/bus/pci/devices
PcieDeviceList=`ls /sys/bus/pci/devices/`

for BusNo in $PcieDeviceList
do	
	VenderId=`cat $PcieBusPath/$BusNo/device`
	if [ "$VenderId" = "0x4244" ]; then
		echo 1 > /sys/bus/pci/devices/$BusNo/remove
		sleep 1
		echo 1 > /sys/bus/pci/rescan
		echo
		echo "Completed rescan PCIe information !"
		echo "Load nf10.ko kernerl driver!"
		echo
		exit 1
	fi
done

echo "Check programming FPGA or Reboot machine !"


