#!/bin/env python

import os
import sys
from NFTest import *
from ctypes import *
from reg_defines_reference_switch import *

# Loading the nf10_lib shared library
print "loading the nf10_lib library.."
lib_path=os.path.join( os.environ['NF_ROOT'], 'tools','lib','nf10_lib.so')
nf10_lib=cdll.LoadLibrary(lib_path)
print nf10_lib


# argtypes for the functions called from  C
nf10_lib.regread.argtypes = [c_uint]
nf10_lib.regwrite.argtypes= [c_uint, c_uint]

# asserting the reset_counter to 1 for clearing the registers
nf10_lib.regwrite(RESET_CNTRS(), 0x1)

# asseting teh reset_counter to 0 for enable the counters to increment
nf10_lib.regwrite(RESET_CNTRS(), 0x0)

# Initially we expect 0 packets in both the lut_hit and lut_miss registers
rres1= nf10_lib.regread_expect(SWITCH_OP_LUT_NUM_HITS_REG(), 0x0)
rres2=nf10_lib.regread_expect(SWITCH_OP_LUT_NUM_MISSES_REG(), 0x0)



phy2loop0 = ('../connections/conn', [])

nftest_init(sim_loop = [], hw_config = [phy2loop0])
nftest_start()

routerMAC = []
routerIP = []
for i in range(4):
    routerMAC.append("00:ca:fe:00:00:0%d"%(i+1))
    routerIP.append("192.168.%s.40"%i)

num_broadcast = 10

pkts = []
for i in range(num_broadcast):
    pkt = make_IP_pkt(src_MAC="aa:bb:cc:dd:ee:ff", dst_MAC=routerMAC[0],
                      src_IP="192.168.0.1", dst_IP="192.168.1.1", pkt_len=100)

    nftest_send_phy('nf0', pkt)
    nftest_expect_phy('nf1', pkt)
    if not isHW():
        nftest_expect_phy('nf2', pkt)
        nftest_expect_phy('nf3', pkt)



nftest_barrier()

num_normal = 10

for i in range(num_normal):
    pkt = make_IP_pkt(dst_MAC="aa:bb:cc:dd:ee:ff", src_MAC=routerMAC[1],
                     src_IP="192.168.0.1", dst_IP="192.168.1.1", pkt_len=100)

    nftest_send_phy('nf1', pkt)
    nftest_expect_phy('nf0', pkt)

nftest_barrier()

# Now we expect to see the lut_hit and lut_miss registers incremented and we
# verify this by doing a  reg
rres3= nf10_lib.regread_expect(SWITCH_OP_LUT_NUM_HITS_REG(), 0xa)
rres4= nf10_lib.regread_expect(SWITCH_OP_LUT_NUM_MISSES_REG(), 0xa)


# List containing the return values of the reg_reads
mres=[rres1,rres2,rres3,rres4]

nftest_finish(mres)

