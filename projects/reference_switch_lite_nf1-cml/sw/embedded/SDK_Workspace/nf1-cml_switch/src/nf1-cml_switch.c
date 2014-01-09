/*******************************************************************************
 *
 *  NetFPGA-1G-CML https://github.com/cmlab/netfpga-1g-cml
 *
 *  File:
 *      nf1-cml_switch.c
 *
 *  Project:
 *      reference_switch_lite_nf1-cml
 *
 *  Author:
 *      David Van Arnem, Computer Measurement Laboratory, LLC
 *
 *  Description:
 *      Standalone application that reconfigures the RTL8211 PHY LEDs to:
 *          LED0 (top right, ethernet magnetics) - Blink on any activity
 *          LED1 (top left, ethernet magnetics) - Link 1000 (Gigabit) up and blink on activity
 *          LED2 (board) - Solid on Link 1000 (Gigabit) up
 *
 *  Copyright notice:
 *      Copyright (C) 2014, Computer Measurement Laboratory, LLC
 *
 *  Licence:
 *        This file is part of the NetFPGA-1G-CML development base package.
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
 *        License along with the NetFPGA-1G-CML source package. If not, see
 *        http://www.gnu.org/licenses/.
 *
 */ 

#include <stdio.h>
#include "platform.h"
#include "phy_io.h"
#include "xbasic_types.h"
#include "xparameters.h"

int main()
{
	int i;
    init_platform();

    // wait for PHYs to come out of reset
    PhySleep(200);

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

    xil_printf("PHY LED reconfiguration complete!\r\n");

    return 0;
}

