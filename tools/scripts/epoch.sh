#!/bin/sh

EPOCH=`date +%s`

printf "%016x\n" ${EPOCH} | cut -c9-16 > rom_data.txt
printf "%016x\n" ${EPOCH} | cut -c1-8  >> rom_data.txt

# end

