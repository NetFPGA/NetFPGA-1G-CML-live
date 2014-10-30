#!/usr/bin/env python

from NFTest import *
import random
from RegressRouterLib import *
import sys
import os

from scapy.layers.all import Ether, IP, TCP
from reg_defines_reference_router import *

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
dstIP = ["192.168.0.50", "192.168.1.50", "192.168.2.50", "192.168.3.50"]
dstMAC = ["aa:bb:cc:dd:ee:01", "aa:bb:cc:dd:ee:02", "aa:bb:cc:dd:ee:03", "aa:bb:cc:dd:ee:04"]

ALLSPFRouters = "224.0.0.5"

# Clear all tables in a hardware test (not needed in software)
if isHW():
    nftest_invalidate_all_tables()

# Write the mac and IP addresses
for port in range(4):
    nftest_add_dst_ip_filter_entry (port, routerIP[port])
    nftest_set_router_MAC ('nf%d'%port, routerMAC[port])
nftest_add_dst_ip_filter_entry (4, ALLSPFRouters)
nftest_add_dst_ip_filter_entry (5, dstIP[0])

SA = "aa:bb:cc:dd:ee:ff"
DST_IP = dstIP[0]
SRC_IP = "192.168.0.1"
sent_pkts = []

nftest_barrier()

# loop for 30 packets
for i in range(30):
    if isHW():
	for portid in range(2):
	    DA = routerMAC[portid]
            sent_pkt = make_IP_pkt(dst_MAC=DA, src_MAC=SA, src_IP=SRC_IP,
                               dst_IP=DST_IP, pkt_len=random.randint(60,1514))

            nftest_send_phy('nf%d'%portid, sent_pkt)
            nftest_expect_dma('nf%d'%portid, sent_pkt)
    else:
	DA = routerMAC[0]
        sent_pkt = make_IP_pkt(dst_MAC=DA, src_MAC=SA, src_IP=SRC_IP,
                               dst_IP=DST_IP, pkt_len=random.randint(60,1514))
	sent_pkt.time = (i*(1e-8))
        sent_pkts.append(sent_pkt)

if not isHW():
    nftest_send_phy('nf0', sent_pkts) 
    nftest_expect_dma('nf0', sent_pkts)   

nftest_barrier()

# Read the counters
if isHW():
    rres1=nftest_regread_expect(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_PKT_SENT_CPU_DEST_IP_HIT(), 60)
    mres=[rres1]
else:
    nftest_regread_expect(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_PKT_SENT_CPU_DEST_IP_HIT(), 30)
    mres=[]

nftest_barrier()

nftest_finish(mres)
