#!/usr/bin/env python

################################################################################
#
#  NetFPGA-10G http://www.netfpga.org
#
#  File:
#        nf10_sim_registers_axi_logs.py
#
#  Author:
#        Georgina Kalogeridou
#
# Copyright notice:
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

from __future__ import with_statement
from __future__ import generators

import glob
import os
import sys
import csv, collections
import re

REG_STIM     = 'reg_stim.log'    
REG_EXPECT   = 'reg_expect.axi'

def expected():
    i = 0
    with open(REG_EXPECT) as f:
        for line in f.readlines():
            i = i + 1
    return i

def main():
    reg_stim = '%s' % (REG_STIM)
    print 'Check registers'
    with open( reg_stim ) as output:
      	f = output.readlines()    	
	a = 0
	b = 0
 	c = 0
	d = 0
	e = 0 
        lines = 0

	for line in f:
	    lines = lines + 1
	    if 'Error' in line:
		e = 1
		if '<' in line: 
		    c = c + 1 # write
		elif '>' in line:
		    d = d + 1 # read
		else:
		    c = c
		    d = d

	    elif 'WARNING' in line:
		e = 2	   

	    else:
		if '<' in line:
		    a = a + 1 # write
		elif '>' in line:
		    b = b + 1 # read
		else:
		    a = a
		    b = b		

	if e == 1:	
	    print '\tFAIL ( Check reg_stim.log file!!!! )'
	elif e == 2:
	    print '\tPASS ( WARNING! Check reg_stim.log file!!!! )'
	elif lines == 0 and expected() != 0:
	    print '\tFAIL ( Did not get any results! )'
	else:
	    print '\tPASS'

    print
    return 0

if __name__ == '__main__':
    main()
