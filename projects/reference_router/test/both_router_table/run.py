#!/usr/bin/env python

from NFTest import *
from NFTest.hwRegLib import *
from RegressRouterLib import *
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

NUM_PORTS = 4

def get_dest_MAC(i):
    i_plus_one = i + 1
    if i == 0:
        return "00:ca:fe:00:00:02"
    if i == 1:
        return "00:ca:fe:00:00:01"
    if i == 2:
        return "00:ca:fe:00:00:04"
    if i == 3:
        return "00:ca:fe:00:00:03"

routerMAC = ["00:ca:fe:00:00:01", "00:ca:fe:00:00:02", "00:ca:fe:00:00:03", "00:ca:fe:00:00:04"]
routerIP = ["192.168.0.40", "192.168.1.40", "192.168.2.40", "192.168.3.40"]

ALLSPFRouters = "224.0.0.5"

# Clear all tables in a hardware test (not needed in software)
if isHW():
    nftest_invalidate_all_tables()

# Write the mac and IP addresses
for port in range(4):
    nftest_add_dst_ip_filter_entry (port, routerIP[port])
    nftest_set_router_MAC ('nf%d'%port, routerMAC[port])
nftest_add_dst_ip_filter_entry (4, ALLSPFRouters)

# router mac 0
nftest_regread_expect(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_MAC_0_HIGH(), 0xca)
nftest_regread_expect(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_MAC_0_LOW(), 0xfe000001)
# router mac 1
nftest_regread_expect(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_MAC_1_HIGH(), 0xca)
nftest_regread_expect(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_MAC_1_LOW(), 0xfe000002)
# router mac 2
nftest_regread_expect(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_MAC_2_HIGH(), 0xca)
nftest_regread_expect(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_MAC_2_LOW(), 0xfe000003)
# router mac 3
nftest_regread_expect(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_MAC_3_HIGH(), 0xca)
nftest_regread_expect(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_MAC_3_LOW(), 0xfe000004)

# add LPM and ARP entries for each port
for i in range(NUM_PORTS):
    i_plus_1 = i + 1
    subnetIP = "192.168." + str(i_plus_1) + ".1"
    subnetMask = "255.255.255.225"
    nextHopIP = "192.168.5." + str(i_plus_1)
    outPort = 1 << (2 * i)
    nextHopMAC = get_dest_MAC(i)

    # add an entry in the routing table
    nftest_add_LPM_table_entry(i, subnetIP, subnetMask, nextHopIP, outPort)
    # add and entry in the ARP table
    nftest_add_ARP_table_entry(i, nextHopIP, nextHopMAC)

# ARP table
mac_hi = 0xca
mac_lo = [0xfe000002, 0xfe000001, 0xfe000004, 0xfe000003]
router_ip = [0xc0a80501, 0xc0a80502, 0xc0a80503, 0xc0a80504]
for i in range(31):
    nftest_regwrite(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_ARP_RD_ADDR(), i)
    # ARP MAC
    if i < 4:
        nftest_regread_expect(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_ARP_MAC_HIGH(), mac_hi)
        nftest_regread_expect(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_ARP_MAC_LOW(), mac_lo[i])
        nftest_regread_expect(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_ARP_IP(), router_ip[i])
    else:
        nftest_regread_expect(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_ARP_MAC_HIGH(), 0)
        nftest_regread_expect(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_ARP_MAC_LOW(), 0)
        nftest_regread_expect(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_ARP_IP(), 0)

# Routing table
router_ip = [0xc0a80101, 0xc0a80201, 0xc0a80301, 0xc0a80401]
subnet_mask = [0xffffffe1, 0xffffffe1, 0xffffffe1, 0xffffffe1]
arp_port = [1, 4]
next_hop_ip = [0xc0a80501, 0xc0a80502, 0xc0a80503, 0xc0a80504]
for i in range(31):
    nftest_regwrite(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_LPM_RD_ADDR(), i)
    if i < 2:
        nftest_regread_expect(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_LPM_OQ(), arp_port[i])
    if i < 4:
        # Router IP
        nftest_regread_expect(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_LPM_IP(), router_ip[i])
        nftest_regread_expect(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_LPM_NEXT_HOP_IP(), next_hop_ip[i])
        # Router subnet mask
        nftest_regread_expect(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_LPM_IP_MASK(), subnet_mask[i])
    else:
        # Router IP
        nftest_regread_expect(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_LPM_IP(), 0)
        nftest_regread_expect(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_LPM_NEXT_HOP_IP(), 0)
        # Router subnet mask
        nftest_regread_expect(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_LPM_IP_MASK(), 0xffffffff)

# IP filter
filter = [0xc0a80028, 0xc0a80128, 0xc0a80228, 0xc0a80328, 0xe0000005]
for i in range(31):
    nftest_regwrite(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_FILTER_RD_ADDR(), i)
    if i < 5:
        nftest_regread_expect(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_FILTER_IP(), filter[i])
    else:
        nftest_regread_expect(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_FILTER_IP(), 0)
mres=[]
nftest_finish(mres)

