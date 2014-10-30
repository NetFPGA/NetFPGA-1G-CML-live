#!/usr/bin/python

################################################################################
#
#  NetFPGA-10G http://www.netfpga.org
#
#  File:
#        xparam2regdefines.py
#
#  Project:
#        
#
#  Module:
#        
#
#  Author:
#        Neelakandan Manihatty Bojan
#
#  Description:
#        This is used to convert xparameters.h to reg_defines.h
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
import re

input_file = open("xparameters.h", "r")
output_file = open("reg_defines.h", "w")
baseaddr = 0
baseaddr_int = 0
offset_int =0

for line in input_file:
    match_baseaddr = re.match(r'\s*#define .*_BASEADDR (0x[a-zA-Z_0-9]{8})', line)
    match_offset = re.match(r'\s*#define (.*)_OFFSET (0x[a-zA-Z_0-9]+)', line)
 	
    if match_baseaddr:
        baseaddr = match_baseaddr.group(1)
	baseaddr_int= int(baseaddr,16)	
        output_file.write(line)

    elif match_offset:
	offset = match_offset.group(2)
	offset_int=int(offset,16)
        new_val = hex(baseaddr_int+offset_int)     
	newline= "#define %s %s\n" % (match_offset.group(1),new_val)
        output_file.write(newline)

    else:
        output_file.write(line)


