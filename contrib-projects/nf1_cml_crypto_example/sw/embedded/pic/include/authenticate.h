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
 * \file authenticate.h
 *
 * \brief Header file for authenticate.c
 *
 * \author Computer Measurement Laboratory
 */

#ifndef AUTHENTICATE_H
#define	AUTHENTICATE_H

#include <GenericTypeDefs.h>

void getNonceSeed(UINT8 *nonce_seed);
void hashKeyNonceAndSalt(UINT8 *key, UINT8 *nonce, UINT8 *key_nonce_hash);
BOOL checkHash(UINT8 *hash, UINT16 slot_id);

#define PIC_NONCE_REQ       0xA4
#define PIC_AUTH_CODE_RDY   0xCD
#define PIC_AUTH_CODE_XMIT  0xE6
#define PIC_AUTH_CODE_RETRY 0xB2
#define PIC_AUTH_FAIL_VAL   0x12
#define PIC_AUTH_PASS_VAL   0x11

#endif	/* AUTHENTICATE_H */

