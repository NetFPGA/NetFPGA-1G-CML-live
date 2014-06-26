/*******************************************************************************
 *
 *  NetFPGA-1G-CML http://www.netfpga.org
 *
 *  File:
 *        rdbpiaxi.c
 *
 *  Project:
 *        reference_flash_nf1_cml
 *
 *  Author:
 *        David Luman
 *
 *  Description:
 *        Test utility to read BPI-Flash register values.
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

#include <stdio.h>
#include "bpi_axi_util.h"
#include "pcie_axi_if.h"

int main(int argc, char* argv[])
{  
  uint64_t addr;
  uint64_t val;

  if(init_pcie_if() < 0)
  {
    printf("error opening nf10 driver !!\n\n");
    return 0;
  }

  if(argc != 2)
  {
    printf("usage: rdaxi reg_addr(in hex)\n\n");
    return 0;
  }
  else
  {
    sscanf(argv[1], "%llx", (long long unsigned int *)(&addr));
  }

  val = bpi_axi_rd(addr);

  printf("bpi_axi_rd addr: 0x%llX, val: 0x%llX\n", (long long unsigned int)addr, (long long unsigned int)val);

  stop_pcie_if();
  return 0;
}
