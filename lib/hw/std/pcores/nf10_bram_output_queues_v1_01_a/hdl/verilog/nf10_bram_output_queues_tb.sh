################################################################################
#
#  NetFPGA-10G http://www.netfpga.org
#
#  File:
#        nf10_bram_output_queues_tb.sh
#
#  Library:
#        hw/std/pcores/nf10_bram_output_queues_v1_00_a
#
#  Module:
#        nf10_bram_output_queues_tb.bat
#
#  Author:
#        James Hongyi Zeng
#
#  Description:
#        Mark Grindell- batch file to compile the test bench for the
#                       nf10_bram_output_queues_tb module, and to
#                       check it's basic functionality
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

cd $(dirname $0)
rm -rf unittest_build
mkdir  unittest_build
cd     unittest_build
fuse -incremental -prj ../nf10_bram_output_queues_tb.prj -o nf10_bram_output_queues_tb.exe testbench
./nf10_bram_output_queues_tb.exe -tclbatch ../nf10_bram_output_queues_tb.tcl
