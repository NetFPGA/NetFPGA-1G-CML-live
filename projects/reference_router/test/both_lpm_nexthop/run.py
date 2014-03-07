#!/usr/bin/env python

from NFTest import *
import random
from RegressRouterLib import *
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

index = 0
subnetIP = ["192.168.1.1", "192.168.1.0"]
subnetMask = ["255.255.255.225", "255.255.255.0"]
nextHopIP = ["0.0.0.0", "192.168.1.54"]
arpNextHopIP = ["192.168.1.54", "192.168.1.1"]
outPort = [0x4, 0x1]
nextHopMAC = "dd:55:dd:66:dd:77"
pkts = []
exp_pkts = []

for i in range(2):
	nftest_add_LPM_table_entry(i, subnetIP[i], subnetMask[i], nextHopIP[i], outPort[i])
	nftest_add_ARP_table_entry(i, arpNextHopIP[i], nextHopMAC)

nftest_barrier()

for i in range(100):
    hdr = make_MAC_hdr(src_MAC="aa:bb:cc:dd:ee:ff", dst_MAC=routerMAC[0],
                       )/scapy.IP(src="192.168.0.1", dst="192.168.1.1")
    exp_hdr = make_MAC_hdr(src_MAC=routerMAC[1], dst_MAC=nextHopMAC,
                           )/scapy.IP(src="192.168.0.1", dst="192.168.1.1", ttl=63)
    load = generate_load(100)
    pkt = hdr/load
    exp_pkt = exp_hdr/load
    if isHW():
        nftest_send_phy('nf0', pkt)
        nftest_expect_phy('nf1', exp_pkt)
    else:
	pkt.time = (i*(1e-8))
	pkts.append(pkt)
	exp_pkt.time = (i*(1e-8))
	exp_pkts.append(exp_pkt)

if not isHW():
    nftest_send_phy('nf0', pkts)
    nftest_expect_phy('nf1', exp_pkts)

mres=[]
nftest_finish(mres)
