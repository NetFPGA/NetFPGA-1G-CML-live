/*
 * Copyright (c) 2009-2012 Xilinx, Inc.  All rights reserved.
 *
 * Xilinx, Inc.
 * XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS" AS A
 * COURTESY TO YOU.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
 * ONE POSSIBLE   IMPLEMENTATION OF THIS FEATURE, APPLICATION OR
 * STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS IMPLEMENTATION
 * IS FREE FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE RESPONSIBLE
 * FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE FOR YOUR IMPLEMENTATION.
 * XILINX EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH RESPECT TO
 * THE ADEQUACY OF THE IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO
 * ANY WARRANTIES OR REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
 * FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.
 *
 */

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xparameters.h"
#include "xhwicap.h"

void print(char *str);

// Multiboot commands
static unsigned int rcfg_cmds[8] = {
    0xFFFFFFFF,
    0xAA995566,
    0x20000000,
    0x30020001,
    0x02000000,
    0x30008001,
    0x0000000F,
    0x20000000
};

int main()
{
    volatile unsigned int *gpio_data = (volatile unsigned int *)(XPAR_AXI_GPIO_BPI_IF_BASEADDR + 0x08);
    volatile unsigned int *gpio_tris = (volatile unsigned int *)(XPAR_AXI_GPIO_BPI_IF_BASEADDR + 0x0c);
    unsigned int hwicap_base_addr = XPAR_AXI_HWICAP_0_BASEADDR;
    int i;

    // BPI data tristate 0-15 as output, 16-17 as input
    *gpio_tris = 0x00030000;
    init_platform();

    while (1) {
        if ((*gpio_data & 0x00030000) == 0x00020000) {
            // check that BPI data 16-17 is 01
            xil_printf("PIC signal detected, loading the NetFPGA-1G-CML self test...\r\n");

            for (i = 0; i < 10000; i++);

            // write commands to HWICAP FIFO
            for (i = 0; i < 8; i++) {
                XHwIcap_WriteReg(hwicap_base_addr, XHI_WF_OFFSET, rcfg_cmds[i]);
            }

            // tell HWICAP to run commands in FIFO
            XHwIcap_WriteReg(hwicap_base_addr, XHI_CR_OFFSET, XHI_CR_WRITE_MASK);
            break;
        }
    }

    xil_printf("End of microBlaze code\r\n");
    return 0;
}
