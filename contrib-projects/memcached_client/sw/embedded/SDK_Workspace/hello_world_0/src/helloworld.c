/*******************************************************************************
 *
 *  NetFPGA-10G http://www.netfpga.org
 *
 *  File:
 *        memcached.c
 *
 *  Project:
 *        Memcached Client
 *
 *  Author:
 *        Jeremia Baer
 *
 *  Description:
 *
 *        Currently only 10GBASE-SR and Direct Attach are supported.
 *        This firmware will detect port mode according to SFF-8472.
 *        The default mode is Direct Attach.
 *
 *  Copyright notice:
 *        Copyright (C) 2010, 2011 The Board of Trustees of The Leland Stanford
 *                                 Junior University
 *
 *  Licence:
 *        This file is part of the NetFPGA 10G development base package.
 *
 *        This file is free code: you can redistribute it and/or modify it under
 *        the terms of the GNU Lesser General Public License version 2.1 as
 *        published by the Free Software Foundation.
 *
 *        This package is distributed in the hope that it will be useful, but
 *        WITHOUT ANY WARRANTY; without even the implied warranty of
 *        MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *        Lesser General Public License for more details.
 *
 *        You should have received a copy of the GNU Lesser General Public
 *        License along with the NetFPGA source package.  If not, see
 *        http://www.gnu.org/licenses/.
 *
 */

#include <stdio.h>
#include "platform.h"
#include "xwdttb.h"
#include "xemaclite.h"
#include "xemaclite_l.h"

////////////////////////////////////////////////////////////////////////
//Our experiment shows that the Direct Attach EDC also applies
//to 10GBASE-SR modules. To save the BRAM resource and minimize
//the program size, both 10GBASE-SR and Direct Attach use the
//same EDC code. If you have problems getting 10GBASE-SR running
//please enable 10GBASE-SR EDC by setting AEL2005_SR marco to 1.
////////////////////////////////////////////////////////////////////////
#define AEL2005_SR 0
#include "helloworld.h"

#define EMAC_DEVICE_ID		XPAR_EMACLITE_0_DEVICE_ID
#define TIMER_DEVICE_ID     XPAR_WDTTB_0_DEVICE_ID

// Testclient driver support -----------------------------------------
#define TESTCLIENT_VERSION "NT01"

const u32 Client0 = XPAR_NF10_AXIS_MEMCACHED_CLIENT_0_BASEADDR;
const u32 Client1 = XPAR_NF10_AXIS_MEMCACHED_CLIENT_1_BASEADDR;

#define SB_BUFSIZE 1520
#define SB_WC      (SB_BUFSIZE / 4)
typedef struct {
   u32 tx_length;
   u8  tx_buffer[SB_BUFSIZE];
   u32 rx_length;
   u8  rx_buffer[SB_BUFSIZE];
} streamblock;

u8 ascii2bin(u8 byte0, u8 byte1);
void testclient_writeStreamblock(u32 client_baseaddr, streamblock *sb);
void testclient_readStreamblock(u32 client_baseaddr, streamblock *sb);
// -------------------------------------------------------------------

XEmacLite EmacLiteInstance;	/* Instance of the EmacLite */
streamblock sb;

void helpmsg() {
   char *table[3][6];
   print("\r\n=======================   N E T W O R K    T E S T E R   =======================\r\n");
   print("\r\n");
   table[0][0] = "Traffic Control";
   table[0][1] = "  r : Start Traffic (run)";
   table[0][2] = "  h : Stop Traffic (halt)";
   table[0][3] = "  o : Oneshot & Latency";
   table[0][4] = "  s : Statistics";
   table[0][5] = "  x : Reset Stats";
   table[1][0] = "Packet Setup";
   table[1][1] = "  d : Dump SEND buffer";
   table[1][2] = "  l : Load SEND buffer";
   table[1][3] = "  g : Set IFG";
   table[1][4] = "";
   table[1][5] = "";
   table[2][0] = "Maintenance";
   table[2][1] = "  i : Initialize PHY";
   table[2][2] = "  p : PHY Status";
   table[2][3] = "  v : Version / Probe"; // used to probe from host SW
   table[2][4] = "  ? : This message";
   table[2][5] = "";
   int i; for(i=0; i<6; i++) xil_printf("%-26s %-26s %-26s\r\n", table[0][i], table[1][i], table[2][i]);
   print("\r\n");
}

int main (void) {
   int i;

   init_platform();
   XEmacLite *EmacLiteInstPtr = &EmacLiteInstance;
   XEmacLite_Config *ConfigPtr;

   ConfigPtr = XEmacLite_LookupConfig(EMAC_DEVICE_ID);
   XEmacLite_CfgInitialize(EmacLiteInstPtr, ConfigPtr, ConfigPtr->BaseAddress);

   const int ll = 60;
   sb.tx_length = ll;
   sb.rx_length = ll;
   for(i=0; i<SB_BUFSIZE; i++) {
      sb.tx_buffer[i] = (u8) i;
      sb.rx_buffer[i] = (u8) i;
   }
   sb.tx_buffer[12] = 0x08;
   sb.tx_buffer[13] = 0x00;
   sb.rx_buffer[12] = 0x08;
   sb.rx_buffer[13] = 0x00;
   sb.tx_buffer[ll-1] = 0xFF;
   sb.rx_buffer[ll-1] = 0xFF;
   testclient_writeStreamblock(Client0, &sb);
   testclient_writeStreamblock(Client1, &sb);

   char s;
   char t;
   int port, dev;
   unsigned int value;

#if AEL2005_SR
   char port_mode_new[4] = {-1,-1,-1,-1};
   char port_mode[4] = {-1,-1,-1,-1};
#endif

   goto INIT;

   while(1){
      print("> ");
      s = inbyte();
      print("\r\n");
      // Initialize PHY ----------------------------------------------
      if(s == 'i') {
INIT:    for(port = 0; port < 4; port ++){
            if(port == 0) dev = 2;
            if(port == 1) dev = 1;
            if(port == 2) dev = 0;
            if(port == 3) dev = 3;

            xil_printf("Port %d: ", port);
            ael2005_read (EmacLiteInstPtr, dev, 1, 0xa, &value);
            /*if(value == 0) {
                	print("No Signal.\r\n");
                	continue;
            }*/
            for(s = 20; s < 36; s++){
                	ael2005_i2c_read (EmacLiteInstPtr, dev, MODULE_DEV_ADDR, s, &value);
                	xil_printf("%c", value);
            }
            for(s = 40; s < 56; s++){
                	ael2005_i2c_read (EmacLiteInstPtr, dev, MODULE_DEV_ADDR, s, &value);
                	xil_printf("%c", value);
            }
            print("\r\n");

#if AEL2005_SR
            // Check if we have a 10GBASE-SR cable
            ael2005_i2c_read (EmacLiteInstPtr, dev, MODULE_DEV_ADDR, 0x3, &value);
            if((value >> 4) == 1) port_mode_new[port] = MODE_SR;
            else port_mode_new[port] = MODE_TWINAX;

            if(port_mode_new[port] != port_mode[port]){
                xil_printf("Port %d Detected new mode %x\r\n", port, port_mode_new[port]);
                   test_initialize(EmacLiteInstPtr, dev, port_mode_new[port]);
                   port_mode[port] = port_mode_new[port];
            }
#else
            test_initialize(EmacLiteInstPtr, dev, MODE_TWINAX);
#endif
         }

         helpmsg();
      }
      // PHY Status --------------------------------------------------
      else if(s == 'p') {
         test_status(EmacLiteInstPtr);
      }
      // Version / Probe ---------------------------------------------
      else if(s == 'v') {
         xil_printf("%s\r\n", TESTCLIENT_VERSION);
      }
      // Help Message / Welcome Screen -------------------------------
      else if(s == '?') {
         helpmsg();
      }
      // Start Traffic -----------------------------------------------
      else if (s == 'r'){
         Xil_Out32(XPAR_NF10_AXIS_MEMCACHED_CLIENT_0_BASEADDR+0x0, 0x1);
         Xil_Out32(XPAR_NF10_AXIS_MEMCACHED_CLIENT_1_BASEADDR+0x0, 0x1);
         print("Client Started\r\n");
      }
      // Stop Traffic ------------------------------------------------
      else if (s == 'h'){
         Xil_Out32(XPAR_NF10_AXIS_MEMCACHED_CLIENT_0_BASEADDR+0x0, 0x0);
         Xil_Out32(XPAR_NF10_AXIS_MEMCACHED_CLIENT_1_BASEADDR+0x0, 0x0);
         print("Client Stopped\r\n");
      }
      // Short Burst -------------------------------------------------
      else if(s == 'b') {
         Xil_Out32(XPAR_NF10_AXIS_MEMCACHED_CLIENT_0_BASEADDR+0x0, 0x1);
         Xil_Out32(XPAR_NF10_AXIS_MEMCACHED_CLIENT_1_BASEADDR+0x0, 0x1);
         Xil_Out32(XPAR_NF10_AXIS_MEMCACHED_CLIENT_0_BASEADDR+0x0, 0x0);
         Xil_Out32(XPAR_NF10_AXIS_MEMCACHED_CLIENT_1_BASEADDR+0x0, 0x0);
         print("Burst sent.\r\n");
      }
      // Oneshot / Latency -------------------------------------------
      else if(s == 'o') {
         Xil_Out32(XPAR_NF10_AXIS_MEMCACHED_CLIENT_0_BASEADDR+0x3, 0x1);
         Xil_Out32(XPAR_NF10_AXIS_MEMCACHED_CLIENT_1_BASEADDR+0x3, 0x1);

         u32 latency;
         do {
            latency = Xil_In32(XPAR_NF10_AXIS_MEMCACHED_CLIENT_0_BASEADDR+0x3);
         } while(!(latency>>31));
         latency &= 0x7FFFFFFF;
         xil_printf("Client0: %d cycles / %d us\r\n", latency, latency/160000);

         do {
            latency = Xil_In32(XPAR_NF10_AXIS_MEMCACHED_CLIENT_1_BASEADDR+0x3);
         } while(!(latency>>31));
         latency &= 0x7FFFFFFF;
         xil_printf("Client1: %d cycles / %d us\r\n", latency, latency/160000);
      }
      // Statistics --------------------------------------------------
      else if (s == 's'){
         u32 tx, rx_ok, rx_no;

         tx    = Xil_In32(XPAR_NF10_AXIS_MEMCACHED_CLIENT_0_BASEADDR+0x10);
         rx_ok = Xil_In32(XPAR_NF10_AXIS_MEMCACHED_CLIENT_0_BASEADDR+0x11);
         rx_no = Xil_In32(XPAR_NF10_AXIS_MEMCACHED_CLIENT_0_BASEADDR+0x12);
         xil_printf("Client 0: TX %-15d RX Match %-15d RX Fail %-15d\r\n", tx, rx_ok, rx_no);

         tx    = Xil_In32(XPAR_NF10_AXIS_MEMCACHED_CLIENT_1_BASEADDR+0x10);
         rx_ok = Xil_In32(XPAR_NF10_AXIS_MEMCACHED_CLIENT_1_BASEADDR+0x11);
         rx_no = Xil_In32(XPAR_NF10_AXIS_MEMCACHED_CLIENT_1_BASEADDR+0x12);
         xil_printf("Client 1: TX %-15d RX Match %-15d RX Fail %-15d\r\n", tx, rx_ok, rx_no);
      }
      // Reset Stats -------------------------------------------------
      else if (s == 'x'){
         Xil_Out32(XPAR_NF10_AXIS_MEMCACHED_CLIENT_0_BASEADDR+0x1, 0x1);
         Xil_Out32(XPAR_NF10_AXIS_MEMCACHED_CLIENT_1_BASEADDR+0x1, 0x1);
         Xil_Out32(XPAR_NF10_AXIS_MEMCACHED_CLIENT_0_BASEADDR+0x1, 0x0);
         Xil_Out32(XPAR_NF10_AXIS_MEMCACHED_CLIENT_1_BASEADDR+0x1, 0x0);
         print("Statistics reset.\r\n");
      }
      // Dump TX Buffer ----------------------------------------------
      else if(s == 'd') {
         testclient_readStreamblock(Client0, &sb);

         xil_printf("SEND  %4dB: ", sb.tx_length);
         for(i=0; i<sb.tx_length; i++) {
            xil_printf("%02x", sb.tx_buffer[i]);
         }
         print("\r\n");

         xil_printf("CHECK %4dB: ", sb.rx_length);
         for(i=0; i<sb.rx_length; i++) {
            xil_printf("%02x", sb.rx_buffer[i]);
         }
         print("\r\n");
      }
      // Load TX Buffer ----------------------------------------------
      else if(s == 'l') {
         print("Please enter the hexstring terminated by CRLF.\r\n");
         print("SEND > ");
         u32 length = 0;
         while(1) {
            u32 byte0 = inbyte();
            if(byte0 == '\n') break; // UNIX linebreak.
            // We use windows lineberak, but I can't get minicom to use
            // windows linebreaks, thus I support unix breaks as well :-(
            u32 byte1 = inbyte();
            if(byte0 == '\r' && byte1 == '\n') break; // windows linebreak

            if(length == SB_BUFSIZE) {
               xil_printf("Maximum bufsize %dB exceeded.\r\n", SB_BUFSIZE);
               break;
            }

            sb.tx_buffer[length] = ascii2bin(byte0, byte1);
            length = length + 1;
         }
         xil_printf("\r\nSend block of %dB loaded.\r\n", length);
         if(length < 60) {
            print("NOTE: Block padded to 60B (minimum frame length).\r\n");
            for(; length<60; length++) sb.tx_buffer[length] = 0;
         }
         sb.tx_length = length;

         print("CHECK> ");
         length = 0;
         while(1) {
            u32 byte0 = inbyte();
            if(byte0 == '\n' ) break; // UNIX linebreak.
            u32 byte1 = inbyte();
            if(byte0 == '\r' && byte1 == '\n') break; // windows linebreak

            if(length == SB_BUFSIZE) {
               xil_printf("Maximum bufsize %dB exceeded.\r\n", SB_BUFSIZE);
               break;
            }

            sb.rx_buffer[length] = ascii2bin(byte0, byte1);
            length = length + 1;
         }
         xil_printf("\r\nCheck block of %dB loaded.\r\n", length);
         if(length < 60) {
            print("NOTE: Block padded to 60B (minimum frame length).\r\n");
            for(; length<60; length++) sb.rx_buffer[length] = 0;
         }
         sb.rx_length = length;

         testclient_writeStreamblock(Client0, &sb);
         testclient_writeStreamblock(Client1, &sb);
      }
      // Set Inter Frame Gap -----------------------------------------
      else if(s == 'g') {
         print("IFG: 8 digit hex number> ");
         u8 byte0 = inbyte();
         u8 byte1 = inbyte();
         u8 byte2 = inbyte();
         u8 byte3 = inbyte();
         u8 byte4 = inbyte();
         u8 byte5 = inbyte();
         u8 byte6 = inbyte();
         u8 byte7 = inbyte();
         u32 number = (ascii2bin(byte0, byte1) << 24) |
                      (ascii2bin(byte2, byte3) << 16) |
                      (ascii2bin(byte4, byte5) <<  8) |
                      (ascii2bin(byte6, byte7)      ) ;
         if(number < (u8) 2) {
            xil_printf("\r\nIFG %d too small. Setting to 2.", number);
            number = 2;
         }
         print("\r\n");
         Xil_Out32(XPAR_NF10_AXIS_MEMCACHED_CLIENT_0_BASEADDR+0x2, number);
         Xil_Out32(XPAR_NF10_AXIS_MEMCACHED_CLIENT_1_BASEADDR+0x2, number);
      }
      else
         continue;
   }

   cleanup_platform();
   return 0;
}

// -------------------------------------------------------------------
// PHY Configuration
// -------------------------------------------------------------------

int ael2005_read (XEmacLite *EmacLiteInstPtr, u32 PhyAddr, u32 PhyDev, u16 address, u16 *data){
    XEmacLite_PhyWrite(EmacLiteInstPtr, PhyAddr, PhyDev, XEL_MDIO_OP_45_ADDRESS, XEL_MDIO_CLAUSE_45, address);
    XEmacLite_PhyRead(EmacLiteInstPtr, PhyAddr, PhyDev, XEL_MDIO_OP_45_READ, XEL_MDIO_CLAUSE_45, data);
    ael2005_sleep(2);
    return XST_SUCCESS;
}

int ael2005_write (XEmacLite *EmacLiteInstPtr, u32 PhyAddr, u32 PhyDev, u16 address, u16 data){
    XEmacLite_PhyWrite(EmacLiteInstPtr, PhyAddr, PhyDev, XEL_MDIO_OP_45_ADDRESS, XEL_MDIO_CLAUSE_45, address);
    XEmacLite_PhyWrite(EmacLiteInstPtr, PhyAddr, PhyDev, XEL_MDIO_OP_45_WRITE, XEL_MDIO_CLAUSE_45, data);
    ael2005_sleep(2);
    return XST_SUCCESS;
}

// The following functions are commented out to minimize executable size
int ael2005_i2c_write (XEmacLite *InstancePtr, u32 PhyAddress, u16 dev_addr, u16 word_addr, u16 data){
    u16 stat;
    int i;
    ael2005_write (InstancePtr, PhyAddress, 1, AEL_I2C_DATA, data);
    ael2005_write (InstancePtr, PhyAddress, 1, AEL_I2C_CTRL, (dev_addr << 8) | word_addr);
    for (i = 0; i < 20; i++){
        ael2005_sleep (2);
        ael2005_read  (InstancePtr, PhyAddress, 1, AEL_I2C_STAT, &stat);
        if ((stat & 3) == 1)
			return XST_SUCCESS;
	}
	return XST_DEVICE_BUSY;
}

int ael2005_i2c_read (XEmacLite *InstancePtr, u32 PhyAddress, u16 dev_addr, u16 word_addr, u16 *data){
    u16 stat;
    int i;
    ael2005_write (InstancePtr, PhyAddress, 1, AEL_I2C_CTRL, (dev_addr << 8) | (1 << 8) | word_addr);
    for (i = 0; i < 20; i++){
        ael2005_sleep (2);
        ael2005_read  (InstancePtr, PhyAddress, 1, AEL_I2C_STAT, &stat);
        if ((stat & 3) == 1){
            ael2005_read  (InstancePtr, PhyAddress, 1, AEL_I2C_DATA, &stat);
            *data = stat >> 8;
			return XST_SUCCESS;
	    }
	}
	return XST_DEVICE_BUSY;
}

int ael2005_sleep (int ms){

    int result_0 = XWdtTb_ReadReg(XPAR_AXI_TIMEBASE_WDT_0_BASEADDR, XWT_TBR_OFFSET);
    int result_1 = result_0;
    while(result_1 - result_0 < ms * 50000) {
        result_1 = XWdtTb_ReadReg(XPAR_AXI_TIMEBASE_WDT_0_BASEADDR, XWT_TBR_OFFSET);
    }
    return XST_SUCCESS;
}

int ael2005_initialize(XEmacLite *InstancePtr, u32 dev, int mode){

        int size, i;

        print("Initialization Start..\r\n");
        // Step 1
        print("Step 1..\r\n");
        size = sizeof(regs0) / sizeof(u16);
        for(i = 0; i < size; i+=2) ael2005_write(InstancePtr, dev, 1, regs0[i], regs0[i+1]);
        ael2005_sleep(50);

        // Step 2
        print("Step 2..\r\n");
        #if AEL2005_SR
        if(mode == MODE_SR){
            size = sizeof(sr_edc) / sizeof(u16);
            for(i = 0; i < size; i+=2) ael2005_write(InstancePtr, dev, 1, sr_edc[i], sr_edc[i+1]);
        }
        else {
            size = sizeof(twinax_edc) / sizeof(u16);
            for(i = 0; i < size; i+=2) ael2005_write(InstancePtr, dev, 1, twinax_edc[i], twinax_edc[i+1]);
        }
        #else
        size = sizeof(twinax_edc) / sizeof(u16);
        for(i = 0; i < size; i+=2) ael2005_write(InstancePtr, dev, 1, twinax_edc[i], twinax_edc[i+1]);
        #endif

        // Step 3
        print("Step 3..\r\n");
        size = sizeof(regs1) / sizeof(u16);
        for(i = 0; i < size; i+=2) ael2005_write(InstancePtr, dev, 1, regs1[i], regs1[i+1]);
        ael2005_sleep(50);
        return XST_SUCCESS;
}

int test_initialize(XEmacLite *InstancePtr, u32 PhyAddress, int mode){
        ael2005_sleep(100);
        ael2005_initialize(InstancePtr, PhyAddress, mode);
        ael2005_sleep(200);
        return XST_SUCCESS;
}

int test_status(XEmacLite *InstancePtr){
		  int i, dev;
          u16 pma_status, pcs_status, phy_xs_status;
		  for( i = 0; i < 4; i++){
		          switch(i){  // PHY0-3 -> C, B, A, D
                    case 0:
						      dev = 2;
								break;
					     case 1:
						      dev = 1;
								break;
						  case 2:
						      dev = 0;
								break;
						  case 3:
						      dev = 3;
								break;
						  default:;
					 }
					 ael2005_read(InstancePtr, dev, 1, 0x1, &pma_status);
					 ael2005_read(InstancePtr, dev, 3, 0x1, &pcs_status);
					 ael2005_read(InstancePtr, dev, 4, 0x1, &phy_xs_status);
					 //xil_printf("DEBUG: %x, %x, %x\r\n", pma_status, pcs_status, phy_xs_status);
					 if(((pma_status>>2) & 0x1) &
					    ((pcs_status>>2) & 0x1) &
						 ((phy_xs_status>>2) & 0x1)){
						    xil_printf("PHY %d OK\r\n", i);
				    }
				    else {
					     xil_printf("PHY %d error: link down\r\n", i);
				    }

        }
        return XST_SUCCESS;
}

// -------------------------------------------------------------------
// Testclient Driver Support
// -------------------------------------------------------------------

u8 char2bin(u8 c) {
   if((c>>4) == 3) {
      return (c & 0x0F);
   } else if(((c>>4) == 4) || ((c>>4) == 6)) {
      return (c & 0x0F) + 9;
   } else {
      return 0;
   }
}

u8 ascii2bin(u8 byte0, u8 byte1) {
   return (char2bin(byte0) << 4) + char2bin(byte1);
}
	
u32 sb_wordcount(u32 length) {
   u32 modulus = length % 8;
   return (modulus == 0) ? (length / 8) : (length / 8 + 1);
}

u32 sb_strobe(u32 length) {
   u32 modulus = length % 8;
   switch(modulus) {
      case 1: return 0x01;
      case 2: return 0x03;
      case 3: return 0x07;
      case 4: return 0x0F;
      case 5: return 0x1F;
      case 6: return 0x3F;
      case 7: return 0x7F;
      default: return 0xFF;
   }
}

u32 sb_length(u32 word_count, u32 strobe) {
    u32 modulus;
    switch(strobe) {
        case 0x01: modulus = 1; break;
        case 0x03: modulus = 2; break;
        case 0x07: modulus = 3; break;
        case 0x0F: modulus = 4; break;
        case 0x1F: modulus = 5; break;
        case 0x3F: modulus = 6; break;
        case 0x7F: modulus = 7; break;
        default: modulus = 8; break;
    }
    
    u32 modulus_reverse = 8 - modulus;
    u32 length = word_count * 8 - modulus_reverse;
    return length;
}

u32 sb_getWord(u8 *buffer, int index) {
   return (buffer[4*index])         |
          (buffer[4*index+1]) << 8  |
          (buffer[4*index+2]) << 16 |
          (buffer[4*index+3]) << 24 ;
}

void sb_setWord(u8 *buffer, int index, u32 value) {
   buffer[4*index]     = (u8) (value & 0xFF);
   buffer[4*index + 1] = (u8) ((value>>8) & 0xFF);
   buffer[4*index + 2] = (u8) ((value>>16) & 0xFF);
   buffer[4*index + 3] = (u8) ((value>>24) & 0xFF);
}

void testclient_writeStreamblock(u32 client_baseaddr, streamblock *sb) {
   int i;
   Xil_Out32(client_baseaddr + 0x20, sb_wordcount(sb->tx_length));
   Xil_Out32(client_baseaddr + 0x20, sb_strobe(sb->tx_length));
   for(i=0; i<SB_WC; i++) Xil_Out32(client_baseaddr + 0x20, sb_getWord(sb->tx_buffer, i));
   Xil_Out32(client_baseaddr + 0x20, sb_wordcount(sb->rx_length));
   Xil_Out32(client_baseaddr + 0x20, sb_strobe(sb->rx_length));
   for(i=0; i<SB_WC; i++) Xil_Out32(client_baseaddr + 0x20, sb_getWord(sb->rx_buffer, i));
}

void testclient_readStreamblock(u32 client_baseaddr, streamblock *sb) {
   int i;
   u32 word_count = Xil_In32(client_baseaddr + 0x20);
   u32 strobe     = Xil_In32(client_baseaddr + 0x20);
   sb->tx_length = sb_length(word_count, strobe);
   for(i=0; i<SB_WC; i++) sb_setWord(sb->tx_buffer, i, Xil_In32(client_baseaddr + 0x20));
   word_count = Xil_In32(client_baseaddr + 0x20);
   strobe     = Xil_In32(client_baseaddr + 0x20);
   sb->rx_length = sb_length(word_count, strobe);
   for(i=0; i<SB_WC; i++) sb_setWord(sb->rx_buffer, i, Xil_In32(client_baseaddr + 0x20));
}
