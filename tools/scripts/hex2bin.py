#!/usr/bin/python

input_file = open("rom_data.txt", "r")
output_file = open("id_rom16x32.mif", "w")
scale = 16 ## equals to hexadecimal
num_of_bits = 32

for line in input_file:
    newline1= bin(int(line, scale))[2:].zfill(num_of_bits)+ "\n"
    output_file.write(newline1)


