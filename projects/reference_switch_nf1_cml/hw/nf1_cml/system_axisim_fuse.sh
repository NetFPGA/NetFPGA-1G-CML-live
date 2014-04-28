#!/bin/sh
#  Simulation Model Generator
#  Xilinx EDK 14.6 EDK_P.68d
#  Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.
#
#  File     system_axisim_fuse.sh (Tue Apr 15 16:45:44 2014)
#
#  ISE Simulator Fuse Script File
#
#  The Fuse script compiles and generates an ISE simulator
#  executable named isim_system_axisim that is used to run your
#  simulation. To run a simulation in command line mode,
#  perform the following steps:
#
#  1. Run the ISE Simulator Fuse script file
#     source system_axisim_fuse.sh
#  2. Use a text editor to modify the signal wave files,
#     which have the file name <module>_wave.tcl
#  3. Launch the simulator using the following command:
#     isim_system_axisim -gui -tclbatch system_axisim_setup.tcl
#
fuse -incremental work.system_axisim_tb work.glbl -prj system_axisim.prj -L nf10_axis_conferter_v1_00_a -L nf10_proc_common_v1_00_a -L xilinxcorelib_ver -L secureip -L unisims_ver -L unimacro_ver  -o isim_system_axisim
