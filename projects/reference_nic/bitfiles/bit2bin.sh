#!/bin/bash
###############################################################################
#
#  NetFPGA-10G http://www.netfpga.org
#
#  File:
#        bit2bin.sh
#
#  Project:
#        reference_nic
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

promgen -c -u 0 $1 -p bin -w -data_width 8 -s 8192  
