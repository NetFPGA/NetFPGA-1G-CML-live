#!/usr/bin/python

"""Network Client NT01 Host Support Shell/Library"""

import sys
import code
import serial
import time
import re
import types

import logging
logging.getLogger('scapy.runtime').setLevel(logging.ERROR)
import scapy.all

# If you use this in your own code, you will need to set host.s
# s = serial.Serial(port='/dev/ttyUSB0', timeout=0.5)
s = None

def probe():
	"""Return True if NT01 prompt is available."""
	s.flushInput()
	s.write('v')
	return s.read(1000) == '\r\nNT01\r\n> '

def writeBuffersPCAP(send_pcap, send_index=0, check_pcap=None, check_index=1):
	"""Set the client's buffers from a .pcap capture file.

	If no check_pcap is provided, the first two entires in send_pcap are used.

	:param send_pcap:   Filename of source pcap for send buffer.
	:param send_index:  Index into send_pcap.
	:param check_pcap:  Filename of source pcap for check buffer.
	:param check_index: Index into send_pcap.
	"""
	if(check_pcap==None):
		check_pcap = send_pcap

	send  = scapy.all.rdpcap(send_pcap)
	check = scapy.all.rdpcap(check_pcap)
	writeBuffers(str(send[send_index]), str(check[check_index]))

def writeBuffers(send_buffer, check_buffer):
	"""Set the client's buffers to the given binary strings."""
	writeBuffersHex(
		send_buffer.encode('hex'),
		check_buffer.encode('hex'))

def writeBuffersHex(send_buffer, check_buffer):
	"""Set the client's buffers to the given hex strings."""
	if(len(send_buffer) < 120):
		print >> sys.stderr, "NOTE: send_buffer will be padded to a minimal of 60B."
		# happens on the microblaze
	if(len(check_buffer) < 120):
		print >> sys.stderr, "NOTE: check_buffer will be padded to a minimal of 60B."
		# happens on the microblaze
	if(len(send_buffer) > 1518*2):
		print >> sys.stderr, "NOTE: send_buffer truncated to a maximum of 1518B."
		send_buffer = send_buffer[:(1518*2)]
	if(len(check_buffer) > 1518*2):
		print >> sys.stderr, "NOTE: check_buffer truncated to a maximum of 1518B."
		check_buffer = check_buffer[:(1518*2)]

	s.flushInput()
	s.write('l')

	while len(send_buffer) > 0:
		s.write(send_buffer[:10])
		print "%4dB remaining" % ((len(send_buffer) + len(check_buffer))/2)
		send_buffer = send_buffer[10:]
		time.sleep(0.05)
	s.write('\r\n')
	s.flushInput()

	while len(check_buffer) > 0:
		s.write(check_buffer[:10])
		print "%4dB remaining" % ((len(send_buffer) + len(check_buffer))/2)
		check_buffer = check_buffer[10:]
		time.sleep(0.05)
	s.write('\r\n')
	s.flushInput()

def readBuffersPCAP(file):
	"""Write the client's buffers into a .pcap capture file."""
	buffers = readBuffers()
	scapy.all.wrpcap(file, [scapy.all.Raw(buffers[0]), scapy.all.Raw(buffers[1])])

def readBuffers():
	"""Return the client's buffers as binary strings.
	
	:return: tuple (send_buffer, check_buffer)
	"""
	buffers = readBuffersHex()
	return (buffers[0].decode('hex'), buffers[1].decode('hex'))

def readBuffersHex():
	"""Return the client's buffers as hex strings.
	
	:return: tuple (send_buffer, check_buffer)
	"""
	s.flushInput()
	s.write('d')
	lines = s.read(10000).split('\r\n')
	return (lines[1][13:], lines[2][13:])

def readStats():
	"""Return the client's traffic statistics.
	
	:return: Array with a dictionary for each client.
	         The following fields are defined: tx, rx_match, rx_fail.
	"""
	s.flushInput()
	s.write('s')
	lines = s.read(1000).split('\r\n')
	line1 = {
		'tx'       : int(re.search('TX [0-9]+', lines[1]).group(0)[3:]),
		'rx_match' : int(re.search('RX Match [0-9]+', lines[1]).group(0)[9:]),
		'rx_fail'  : int(re.search('RX Fail [0-9]+', lines[1]).group(0)[8:]),
	}
	line2 = {
		'tx'       : int(re.search('TX [0-9]+', lines[2]).group(0)[3:]),
		'rx_match' : int(re.search('RX Match [0-9]+', lines[2]).group(0)[9:]),
		'rx_fail'  : int(re.search('RX Fail [0-9]+', lines[2]).group(0)[8:]),
	}
	return [ line1, line2 ]

def resetStats():
	"""Reset traffic statistics."""
	s.write('x')
	s.flushInput()

def setInterFrameGap(i):
	"""Set the packet inter frame gap (number of cycles @ 160MHz)."""
	if i < 2:
		print "i < 2 too small. Setting i=2."
		i = 2
	
	s.write('g')
	s.flushInput()
	s.write("%08x" % i)
	s.flushInput()

def burst():
	"""Send a packet burst (count dependant on frame size)."""
	s.write('b')
	s.flushInput()

def start():
	"""Start traffic."""
	s.write('r')
	s.flushInput()

def oneshotLatency():
	"""Send a single packet and measure the latency.

	:returns: Latency cycle count @ 160MHz.
	"""
	s.flushInput()
	s.write('o')
	s.readline()
	timeout = s.timeout
	s.timeout = 6
	c1 = int(re.search('[0-9]+ cycles', s.readline()).group(0)[:-7])
	c2 = int(re.search('[0-9]+ cycles', s.readline()).group(0)[:-7])
	s.timeout = timeout
	#return [c1_cycles, c2_cycles]
	return [ { 'cycles' : c1,
	           'time'   : "%.2f us" % (c1 / 160.0) },
	         { 'cycles' : c2,
	           'time'   : "%.2f us" % (c2 / 160.0) } ]

def stop():
	"""Stop traffic."""
	s.write('h')
	s.flushInput()

def initialize():
	"""Initialize the NetFPGA's PHYs."""
	s.write('i')
	time.sleep(9)
	print "done"

def status():
	"""Report the client's PHY status.
	
	:return: Array with status for each client's link.
	"""
	s.flushInput()
	s.write('p')
	lines = s.read(1000).split('\r\n')
	client0 = {
		'client' : 0,
		'phy'    : 0,
		'status' : lines[1][6:]
	}
	client1 = {
		'client' : 1,
		'phy'    : 3,
		'status' : lines[4][6:]
	}
	return [client0, client1]

def setSerialPort(port):
	"""Set serial port to be used."""
	global s
	s = serial.Serial(port=port, timeout=0.5)

def help():
	"""Display this help message."""
	functions = [f for f in globals().values() if type(f) == types.FunctionType]
	functions.sort(key=lambda f: f.__name__)
	func_dict = { f.__name__ : f for f in functions }

	print "The following functions can be used to interact with the client:"
	for f in functions:
		print "  %-16s : %s" % (f.__name__, f.__doc__.split('\n')[0])
	print "Type 'help(funcname)' for more details."

if __name__ == '__main__':
	print "=" * 80
	print "Network Client NT01 Host Support"
	print "=" * 80
	print

	port = raw_input("Please specify serial port (e.g. /dev/ttyUSB0 or COM1): ")
	setSerialPort(port)

	print
	help()

	print
	print "This is an interactive python shell."
	print "You can also import this file as a module into your own script."
	print "Type 'pydoc " + __file__ + "' in your shell for documentation."

	functions = [f for f in globals().values() if type(f) == types.FunctionType]
	functions.sort(key=lambda f: f.__name__)
	func_dict = { f.__name__ : f for f in functions }
	code.interact(banner="", local=func_dict)
