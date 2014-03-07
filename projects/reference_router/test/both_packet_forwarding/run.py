#!/usr/bin/python

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

# add an entry in the routing table:
subnetIP = ["192.168.2.0", "192.168.1.0"]
subnetMask = ["255.255.255.0", "255.255.255.0"]
nextHopIP = ["192.168.1.54", "192.168.3.12"]
outPort = [0x1, 0x4]
nextHopMAC = "dd:55:dd:66:dd:77"
SA = "aa:bb:cc:dd:ee:ff"
SRC_IP = "192.168.0.1"
length = 100
nextHopMAC = "dd:55:dd:66:dd:77"

for i in range(2):
    nftest_add_LPM_table_entry (i, subnetIP[i], subnetMask[i], nextHopIP[i], outPort[i])
    nftest_add_ARP_table_entry (i, nextHopIP[i], nextHopMAC)

#clear the num pkts forwarded reg
nftest_regwrite(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_PKT_FORWARDED(), 0)

nftest_barrier()

precreated = [[], []]
precreated_exp = [[], []]
sent_pkts = []
exp_pkts = []

# loop for 20 packets from eth1 to eth2
for i in range(20):
    if isHW():
        for port in range(2):
            DA = routerMAC[port]
            DST_IP = "192.168.%d.1"%(port + 1)
            sent_pkt = make_IP_pkt(dst_MAC=DA, src_MAC=SA, dst_IP=DST_IP,
                               src_IP=SRC_IP, pkt_len=length)
            exp_pkt = make_IP_pkt(dst_MAC=nextHopMAC, src_MAC=routerMAC[1 - port],
                              TTL = 63, dst_IP=DST_IP, src_IP=SRC_IP)
            exp_pkt[scapy.Raw].load = sent_pkt[scapy.Raw].load

            # send packet out of eth1->nf0
            nftest_send_phy('nf%d'%port, sent_pkt);
            nftest_expect_phy('nf%d'%(1-port), exp_pkt);
    else:
	DA = routerMAC[0]
        DST_IP = "192.168.1.1"
        sent_pkt = make_IP_pkt(dst_MAC=DA, src_MAC=SA, dst_IP=DST_IP,
                               src_IP=SRC_IP, pkt_len=length)
	sent_pkt.time = (i*(1e-8))
	sent_pkts.append(sent_pkt)
        exp_pkt = make_IP_pkt(dst_MAC=nextHopMAC, src_MAC=routerMAC[1],
                              TTL = 63, dst_IP=DST_IP, src_IP=SRC_IP)
        exp_pkt[scapy.Raw].load = sent_pkt[scapy.Raw].load
	exp_pkt.time = (i*(1e-8))
	exp_pkts.append(exp_pkt)

if not isHW():
    nftest_send_phy('nf0', sent_pkts)
    nftest_expect_phy('nf1', exp_pkts)

nftest_barrier()

if isHW():
    rres1=nftest_regread_expect(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_PKT_FORWARDED(), 40);
    mres=[rres1]
else:
    nftest_regread_expect(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_PKT_FORWARDED(), 20);
    mres=[]

nftest_finish(mres)
