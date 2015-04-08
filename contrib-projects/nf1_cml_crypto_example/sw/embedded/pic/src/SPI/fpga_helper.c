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
 * \file fpga_helper.c
 *
 * \brief Contains helper functions for communicating with the FPGA.
 *
 * \author Computer Measurement Laboratory
 */

#include <stdint.h>
#include <peripheral/spi.h>
#include "I2C/i2c_helper.h"
#include "I2C/M41T62/m41t62.h"
#include "SPI/fpga_helper.h"
#include "SPI/fpga_messages.h"
#include "I2C/SHA204/sha204_lib_return_codes.h"
#include "I2C/SHA204/sha204_comm_marshaling.h"
#include "I2C/SHA204/sha204_physical.h"

// used to select conditional compile items
#define DEBUG   1
#define VALIDATE_MAC 0

// make appropriate changes to defines based on other
// selected defines
#if (1 == DEBUG)
#define VERBOSE 1
#else
#define VERBOSE 0
#endif

// include needed for test/debug of sha204_mac command
#if (1 == VALIDATE_MAC)
#include "sha_256.h"
#endif

static RTC_TIME rtc_t;  // <<== does this really need to be a global?
UINT8 addr;
UINT8 len;
UINT8 xtra;

/*
 * Private forward prototypes
 */
UINT8 dispatch_req(BYTE req);
#if (1 == VERBOSE)
void show_FPGA_request(UINT8 request);
#endif
#if (1 == DEBUG)
void dump_SPI_status(SpiChannel spi_chan);
void show_RTC_val(RTC_TIME *time);
#endif

void init_FPGA_SPI(UINT8 channel)
{
}

UINT8 check_FPGA_SPI(UINT8 channel)
{
  UINT8 ret_val;
  BYTE req;

  if(FALSE == SpiChnDataRdy(SPI_CHANNEL4))
  {
    return(NO_MSG);
  }

  req  = SpiChnGetC(SPI_CHANNEL4);
  addr = SpiChnGetC(SPI_CHANNEL4);
  len  = SpiChnGetC(SPI_CHANNEL4);
  xtra = SpiChnGetC(SPI_CHANNEL4);
  ret_val = dispatch_req(req);
}

void send_FPGA_ack(UINT8 channel, UINT8 msg)
{
  while(SpiChnTxBuffCount(channel))
  {
  }
  delay_ms(50);
  SpiChnPutC(channel, msg);  // send the ACK to the MicroBlaze
  if(0 != SpiChnRxBuffCount(channel))
  {
    SpiChnGetC(channel);  
  }
}

void send_FPGA_SPI(UINT8 channel, UINT8 *msg, UINT8 len, UINT8 status)
{
  UINT8 i, j, k;
  UINT8 idx;
  UINT8 cur_len;
  UINT8 show_msg = 1;
  UINT8 tx_buf[48];

  // Now functions so that a read does not try to do a PASS/FAIL
  // ACK and then follows that with a seperate transmit of data. instead just
  // have the PIC send the PASS/FAIL value back as the first byte of all the 
  // data. the MicroBlaze should be able to read one byte from it's receive
  // buffer to see if the data is valid (PASS/FAIL). if it is valid, read
  // the remaining 15 bytes, then another 15 followed by a single if it 
  // was a full 32-byte transmission. so the loops to transmit and receive
  // will need thorough testing to make sure the uB SEND_DATA works out
  // correctly and solves the problem.
  memset(&tx_buf[0], IGNORE, 16);
  memcpy(&tx_buf[16], msg, len);
  tx_buf[0] = status;
  len+=16;

  while(SpiChnTxBuffCount(channel));
  
  j=0;
  for(i=0;i<len;i++)
  {
    if((!((i+1)%16)) || i == (len-1))
    {
      idx = (j * 16);
      cur_len = (i - idx) + 1;
      SpiChnPutS(channel, (UINT *)&tx_buf[idx], cur_len);  // send the data to the MicroBlaze
      
      while(0 == SpiChnRxBuffCount(SPI_CHANNEL4))
      {
        if(show_msg)
        {
          show_msg = 0;
        }
      } 
      show_msg = 1;
      SpiChnGetC(SPI_CHANNEL4);
      delay_ms(25);

      j++;
    }
  }
}

/*
 * Private functions
 */
UINT8 dispatch_req(BYTE req)
{
  I2C_RESULT i2c_val;
  UINT8 resp;
  UINT8 i, j;
  UINT8 snd_data[32];
  UINT8 rcv_data[32];
  UINT8 rcv_cnt = 0;
  UINT8 tmp_data[32];  
  UINT8 mac[MAC_RSP_SIZE];
  UINT8 rtc_val_buf[sizeof(RTC_TIME)];

#if (1 == VALIDATE_MAC)
  UINT8 test_hash[88] = {
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,  // first 16 bytes of key value that will be overwritten later
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,  // second 16 bytes of key value 
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,  // first 16 bytes of challenge that will be overwritten later
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,  // second 16 bytes of challenge
    0x08,                                            // begin 24 bytes for salt.
    0x00,
    // the short value for this is 0x000e.  But for some reason,
    // the ATSHA204 swaps the bytes to make it 0x0e00.  So, make
    // sure the LSB of the parameter comes first.
    0x0e, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00,
    0xee,
    0x00, 0x00, 0x00, 0x00,
    0x01, 0x23,
    0x00, 0x00
  };
  UINT8 test_hash_result[32];
  UINT8 tmp[4];
#endif

#if (1 == VERBOSE)
  show_FPGA_request(req);
#else
  delay_ms(25);
#endif
  switch(req)
  {
    case IGNORE:                             
#if (1 == VERBOSE)
                                             printf("IGNORE: Expecting blank clocks to allow input/output\r\n");
#endif
                                             break;
    case ATSHA204_READ_CONFIG:                                            
#if (1 == VERBOSE)
                                             printf("ATSHA204_READ_CONFIG, addr: %d, len: %d bytes\r\n", addr, len);
#endif
                                             sha204p_sleep();
                                             SHA204_Wakeup();                      // wake up ATSHA204 if not already awake
                                             if(SHA204_ReadConfig(&snd_data[0], addr))
                                             {
                                               resp = FAIL;
                                               len = 0; // overwrite this so only the FAIL status is sent back
                                             }
                                             else
                                             {
                                               resp = PASS;
                                             }
                                             send_FPGA_SPI(SPI_CHANNEL2, (UINT8 *)&snd_data[0], len, resp);
#if (1 == VERBOSE)
                                             printf("           ATSHA204_READ_CONFIG completed\r\n");
#endif
                                             break;
    case ATSHA204_NONCE:                                                  
#if (1 == VERBOSE)
                                             printf("MicroBlaze has requested a nonce\r\n");
#endif
                                             resp = getSystemNonce(&snd_data[0]);
                                             if(SHA204_SUCCESS != resp) 
                                             {
                                               resp = FAIL;
                                               len = 0; // overwrite this so only the FAIL status is sent back
                                             }
                                             else
                                             {
                                               resp = PASS;
                                             }
                                             send_FPGA_SPI(SPI_CHANNEL2, (UINT8 *)&snd_data[0], 32, resp);
                                             break;
    case ATSHA204_WRITE_DATA:                                             
#if (1 == VERBOSE)
                                             printf("ATSHA204_WRITE_DATA, slot: %d, len: %d bytes\r\n", addr, len);
#endif
                                             send_FPGA_ack(SPI_CHANNEL2, ATSHA204_WRITE_DATA);
                                             while(rcv_cnt < len)
                                             {
                                               if(rcv_cnt < (len - 16))
                                               {
                                                 SpiChnGetS(SPI_CHANNEL4, (UINT *)(&rcv_data[0]+rcv_cnt), 16);
                                                 rcv_cnt+=16;  
                                                 resp = DATA_ACK;
                                                 send_FPGA_ack(SPI_CHANNEL2, resp);
                                               }
                                               else
                                               {
                                                 SpiChnGetS(SPI_CHANNEL4, (UINT *)(&rcv_data[0]+rcv_cnt), (len-rcv_cnt));
                                                 rcv_cnt+=(len-rcv_cnt); 
                                                 resp = DATA_ACK;
                                                 send_FPGA_ack(SPI_CHANNEL2, resp); 
                                               }
                                             }

                                             sha204p_sleep();
                                             SHA204_Wakeup();                      // wake up ATSHA204 if not already awake
                                             resp = SHA204_WriteData(&rcv_data[0], (UINT16)addr);
                                             if(SHA204_SUCCESS == resp)       
                                             {
                                               resp = PASS;
                                             }
                                             else
                                             {
                                               resp = FAIL;
                                             }
                                             send_FPGA_ack(SPI_CHANNEL2, resp);                             
#if (1 == VERBOSE)
                                             printf("           ATSHA204_WRITE_DATA completed\r\n");
#endif
                                             break;
    case ATSHA204_READ_DATA:                                                                   
#if (1 == VERBOSE)
                                             printf("ATSHA204_READ_DATA\r\n");
#endif
                                             sha204p_sleep();
                                             SHA204_Wakeup();                     // wake up ATSHA204 if not already awake
                                             resp = SHA204_ReadData(&snd_data[0], addr);
                                             if(resp != SHA204_SUCCESS)
                                             {
                                               resp = FAIL;
                                               len = 0;
                                             }
                                             else
                                             {
                                               resp = PASS;
                                             }
                                             send_FPGA_SPI(SPI_CHANNEL2, (UINT8 *)&snd_data[0], len, resp);                                                                   
#if (1 == VERBOSE)
                                             printf("           ATSHA204_READ_DATA completed\r\n");
#endif
                                             break;
    case ATSHA204_AUTH:                                                   
#if (1 == VERBOSE)
                                             printf("ATSHA204_AUTH, slot: %d, len: %d bytes\r\n", addr/8, len);
#endif
                                             send_FPGA_ack(SPI_CHANNEL2, ATSHA204_AUTH);
                                             while(rcv_cnt < len)
                                             {
                                               if(rcv_cnt < (len - 16))
                                               {
                                                 SpiChnGetS(SPI_CHANNEL4, (UINT *)(&rcv_data[0]+rcv_cnt), 16);
                                                 rcv_cnt+=16; 
                                                 resp = DATA_ACK;
                                                 send_FPGA_ack(SPI_CHANNEL2, resp);
                                               }
                                               else
                                               {
                                                 SpiChnGetS(SPI_CHANNEL4, (UINT *)(&rcv_data[0]+rcv_cnt), (len-rcv_cnt));
                                                 rcv_cnt+=(len-rcv_cnt); 
                                                 resp = DATA_ACK;
                                                 send_FPGA_ack(SPI_CHANNEL2, resp);                                               
                                               }
                                             }

                                             if(TRUE == checkHash(&rcv_data[0], addr/8))
                                             {
                                               resp = PASS;
                                             }
                                             else
                                             {
                                               resp = FAIL;
                                             }                                             
                                             send_FPGA_ack(SPI_CHANNEL2, resp);
                                                                          
#if (1 == VERBOSE)
                                             printf("           ATSHA204_AUTH completed\r\n");
#endif
                                             break;
    case ATSHA204_MAC:                                                    
#if (1 == VERBOSE)
                                             printf("ATSHA204_MAC\r\n");
#endif
                                             send_FPGA_ack(SPI_CHANNEL2, ATSHA204_MAC);
                                             while(rcv_cnt < len)
                                             {
                                               if(rcv_cnt < (len - 16))
                                               {
                                                 SpiChnGetS(SPI_CHANNEL4, (UINT *)(&rcv_data[0]+rcv_cnt), 16);
                                                 rcv_cnt+=16;    
                                                 resp = DATA_ACK;
                                                 send_FPGA_ack(SPI_CHANNEL2, resp);   
                                               }
                                               else
                                               {
                                                 SpiChnGetS(SPI_CHANNEL4, (UINT *)(&rcv_data[0]+rcv_cnt), (len-rcv_cnt));
                                                 rcv_cnt+=(len-rcv_cnt);     
                                                 resp = DATA_ACK;
                                                 send_FPGA_ack(SPI_CHANNEL2, resp);                                            
                                               }
                                             }
                                             resp = PASS;                            // send back PASS so MicroBlaze knows challenge was received and 
                                             send_FPGA_ack(SPI_CHANNEL2, resp); 

                                             sha204p_sleep();
                                             SHA204_Wakeup();                      // wake up ATSHA204 if not already awake
                                             resp = SHA204_Mac(xtra, addr, &rcv_data[0], &mac[0]);
                                             if(SHA204_SUCCESS == resp)
                                             {
                                               resp = PASS;
                                               len = 32;
                                             }
                                             else
                                             {
                                               resp = FAIL;
                                               len = 0;
                                             }
                                             send_FPGA_SPI(SPI_CHANNEL2, (UINT8 *)&mac, len, resp);
                                                                          
#if (1 == VERBOSE)
                                             printf("           ATSHA204_MAC completed\r\n");
#endif
                                                                          
#if (1 == VALIDATE_MAC)
                                             // the following is only used to test/debug this MAC call and should be
                                             // removed after proving it works properly.
                                             sha204p_sleep();
                                             SHA204_Wakeup();                      // wake up ATSHA204 if not already awake
                                             SHA204_ReadData(&test_hash[0], addr*8); // get key from slot being used for this test
                                             for(i=0;i<32;i++)                       // copy challenge data into array 
                                               test_hash[32+i] = rcv_data[i];
                                             SHA204_ReadConfig(&tmp[0], 0);          // get SN[0:1]
                                             test_hash[84] = tmp[0];
                                             test_hash[85] = tmp[1];
                                             SHA204_ReadConfig(&tmp[0], 3);          // get SN[8]
                                             test_hash[79] = tmp[0];
                                             test_hash[65] = xtra;                   // set mode
                                             test_hash[66] = addr;                   // set slot being used
                                             printf("\r\ntest_hash contents\r\n");
                                             for(i=0;i<88;i++)
                                             {
                                               printf("0x%02X ", test_hash[i]);
                                               if(!((i+1)%16))
                                                 printf("\r\n");
                                             }
                                             printf("\r\n");
                                             SHA256_HashMessage(&test_hash[0], 88, &test_hash_result[0]);
                                             for(i=0;i<32;i++)
                                               if(test_hash_result[i] != mac[i])
                                                 printf("!! FAIL: test hash result[%d]: 0x%02X != mac[%d]: 0x%02X\r\n", i, test_hash_result[i], i, mac[i]);

                                             printf("    done with MAC request and verification check\r\n");
#endif
                                             break;
    case RTC_READ_TIME:                      i2c_val = M41T62_ReadTime(&rtc_t);                                                                          
#if (1 == DEBUG)
//                                             show_RTC_val(&rtc_t);
                                             M41T62_PrintTime(&rtc_t);
#endif

                                             if(I2C_SUCCESS != i2c_val)
                                             {
                                               len = 0;
                                               resp = FAIL;
                                             }
                                             else
                                             {
                                               len = sizeof(RTC_TIME);
                                               resp = PASS;
                                             }
                                             send_FPGA_SPI(SPI_CHANNEL2, (UINT8 *)&rtc_t, len, resp);
                                             break;
    case RTC_WRITE_TIME:                                                  
#if (1 == VERBOSE)
                                             printf("  starting RTC_WRITE_TIME, get SPI data (RxBuffCnt: 0x%02X)\r\n", SpiChnRxBuffCount(SPI_CHANNEL4));                                             
#endif
                                             send_FPGA_ack(SPI_CHANNEL2, RTC_WRITE_TIME);
                                             SpiChnGetS(SPI_CHANNEL4, (UINT *)&rtc_t, sizeof(rtc_t));
                                             delay_ms(15);
                                             send_FPGA_ack(SPI_CHANNEL2, DATA_ACK);

                                             M41T62_PrintTime(&rtc_t);
                                             i2c_val = M41T62_WriteTime(&rtc_t);
                                             if(I2C_SUCCESS != i2c_val)
                                             {
                                               resp = FAIL;
                                             }
                                             else
                                             {
                                               resp = PASS;               
                                             }
                                             send_FPGA_ack(SPI_CHANNEL2, resp);
                                             break;
    default:                                 printf("Unrecognized request, no handler implemented: 0x%02X\r\n", req);
                                             break;
  }
}

#if (1 == VERBOSE)
void show_FPGA_request(UINT8 request)
{
  printf("\r\n\n  ----\r\n  ---- FPGA request: (0x%02X) ", request);
  switch(request)
  {
    case IGNORE:                             printf("IGNORE\r\n");
                                             break;
    case ATSHA204_READ_CONFIG:               printf("ATSHA204_READ_CONFIG\r\n");
                                             break;
    case ATSHA204_WRITE_CONFIG:              printf("ATSHA204_WRITE_CONFIG\r\n");
                                             break;
    case ATSHA204_NONCE:                     printf("ATSHA204_NONCE\r\n");
                                             break;
    case ATSHA204_WRITE_DATA:                printf("ATSHA204_WRITE_DATA\r\n");
                                             break;
    case ATSHA204_READ_DATA:                 printf("ATSHA204_READ_DATA\r\n");
                                             break;
    case ATSHA204_AUTH:                      printf("ATSHA204_AUTH\r\n");
                                             break;
    case ATSHA204_MAC:                       printf("ATSHA204_MAC\r\n");
                                             break;
    case RTC_READ_TIME:                      printf("RTC_READ_TIME\r\n");
                                             break;
    case RTC_WRITE_TIME:                     printf("RTC_WRITE_TIME\r\n");
                                             break;
    default:                                 printf("Unrecognized request: 0x%02X\r\n", request);
                                             break;
  }
  printf("  ----\r\n");
}
#endif


#if (1 == DEBUG)
void show_RTC_val(RTC_TIME *time)
{
  printf("  RTC_TIME struct size is: %d\r\n", sizeof(RTC_TIME));
  printf("  RTC values in RTC_TIME struct at address: 0x%08X\r\n", time);
  printf("    century  %d\r\n", time->century); 
  printf("    year     %d\r\n", time->year);
  printf("    month    %d\r\n", time->month);
  printf("    date     %d\r\n", time->date);
  printf("    dow      %d\r\n", time->dow);
  printf("    hour     %d\r\n", time->hour);
  printf("    min      %d\r\n", time->min);
  printf("    sec      %d\r\n", time->sec);
  printf("    tenths   %d\r\n", time->tenths);
}

void dump_SPI_status(SpiChannel spi_chan)
{
  printf(" ---- SPI info (channel %d) ----\r\n", spi_chan);
  printf("   SPI Channel Busy:     %d\r\n", SpiChnIsBusy(spi_chan));
  printf("   SPI Channel Overflow: %d\r\n", SpiChnGetRov(spi_chan, 0));
  printf("   SPI TX count:         %d\r\n", SpiChnTxBuffCount(spi_chan));
  printf("   SPI TX buff full:     %d\r\n", SpiChnTxBuffFull(spi_chan));
  printf("   SPI TX buff empty:    %d\r\n", SpiChnTxBuffEmpty(spi_chan));
  printf("   SPI RX count:         %d\r\n", SpiChnRxBuffCount(spi_chan));
  printf("   SPI RX buff full:     %d\r\n", SpiChnRxBuffFull(spi_chan));
  printf("   SPI RX buff empty:    %d\r\n", SpiChnRxBuffEmpty(spi_chan));
  printf("   SPI Data Ready:       %d\r\n", SpiChnDataRdy(spi_chan));
}
#endif
