/*******************************************************************************
 *
 *  NetFPGA-1G-CML http://www.netfpga.org
 *
 *  File:
 *        nf1_cml_configure.c
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

#include <ctype.h>
#include <stdio.h>
#include <unistd.h>
#include "pcie_axi_if.h"
#include "bpi_axi_util.h"
#include "icap_util.h"

void usage(void)
{
  printf("\nUsage:\n");
  printf("\tnf1_cml_configure -b image <-a address> <-i>\n\n");
  printf("\tWrites a bitstream image to the BPI-Flash.\n");
  printf("\t-b\tSpecifies name of bitsream image to use\n");
  printf("\t-a\tWrite image to address instead of default of 0x00000000\n");
  printf("\t\tEnter using hex address 0xXXXXXXXX. The address should be\n");
  printf("\t\ta multiple of 1024.\n");
  printf("\t-i\tRe-initialize FPGA from address specified by -a option\n");
  printf("\n");
}

int main(int argc, char* argv[])
{  
  uint16_t data;  
  FILE     *fp;
  char     *filename;
  uint32_t base_addr = 0;
  uint32_t restart_addr = 0;
  int opt;

  printf("built %s on %s\n\n", __TIME__, __DATE__);
  
  if((argc < 2) || (argc > 6))
  {
    usage();
    return(-1);
  }
  else
  {
    while((opt=getopt(argc, argv, "b:a:i")) != -1)
    {
      switch(opt)
      {
        case 'b': filename = optarg;
                  break;
        case 'a': sscanf(optarg, "%x", &base_addr);
                  if(base_addr % 0x400)
                  {
                    fprintf(stderr, "Address must be a multilple of 0x400\n");
                    fprintf(stderr, "to effectively utilize the BPI-Flash\n");
                    fprintf(stderr, "programming buffer. 0x%08X was entered.\n", base_addr);
                    return(-1);
                  }
                  break;
        case 'i': restart_addr = base_addr;
                  break;
        case '?': if(optopt == 'a' || optopt == 'b')
                    fprintf(stderr, "Option -%c requires an argument\n", optopt);
                  else if(isprint(optopt))
                    fprintf(stderr, "Unknown option `-%c'.\n", optopt);
                  else
                    fprintf(stderr, "Unknown option character `\\x%x'.\n", optopt);
                  usage();
                  return(-1);
        default:
                  fprintf(stderr, "Unexpected error parsing command line!\n");
                  usage();
                  return(-1);
      }
    }
  }
  
  if(init_pcie_if() < 0)
  {
    fprintf(stderr, "error opening nf10 driver !!\n\n");
    return(-1);
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
    warm_restart_fpga(restart_addr);
  }
  else
  {
    printf("\n  !! Failed programming BPI-Flash !!\n\n");
    fprintf(stderr, "Failed programming BPI-Flash!\n\n");
  }
  fclose(fp);

  stop_pcie_if();
  return(0);
}
