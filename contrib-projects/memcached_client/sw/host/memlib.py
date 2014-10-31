#!/usr/bin/python

"""
memlib is a helper library to generate memached request and responses.

####################
FORMATTING A KV-PAIR
####################

# V1::

  ShortTest = memlib.kv_pair("k", "v", "DEADBEEF", 42)

# V2::

  Integration1 = {
  	"key"        : "this-is-the-key-that-i'll-be-using-for-the-next-time-to-test-the-longest-of-all-keys",
  	"value"      : "aaaaaaaabbbbbbbbccccccccddddddddeeeeeeeeffffffffgggggggghhhhhhhhiiiiiiiijjjjjjjjkkkkkkkkllllllllmmmmmmmmnnnnnnnnooooooooppppppppqqqqqqqqrrrrrrrrssssssssttttttttuuuuuuuuvvvvvvvvwwwwwwwwxxxxxxxxyyyyyyyyzzzzzzzz",
  	"flags"      : "0000002a",     # 32bit, hex-encoded
  	"expiration" : 13
  }

CREATING SINGLE REQUESTS
########################

Test
====

test::

  print "Binary Set Request"
  rq = memlib.binarySetRequest(Integration1, "aabbccdd")
  
  print "Binary Set Response"
  rq = memlib.binarySetResponse(Integration1, "aabbccdd")
  
  print "Binary Get Request"
  rq = memlib.binaryGetRequest(Integration1, "aabbccdd")
  
  print "Binary Get Response"
  rq = memlib.binaryGetResponse(Integration1, "aabbccdd")
  
  print "Useful functions"
  print ("%08x" % 42)
  print "Key".encode('hex')
"""

import sys

## kv_pair data structure ######################################################

# Example kv_pair: (key, value, flags, expiration)
ex_kv_pair = {
	"key"        : "ExampleKey",
	"value"      : "ExampleValue",
	"flags"      : "01234567",     # 32bit, hex-encoded
	"expiration" : 10
}

def kv_pair(key, value, flags, expiration):
	if (type(key) != str) | (type(value) != str) | (type(expiration) != int) | (type(flags) != str):
		raise Exception("Error: Wrong types for kv_pair")
	if len(flags) != 8:
		raise Exception("Error: Wrong flags length: %d. Should be 8." % len(flags))
	return {
		"key"        : key,
		"value"      : value,
		"flags"      : flags,
		"expiration" : expiration
	}

## binary protocol packet generators ###########################################

def binaryResponseTemplate(opcode, opaque, status="00"):
	magic             = "81"
	key_length_bin    = "0000"
	extras_length_bin = "00"
	data_type         = "00"
	status            = "00" + status
	body_length       = "00000000"
	cas               = "0000000000000000"

	response = magic + opcode + key_length_bin +        \
	           extras_length_bin + data_type + status + \
	           body_length +                            \
	           opaque +                                 \
	           cas
	
	return response

def binaryGetRequest(kv_pair, opaque="01234567"):
	if len(opaque) != 8:
		raise Exception("Error: Wrong opaque length: %d. Should be 8." % len(opaque))

	magic          = "80"
	opcode         = "00"
	key            = kv_pair["key"]
	key_bin        = key.encode('hex')
	key_length     = len(key)
	key_length_bin = "%04x" % key_length
	extras_length  = "00"
	data_type      = "00"
	vbucket_id     = "0000"
	body_length    = "%08x" % key_length
	cas            = "0000000000000000"

	request = magic + opcode + key_length_bin +        \
	          extras_length + data_type + vbucket_id + \
		  body_length +                            \
		  opaque +                                 \
		  cas +                                    \
		  key_bin
	
	return request

def binaryFailedGetResponse(opaque="01234567"):
	magic             = "81"
	opcode            = "00"
	key_length_bin    = "0000"
	extras_length_bin = "00"
	data_type         = "00"
	status            = "0001"
	body_length       = "00000008"
	cas               = "0000000000000000"
	message           = "ERROR 01".encode('hex')

	response = magic + opcode + key_length_bin +        \
	           extras_length_bin + data_type + status + \
	           body_length +                            \
	           opaque +                                 \
	           cas +                                    \
		   message
	
	return response

def binaryGetResponse(kv_pair, opaque="01234567"):
	if len(opaque) != 8:
		raise Exception("Error: Wrong opaque length: %d. Should be 8." % len(opaque))

	magic             = "81"
	opcode            = "00"
	key_length_bin    = "0000"
	extras            = kv_pair["flags"]
	extras_length     = len(extras) / 2
	extras_length_bin = "%02x" % extras_length
	data_type         = "00"
	status            = "0000"
	value             = kv_pair["value"]
	value_bin         = value.encode('hex')
	value_length      = len(value)
	body_length       = "%08x" % (extras_length + value_length)
	cas               = "0000000000000000"

	response = magic + opcode + key_length_bin +        \
	           extras_length_bin + data_type + status + \
	           body_length +                            \
	           opaque +                                 \
	           cas +                                    \
	           extras +                                 \
	           value_bin
	
	return response

def binarySetRequest(kv_pair, opaque="01234567"):
	if len(opaque) != 8:
		raise Exception("Error: Wrong opaque length: %d. Should be 8." % len(opaque))

	magic          = "80"
	opcode         = "01"
	key            = kv_pair["key"]
	key_bin        = key.encode('hex')
	key_length     = len(key)
	key_length_bin = "%04x" % key_length
	extras_length  = "08"
	data_type      = "00"
	vbucket_id     = "0000"
	value          = kv_pair["value"]
	value_bin      = value.encode('hex')
	value_length   = len(value)
	body_length    = "%08x" % (key_length + value_length + 8)
	cas            = "0000000000000000"
	flags          = kv_pair["flags"]
	expiration     = kv_pair["expiration"]
	expiration_bin = "%08x" % expiration
	extras         = flags + expiration_bin

	request = magic + opcode + key_length_bin +        \
	          extras_length + data_type + vbucket_id + \
		  body_length +                            \
		  opaque +                                 \
		  cas +                                    \
		  extras +                                 \
		  key_bin +                                \
		  value_bin
	
	return request

def binarySetResponse(kv_pair, opaque="01234567"):
	if len(opaque) != 8:
		raise Exception("Error: Wrong opaque length: %d. Should be 8." % len(opaque))
	return binaryResponseTemplate("01", opaque)

def binaryDeleteRequest(kv_pair, opaque="01234567"):
	if len(opaque) != 8:
		raise Exception("Error: Wrong opaque length: %d. Should be 8." % len(opaque))

	magic          = "80"
	opcode         = "04"
	key            = kv_pair["key"]
	key_bin        = key.encode('hex')
	key_length     = len(key)
	key_length_bin = "%04x" % key_length
	extras_length  = "00"
	data_type      = "00"
	vbucket_id     = "0000"
	body_length    = "%08x" % key_length
	cas            = "0000000000000000"

	request = magic + opcode + key_length_bin +        \
	          extras_length + data_type + vbucket_id + \
		  body_length +                            \
		  opaque +                                 \
		  cas +                                    \
		  key_bin
	
	return request

def binaryFailedDeleteResponse(kv_pair, opaque="01234567"):
	if len(opaque) != 8:
		raise Exception("Error: Wrong opaque length: %d. Should be 8." % len(opaque))

	magic             = "81"
	opcode            = "04"
	key_length_bin    = "0000"
	extras_length_bin = "00"
	data_type         = "00"
	status            = "0001"
	body_length       = "00000008"
	cas               = "0000000000000000"
	message           = "ERROR 01".encode('hex')

	response = magic + opcode + key_length_bin +        \
	           extras_length_bin + data_type + status + \
	           body_length +                            \
	           opaque +                                 \
	           cas +                                    \
		   message
	
	return response

def binaryDeleteResponse(kv_pair, opaque="01234567"):
	if len(opaque) != 8:
		raise Exception("Error: Wrong opaque length: %d. Should be 8." % len(opaque))
	return binaryResponseTemplate("04", opaque)

def binaryFlushRequest(expiration=0, opaque="01234567"):
	if len(opaque) != 8:
		raise Exception("Error: Wrong opaque length: %d. Should be 8." % len(opaque))
	
	if(expiration!=0):
		extras_length = "04"
		expiration_bin = "%08x" % expiration
		body_length   = "00000004"

	magic          = "80"
	opcode         = "08"
	key_length_bin = "0000"
	extras_length  = "00"
	data_type      = "00"
	vbucket_id     = "0000"
	body_length    = "00000000"
	cas            = "0000000000000000"
	expiration_bin = ""

	if(expiration!=0):
		extras_length  = "04"
		body_length    = "00000004"
		expiration_bin = "%08x" % expiration

	request = magic + opcode + key_length_bin +        \
	          extras_length + data_type + vbucket_id + \
		  body_length +                            \
		  opaque +                                 \
		  cas +                                    \
		  expiration_bin
	
	return request

def binaryFlushResponse(opaque="01234567"):
	if len(opaque) != 8:
		raise Exception("Error: Wrong opaque length: %d. Should be 8." % len(opaque))
	return binaryResponseTemplate("08", opaque)

## text protocol packet generators #############################################

def textSetRequest(kv_pair):
	txt_req = "set %s %d %d %d\r\n%s\r\n" % (
		kv_pair['key'],
		int(kv_pair['flags'], 16),
		kv_pair['expiration'],
		len(kv_pair['value']),
		kv_pair['value'])
	return txt_req.encode('hex')

def textSetResponse(kv_pair):
	return "STORED\r\n".encode('hex')

def textGetRequest(kv_pair):
	txt_req = "get %s\r\n" % kv_pair['key']
	return txt_req.encode('hex')

def textGetResponse(kv_pair):
	txt_res = "VALUE %s %d %d\r\n%s\r\nEND\r\n" % (
		kv_pair['key'],
		int(kv_pair['flags'], 16),
		len(kv_pair['value']),
		kv_pair['value'])
	return txt_res.encode('hex')

def textFailedGetResponse():
	return "END\r\n".encode('hex')

def textDeleteRequest(kv_pair):
	txt_req = "delete %s\r\n" % kv_pair['key']
	return txt_req.encode('hex')

def textDeleteResponse(kv_pair):
	return "DELETED\r\n".encode('hex')

def textFailedDeleteResponse(kv_pair):
	return "NOT_FOUND\r\n".encode('hex')

def textFlushRequest():
	return "flush_all\r\n".encode('hex')

def textFlushResponse():
	return "OK\r\n".encode('hex')

## mixed protocol converter (from text) ########################################

def text2mixed(txt_rq, rq_id=0):
	frame = "%04x000000010000" % rq_id
	return (frame + txt_rq)
