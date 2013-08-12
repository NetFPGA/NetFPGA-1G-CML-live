#!/usr/bin/env python


import os
from fcntl import *
from struct import *
from reg_defines_reference_nic import *

SIOCDEVPRIVATE = 35312
NF10_IOCTL_CMD_READ_STAT = SIOCDEVPRIVATE + 0
NF10_IOCTL_CMD_WRITE_REG = SIOCDEVPRIVATE + 1
NF10_IOCTL_CMD_READ_REG = SIOCDEVPRIVATE + 2

def readReg(reg):
    f = open("/dev/nf10", "r+")
    arg = pack("q", int(reg, 16))
    value = ioctl(f, NF10_IOCTL_CMD_READ_REG, arg)
    value = unpack("q", value)
    value = value[0]
    value = hex(value & int("0xffffffff", 16))
    f.close()
    print value
    return value

def writeReg(reg, val):

    f = open("/dev/nf10", "r+")
    arg = (int(addr, 16) << 32) + int(value, 16)
    arg = pack("q", arg)
    ioctl(f, NF10_IOCTL_CMD_WRITE_REG, arg)
    f.close()

