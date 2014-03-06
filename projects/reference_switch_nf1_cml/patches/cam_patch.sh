#!/bin/bash

patch ../implement/CustomizeWrapper.pl CustomizeWrapper.pl.patch
patch ../implement/vhdl_xst.scr vhdl_xst.scr.patch
patch ../src/vhdl/cam_pkg.vhd cam_pkg.vhd.patch
patch ../src/vhdl/cam_control.vhd cam_control.vhd.patch
patch ../src/vhdl/cam_mem_blk.vhd cam_mem_blk.vhd.patch
patch ../src/vhdl/cam_mem_blk_extdepth_prim.vhd cam_mem_blk_extdepth_prim.vhd.patch
patch ../src/vhdl/cam_rtl.vhd cam_rtl.vhd.patch
