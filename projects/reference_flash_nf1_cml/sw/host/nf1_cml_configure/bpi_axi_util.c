/*******************************************************************************
 *
 *  NetFPGA-1G-CML http://www.netfpga.org
 *
 *  File:
 *        bpi_axi_util.c
 *
 *  Project:
 *        reference_flash_nf1_cml
 *
 *  Author:
 *        David Luman
 *
 *  Description:
 *        Functions used communicate with the BPI-Flash registers.
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
#include <stdlib.h>
#include "pcie_axi_if.h"
#include "bpi_axi_util.h"

// define some bit positions for setting control line levels
#define CE_N            0x08000000
#define WE_N            0x20000000
#define OE_N            0x10000000
#define ADV             0x04000000

// gpio-based BPI interface
#define BPI_CMD         0x40000000
#define BPI_CMD_TRI     0x40000004
#define BPI_DATA        0x40000008
#define BPI_DATA_TRI    0x4000000c

// BPI interface commands
#define BLOCK_LOCK_SETUP         0x60
#define BLOCK_LOCK               0x01
#define BLOCK_UNLOCK             0xD0
#define CLEAR_STATUS_REG         0x50
#define BLOCK_ERASE_SETUP        0x20
#define BLOCK_ERASE_CONFIRM      0xD0
#define WORD_PROGRAM_SETUP       0x40
#define BUFFERED_PROGRAM         0xE8
#define BUFFERED_PROGRAM_CONFIRM 0xD0
#define READ_ARRAY               0xFF
#define READ_STATUS              0x70

// BPI Flash structure info
#define BLOCK_SZ_BOUNDARY_ADDR 0x3FF0000
#define LOWER_BLOCK_SZ         0x10000
#define UPPER_BLOCK_SZ         0x4000
#define DEVICE_PRG_BUF_SZ      (512 * 2)      // in 16-bit words

void bpi_axi_wr(uint64_t addr, uint64_t val)
{
  pcie_axi_wr(BPI_CMD, (CE_N | WE_N | OE_N | ADV | addr));
  pcie_axi_wr(BPI_CMD, (              OE_N |       addr));
  pcie_axi_wr(BPI_DATA, val);
  pcie_axi_wr(BPI_DATA_TRI, 0x0);
  pcie_axi_wr(BPI_CMD, (CE_N | WE_N | OE_N | ADV | addr));
  pcie_axi_wr(BPI_DATA_TRI, 0xffffffff);
}

unsigned short bpi_axi_rd(uint64_t addr)
{
  uint64_t read_val;

  pcie_axi_wr(BPI_CMD, (CE_N | WE_N | OE_N | ADV | addr));
  pcie_axi_wr(BPI_CMD, (       WE_N |              addr));
  read_val=BPI_DATA;
  pcie_axi_rd(&read_val);
  pcie_axi_wr(BPI_CMD, (CE_N | WE_N | OE_N | ADV));

  // upper 32bits contain the address and are masked away here
  // lower 32bits contain the data
  read_val &= 0xffffffff;
  return(read_val);
}

void wait_bpi_ready(uint32_t block)
{  
  uint16_t data;

  do
  {
    data = bpi_axi_rd(block);
  }while (!(data & 0x80));
}

int unlock_block(uint32_t block)
{
  uint16_t data;
  
  bpi_axi_wr(block, BLOCK_LOCK_SETUP);
  bpi_axi_wr(block, BLOCK_UNLOCK);
  wait_bpi_ready(block);   
  data = bpi_axi_rd(block);
  if(data & 0x007F)
  {
      printf("Errors while unlocking: 0x%02X\n", data);
      return(-1);
  }
  return(0);
}

int erase_block(uint32_t block)
{
  uint16_t data;  

  bpi_axi_wr(block, BLOCK_ERASE_SETUP);
  bpi_axi_wr(block, BLOCK_ERASE_CONFIRM);
  wait_bpi_ready(block);   
  data = bpi_axi_rd(block);
  if(data & 0x007F)
  {
      printf("Errors while erasing: 0x%02X\n", data);
      return(-1);
  }
  return(0);
}


int buffered_write(uint32_t bpi_base, uint32_t offset, uint16_t sz, uint16_t *src)
{
  uint32_t addr;
  uint16_t data;
  uint16_t i;

  addr = bpi_base+offset;
  
  if(0 != unlock_block(addr))
    return(-1);
  bpi_axi_wr(addr, CLEAR_STATUS_REG);
  bpi_axi_wr(addr, BUFFERED_PROGRAM);  
  data = bpi_axi_rd(addr); 
  if(!(data & 0x0080))
  {
    printf("\n**\n** Buffer for writing block %d not available\n**\n", addr);
    return(-1);
  }
  bpi_axi_wr(addr, sz-1);
  for(i=0;i<sz;i++)
  {
    bpi_axi_wr(addr+i, src[i]);      
  }
  bpi_axi_wr(addr, BUFFERED_PROGRAM_CONFIRM);
  wait_bpi_ready(addr);  
  data = bpi_axi_rd(addr);
  if (data & 0x007F)
  {
    printf("Errors during BUFFERED writing: 0x%02X\n", data);
    return(-1);
  }  
  bpi_axi_wr(addr, CLEAR_STATUS_REG);
  bpi_axi_wr(addr, READ_ARRAY);
  return(0);
}

int program_bpi(uint32_t bpi_start_addr, FILE *fp)
{
  uint8_t  done = 0;
  uint32_t block_cnt = 0;
  uint32_t cur_write_sz;
  uint32_t buf_idx = 0;
  uint32_t cur_bpi_block = 0;
  uint32_t old_bpi_block = 0xFFFFFFFF;  // force possible zero block to get erased on first use
  uint32_t cur_block_sz;
  uint32_t addr;
  uint8_t  *fbuf;
  uint32_t total_sz = 0;

  printf("\n** Begin BPI programming**\n");
  fbuf = (uint8_t *)malloc(DEVICE_PRG_BUF_SZ);

  while(!done)
  {
    cur_write_sz = fread((uint8_t *)(fbuf),       // read into buffer
                         1,                       // size of data items in bytes
                         DEVICE_PRG_BUF_SZ,       // number of data items
                         fp);                     // file to read from
    total_sz += cur_write_sz;
    if(cur_write_sz < DEVICE_PRG_BUF_SZ)
    {
      if(ferror(fp))
      {            
		    fprintf(stderr, "Unable to completely load file!\n");
      }
    }
    if(feof(fp))
    {
      done = 1;
    }
    
    buf_idx = ((DEVICE_PRG_BUF_SZ/2) * block_cnt);

    // The BPI part on the NetFPGA 1G-CML is not symetric. The highest
    // block in the device has been divided into four smaller addressable
    // blocks. This convoluted code adapts it's behaviour to support this.
    // If the part is changed to use one of the symetrical or bottom
    // divided parts this will need to change.
    addr = bpi_start_addr+buf_idx;
    if(addr < BLOCK_SZ_BOUNDARY_ADDR)
    {
      cur_block_sz = LOWER_BLOCK_SZ;                                                                 // 64K block size below address BLOCK_SZ_BOUNDARY_ADDR
      cur_bpi_block = addr/cur_block_sz;
    }
    else
    {
      cur_block_sz = UPPER_BLOCK_SZ;                                                                 // 16K block size above address BLOCK_SZ_BOUNDARY_ADDR
      cur_bpi_block = addr/cur_block_sz;                                                             // this calcs a block number, but it is too high because addresses below 0x3FEFFFF are much larger
      cur_bpi_block -= ((LOWER_BLOCK_SZ/UPPER_BLOCK_SZ)-1)*(BLOCK_SZ_BOUNDARY_ADDR/LOWER_BLOCK_SZ);  // so subtract out the extra number of blocks counted to get the real block number...
    }
    if(cur_bpi_block != old_bpi_block)
    {
      if(0 != unlock_block(addr))
      {
        free(fbuf);
        return(-1);
      }
      if(0 != erase_block(addr))
      {
        free(fbuf);
        return(-1);
      }
      old_bpi_block = cur_bpi_block;
    }
    if(0 != buffered_write(bpi_start_addr, buf_idx, cur_write_sz/2, (uint16_t *)(fbuf)))
    {
      free(fbuf);
      return(-1);
    }
    block_cnt++;
  }
  printf("     program BPI completed\n");
  free(fbuf);
  return(0);
}


