#!/bin/sh
#  Simulation Model Generator
#  Xilinx EDK 13.4 EDK_O.87xd
#  Copyright (c) 1995-2011 Xilinx, Inc.  All rights reserved.
#
#  File     system_axisim_fuse.sh (Tue Jun 25 15:02:27 2013)
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
fuse -incremental work.system_axisim_tb work.glbl -prj system_axisim.prj -L xilinxcorelib_ver -L secureip -L unisims_ver -L nf10_proc_common_v1_00_a -L nf10_axis_converter_v1_00_a -o isim_system_axisim
