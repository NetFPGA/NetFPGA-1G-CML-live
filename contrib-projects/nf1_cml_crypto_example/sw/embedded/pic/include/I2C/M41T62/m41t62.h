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
 * \file m41t62.h
 *
 * \brief Header file for m41t62.c
 *
 * \author Computer Measurement Laboratory
 */

#ifndef M41T62_H
#define M41T62_H

#include <GenericTypeDefs.h>
#include "plib.h"

/*!
 * \brief Structure containing the time fields used by the M41T62 RTC.
 *
 * \note These fields are meant to simplify code organization, but are not
 * formatted for direct use with the M41T62 registers.  Instead, pass the
 * structure to FormatTimeForRTC() to get an array that is formatted for the
 * M41T62.
 */
typedef struct rtc_time {
    UINT8 century;  /*!< Century byte       */
    UINT8 year;     /*!< Year byte          */
    UINT8 month;    /*!< Month byte         */
    UINT8 date;     /*!< Day byte           */
    UINT8 dow;      /*!< Day of week byte   */
    UINT8 hour;     /*!< Hours byte         */
    UINT8 min;      /*!< Minutes byte       */
    UINT8 sec;      /*!< Seconds byte       */
    UINT8 tenths;   /*!< Tenths byte        */
} RTC_TIME;

/*! \brief M41T62 fractional seconds register address */
#define M41T62_SSEC         0x00
/*! \brief M41T62 seconds register address */
#define M41T62_SECONDS 	    0x01
/*! \brief M41T62 minutes register address */
#define M41T62_MINUTES 	    0x02
/*! \brief M41T62 hours register address */
#define M41T62_HOURS	    0x03
/*! \brief M41T62 day of the week register address */
#define M41T62_DAY		    0x04
/*! \brief M41T62 day of the month register address */
#define M41T62_DATE		    0x05
/*! \brief M41T62 century and month register address */
#define M41T62_CEN_MON	    0x06
/*! \brief M41T62 year register address */
#define M41T62_YEAR		    0x07
/*! \brief M41T62 calibration register address */
#define M41T62_CALIBRATION	0x08
/*! \brief M41T62 watchdog timer register address */
#define M41T62_WATCHDOG		0x09
/*! \brief M41T62 alarm month register address */
#define M41T62_ALARM_MONTH	0x0A
/*! \brief M41T62 alarm date register address */
#define M41T62_ALARM_DATE	0x0B
/*! \brief M41T62 alarm hours register address */
#define M41T62_ALARM_HOUR	0x0C
/*! \brief M41T62 alarm minutes register address */
#define M41T62_ALARM_MIN	0x0D
/*! \brief M41T62 alarm seconds register address */
#define M41T62_ALARM_SEC	0x0E
/*! \brief M41T62 flags register address */
#define M41T62_FLAGS		0x0F

I2C_RESULT M41T62_WriteTime(RTC_TIME *);
I2C_RESULT M41T62_ReadTime(RTC_TIME *);
void FormatTimeForRTC(RTC_TIME *, UINT8 *);
void FormatTimeForHuman(UINT8 *, RTC_TIME *);
void M41T62_PrintTime(RTC_TIME *);
void M41T62_EnterTime(RTC_TIME *);
void M41T62_Init(void);
BOOL M41T62_Test(void);

#endif /* M41T62_H */
