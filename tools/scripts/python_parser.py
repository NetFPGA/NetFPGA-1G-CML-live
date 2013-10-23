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

input_file = open("reg_defines.h", "r")
output_file = open("reg_defines.py", "w")
output_file.write("#!/usr/bin/python")
for line in input_file:
    match_defines = re.match(r'\s*#define ([a-zA-Z_0-9]+) (.*)', line)
    match_comments = re.match(r'\s*[/\*][\s*\*](.*)', line)
 	
    if match_defines:
        newline1= "\ndef %s():\n    return %s" % (match_defines.group(1),match_defines.group(2))
	output_file.write(newline1)

    elif match_comments:
	newline2= "\n# %s" % (match_comments.group(1))
        output_file.write(newline2)

    else:
        output_file.write(line)


