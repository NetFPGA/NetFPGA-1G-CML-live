#!/bin/bash
################################################################################
#
#  NetFPGA-10G http://www.netfpga.org
#
#  File:
#        cpld_run.sh 
#
#  Project:
#        cpld run scripts called by Makefile
#
#  Author:
#        Jong Han
#
#  Description:
#			An image file of cpld.jed file is generated for pcie programming.
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


xst -intstyle ise -ifn "./cpld.xst" -ofn "./cpld.syr" 
ngdbuild -intstyle ise -dd _ngo -uc cpld.ucf -p xc2c256-PQ208-6 cpld.ngc cpld.ngd  
cpldfit -intstyle ise -p xc2c256-6-PQ208 -ofmt vhdl -optimize density -htmlrpt -loc on -slew fast -init low -inputs 32 -pterms 28 -unused keeper -terminate keeper -iostd LVCMOS33 cpld.ngd 
XSLTProcess cpld_build.xml 
tsim -intstyle ise cpld cpld.nga 
hprep6 -s IEEE1149 -i cpld 

