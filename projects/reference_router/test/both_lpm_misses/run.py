#!/usr/bin/env python

from NFTest import *
import random
from RegressRouterLib import *
from reg_defines_reference_router import *

import os

from scapy.layers.all import Ether, IP, TCP

phy2loop0 = ('../connections/2phy', [])

nftest_init(sim_loop = [], hw_config = [phy2loop0])
nftest_start()

if isHW():
    # asserting the reset_counter to 1 for clearing the registers
    nftest_regwrite(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_RESET_CNTRS(), 0x1)
    nftest_regwrite(XPAR_NF10_10G_INTERFACE_0_RESET_CNTRS(), 0x1)
    nftest_regwrite(XPAR_NF10_10G_INTERFACE_1_RESET_CNTRS(), 0x1)
    nftest_regwrite(XPAR_NF10_10G_INTERFACE_2_RESET_CNTRS(), 0x1)
    nftest_regwrite(XPAR_NF10_10G_INTERFACE_3_RESET_CNTRS(), 0x1)
    nftest_regwrite(XPAR_NF10_INPUT_ARBITER_0_RESET_CNTRS(), 0x1)
    nftest_regwrite(XPAR_NF10_BRAM_OUTPUT_QUEUES_0_RESET_CNTRS(), 0x1)

    # asseting teh reset_counter to 0 for enable the counters to increment
    nftest_regwrite(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_RESET_CNTRS(), 0x0)
    nftest_regwrite(XPAR_NF10_10G_INTERFACE_0_RESET_CNTRS(), 0x0)
    nftest_regwrite(XPAR_NF10_10G_INTERFACE_1_RESET_CNTRS(), 0x0)
    nftest_regwrite(XPAR_NF10_10G_INTERFACE_2_RESET_CNTRS(), 0x0)
    nftest_regwrite(XPAR_NF10_10G_INTERFACE_3_RESET_CNTRS(), 0x0)
    nftest_regwrite(XPAR_NF10_INPUT_ARBITER_0_RESET_CNTRS(), 0x0)
    nftest_regwrite(XPAR_NF10_BRAM_OUTPUT_QUEUES_0_RESET_CNTRS(), 0x0)

routerMAC = ["00:ca:fe:00:00:01", "00:ca:fe:00:00:02", "00:ca:fe:00:00:03", "00:ca:fe:00:00:04"]
routerIP = ["192.168.0.40", "192.168.1.40", "192.168.2.40", "192.168.3.40"]

# Clear all tables in a hardware test (not needed in software)
if isHW():
    nftest_invalidate_all_tables()

# Write the mac and IP addresses
for port in range(4):
    nftest_add_dst_ip_filter_entry (port, routerIP[port])
    nftest_set_router_MAC ('nf%d'%port, routerMAC[port])

index = 0
subnetIP = "192.168.1.0"
subnetMask = "255.255.255.0"
nextHopIP = "192.168.1.54"
outPort = 0x4
nextHopMAC = "dd:55:dd:66:dd:77"
pkts = []

nftest_add_LPM_table_entry(index, subnetIP, subnetMask, nextHopIP, outPort)
nftest_add_ARP_table_entry(index, nextHopIP, nextHopMAC)

nftest_barrier()

for i in range(100):
    pkt = make_IP_pkt(src_MAC="aa:bb:cc:dd:ee:ff", dst_MAC=routerMAC[0],
                      src_IP="192.168.0.1", dst_IP="192.168.2.1")
    if isHW():
        nftest_send_phy('nf0', pkt)
        nftest_expect_dma('nf0', pkt)
    else:
	pkt.time = (i*(1e-8))
	pkts.append(pkt)

if not isHW():
    nftest_send_phy('nf0', pkts)
    nftest_expect_dma('nf0', pkts)

nftest_barrier()

if isHW():
    rres1=nftest_regread_expect(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_PKT_SENT_CPU_LPM_MISS(), 100)
    mres=[rres1]
else:
    nftest_regread_expect(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_PKT_SENT_CPU_LPM_MISS(), 100)
    mres=[]

nftest_finish(mres)
