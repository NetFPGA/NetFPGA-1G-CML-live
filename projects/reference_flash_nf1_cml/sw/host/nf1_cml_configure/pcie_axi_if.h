/*******************************************************************************
 *
 *  NetFPGA-1G-CML http://www.netfpga.org
 *
 *  File:
 *        pcie_axi_if.h
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

#include <stdint.h>

#define NF10_IOCTL_CMD_WRITE_REG (SIOCDEVPRIVATE+1)
#define NF10_IOCTL_CMD_READ_REG  (SIOCDEVPRIVATE+2)

int init_pcie_if(void);
int stop_pcie_if(void);
void pcie_axi_wr(uint64_t addr, uint64_t val);
void pcie_axi_rd(uint64_t *val);
