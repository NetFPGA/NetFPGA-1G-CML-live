################################################################################
#
#  NetFPGA-10G http://www.netfpga.org
#
#  File:
#        Makefile
#
#  Project:
#        nic
#
#  Author:
#        Mario Flajslik
#        Jong Hun Han
#
#  Description:
#        make : Make example applications to read stats and read/write AXI
#               registers
#
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

all:
	gcc -march=core2 -o stats stats.c
	gcc -march=core2 -o rdaxi rdaxi.c
	gcc -march=core2 -o wraxi wraxi.c
	gcc -march=core2 -o netfpga10g_ver netfpga10g_ver.c
	gcc -march=core2 -o ael2005_conf ael2005_conf.c

clean:
	rm stats rdaxi wraxi netfpga10g_ver ael2005_conf
