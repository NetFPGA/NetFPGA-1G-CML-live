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
 * \file fpga_pic_comm.h
 *
 * \brief This code supports communication via SPI between a MicroBlaze
 * processor running on the Xilinx FPGA and the PIC microcontroller
 * that are on the CML NetFPGA-1G board. This code is for the 
 * MicroBlaze processor. It uses two SPIC busses, one to send and
 * the other to receive. 
 *
 * \author Computer Measurement Laboratory
 */


#ifndef FPGA_PIC_COMM_H_
#define FPGA_PIC_COMM_H_

#define SPI_XFER_FAIL        0x27
#define SPI_OPERATION_FAIL   0x28
#define STORE_KEY_FAIL       0x11
#define AUTHENTICATION_FAIL  0x12

int  InitSPI();
u8   request_rtc_time(u8 *time_vals);
u8   set_rtc_time(u8 *time_vals);
u8   read_config(u8 *data, u16 addr);
//u8   write_config(u8 *data, u16 addr);
u8   read_key(u16 slot, u8 *key);
u8   store_key(u16 slot, u8 *key);
u8   request_nonce(u8 *nonce);
u8   request_auth(u8 slot, u8 *hash);
u8   request_mac(u8 mode, u8 slot, u8 *challenge, u8 *mac);
void hashKeyNonceAndSalt(u8 *key, u8 *nonce, u8 *key_nonce_salt_hash);


#endif /* FPGA_PIC_COMM_H_ */
