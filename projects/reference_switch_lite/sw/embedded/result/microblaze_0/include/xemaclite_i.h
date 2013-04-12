/* $Id: xemaclite_i.h,v 1.1.2.1 2010/07/12 08:34:27 svemula Exp $ */
/******************************************************************************
*
* (c) Copyright 2004-2009 Xilinx, Inc. All rights reserved.
*
* This file contains confidential and proprietary information of Xilinx, Inc.
* and is protected under U.S. and international copyright and other
* intellectual property laws.
*
* DISCLAIMER
* This disclaimer is not a license and does not grant any rights to the
* materials distributed herewith. Except as otherwise provided in a valid
* license issued to you by Xilinx, and to the maximum extent permitted by
* applicable law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND WITH ALL
* FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES AND CONDITIONS, EXPRESS,
* IMPLIED, OR STATUTORY, INCLUDING BUT NOT LIMITED TO WARRANTIES OF
* MERCHANTABILITY, NON-INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE;
* and (2) Xilinx shall not be liable (whether in contract or tort, including
* negligence, or under any other theory of liability) for any loss or damage
* of any kind or nature related to, arising under or in connection with these
* materials, including for any direct, or any indirect, special, incidental,
* or consequential loss or damage (including loss of data, profits, goodwill,
* or any type of loss or damage suffered as a result of any action brought by
* a third party) even if such damage or loss was reasonably foreseeable or
* Xilinx had been advised of the possibility of the same.
*
* CRITICAL APPLICATIONS
* Xilinx products are not designed or intended to be fail-safe, or for use in
* any application requiring fail-safe performance, such as life-support or
* safety devices or systems, Class III medical devices, nuclear facilities,
* applications related to the deployment of airbags, or any other applications
* that could lead to death, personal injury, or severe property or
* environmental damage (individually and collectively, "Critical
* Applications"). Customer assumes the sole risk and liability of any use of
* Xilinx products in Critical Applications, subject only to applicable laws
* and regulations governing limitations on product liability.
*
* THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE
* AT ALL TIMES.
*
******************************************************************************/
/******************************************************************************/
/**
* @file xemaclite_i.h
*
* This header file contains internal identifiers, which are those shared
* between the files of the driver. It is intended for internal use only.
*
* NOTES:
*
* None.
*
* <pre>
* MODIFICATION HISTORY:
*
* Ver   Who  Date     Changes
* ----- ---- -------- -----------------------------------------------
* 1.01a ecm  05/21/04 First release
* 1.11a mta  03/21/07 Updated to new coding style
* 1.13a sv   02/1/08  Added macros to Get/Set Tx/Rx status
* 3.00a ktn  10/22/09 The macros have been renamed to remove _m from the name.
*		      The macros changed in this file are
*		      XEmacLite_mGetTxActive changed to XEmacLite_GetTxActive,
*		      XEmacLite_mSetTxActive changed to XEmacLite_SetTxActive.
*
* </pre>
******************************************************************************/

#ifndef XEMACLITE_I_H		/* prevent circular inclusions */
#define XEMACLITE_I_H		/* by using protection macros */

#ifdef __cplusplus
extern "C" {
#endif


/***************************** Include Files *********************************/

#include "xemaclite.h"

/************************** Constant Definitions ****************************/

/**************************** Type Definitions *******************************/

/***************** Macros (Inline Functions) Definitions *********************/

/****************************************************************************/
/**
*
* Get the TX active location to check status. This is used to check if
* the TX buffer is currently active. There isn't any way in the hardware
* to implement this but the register is fully populated so the driver can
* set the bit in the send routine and the ISR can clear the bit when
* the handler is complete. This mimics the correct operation of the hardware
* if it was possible to do this in hardware.
*
* @param	BaseAddress is the base address of the device
*
* @return	Contents of active bit in register.
*
* @note		C-Style signature:
* 		u32 XEmacLite_GetTxActive(u32 BaseAddress)
*
*****************************************************************************/
#define XEmacLite_GetTxActive(BaseAddress)			\
		 (XEmacLite_ReadReg((BaseAddress), XEL_TSR_OFFSET))

/****************************************************************************/
/**
*
* Set the TX active location to update status. This is used to set the bit
* indicating which TX buffer is currently active. There isn't any way in the
* hardware to implement this but the register is fully populated so the driver
* can set the bit in the send routine and the ISR can clear the bit when
* the handler is complete. This mimics the correct operation of the hardware
* if it was possible to do this in hardware.
*
* @param	BaseAddress is the base address of the device
* @param	Mask is the data to be written
*
* @return	None
*
* @note		C-Style signature:
* 		void XEmacLite_SetTxActive(u32 BaseAddress, u32 Mask)
*
*****************************************************************************/
#define XEmacLite_SetTxActive(BaseAddress, Mask) 		\
	(XEmacLite_WriteReg((BaseAddress), XEL_TSR_OFFSET, (Mask)))

/************************** Variable Definitions ****************************/

extern XEmacLite_Config XEmacLite_ConfigTable[];

/************************** Function Prototypes ******************************/

void XEmacLite_AlignedWrite(void *SrcPtr, u32 *DestPtr, unsigned ByteCount);
void XEmacLite_AlignedRead(u32 *SrcPtr, void *DestPtr, unsigned ByteCount);

void StubHandler(void *CallBackRef);


#ifdef __cplusplus
}
#endif

#endif /* end of protection macro */
