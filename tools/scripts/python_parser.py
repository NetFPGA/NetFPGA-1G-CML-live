#!/usr/bin/python

# Description:
# This python parser takes the xpararamters.h file generated
# by doing a "make xparam" at the hw folder inside the project
# of your interest. xparameter.h file should be given as input 
# to this file by placing it in this folder. Then when you run
# this script, it will generate the reg_defines.py file which 
# can be used by the HW tests to access the registers by placing
# them inside the project specific python lib 
# (ex: xyz_proj/lib/Python/). Please remember to suffix the name
# of the project after reg_defines.py (ex: reg_defines_xyz_proj.py)
# only then the test scripts can recognize this file.


import re

inputfile=open('xparameters.h',"r")
str1=inputfile.read()
inputfile.close()

for line in str1:
	match = re.compile(r'\s*#define ([a-zA-Z_0-9]+) (.*)')
	str2=match.sub(r'\ndef \1():\n    return \2\n', str1)
outputfile=open("temp.py","w")
outputfile.write(str2)
outputfile.close()

regdefinesfile=open('temp.py',"r")
str3=regdefinesfile.read()
regdefinesfile.close()

for line in str3:
	match =	re.compile(r'\s*[/\*][\s*\*](.*)')
	str4=match.sub(r'\n# \1\n',str3)
outputfile1=open("reg_defines.py","w")
outputfile1.write("#!/usr/bin/python")
outputfile1.write(str4)
outputfile1.close()
