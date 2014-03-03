/*******************************************************************************
 *
 *  NetFPGA-1G-CML http://www.netfpga.org
 *
 *  File:
 *      nf1_cml_switch.c
 *
 *  Project:
 *      reference_switch_lite_nf1_cml
 *
 *  Author:
 *      David Van Arnem
 *
 *  Description:
 *      Standalone application that reconfigures the RTL8211 PHY LEDs to:
 *          LED0 (top right, ethernet magnetics) - Blink on any activity
 *          LED1 (top left, ethernet magnetics) - Link 1000 (Gigabit) up and blink on activity
 *          LED2 (board) - Solid on Link 1000 (Gigabit) up
 *      This application is not necessary for the switch to function.
 *
 *  Copyright notice:
 *      Copyright (C) 2013, Computer Measurement Laboratory, LLC
 *
 *  Licence:
 *        This file is part of the NetFPGA-10G development base package.
 *
 *        This file is free code: you can redistribute it and/or modify it under
 *        the terms of the GNU Lesser General Public License version 2.1 as
 *        published by the Free Software Foundation.
 *
 *        This package is distributed in the hope that it will be useful, but
 *        WITHOUT ANY WARRANTY; without even the implied warranty of
 *        MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 *        Lesser General Public License for more details.
 *
 *        You should have received a copy of the GNU Lesser General Public
 *        License along with the NetFPGA source package. If not, see
 *        http://www.gnu.org/licenses/.
 *
 */ 

#include <stdio.h>
#include "platform.h"
#include "phy_io.h"
#include "xbasic_types.h"
#include "xparameters.h"

#define GBSR 0x0a
#define PHYSR 0x11
#define INSR 0x13
#define RXERC 0x18
#define BMSR 0x01
int main()
{
	int i;
    unsigned short gbsr_rd_val, physr_rd_val, insr_rd_val, rxerc_rd_val;
    unsigned short bmcr_rd_val;
    init_platform();

    // wait for PHYs to come out of reset
    PhySleep(200);

    // Configure the Ethernet magnetics and board LEDs for:
    //   LED0 (top right) - Blink on any activity
    //   LED1 (top left) - Link 1000 (Gigabit) up and blink on activity
    //   LED2 (board) - Solid on Link 1000 (Gigabit) up
//    for (i = 1; i < 5; i++) {
////        PhyRead(i, 0x00, &bmcr_rd_val);
////        xil_printf("BMCR for Phy %d before write : 0x%04x\r\n", i, bmcr_rd_val);
////
////        bmcr_rd_val |= 0x0140;
////
////        PhyWrite(i, 0x00, 0x0140);
////
////        PhyRead(i, 0x00, &bmcr_rd_val);
////        xil_printf("BMCR for Phy %d before reset : 0x%04x\r\n", i, bmcr_rd_val);
////
////        bmcr_rd_val |= 0x8000;
////
////        PhyWrite(i, 0x00, bmcr_rd_val);
////
////        PhyRead(i, 0x00, &bmcr_rd_val);
////        xil_printf("BMCR for Phy %d after reset  : 0x%04x\r\n\n", i, bmcr_rd_val);
////
//        // Set PHY to use extended page
//        PhyWrite(i, 0x1f, 0x0007);
//        // Specify which extended page to use
//        PhyWrite(i, 0x1e, 0x002c);
//        // Write the LED action control register
//        PhyWrite(i, 0x1a, 0x0030);
//        // Write the LED control register
//        PhyWrite(i, 0x1c, 0x0440);
//
//        // Reset the PHY to use page 0
//        PhyWrite(i, 0x1f, 0x0000);
//        PhySleep(500);
//    }

    xil_printf("PHY LED reconfiguration complete!\r\n");

    while (1) {
        for (i = 0; i < 1500000; i++);
        PhyRead(1, BMSR, &gbsr_rd_val);
//        PhyRead(1, PHYSR, &physr_rd_val);
//        PhyRead(1, INSR, &insr_rd_val);
//        PhyRead(1, RXERC, &rxerc_rd_val);

        xil_printf("BMSR:  0x%04x\r\n", gbsr_rd_val);
//        xil_printf("PHYSR: 0x%04x\r\n", physr_rd_val);
//        xil_printf("INSR:  0x%04x\r\n", insr_rd_val);
//        xil_printf("RXERC: 0x%04x\r\n\n", rxerc_rd_val);
    }

    return 0;
}

