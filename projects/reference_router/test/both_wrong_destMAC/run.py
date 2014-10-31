#!/usr/bin/env python

from NFTest import *
import random
from RegressRouterLib import *
import NFTest.simReg
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

# Clear all tables in a hardware test (not needed in software)
if isHW():
    nftest_invalidate_all_tables()

# Write the mac and IP addresses
for port in range(4):
    nftest_add_dst_ip_filter_entry (port, routerIP[port])
    nftest_set_router_MAC ('nf%d'%port, routerMAC[port])

# set parameters
SA = "aa:bb:cc:dd:ee:ff"
DST_IP = "192.168.2.1";   #not in the lpm table
SRC_IP = "192.168.0.1"
VERSION = 0x4
nextHopMAC = "dd:55:dd:66:dd:77"

# Wrong mac destination
DA = "00:ca:fe:00:00:11"
sent_pkts = []

nftest_barrier()

# loop for 30 packets
for i in range(30):
    if isHW():
	for port in range(2):
            sent_pkt = make_IP_pkt(dst_MAC=DA, src_MAC=SA,
                               src_IP=SRC_IP, dst_IP=DST_IP,
                               pkt_len=random.randint(60, 1514))
            nftest_send_phy('nf%d'%port, sent_pkt)
	nftest_barrier()
    else:
	sent_pkt = make_IP_pkt(dst_MAC=DA, src_MAC=SA,
                               src_IP=SRC_IP, dst_IP=DST_IP,
                               pkt_len=random.randint(60, 1514))
	sent_pkt.time = (i*(1e-8))
	sent_pkts.append(sent_pkt)
        
if not isHW():
    nftest_send_phy('nf0', sent_pkts)
    nftest_barrier()
    simReg.regDelay(1000)

# Read the counters
if isHW():
    rres1=nftest_regread_expect(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_PKT_DROPPED_WRONG_DST_MAC(), 60)
    mres=[rres1]
else:
    nftest_regread_expect(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_PKT_DROPPED_WRONG_DST_MAC(), 30)
    mres=[]

nftest_barrier()

nftest_finish(mres)
