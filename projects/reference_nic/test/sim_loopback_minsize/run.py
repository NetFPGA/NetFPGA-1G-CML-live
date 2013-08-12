#!/usr/bin/env python

from __future__ import with_statement

from NFTest import *
import sys
import os
import argparse

script_dir = os.path.dirname( sys.argv[0] )
# Add path *relative to this script's location* of axitools module
sys.path.append( os.path.join( script_dir, '..','..','..','..','tools','scripts' ) )

# NB: axitools import must preceed any scapy imports
import axitools

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
                             pkt_len=60)
        	totalPktLengths[port] += len(pkt)

        	nftest_send_dma('nf' + str(port), pkt)
        	nftest_expect_dma('nf' + str(port), pkt)

	print ""

	nftest_finish()
else:
	no_pkts = 8
	pkts=[]
	# A simple TCP/IP packet embedded in an Ethernet II frame	
	for i in range(no_pkts):
    	    g = 10 # min payload length
	    payload = ''
	    for x in range(g):
		payload = payload + 'A'
    	    	pkt = (Ether(src='aa:bb:cc:dd:ee:ff', dst='77:88:99:aa:bb:cc')/
           	      IP(src='192.168.0.1', dst='192.168.1.1')/
           	      TCP()/
		      payload)    	    
	    pkt.time = i*(1e-8)
       	    # Set source network interface for DMA stream
    	    pkt.tuser_sport = 1 << (i%4*2 + 1) # PCI ports are odd-numbered
    	    pkts.append(pkt)

	# PCI interface
	with open( os.path.join( script_dir, 'dma_0_stim.axi' ), 'w' ) as f:
    	    axitools.axis_dump( pkts, f, 256, 1e-9 )
	with open( os.path.join( script_dir, 'dma_0_expected.axi' ), 'w' ) as f:
    	    axitools.axis_dump( pkts*4, f, 256, 1e-9 )

	# 10g interfaces
	for i in range(4):
    	    # replace source port
    	    for pkt in pkts:
        	pkt.tuser_sport = 1 << (i*2) # physical ports are even-numbered
    	    with open( os.path.join( script_dir, 'nf10_10g_interface_%d_stim.axi' % i ), 'w' ) as f:
        	axitools.axis_dump( pkts, f, 256, 1e-9 )
    	    with open( os.path.join( script_dir, 'nf10_10g_interface_%d_expected.axi' % i ), 'w' ) as f:
        	axitools.axis_dump( pkts[0:(no_pkts/4)], f, 256, 1e-9 )




