/*
 * This file is used to hold defines for messages used by
 * the FPGA to request action and information from the PIC
 * using SPI. 
 *
 * These are separate from the FPGA helper include so that 
 * this file can also be included by the FPGA source code to
 * help prevent problems caused by having a define file for
 * each system and then have them get out of synch for
 * defined values.
 */

#ifndef FPGA_MESSAGES_H
#define FPGA_MESSAGES_H

#define IGNORE                                0x00
#define PASS                                  0x01
#define FAIL                                  0x02
#define ATSHA204_READ_CONFIG                  0x03
#define ATSHA204_WRITE_CONFIG                 0x04
#define ATSHA204_NONCE                        0x05
#define ATSHA204_WRITE_DATA                   0x06
#define ATSHA204_READ_DATA                    0x07
#define ATSHA204_AUTH                         0x08
#define ATSHA204_MAC                          0x09
#define RTC_READ_TIME                         0x0A
#define RTC_WRITE_TIME                        0x0B

#define DATA_ACK                              0x31
#define SEND_DATA                             0x32


#endif /* FPGA_MESSAGES_H */
