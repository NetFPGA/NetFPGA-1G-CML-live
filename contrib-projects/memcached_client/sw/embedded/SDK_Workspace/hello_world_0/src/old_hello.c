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
 *        James Kulina
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

#define TESTCLIENT_VERSION "NT01"
// Testclient driver support -----------------------------------------
const u32 Client0 = XPAR_NF10_AXIS_MEMCACHED_CLIENT_0_BASEADDR;
const u32 Client1 = XPAR_NF10_AXIS_MEMCACHED_CLIENT_1_BASEADDR;

u8 ascii2bin(u8 byte0, u8 byte1);
void testclient_setTxBuffer(u32 client_baseaddr, u32 offset, u8 value);
void testclient_setTxLength(u32 client_baseaddr, u32 length);
u32  testclient_getTxBuffer(u32 client_baseaddr, u32 offset);
u32  testclient_getTxLength(u32 client_baseaddr);
void testclient_setRxBuffer(u32 client_baseaddr, u32 offset, u8 value);
void testclient_setRxLength(u32 client_baseaddr, u32 length);
u32  testclient_getRxBuffer(u32 client_baseaddr, u32 offset);
u32  testclient_getRxLength(u32 client_baseaddr);
// -------------------------------------------------------------------

XEmacLite EmacLiteInstance;	/* Instance of the EmacLite */

void helpmsg() {
   char *table[3][5];
   print("\r\n=======================   N E T W O R K    T E S T E R   =======================\r\n");
   print("\r\n");
   table[0][0] = "Traffic Control";
   table[0][1] = "  r : Start Traffic (run)";
   table[0][2] = "  h : Stop Traffic (halt)";
   table[0][3] = "  b : Short Burst";
   table[0][4] = "  s : Statistics";
   table[1][0] = "Packet Setup";
   table[1][1] = "  d : Dump SEND buffer";
   table[1][2] = "  l : Load SEND buffer";
   table[1][3] = "  D : Dump CHECK buffer";
   table[1][4] = "  L : Load CHECK buffer";
   table[2][0] = "Maintenance";
   table[2][1] = "  i : Initialize PHY";
   table[2][2] = "  p : PHY Status";
   table[2][3] = "  v : Version / Probe"; // used to probe from host SW
   table[2][4] = "  ? : This message";
   int i; for(i=0; i<5; i++) xil_printf("%-26s %-26s %-26s\r\n", table[0][i], table[1][i], table[2][i]);
   print("\r\n");

      /*
      print("\r\n=======================   N E T W O R K    T E S T E R   =======================\r\n");
      print("Maintenance\r\n");
      print("  i : Initialize PHY\r\n");
      print("  s : PHY Status\r\n");
      print("  v : Version Info / Probe\r\n"); // used to probe from host SW
      print("  h : Print this message\r\n");
      print("Traffic Control\r\n");
      print("  t : Start Traffic\r\n");
      print("  r : Stop Traffic\r\n");
      print("  u : short burst\r\n");
      print("  ? : Statistics\r\n");
      print("Configuration\r\n");
      print("  d : Dump SEND buffer\r\n");
      print("  l : Load SEND buffer\r\n");
      print("  d : Dump CHECK buffer\r\n");
      print("  l : Load CHECK buffer\r\n");
      */
}

int main (void) {

   init_platform();
   XEmacLite *EmacLiteInstPtr = &EmacLiteInstance;
   XEmacLite_Config *ConfigPtr;

   ConfigPtr = XEmacLite_LookupConfig(EMAC_DEVICE_ID);
   XEmacLite_CfgInitialize(EmacLiteInstPtr, ConfigPtr, ConfigPtr->BaseAddress);

   // Hold AXI4-Stream Packet Generator/Checker
   Xil_Out32(XPAR_NF10_AXIS_MEMCACHED_CLIENT_0_BASEADDR+0x3, 0x1);
   Xil_Out32(XPAR_NF10_AXIS_MEMCACHED_CLIENT_1_BASEADDR+0x3, 0x1);

   char s;
   char t;
   int port, dev;
   unsigned int value;

#if AEL2005_SR
   char port_mode_new[4] = {-1,-1,-1,-1};
   char port_mode[4] = {-1,-1,-1,-1};
#endif

   goto INIT;

   int i;
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
         Xil_Out32(XPAR_NF10_AXIS_MEMCACHED_CLIENT_0_BASEADDR+0x3, 0x0);
         Xil_Out32(XPAR_NF10_AXIS_MEMCACHED_CLIENT_1_BASEADDR+0x3, 0x0);
         print("Client Started\r\n");
      }
      // Stop Traffic ------------------------------------------------
      else if (s == 'h'){
         Xil_Out32(XPAR_NF10_AXIS_MEMCACHED_CLIENT_0_BASEADDR+0x3, 0x1);
         Xil_Out32(XPAR_NF10_AXIS_MEMCACHED_CLIENT_1_BASEADDR+0x3, 0x1);
         print("Client Stopped\r\n");
      }
      // Short Burst -------------------------------------------------
      else if(s == 'b') {
         Xil_Out32(XPAR_NF10_AXIS_MEMCACHED_CLIENT_0_BASEADDR+0x3, 0x0);
         Xil_Out32(XPAR_NF10_AXIS_MEMCACHED_CLIENT_1_BASEADDR+0x3, 0x0);
         print("Client Started\r\n");
         int i;
         for(i=0; i<100; i++); // please don't optimize
         Xil_Out32(XPAR_NF10_AXIS_MEMCACHED_CLIENT_0_BASEADDR+0x3, 0x1);
         Xil_Out32(XPAR_NF10_AXIS_MEMCACHED_CLIENT_1_BASEADDR+0x3, 0x1);
         print("Client Stopped\r\n");
      }
      // Statistics --------------------------------------------------
      else if (s == 's'){
         u32 tx, rx_ok, rx_no;

         tx    = Xil_In32(XPAR_NF10_AXIS_MEMCACHED_CLIENT_0_BASEADDR+0x0);
         rx_ok = Xil_In32(XPAR_NF10_AXIS_MEMCACHED_CLIENT_0_BASEADDR+0x1);
         rx_no = Xil_In32(XPAR_NF10_AXIS_MEMCACHED_CLIENT_0_BASEADDR+0x2);
         xil_printf("Client 0: TX %-15d RX Match %-15d RX Fail %-15d\r\n", tx, rx_ok, rx_no);

         tx    = Xil_In32(XPAR_NF10_AXIS_MEMCACHED_CLIENT_1_BASEADDR+0x0);
         rx_ok = Xil_In32(XPAR_NF10_AXIS_MEMCACHED_CLIENT_1_BASEADDR+0x1);
         rx_no = Xil_In32(XPAR_NF10_AXIS_MEMCACHED_CLIENT_1_BASEADDR+0x2);
         xil_printf("Client 1: TX %-15d RX Match %-15d RX Fail %-15d\r\n", tx, rx_ok, rx_no);
      }
      // Dump TX Buffer ----------------------------------------------
      else if(s == 'd') {
         u32 length = testclient_getTxLength(Client0);
         xil_printf("Send block of %dB: ", length);
         u32 i;
         for(i=0; i<length; i++) {
            u8 v = testclient_getTxBuffer(Client0, i);
            xil_printf("%02x", v);
         }
         print("\r\n");
      }
      // Load TX Buffer ----------------------------------------------
      else if(s == 'l') {
         print("CRLF terminated hexstring> ");
         u32 length = 0;
         while(1) {
            u32 byte0 = inbyte();
            //xil_printf("byte0: %x\r\n", byte0);
            if(byte0 == '\n' | byte0 == '\r') break; // UNIX linebreak.
            // We use windows lineberak, but I can't get minicom to use
            // windows linebreaks, thus I support unix breaks as well :-(
            u32 byte1 = inbyte();
            //xil_printf("byte1: %x\r\n", byte1);
            if(byte0 == '\r' || byte1 == '\n') break; // windows linebreak

            u8 data = ascii2bin(byte0, byte1);
            testclient_setTxBuffer(Client0, length, data);
            testclient_setTxBuffer(Client1, length, data);
            //xil_printf("TX_BUF[%d] = %x\r\n", length, data);
            length = length + 1;
         }
         testclient_setTxLength(Client0, length);
         testclient_setTxLength(Client1, length);
         xil_printf("\r\nSend block of %dB loaded.\r\n", length);
      }
      // Dump RX Buffer ----------------------------------------------
      else if(s == 'D') {
         u32 length = testclient_getRxLength(Client0);
         xil_printf("Check block of %dB: ", length);
         u32 i;
         for(i=0; i<length; i++) {
            u8 v = testclient_getRxBuffer(Client0, i);
            xil_printf("%02x", v);
         }
         print("\r\n");
      }
      // Load RX Buffer ----------------------------------------------
      else if(s == 'L') {
         print("CRLF terminated hexstring> ");
         u32 length = 0;
         while(1) {
            u32 byte0 = inbyte();
            if(byte0 == '\n' | byte0 == '\r') break; // UNIX linebreak.
            u32 byte1 = inbyte();
            if(byte0 == '\r' || byte1 == '\n') break; // windows linebreak

            u8 data = ascii2bin(byte0, byte1);
            testclient_setRxBuffer(Client0, length, data);
            testclient_setRxBuffer(Client1, length, data);
            length = length + 1;
         }
         testclient_setRxLength(Client0, length);
         testclient_setRxLength(Client1, length);
         xil_printf("\r\nCheck block of %dB loaded.\r\n", length);
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
	
void testclient_setTxBuffer(u32 client_baseaddr, u32 offset, u8 value) {
   Xil_Out32(client_baseaddr + 0x200 + offset, (u32) value);
}

void testclient_setTxLength(u32 client_baseaddr, u32 length) {
   u32 modulus = length % 8;
   u32 strobe;
   switch(modulus) {
      case 1: strobe = 0x01; break;
      case 2: strobe = 0x03; break;
      case 3: strobe = 0x07; break;
      case 4: strobe = 0x0F; break;
      case 5: strobe = 0x1F; break;
      case 6: strobe = 0x3F; break;
      case 7: strobe = 0x7F; break;
      default: strobe = 0xFF; break;
   }
   u32 word_count;
   if(modulus == 0) {
      word_count = length / 8;
   } else {
      word_count = length / 8 + 1;
   }

   Xil_Out32(client_baseaddr + 0x100, word_count);
   Xil_Out32(client_baseaddr + 0x101, strobe);
   //xil_printf("setting WC: %x STRB: %x\r\n", word_count, strobe);
}

u32 testclient_getTxBuffer(u32 client_baseaddr, u32 offset) {
    return Xil_In32(client_baseaddr + 0x200 + offset);
}

u32 testclient_getTxLength(u32 client_baseaddr) {
    u32 word_count = Xil_In32(client_baseaddr + 0x100);
    u32 strobe     = Xil_In32(client_baseaddr + 0x101);
    //xil_printf("getting WC: %x STRB: %x\r\n", word_count, strobe);

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

void testclient_setRxBuffer(u32 client_baseaddr, u32 offset, u8 value) {
	Xil_Out32(client_baseaddr + 0x300 + offset, (u32) value);
}

void testclient_setRxLength(u32 client_baseaddr, u32 length) {
   u32 modulus = length % 8;
   u32 strobe;
   switch(modulus) {
      case 1: strobe = 0x01; break;
      case 2: strobe = 0x03; break;
      case 3: strobe = 0x07; break;
      case 4: strobe = 0x0F; break;
      case 5: strobe = 0x1F; break;
      case 6: strobe = 0x3F; break;
      case 7: strobe = 0x7F; break;
      default: strobe = 0xFF; break;
   }
   u32 word_count;
   if(modulus == 0) {
      word_count = length / 8;
   } else {
      word_count = length / 8 + 1;
   }

	Xil_Out32(client_baseaddr + 0x110, word_count);
	Xil_Out32(client_baseaddr + 0x111, strobe);
}

u32 testclient_getRxBuffer(u32 client_baseaddr, u32 offset) {
    return Xil_In32(client_baseaddr + 0x300 + offset);
}

u32 testclient_getRxLength(u32 client_baseaddr) {
    u32 word_count = Xil_In32(client_baseaddr + 0x110);
    u32 strobe     = Xil_In32(client_baseaddr + 0x111);

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
