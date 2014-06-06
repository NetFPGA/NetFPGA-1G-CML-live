/*******************************************************************************
 *
 *  NetFPGA-1G-CML http://www.netfpga.org
 *
 *  File:
 *        prg_bpi.c
 *
 *  Project:
 *        reference_flash_nf1_cml
 *
 *  Author:
 *        David Luman
 *
 *  Description:
 *        Programs BPI-Flash over PCIe.
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
#include "pcie_axi_if.h"
#include "bpi_axi_util.h"
#include "icap_util.h"

int main(int argc, char* argv[])
{  
  uint16_t data;  
  FILE     *fp;
  char  filename[1025];
  uint32_t base_addr = 0;

  printf("built %s on %s\n\n", __TIME__, __DATE__);
  if(init_pcie_if() < 0)
  {
    printf("error opening nf10 driver !!\n\n");
    return 0;
  }
  
  if((argc < 2) || (argc > 3))
  {
    printf("\nusage: prg_bpi filename <base_addr>\n");
    printf("       default base_addr is 0x0\n\n");
    return 0;
  }
  else
  {
    sscanf(argv[1], "%s", (char *)(&filename));
    if(argc==3)
      sscanf(argv[2], "%x", &base_addr);
  }
  
  bpi_axi_wr(0, 0x50);  // clearing status
  // read device ID
  printf("Read device ID...\n");
  bpi_axi_wr(0, 0x90);
  data = bpi_axi_rd(0);
  printf("Manufacturer code: %04x ", data);
  if (data == 0x89) {
      printf("[OK]\n");
  } else {
      printf("[FAIL]\n");
      return(-1);
  }
  data = bpi_axi_rd(1);
  printf("Device ID code: %04x ", data);
  if (data == 0x8962) {
      printf("[OK]\n");
  } else {
      printf("[FAIL]\n");
      return(-1);
  }
  
  fp = fopen(&filename[0], "rb");
  if(!fp)
  {
		fprintf(stderr, "Unable to load file %s!\n", filename);
  }
  if(0 == program_bpi(base_addr, fp))
  {
    warm_restart_fpga(base_addr);
  }
  else
  {
    printf("\n  !! Failed programming BPI-Flash !!\n\n");
  }
  fclose(fp);

  stop_pcie_if();
  return 0;
}
