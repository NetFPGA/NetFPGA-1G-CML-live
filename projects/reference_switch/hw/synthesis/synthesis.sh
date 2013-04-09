#!/bin/bash

rm -rf xst

echo "xst -ifn "axi_interconnect_0_wrapper_xst.scr" -intstyle silent"

echo "Running XST synthesis ..."

xst -ifn "axi_interconnect_0_wrapper_xst.scr" -intstyle silent
if [ $? -ne 0 ]; then
	exit 1
fi

echo "XST completed"

rm -rf xst

cd ../implementation/axi_interconnect_0_wrapper
mv ../axi_interconnect_0_wrapper.ngc .
ngcbuild ./axi_interconnect_0_wrapper.ngc ../axi_interconnect_0_wrapper.ngc
if [ $? -ne 0 ]; then
   exit 1
fi

cd ../../synthesis

echo "xst -ifn "system_xst.scr" -intstyle silent"

echo "Running XST synthesis ..."

xst -ifn "system_xst.scr" -intstyle silent
if [ $? -ne 0 ]; then
  exit 1
fi

echo "XST completed"

rm -rf xst
