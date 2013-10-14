#!/usr/bin/env python

from NFTest import *
import sys
import os
from scapy.layers.all import Ether, IP, TCP

conn = ('../connections/conn', [])
nftest_init(sim_loop = ['nf0', 'nf1', 'nf2', 'nf3'], hw_config = [conn])
nftest_start()

# set parameters
SA = "aa:bb:cc:dd:ee:ff"
TTL = 64
DST_IP = "192.168.1.1"
SRC_IP = "192.168.0.1"
nextHopMAC = "dd:55:dd:66:dd:77"
if isHW():
    NUM_PKTS = 50
else:
    NUM_PKTS = 5

pkts = []

print "Sending now: "
totalPktLengths = [0,0,0,0]
# send NUM_PKTS from ports nf2c0...nf2c3
for i in range(NUM_PKTS):
    sys.stdout.write('\r'+str(i))
    sys.stdout.flush()
    if isHW():
        for port in range(4):
            DA = "00:ca:fe:00:00:%02x"%port
            pkt = make_IP_pkt(dst_MAC=DA, src_MAC=SA, dst_IP=DST_IP,
                             src_IP=SRC_IP, TTL=TTL,
                             pkt_len=1514)
            totalPktLengths[port] += len(pkt)

	    nftest_send_dma('nf' + str(port), pkt)
            nftest_expect_dma('nf' + str(port), pkt)
    else:
	DA = "00:ca:fe:00:00:00"
        pkt = make_IP_pkt(dst_MAC=DA, src_MAC=SA, dst_IP=DST_IP,
                             src_IP=SRC_IP, TTL=TTL,
                             pkt_len=1514) 
	pkt.time = (i*(1e-8))
        pkts.append(pkt)

if not isHW():
    nftest_send_phy('nf0', pkts) 
    nftest_expect_dma('nf0', pkts) 

print ""
mres=[]
nftest_finish(mres)
