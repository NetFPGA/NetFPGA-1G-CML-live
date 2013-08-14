/*******************************************************************************
 *
 *  NetFPGA-10G http://www.netfpga.org
 *
 *  File:
 *        nf10_flash_b.c
 *
 *  Library:
 *
 *
 *  Project:
 *        
 *
 *  Author:
 *        Jong Han
 *
 *  Description:
 *        
 *
 *  Copyright notice:
 *        Copyright (C) 2013 University of Cambridge
 *
 *  Licence:
 *        This file is part of the NetFPGA 10G development base package.
 *
 *        This file is free code: you can redistribute it and/or modify it under
 *        the terms of the GNU Lesser General Public License version 2.1 as
 *        published by the Free Software Foundation.
 *
 *        This package is distributed in the hope that it will be useful, but
 *        WITHOUT ANY WARRANTY; without even the implied warranty of
 *        MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *        Lesser General Public License for more details.
 *
 *        You should have received a copy of the GNU Lesser General Public
 *        License along with the NetFPGA source package.  If not, see
 *        http://www.gnu.org/licenses/.
 *
 *        This file was developed by SRI International and the University of
 *        Cambridge Computer Laboratory under DARPA/AFRL contract (FA8750-10-C-0237)
 *        ("CTSRD"), as part of the DARPA CRASH research programme.
 */

#include "reg_lib.h"
#include "emc_flash_lib.h"
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/ioctl.h>

#define NF10_IOCTL_CMD_WRITE_REG (SIOCDEVPRIVATE+1)
#define NF10_IOCTL_CMD_READ_REG (SIOCDEVPRIVATE+2)

int main ()
{
	int f, i;
	uint64_t v, addr, val0, val1;

	addr = 0x40000000;
	val0 = 0x1;
	val1 = 0x0;

	// Open device handle
	f = open("/dev/nf10", O_RDWR);
    	if (f < 0){
        	perror("/dev/nf10");
        	return 0;
    	}

	v = addr;

	if(ioctl(f, NF10_IOCTL_CMD_READ_REG, &v) < 0){
		perror("nf10 ioctl failed");
	return 0;
	}
	
	v &= 0xffffffff;

	if (v != 0x3) {
		printf ("Check HW or Driver, cannot load Flash B!");
	}
	else {
		printf("GPIO initial 0x%llx 0x%llx \n", addr, v);
		v = (addr << 32) + val0;
		if(ioctl(f, NF10_IOCTL_CMD_WRITE_REG, v) < 0){
		        perror("nf10 ioctl failed");
		        return 0;
		}
		for (i = 0; i < 4096; i++)
		v = (addr << 32) + val1;
		if(ioctl(f, NF10_IOCTL_CMD_WRITE_REG, v) < 0){
		        perror("nf10 ioctl failed");
		        return 0;
		}
		printf("FPGA is programmed with Flash B!\n");
	}

	close(f);

	return 0;
}
