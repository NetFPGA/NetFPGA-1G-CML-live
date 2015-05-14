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
 * \file utility.h
 *
 * \brief Header file for the utility function source file (utility.c).
 *
 * \author David A. Van Arnem, Computer Measurement Laboratory
 */

#ifndef UTILITY_H
#define UTILITY_H

void InitApp(void);
void InitUART1(void);
void InitMCU(void);
void InitI2C2(void);
void InitSPI2(void);
void InitSPI4(void);
char GetUserInput(void);
void InitPicTimer2(void);
void delay_ms(int delay);

#endif /* UTILITY_H */
