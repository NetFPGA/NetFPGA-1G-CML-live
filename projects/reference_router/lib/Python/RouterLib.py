from NFTest import *
from NFTest.hwRegLib import regread
import NFTest.simReg

import sys
import os

import re

import socket
import struct


from ctypes import *
from reg_defines_reference_router import *


################################################################
#
# Setting and getting the router MAC addresses
#
################################################################
def set_router_MAC(port, MAC):
	port = int(port)
	if port < 1 or port > 4:
		print 'bad port number'
		sys.exit(1)
	mac = MAC.split(':')
	mac_hi = int(mac[0],16)<<8 | int(mac[1],16)
	mac_lo = int(mac[2],16)<<24 | int(mac[3],16)<<16 | int(mac[4],16)<<8 | int(mac[5],16)

	port -= 1

	nftest_regwrite(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_MAC_0_HIGH() + port * 8, mac_hi)
	nftest_regwrite(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_MAC_0_LOW() + port * 8, mac_lo)

def get_router_MAC(port, MAC):
	port = int(port)
	if port < 1 or port > 4:
		print 'bad port number'
	port -= 1
	mac_hi = nftest_regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_MAC_0_HIGH() + port * 8)
	mac_lo = nftest_regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_MAC_0_LOW() + port * 8)
	mac_tmp = "%04x%08x"%(mac_hi, mac_lo)
        grp_mac = re.search("^(..)(..)(..)(..)(..)(..)$", mac_tmp).groups()
        str_mac = ''
        for octet in grp_mac:
            str_mac += grp_mac + ":"
        str_mac.rstrip(':')
	return str_mac

################################################################
#
# LPM table stuff
#
################################################################
def add_LPM_table_entry(index, IP, mask, next_IP, next_port):
        if index < 0 or index > XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_ROUTE_TABLE_DEPTH() - 1 or next_port < 0 or next_port > 255:
                print 'Bad data'
                sys.exit(1)
        if re.match("(\d+)\.", IP):
                IP = dotted(IP)
        if re.match("(\d+)\.", mask):
                mask = dotted(mask)
        if re.match("(\d+)\.", next_IP):
                next_IP = dotted(next_IP)
	nftest_regwrite(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_LPM_IP(), IP)
	nftest_regwrite(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_LPM_IP_MASK(), mask)
	nftest_regwrite(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_LPM_NEXT_HOP_IP(), next_IP)
	nftest_regwrite(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_LPM_OQ(), next_port)
	nftest_regwrite(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_LPM_WR_ADDR(), index)

def check_LPM_table_entry(index, IP, mask, next_IP, next_port):
	if index < 0 or index > XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_ROUTE_TABLE_DEPTH() - 1 or next_port < 0 or next_port > 255:
		print 'Bad data'
		sys.exit(1)
        if re.match("(\d+)\.", IP):
		IP = dotted(IP)
        if re.match("(\d+)\.", IP):
		mask = dotted(mask)
        if re.match("(\d+)\.", IP):
		next_IP = dotted(next_IP)

	nftest_regwrite(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_LPM_RD_ADDR(), index)
	nftest_regread_expect(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_LPM_IP(), IP)
	nftest_regread_expect(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_LPM_IP_MASK(), mask)
	nftest_regread_expect(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_LPM_NEXT_HOP_IP(), next_IP)
	nftest_regread_expect(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_LPM_OQ(), next_port)

def invalidate_LPM_table_entry(index):
	if index < 0 or index > XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_ROUTE_TABLE_DEPTH()-1:
		print 'Bad data'
		sys.exit(1)
	nftest_regwrite(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_LPM_IP(), 0)
	nftest_regwrite(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_LPM_IP_MASK(), 0xffffffff)
	nftest_regwrite(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_LPM_NEXT_HOP_IP(), 0)
	nftest_regwrite(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_LPM_OQ(), 0)
	nftest_regwrite(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_LPM_WR_ADDR(), index)

def get_LPM_table_entry(index):
	if index < 0 or index > XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_ROUTE_TABLE_DEPTH() - 1:
		print 'get_LPM_table_entry_generic: Bad data'
		sys.exit(1)
	nftest_regwrite(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_LPM_RD_ADDR(), index)	
	IP = nftest_regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_LPM_IP())
	mask = nftest_regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_LPM_IP_MASK())
	next_hop = nftest_regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_LPM_NEXT_HOP_IP())
	output_port = nftest_regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_LPM_OQ())

	ip_str = socket.inet_ntoa(struct.pack('!L', IP))
	mask_str = socket.inet_ntoa(struct.pack('!L', mask))
	next_hop_str = socket.inet_ntoa(struct.pack('!L', next_hop))
	return ip_str + '-' + mask_str + '-' + next_hop_str + "-0x%02x"%output_port

################################################################
#
# Destination IP filter table stuff
#
################################################################
def add_dst_ip_filter_entry(index, IP):
        if index < 0 or index > XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_ROUTE_TABLE_DEPTH() - 1:
                print 'Bad data'
                sys.exit(1)
        if re.match("(\d+)\.", IP):
                IP = dotted(IP)
	nftest_regwrite(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_FILTER_IP(), IP)
	nftest_regwrite(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_FILTER_WR_ADDR(), index)

def invalidate_dst_ip_filter_entry(index):
	if index < 0 or index > XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_DST_IP_FILTER_TABLE_DEPTH()-1:
		print 'Bad data'
		sys.exit(1)
	nftest_regwrite(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_FILTER_IP(), 0)
	nftest_regwrite(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_FILTER_WR_ADDR(), index)

def get_dst_ip_filter_entry(index):
	if index < 0 or index > XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_DST_IP_FILTER_TABLE_DEPTH()-1:
		print 'Bad data'
		sys.exit(1)
	nftest_regwrite(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_FILTER_RD_ADDR(), index)
	return nftest_regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_FILTER_IP())


################################################################
#
# ARP stuff
#
################################################################
def add_ARP_table_entry(index, IP, MAC):
        if index < 0 or index > XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_ARP_TABLE_DEPTH()-1:
                print 'Bad data'
                sys.exit(1)
        if re.match("(\d+)\.", IP):
                IP = dotted(IP)
        mac = MAC.split(':')
        mac_hi = int(mac[0],16)<<8 | int(mac[1],16)
        mac_lo = int(mac[2],16)<<24 | int(mac[3],16)<<16 | int(mac[4],16)<<8 | int(mac[5],16)
	nftest_regwrite(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_ARP_IP(), IP)
	nftest_regwrite(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_ARP_MAC_HIGH(), mac_hi)
	nftest_regwrite(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_ARP_MAC_LOW(), mac_lo)
	nftest_regwrite(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_ARP_WR_ADDR(), index)

def invalidate_ARP_table_entry(index):
        if index < 0 or index > XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_ARP_TABLE_DEPTH()-1:
                print 'Bad data'
                sys.exit(1)
	nftest_regwrite(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_ARP_IP(), 0)
	nftest_regwrite(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_ARP_MAC_HIGH(), 0)
	nftest_regwrite(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_ARP_MAC_LOW(), 0)
	nftest_regwrite(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_ARP_WR_ADDR(), index)

def check_ARP_table_entry(index, IP, MAC):
	if index < 0 or index > XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_ARP_TABLE_DEPTH() - 1:
		print 'check_ARP_table_entry: Bad data'
		sys.exit(1)
        if re.match("(\d+)\.", IP):
                IP = dotted(IP)
	mac = MAC.split(':')
	mac_hi = int(mac[0],16)<<8 | int(mac[1],16)
	mac_lo = int(mac[2],16)<<24 | int(mac[3],16)<<16 | int(mac[4],16)<<8 | int(mac[5],16)
	nftest_regwrite(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_LPM_RD_ADDR(), index)
	nftest_regread_expect(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_ARP_IP(), IP)
	nftest_regread_expect(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_ARP_MAC_HIGH(), mac_hi)
	nftest_regread_expect(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_ARP_MAC_LOW(), mac_lo)

def get_ARP_table_entry(index):
	if index < 0 or index > XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_ARP_TABLE_DEPTH()-1:
		print 'check_ARP_table_entry: Bad data'
		sys.exit(1)
	nftest_regwrite(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_ARP_RD_ADDR(), index)
	IP = nftest_regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_ARP_IP())
	mac_hi = nftest_regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_ARP_MAC_HIGH())
	mac_lo = nftest_regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_ARP_MAC_LOW())

	IP_str = socket.inet_ntoa(struct.pack('!L', IP))
	mac_tmp = "%04x%08x"%(mac_hi, mac_lo)
        grp_mac = re.search("^(..)(..)(..)(..)(..)(..)$", mac_tmp).groups()
        str_mac = ''
        for octet in grp_mac:
            str_mac += octet + ":"
        str_mac = str_mac.rstrip(':')
	return IP_str + '-' + str_mac


################################################################
#
# Misc routines
#
################################################################
def dotted(strIP):
	octet = strIP.split('.')
	newip = int(octet[0])<<24 | int(octet[1])<<16 | int(octet[2])<<8 | int(octet[3])
	return newip
