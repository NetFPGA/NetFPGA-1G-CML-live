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
 * \file fpga_comm.c
 *
 * \brief Main application for handling requests from the Microblaze.
 *
 * \author Computer Measurement Laboratory
 *
 */

#include <GenericTypeDefs.h>
#include <peripheral/spi.h>
#include <peripheral/spi_5xx_6xx_7xx.h>
#include <stdio.h>
#include <stdlib.h>
#include "HardwareProfile.h"
#include "SPI/fpga_helper.h"
#include "SPI/fpga_messages.h"

UINT8 fx2_rev_code;  // expected by utility.c

/*
 * Forward prototypes
 */
void handle_microblaze(void);


/*
 * 
 */
int main(int argc, char** argv)
{ 
  InitMCU();
  InitApp(); 
 
  printf("\r\nbuilt %s at %s\r\n", __DATE__, __TIME__);
  printf("\r\n**\r\n** PIC initialized, waiting for request from FPGA\r\n**\r\n\r\n");

  while(1)  // forever handle requests from the FPGA...
  {
    handle_microblaze();
  }
 
  return (EXIT_SUCCESS);
}


void handle_microblaze(void)
{

  check_FPGA_SPI(SPI_CHANNEL4);
}
