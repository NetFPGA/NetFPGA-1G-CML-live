/*******************************************************************************
 *
 *  NetFPGA-1G-CML http://www.netfpga.org
 *
 *  File:
 *        nf10_switch.c
 *
 *  Library:
 *        stdio.h, stdlib.h, string.h ctype.h
 *
 *  Project:
 *        reference_switch_lite_nf1-cml
 *
 *  Author:
 *        Muhammad Shahbaz
 *        David Van Arnem
 *
 *  Description:
 *        Host software that communicates with the NetFPGA-1G-CML
 *        using the nf10 device driver.
 *
 *  Copyright notice:
 *        Copyright (C) 2010, 2011 University of Cambridge
 *        Copyright (C) 2013 Computer Measurement Laboratory
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
 */

#include "reg_lib.h"
#include "nf10_switch_lib.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/ioctl.h>

int main (int argc, char **argv)
{
	int dev = -1;

	// Open device handle
	dev = open("/dev/nf10", O_RDWR);
    	if(dev < 0){
       		perror("/dev/nf10");
       		return 0;
    	}

    // defined in <repository>/lib/sw/std/drivers/nf10_switch_v1_00_a/src/nf10_switch_lib.c
	run(dev);

	// Close device handle
	close(dev);

	return 0;
}
