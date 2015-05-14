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
#include <stdlib.h>
#include <inttypes.h>
#include "platform.h"
#include "ff.h"
#include "device.h"

#define PMOD_LED_WAIT_TIME                  10000

int sdcard_test(void);

struct gpio {
    uint32_t data;
    uint32_t tri;
};

uint32_t gpio_read(struct gpio *gpio)
{
    gpio->tri = 0xffffffff;
    return gpio->data;
}

void gpio_write(struct gpio *gpio, uint32_t data)
{
    gpio->tri = 0x0;
    gpio->data = data;
}


struct uart {
    uint32_t rx;
    uint32_t tx;
    uint32_t status;
    uint32_t ctrl;
};

#define UART_RX_VALID                       0x00000001

int uart_has_data(struct uart *uart)
{
    if (uart->status & UART_RX_VALID)
        return 1;
    else
        return 0;
}

int uart_read(struct uart *uart)
{
    return uart->rx;
}

int uart_write(struct uart *uart, char c)
{
    uart->tx = c;
    return 0;
}

void update_pmod_leds(void)
{
    struct gpio *pmod_leds = (void *)0x40020000;
    static uint8_t led_pattern[] = {1, 2, 4, 8, 16, 32, 64, 128, 64, 32, 16, 8, 4, 2};
    static int i = 0;

    gpio_write(pmod_leds, led_pattern[i]);
    i++;
    i = i % sizeof(led_pattern);
}

void respond_to_buttons(void)
{
    struct gpio *onboard_buttons = (void *)0x40000000;
    struct gpio *onboard_leds = (void *)0x40080000;
    int data;

    data = gpio_read(onboard_buttons);
    gpio_write(onboard_leds, data);
}


void print_led_message(void)
{
    printf("LED and button example\n");
    printf("----------------------\n");
    printf("The LEDs on the Pmod8LD should be flashing.\n\n");
    printf("Push the onboard buttons to illuminate the onboard LEDs\n\n");
    printf("Press any key to enter SD card example\n\n");
}


int main(void)
{
    uint32_t count;
    struct uart *uart = (void*)0x40600000;

    setvbuf(stdin, NULL, _IONBF, 0);

    init_platform();

    printf("NetFPGA-1G-CML IO Example\n");
    printf("=========================\n\n");
    printf("This program demonstrates DDR3, onboard LEDs, onboard buttons,\n"
            "an external Pmod8LD, and SD Card access.\n\n");




    print_led_message();
    count = 0;
    while (1) {

        if (uart_has_data(uart)) {
            while (uart_has_data(uart))
                uart_read(uart);
            sdcard_test();
            print_led_message();
        }
        if ((count % PMOD_LED_WAIT_TIME) == 0)
            update_pmod_leds();

        respond_to_buttons();

        count++;
    }

    cleanup_platform();
    return 0;
}

