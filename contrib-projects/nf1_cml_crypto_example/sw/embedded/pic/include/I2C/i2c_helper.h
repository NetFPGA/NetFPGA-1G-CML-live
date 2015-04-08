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
 * \file i2c_helper.h
 *
 * \brief Header file for i2c_helper.c
 *
 * \author Computer Measurement Laboratory
 */

#ifndef I2C_HELPER_H
#define	I2C_HELPER_H

#include <peripheral/i2c.h>

I2C_RESULT I2CStartTransfer(BOOL, I2C_MODULE);
I2C_RESULT I2CSendOneByte(UINT8, I2C_MODULE);
I2C_RESULT I2CGetOneByte(BOOL, I2C_MODULE, UINT8 *);
void I2CStopTransfer(I2C_MODULE);
I2C_RESULT I2CSendBytes(UINT8, UINT8 *, int, UINT8 *, int, I2C_MODULE);
I2C_RESULT I2CGetBytes(UINT8, UINT8 *, int, I2C_MODULE, UINT8 *, int);
I2C_RESULT I2CSendBytesAddr(UINT8 *, int, UINT8 *, int, I2C_MODULE);
BOOL I2CPoll(UINT8 slave_addr, I2C_MODULE bus);

#endif	/* I2C_HELPER_H */
