#!/usr/bin/env python


from NFTest import *
import os
from fcntl import *
from ctypes import *

# Loading the nf10_lib shared library
print "loading the nf10_lib library.."
lib_path=os.path.join( os.environ['NF_ROOT'], 'tools','lib','nf10_lib.so')
nf10_lib=cdll.LoadLibrary(lib_path)
#print nf10_lib

# argtypes for the functions called from  C
nf10_lib.regread.argtypes = [c_uint]
nf10_lib.regwrite.argtypes= [c_uint, c_uint]

def readReg(reg):
	nf10_lib.regread(reg)

def writeReg(reg, val):
	nf10_lib.regwrite(reg, val)

def regread_expect(reg, val):
	return nf10_lib.regread_expect(reg, val)
