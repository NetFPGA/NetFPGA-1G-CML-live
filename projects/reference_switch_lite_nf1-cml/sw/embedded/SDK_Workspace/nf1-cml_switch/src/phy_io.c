/*******************************************************************************
 *
 *  NetFPGA-1G-CML https://github.com/cmlab/netfpga-1g-cml
 *
 *  File:
 *      phy_io.c
 *
 *  Project:
 *      reference_switch_lite_nf1-cml
 *
 *  Author:
 *      David Van Arnem, Computer Measurement Laboratory, LLC
 *
 *  Description:
 *      Realtek RTL8211 PHY register input and output using the nf1-cml_mdio pcore
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
#include "xbasic_types.h"
#include "xstatus.h"
#include "xparameters.h"
#include "xwdttb.h"

#include "phy_io.h"

// Realtek RTL8211 PHY register defaults
#define PHY_DEFAULTS {0x1140,0x7949,0x001C,0xC915,0x05E1,0x0000,0x0004,0x2001,\
                      0x0000,0x0200,0x0000,0x0000,0x0000,0x0000,0x0000,0x3000,\
                      0x016E,0x4040,0x9F01,0x0040,0x8040,0x1006,0x4100,0x2100,\
                      0x0000,0x8C00,0x0040,0x805A,0x0408,0x8038,0x0123,0x0000}

unsigned int phydef[] = PHY_DEFAULTS;

#define MDIO_BASE_ADDR XPAR_NF7_MDIO_0_BASEADDR
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

/*!
 * \brief Read a PHY register.
 *
 * \param PhyAddr the PHY address to read
 * \param RegAddr the register address in the PHY to read
 * \param ReadData a pointer to where to store the data read
 *
 * \return the status of the operation
 */
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

/*!
 * \brief Hardware timer-based sleep
 *
 * \param ms the number of milliseconds to sleep
 */
void PhySleep (int ms)
{
    int result_0 = XWdtTb_ReadReg(XPAR_AXI_TIMEBASE_WDT_0_BASEADDR, XWT_TBR_OFFSET);
    int result_1 = result_0;
    while(result_1 - result_0 < ms * 100000) {
        result_1 = XWdtTb_ReadReg(XPAR_AXI_TIMEBASE_WDT_0_BASEADDR, XWT_TBR_OFFSET);
    }
}

/*!
 * \brief Prints the value of all the RTL8211 PHY registers
 *
 * \param phy the PHY address to dump
 */
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

/*!
 * \brief Write a PHY register.
 *
 * \param PhyAddr the PHY address to write
 * \param RegAddr the PHY register address to write
 * \param WriteData the data to write
 *
 * \return the status of the operation
 */
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
