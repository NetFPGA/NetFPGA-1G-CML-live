/*******************************************************************************
 *
 * NetFPGA-1G-CML http://www.netfpga.org
 *
 * Project:
 *       nf1_cml_io_example
 *
 * Author:
 *       Jay Hirata
 *
 * Copyright notice:
 *       Copyright (C) 2014 Computer Measurement Laboratory
 *
 * Licence:
 *       This file is part of the NetFPGA-1G-CML development base package.
 *
 *       This file is free code: you can redistribute it and/or modify it under
 *       the terms of the GNU Lesser General Public License version 2.1 as
 *       published by the Free Software Foundation.
 *
 *       This package is distributed in the hope that it will be useful, but
 *       WITHOUT ANY WARRANTY; without even the implied warranty of
 *       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *       Lesser General Public License for more details.
 *
 *       You should have received a copy of the GNU Lesser General Public
 *       License along with the NetFPGA source package.  If not, see
 *       http://www.gnu.org/licenses/.
 *
 ******************************************************************************/

#include "device.h"

unsigned int *gpio_io = (unsigned int *)0x40040000;
unsigned int *gpio_tri = (unsigned int *)0x40040004;

void init_sd_gpio_port()
{
    *gpio_tri = ~(SD_SPI_CS | SD_SPI_CK | SD_SPI_DI);
}



/* timer */
static volatile unsigned int *timer = (void *)0x41c00000;
#define TIMER_TCSR0     0
#define TIMER_TLR0      1
#define TIMER_TCR0      2

void udelay(int n)
{
    timer[TIMER_TLR0]  = n * 100000;    /* Load timer amount */
    timer[TIMER_TCSR0] = 0x00000120;    /* Clear interrupt and load timer */
    timer[TIMER_TCSR0] = 0x00000182;    /* Clear interrupt, start timer, countdown */

    while (!(timer[TIMER_TCSR0] & 0x00000100));
}



