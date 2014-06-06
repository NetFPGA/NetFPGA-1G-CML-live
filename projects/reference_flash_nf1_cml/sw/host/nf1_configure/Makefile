################################################################################
#
#  NetFPGA-10G http://www.netfpga.org
#
#  File:
#        Makefile
#
#  Project:
#        reference_flash_nf1_cml
#
#  Author:
#        Mario Flajslik
#        David Luman
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
	gcc -o stats stats.c
	gcc -o rdaxi rdaxi.c
	gcc -o wraxi wraxi.c
	gcc -Wall -o nf1_configure nf1_configure.c bpi_axi_util.c pcie_axi_if.c icap_util.c
	gcc -Wall -o rdbpiaxi rdbpiaxi.c bpi_axi_util.c pcie_axi_if.c
	gcc -Wall -o restart_fpga restart_fpga.c bpi_axi_util.c icap_util.c pcie_axi_if.c
clean:
	rm -f stats rdaxi wraxi nf1_configure rdbpiaxi restart_fpga
