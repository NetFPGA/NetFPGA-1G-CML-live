#!/bin/env python

from NFTest import *
import random
import sys

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
    NUM_PKTS = 5
else:
    NUM_PKTS = 5

print "Sending now: "
totalPktLengths = [0,0,0,0]
# send NUM_PKTS from ports nf2c0...nf2c3
for i in range(NUM_PKTS):
    sys.stdout.write('\r'+str(i))
    sys.stdout.flush()
    for port in range(4):
        DA = "00:ca:fe:00:00:%02x"%port
        pkt = make_IP_pkt(dst_MAC=DA, src_MAC=SA, dst_IP=DST_IP,
                             src_IP=SRC_IP, TTL=TTL,
                             pkt_len=random.randint(60,1514))
        totalPktLengths[port] += len(pkt)

        nftest_send_dma('nf' + str(port), pkt)
        nftest_expect_dma('nf' + str(port), pkt)

print ""
mres=[]
nftest_finish(mres)
