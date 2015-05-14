/*******************************************************************************
 *
 * NetFPGA-1G-CML http://www.netfpga.org
 *
 * Project:
 *       nf1_cml_crypto_example
 *
 * Author:
 *       Computer Measurement Laboratory
 *
 * Copyright notice:
 *       Copyright (C) 2015 Computer Measurement Laboratory
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

/*!
 * \file fpga_helper.h
 *
 * \brief Header file for fpga_helper.c
 *
 * \author Computer Measurement Laboratory
 */

#ifndef FPGA_HELPER_H
#define FPGA_HELPER_H

#include <GenericTypeDefs.h>

#define VALID_MSG 0
#define NO_MSG 1

void init_FPGA_SPI(UINT8 channel);
UINT8 check_FPGA_SPI(UINT8 channel);
void send_FPGA_SPI(UINT8 channel, UINT8 *msg, UINT8 len, UINT8 status);
void show_FPGA_request(UINT8 request);

#endif /* FPGA_HELPER_H */
