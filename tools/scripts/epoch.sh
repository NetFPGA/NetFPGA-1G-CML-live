#!/bin/bash

# max value that can be stored by a 32 bit signed integer is 2^31-1
EPOCH_MAX=2147483647

# get the epoch value 
EPOCH=$(date +%s)

# condition to check if overflow occurs
if [ $EPOCH -gt $EPOCH_MAX ] 
then
      reg_a=$EPOCH_MAX
      reg_b=`expr $EPOCH - $EPOCH_MAX`
else
      reg_a=$EPOCH
      reg_b=0	
fi

# here I want to print the values in a text file
printf "%x\n" "$reg_a" > rom_data.txt
printf "%x\n" "$reg_b" >> rom_data.txt
