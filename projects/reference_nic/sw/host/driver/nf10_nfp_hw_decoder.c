/*******************************************************************************
 *
 *  NetFPGA-10G http://www.netfpga.org
 *
 *  File:
 *        nf10_nfp_hw_decoder.c
 *
 *  Project:
 *        nic
 *
 *  Author:
 *        M. Forconesi (Cambridge Team)
 *
 *  Modified by:
 *        Neelakandan Manihatty Bojan  
 *        -- updated on 13 May 2014 to do more register parsing to extract
 *           bitfile related information 				
 *
 *  Description:
 *        Top level file to find out the hardware configured on the
 *        NetFPGA-10G board.
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

#include <linux/kernel.h>
#include "nf10driver.h"
#include "nf10_nfp_hw_decoder.h"

void nf10_NetFPGA_Hardware_Project_decoder(struct nf10_card *card) {
    uint64_t val, byte[4];

    //let's see what type of project you have...
    //printk(KERN_INFO "nf10: let's see what type of project you have...\n");

    // Register 1 : Read date, month, year when synthesised.
    *(((uint64_t*)card->cfg_addr) + 129) = (ID_BASE_ADDR + 0x4) << 32;
    mb();
    val = (*(((uint64_t*)card->cfg_addr) + 129)) & 0xffffffff;
    byte[0] = (0xff & val);                 //year_lower
    byte[1] = (0xffff & val) >> 8;          //year_upper
    byte[2] = (0xffffff & val) >> 16;       //month
    byte[3] = (0xffffffff & val) >>24;     //day

    printk(KERN_INFO "nf10: This HW was implemented on %llx/%llx/%llx%llx (dd/mm/YYyy)\n", byte[3], byte[2], byte[1], byte[0]);
    
   //Register 2 : Read time when synthesised
    *(((uint64_t*)card->cfg_addr) + 129) = (ID_BASE_ADDR + 0x8) << 32;
    mb();
    val = (*(((uint64_t*)card->cfg_addr) + 129)) & 0xffffffff;
    byte[0] = (0xff & val);                 //seconds
    byte[1] = (0xffff & val) >> 8;          //min
    byte[2] = (0xffffff & val) >> 16;       //hour
    printk(KERN_INFO "nf10: Time: %llx:%llx:%llx (hour:min:sec)\n",byte[2], byte[1], byte[0]);

    //Register 3 : Read project related information
    *(((uint64_t*)card->cfg_addr) + 129) = (ID_BASE_ADDR + 0xc) << 32;
    mb();
    val = (*(((uint64_t*)card->cfg_addr) + 129)) & 0xffffffff;
    byte[0] = (0x3fff & val);               //project_id
    byte[1] = (0xffff & val) >> 15;         //identifies if it is a reference/contrib project
    byte[2] = (0xffffffff & val) >> 16;     //project features 
    
    printk(KERN_INFO "nf10: Project ID code: %llx:%llx:%llx \n", byte[2], byte[1], byte[0]);

    switch (byte[0]) {
        case 0x1 : printk(KERN_INFO "nf10: The reference nic\n"); break;
        case 0x2 : printk(KERN_INFO "nf10: The reference switch\n"); break;
        case 0x3 : printk(KERN_INFO "nf10: The reference router\n"); break;
        case 0x4 : printk(KERN_INFO "nf10: The reference switch_lite\n"); break;
        default : printk(KERN_INFO "nf10: No project identified!\n"); break;
    }

    switch (byte[1]) {
        case 0x0 : printk(KERN_INFO "nf10: This is a contributed project\n"); break;
        case 0x1 : printk(KERN_INFO "nf10: This is a reference project\n"); break;
        default : printk(KERN_INFO "nf10: Cannot identify the project!\n"); break;
    }

    switch (byte[2]) {
        case 0xff: printk(KERN_INFO "nf10: Lots of features\n"); break;
        default : printk(KERN_INFO "nf10: This is work in progress!\n"); break;
    }

    //Register 4 : Read git tag 
    *(((uint64_t*)card->cfg_addr) + 129) = (ID_BASE_ADDR + 0x10) << 32;
    mb();
    val = (*(((uint64_t*)card->cfg_addr) + 129)) & 0xffffffff;
    byte[0] = (0xf & val);                 //tag_0
    byte[1] = (0xff & val) >> 4;           //tag_1
    byte[2] = (0xfff & val) >> 8;          //tag_2
    printk(KERN_INFO "nf10: NetFPGA GitHub Tag : %llx.%llx.%llx\n", byte[2], byte[1], byte[0]);

    //Register 5 : Board specific information
    *(((uint64_t*)card->cfg_addr) + 129) = (ID_BASE_ADDR + 0x14) << 32;
    mb();
    val = (*(((uint64_t*)card->cfg_addr) + 129)) & 0xffffffff;
    byte[0] = (0xff & val);                 //Board revision number
    byte[1] = (0xffff & val) >> 8;          //Board identification number
    byte[2] = (0xffffff & val) >> 16;       //Board PCB version
    byte[3] = (0xffffffff & val) >>24;      //BOard Assembly number
    printk(KERN_INFO "nf10: Board Revision number is    : %llx\n", byte[0]);
    printk(KERN_INFO "nf10: Board idenfification id is  : %llx\n", byte[1]);
    printk(KERN_INFO "nf10: Board PCB version is        : %llx\n", byte[2]);
    printk(KERN_INFO "nf10: Board Assembly number is    : %llx\n", byte[3]);

   switch (byte[1]) {
        case 0x1 : printk(KERN_INFO "nf10: This project is for NetFPGA-1G board\n"); break;
        case 0x2 : printk(KERN_INFO "nf10: This project is for NetFPGA-10G board\n"); break;
        case 0x3 : printk(KERN_INFO "nf10: This project is for NetFPGA-CML board\n"); break;
        case 0x4 : printk(KERN_INFO "nf10: This project is for NetFPGA-SUME board\n"); break;
        default : printk(KERN_INFO "nf10: Board can't be identified!\n"); break;
    }


    //if (If you don't like this version of the hw, you could stop now)
}
