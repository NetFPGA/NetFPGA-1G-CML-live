/*******************************************************************************
 *
 *  NetFPGA-10G http://www.netfpga.org
 *
 *  File:
 *        loopback_test_nf7.c
 *
 *  Project:
 *        loopback_test_nf7
 *
 *  Author:
 *        Jack Meador, Computer Measurement Laboratory, LLC
 *
 *  Description:
 *        Test NetFPGA-1G-CML Ethernet Communications.
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
#include "xparameters.h"

#define TIMER_DEVICE_ID XPAR_WDTTB_0_DEVICE_ID

#define PHY_DEFAULTS {0x1140,0x7949,0x001C,0xC915,0x05E1,0x0000,0x0004,0x2001,\
                      0x0000,0x0200,0x0000,0x0000,0x0000,0x0000,0x0000,0x3000,\
                      0x016E,0x4040,0x9F01,0x0040,0x8040,0x1006,0x4100,0x2100,\
                      0x0000,0x8C00,0x0040,0x805A,0x0408,0x8038,0x0123,0x0000}

#define MDIO_BASE_ADDR 0x7a040000

// MDIO registers
#define MDIOADDR      (MDIO_BASE_ADDR + 0x00)
#define MDIOWR        (MDIO_BASE_ADDR + 0x04)
#define MDIORD        (MDIO_BASE_ADDR + 0x08)
#define MDIOCTRL      (MDIO_BASE_ADDR + 0x0c)
#define OP_RD          1
#define OP_WR          0
#define ENB            1
#define DIS            0
#define INT            1
#define RDY            1

//#define SIMULATION

void PhyInit(u32 Phy);
void PhyDump(u32 Phy);
int PhyRead(u32 PhyAddr, u32 RegAddr, u16 *ReadData);
int PhyWrite(u32 PhyAddr, u32 RegAddr, u16 WriteData);
int PhySleep(int ms);
int test_initialize();

unsigned int phydef[] = PHY_DEFAULTS;

int main (void)
{
    int i;

    init_platform();

    // AXI4-Stream Packet Generator/Checker
    // TURN ON  (0x0) for rapid simulation
    // TURN OFF (0x1) initially for hardware 
#ifdef SIMULATION
    Xil_Out32(XPAR_NF10_AXIS_GEN_CHECK_0_BASEADDR+0x3, 0x0);
    Xil_Out32(XPAR_NF10_AXIS_GEN_CHECK_1_BASEADDR+0x3, 0x0);
#else
    Xil_Out32(XPAR_NF10_AXIS_GEN_CHECK_0_BASEADDR+0x3, 0x1);
    Xil_Out32(XPAR_NF10_AXIS_GEN_CHECK_1_BASEADDR+0x3, 0x1);
#endif

   char s;
   int tx0,rx0,err0,tx1,rx1,err1;

   // giving 200 mS for PHYS to come out of reset 
   PhySleep(200);
   goto INIT;

   while(1){
       print("\r\n== NetFPGA-1G-CML ==\r\n");
       print("i : PHY initialization/status\r\n");
       print("s : Packet Stream status\r\n");
       print("t : Run AXI4-Stream Gen/Check\r\n");
       print("r : Stop AXI4-Stream Gen/Check\r\n");
       s = inbyte();
       if(s == 'i')
INIT:      test_initialize();
       else if (s == 'r'){
           Xil_Out32(XPAR_NF10_AXIS_GEN_CHECK_0_BASEADDR+0x3, 0x1);
           Xil_Out32(XPAR_NF10_AXIS_GEN_CHECK_1_BASEADDR+0x3, 0x1);
           print("AXI4-Stream Gen/Check Stopped\r\n");
       }
       else if (s == 't'){
           Xil_Out32(XPAR_NF10_AXIS_GEN_CHECK_0_BASEADDR+0x3, 0x0);
           Xil_Out32(XPAR_NF10_AXIS_GEN_CHECK_1_BASEADDR+0x3, 0x0);
           print("AXI4-Stream Gen/Check Started\r\n");
       }
       else if (s == 's'){
           tx0 = Xil_In32(XPAR_NF10_AXIS_GEN_CHECK_0_BASEADDR+0x0);
    	   rx0 = Xil_In32(XPAR_NF10_AXIS_GEN_CHECK_0_BASEADDR+0x1);
    	   err0 = Xil_In32(XPAR_NF10_AXIS_GEN_CHECK_0_BASEADDR+0x2);
           tx1 = Xil_In32(XPAR_NF10_AXIS_GEN_CHECK_1_BASEADDR+0x0);
    	   rx1 = Xil_In32(XPAR_NF10_AXIS_GEN_CHECK_1_BASEADDR+0x1);
    	   err1 = Xil_In32(XPAR_NF10_AXIS_GEN_CHECK_1_BASEADDR+0x2);
           xil_printf("AXI4-Stream Gen/Check 0\r\nTX\t%d\t", tx0);
           xil_printf("RX\t%d\t", rx0);
           xil_printf("ERR\t%d\r\n", err0);
           xil_printf("AXI4-Stream Gen/Check 1\r\nTX\t%d\t", tx1);
           xil_printf("RX\t%d\t", rx1);
           xil_printf("ERR\t%d\r\n", err1);
       }
       else
           continue;
   }

   cleanup_platform();
   return 0;
}

//
// Initialize Test 
//

int test_initialize()
{
    u16 led_cfg;
    u16 reg_read;
    u8 i;
    print("\r\n");
    // Check all the PHYs for expected defaults
    PhyInit(1);
    PhyInit(2);
    PhyInit(3);
    PhyInit(4);
    print("\r\n");

    // Configure the Ethernet magnetics and board LEDs for:
    //   LED0 (top right) - Blink on any activity
    //   LED1 (top left) - Link 1000 (Gigabit) up and blink on activity
    //   LED2 (board) - Solid on Link 1000 (Gigabit) up
    for (i = 1; i < 5; i++) {
        // Set PHY to use extended page
        PhyWrite(i, 31, 0x0007);
        // Specify which extended page to use
        PhyWrite(i, 30, 0x002c);
        // Write the LED action control register
        PhyWrite(i, 0x1a, 0x0030);
        // Write the LED control register
        PhyWrite(i, 0x1c, 0x0440);

        // Reset the PHY to use page 0
        PhyWrite(i, 31, 0x0000);
    }
    return XST_SUCCESS;
}

//
// Only link status is checked here, 
// but many other registers can be accessed
// See the Realtek RTL8211 Data Sheet for more details
//
void PhyInit(u32 phy) {
  u32 reg; 
  u16 dat;
  xil_printf("PHY%d\r\n",phy);
  while(1) {
      PhyRead(phy,1,&dat);
        switch(dat) {
          case 0x7949:
            print("  negotiation pending \r\n");
            PhySleep(4000);
            break;
          case 0x7969:
            print("  negotiation complete \r\n");
            PhySleep(100);
            break;
          case 0x796D:
            print("  linked\r\n");
            PhySleep(100);
            return;
            break;
        default:
          xil_printf("\r\n     0x%02x 0x%04x:0x%04x Default:Current\r\n",reg,phydef[1],dat);
          return;
      }
    }
  }

//
// Read PHY Register
//

int PhyRead(u32 PhyAddr, u32 RegAddr, u16 *ReadData)
{
    u32 stat, timeout;
  
// wait for ready
  timeout = 10;
  while ((stat = Xil_In16(MDIOCTRL) & RDY ) && (timeout > 0)) {
    PhySleep(10);
    timeout--;
    }
    if (timeout == 0) {
        xil_printf("\r\nPhyRead ERROR: MAC Not Ready 0x%04x\r\n",stat);
        return XST_FAILURE;
    }
    
// initiate request 
    Xil_Out32(MDIOADDR, (OP_RD << 10) | (PhyAddr << 5) | RegAddr); 
    Xil_Out32(MDIOCTRL, (ENB << 3) | INT);

// wait for response
  timeout = 10;
  while ((stat = Xil_In16(MDIOCTRL) & RDY ) && (timeout > 0)) {
    PhySleep(10);
    timeout--;
    }
    if (timeout == 0) {
        xil_printf("\r\nPhyRead ERROR: Response Timeout 0x%04x\r\n",stat);
        return XST_FAILURE;
    }

// read data from input register
    *ReadData = Xil_In16(MDIORD);

    return XST_SUCCESS;
}

//
// Hardware timer-based sleep 
//
int PhySleep (int ms)
{
    int result_0 = XWdtTb_ReadReg(XPAR_AXI_TIMEBASE_WDT_0_BASEADDR, XWT_TBR_OFFSET);
    int result_1 = result_0;
    while(result_1 - result_0 < ms * 100000) {
        result_1 = XWdtTb_ReadReg(XPAR_AXI_TIMEBASE_WDT_0_BASEADDR, XWT_TBR_OFFSET);
    }
    return XST_SUCCESS;
}

//
// The following are presently not used
// but may be useful in the future
//

//
// Print PHY registers
//
void PhyDump(u32 phy)
{
    u32 reg; 
    u16 dat;
    xil_printf("PHY %d Registers",phy);
    for (reg=0; reg <=30; reg+=4) {
        xil_printf("\r\n 0x%02x: ",reg);
        PhyRead(phy,reg,&dat);
        xil_printf("  0x%04x",dat);
        PhyRead(phy,reg+1,&dat);
        xil_printf("  0x%04x",dat);
        PhyRead(phy,reg+2,&dat);
        xil_printf("  0x%04x",dat);
        PhyRead(phy,reg+3,&dat);
        xil_printf("  0x%04x",dat);
    }
    xil_printf("\r\n\r\n");
}

//
// Write PHY register
//
int PhyWrite(u32 PhyAddr, u32 RegAddr, u16 WriteData)
{
    u32 stat, timeout;

// wait for ready
    timeout = 10;
    while ((stat = Xil_In16(MDIOCTRL) & RDY ) && (timeout > 0)) {
        PhySleep(1);
        timeout--;
    }
    if (timeout == 0) {
        xil_printf("\r\nPhyWrite ERROR: MAC Not Ready\r\n");
        return XST_FAILURE;
    }
    
// put data in MDIO write data register and initiate request
    Xil_Out32(MDIOADDR, (OP_WR << 10) | (PhyAddr << 5) | RegAddr); 
    Xil_Out32(MDIOWR, WriteData); 
    Xil_Out32(MDIOCTRL, (ENB << 3) | INT);

// wait for response
    timeout = 10;
    while ((stat = Xil_In16(MDIOCTRL) & RDY ) && (timeout > 0)) {
        PhySleep(1);
        timeout--;
    }
    if (timeout == 0) {
        xil_printf("\r\nPhyWrite ERROR: Response Timeout\r\n");
        return XST_FAILURE;
    }

    return XST_SUCCESS;
}
