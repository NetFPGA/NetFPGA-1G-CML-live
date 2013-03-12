
all:	nf10_switch

nf10_switch:
	gcc -march=core2 nf10_switch.c ../include/libsrc/nf10_switch_v1_00_a/src/nf10_switch_lib.c reg_lib.c -I . -I ../include/libsrc/nf10_switch_v1_00_a/src -I ../include -o nf10_switch

clean:
	rm -rf nf10_switch

