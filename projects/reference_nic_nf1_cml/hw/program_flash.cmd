setMode -bs
setCable -port auto
Identify -inferir
identifyMPM
attachflash -position 1 -bpi "28F00AP30"
assignfiletoattachedflash -position 1 -file "smallbits.mcs"
Program -p 1 -dataWidth 16 -rs1 NONE -rs0 NONE -bpionly -e -v -loadfpga
closeCable
Quit

