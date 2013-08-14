#!/bin/bash

################################################################################
#
#  NetFPGA-10G http://www.netfpga.org
#
#  File:
#        planahead_run.sh
#
#  Author:
#        Jong HAN
#  
#  Date : 30 April 2013
#
#  Description:
#        This script runs planAhead for map and par after completing synthesis
#        a module modified.
#        This script can be run only after succeeding 'make' generating bit file. 
#
#
###############################################################################


rm -rf planAhead.*
rm -rf system/system.*
rm -rf system
rm -rf .Xilinx*
rm -rf hw/__xps
rm -rf hw/synthesis/_xmsgs

xilinxtool=`echo $XILINX`

if [ -z $xilinxtool ]; then
	echo
	echo 'Setup Xilinx tools.'
	echo
	exit 1
fi

if [ -z $1 ]; then
	echo
	echo 'Run ./planahead_run.sh <instantiation_module_nam> '
	echo
	exit 1
fi

cd ./hw/synthesis

if [ ! -f $1_wrapper_xst.scr ]; then
	if [ ! -f $1_*_wrapper_xst.scr ]; then
		echo 
		echo 'There is no $1 module'
		echo
		exit 1
	fi
fi

if [ $1 = "nf10_10g_interface" ]; then
	for num in 0 1 2 3; do
		xst -ifn $1_${num}_wrapper_xst.scr
		cd ../implementation/$1_${num}_wrapper
		ngcbuild -p xc5vtx240tff1759-2 -intstyle \
			silent -i -sd .. $1_${num}_wrapper.ngc ../$1_${num}_wrapper
		cd ../../synthesis
	done
else
	xst -ifn $1_wrapper_xst.scr
	cd ../implementation/$1_wrapper
	ngcbuild -p xc5vtx240tff1759-2 -intstyle silent -i -sd .. $1_wrapper.ngc ../$1_wrapper
	cd ../../synthesis
fi

cd ../implementation

\cp ./dma_0_wrapper/dma_0_wrapper.ngc ./

# Fine ngc file list in the implementation directory.
listngc=`ls -x *.ngc`

echo $listngc

echo ${#listngc}

dirlistngc=`echo $listngc | sed 's/.ngc//g'`

echo $dirlistngc

addfile="./hw/implementation/system.ngc"

for dirngc in $dirlistngc; do
	findsamengc=`echo $addfile | grep ${dirngc}.ngc | wc -l`
	if [ $findsamengc -eq 0 ]; then
		addfile="${addfile} ./hw/implementation/${dirngc}.ngc"
	fi
done

cd ./../..

echo Current directory

pwd

addfile="{${addfile} ./hw/implementation/dma_0_wrapper/dma_engine.edf}"

echo $addfile

echo "$addfile" > addfile.txt

sed 's/ //g' addfile.txt > addfile_temp.txt

addfile=`cat addfile_temp.txt`

echo $addfile

sed s:NGCFILELIST:$addfile: <planahead.temp.tcl > planahead.tcl.temp

sed 's/ngc/& /g' planahead.tcl.temp > planahead.tcl

planAhead -mode batch -source planahead.tcl

cd ./system/system.runs/impl_1

if [ ! -f system_routed.ncd ]; then
	echo
	echo 'Error no ncd file'
	echo
	echo 'Remove all PlanAhead projects and run it again'
	echo
	exit 1
fi

\cp ../../../hw/implementation/bitgen.ut .

bitgen -w -f bitgen.ut system_routed

\cp system_routed.bit ../../../sw/embedded/SDK_Workspace/hw/system.bit

cd ../../../sw/embedded

data2mem -bm SDK_Workspace/hw/system_bd.bmm \
   	-bt SDK_Workspace/hw/system.bit \
	   -bd result/hello_world_0.elf\
   	tag microblaze_0 \
   	-o b result/download.bit

\cp ./result/download.bit ../../bitfiles/download_pr.bit


