#!/usr/bin/python
#############################################################
#
# Python register defines
#
# Project: Reference switch
# Description: Register map for Reference switch
#
#############################################################

def RESET_CNTRS():
    return 0x74800000

def SWITCH_OP_LUT_NUM_MISSES_REG():
    return 0x74800008

def SWITCH_OP_LUT_NUM_HITS_REG():
    return 0x74800004

def STDIN_BASEADDRESS():
    return 0x40600000

def STDOUT_BASEADDRESS():
    return 0x40600000

