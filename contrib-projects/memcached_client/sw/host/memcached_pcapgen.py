#!/usr/bin/python

"""
Interactive .pcap generator for memcached requests

This script will guide you step by step to create a request and
expected response packet for a memcached server and will store it in a
.pcap file. You can then load this .pcap file into the Network Client
using the host support shell.

You can also use memlib direclty, see memlib_example.py
"""

import re
import subprocess
import logging
logging.getLogger('scapy.runtime').setLevel(logging.ERROR)
import scapy.all
import memlib

# -------------------------------------------------------------------------
# UI Helper Functions 
# -------------------------------------------------------------------------

def ask(cfg, property, question):
	print
	print question
	answer = raw_input("> ")
	if answer != '':
		cfg[property] = answer
	else:
		print("Invalid answer.")
		ask(cfg, property, question)

def askOpts(cfg, property, question, options):
	print
	print question
	for o in options:
		print "  " + o
	
	answer = raw_input("> ")
	if answer in options:
		cfg[property] = answer
	else:
		print "Invalid option."
		askOpts(cfg, property, question, options)

def askHex(cfg, property, question, digits):
	ask(cfg, property, question + " [%d digit hex number]" % digits)
	cfg[property] = cfg[property].upper()
	if len(cfg[property]) != digits:
		print "Invalid length."
		askHex(cfg, property, question, digits)
	elif not re.match('^[0-9a-fA-F]+$', cfg[property]):
		print "Invalid hex number."
		askHex(cfg, property, question, digits)

def askInt(cfg, property, question):
	ask(cfg, property, question + " [int]")
	try:
		cfg[property] = int(cfg[property])
	except ValueError:
		print "Invalid number."
		askInt(cfg, property, question)

def askRegexp(cfg, property, question, regexp, error):
	ask(cfg, property, question)
	if not re.match(regexp, cfg[property]):
		print error
		askRegexp(cfg, property, question, regexp, error)

# -------------------------------------------------------------------------
# Interactive Generator Dialog
# -------------------------------------------------------------------------

def askMemcached():
	"""Interactive memcached configuration generator."""
	cfg = {}

	askOpts(cfg, "type", "What type of request should be generated?",
		["set", "get", "delete", "flush"])

	if cfg['type'] != "flush":
		ask(cfg, "key", "What key should be used?")

	if cfg['type'] == "get" or cfg['type'] == "delete":
		askOpts(cfg, "success", "Should the request succeed?", ["yes", "no"])

	if cfg['type'] == "set" or (cfg['type'] == "get" and cfg['success'] == "yes"):
		ask(cfg, "value", "What value should be used?")
		askHex(cfg, "flags", "What is the 'flags' value?", 8)

	if cfg['type'] == "set":
		askInt(cfg, "expiration", "What expiration time should be used? [0 = infinite]")

	askOpts(cfg, "protocol", "What protocol should be used?", ["binary", "ascii", "mixed"])

	if cfg['protocol'] == "binary":
		askHex(cfg, "opaque", "What opaque value should be used in the binary request?", 8)

	if cfg['protocol'] == "mixed":
		askInt(cfg, "request-id", "What request ID should be used in the mixed request?")

	arp = subprocess.check_output(['arp', '-n'])
	lo  = subprocess.check_output(['ip', 'link'])
	ethhint = "\n" + arp + "\n" + lo

	askRegexp(cfg, "dst-ip", "What is the destination IP?",
		'^([0-9]{1,3}\.){3}[0-9]{1,3}$', "Invalid IP.")
	askInt(cfg, "dst-port", "What is the destination UDP port? [memcached = 11211]")
	askRegexp(cfg, "dst-mac", "What is the destination MAC address? [Hint: ARP cache/NIC list shown]" + ethhint,
		'^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$', "Invalid MAC address.")
	cfg['dst-mac'] = cfg['dst-mac'].upper().replace('-', ':')

	askRegexp(cfg, "src-ip", "What is the source IP?",
		'^([0-9]{1,3}\.){3}[0-9]{1,3}$', "Invalid IP.")
	askInt(cfg, "src-port", "What is the source UDP port?")
	askRegexp(cfg, "src-mac", "What is the source MAC address? [Hint: ARP cache/NIC list shown]\n" + ethhint,
		'^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$', "Invalid MAC address.")
	cfg['src-mac'] = cfg['src-mac'].upper().replace('-', ':')

	askOpts(cfg, "dont-fragment", "Set 'don't fragment (DF)' ethernet flag? [depends on host NIC]",
		["yes", "no"])

	ask(cfg, "file", "Where should the file be stored? [.pcap]")

	print
	print "This is a summary of your options:"
	order = [ 'type', 'success', 'key', 'value', 'flags', 'expiration',
		'protocol', 'opaque', 'request-id',
		'dst-ip', 'dst-port', 'dst-mac',
		'src-ip', 'src-port', 'src-mac',
		'dont-fragment', 'file' ]
	for o in order:
		try:
			print "%15s : %s" % (o, cfg[o])
		except KeyError:
			pass
	return cfg

# -------------------------------------------------------------------------
# Packet generator dispatcher
# -------------------------------------------------------------------------

def generateMemcached(cfg):
	"""Generate a memcached request and resonse."""
	request  = ""
	response = ""

	if cfg['type'] == "set":
		if cfg['protocol'] == "binary":
			request  = memlib.binarySetRequest(cfg, cfg['opaque'])
			response = memlib.binarySetResponse(cfg, cfg['opaque'])
		else:
			request  = memlib.textSetRequest(cfg)
			response = memlib.textSetResponse(cfg)

	elif cfg['type'] == "get":
		if cfg['protocol'] == "binary":
			request  = memlib.binaryGetRequest(cfg, cfg['opaque'])
			if cfg['success'] == "yes":
				response = memlib.binaryGetResponse(cfg, cfg['opaque'])
			else:
				response = memlib.binaryFailedGetResponse(cfg['opaque'])
		else:
			request  = memlib.textGetRequest(cfg)
			if cfg['success'] == "yes":
				response = memlib.textGetResponse(cfg)
			else:
				response = memlib.textFailedGetResponse()

	elif cfg['type'] == "delete":
		if cfg['protocol'] == "binary":
			request  = memlib.binaryDeleteRequest(cfg, cfg['opaque'])
			if cfg['success'] == "yes":
				response = memlib.binaryDeleteResponse(cfg, cfg['opaque'])
			else:
				response = memlib.binaryFailedDeleteResponse(cfg, cfg['opaque'])
		else:
			request  = memlib.textDeleteRequest(cfg)
			if cfg['success'] == "yes":
				response = memlib.textDeleteResponse(cfg)
			else:
				response = memlib.textFailedDeleteResponse(cfg)

	elif cfg['type'] == "flush":
		if cfg['protocol'] == "binary":
			request  = memlib.binaryFlushRequest(opaque=cfg['opaque'])
			response = memlib.binaryFlushResponse(cfg['opaque'])
		else:
			request  = memlib.textFlushRequest()
			response = memlib.textFlushResponse()

	if cfg['protocol'] == "mixed":
		request  = memlib.text2mixed(request, cfg['request-id'])
		response = memlib.text2mixed(response, cfg['request-id'])
	
	return (request.decode('hex'), response.decode('hex'))

def generateUdpIp(cfg, request, response):
	"""Generate a UPD/IP/Ethernet packet with the given payload."""
	if cfg['dont-fragment'] == "yes":
		flags = 2
	else:
		flags = 0

	request_packet = \
		scapy.all.Ether(dst=cfg['dst-mac'], src=cfg['src-mac']) / \
		scapy.all.IP(dst=cfg['dst-ip'], src=cfg['src-ip'], id=0, flags=flags) / \
		scapy.all.UDP(dport=cfg['dst-port'], sport=cfg['src-port']) / \
		scapy.all.Raw(request)

	response_packet = \
		scapy.all.Ether(dst=cfg['src-mac'], src=cfg['dst-mac']) / \
		scapy.all.IP(dst=cfg['src-ip'], src=cfg['dst-ip'], id=0, flags=flags) / \
		scapy.all.UDP(dport=cfg['src-port'], sport=cfg['dst-port']) / \
		scapy.all.Raw(response)
	
	return (request_packet, response_packet)

# -------------------------------------------------------------------------
# Standalone application
# -------------------------------------------------------------------------

if __name__ == "__main__":
	print "="*80
	print "Interactive Memcached Request/Response Generator"
	print "="*80
	cfg = askMemcached()
	(request, response) = generateMemcached(cfg)
	(request_packet, response_packet) = generateUdpIp(cfg, request, response)
	scapy.all.wrpcap(cfg['file'], [request_packet, response_packet])
	print
	print "Packets written to %s." % cfg['file']
