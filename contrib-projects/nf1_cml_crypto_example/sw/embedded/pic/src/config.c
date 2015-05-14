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
 * \file config.c
 *
 * \brief Contains the configuration settings necessary for the NetFPGA-7's
 * PIC32MX795F512L.
 *
 * The settings for the PIC are:
 *  - ICESEL    : ICS_PGx1
 *  - BWP       : OFF
 *  - CP        : OFF
 *  - FNOSC     : PRIPLL
 *  - FSOSCEN   : OFF
 *  - IESO      : OFF
 *  - POSCMOD   : XT
 *  - OSCIOFNC  : OFF
 *  - FPBDIV    : DIV_2
 *  - WDTPS     : PS1024
 *  - FWDTEN    : OFF
 *  - FPLLIDIV  : DIV_2
 *  - FPLLMUL   : MUL_20
 *  - FPLLODIV  : DIV_1
 *  - UPLLIDIV  : DIV_2
 *  - UPLLEN    : ON
 *  - PWP       : OFF
 *  - DEBUG     : OFF
 *
 * More information about the configuration settings can be found in the Help
 * topics in MPLAB X.
 *
 * \author Computer Measurement Laboratory
 */

#pragma config ICESEL   = ICS_PGx1		// ICE/ICD Comm Channel Select
#pragma config BWP      = OFF			// Boot Flash Write Protect
#pragma config CP       = OFF			// Code Protect
#pragma config FNOSC    = PRIPLL		// Oscillator Selection : Primary w/ PLL
#pragma config FSOSCEN  = OFF			// Secondary Oscillator Enable : OFF
#pragma config IESO     = OFF			// Internal/External Switch-over
#pragma config POSCMOD  = XT			// Primary Oscillator Type: 3.5MHz-10MHz crystal
#pragma config OSCIOFNC = OFF			// CLKO Enable: CLKO disabled, we have a crystal there
#pragma config FPBDIV	= DIV_2			// Peripheral Clock divisor (60/2=30 MHz)
#pragma config WDTPS    = PS1024		// Watchdog Timer Postscale 1:1024 = 1.024s
#pragma config FWDTEN   = OFF			// Watchdog Timer
#pragma config FPLLIDIV = DIV_2			// PLL Input Divider: PLL Input has to be in the 4-5 MHz range (8/2=4)
#pragma config FPLLMUL  = MUL_20		// PLL Multiplier: 8/2*15=60
#pragma config FPLLODIV = DIV_1			// PLL Output Divider: 8/2*15/1=60 MHz Core Freq
#pragma config UPLLIDIV = DIV_2			// USB PLL Input Divider: PLL Input has to be in the 4-5 MHz range (8/2=4)
#pragma config UPLLEN   = ON			// USB PLL Enabled: ON
#pragma config PWP      = OFF			// Program Flash Write Protect
#pragma config DEBUG    = OFF			// Debugger Enable/Disable
