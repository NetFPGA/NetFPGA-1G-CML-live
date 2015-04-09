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
 * \file fpga_messages.h
 *
 * \brief This file is used to hold defines for messages used by
 * the FPGA to request action and information from the PIC
 * using SPI. 
 *
 * \author Computer Measurement Laboratory
 */

#ifndef FPGA_MESSAGES_H
#define FPGA_MESSAGES_H

#define IGNORE                                0x00
#define PASS                                  0x01
#define FAIL                                  0x02
#define ATSHA204_READ_CONFIG                  0x03
#define ATSHA204_WRITE_CONFIG                 0x04
#define ATSHA204_NONCE                        0x05
#define ATSHA204_WRITE_DATA                   0x06
#define ATSHA204_READ_DATA                    0x07
#define ATSHA204_AUTH                         0x08
#define ATSHA204_MAC                          0x09
#define RTC_READ_TIME                         0x0A
#define RTC_WRITE_TIME                        0x0B

#define DATA_ACK                              0x31
#define SEND_DATA                             0x32


#endif /* FPGA_MESSAGES_H */
