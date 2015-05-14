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
 * \file hsc_sha_256.h
 *
 * \brief Header file for hsc_sha_256.c
 *
 * \author Computer Measurement Laboratory
 */

#ifndef HSC_SHA_256_H
#define HSC_SHA_256_H

#include <xbasic_types.h>

int SHA256_HashBlock(u8 *block, u32 *H);
u32 SHA256_PadMessage(u8 *message, u32 msg_length_bytes, u8 *padded);
void SHA256_InitHashes(u32 *H);
void SHA256_ClearHashes(u32 *H);
void SHA256_HashMessage(u8 *message, u32 msg_length_bytes, u8 *hash);

#endif
