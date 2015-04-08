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
 * \file utility.c
 *
 * \brief Contains various functions for initializing peripherals in the PIC.
 *
 * \author Computer Measurement Laboratory
 */

#include "GenericTypeDefs.h"
#include "HardwareProfile.h"
#include "utility.h"
#include "I2C/SHA204/sha204_physical.h"
#include "I2C/SHA204/sha204_lib_return_codes.h"
#include "I2C/M41T62/m41t62.h"
#include <plib.h>

#define REQ_FPGA_ATTN_TRI   trisPIC2FPGA_GPIO0
#define REQ_FPGA_ATTN       portPIC2FPGA_GPIO0
int pic_timer2_expired;		// PIC timer 2 interrupt handler flag

/*!
 * \brief Overloaded function so putc()/printf() use UART1 instead of UART2.
 *
 * \param[in] c the character to put in the UART1 transmit buffer
 */
void _mon_putc(char c)
{
	while (U1STAbits.UTXBF);
	U1TXREG = c;
}

/*!
 * \brief Initializes the peripherals and interfaces
 */
void InitApp(void)
{
//    InitPicTimer1();
    // timer for real-time delays
    InitPicTimer2();
    // UART for terminal communication
    InitUART1();
    // I2C2 module
    InitI2C2();
    // SPI2 module
    InitSPI2();
    // SPI4 module
    InitSPI4();
    sha204p_init();
    // set FPGA attention getter high
    REQ_FPGA_ATTN_TRI = OUTPUT_PIN;
    REQ_FPGA_ATTN = 1;
    delay_ms(2000);
}

/*!
 * \brief Initializes Timer 2 to interrupt every 1 millisecond
 *
 * The millisecond interrupt is generated by counting 40,000 cycles of the
 * PBClk, which runs at 40 MHz.
 */
void InitPicTimer2(void)
{
    T2CON = 0x0;	// 16-bit mode
    T2CONSET = 0x0;
    TMR2 = 0x0;
    PR2 = 0x9c40;       // 40,000 decimal
    T2CONSET = 0x8000;
    INTEnable(INT_T2, INT_ENABLED);
    INTSetVectorPriority(INT_TIMER_2_VECTOR, INT_PRIORITY_LEVEL_3);
    INTSetVectorSubPriority(INT_TIMER_2_VECTOR, INT_SUB_PRIORITY_LEVEL_0);
    INTConfigureSystem(INT_SYSTEM_CONFIG_MULT_VECTOR);
    INTEnableInterrupts();
}

/*!
 * \brief Timer 2 interrupt handler. (1 ms)
 *
 * The handler sets a flag whenever Timer 2 interrupts (every ~1ms) that is
 * used in the delay_ms function.
 */
void __ISR(_TIMER_2_VECTOR, IPL3AUTO) Timer2Handler(void)
{
    INTClearFlag(INT_T2);
    pic_timer2_expired = 1;
}

/*!
 * \brief This function returns after a specified delay. in
 * milliseconds.
 *
 * It uses PIC Timer 2, configured to interrupt every 1 ms, to generate fairly
 * accurate real-time delays.
 *
 * \param[in] delay number of milliseconds to delay
 */
void delay_ms(int delay)
{
    int i;
    pic_timer2_expired = 0;
    for (i = 0; i < delay; i++) {
        TMR2 = 0;
        while(!pic_timer2_expired);
        pic_timer2_expired = 0;
    }
}

/*!
 * \brief Initializes UART1 for TX/RX at 115200 baud, 8N1.
 */
void InitUART1(void)
{
	UARTConfigure(UART1, UART_ENABLE_PINS_TX_RX_ONLY);
  	UARTSetFifoMode(UART1, UART_INTERRUPT_ON_TX_NOT_FULL | UART_INTERRUPT_ON_RX_NOT_EMPTY);
	UARTSetLineControl(UART1, UART_DATA_SIZE_8_BITS | UART_PARITY_NONE |
			UART_STOP_BITS_1);
    UARTSetDataRate(UART1, GetPeripheralClock(), 115200);
    UARTEnable(UART1, UART_ENABLE_FLAGS(UART_PERIPHERAL | UART_RX | UART_TX));

    // UART Interrupt setup
//  	INTEnable(INT_SOURCE_UART_RX(UART1), INT_ENABLED);
//  	INTSetVectorPriority(INT_VECTOR_UART(UART1), INT_PRIORITY_LEVEL_3);
//  	INTSetVectorSubPriority(INT_VECTOR_UART(UART1), INT_SUB_PRIORITY_LEVEL_0);
}

/*!
 * \brief Initialize the I2C2 port for communication.
 *
 * I2C2 is set for 100 KHz mode since that is the max speed for the ADM1177.
 */
void InitI2C2(void)
{
    unsigned int actualClock;
    I2CConfigure(I2C2, I2C_ENABLE_SLAVE_CLOCK_STRETCHING);
    actualClock = I2CSetFrequency(I2C2, GetPeripheralClock(), I2C_CLOCK_FREQ_FAST);
    //actualClock = I2CSetFrequency(I2C2, GetPeripheralClock(), I2C_CLOCK_FREQ_SLOW);
    if (abs(actualClock - I2C_CLOCK_FREQ_FAST) > I2C_CLOCK_FREQ_FAST/10) {
    //if (abs(actualClock - I2C_CLOCK_FREQ_SLOW) > I2C_CLOCK_FREQ_SLOW/10) {
        printf("Error: I2C2 clock frequency error exceeds 10%%.\r\n");
    }

    I2CEnable(I2C2, TRUE);
}

/*!
 * \brief Initializes the SPI2 interface.
 *
 * SPI2 acts as a master to the FPGA on the NetFPGA-7 and is initialized in
 * master mode with slave select and 1 byte data width.
 */
void InitSPI2(void)
{
    SpiOpenFlags flags = SPI_OPEN_MSTEN | SPI_OPEN_MSSEN | SPI_OPEN_MODE8 | SPI_OPEN_ENHBUF | SPI_OPEN_CKE_REV;
    SpiChnOpen(SPI_CHANNEL2, flags, 40);
}

/*!
 * \brief Initializes the SPI4 interface.
 *
 * SPI4 acts as a slave to the FPGA on the NetFPGA-7 and is initialized in
 * slave mode with slave select and 1 byte data width.
 */
void InitSPI4(void)
{
    SpiOpenFlags flags = SPI_OPEN_SLVEN | SPI_OPEN_SSEN | SPI_OPEN_MODE8 | SPI_OPEN_ENHBUF | SPI_OPEN_CKE_REV;
    SpiChnOpen(SPI_CHANNEL4, flags, 256);
}

/*!
 * \brief Initializes the microcontroller system.
 *
 * Initialization sets up the system to run at 80 MHz with cache and wait states
 * enabled.  Also sets the analog pins to digital mode.
 */
void InitMCU(void)
{
	int  value;

	value = SYSTEMConfig( GetSystemClock(), SYS_CFG_WAIT_STATES | SYS_CFG_PCACHE );

	// Enable the cache for the best performance
	CheKseg0CacheOn();

	value = OSCCON;
	while (!(value & 0x00000020))
	{
	    value = OSCCON;    // Wait for PLL lock to stabilize
	}

	AD1PCFG = 0xFFFF;   // Set analog pins to digital.
	TRISF   = 0x00;
}

/*!
 * \brief Gets a character from UART1's receive line.
 *
 * This function is used to get a selection from a user through a terminal
 * emulator on a host machine.
 *
 * \note This is a blocking function and will wait until data is available on
 * the UART.
 */
char GetUserInput(void)
{
    char sel;
    while (!UARTReceivedDataIsAvailable(UART1));
    sel = UARTGetDataByte(UART1);
    // print the character if it's not ESC
    if (sel != 0x1B) {
        printf("%c", sel);
    }
    // clear interrupt flag
//	INTClearFlag(INT_SOURCE_UART_RX(UART1));
    return sel;
}
