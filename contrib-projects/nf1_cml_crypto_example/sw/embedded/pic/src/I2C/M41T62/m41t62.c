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
 * \file m41t62.c
 *
 * \brief This file contains functions to interface with the M41T62 Real Time Clock.
 *
 * More information about the part can be found in the datasheet
 * <a href="http://www.st.com/web/en/resource/technical/document/datasheet/CD00019860.pdf">
 * here</a>.
 *
 * \author Computer Measurement Laboratory
 */

#include <plib.h>
#include "I2C/M41T62/m41t62.h"
#include "HardwareProfile.h"
#include "I2C/i2c_helper.h"
#include "utility.h"

/*!
 * \brief Writes all the time registers in the M41T62 RTC.
 *
 * The M41T62 has 8 time registers that cover the following time components:
 *      - Century
 *      - Year
 *      - Month
 *      - Day
 *      - Day of Week
 *      - Hour (24 hour format)
 *      - Minutes
 *      - Seconds
 *      - Fractional Seconds
 *
 * m41t62.h contains a struct to store all of these components, called RTC_TIME.
 *
 * The M41T62 supports automatic address pointer incrementing, so it is only
 * necessary to write the first register address on the device and consecutive
 * writes will automatically go into the next register.
 *
 * \note This is not a blocking function but makes calls to blocking functions.
 *
 * \param[in] time a pointer to an RTC_TIME struct storing the values to write
 *
 * \return an I2C_RESULT indicating the success or failure of the operation
 */
I2C_RESULT M41T62_WriteTime(RTC_TIME *time) {
    UINT8 i2c_data[10];
    int num_data_bytes;
    I2C_RESULT result = I2C_SUCCESS;
    UINT8 m41t62_reg = M41T62_SSEC;
    int i;

    // Initialize the data buffer
//    i2cData[0] = M41T62_ADDRESS;
//    i2cData[1] = M41T62_SSEC;
    FormatTimeForRTC(time, &i2c_data[0]);
#ifdef VERBOSE
    for (i = 0; i < 8; i++) {
        printf("RTC[%d] : 0x%02x\r\n", i, i2c_data[i]);
    }
#endif
    num_data_bytes = 8;

    result = I2CSendBytes(M41T62_ADDRESS, &m41t62_reg, 1, &i2c_data[0], num_data_bytes, M41T62_I2C_BUS);

    return result;
}

/*!
 * \brief Reads all the time registers on the M41T62 RTC.
 *
 * The M41T62 supports automatic address pointer incrementing, so it is only
 * necessary to specify the first read address and consecutive reads will
 * automatically come from to the next register.
 *
 * \note This is not a blocking function but makes calls to blocking functions.
 *
 * \param[out] time a pointer to an RTC_TIME struct to store the values read
 *
 * \return an I2C_RESULT indicating the success or failure of the operation
 */
I2C_RESULT M41T62_ReadTime(RTC_TIME *time) {
    UINT8 i2c_data[8];
    UINT8 m41t62_reg = M41T62_SSEC;
    I2C_RESULT result = I2C_SUCCESS;
    int i;

    result = I2CGetBytes(M41T62_ADDRESS, &m41t62_reg, 1, M41T62_I2C_BUS, &i2c_data[0], 8);
    if (result != I2C_SUCCESS) {
        return result;
    }

    FormatTimeForHuman(i2c_data, time);

    return result;
}

/*!
 * \brief Formats human-readable time entries to match the format needed by the
 * RTC registers.
 *
 * In order to enforce the limits on time values (e.g. minutes will never be
 * less than 0 or greater than 59), this function checks the time values against
 * their upper and lower limits.  This is also done to prevent time values from
 * overrunning the space they are allowed in the RTC registers.  Just for
 * clarity those limits are:
 *      - Fractional seconds : 0 - 99
 *      - Seconds : 0 - 59
 *      - Minutes : 0 - 59
 *      - Hours : 0 - 23
 *      - Day of the Week : 1 - 7
 *      - Day of the Month : 1 - 31
 *      - Month : 1 - 12
 *      - Year : 0 - 99
 *      - Century : 0 - 3
 *
 * If the time value is outside of the allowed limit, its corresponding buffer
 * value is set to 0x00.
 *
 * \param[in] time a pointer to an rtc_time structure storing human-readable time values
 * \param[out] buffer a pointer to a byte buffer with the RTC formatted time
 */
void FormatTimeForRTC(RTC_TIME *time, UINT8 *buffer) {
    if (time->tenths >= 0 && time->tenths <= 99) {
        buffer[0] = ((time->tenths / 10) << 4 | (time->tenths % 10)) & 0xff;
    } else {
        buffer[0] = 0x00;
    }

    if (time->sec >= 0 && time->sec <= 59) {
        buffer[1] = ((time->sec / 10) << 4 | (time->sec % 10)) & 0x7f;
    } else {
        buffer[1] = 0x00;
    }

    if (time->min >= 0 && time->min <= 59) {
        buffer[2] = ((time->min / 10) << 4 | (time->min % 10)) & 0x7f;
    } else {
        buffer[2] = 0x00;
    }

    if (time->hour >= 0 && time->hour <= 23) {
        buffer[3] = ((time->hour / 10) << 4 | (time->hour % 10)) & 0x3f;
    } else {
        buffer[3] = 0x00;
    }

    if (time->dow >= 1 && time->dow <= 7) {
        buffer[4] = (time->dow) & 0x07;
    } else {
        buffer[4] = 0x00;
    }

    if (time->date >= 1 && time->date <= 31) {
        buffer[5] = ((time->date / 10) << 4 | (time->date % 10)) & 0x3f;
    } else {
        buffer[5] = 0x00;
    }

    if (time->month >= 1 && time->month <= 12) {
        buffer[6] = ((time->month / 10) << 4 | (time->month % 10)) & 0xdf;
    } else {
        buffer[6] = 0x00;
    }

    if ((time->century >= 0 && time->century <= 3)) {
        buffer[6] |= ((time->century) << 6);
    }

    if (time->year >= 0 && time->year <= 99) {
        buffer[7] = ((time->year / 10 ) << 4 | (time->year % 10)) & 0xff;
    } else {
        buffer[7] = 0x00;
    }
}

/*!
 * \brief Formats the RTC time registers' contents into human-readable time
 * components.
 *
 * \param[in] buffer a pointer to a BYTE buffer containing the RTC time registers'
 * contents
 * \param[out] time a pointer to an RTC_TIME struct to store the human-readable time
 * components
 */
void FormatTimeForHuman(UINT8 *buffer, RTC_TIME *time) {
    time->tenths = ((buffer[0] & 0xf0) >> 4) * 10 + (buffer[0] & 0x0f);

    time->sec = ((buffer[1] & 0x70) >> 4) * 10 + (buffer[1] & 0x0f);
    time->min = ((buffer[2] & 0x70) >> 4) * 10 + (buffer[2] & 0x0f);
    time->hour = ((buffer[3] & 0x30) >> 4) * 10 + (buffer[3] & 0x0f);
    time->dow = (buffer[4] & 0x07);
    time->date = ((buffer[5] & 0x30) >> 4) * 10 + (buffer[5] & 0x0f);
    time->century = (buffer[6] & 0xc0) >> 6;
    time->month = ((buffer[6] & 0x10) >> 4) * 10 + (buffer[6] & 0x0f);
    time->year = ((buffer[7] & 0xf0) >> 4) * 10 + (buffer[7] & 0x0f);
}

/*!
 * \brief Prints the time components from an RTC_TIME struct in the normal format
 * of DayofWeek mm/dd/yyyy  hr:min:sec.frac.
 *
 * \param[in] time a pointer to an RTC_TIME struct containing the time components
 * to print
 */
void M41T62_PrintTime(RTC_TIME *time) {
    printf("RTC setting: ");
    switch (time->dow) {
        case 1 :
            printf("Sunday ");
            break;
        case 2 :
            printf("Monday ");
            break;
        case 3 :
            printf("Tuesday ");
            break;
        case 4 :
            printf("Wednesday ");
            break;
        case 5 :
            printf("Thursday ");
            break;
        case 6 :
            printf("Friday ");
            break;
        case 7 :
            printf("Saturday ");
            break;
    }

    printf("%02d/%02d/2%1d%02d  %02d:%02d:%02d.%02d\r\n",
            time->month, time->date, time->century, time->year, time->hour,
            time->min, time->sec, time->tenths);
}

/*!
 * \brief Initializes the M41T62 RTC by setting the Oscillator Fail (0x0F[2])
 * to 0.
 *
 * The OF bit indicates when the oscillator is not generating a proper clock
 * signal, and its reset value is 1 so it must be reset to 0.
 */
void M41T62_Init(void) {
    UINT8 data_buf[10];
    UINT8 m41t62_reg = M41T62_FLAGS;
    int num_data_bytes = 1;
    I2C_RESULT result;

    data_buf[0] = 0x00;

    delay_ms(1000);

    result = I2CSendBytes(M41T62_ADDRESS, &m41t62_reg, 1, &data_buf[0], num_data_bytes, M41T62_I2C_BUS);
    if (result == I2C_SUCCESS) {
        return;
    } else {
        printf("M41T62 RTC initialization failed.\r\n");
        return;
    }
}

/*!
 * \brief Gets the intial values for the time components from UART1 (user entry).
 *
 * \param time a pointer to an RTC_TIME structure to store the time values
 */
void M41T62_EnterTime(RTC_TIME *time) {
    UINT8 tmp[2];
    printf("RTC time entry.  All values must be entered as two digits, so if\r\n");
    printf("a single digit entry is wanted (e.g. 9) enter '0' then the value\r\n");
    printf("(e.g. 09).");
    printf("\r\nEnter century (00-03): ");
    tmp[0] = GetUserInput();
    tmp[1] = GetUserInput();
    time->century = (((int)tmp[0] - 48) * 10) + ((int)tmp[1] - 48);

    printf("\r\nEnter year (00-99): ");
    tmp[0] = GetUserInput();
    tmp[1] = GetUserInput();
    time->year = (((int)tmp[0] - 48) * 10) + ((int)tmp[1] - 48);

    printf("\r\nEnter month (01-12): ");
    tmp[0] = GetUserInput();
    tmp[1] = GetUserInput();
    time->month = (((int)tmp[0] - 48) * 10) + ((int)tmp[1] - 48);

    printf("\r\nEnter date (01-31): ");
    tmp[0] = GetUserInput();
    tmp[1] = GetUserInput();
    time->date = (((int)tmp[0] - 48) * 10) + ((int)tmp[1] - 48);

    printf("\r\nEnter day of the week (01-07)[01=Sunday, etc]: ");
    tmp[0] = GetUserInput();
    tmp[1] = GetUserInput();
    time->dow = (((int)tmp[0] - 48) * 10) + ((int)tmp[1] - 48);

    printf("\r\nEnter hours (00-23): ");
    tmp[0] = GetUserInput();
    tmp[1] = GetUserInput();
    time->hour = (((int)tmp[0] - 48) * 10) + ((int)tmp[1] - 48);

    printf("\r\nEnter minutes (00-59): ");
    tmp[0] = GetUserInput();
    tmp[1] = GetUserInput();
    time->min = (((int)tmp[0] - 48) * 10) + ((int)tmp[1] - 48);

    printf("\r\nEnter seconds (00-59): ");
    tmp[0] = GetUserInput();
    tmp[1] = GetUserInput();
    time->sec = (((int)tmp[0] - 48) * 10) + ((int)tmp[1] - 48);

    printf("\r\nEnter fractional seconds (00-99): ");
    tmp[0] = GetUserInput();
    tmp[1] = GetUserInput();
    time->tenths = (((int)tmp[0] - 48) * 10) + ((int)tmp[1] - 48);

    // Clear the interrupt flag to prevent the entries above from causing an
    // interrupt
	INTClearFlag(INT_SOURCE_UART_RX(UART1));
}

/*!
 * \brief Runs a simple test on the M41T62 real-time clock.
 *
 * This test writes the following time to the device:
 *
 * Saturday 12/31/2099 23:59:59.50
 *
 * After a five second delay, the time is read and compared to:
 *
 * Sunday 01/01/2100 00:00:04.xx
 *
 * If the time read matches, the test is successful, otherwise it fails.  Tenths
 * of a second are not checked since the 5 second delay by the PIC is not exact.
 *
 * \param results_p a pointer to a TEST_RESULTS structure to store the results
 */
BOOL M41T62_Test(void)
{
    I2C_RESULT result;
    BOOL test_result = TRUE;
    RTC_TIME wr_time, rd_time;

    wr_time.century = 0;
    wr_time.date = 31;
    wr_time.dow = 7;
    wr_time.hour = 23;
    wr_time.min = 59;
    wr_time.month = 12;
    wr_time.sec = 59;
    wr_time.tenths = 50;
    wr_time.year = 99;

    if (test_result) {
        result = M41T62_WriteTime(&wr_time);
        if (result != I2C_SUCCESS) {
            printf("M41T62 Real-Time Clock FAILED: M41T62_Test(): Writing time unsuccessful - I2C Rsp: %d\r\n", result);
            test_result = FALSE;
        }
    }

    delay_ms(5000);

    if (test_result) {
        result = M41T62_ReadTime(&rd_time);
        if (result != I2C_SUCCESS) {
            printf("M41T62 Real-Time Clock FAILED: M41T62_Test(): Reading time unsuccessful - I2C Rsp: %d\r\n", result);
            test_result = FALSE;
        }
    }

    if (test_result) {
        if (rd_time.century != 1) {
            printf("M41T62 Real-Time Clock FAILED: M41T62_Test(): Century did not increment correctly. Expected value: 1  Actual value: %d\r\n", rd_time.century);
            test_result = FALSE;
        }
    }

    if (test_result) {
        if (rd_time.date != 1) {
            printf("M41T62 Real-Time Clock FAILED: M41T62_Test(): Date did not increment correctly. Expected value: 1  Actual value: %d\r\n", rd_time.date);
            test_result = FALSE;
        }
    }

    if (test_result) {
        if (rd_time.dow != 1) {
            printf("M41T62 Real-Time Clock FAILED: M41T62_Test(): Day did not increment correctly. Expected value: 1  Actual value: %d\r\n", rd_time.dow);
            test_result = FALSE;
        }
    }

    if (test_result) {
        if (rd_time.hour != 0) {
            printf("M41T62 Real-Time Clock FAILED: M41T62_Test(): Hours did not increment correctly. Expected value: 0  Actual value: %d\r\n", rd_time.hour);
            test_result = FALSE;
        }
    }

    if (test_result) {
        if (rd_time.min != 0) {
            printf("M41T62 Real-Time Clock FAILED: M41T62_Test(): Minutes did not increment correctly. Expected value: 0  Actual value: %d\r\n", rd_time.min);
            test_result = FALSE;
        }
    }

    if (test_result) {
        if (rd_time.month != 1) {
            printf("M41T62 Real-Time Clock FAILED: M41T62_Test(): Month did not increment correctly. Expected value: 1  Actual value: %d\r\n", rd_time.month);
            test_result = FALSE;
        }
    }

    if (test_result) {
        if (rd_time.sec <= 3 || rd_time.sec >= 5) {
            printf("M41T62 Real-Time Clock FAILED: M41T62_Test(): Seconds did not increment correctly. Expected value: 1  Actual value: %d\r\n", rd_time.sec);
            test_result = FALSE;
        }
    }

    if (test_result) {
        if (rd_time.year != 0) {
            printf("M41T62 Real-Time Clock FAILED: M41T62_Test(): Year did not increment correctly. Expected value: 0  Actual value: %d\r\n", rd_time.year);
            test_result = FALSE;
        }
    }

    return test_result;
}
