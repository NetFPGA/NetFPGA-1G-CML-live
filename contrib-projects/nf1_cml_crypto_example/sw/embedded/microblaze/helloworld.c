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
 * \file helloworld.c
 *
 * \brief A simple test application to demonstrate RTC and ATSHA204 functions.
 *
 * \author Computer Measurement Laboratory
 *
 */

#include <stdio.h>
#include <string.h>
#include <xbasic_types.h>
#include "platform.h"
#include "fpga_messages.h"
#include "xspi.h"
#include "xparameters.h"
#include "sha_256.h"
#include "fpga_pic_comm.h"

#define TEST_DATA_SZ         256
#define LENGTH_OVERFLOW      0x00

// define used in the PIC code, defined here to match
#define MAC_CHALLENGE_SIZE 32

void atsha_nonce_test(void);
void atsha_auth_test(void);
void atsha_mac_test(void);
void atsha_config_test(void);
void atsha_rd_wr_test(void);
void rtc_test(void);
void debug_info(void);
void display_rtc_time(u8 *);

/*!
 * \brief Main function that calls a number of tests that demonstrate how to
 * communicate with the PIC to perform commands on the RTC and ATSHA204.
 */
int main()
{
    init_platform();
    InitSPI();

    xil_printf("\r\n*********************************\r\n**\r\n** built %s at %s\r\n**\r\n*********************************\r\n\n", __DATE__, __TIME__);
    xil_printf("Testing FPGA ability to use the PIC to\r\n");
    xil_printf("relay info from ATSHA and RTC parts\r\n\n");

    xil_printf("------------------------------------------------------------------------------------------------\r\n");
    xil_printf("------------------------------------------------------------------------------------------------\r\n");
    // read/write the RTC
    rtc_test();

    xil_printf("------------------------------------------------------------------------------------------------\r\n");
    xil_printf("------------------------------------------------------------------------------------------------\r\n");
    // read the ATSHA204 config zone
    atsha_config_test();

    xil_printf("------------------------------------------------------------------------------------------------\r\n");
    xil_printf("------------------------------------------------------------------------------------------------\r\n");
    // get a NONCE from the ATSHA204
    atsha_nonce_test();

    xil_printf("------------------------------------------------------------------------------------------------\r\n");
    xil_printf("------------------------------------------------------------------------------------------------\r\n");
    // read/write the data slots in the ATSHA204
    atsha_rd_wr_test();

    xil_printf("------------------------------------------------------------------------------------------------\r\n");
    xil_printf("------------------------------------------------------------------------------------------------\r\n");
    // generate a MAC with the ATSHA204
    atsha_mac_test();

    xil_printf("------------------------------------------------------------------------------------------------\r\n");
    xil_printf("------------------------------------------------------------------------------------------------\r\n");
    // authorize a SHA256 hash with the ATSHA204
    atsha_auth_test();

    xil_printf("------------------------------------------------------------------------------------------------\r\n");
    xil_printf("------------------------------------------------------------------------------------------------\r\n");

    xil_printf("\r\n\n**********************************\r\n");
    xil_printf("ok, all done with testing,\r\n");
    xil_printf("    (now entering forever loop to wait for restart)\r\n");
    while(1);
}

/*!
 * \brief Commands the PIC to read a config zone from the ATSHA204 and return 
 * the result.
 */
void atsha_config_test(void)
{
    u8 rcv_data[32];

    xil_printf("\r\n** Starting Read ATSHA204 Configuration Zone Test ( atsha_config_test ) **\r\n");
    
    // checks to verify a manufacturer hard coded value is read correctly
    if(FALSE == read_config(&rcv_data[0], 0)) {
        xil_printf("       Failure reading ATSHA204 Config word 3\r\n");
        xil_printf("\r\n!! Read ATSHA204 Config Test FAILED !!\r\n\n");
        return;
    }

    if((rcv_data[0] != 0x01) || (rcv_data[1] != 0x23)) {
        xil_printf("       Failure reading ATSHA204 Config word 0\r\n");
        xil_printf("       Read was successful, but data did not match:\r\n");
        xil_printf("           expected: 0x0123, received 0x%02X%02X\r\n", rcv_data[0], rcv_data[1]);
        xil_printf("\r\n!! Read ATSHA204 Config Test FAILED !!\r\n\n");
        return;
    } else {
        xil_printf("       Success reading ATSHA204 Config word 0\r\n");
        xil_printf("           received: 0x0123\r\n");
    }

    // check to see if the slot configuration was cleared during our
    // manufacturing test...
    if(FALSE == read_config(&rcv_data[0], 10)) {
        xil_printf("       Failure reading ATSHA204 Config word 10\r\n");
        xil_printf("\r\n!! Read ATSHA204 Config Test FAILED !!\r\n\n");
        return;
    }

    if((rcv_data[0] != 0x00) || (rcv_data[1] != 0x00) || (rcv_data[2] != 0x00) || (rcv_data[3] != 0x00)) {
        xil_printf("       Failure reading ATSHA204 Config word 10\r\n");
        xil_printf("       Read was successful, but data did not match:\r\n");
        xil_printf("           expected: 0x000000, received 0x%02X%02X%02X%02X\r\n", rcv_data[0], rcv_data[1], rcv_data[2], rcv_data[3]);
        xil_printf("\r\n!! Read ATSHA204 Config Test FAILED !!\r\n\n");
        return;
    } else {
        xil_printf("       Success reading ATSHA204 Config word 10\r\n");
        xil_printf("           received: 0x000000\r\n");
    }

    xil_printf("\r\n** Read ATSHA204 Config Test Passed **\r\n\n");
    return;
}

/*!
 * \brief Commands the PIC to write a data slot in the ATSHA204 and then
 * read and return its contents for verification.
 */
void atsha_rd_wr_test(void)
{
    u8 i;
    u8 rcv_data[32];
    u8 snd_data[32];

    xil_printf("\r\n** Starting ATSHA204 Read/Write Data Slot Test ( atsha_rd_wr_test ) **\r\n");
    if (FALSE == read_key(0, &rcv_data[0])) {
        xil_printf("       Failure reading key in ATSHA204 slot 0\r\n");
        xil_printf("\r\n!! Read ATSHA204 Data Slot FAILED !! \r\n\n");
        return;
    } else {
        xil_printf("       Slot 0 contents:\r\n          ");
        for (i = 0; i < 32; i++) {
            xil_printf(" 0x%02x", rcv_data[i]);
            if (i == 15) {
                xil_printf("\r\n          ");
            }
        }
        xil_printf("\r\n\n");
    }

    // put some data in the snd_data array
    for(i=0;i<32;i++)
    {
        snd_data[i] = (rcv_data[i] + 0x10);
    }
    xil_printf("       Data to write to Slot 0:\r\n          ");
    for (i = 0; i < 32; i++) {
        xil_printf(" 0x%02x", snd_data[i]);
        if (i == 15) {
            xil_printf("\r\n          ");
        }
    }
    xil_printf("\r\n\n");

    // actually send it...
    if (FALSE == store_key(0, &snd_data[0])) {
        xil_printf("       Failure storing key in ATSHA204 slot 0\r\n");
        xil_printf("\r\n!! Write ATSHA204 Data Slot FAILED !!\r\n\n");
        return;
    }
 
    // save original values
    for(i=0;i<32;i++)
        snd_data[i] = rcv_data[i];

    // read it back
    read_key(0, &rcv_data[0]);
    if (FALSE == read_key(0, &rcv_data[0])) {
        xil_printf("       Failure reading key in ATSHA204 slot 0\r\n");
        xil_printf("\r\n!! Read ATSHA204 Data Slot FAILED !! \r\n\n");
        return;
    } else {
        xil_printf("       Slot 0 contents after write:\r\n          ");
        for (i = 0; i < 32; i++) {
            xil_printf(" 0x%02x", rcv_data[i]);
            if (i == 15) {
                xil_printf("\r\n          ");
            }
        }
        xil_printf("\r\n");
    }

    // restore the original values...
    if (FALSE == store_key(0, &snd_data[0])) {
        xil_printf("       Failure restoring key in ATSHA204 slot 0\r\n");
        xil_printf("\r\n!! Write ATSHA204 Data Slot FAILED !!\r\n\n");
        return;
    }

    xil_printf("\r\n** ATSHA204 Read/Write Data Slot Test Passed **\r\n\n");
    return;
}

/*!
 * \brief Commands the PIC to write time values to the RTC and then read them
 * back and return them for verification.
 */
void rtc_test(void)
{
    u8 rcv_data[9];
    u8 snd_data[32];
    u8 orig_data[9];
    u8 i;

    xil_printf("\r\n** Starting RTC Test ( rtc_test ) **\r\n");

    // store current time
    request_rtc_time(&orig_data[0]);    

    xil_printf("       original RTC time:\r\n          ");
    display_rtc_time(&orig_data[0]);

    // create a time to be written to the RTC (Tuesday April 7 2015 18:05:30.00)
    snd_data[0] = 0;    // century
    snd_data[1] = 15;   // year
    snd_data[2] = 4;    // month
    snd_data[3] = 7;    // date
    snd_data[4] = 3;    // dow
    snd_data[5] = 18;   // hour
    snd_data[6] = 5;    // min
    snd_data[7] = 30;   // sec
    snd_data[8] = 0;    // tenths

    xil_printf("       setting RTC time:\r\n          ");

    display_rtc_time(&snd_data[0]);

    set_rtc_time(&snd_data[0]);

    request_rtc_time(&rcv_data[0]);

    xil_printf("       get RTC time:\r\n          ");
    display_rtc_time(&rcv_data[0]);

    xil_printf("       restoring RTC time:\r\n");
    // restore to previous
    set_rtc_time(&orig_data[0]);

    // if the tenths of a second of the time read back is greater than written,
    // the test passes, otherwise it fails
    if (rcv_data[8] > snd_data[8]) {
        xil_printf("\r\n** RTC Test Passed **\r\n\n");
        return;
    } else {
        xil_printf("\r\n!! RTC Test FAILED !!\r\n\n");
        return;
    }
}

/*!
 * \brief Takes the RTC data array and parses it to print in human-readable
 * format.
 *
 * \param[in] buf a pointer to the buffer containing time values read from
 * the RTC.
 */
void display_rtc_time(u8 *buf)
{
    switch(buf[4]) {
        case 1:
            xil_printf("Sunday ");
            break;
        case 2:
            xil_printf("Monday ");
            break;
        case 3:
            xil_printf("Tuesday ");
            break;
        case 4:
            xil_printf("Wednesday ");
            break;
        case 5:
            xil_printf("Thursday ");
            break;
        case 6:
            xil_printf("Friday ");
            break;
        case 7:
            xil_printf("Saturday ");
            break;
        default:
            xil_printf("Invalid day of week ");
            break;
    }

    switch (buf[2]) {
        case 1:
            xil_printf("January ");
            break;
        case 2:
            xil_printf("February ");
            break;

        case 3:
            xil_printf("March ");
            break;

        case 4:
            xil_printf("April ");
            break;

        case 5:
            xil_printf("May ");
            break;

        case 6:
            xil_printf("June ");
            break;

        case 7:
            xil_printf("July ");
            break;

        case 8:
            xil_printf("August ");
            break;

        case 9:
            xil_printf("September ");
            break;

        case 10:
            xil_printf("October ");
            break;

        case 11:
            xil_printf("November ");
            break;

        case 12:
            xil_printf("December ");
            break;

        default:
            xil_printf("Invalid week ");
            break;

    }

    xil_printf("%d 2%d%02d  %02d:%02d:%02d.%02d\r\n", buf[3], buf[0], buf[1], buf[5], buf[6], buf[7], buf[8]);

    xil_printf("\r\n");
}

/*!
 * \brief Commands the PIC to perform a NONCE command on the ATSHA204 and 
 * return the resulting NONCE.
 */
void atsha_nonce_test(void)
{
    u8 nonce[32];
    int i;

    xil_printf("\r\n** Starting Nonce Test ( atsha_nonce_test ) **\r\n");
    if (FALSE == request_nonce(&nonce[0])) {
        xil_printf("\r\n!! Nonce test FAILED !!\r\n\n");
    } else {
        xil_printf("       Nonce:\r\n          ");
        for (i = 0; i < 32; i++) {
            xil_printf(" 0x%02x", nonce[i]);
            if (i == 15) {
                xil_printf("\r\n          ");
            }
        }
        xil_printf("\r\n");
        xil_printf("\r\n** Nonce test Passed **\r\n\n");
    }
}

/*!
 * \brief Commands the PIC to perform a MAC command on the ATSHA204 and
 * return the resulting MAC.
 */
void atsha_mac_test(void)
{
    u8 challenge[MAC_CHALLENGE_SIZE];
    u8 i;
    u8 mac[32];
    u8 mode = 0;
    u8 slot = 5;
// <<==    u8 test_key[32];

    for (i = 0; i < MAC_CHALLENGE_SIZE; i++) {
        challenge[i] = i+1;
    }

// <<==    for (i = 0; i < 32; i++) {
// <<==        test_key[i] = 0x20 + i;
// <<==    }

    xil_printf("\r\n** Starting ATSHA204 MAC Test ( atsha_mac_test ) **\r\n");
    // <<== uncomment this... store_key(slot, &test_key[0]);
    if (FALSE == request_mac(mode, slot, &challenge[0], &mac[0])) {
        xil_printf("\r\n!! ATSHA204 MAC Test FAILED !!\r\n\n");
    } else {
        xil_printf("       MAC:\r\n          ");
        for (i = 0; i < 32; i++) {
            xil_printf(" 0x%02x", mac[i]);
            if (i == 15) {
                xil_printf("\r\n          ");
            }
        }
        xil_printf("\r\n");
        xil_printf("\r\n** ATSHA204 MAC Test Passed **\r\n\n");
    }
}

/*!
 * \brief Commands the PIC to perform an authentication of a hash using the
 * ATSHA204's CheckMAC command.
 */
void atsha_auth_test(void)
{
    u32 i;
    u8 test_data[TEST_DATA_SZ];
    u8 digest[32];
    u8 nonce[32];
    u8 auth_hash[32];
    u8 test_slot;

    test_slot = 3;

    xil_printf("\r\n** Starting ATSHA204 Authentication Test Using Slot %d ( atsha_auth_test ) **\r\n", test_slot);

    // generate data for the test to hash
    for ( i = 0; i < TEST_DATA_SZ; i++) {
        test_data[i] = i+4;
    }

    for (i = 0; i < 32; i++) {
        digest[i] = 0;
    }

    xil_printf("       Generating test key for authentication\r\n\n");
    // hash the sample test data to produce the key that is used by the verification test
    SHA256_HashMessage(&test_data[0], TEST_DATA_SZ, &digest[0]);

    xil_printf("       Writing test key\r\n\n");
    // need to ensure the key to be used is written to the slot on the ATSHA204 that will be used for the verification check
    if (TRUE != store_key(test_slot, &digest[0])) {
        xil_printf("\r\n!! Aborting atsha_auth_test after STORE_KEY failure\r\n");
        return;
    }
    
    xil_printf("       Requesting NONCE\r\n\n");
    // get a nonce via the PIC;
    if (TRUE != request_nonce(&nonce[0])) {
        xil_printf("\r\n!! Error with pic request nonce !! (aborting)\r\n\n");
        return;
    }
    
    xil_printf("       Generating authentication comparison hash\r\n\n");
    // hash the nonce and the key/digest together
    hashKeyNonceAndSalt(&digest[0], &nonce[0], &auth_hash[0]);

    xil_printf("       Authenticating hash with ATSHA204\r\n");
    // request the PIC use the ATSHA204 to verify the hashed nonce and key...
    if (TRUE != request_auth(test_slot, &auth_hash[0])) {
        xil_printf("\r\n!! Authentication Test FAILED !!\r\n\n");
    } else {
        xil_printf("\r\n** Authentication Test Passed **\r\n\n");
    }
}
