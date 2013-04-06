/*******************************************************************************
 *
 *  NetFPGA-10G http://www.netfpga.org
 *
 *  File:
 *        nf10_switch_lib.h
 *
 *  Project:
 *        Switch Library
 *
 *  Author:
 *        Muhammad Shahbaz
 *
 *  Description:
 *        For the Register IO Project.
 *
 *  Copyright notice:
 *        Copyright (C) 2010, 2011 University of Cambridge
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

#ifndef _NF10_SWITCH_LIB_H_
#define _NF10_SWITCH_LIB_H_

#include "xparameters.h"

enum {
	BAR_BASE_ADDRESS = XPAR_NF10_SWITCH_OUTPUT_PORT_LOOKUP_0_BASEADDR,
};

enum {
	RST_CNTRS = 0x00,
	LUT_HIT_REG = 0x04,
	LUT_MISS_REG = 0x08,
};

/*************************************************************
  Function prototypes
 *************************************************************/
void run(int dev);

#endif
