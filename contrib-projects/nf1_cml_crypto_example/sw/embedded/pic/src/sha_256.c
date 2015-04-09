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
 * \file sha-256.c
 *
 * \brief This file contains library functions for performing the SHA-256 algorithm
 * (FIPS 180-2).
 *
 * \author Computer Measurement Laboratory
 */

#include "sha_256.h"
#include <GenericTypeDefs.h>

/* combines 4 bytes into an integer */
#define MAKE_UINT(o,m,i) ( \
	(o) = 	((UINT32)(m)[i] << 24)  | \
		    ((UINT32)(m)[i+1] << 16)| \
		    ((UINT32)(m)[i+2] << 8) | \
		    ((UINT32)(m)[i+3]))

 /* Working Variables structure.  Variables are temporary hash values. */
struct working_vars {
	UINT32 a, b, c, d, e, f, g, h;
};

/* Function prototypes */
static UINT32 Ch(UINT32 x, UINT32 y, UINT32 z);
static UINT32 Maj(UINT32 x, UINT32 y, UINT32 z);
static UINT32 Sum_0_256(UINT32 x);
static UINT32 Sum_1_256(UINT32 x);
static UINT32 Theta_0_256(UINT32 x);
static UINT32 Theta_1_256(UINT32 x);
static void InitWordSchedule(UINT32 *W, UINT8 *padded);
static void PerformStep(UINT32 K, UINT32 W, struct working_vars *vars);
static void UpdateHashes(struct working_vars *vars, UINT32 *H);

/* Algorithm constants array, as specified in FIPS 180-2, section 4.2.2 */
static const UINT32 K[64] = {
	0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1,
	0x923f82a4, 0xab1c5ed5, 0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3,
	0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174, 0xe49b69c1, 0xefbe4786,
	0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
	0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147,
	0x06ca6351, 0x14292967, 0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13,
	0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85, 0xa2bfe8a1, 0xa81a664b,
	0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
	0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a,
	0x5b9cca4f, 0x682e6ff3, 0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208,
	0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
};

/*!
 * \brief Equation 4.2 as described in FIPS 180-2, section 4.1.2.
 *
 * \param[in] x operand 1
 * \param[in] y operand 2
 * \param[in] z operand 3
 *
 * \return ((x & y) ^ (~x & z))
 */
static UINT32 Ch(UINT32 x, UINT32 y, UINT32 z)
{
	return ((x & y) ^ (~x & z));
}

/*!
 * \brief Equation 4.3 as described in FIPS 180-2, section 4.1.2.
 *
 * \param[in] x operand 1
 * \param[in] y operand 2
 * \param[in] z operand 3
 *
 * \return ((x & y) ^ (x & z) ^ (y & z))
 */
static UINT32 Maj(UINT32 x, UINT32 y, UINT32 z)
{
	return ((x & y) ^ (x & z) ^ (y & z));
}

/*!
 * \brief Equation 4.4 as described in FIPS 180-2, section 4.1.2.
 *
 * \param[in] x operand 1
 *
 * \return ROTR2(x) ^ ROTR13(x) ^ ROTR22(x)
 */
static UINT32 Sum_0_256(UINT32 x)
{
	UINT32 rotr_2, rotr_13, rotr_22;

	rotr_2 = (x >> 2) | (x << (32 - 2));
	rotr_13 = (x >> 13) | (x << (32 - 13));
	rotr_22 = (x >> 22) | (x << (32 - 22));

	return (rotr_2 ^ rotr_13 ^ rotr_22);
}

/*!
 * \brief Equation 4.5 as described in FIPS 180-2, section 4.1.2.
 *
 * \param[in] x operand 1
 *
 * \return ROTR6(x) ^ ROTR11(x) ^ ROTR25(x)
 */
static UINT32 Sum_1_256(UINT32 x)
{
	UINT32 rotr_6, rotr_11, rotr_25;

	rotr_6 = (x >> 6) | (x << (32 - 6));
	rotr_11 = (x >> 11) | (x << (32 - 11));
	rotr_25 = (x >> 25) | (x << (32 - 25));

	return (rotr_6 ^ rotr_11 ^ rotr_25);
}

/*!
 * \brief Equation 4.6 as described in FIPS 180-2, section 4.1.2.
 *
 * \param[in] x operand 1
 *
 * \return ROTR7(x) ^ ROTR18(x) ^ SHR3(x)
 */
static UINT32 Theta_0_256(UINT32 x)
{
	UINT32 rotr_7, rotr_18, shr_3;

	rotr_7 = (x >> 7) | (x << (32 - 7));
	rotr_18 = (x >> 18) | (x << (32 - 18));
	shr_3 = x >> 3;

	return (rotr_7 ^ rotr_18 ^ shr_3);
}

/*!
 * \brief Equation 4.7 as described in FIPS 180-2, section 4.1.2.
 *
 * \param[in] x operand 1
 *
 * \return ROTR17(x) ^ ROTR19(x) ^ SHR10(x)
 */
static UINT32 Theta_1_256(UINT32 x)
{
	UINT32 rotr_17, rotr_19, shr_10;

	rotr_17 = (x >> 17) | (x << (32 - 17));
	rotr_19 = (x >> 19) | (x << (32 - 19));
	shr_10 = x >> 10;

	return (rotr_17 ^ rotr_19 ^ shr_10);
}

/*!
 * \brief Initializes the Word Schedule for a block as described in FIPS 180-2,
 * section 6.2.2.
 *
 * \param[out] W pointer to memory to store the Word Schedule
 * \param[in] padded pointer to a 64 byte message block
 */
static void InitWordSchedule(UINT32 *W, UINT8 *padded)
{
	int i;
    UINT32 tmp1, tmp2, tmp3, tmp4;
	for (i = 0; i < 64; i++) {
		if (i < 16) {
//			MAKE_UINT(W[i], padded, i * 4);
            tmp1 = ((UINT32)padded[i*4]) << 24;
            tmp2 = ((UINT32)padded[i*4+1]) << 16;
            tmp3 = ((UINT32)padded[i*4+2]) << 8;
            tmp4 = ((UINT32)padded[i*4+3]);
            W[i] = tmp1 | tmp2 | tmp3 | tmp4;
		} else {
			W[i] = Theta_1_256(W[i - 2]) + W[i - 7] +
					Theta_0_256(W[i - 15]) + W[i - 16];
		}
	}
}

/*!
 * \brief Initializes the 8 hash values that make up the message digest as
 * specified in FIPS 180-2, section 5.3.2.
 *
 * \param[in] H pointer to the hash values array
 */
void SHA256_InitHashes(UINT32 *H)
{
	H[0] = 0x6a09e667;
	H[1] = 0xbb67ae85;
	H[2] = 0x3c6ef372;
	H[3] = 0xa54ff53a;
	H[4] = 0x510e527f;
	H[5] = 0x9b05688c;
	H[6] = 0x1f83d9ab;
	H[7] = 0x5be0cd19;
}

/*!
 * \brief Clears the 8 hash values that make up the message digest to 0.
 *
 * \param[in] H pointer to the hash values array
 */
void SHA256_ClearHashes(UINT32 *H)
{
	int i;
	for (i = 0; i < 8; i++) {
		H[i] = 0x00000000;
	}
}

/*!
 * \brief Performs one SHA-256 "step" as outlined in FIPS 180-2, section 6.2.2,
 * number 3.
 *
 * Each step updates the working variables to new values depending
 * on both the algorithm constant and word schedule value for the step.
 *
 * \param[in] K the algorithm constant for the current iteration
 * \param[in] W the Word Schedule value for the current iteration
 * \param[out] vars pointer to the working variable structure
 */
static void PerformStep(UINT32 K, UINT32 W, struct working_vars *vars)
{
	UINT32 T1, T2;
	T1 = vars->h + Sum_1_256(vars->e) + Ch(vars->e, vars->f, vars->g) + K + W;
	T2 = Sum_0_256(vars->a) + Maj(vars->a, vars->b, vars->c);
	vars->h = vars->g;
	vars->g = vars->f;
	vars->f = vars->e;
	vars->e = vars->d + T1;
	vars->d = vars->c;
	vars->c = vars->b;
	vars->b = vars->a;
	vars->a = T1 + T2;
}

/*!
 * \brief Updates the 8 hash values after each 64 bit block is hashed, as
 * specified in FIPS 180-2, section 6.2.2, number 4.
 *
 * The new hash value is the previous hash value plus the working variable
 * associated with it (e.g. a + H[0]).
 *
 * \param[in] vars pointer to the working variable structure
 * \param[out] H pointer to the hash values array
 */
static void UpdateHashes(struct working_vars *vars, UINT32 *H)
{
	H[0] = vars->a + H[0];
	H[1] = vars->b + H[1];
	H[2] = vars->c + H[2];
	H[3] = vars->d + H[3];
	H[4] = vars->e + H[4];
	H[5] = vars->f + H[5];
	H[6] = vars->g + H[6];
	H[7] = vars->h + H[7];
}

/*!
 * \brief Hashes an entire 64 byte message block into 8 hash values and updates
 * them.
 *
 * A block hash consists of:
 *  -# Initializing the Word Schedule (FIPS 180-2, section 6.2.2, number 1)
 * 	-# Initializing the eight working variables (FIPS 180-2, section 6.2.2,
 *		number 2)
 * 	-# Updating the working variables 64 times using the functions outlined
 *		in FIPS 180-2, section 4.1.2 (FIPS 180-2, section 6.2.2, number 3)
 * 	-# Updating the hashes using the working variable values after 64
 *		updates (FIPS 180-2, section 6.2.2, number 4)
 *
 * This function should ultimately be called N or N+1 times, where N is the
 * number of 64 byte blocks in the message to be hashed.
 *
 * \param[in] block pointer to the message block, stored in bytes
 * \param[out] H pointer to the hash values array
 *
 * \return 0 if successful, 1 if the Word Schedule memory is not allocated
 * correctly.
 */
int SHA256_HashBlock(UINT8 *block, UINT32 *H)
{
	int i;
	struct working_vars vars;
	struct working_vars *pvars;
	UINT32 W[64];

	pvars = &vars;

	InitWordSchedule(W, block);

	pvars->a = H[0];
	pvars->b = H[1];
	pvars->c = H[2];
	pvars->d = H[3];
	pvars->e = H[4];
	pvars->f = H[5];
	pvars->g = H[6];
	pvars->h = H[7];

	for (i = 0; i < 64; i++) {
		PerformStep(K[i], W[i], pvars);
	}
	UpdateHashes(pvars, H);

	return 0;
}

/*!
 * \brief Pads the final message block to 512 bits, or 64 bytes.
 *
 * This padding deviates from the official SHA-256 algorithm, though
 * the padded message would be the same.  The official algorithm specifies
 * the last 64 bits of the padded message contain the length of the message
 * in bits, but since the length of the bitstream can easily be stored in 32
 * bits, only the last word contains the bitstream length.  This also prevents
 * some programming headaches of trying to construct a 64 bit value for a
 * length on a 32 bit machine.
 *
 * \param[in] message pointer to the unpadded message
 * \param[in] message_len the message length in bytes
 * \param[out] padded pointer to the padded message
 * \param[in] full_message_len the length in bits of the full message
 *
 * \return the number of 64 byte blocks in the padded message
 */
UINT32 SHA256_PadMessage(UINT8 *message, UINT32 msg_length_bytes, UINT8 *padded)
{
	int i, ii, top;
    UINT32 full_message_len;
    UINT32 num_extra_blocks;
	UINT8 *bit_len_p = (UINT8 *) &full_message_len;

    full_message_len = msg_length_bytes * 8;

    num_extra_blocks = 0;

    top = msg_length_bytes % 64;
    for (i = 0; i < top; i++) {
        padded[i] = message[i];
    }

    padded[i] = 0x80;
    i++;

    for (; i < 60; i++) {
        padded[i] = 0x00;
    }

    if (top > 55) {
        num_extra_blocks = 1;
        for (; i < 124; i++) {
            padded[i] = 0x00;
        }
    }

    top = i + 4;
    ii = 3;
    for (; i < top; i++) {
        padded[i] = bit_len_p[ii];
        ii--;
    }

    return num_extra_blocks;
}

/*!
 * \brief Hashes a message of variable length.
 *
 * \param[in] message a pointer to the message to hash
 * \param[in] msg_length_bytes the message length
 * \param[out] hash a pointer to where to store the message after its been hashed
 */
void SHA256_HashMessage(UINT8 *message, UINT32 msg_length_bytes, UINT8 *hash)
{
    UINT32 H[8];
    UINT8 *H_char;
    UINT8 padded_block[128];
    int extra_block;
    int full_blocks;
    int i;

    full_blocks = msg_length_bytes / 64;

    SHA256_InitHashes(&H[0]);

    for (i = 0; i < full_blocks; i++) {
        SHA256_HashBlock(&message[i*64], &H[0]);
    }

    extra_block = SHA256_PadMessage(&message[i*64], msg_length_bytes, &padded_block[0]);
    SHA256_HashBlock(&padded_block[0], &H[0]);
    if (extra_block) {
        SHA256_HashBlock(&padded_block[64], &H[0]);
    }

    H_char = (UINT8 *)&H[0];

    for (i = 0; i < 8; i++) {
        hash[i*4+0] = H_char[i*4+3];
        hash[i*4+1] = H_char[i*4+2];
        hash[i*4+2] = H_char[i*4+1];
        hash[i*4+3] = H_char[i*4+0];
    }
}
