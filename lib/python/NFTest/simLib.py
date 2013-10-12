#!/usr/bin/env python
# Author: James Hsi, Eric Lo
# Modified by Georgina Kalogeridou
# Date: 1/31/2011
#
#  Overarching test module.
#  Creates and maintains file objects through file writes during tests.
# python -m pdb
#

from NFTest import *
import os

NUM_PORTS = 4
NF2_MAX_PORTS = 4
DMA_QUEUES = 4

#instantiation
f_ingress = []
f_expectPHY = []
f_expectDMA = []
f_dma = []
f_regstim = []
f_regexpect = []

# directory = 'packet_data'
dma_stim = 'dma_0_stim.axi'
dma_expect = 'dma_'
ingress_fileHeader = 'nf10_10g_interface_' # 'ingress_port_'
expectPHY_fileHeader = 'nf10_10g_interface_' # 'expected_port_'
reg_expect = 'reg_expect.axi' 
reg_stim = 'reg_stim.axi'

############################
# Function: init()
#   Creates the hardware and simulation files to be read by ModelSim,
############################
def init():

    global f_dma; global f_regstim; global f_regexpect
    f_dma = open(dma_stim,'w')  
    f_regstim = open(reg_stim, 'w')
    f_regexpect = open(reg_expect, 'w')  

    for i in range(NUM_PORTS):
        filename = ingress_fileHeader + str(i) + "_stim.axi"
        f_ingress.append(open(filename, 'w'))
        
    for i in range(NUM_PORTS):
        filename = expectPHY_fileHeader + str(i) + "_expected.axi"
        f_expectPHY.append(open(filename, 'w'))
  
    for i in range(NUM_PORTS):
        filename = dma_expect + str(i) + "_expected.axi"
        f_expectDMA.append(open(filename, 'w'))
	

    #f_dma.append(open(dma_stim, 'w'))
    #f_expectDMA.append(open(dma_expect, 'w'))
    #f_regstim.append(open(reg_stim, 'w'))
    #f_regexpect.append(open(reg_expect, 'w'))
   
############################
# Function: writeFileHeader
#  Writes timestamp and general information to file head.
############################
def writeFileHeader(fp, filePath):
    from time import gmtime, strftime
    fp.write("//File " + filePath + " created " +
                strftime("%a %b %d %H:%M:%S %Y", gmtime())+"\n")
    fp.write("//\n//This is a data file intended to be read in by a " +
                "Verilog simulation.\n//\n")


############################
# Function: writeXMLHeader
#  Writes timestamp and general information to file head.
############################
def writeXMLHeader(fp, filePath):
    from time import gmtime, strftime
    fp.write("<?xml version=\"1.0\" standalone=\"yes\" ?>\n")
    fp.write("<!-- File "+filePath+" created "+
                strftime("%a %b %d %H:%M:%S %Y", gmtime())+" -->\n")
    if str.find(filePath, expectPHY_fileHeader)>0:
        fp.write("<!-- PHYS_PORTS = "+str(NUM_PORTS)+" MAX_PORTS = "+
                    str(NF2_MAX_PORTS)+" -->\n")
        fp.write("<PACKET_STREAM>\n")
    elif str.find(filePath, expectDMA_fileHeader)>0:
        fp.write("<!-- DMA_QUEUES = "+"%d"%DMA_QUEUES+" -->")
        fp.write("<DMA_PACKET_STREAM>\n")
    fp.write("\n")


############################
# Function: close()
#   Closes all file pointers created during initialization.
#   Must be called at the end of every test file.
############################
def close():
    f_dma.close()
    f_regstim.close()
    f_regexpect.close()

    for i in range(NUM_PORTS):
        f_ingress[i].close()

    for i in range(NUM_PORTS):
        f_expectPHY[i].close()

    for i in range(NUM_PORTS):
        f_expectDMA[i].close()

############################
# Function: fregstim(), fregexpect()
#  A Getter that returns the file pointer for file with
#  register read/write info.
############################
def fregstim():
    return f_regstim

def fregexpect():
    return f_regexpect

############################
# Function: fDMA
#  A Getter that returns the file pointer for file with DMA read/write info.
############################
def fDMA():
    return f_dma


############################
# Function: fPort
# Argument: port - int - port for which read/write is occurring
#                   (Should be 1-4, NOT THE INDEX OF ARRAY)
#  A Getter that returns the file pointer for file with PHY read/write info.
#
############################
def fPort(port):
    return f_ingress[port-1] # 0,1,2,3


############################
# Function: fExpectPHY
# Argument: port - int - port for which read/write is occurring
#                   (Should be 1-4, NOT THE INDEX OF ARRAY)
#  A Getter that returns the file pointer for file with PHY read/write info.
#
############################
def fExpectPHY(port):
    return f_expectPHY[port-1]


############################
# Function: fExpectDMA
# Argument: port - int - port for which read/write is occurring
#                   (Should be 1-4, NOT THE INDEX OF ARRAY)
#  A Getter that returns the file pointer for file with DMA read/write info.
#
############################
def fExpectDMA(port):
    return f_expectDMA[port-1]
