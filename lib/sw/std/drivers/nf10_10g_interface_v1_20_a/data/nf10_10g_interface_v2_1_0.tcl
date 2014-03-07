################################################################################
#
#  NetFPGA-10G http://www.netfpga.org
#
#  File:
#        nf10_10g_interface_v2_1_0.tcl
#
#  Library:
#        std/pcores/nf10_10g_interface_v1_20_a
#
#  Author:
#        Neelakandan Manihatty Bojan
#
#  Description:
#        Driver TCL script
#
#  Copyright notice:
#        Copyright (C) 2013 University of Cambridge
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


proc generate {drv_handle} {
    #---------------------------
    # #defines in xparameters.h
    #---------------------------
    xdefine_include_file $drv_handle "xparameters.h" "NF10_10G_INTERFACE" "C_BASEADDR" "C_HIGHADDR" "RESET_CNTRS_OFFSET" "BAD_FRAMES_COUNTER_OFFSET" "GOOD_FRAMES_COUNTER_OFFSET" "BYTES_FROM_MAC_OFFSET" "RX_ENQUEUED_PKTS_OFFSET" "RX_ENQUEUED_BYTES_OFFSET" "RX_DEQUEUED_PKTS_OFFSET" "RX_DEQUEUED_BYTES_OFFSET" "TX_ENQUEUED_PKTS_OFFSET" "TX_ENQUEUED_BYTES_OFFSET" "TX_DEQUEUED_PKTS_OFFSET" "TX_DEQUEUED_BYTES_OFFSET" "RX_PKTS_IN_QUEUE_OFFSET" "RX_BYTES_IN_QUEUE_OFFSET" "TX_PKTS_IN_QUEUE_OFFSET" "TX_BYTES_IN_QUEUE_OFFSET" "RX_PKTS_DROPPED_OFFSET" "RX_BYTES_DROPPED_OFFSET"
}

