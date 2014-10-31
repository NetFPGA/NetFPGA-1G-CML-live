#!/usr/bin/env python

from NFTest import *
import sys
import os
import argparse
from scapy.layers.all import Ether, IP, TCP

conn = ('../connections/conn', [])
nftest_init(sim_loop = ['nf0', 'nf1', 'nf2', 'nf3'], hw_config = [conn])

pkts = []

# Packet length parameter
parser = argparse.ArgumentParser()
parser.add_argument("--packet_length", help="Length of packet in no of bytes")
parser.add_argument("--packet_no", help="No of packets")

args = parser.parse_args()

if (args.packet_length):
	pkt_length = args.packet_length
else:
	pkt_length = '16'

payload_data = ''

if (args.packet_no):
	no_pkts = args.packet_no
else:
	no_pkts = '2'

for i in range(int(pkt_length)):
	payload_data = payload_data + 'A'

for i in range(int(no_pkts)*4):        
        pkt = (Ether(src='11:22:33:44:55:66', dst='77:88:99:aa:bb:cc')/
           IP(src='192.168.1.1', dst='192.168.1.2')/
           TCP()/payload_data)
	pkt.time = (i*(1e-8))
        pkts.append(pkt)

for i in range(4):
    nftest_send_dma('nf%d'%i, pkts) # --tx
    nftest_expect_phy('nf%d' %i, pkts) # --tx

print ""

