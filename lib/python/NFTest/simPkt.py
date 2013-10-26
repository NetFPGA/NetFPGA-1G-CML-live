#!/usr/bin/env python
# Author: James Hsi, Eric Lo
# Modified by Georgina Kalogeridou
# Date: 1/31/2011

from NFTest import *

import simLib
import simReg
import os
import sys

script_dir = os.path.dirname( sys.argv[0] )
# Add path *relative to this script's location* of axitools module
sys.path.append( os.path.join( script_dir, '..','..','..','..','tools','scripts' ) )

# NB: axitools import must preceed any scapy imports
import axitools

NUM_PORTS = 4

CMD_SEND = 1
CMD_BARRIER = 2
CMD_DELAY = 3

CMD_BARRIER_REG = 4
CMD_PCI_DELAY = 5

f = []

# Global counters for synchronization
numExpectedPktsPHY = [0, 0, 0, 0]; numExpectedPktsDMA = [0, 0, 0, 0]
numSendPktsPHY = [0, 0, 0, 0]; numSendPktsDMA = [0, 0, 0, 0]

# Packet counters
SentPktsPHYcount = [0, 0, 0, 0]; SentPktsDMAcount = [0, 0, 0, 0]
ExpectedPktsPHYcount = [0, 0, 0, 0]; ExpectedPktsDMAcount = [0, 0, 0, 0]


############################
# Function: pktSendPHY
# Arguments: toPort - the port the packet will be sent to (1-4)
#            pkt - the packet data, class scapy.Packet
#
############################
def pktSendPHY(toPort, pkt):
    numSendPktsPHY[toPort-1] += 1

############################
# Function: pktSendDMA
# Arguments: toPort - the port the packet will be sent to (1-4)
#            pkt - the packet data, class scapy.Packet
#
############################
def pktSendDMA(toPort, pkt):
    #f = simLib.fDMA()
    numSendPktsDMA[toPort-1] += 1

############################
# Function: pktExpectPHY
# Arguments: atPort - the port the packet will be sent at (1-4)
#            pkt - the packet data, class scapy.Packet
#            mask - mask packet data, class scapy.Packet
#
############################
def pktExpectPHY(atPort, pkt, mask = None):
    numExpectedPktsPHY[atPort-1] += 1
   
############################
# Function: pktExpectDMA
# Arguments: atPort - the port the packet will be expected at (1-4)
#            pkt - the packet data, class scapy.Packet
#            mask - mask packet data, class scapy.Packet
#
############################
def pktExpectDMA(atPort, pkt, mask = None):
    numExpectedPktsDMA[atPort-1] += 1
   
# Synchronization ########################################################

############################
# Function: resetBarrier()
#
#  Private function to be called by pktBarrier
############################
def resetBarrier():
    global numExpectedPktsPHY; global numExpectedPktsDMA; global numSendPktsDMA; global numSendPktsPHY
    numExpectedPktsPHY = [0, 0, 0, 0]
    numExpectedPktsDMA = [0, 0, 0, 0]
    numSendPktsPHY = [0, 0, 0, 0]
    numSendPktsDMA = [0, 0, 0, 0]

############################
# Function: barrier
# Parameters: num - number of packets that must arrive
#   Modifies appropriate files for each port and ingress_dma to denote
#   a barrier request
############################
def barrier():
    for i in range(NUM_PORTS): # 0,1,2,3
	simLib.fPort(i + 1).write("# BARRIER\n")
	simLib.fPort(i + 1).write("B " + "%d\n"%CMD_BARRIER)   
	simLib.fPort(i + 1).write("# EXPECTED\n") 
	simLib.fPort(i + 1).write("N " + "%d\n"%(numExpectedPktsPHY[i]))
	simLib.fPort(i + 1).write("# SENT\n") 
	simLib.fPort(i + 1).write("S " + "%d\n\n"%(numSendPktsPHY[i]))
    simLib.fDMA().write("# BARRIER\n")
    simLib.fDMA().write("B " + "%d\n"%CMD_BARRIER)   
    simLib.fDMA().write("# EXPECTED\n") 
    simLib.fDMA().write("N " + "%d\n"%(numExpectedPktsDMA[0]))
    simLib.fDMA().write("# SENT\n") 
    simLib.fDMA().write("S " + "%d\n\n"%(numSendPktsDMA[0]))
    simLib.fregstim().write("# BARRIER\n")
    simLib.fregstim().write("B " + "%d\n"%CMD_BARRIER_REG)
    for i in range(NUM_PORTS):
	#if numSendPktsPHY[i] == 0:
	#    simLib.fregstim().write("")
	#else: 
	#if numExpectedPktsPHY[i] == numSendPktsPHY[i]:
	#    simLib.fregstim().write("N " + "%d\n"%(numSendPktsPHY[i]))
	#    simLib.fregstim().write("N " + "%d\n"%(numExpectedPktsPHY[i]))
	#else:
	simLib.fregstim().write("# Interface " + "%d\n"%(i)) 
	#simLib.fregstim().write("S " + "%d\n"%(numSendPktsPHY[i]))
        simLib.fregstim().write("N " + "%d\n"%(numExpectedPktsPHY[i]))
	simLib.fregstim().write("S " + "%d\n"%(numSendPktsPHY[i]))
    #if numSendPktsDMA[i] == 0:
#	simLib.fregstim().write("")
#    else:
    simLib.fregstim().write("# DMA\n")
    #simLib.fregstim().write("S " + "%d\n"%(numSendPktsDMA[i]))
    simLib.fregstim().write("N " + "%d\n"%(numExpectedPktsDMA[i])) 
    simLib.fregstim().write("S " + "%d\n"%(numSendPktsDMA[i]))
    #simLib.fregexpect().write("# BARRIER\n")
    #simLib.fregexpect().write("B " + "%d\n"%CMD_BARRIER_REG)
       
    resetBarrier()

MSB_MASK = (0xFFFFFFFF00000000)
LSB_MASK = (0x00000000FFFFFFF)

###########################
# Function: pktDelay
#
###########################
def delay(nanoSeconds):
    for i in range(NUM_PORTS):
        simLib.fPort(i+1).write("%08d"%CMD_DELAY + " // DELAY\n")
        simLib.fPort(i+1).write("%08x"%(MSB_MASK & nanoSeconds) +
                                " // Delay (MSB) " + str(nanoSeconds)+" ns\n")
        simLib.fPort(i+1).write("%08x"%(MSB_MASK & nanoSeconds) +
                                " // Delay (LSB) " + str(nanoSeconds)+" ns\n")

    simLib.fPCI().write("%08d"%CMD_PCI_DELAY+" // DELAY\n")
    simLib.fPCI().write("%08x"%(MSB_MASK & nanoSeconds) + " // Delay (MSB) " +
                        str(nanoSeconds) + " ns\n")
    simLib.fPCI().write("%08x"%(LSB_MASK & nanoSeconds) + " // Delay (LSB) " +
                        str(nanoSeconds) + " ns\n")
