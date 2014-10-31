################################################################################
#
#  NetFPGA-10G http://www.netfpga.org
#
#  File:
#        nf10_bram_oqs_v2_1_0.tcl
#
#  Library:
#        std/pcores/nf10_bram_oqs_v1_10_a
#
#  Author:
#        Gianni Antichi
#
#  Description:
#        Driver TCL script
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


proc generate {drv_handle} {
    #---------------------------
    # #defines in xparameters.h
    #---------------------------
    xdefine_include_file $drv_handle "xparameters.h" "NF10_BRAM_OQS" "C_BASEADDR" "C_HIGHADDR" "RESET_CNTRS_OFFSET" "PKT_STORED_PORT_0_OFFSET" "BYTES_STORED_PORT_0_OFFSET" "PKT_REMOVED_PORT_0_OFFSET" "BYTES_REMOVED_PORT_0_OFFSET" "PKT_DROPPED_PORT_0_OFFSET" "BYTES_DROPPED_PORT_0_OFFSET" "PKT_IN_QUEUE_PORT_0_OFFSET" "BYTES_IN_QUEUE_PORT_0_OFFSET" "PKT_STORED_PORT_1_OFFSET" "BYTES_STORED_PORT_1_OFFSET" "PKT_REMOVED_PORT_1_OFFSET" "BYTES_REMOVED_PORT_1_OFFSET" "PKT_DROPPED_PORT_1_OFFSET" "BYTES_DROPPED_PORT_1_OFFSET" "PKT_IN_QUEUE_PORT_1_OFFSET" "BYTES_IN_QUEUE_PORT_1_OFFSET" "PKT_STORED_PORT_2_OFFSET" "BYTES_STORED_PORT_2_OFFSET" "PKT_REMOVED_PORT_2_OFFSET" "BYTES_REMOVED_PORT_2_OFFSET" "PKT_DROPPED_PORT_2_OFFSET" "BYTES_DROPPED_PORT_2_OFFSET" "PKT_IN_QUEUE_PORT_2_OFFSET" "BYTES_IN_QUEUE_PORT_2_OFFSET" "PKT_STORED_PORT_3_OFFSET" "BYTES_STORED_PORT_3_OFFSET" "PKT_REMOVED_PORT_3_OFFSET" "BYTES_REMOVED_PORT_3_OFFSET" "PKT_DROPPED_PORT_3_OFFSET" "BYTES_DROPPED_PORT_3_OFFSET" "PKT_IN_QUEUE_PORT_3_OFFSET" "BYTES_IN_QUEUE_PORT_3_OFFSET" "PKT_STORED_PORT_4_OFFSET" "BYTES_STORED_PORT_4_OFFSET" "PKT_REMOVED_PORT_4_OFFSET" "BYTES_REMOVED_PORT_4_OFFSET" "PKT_DROPPED_PORT_4_OFFSET" "BYTES_DROPPED_PORT_4_OFFSET" "PKT_IN_QUEUE_PORT_4_OFFSET" "BYTES_IN_QUEUE_PORT_4_OFFSET"
}

