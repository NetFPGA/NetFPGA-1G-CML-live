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
 * \file fpga_pic_comm.c
 *
 * \brief This code supports communication via SPI between a MicroBlaze
 * processor running on the Xilinx FPGA and the PIC microcontroller
 * that are on the CML NetFPGA-1G board. This code is for the 
 * MicroBlaze processor. It uses two SPIC busses, one to send and
 * the other to receive. 
 *
 * \author Computer Measurement Laboratory
 */

#include <stdio.h>
#include <string.h>
#include <xbasic_types.h>
#include "platform.h"
#include "xparameters.h"
#include "xspi.h"
#include "fpga_messages.h"
#include "sha_256.h"
#include "fpga_pic_comm.h"

// defines for conditional compile items
#define DEBUG 0


// debug defines to read SPI registers directly
#define PIC2FPGA_CNTL_REG (volatile u32 *)(XPAR_PIC_FPGA_SPI_BASEADDR + 0x60)
#define PIC2FPGA_STAT_REG (volatile u32 *)(XPAR_PIC_FPGA_SPI_BASEADDR + 0x64)

// defines for the SPI interface to the PIC
#define F2P_SPI_DEVICE_ID    XPAR_SPI_0_DEVICE_ID
#define P2F_SPI_DEVICE_ID    XPAR_SPI_1_DEVICE_ID

// define used in the PIC code, defined here to match
#define MAC_CHALLENGE_SIZE 32

static XSpi f2p_spi_inst;  // FPGA to PIC SPI controller software instance pointer
static XSpi p2f_spi_inst;  // PIC to FPGA SPI controller software instance pointer

static u8 other_data[13] = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i',
                             'j', 'k', 'l', 'm' };

// forward prototypes for locally used functions
static u8 send_PIC_read(u8 request, u8 addr, u8 len, u8 xtra);
static u8 send_PIC_write(u8 request, u8 addr, u8 *data, u8 len, u8 xtra);
static u8 get_PIC_response(u8 *resp, u8 len);
static u8 get_PIC_ack(void);

/*****************************************************************
 *
 * The following are public functions of this file and are exposed 
 * for use outside of this file by including fpga_pic_comm.h.
 *
 ****************************************************************/
/*!
 * \brief Configures the SPI ports to be available for communication. 
 *  
 *  One SPI port is used to send messages from the FPGA to the PIC and
 *  is prefixed with f2p. Conversely, the other SPI port sends messages
 *  from the PIC to the FPGA and is prefixed with p2f.
 *
 *  The configurations are stored in global instance pointers that are 
 *  used by this function (and others) in this file.
 */
int InitSPI()
{
    XSpi_Config *f2p_cfg_p;
    XSpi_Config *p2f_cfg_p;
    int status;

    // lookup the FPGA to PIC SPI interface configuration from hardware
    f2p_cfg_p = XSpi_LookupConfig(F2P_SPI_DEVICE_ID);
    if (f2p_cfg_p == NULL) {
        xil_printf("Null f2p SPI configuration pointer\r\n");
        return XST_FAILURE;
    }
    // lookup the PIC to FPGA SPI interface configuration from hardware
    p2f_cfg_p = XSpi_LookupConfig(P2F_SPI_DEVICE_ID);
    if (p2f_cfg_p == NULL) {
        xil_printf("Null p2f SPI configuration pointer\r\n");
        return XST_FAILURE;
    }

    // initialize the XSpi FPGA to PIC configuration from the hardware configuration
    status = XSpi_CfgInitialize(&f2p_spi_inst, f2p_cfg_p, f2p_cfg_p->BaseAddress);
    if (status != XST_SUCCESS) {
        xil_printf("Initializing f2p configuration failed\r\n");
        return status;
    }

    // initialize the XSpi PIC to FPGA configuration from the hardware configuration
    status = XSpi_CfgInitialize(&p2f_spi_inst, p2f_cfg_p, p2f_cfg_p->BaseAddress);
    if (status != XST_SUCCESS) {
        xil_printf("Initializing p2f configuration failed\r\n");
        return status;
    }

    // set the FPGA as the master to the PIC on the FPGA to PIC interface
    status = XSpi_SetOptions(&f2p_spi_inst, XSP_MASTER_OPTION);

    if (status != XST_SUCCESS) {
        xil_printf("Setting f2p options failed\r\n");
        return status;
    }

    // start the interfaces
    XSpi_Start(&f2p_spi_inst);
    XSpi_Start(&p2f_spi_inst);

    // disable the interrupts
    XSpi_IntrGlobalDisable(&f2p_spi_inst);
    XSpi_IntrGlobalDisable(&p2f_spi_inst);

    return status;
}


/*!
 * \brief Hashes together a key and NONCE (from getSystemNonce) to form part of
 * the message for CheckMAC.
 *
 * \param[in] key the key value to compare to a slot value
 * \param[in] nonce a NONCE from getSystemNonce()
 * \param[out] key_nonce_hash the hash of the key and NONCE
 */
// this was swiped from the authenticate.c file for the PIC code since
// this needs to be run on the Microblaze.
void hashKeyNonceAndSalt(u8 *key, u8 *nonce, u8 *key_nonce_salt_hash)
{
    u8 blk_to_hash[88];
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
 * \brief Send data to the ATSHA204 to be authenticated
 *
 * Send data and a specific slot number to the PIC and request that
 * the PIC have the ATSHA204 authenticate that data using the value 
 * contained in the specified slot.
 *
 * \param slot[in] the slot number to use for the authentication
 * \param hash[in] a unsigned byte pointer to 32 bytes of data
 *                 to be authenticated
 *
 * \return a code indicating the status of the operation
 */
u8 request_auth(u8 slot, u8 *hash)
{
    if (send_PIC_write(ATSHA204_AUTH, slot*8, hash, 32, NULL)) {
        return (FALSE);
    }

    return (TRUE);
}

/*!
 * \brief Get a new nonce from the ATSHA204
 *
 * Have the PIC get a new nonce from the ATSHA204 and return
 * it using the nonce pointer.
 *
 * \param nonce[out] A byte pointer used to receive 32 bytes
 *                   containing the new nonce
 *
 * \return a code indicating the status of the operation
 */
u8 request_nonce(u8 *nonce)
{
    if (!(send_PIC_read(ATSHA204_NONCE, NULL, NULL, NULL))) {
        get_PIC_response(nonce, 32);
        return (TRUE);
    } else {
        return (FALSE);
    }
}


/*!
 * \brief Save a authentication key to the ATSHA204
 *
 * Have the PIC store the authentication key in a specific
 * slot on the ATSHA204
 *
 * \param slot[in] The location in the ATSHA204 where the
 *                 authentication data should be written.
 * \param key[in] A byte pointer to 32 bytes of authentication
 *                data to be written to the specified slot.
 *
 * \return a code indicating the status of the operation
 */
u8 store_key(u16 slot, u8 *key)
{
    if (send_PIC_write(ATSHA204_WRITE_DATA, slot*8, key, 32, NULL)) {
        return (FALSE);
    }
    
    return (TRUE);
}

/*!
 * \brief Retrieve a authentication key from the ATSHA204
 *
 * Have the PIC read the ATSHA204 and return the authentication 
 * key in the specified slot.
 *
 * \param slot[in] The location in the ATSHA204 where the
 *                 authentication data should be read.
 * \param key[out] A byte pointer to 32 bytes where the authentication
 *                 data from the specified slot can be written.
 *
 * \return a code indicating the status of the operation
 */
u8 read_key(u16 slot, u8 *key)
{
    if (!(send_PIC_read(ATSHA204_READ_DATA, slot*8, 32, NULL))) {
        get_PIC_response(key, 32);
        return (TRUE);
    } else {
        return (FALSE);
    }
}

/*!
 * \brief Retrieve configuration information for a slot on the ATSHA204
 *
 * Have the PIC read the ATSHA204 and return the slot configuration held
 * at the requested address.
 *
 * \param addr[in] Address in the ATSHA204 to read the configuration data
 * \param data[in] Byte pointer to 4 bytes of data to store at the
 *                 specified address
 *
 * \return a code indicating the status of the operation
 */
u8 read_config(u8 *data, u16 addr)
{
#if (1 == DEBUG)
    u8 i;
#endif

    if (!(send_PIC_read(ATSHA204_READ_CONFIG, addr, 4, NULL))) {
        get_PIC_response(data, 4);
#if (1 == DEBUG)
        xil_printf("        after requesting ATSHA Config, response array now contains:\r\n            ");
        for (i = 0; i < 4; i++) {
            xil_printf("0x%02X ", data[i]);
            if(i == 15)
                xil_printf("\r\n            ");
        }
        xil_printf("\r\n\n");
#endif
        return (TRUE);
    } else {
        xil_printf("\r\n!! Error with pic request to read ATSHA Config !!\r\n\n");
        return (FALSE);
    }
}

/*!
 * \brief Store configuration information for a slot on the ATSHA204
 *
 * Have the PIC write the configuration for a slot to the ATSHA204
 * at the requested address.
 *
 * \param addr[in] Address in the ATSHA204 to store the configuration data
 * \param data[in] Byte pointer to 4 bytes of data to store from the
 *                 specified address
 *
 * \return a code indicating the status of the operation
 */
u8 write_config(u8 *data, u16 addr)
{
    if (send_PIC_write(ATSHA204_WRITE_CONFIG, addr, data, 4, NULL)) {
        xil_printf("\r\n!! Error with pic request to write ATSHA Config!!\r\n\n");
        return (FALSE);
    } else {
        return (TRUE);
    }
}

// only mode == 0 is supported currently (may only be valid for the
// check/validation part of the operation on the PIC side. mode gets
// handled automatically by hardware and if the test/check code is 
// removed, it no longer matters eh?)
u8 request_mac(u8 mode, u8 slot, u8 *challenge, u8 *mac)
{
#if (1 == DEBUG)
    u8 i;
#endif

#if (1 == DEBUG)
    xil_printf("                    challenge: ");
    for (i = 0; i < MAC_CHALLENGE_SIZE; i++)
        xil_printf("0x%02X ", challenge[i]);

    xil_printf("\r\n");
#endif
    if (send_PIC_write(ATSHA204_MAC, slot, challenge, MAC_CHALLENGE_SIZE, mode)) {
        xil_printf("!! REQUEST_MAC Failed\r\n");
        return (FALSE);
    }
    if (PASS != get_PIC_response(mac, 32)) {
        xil_printf("!! REQUEST_MAC Failed\r\n");
        return (FALSE);
    }
#if (1 == DEBUG)
    printf("                    get_PIC_response returned\r\n");
    printf("                    returned mac: ");
    for (i = 0; i < 32; i++)
        xil_printf("0x%02X ", mac[i]);

    xil_printf("\r\n");
#endif
    
    return (TRUE);
}

/*!
 * \brief Get current time from the system's real time clock
 *
 * Have the PIC read the current time information from the 
 * board's real time clock chip.
 *
 * \param time_vals[out] Byte pointer to 9 bytes that will receive
 *                       the data read from the RTC
 *
 * \return a code indicating the status of the operation
 */
u8 request_rtc_time(u8 *time_vals)
{
#if (1 == DEBUG)
    u8 i;
#endif

    if (!(send_PIC_read(RTC_READ_TIME, NULL, NULL, NULL))) {
        if (PASS != get_PIC_response(time_vals, 9)) {
            xil_printf("    PIC had problem with read RTC command\r\n");
            return (FALSE);
        }
#if (1 == DEBUG)
        xil_printf("          after requesting RTC time, response array now contains:\r\n            ");
        for (i = 0; i < 9; i++)
            xil_printf("%d ", time_vals[i]);

        xil_printf("\r\n\n");
#endif
        return (TRUE);
    }
    else {
        xil_printf("\r\n!! Error with pic request to read RTC time !!\r\n\n");
        return (FALSE);
    }
}


/*!
 * \brief Set current time in the system's real time clock
 *
 * Have the PIC send the current time information to the 
 * board's real time clock chip.
 *
 * \param time_vals[in] Byte pointer to 9 bytes that contain
 *                      the data to write to the RTC
 *
 * \return a code indicating the status of the operation
 */

u8 set_rtc_time(u8 *time_vals)
{
    if (send_PIC_write(RTC_WRITE_TIME, NULL, time_vals, 9, NULL)) {
        xil_printf("\r\n!! Error with pic request to write RTC time (changing test values)!!\r\n\n");
        return (FALSE);
    }
    else {
        return (TRUE);
    }
}

/*
 * The following are private functions of this file and are not exposed 
 * for use by calling from outside of this file.
 */


/*!
 * \brief Have PIC retrieve data from targeted device
 *
 * Send a message to the PIC to read a specified number of
 * bytes from the address of the targeted device and have the
 * data ready to be read by get_PIC_response.
 *
 * \param request[in] indicates desired action using one of the
 *                    defines from fpga_messages.h
 * \param addr[in] indicates the address the read should use
 * \param len[in] number of bytes to be read. should match the
 *                number used when get_PIC_response is called.
 *
 * \return a code indicating the status of the operation
 */
u8 send_PIC_read(u8 request, u8 addr, u8 len, u8 xtra)
{
    u8 receive_val[32];
    XStatus result;
    u8 msg[] = {request, addr, len, xtra};
    u8 disp_wait_msg = 0;

#if (1 == DEBUG)
    xil_printf("    Sending read request -0x%04X- to PIC (len: %d)\r\n", request, len);
#endif

    XSpi_SetSlaveSelect(&f2p_spi_inst, 1);
    result = XSpi_Transfer(&f2p_spi_inst, &msg, &receive_val[0], sizeof(msg));
    XSpi_SetSlaveSelect(&f2p_spi_inst, 0);
    if (result != XST_SUCCESS) {
        xil_printf("!! Failure spi xfer to PIC\r\n");
        return (SPI_XFER_FAIL);
    }
    return (0);
}

/*!
 * \brief Have PIC store data to targeted device
 *
 * Send a message to the PIC to write a specified number of
 * bytes to the address of the targeted device.
 *
 * \param request[in] indicates desired action using one of the
 *                    defines from fpga_messages.h
 * \param addr[in] indicates the address the write should use
 * \param data[in] byte pointer to buffer containing data to
 *                 be written to the target device.
 * \param len[in] number of bytes to be written.
 *
 * \return a code indicating the status of the operation
 */
u8 send_PIC_write(u8 request, u8 addr, u8 *data, u8 len, u8 xtra)
{
    u8 receive_val[32];
    XStatus result;
    u8 msg[] = {request, addr, len, xtra};
    u8 snd_cnt;
    u8 disp_wait_msg = 0;

#if (1 == DEBUG)
    xil_printf("    Sending write request -0x%04X- to PIC (%d bytes), addr: 0x%04X\r\n", request, len, addr);
#endif
    
    XSpi_SetSlaveSelect(&f2p_spi_inst, 1);
    result = XSpi_Transfer(&f2p_spi_inst, &msg, &receive_val[0], sizeof(msg));         
    XSpi_SetSlaveSelect(&f2p_spi_inst, 0); 

    if (request != get_PIC_ack())
        return (SPI_OPERATION_FAIL);

    snd_cnt = 0;
    while (snd_cnt < len) {
        if (snd_cnt < (len - 16)) {
            XSpi_SetSlaveSelect(&f2p_spi_inst, 1);
            result = XSpi_Transfer(&f2p_spi_inst, data+snd_cnt, &receive_val[0], 16);         
            XSpi_SetSlaveSelect(&f2p_spi_inst, 0);
            snd_cnt += 16;
            if (DATA_ACK != get_PIC_ack()) {
                xil_printf("        !! Problem with write data transfer !!\r\n");
                return (SPI_XFER_FAIL);
            }
        }
        else {
            XSpi_SetSlaveSelect(&f2p_spi_inst, 1);
            result = XSpi_Transfer(&f2p_spi_inst, data+snd_cnt, &receive_val[0], (len-snd_cnt));
            XSpi_SetSlaveSelect(&f2p_spi_inst, 0);
            snd_cnt += (len-snd_cnt);
            if (DATA_ACK != get_PIC_ack()) {
                xil_printf("        !! Problem with write data transfer !!\r\n");
                return (SPI_XFER_FAIL);
            }
        }
    }

    if (result != XST_SUCCESS) {
        xil_printf("!! Failure spi xfer to PIC\r\n");
        return (SPI_XFER_FAIL);
    }
    //xil_printf("        wait for PASS ack (0x%02X)\r\n", PASS);
    result = get_PIC_ack();
    if (result != PASS) {
        return (SPI_OPERATION_FAIL);
    }

#if (1 == DEBUG)
    xil_printf("    returning from send_PIC_write\r\n"); 
#endif

    return(0);
}

u8 get_PIC_ack(void)
{
    u8 msg = IGNORE;
    u8 resp = IGNORE;
    u8 result;

#if (1 == DEBUG)
    xil_printf("            starting get_PIC_ack from PIC\r\n");
#endif
    while (IGNORE == resp) {
        result = XSpi_Transfer(&p2f_spi_inst, &msg, &resp, 1);
    }
#if (1 == DEBUG)
    xil_printf("                finished get_PIC_ack from PIC (ack: 0x%02X)\r\n", resp);
#endif
    
    return(resp);
}

/*!
 * \brief Get results from the PIC
 *
 * Typically not called directly, this is used by the functions
 * in this file to retrieve results from a read operation or the
 * status of a write operation.
 *
 * \param resp[out] a byte pointer to location where the result being
 *                  read will be stored.
 * \param len[in] indicates the legth of the buffer that resp points to.
 *
 * \return a code indicating the status of the operation
 */
u8 get_PIC_response(u8 *resp, u8 len)
{
    u8 msg[32];
    XStatus result;
    u8 ret_val = PASS;
    u8 disp_wait_msg = 0;
    u8 rcv_resp_cnt = 0;

#if (1 == DEBUG)
    xil_printf("        starting get_PIC_response, read %d bytes from PIC\r\n", len);
#endif
    result = XSpi_Transfer(&p2f_spi_inst, &msg[0], resp, 16);
    if (resp[0] == PASS) {
        msg[0] = SEND_DATA;                                                                             // <<== notify received pass/fail data block to go on to real data
        XSpi_SetSlaveSelect(&f2p_spi_inst, 1); 
        result = XSpi_Transfer(&f2p_spi_inst, &msg[0], NULL, 1);
        XSpi_SetSlaveSelect(&f2p_spi_inst, 0); 
        while (rcv_resp_cnt < len) {
            if (rcv_resp_cnt < (len - 16)) {
                result = XSpi_Transfer(&p2f_spi_inst, &msg[0], resp+rcv_resp_cnt, 16);
                rcv_resp_cnt += 16;
                msg[0] = SEND_DATA;
                XSpi_SetSlaveSelect(&f2p_spi_inst, 1);
                result = XSpi_Transfer(&f2p_spi_inst, &msg[0], NULL, 1);
                XSpi_SetSlaveSelect(&f2p_spi_inst, 0);
            }
            else {
                result = XSpi_Transfer(&p2f_spi_inst, &msg[0], resp+rcv_resp_cnt, (len-rcv_resp_cnt));
                rcv_resp_cnt += (len-rcv_resp_cnt);
                msg[0] = SEND_DATA;
                XSpi_SetSlaveSelect(&f2p_spi_inst, 1);
                result = XSpi_Transfer(&f2p_spi_inst, &msg[0], NULL, 1);
                XSpi_SetSlaveSelect(&f2p_spi_inst, 0);
            }
        }
    }
    else {
        xil_printf("!!    PIC read FAILED, not reading data back\r\n");
        ret_val = FAIL;
    }

    if (result != XST_SUCCESS) {
        xil_printf("!! Failure spi xfer from PIC\r\n");
        return (SPI_XFER_FAIL);
    }
#if (1 == DEBUG)
    xil_printf("        returning from get_PIC_response\r\n");
#endif

    return (ret_val);
}


