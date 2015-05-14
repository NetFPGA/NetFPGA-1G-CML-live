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
 * \file sha204_helper.h
 *
 * \brief Header file for sha204_helper.c
 *
 * \author Computer Measurement Laboratory
 */

#ifndef SHA204_HELPER_H
#define	SHA204_HELPER_H

#include <GenericTypeDefs.h>

UINT8 SHA204_ReadConfig(UINT8 *, UINT16);
UINT8 SHA204_Nonce(UINT8, UINT8 *, UINT8 *);
UINT8 SHA204_CheckMAC(UINT8, UINT16, UINT8 *, UINT8 *, UINT8 *, UINT8 *);
UINT8 SHA204_Mac(UINT8, UINT8, UINT8 *, UINT8 *);
UINT8 SHA204_WriteData(UINT8 *, UINT16);
UINT8 SHA204_ReadData(UINT8 *, UINT16);

#endif	/* SHA204_HELPER_H */

