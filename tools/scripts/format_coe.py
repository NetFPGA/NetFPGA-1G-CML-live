#!/usr/bin/env python
import subprocess
cmd=[""" cat rom_data.txt | wc -l """]
no_of_lines=subprocess.check_output(cmd,shell=True)
print no_of_lines

input_file = open("rom_data.txt", "r")
output_file = open("id_rom16x32.coe", "w")
output_file.write("memory_initialization_radix=16;\n")
output_file.write("memory_initialization_vector=\n")

line_no = 0
for line in input_file:
	line_no += 1
	b=len(line)
	line = line.strip()
	zeros=9-b
	pad='0'*zeros
	if line_no == 16: # To track the last element of the rom
		final= pad+line+';'
	else:
		final= pad+line+','
	output_file.write(final+"\n")

	
