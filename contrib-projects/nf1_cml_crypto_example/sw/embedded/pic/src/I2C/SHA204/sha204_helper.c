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
 * \file sha204_helper.c
 *
 * \brief This file contains helper functions for performing certain actions on
 * the ATSHA204.
 *
 * \author Computer Measurement Laboratory
 */

#include <stdio.h>
#include "I2C/SHA204/sha204_helper.h"
#include "I2C/SHA204/sha204_comm.h"
#include "I2C/SHA204/sha204_comm_marshaling.h"
#include "I2C/SHA204/sha204_lib_return_codes.h"
#include "sha_256.h"
#include "HardwareProfile.h"

static UINT8 wake_rsp[4];

/*!
 * \brief Sends a wakeup command to the ATSHA204.
 *
 * \return a code indicating the status of the operation
 */
UINT8 SHA204_Wakeup(void)
{
    UINT8 ret_code;
    UINT8 wake_rsp[SHA204_RSP_SIZE_MIN];

    ret_code = sha204c_wakeup(&wake_rsp[0]);
    return ret_code;
}

/*!
 * \brief Performs a MAC operation on the ATSHA204.
 *
 * \param mode the mode byte required for the command
 * \param slot_id the slot to use as part of the message to hash
 * \param challenge a pointer to an input challenge to use as part of the message to hash
 * \param mac a pointer to where to store the MAC
 *
 * \return a code indicating the status of the operation
 */
UINT8 SHA204_Mac(UINT8 mode, UINT8 slot_id, UINT8 *challenge, UINT8 *mac)
{
    UINT8 ret_code;
    UINT8 mac_tx[MAC_COUNT_SHORT];
    UINT8 mac_tx_long[MAC_COUNT_LONG];
    UINT8 mac_rx[MAC_RSP_SIZE];
    int i;

    ret_code = sha204m_execute(SHA204_MAC, mode, slot_id, MAC_CHALLENGE_SIZE,
        challenge, 0, NULL, 0, NULL, MAC_COUNT_LONG, mac_tx_long, MAC_RSP_SIZE,
        mac_rx);

    if (ret_code == SHA204_SUCCESS) {
        for (i = 0; i < 32; i++) {
            mac[i] = mac_rx[i+1];
        }
    } else {
        for (i = 0; i < 32; i++) {
            mac[i] = 0;
        }
    }

    return ret_code;
}

/*!
 * \brief Performs a CheckMAC command on the ATSHA204.
 * 
 * \param mode[in] the mode byte (Param1)
 * \param slot_id[in] the slot to use in the client challenge (Param2)
 * \param client_chal[in] a pointer to an array containing the externally hashed client challenge to compare against (Data1)
 * \param client_resp[in] a pointer to an array containing the externally hashed expected response to compare against (Data2)
 * \param other_data[in] a pointer to an array containing the other data used in the comparison hash (Data3)
 * \param checkmac_rsp[out] a pointer to the return value from the CheckMAC command
 *
 * \return a code indicating the status of the operation
 */

UINT8 SHA204_CheckMAC(UINT8 mode, UINT16 slot_id, UINT8 *client_chal,
    UINT8 *client_resp, UINT8 *other_data, UINT8 *checkmac_rsp)
{
    UINT8 ret_code;
    UINT8 checkmac_tx[CHECKMAC_COUNT];
    UINT8 checkmac_rx[CHECKMAC_RSP_SIZE];
    UINT8 wake_rsp[SHA204_RSP_SIZE_MIN];
    int i;

    ret_code = sha204m_execute(SHA204_CHECKMAC, mode, slot_id, CHECKMAC_CLIENT_CHALLENGE_SIZE,
        &client_chal[0], CHECKMAC_CLIENT_RESPONSE_SIZE, &client_resp[0], CHECKMAC_OTHER_DATA_SIZE,
        &other_data[0], CHECKMAC_COUNT, &checkmac_tx[0], CHECKMAC_RSP_SIZE, &checkmac_rx[0]);

    if (ret_code == SHA204_SUCCESS) {
        *checkmac_rsp = checkmac_rx[1];
    }

    return ret_code;
}

/*!
 * \brief Performs a NONCE command on the ATSHA204.
 *
 * \param mode[in] the mode byte (Param1)
 * \param num_in[in] the input seed (Data)
 * \param rand_num[out] a pointer to an array to store the random number response from the NONCE command, if any
 *
 * \return a code indicating the status of the operation
 */
UINT8 SHA204_Nonce(UINT8 mode, UINT8 *num_in, UINT8 *rand_num)
{
    UINT8 ret_code;
    UINT8 nonce_tx_short[NONCE_COUNT_SHORT];
    UINT8 nonce_tx_long[NONCE_COUNT_LONG];
    UINT8 nonce_rx_short[NONCE_RSP_SIZE_SHORT];
    UINT8 nonce_rx_long[NONCE_RSP_SIZE_LONG];
    UINT8 wake_rsp[SHA204_RSP_SIZE_MIN];
    int i;

    if (mode == 0x00 || mode == 0x01) {
        ret_code = sha204m_execute(SHA204_NONCE, mode, 0x0000, NONCE_NUMIN_SIZE, num_in, 0,
            NULL, 0, NULL, NONCE_COUNT_SHORT, &nonce_tx_short[0], NONCE_RSP_SIZE_LONG,
            &nonce_rx_long[0]);
        if (ret_code == SHA204_SUCCESS) {
            for (i = 0; i < 32; i++) {
                rand_num[i] = nonce_rx_long[i+1];
            }
        }
    } else {
        ret_code = sha204m_execute(SHA204_NONCE, mode, 0x0000, 32, num_in, 0,
            NULL, 0, NULL, NONCE_COUNT_LONG, &nonce_tx_long[0], NONCE_RSP_SIZE_SHORT,
            &nonce_rx_short[0]);
    }

    return ret_code;
}

/*!
 * \brief Reads a word (4 bytes) from the configuration zone.
 *
 * \param config_rd_val[out] a pointer to where to store the word read
 * \param word_addr[in] the address of the word to read
 *
 * \return a code indicating the status of the operation
 */
UINT8 SHA204_ReadConfig(UINT8 *config_rd_val, UINT16 word_addr)
{
    UINT8 ret_code;
    UINT8 read_cfg_tx[READ_COUNT];
    UINT8 read_cfg_rx[READ_4_RSP_SIZE];
    INT i;

    ret_code = sha204m_execute(SHA204_READ, 0x00, word_addr, 0, NULL, 0, NULL,
                        0, NULL, READ_COUNT, &read_cfg_tx[0], READ_4_RSP_SIZE,
                        &read_cfg_rx[0]);
    if (ret_code != SHA204_SUCCESS) {
        DEBUG_PRINT(("Configuration read failed: 0x%02x\r\n", ret_code));
        return ret_code;
    }

    for (i = 0; i < 4; i++) {
        config_rd_val[i] = read_cfg_rx[i+1];
    }

    return ret_code;
}

/*!
 * \brief Reads a data slot.
 *
 * \param data_rd_val buffer to store the values read
 * \param the word address of the slot to read
 *
 * \return a code indicating the status of the operation
 */
UINT8 SHA204_ReadData(UINT8 *data_rd_val, UINT16 word_addr)
{
    UINT8 ret_code;
    UINT8 read_dat_tx[READ_COUNT];
    UINT8 read_dat_rx[READ_32_RSP_SIZE];
    int i;

    ret_code = sha204m_execute(SHA204_READ, 0x82, word_addr,
                        0, NULL, 0, NULL, 0, NULL, READ_COUNT, &read_dat_tx[0],
                        READ_32_RSP_SIZE, &read_dat_rx[0]);
    if (ret_code != SHA204_SUCCESS) {
        printf("Data read failed: 0x%02x\r\n", ret_code);
        return ret_code;
    }

    for (i = 0; i < 32; i++) {
        data_rd_val[i] = read_dat_rx[i+1];
    }

    return ret_code;
}

/*!
 * \brief Writes a 32 byte value to one of the 16 data slots.
 *
 * If the data zone is unlocked, writes can be done freely.  Each slot should be
 * written before the data zone is locked.  Once the data zone is locked, it is
 * necessary to use SHA204_EncryptedSlotWrite() to update the value in the slot.
 *
 * \param slot_wr_val[in] a pointer to a 32 byte array to write to a slot
 * \param slot_num[in] the slot number to write to
 *
 * \return a code indicating the status of the operation
 */
UINT8 SHA204_WriteData(UINT8 *slot_wr_val, UINT16 word_addr)
{
    UINT8 ret_code;
    UINT8 write_tx[WRITE_COUNT_LONG];
    UINT8 write_rx[WRITE_RSP_SIZE];
    UINT i;

    ret_code = sha204m_execute(SHA204_WRITE, 0x82, word_addr, 32, slot_wr_val,
                                0, NULL, 0, NULL, WRITE_COUNT_LONG, write_tx,
                                WRITE_RSP_SIZE, write_rx);

    // write data quietly
    if (ret_code != SHA204_SUCCESS || write_rx[1] != 0x00) {
        DEBUG_PRINT(("Failure writing slot address 0x%04x : 0x%02x\r\n", word_addr, ret_code));
        for (i = 0; i < 4; i++) {
            DEBUG_PRINT(("Write response[%d] : 0x%02x\r\n", i, write_rx[i]));
        }
        return ret_code;
    }

    return ret_code;
}

/*!
 * \brief Read 4 bytes of the OTP zone
 *
 * \param otp_val buffer to store the 4 OTP bytes read
 * \param otp_addr the OTP word address to read
 *
 * \return a code indicating the status of the operation
 */
UINT8 SHA204_ReadOTP(UINT8 *otp_val, UINT16 otp_addr)
{
    UINT8 ret_code;
    UINT8 read_otp_tx[READ_COUNT];
    UINT8 read_otp_rx[READ_4_RSP_SIZE];
    int i;

    ret_code = sha204m_execute(SHA204_READ, 0x01, otp_addr, 0, NULL, 0, NULL,
            0, NULL, READ_COUNT, read_otp_tx, READ_4_RSP_SIZE, read_otp_rx);

    // read the OTP zone queitly
    if (ret_code != SHA204_SUCCESS) {
        printf("Reading the OTP zone failed: 0x%02x\r\n", ret_code);
        return ret_code;
    }

    for (i = 0; i < 4; i++) {
        otp_val[i] = read_otp_rx[i+1];
    }
    return ret_code;
}
