################################################################################
#
#  NetFPGA-10G http://www.netfpga.org
#
#  File:
#        nf10_router_v2_1_0.tcl
#
#  Library:
#        std/pcores/nf10_router_v1_00_a
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
    xdefine_include_file $drv_handle "xparameters.h" "NF10_ROUTER_OUTPUT_PORT_LOOKUP" "ROUTE_TABLE_DEPTH" "ARP_TABLE_DEPTH" "DST_IP_FILTER_TABLE_DEPTH" "C_BAR0_BASEADDR" "C_BAR0_HIGHADDR" "BAR0_RESET_CNTRS_OFFSET" "BAR0_MAC_0_LOW_OFFSET" "BAR0_MAC_0_HIGH_OFFSET" "BAR0_MAC_1_LOW_OFFSET" "BAR0_MAC_1_HIGH_OFFSET" "BAR0_MAC_2_LOW_OFFSET" "BAR0_MAC_2_HIGH_OFFSET" "BAR0_MAC_3_LOW_OFFSET" "BAR0_MAC_3_HIGH_OFFSET" "BAR0_PKT_DROPPED_WRONG_DST_MAC_OFFSET" "BAR0_PKT_SENT_CPU_LPM_MISS_OFFSET" "BAR0_PKT_SENT_CPU_ARP_MISS_OFFSET" "BAR0_PKT_SENT_CPU_NON_IP_OFFSET" "BAR0_PKT_DROPPED_CHECKSUM_OFFSET" "BAR0_PKT_FORWARDED_OFFSET" "BAR0_PKT_SENT_CPU_DEST_IP_HIT_OFFSET" "BAR0_PKT_SENT_TO_CPU_BAD_TTL_OFFSET" "BAR0_PKT_SENT_CPU_OPTION_VER_OFFSET" "BAR0_PKT_SENT_FROM_CPU_OFFSET" "C_BAR1_BASEADDR" "C_BAR1_HIGHADDR" "BAR1_LPM_IP_OFFSET" "BAR1_LPM_IP_MASK_OFFSET" "BAR1_LPM_NEXT_HOP_IP_OFFSET" "BAR1_LPM_OQ_OFFSET" "BAR1_LPM_WR_ADDR_OFFSET" "BAR1_LPM_RD_ADDR_OFFSET" "BAR1_ARP_IP_OFFSET" "BAR1_ARP_MAC_LOW_OFFSET" "BAR1_ARP_MAC_HIGH_OFFSET" "BAR1_ARP_WR_ADDR_OFFSET" "BAR1_ARP_RD_ADDR_OFFSET" "BAR1_FILTER_IP_OFFSET" "BAR1_FILTER_WR_ADDR_OFFSET" "BAR1_FILTER_RD_ADDR_OFFSET"
}

