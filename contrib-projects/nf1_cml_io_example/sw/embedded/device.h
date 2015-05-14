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


extern unsigned int *gpio_io;
extern unsigned int *gpio_tri;


#define SD_CD           0x01
#define SD_WP           0x02
#define SD_CCLK         0x04
#define SD_CMD          0x08
#define SD_D0           0x10
#define SD_D1           0x20
#define SD_D2           0x40
#define SD_D3           0x80

#define SD_SPI_CS       SD_D3
#define SD_SPI_CK       SD_CCLK
#define SD_SPI_DI       SD_CMD
#define SD_SPI_DO       SD_D0

void udelay(int n);

