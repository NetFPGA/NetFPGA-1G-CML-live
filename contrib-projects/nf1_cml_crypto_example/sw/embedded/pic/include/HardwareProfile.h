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
 * \file HardwareProfile.h
 *
 * \brief Contains definitions for various pins, clock speeds, and interfaces
 * used by the PIC.
 *
 * \author Computer Measurement Laboratory
 */

#ifndef _HARDWARE_PROFILE_H_
#define _HARDWARE_PROFILE_H_

#include <plib.h>

#define GetSystemClock()            80000000UL /*!< System clock speed */
#define GetPeripheralClock()        40000000UL /*!< Peripheral clock speed */

/** TRIS **********************************************************************/
#define INPUT_PIN           1
#define OUTPUT_PIN          0

#define __NETFPGA1GCML__
#if defined (__NETFPGA1GCML__)

#define DEBUG
#ifdef DEBUG
#define DEBUG_PRINT(x) printf x
#else
#define DEBUG_PRINT(x)
#endif

#define ARRAYSIZE(x)        (sizeof(x)/sizeof(x[0]))

// I2C slave addresses
#define M41T62_ADDRESS      0xD0
#define ATSHA204_ADDRESS    0xC8

#define M41T62_I2C_BUS      I2C2
#define ATSHA204_I2C_BUS    I2C2

#define I2C_CLOCK_FREQ_SLOW (100000.0)
#define I2C_CLOCK_FREQ_FAST (400000.0)

#define portPIC2FPGA_GPIO0  PORTDbits.RD4
#define trisPIC2FPGA_GPIO0  TRISDbits.TRISD4
#define latPIC2FPGA_GPIO0   LATDbits.LATD4

#define REQ_FPGA_ATTN       portPIC2FPGA_GPIO0
#define REQ_FPGA_ATTN_TRI   trisPIC2FPGA_GPIO0

#endif // #ifdef __NETFPGA1GCML__

#endif //#ifndef _HARDWARE_PROFILE_H_
