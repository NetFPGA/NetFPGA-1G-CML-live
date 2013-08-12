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

import glob
import os
import sys
import csv, collections
import re

script_dir = os.path.dirname( sys.argv[0] )
# Add path *relative to this script's location* of axitools module
sys.path.append( os.path.join( script_dir, '..','..','..','..','tools','scripts' ) )

import axitools

REG_STIM     = 'reg_stim.log'    

def main():
    fail = False
    reg_stim = '%s' % (REG_STIM)
    print 'Count registers'
    with open( reg_stim ) as output:
      	f = output.readlines()    	
	#w = ord('<') # chr(60)
	#r = ord('>') # chr(62)
	a = 0
	b = 0

	for line in f:
	    #if 'OKAY' in line:
		if '<' in line:
		    a = a + 1 # write
		elif '>' in line:
		    b = b + 1 # read
		else:
		    a = a
		    b = b
#	for line in f:
#	    if '<' in line:
#		if 'OKAY' in line:
#	    	    a = a + 1 # write
#	for line in f:
#	    if '>' in line:
#		if 'OKAY' in line: 	
#	    	    b = b + 1 # read
	if a == b:
	    #for line in f:
		#if 'OKAY' in line:
	    print '\tPASS (%d registers written, %d registers read)' % (a, b)
	elif a > b:
	    print '\tFAIL (%d registers written but only %d registers read)' % (a, b)
	else:
	    print '\tFAIL (%d registers written but %d registers read)' % (a, b)
    print
    return 0

if __name__ == '__main__':
    main()
