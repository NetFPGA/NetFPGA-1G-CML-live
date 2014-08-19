/*******************************************************************************
 *
 *  NetFPGA-1G-CML http://www.netfpga.org
 *
 *  File:
 *        icap_util.c
 *
 *  Project:
 *        reference_flash_nf1_cml
 *
 *  Author:
 *        David Luman
 *
 *  Description:
 *        Functions used to communicate with the ICAPE2 module registers.
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

#include "pcie_axi_if.h"
#include "icap_util.h"

// gpio-based ICAP interface
#define ICAP_BASE         0x40200000
#define ICAP_WR_FIFO      ICAP_BASE | 0x100
#define ICAP_CTRL         ICAP_BASE | 0x10C
#define ICAP_STATUS       ICAP_BASE | 0x110

void icap_axi_wr(uint64_t addr, uint64_t val)
{
  pcie_axi_wr(addr, val);
}

void warm_restart_fpga(uint32_t addr)
{
  icap_axi_wr(ICAP_WR_FIFO, 0xFFFFFFFF);
  icap_axi_wr(ICAP_WR_FIFO, 0xAA995566);
  icap_axi_wr(ICAP_WR_FIFO, 0x20000000);
  icap_axi_wr(ICAP_WR_FIFO, 0x30020001);
  icap_axi_wr(ICAP_WR_FIFO, addr);
  icap_axi_wr(ICAP_WR_FIFO, 0x30008001);
  icap_axi_wr(ICAP_WR_FIFO, 0x0000000F);
  icap_axi_wr(ICAP_WR_FIFO, 0x20000000);
  icap_axi_wr(ICAP_WR_FIFO, 0x20000000);
  icap_axi_wr(ICAP_CTRL, 0x00000001);
}
