all : nf10util.o libnf10.so 

libnf10.so: nf10util.c nf10util.h nf_util.c nf_util.h
	gcc -fpic -c nf10util.c nf_util.c
	gcc -shared nf10util.o nf_util.o -o $@

clean :
	rm -rf nf10util.o nf_util.o libnf10.so

install: libnf10.so
	install -d /usr/local/lib
	install -m 644 libnf10.so /usr/local/lib
	ln -s -f /usr/local/lib/libnf10.so /usr/local/lib/libnf10regs.so
	ldconfig

.PHONY: clean 
