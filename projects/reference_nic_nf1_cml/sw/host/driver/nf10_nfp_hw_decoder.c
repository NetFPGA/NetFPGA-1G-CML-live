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

    //Read date, month, year when synthesised.
    *(((uint64_t*)card->cfg_addr) + 129) = (ID_BASE_ADDR + 0x4) << 32;
    mb();
    val = (*(((uint64_t*)card->cfg_addr) + 129)) & 0xffffffff;
    byte[0] = (0xff & val);                 //year
    byte[1] = (0xffff & val) >> 8;          //month
    byte[2] = (0xffffff & val) >> 16;       //day
    printk(KERN_INFO "nf10: This HW was implemented on %llx/%llx/20%llx (dd/mm/yy)\n", byte[2], byte[1], byte[0]);
    
   //Read time when synthesised
    *(((uint64_t*)card->cfg_addr) + 129) = (ID_BASE_ADDR + 0x8) << 32;
    mb();
    val = (*(((uint64_t*)card->cfg_addr) + 129)) & 0xffffffff;
    byte[0] = (0xff & val);                 //min
    byte[1] = (0xffff & val) >> 8;          //hour
    printk(KERN_INFO "nf10: Time: %llx:%llx (hour:min)\n", byte[1], byte[0]);

    //Read project ID
    *(((uint64_t*)card->cfg_addr) + 129) = (ID_BASE_ADDR + 0xc) << 32;
    mb();
    val = (*(((uint64_t*)card->cfg_addr) + 129)) & 0xffffffff;
    val &= 0xffff;
    printk(KERN_INFO "nf10: Project ID code: 0x%llx\n", val);

    switch (val) {
        case 0xa : printk(KERN_INFO "nf10: The reference nic\n"); break;
        case 0xb : printk(KERN_INFO "nf10: The reference switch\n"); break;
        case 0xc : printk(KERN_INFO "nf10: The reference router\n"); break;
        case 0xd : printk(KERN_INFO "nf10: The reference switch_lite\n"); break;
        default : printk(KERN_INFO "nf10: No project identified!\n"); break;
    }

    //Read git tag 
    *(((uint64_t*)card->cfg_addr) + 129) = (ID_BASE_ADDR + 0x10) << 32;
    mb();
    val = (*(((uint64_t*)card->cfg_addr) + 129)) & 0xffffffff;
    byte[0] = (0xf & val);                 //tag_0
    byte[1] = (0xff & val) >> 4;           //tag_1
    byte[2] = (0xfff & val) >> 8;          //tag_2
    printk(KERN_INFO "nf10: NetFPGA GitHub Tag : %llx.%llx.%llx\n", byte[2], byte[1], byte[0]);

    //Read Board ID
    *(((uint64_t*)card->cfg_addr) + 129) = (ID_BASE_ADDR + 0x14) << 32;
    mb();
    val = (*(((uint64_t*)card->cfg_addr) + 129)) & 0xffffffff;
    val &= 0xffff;
    printk(KERN_INFO "nf10: Board ID code: 0x%llx\n", val);

    switch (val) {
        case 0xa : printk(KERN_INFO "nf10: NetFPGA-10G board\n"); break;
        default : printk(KERN_INFO "nf10: No board identified!\n"); break;
    }

    //if (If you don't like this version of the hw, you could stop now)
}