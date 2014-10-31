#!/usr/bin/env python

from NFTest import *
import sys
import os

from scapy.layers.all import Ether, IP, TCP
from reg_defines_reference_switch_lite import *

phy2loop0 = ('../connections/conn', [])

nftest_init(sim_loop = [], hw_config = [phy2loop0])

if isHW():
    # Clearing the LUT_HIT and LUT_MISS by asserting the reset_counters
    nftest_regwrite(XPAR_NF10_SWITCH_OUTPUT_PORT_LOOKUP_0_RESET_CNTRS(), 0x1)
    nftest_regwrite(XPAR_NF10_10G_INTERFACE_0_RESET_CNTRS(), 0x1)
    nftest_regwrite(XPAR_NF10_10G_INTERFACE_1_RESET_CNTRS(), 0x1)
    nftest_regwrite(XPAR_NF10_10G_INTERFACE_2_RESET_CNTRS(), 0x1)
    nftest_regwrite(XPAR_NF10_10G_INTERFACE_3_RESET_CNTRS(), 0x1)
    nftest_regwrite(XPAR_NF10_INPUT_ARBITER_0_RESET_CNTRS(), 0x1)
    nftest_regwrite(XPAR_NF10_BRAM_OUTPUT_QUEUES_0_RESET_CNTRS(), 0x1)

    # Deasserting the reset_counters
    nftest_regwrite(XPAR_NF10_SWITCH_OUTPUT_PORT_LOOKUP_0_RESET_CNTRS(), 0x0)
    nftest_regwrite(XPAR_NF10_10G_INTERFACE_0_RESET_CNTRS(), 0x0)
    nftest_regwrite(XPAR_NF10_10G_INTERFACE_1_RESET_CNTRS(), 0x0)
    nftest_regwrite(XPAR_NF10_10G_INTERFACE_2_RESET_CNTRS(), 0x0)
    nftest_regwrite(XPAR_NF10_10G_INTERFACE_3_RESET_CNTRS(), 0x0)
    nftest_regwrite(XPAR_NF10_INPUT_ARBITER_0_RESET_CNTRS(), 0x0)
    nftest_regwrite(XPAR_NF10_BRAM_OUTPUT_QUEUES_0_RESET_CNTRS(), 0x0)


nftest_start()

routerMAC = []
routerIP = []
for i in range(4):
    routerMAC.append("00:ca:fe:00:00:0%d"%(i+1))
    routerIP.append("192.168.%s.40"%i)

num_broadcast = 20

pkts = []
for i in range(num_broadcast):
    pkt = make_IP_pkt(src_MAC="aa:bb:cc:dd:ee:ff", dst_MAC=routerMAC[0],
                      EtherType=0x800, src_IP="192.168.0.1",
                      dst_IP="192.168.1.1", pkt_len=100)

    pkt.time = ((i*(1e-8)) + (1e-6))
    pkts.append(pkt)
    if isHW():
        nftest_send_phy('nf0', pkt)
        nftest_expect_phy('nf1', pkt)
    
if not isHW():
    nftest_send_phy('nf0', pkts)
    nftest_expect_phy('nf1', pkts)
    nftest_expect_phy('nf2', pkts)
    nftest_expect_phy('nf3', pkts)

nftest_barrier()

if isHW():
    # Expecting the LUT_MISS counter to be incremented by 0x14, 20 packets 

    rres1=nftest_regread_expect(XPAR_NF10_SWITCH_OUTPUT_PORT_LOOKUP_0_LUT_NUM_MISSES_REG(), 0X14)
    rres2=nftest_regread_expect(XPAR_NF10_SWITCH_OUTPUT_PORT_LOOKUP_0_LUT_NUM_HITS_REG(), 0x0)
    mres=[rres1,rres2]
else:
    nftest_regread_expect(XPAR_NF10_SWITCH_OUTPUT_PORT_LOOKUP_0_LUT_NUM_HITS_REG(), 0) # lut_hit
    nftest_regread_expect(XPAR_NF10_SWITCH_OUTPUT_PORT_LOOKUP_0_LUT_NUM_MISSES_REG(), 0x14) # lut_miss
    mres=[]

nftest_finish(mres)
