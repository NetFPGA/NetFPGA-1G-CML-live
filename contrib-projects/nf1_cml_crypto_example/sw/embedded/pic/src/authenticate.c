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
 * \file authenticate.c
 *
 * \brief Contains function for verifying and authenticating different messages
 * and commands for use in secure NetFPGA-1G-CML designs.
 *
 * \author Computer Measurement Laboratory
 */
#include "peripheral/spi.h"
#include "I2C/SHA204/sha204_helper.h"
#include "I2C/SHA204/sha204_lib_return_codes.h"
#include "I2C/SHA204/sha204_comm_marshaling.h"
#include "I2C/M41T62/m41t62.h"
#include "HardwareProfile.h"
#include "sha_256.h"
#include "authenticate.h"

/* User-defined data used by the ATSHA204 in hash calculations */
static UINT8 other_data[13] = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i',
                                'j', 'k', 'l', 'm' };

/*!
 * \brief Creates a 20 byte seed for use in the ATSHA204 NONCE command.
 *
 * \param[out] nonce_seed a pointer to a 20-byte array to store the seed
 */
void getNonceSeed(UINT8 *nonce_seed)
{
    int i;

    for (i = 1; i < 21; i++) {
        nonce_seed[i-1] = i;
    }
}

/*!
 * \brief Performs the NONCE command on the ATSHA204 and generates the same
 * NONCE without the ATSHA204 using the random number returned by the NONCE
 * command.
 *
 * \param[out] sys_nonce a pointer to a 32-byte array to store the system nonce
 *
 * \return a byte indicating the success of the Nonce command on the ATSHA204
 */
UINT8 getSystemNonce(UINT8 *sys_nonce)
{
    UINT8 ret_code;
    UINT8 rand_num[32];
    UINT8 msg_blk[55];
    UINT8 nonce_seed[20];
    int i;

    getNonceSeed(&nonce_seed[0]);

    sha204p_sleep();
    delay_ms(500);
    ret_code = SHA204_Wakeup();
    ret_code = SHA204_Nonce(NONCE_MODE_SEED_UPDATE, nonce_seed, rand_num);

    if (ret_code == SHA204_SUCCESS) {
        for (i = 0; i < 32; i++) {
            msg_blk[i] = rand_num[i];
        }

        for (; i < 52; i++) {
            msg_blk[i] = nonce_seed[i-32];
        }

        msg_blk[i] = SHA204_NONCE;
        i++;
        msg_blk[i] = NONCE_MODE_SEED_UPDATE;
        i++;
        msg_blk[i] = 0x00;

        SHA256_HashMessage(&msg_blk[0], sizeof(msg_blk), &sys_nonce[0]);
    }

    return ret_code;
}

/*!
 * \brief Hashes together a key and NONCE (from getSystemNonce) to form part of
 * the message for the ATSHA204's CheckMAC command.
 *
 * \param[in] key the key value to compare to a slot value
 * \param[in] nonce a NONCE from getSystemNonce()
 * \param[out] key_nonce_salt_hash the hash of the key, NONCE, and a salt value
 */
void hashKeyNonceAndSalt(UINT8 *key, UINT8 *nonce, UINT8 *key_nonce_salt_hash)
{
    UINT8 blk_to_hash[88];
    int i;

    for (i = 0; i < 32; i++) {
        blk_to_hash[i] = key[i];
    }

    for (; i < 64; i++) {
        blk_to_hash[i] = nonce[i-32];
    }

    // build extra bytes used in the CheckMAC command
    // subtract 64 to get other_data[0:3]
    for (; i < 68; i++) {
        blk_to_hash[i] = other_data[i-64];
    }

    for (; i < 76; i++) {
        blk_to_hash[i] = 0;
    }

    // subtract 72 to get other_data[4:6]
    for (; i < 79; i++) {
        blk_to_hash[i] = other_data[i-72];
    }

    // serial number
    blk_to_hash[i] = 0xee;
    i++;

    // subtract 73 to get other_data[7:10]
    for (; i < 84; i++) {
        blk_to_hash[i] = other_data[i-73];
    }

    // serial number
    blk_to_hash[i] = 0x01;
    i++;
    blk_to_hash[i] = 0x23;
    i++;

    // subtract 75 to get other_data[11:12]
    for (; i < 88; i++) {
        blk_to_hash[i] = other_data[i-75];
    }

    SHA256_HashMessage(&blk_to_hash[0], sizeof(blk_to_hash), &key_nonce_salt_hash[0]);
}

/*!
 * \brief Uses the ATSHA204's CheckMAC command to compare a hash ("client response")
 * with one computed internally on the ATSHA204 to verify that the hash was
 * created with a key stored in a slot on the ATSHA204.
 *
 * \param[in] key_nonce_salt_hash a hash of the key, NONCE from the ATSHA204, and
 * the salt needed for the CheckMAC command
 * \param[in] slot_id the slot storing the key hashed in key_nonce_salt_hash
 *
 * \return TRUE if match, FALSE if mismatch
 */
BOOL checkHash(UINT8 *key_nonce_salt_hash, UINT16 slot_id)
{
    UINT8 cmac_client_chal[32];
    UINT8 checkmac_rsp = 0xFF;
    BOOL success = TRUE;
    UINT8 sha204_res;

    SHA204_Wakeup();
    // do the CheckMAC comparison
    // cmac_client_chal is not actually used since we're using mode 0x01, so we
    // could send anything
    sha204_res = SHA204_CheckMAC(0x01, slot_id, &cmac_client_chal[0],
        &key_nonce_salt_hash[0], &other_data[0], &checkmac_rsp);
    if (sha204_res != SHA204_SUCCESS) {
        success = FALSE;
    }

    // set result
    if (success) {
        if (checkmac_rsp == 0) {
            success = TRUE;
        } else {
            success = FALSE;
        }
    }
    sha204p_sleep();
    return success;
}
