/*******************************************************************************
 *
 *  NetFPGA-10G http://www.netfpga.org
 *
 *  File:
 *        netfpga10g_ver.c
 *
 *  Project:
 *        
 *
 *  Author:
 *        Jong Han
 *
 *  Description:
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
 */

#include <fcntl.h>
#include <sys/ioctl.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>

#define	ID_BASE_ADDR	0x6a000000

#define NF10_IOCTL_CMD_READ_REG (SIOCDEVPRIVATE+2)

int main()
{
    int f;
    uint64_t v, addr0, addr1, addr2, addr3, v_date, v_month, v_year, v_hour, v_min;
    uint64_t v_pro, v_tag_0, v_tag_1, v_tag_2;


	addr0 = ID_BASE_ADDR + 0x4;
	addr1 = ID_BASE_ADDR + 0x8;
	addr2 = ID_BASE_ADDR + 0xc;
	addr3 = ID_BASE_ADDR + 0x10;

	// Open device handle
	f = open("/dev/nf10", O_RDWR);
    	if (f < 0){
        	perror("/dev/nf10");
        	return 0;
    	}

	v = addr0;

	if(ioctl(f, NF10_IOCTL_CMD_READ_REG, &v) < 0){
		perror("nf10 ioctl failed");
	return 0;
	}
	
	//Read date, month, year when synthesised.	
	v &= 0xffffffff;
	v_year = (0xff & v);
	v_month = (0xffff & v) >> 8;
	v_date = (0xffffff & v) >> 16;

	printf("\nThis HW is implemented on %llx/%llx/20%llx (dd/mm/yy)\n", v_date, v_month, v_year);

	v = addr1;

	if(ioctl(f, NF10_IOCTL_CMD_READ_REG, &v) < 0){
		perror("nf10 ioctl failed");
	return 0;
	}

	//Read time when synthesised
	v &= 0xffffffff;
	v_min = (0xff & v);
	v_hour = (0xffff & v) >> 8;

	printf("at %llx:%llx (hour:min).\n", v_hour, v_min);

	//Read project
	v = addr2;

	if(ioctl(f, NF10_IOCTL_CMD_READ_REG, &v) < 0){
		perror("nf10 ioctl failed");
	return 0;
	}

	v &= 0xffffffff;
	v_pro = (0xffff & v);

	printf("Project name : %llx.\n", v_pro);

	switch (v_pro) {
		case 0xa : printf("The reference nic. \n"); break;
		case 0xb : printf("The reference switch. \n"); break;
		case 0xc : printf("The reference router. \n"); break;
		case 0xd : printf("The reference switch_lite. \n"); break;
		default : printf("No project identified!\n"); break;
	}

	//Read git tag 
	v = addr3;

	if(ioctl(f, NF10_IOCTL_CMD_READ_REG, &v) < 0){
		perror("nf10 ioctl failed");
	return 0;
	}

	v &= 0xffffffff;
	v_tag_0 = (0xf & v);
	v_tag_1 = (0xff & v) >> 4;
	v_tag_2 = (0xfff & v) >> 8;

	printf("NetFPGA GitHub Tag : %llx. %llx. %llx. \n", v_tag_2, v_tag_1, v_tag_0);

	close(f);

	return 0;
}
