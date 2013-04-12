/*******************************************************************************
 *
 *  NetFPGA-10G http://www.netfpga.org
 *
 *  File:
 *        nf10_switch_lib.c
 *
 *  Project:
 *        reference_switch(_lite)
 *
 *  Author:
 *        Muhammad Shahbaz
 *
 *  Description:
 *        For the Reference Switch project.
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

#include "reg_lib.h"
#include "nf10_switch_lib.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*************************************************************
  Function body
 *************************************************************/

void run(int dev)
{
	printf("--- Switch Status ---\r\n\n");
	printf("LUT Hit = %d\r\n", reg_rd(dev, BAR_BASE_ADDRESS + LUT_HIT_REG));
	printf("LUT Miss = %d\r\n\n", reg_rd(dev, BAR_BASE_ADDRESS + LUT_MISS_REG));

	reg_wr(dev, BAR_BASE_ADDRESS + RST_CNTRS, 1);
	reg_wr(dev, BAR_BASE_ADDRESS + RST_CNTRS, 0);
}

