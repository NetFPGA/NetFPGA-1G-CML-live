#!/usr/bin/python

"""Example script for automated testing using NetFPGA testclient."""

import host
import time

print "This script performs a latency test on the NetFPGA."
print "Using serial port: /dev/ttyUSB0"

host.setSerialPort('/dev/ttyUSB0')

if not host.probe():
	print "Client not responding on port."
else:
	print "Client available on port."
	print "Loading the following test: loopback.pcap"
	host.writeBuffersPCAP('loopback.pcap')
	time.sleep(0.5)

	print "Sending packet..."
	host.resetStats()
	time.sleep(0.5)
	result = host.oneshotLatency()
	print "Latency Client 0:", result[0]['time']
	print "Latency Client 1:", result[1]['time']
	stats = host.readStats()
	if stats[0]['rx_match'] == 1:
		print "Client 0: response DOES match expected packet."
	else:
		print "Client 0: response DOES NOT match expected packet."
	if stats[1]['rx_match'] == 1:
		print "Client 1: response DOES match expected packet."
	else:
		print "Client 1: response DOES NOT match expected packet."
