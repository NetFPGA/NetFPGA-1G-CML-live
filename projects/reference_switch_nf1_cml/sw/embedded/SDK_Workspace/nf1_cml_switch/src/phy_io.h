/*******************************************************************************
 *
 *  NetFPGA-1G-CML http://www.netfpga.org
 *
 *  File:
 *      phy_io.h
 *
 *  Project:
 *      reference_lite_nf1_cml
 *
 *  Author:
 *      David Van Arnem
 *
 *  Description:
 *      Header file for phy_io.c
 *
 *  Copyright notice:
 *      Copyright (C) 2014, Computer Measurement Laboratory, LLC
 *
 *  Licence:
 *        This file is part of the NetFPGA-10G development base package.
 *
 *        This file is free code: you can redistribute it and/or modify it under
 *        the terms of the GNU Lesser General Public License version 2.1 as
 *        published by the Free Software Foundation.
 *
 *        This package is distributed in the hope that it will be useful, but
 *        WITHOUT ANY WARRANTY; without even the implied warranty of
 *        MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 *        Lesser General Public License for more details.
 *
 *        You should have received a copy of the GNU Lesser General Public
 *        License along with the NetFPGA source package. If not, see
 *        http://www.gnu.org/licenses/.
 *
 */ 

#ifndef PHY_IO_H_
#define PHY_IO_H_

#include "xbasic_types.h"

int PhyRead(u32 PhyAddr, u32 RegAddr, u16 *ReadData);
void PhySleep (int ms);
void PhyDump(u32 phy);
int PhyWrite(u32 PhyAddr, u32 RegAddr, u16 WriteData);


#endif /* PHY_IO_H_ */
