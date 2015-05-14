/*******************************************************************************
 *
 * NetFPGA-1G-CML http://www.netfpga.org
 *
 * Project:
 *       nf1_cml_io_example
 *
 * Author:
 *       Jay Hirata
 *
 * Copyright notice:
 *       Copyright (C) 2014 Computer Measurement Laboratory
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

#include <stdio.h>
#include <string.h>
#include "ff.h"
#include "device.h"

#include <unistd.h>
#include <fcntl.h>

const char TEST_WR_MESSAGE[] = "This file has been written by the NetFPGA-1G-CML.\r\n";

FATFS Fatfs;		/* File system object */
FIL Fil;			/* File object */
BYTE Buff[128];		/* File read buffer */

FRESULT fs_ls(const char *path);
FRESULT fs_write_test(const char *path);
FRESULT fs_cat(const char *path);
void sdcard_example_help(void);


/*
 * This function makes it easier to get a text string.
 * It assumes that setvbuf has been called on stdin to use unbuffered input.
 */
char *get_str(char *buf, int size)
{
    char c;
    int i;

    i = 0;
    do {
        buf[i] = 0;
        c = getchar();
        if ((c >= 0x20 && c <= 0x7e) || (c == 0x08)) {
            printf("%c", c);
            if (c == 0x08) {
                printf(" %c", c);
                i--;
            } else {
                buf[i] = c;
                i++;
            }
            fflush(stdout);
        }
        if (c == '\r' || c == '\n')
            break;

    } while (i < (size - 1));
    buf[i] = 0;
    printf("\n");
    return buf;
}


/*-----------------------------------------------------------------------*/
/* Program Main                                                          */
/*-----------------------------------------------------------------------*/

int sdcard_test(void)
{
    unsigned int status;
    unsigned int laststatus;
    static char buf[256];

    laststatus = 0;
    status = *gpio_io;
    do {
        if (status != laststatus) {
            printf("Card Present: ");

            if (status & SD_CD) {
                printf("NO\n");
                printf("Please insert SD card and try again.\n");
                return 0;
            } else {
                printf("YES\n");

                printf("Write protected: ");
                if (status & SD_WP)
                    printf("YES\n");
                else
                    printf("NO\n");
            }
        }
        udelay(1000);
        laststatus = status;
        status = *gpio_io;
    } while (laststatus & (SD_CD | SD_WP));

    printf("Card OK: Continuing\n");



	f_mount(0, &Fatfs);		/* Register volume work area (never fails) */

    sdcard_example_help();

    while (1) {
        printf("Enter a command:\n");
        get_str(buf, sizeof(buf));

        if (strncmp(buf, "ls", sizeof(buf)) == 0) {
            printf("Listing directory contents:\n");
            fs_ls("");

        } else if (strncmp(buf, "cat", sizeof(buf)) == 0) {
            printf("Enter a file name: ");
            get_str(buf, sizeof(buf));
            printf("Printing contents of: '%s'\n", buf);
            fs_cat(buf);

        } else if (strncmp(buf, "write", sizeof(buf)) == 0) {
            printf("Enter a file name: ");
            get_str(buf, sizeof(buf));
            printf("Writing to file: '%s'\n", buf);
            fs_write_test(buf);

        } else if (strncmp(buf, "quit", sizeof(buf)) == 0) {
            break;

        } else if (strncmp(buf, "help", sizeof(buf)) == 0) {
            sdcard_example_help();

        } else {
            if (strlen(buf) != 0) {
                printf("Unknown command: '%s'\n", buf);
                sdcard_example_help();
            }
        }
    }


    return 0;
}

void sdcard_example_help(void)
{
    printf("SD Card Example\n");
    printf("---------------\n");
    printf("Here are your options:\n");
    printf(" 'ls'       -> list directory contents\n");
    printf(" 'cat'      -> show file contents\n");
    printf(" 'write'    -> write example text to file\n");
    printf(" 'help'     -> help\n");
    printf(" 'quit'     -> quit\n");
    printf("\n");
}


FRESULT fs_cat(const char *path)
{
    FRESULT rc;
    FIL fil;
    UINT br;
    int i;
    static char buf[256];

	printf("Displaying contents of file: %s\n", path);
	rc = f_open(&fil, path, FA_READ);
    if (rc != FR_OK) {
        printf("Could not open file: %s\n", path);
        return rc;
    }

    while (((rc = f_read(&fil, buf, sizeof(buf), &br)) == FR_OK) && (br != 0)) {
		for (i = 0; i < br; i++)		/* Type the data */
			putchar(buf[i]);
	}
	f_close(&fil);
    return rc;
}

FRESULT fs_write_test(const char *path)
{
    FRESULT rc;
    FIL fil;
    UINT bw;

    printf("Opening: %s\n", path);
    rc = f_open(&fil, path, FA_WRITE | FA_CREATE_ALWAYS);
    if (rc != FR_OK)
        return rc;

    printf("Writing this message: '%s'\n", TEST_WR_MESSAGE);
	rc = f_write(&fil, TEST_WR_MESSAGE, sizeof(TEST_WR_MESSAGE), &bw);
    if (rc != FR_OK)
        printf("Error while writing file\n");

    printf("%u bytes written\n", bw);
    f_close(&fil);
    return rc;
}


FRESULT fs_ls(const char *path)
{
	DIR dir;
    FRESULT rc;
	FILINFO fno;
    static char lfn[_MAX_LFN + 1];
    fno.lfname = lfn;
    fno.lfsize = sizeof(lfn);

    rc = f_opendir(&dir, path);
    if (rc)
        return rc;

    while (((rc = f_readdir(&dir, &fno)) == FR_OK) && (fno.fname[0] != 0)) {
        if (fno.fattrib & AM_DIR)
            printf(" <DIR> %s -> %s\n", fno.fname, fno.lfname);
        else
            printf("       %s -> %s\n", fno.fname, fno.lfname);
    }
    return rc;
}


/*---------------------------------------------------------*/
/* User Provided Timer Function for FatFs module           */
/*---------------------------------------------------------*/

DWORD get_fattime (void)
{
	return	  ((DWORD)(2012 - 1980) << 25)	/* Year = 2012 */
			| ((DWORD)1 << 21)				/* Month = 1 */
			| ((DWORD)1 << 16)				/* Day_m = 1*/
			| ((DWORD)0 << 11)				/* Hour = 0 */
			| ((DWORD)0 << 5)				/* Min = 0 */
			| ((DWORD)0 >> 1);				/* Sec = 0 */
}
