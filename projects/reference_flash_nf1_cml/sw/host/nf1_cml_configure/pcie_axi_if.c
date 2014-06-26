/*******************************************************************************
 *
 *  NetFPGA-1G-CML http://www.netfpga.org
 *
 *  File:
 *        pcie_axi_if.c
 *
 *  Project:
 *        reference_flash_nf1_cml
 *
 *  Author:
 *        David Luman
 *
 *  Description:
 *        Functions to access the FPGA AXI bus from the host PCIe bus.
 *
 *  Copyright notice:
 *        Copyright (C) 2014 Computer Measurement Laboratory
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
#include <unistd.h>
#include "pcie_axi_if.h"
 
// global so that it doesn't have to be returned to calling functions
int drvr;

int init_pcie_if(void)
{
  drvr = open("/dev/nf10", O_RDWR);
  if(drvr < 0){
    perror("/dev/nf10");
    return -1;
  }
  return(0);
}

int stop_pcie_if(void)
{  
  return(close(drvr));
}

void pcie_axi_wr(uint64_t addr, uint64_t val)
{
  uint64_t v;

  v = addr;
  v<<=32;
  v += val;
  if(ioctl(drvr, NF10_IOCTL_CMD_WRITE_REG, v) < 0)
  {
    perror("nf10 ioctl failed");
  }
}


void pcie_axi_rd(uint64_t *val)
{
  if(ioctl(drvr, NF10_IOCTL_CMD_READ_REG, val) < 0)
  {
    perror("nf10 ioctl failed");
  }
}
