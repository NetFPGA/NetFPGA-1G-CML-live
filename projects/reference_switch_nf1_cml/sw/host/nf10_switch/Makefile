################################################################################
#
#  NetFPGA-1G-CML http://www.netfpga.org
#
#  File:
#        Makefile
#
#  Project:
#        reference_switch_lite_nf1_cml
#
#  Author:
#        David Van Arnem
#
#  Description:
#        make all : builds the host software
#
#  Copyright notice:
#        Copyright (C) 2013 Computer Measurement Laboratory
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
	gcc -march=core2 nf10_switch.c ../../../../../lib/sw/std/drivers/nf10_switch_v1_00_a/src/nf10_switch_lib.c reg_lib.c -I . -I ../../../../../lib/sw/std/drivers/nf10_switch_v1_00_a/src -I ../../embedded/result/microblaze_0/include -o nf10_switch

clean:
	rm -rf nf10_switch

