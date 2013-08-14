
CFLAGS = -g
CC = gcc

# Location of binary files
BINDIR ?= /usr/local/bin

INSTALL_PREFIX ?= /usr/local

# Location of common files
COMMON = ../common

all : common cli

common : 
	$(MAKE) -C $(COMMON)

cli : cli.o ../common/nf10util.o

clean :
	rm -f cli *.o

install:

.PHONY: all clean install
