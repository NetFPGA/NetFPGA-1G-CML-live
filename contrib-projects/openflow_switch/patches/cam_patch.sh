#!/bin/bash

################################################################################
#
#  NetFPGA-1G-CML http://www.netfpga.org
#
#  File:
#       cam_patch.sh
#
#  Project:
#       reference_switch__nf1_cml
#
#  Author:
#       David Van Arnem
#
#  Description:
#       This script automates the process to patch Xilinx's XAPP1151 reference
#       design files so the CAM can be generated for the Kintex-7 on the 
#       NetFPGA-1G-CML.
#
#       Copy this folder to the base directory of Xilinx's XAPP1151 reference
#       design files.  Then:
#
#           $ sh cam_patch.sh
#
#  Copyright notice:
#       Copyright (C) 2014 Computer Measurement Laboratory
#
#  Licence:
#       This file is part of the NetFPGA 10G development base package.
#
#       This file is free code: you can redistribute it and/or modify it under
#       the terms of the GNU Lesser General Public License version 2.1 as
#       published by the Free Software Foundation.
#
#       This package is distributed in the hope that it will be useful, but
#       WITHOUT ANY WARRANTY; without even the implied warranty of
#       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#       Lesser General Public License for more details.
#
#       You should have received a copy of the GNU Lesser General Public
#       License along with the NetFPGA source package.  If not, see
#       http://www.gnu.org/licenses/.
#
#

patch implement/CustomizeWrapper.pl CustomizeWrapper.pl.patch
patch implement/vhdl_xst.scr vhdl_xst.scr.patch
patch src/vhdl/cam_pkg.vhd cam_pkg.vhd.patch
patch src/vhdl/cam_control.vhd cam_control.vhd.patch
patch src/vhdl/cam_mem_blk.vhd cam_mem_blk.vhd.patch
patch src/vhdl/cam_mem_blk_extdepth_prim.vhd cam_mem_blk_extdepth_prim.vhd.patch
patch src/vhdl/cam_rtl.vhd cam_rtl.vhd.patch
