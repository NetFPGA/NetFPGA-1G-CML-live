################################################################################
#
#  NetFPGA-1G-CML https://github.com/cmlab/netfpga-1g-cml
#
#  File:
#        create_bin.cmd
#
#  Project:
#        reference_flash_nf1_cml
#
#  Author:
#        David Luman
#
#  Description:
#        This is a script for the Xilinx impact tool. It is used to
#        convert the download.bit file to a .bin that is suitable for use
#        with the BPI-Flash programmer.
#
#  Copyright notice:
#        Copyright (C) 2014 Computer Measurement Laboratory, LLC
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

setMode -pff
setSubmode -pffbpi
addConfigDevice  -name "reference_nic_nf1_cml" -path "../../bitfiles"
addDesign -version 0 -name "0"
setCurrentDesign -version 0
addDeviceChain -index 0
addPromDevice -p 1 -size 131072 -name 128M
addDevice -p 1 -file "download.bit"
setAttribute -configdevice -attr multibootBpiType -value "TYPE_BPI"
setAttribute -configdevice -attr multibootBpichainType -value "PARALLEL"
setAttribute -configdevice -attr compressed -value "FALSE"
setAttribute -configdevice -attr compressed -value "FALSE"
setAttribute -configdevice -attr autoSize -value "FALSE"
setAttribute -configdevice -attr fileFormat -value "bin"
setAttribute -configdevice -attr fillValue -value "FF"
setAttribute -configdevice -attr swapBit -value "TRUE"
setAttribute -configdevice -attr dir -value "UP"
setAttribute -configdevice -attr multiboot -value "FALSE"
setAttribute -configdevice -attr multiboot -value "FALSE"
setAttribute -configdevice -attr spiSelected -value "FALSE"
setAttribute -configdevice -attr spiSelected -value "FALSE"
setAttribute -configdevice -attr ironhorsename -value "1"
setAttribute -configdevice -attr flashDataWidth -value "16"
setAttribute -configdevice -attr swapBit -value "TRUE"
setAttribute -design -attr RSPin -value ""
setAttribute -design -attr RSPin -value "00"
setAttribute -design -attr RSPinMsb -value "1"
setAttribute -design -attr name -value "0"
setAttribute -design -attr RSPin -value "00"
setAttribute -design -attr endAddress -value "ae9d9b"
generate
quit
