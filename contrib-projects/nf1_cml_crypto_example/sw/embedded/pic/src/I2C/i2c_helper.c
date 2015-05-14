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
 * \file i2c_helper.c
 *
 * \brief Contains helper functions for I<sup>2</sup>C transmission and
 * receive using the I<sup>2</sup>C functions provided with Microchip's XC32
 * compiler.
 *
 * \author Computer Measurement Laboratory
 */

#include "I2C/i2c_helper.h"
#include "HardwareProfile.h"

/*!
 * \brief Sends a start or repeated start condition on the selected I2C bus.
 *
 * \note This is a blocking function and waits until the I2C_STATUS returned from the
 * start condition is I2C_START.
 *
 * \param[in] restart TRUE if the start condition should be a repeat start,
 * FALSE if not
 * \param[in] bus the I2C_MODULE to use (i.e. I<sup>2</sup>C bus)
 *
 * \return an I2C_RESULT indicating the success or failure of the operation
 */
I2C_RESULT I2CStartTransfer(BOOL restart, I2C_MODULE bus)
{
    I2C_RESULT result = I2C_SUCCESS;
    I2C_STATUS status;

    // Send the Start (or Restart) signal
    if(restart)
    {
        result = I2CRepeatStart(bus);
        if (result != I2C_SUCCESS) {
            return result;
        }
    } else {
        // Wait for the bus to be idle, then start the transfer
        while( !I2CBusIsIdle(bus) );

        if((result = I2CStart(bus)) != I2C_SUCCESS)
        {
            return result;
        }
    }

    // Wait for the signal to complete
    do
    {
        status = I2CGetStatus(bus);

    } while ( !(status & I2C_START) );

    return result;
}

/*!
 * \brief Sends a stop condition on the selected I2C bus.
 *
 * \note This is a blocking function and waits until the I2C_STATUS returned
 * from the stop condition is I2C_STOP.
 *
 * \param[in] bus the I2C_MODULE to use (i.e. I<sup>2</sup>C bus)
 */
void I2CStopTransfer(I2C_MODULE bus)
{
    I2C_STATUS status;

    // Send the Stop signal
    I2CStop(bus);
    // Wait for the signal to complete
    do
    {
        status = I2CGetStatus(bus);

    } while ( !(status & I2C_STOP) );
}

/*!
 * \brief Sends one byte over the specified I<sup>2</sup>C bus.
 *
 * \note This is a blocking function that will wait until the transmission has
 * completed.
 *
 * \param[in] data the byte to send
 * \param[in] bus the I2C_MODULE to use (i.e. I<sup>2</sup>C bus)
 *
 * \return an I2C_RESULT indicating the success or failure of the operation
 */
I2C_RESULT I2CSendOneByte(UINT8 data, I2C_MODULE bus)
{
    I2C_RESULT result = I2C_SUCCESS;
    // Wait for the transmitter to be ready
    while(!I2CTransmitterIsReady(bus));

    // Transmit the byte
    if((result = I2CSendByte(bus, data)) != I2C_SUCCESS)
    {
        return result;
    }

    // Wait for the transmission to finish
    while(!I2CTransmissionHasCompleted(bus));

    return result;
}

/*!
 * \brief Gets one byte over the specified I<sup>2</sup>C bus.
 *
 * \note This is a blocking function and will wait until recieved data is
 * available on the I<sup>2</sup>C bus, or until acknowledgement of the byte
 * received has completed.
 *
 * \param[in] ack tells whether to acknowledge (TRUE) or not acknowledge (FALSE)
 * the byte received
 * \param[in] bus the I2C_MODULE to use (i.e. I<sup>2</sup>C bus)
 * \param[out] byte a pointer to where to store the byte received
 *
 * \return an I2C_RESULT indicating the success or failure of the operation
 */
I2C_RESULT I2CGetOneByte(BOOL ack, I2C_MODULE bus, UINT8 *byte)
{
    I2C_RESULT result;
    if((result = I2CReceiverEnable(bus, TRUE)) != I2C_SUCCESS) {
        return result;
    } else {
        while(!I2CReceivedDataIsAvailable(bus));
        byte[0] = I2CGetByte(bus);
        if (ack) {
            I2CAcknowledgeByte(bus, TRUE);
            while (!I2CAcknowledgeHasCompleted(bus));
        } else {
            I2CAcknowledgeByte(bus, FALSE);
            while (!I2CAcknowledgeHasCompleted(bus));
        }
    }

    return result;
}

/*!
 * \brief Transmits multiple bytes over I<sup>2</sup>C.
 *
 * The bytes in a buffer are transmitted individually using I2CSendOneByte(),
 * and an acknowledge from the slave is checked after each send.  After all
 * bytes are sent, the master waits for the slave to complete the write by
 * sending the slave address over the I<sup>2</sup>C bus and checking for an
 * acknowledgement.
 *
 * \note This is a blocking function and will wait until the slave acknowledges
 * the polling after the buffer has been sent.
 *
 * \param[in] slave_addr the address of the slave
 * \param[in] reg_addr_buf a pointer to the register address to write to
 * \param[in] num_reg_addr_bytes the number of bytes in the register address
 * \param[in] data_buf a pointer to the data to write to the device
 * \param[in] num_data_bytes the number of bytes in the data buffer
 * \param[in] bus the I2C_MODULE to use (i.e. I<sup>2</sup>C bus)
 *
 * \return an I2C_RESULT indicating the success or failure of the operation
 */
I2C_RESULT I2CSendBytes(UINT8 slave_addr, UINT8 *reg_addr_buf, int num_reg_addr_bytes,
                    UINT8 *data_buf, int num_data_bytes, I2C_MODULE bus)
{
    int i;
    I2C_RESULT result = I2C_SUCCESS;
    BOOL ack;

    slave_addr |= I2C_WRITE;
    // Start the transfer to write data to the EEPROM
    if((result = I2CStartTransfer(FALSE, bus)) != I2C_SUCCESS)
    {
        return result;
    }

    if ((result = I2CSendOneByte(slave_addr, bus)) != I2C_SUCCESS) {
        return result;
    }

    ack = I2CByteWasAcknowledged(bus);

    if (!ack) {
        DEBUG_PRINT(("Error: Address byte was not acknowledged\r\n"));
        I2CStopTransfer(bus);
        result = I2C_ERROR;
        return result;
    }

    if (reg_addr_buf != NULL) {
        for (i = 0; i < num_reg_addr_bytes; i++) {
            if ( (result = I2CSendOneByte(reg_addr_buf[i], bus)) != I2C_SUCCESS) {
                return result;
            } else {
                if (!I2CByteWasAcknowledged(bus)) {
                    DEBUG_PRINT(("Error: Sent byte was not acknowledged\r\n"));
                    I2CStopTransfer(bus);
                    result = I2C_ERROR;
                    return result;
                }
            }
        }
    }

    if (data_buf != NULL) {
        // Transmit all data
        for (i = 0; i < num_data_bytes; i++) {
            if ( (result = I2CSendOneByte(data_buf[i], bus)) != I2C_SUCCESS) {
                return result;
            } else {
                if (!I2CByteWasAcknowledged(bus)) {
                    DEBUG_PRINT(("Error: Sent byte was not acknowledged\r\n"));
                    I2CStopTransfer(bus);
                    result = I2C_ERROR;
                    return result;
                }
            }
        }
    }

    // End the transfer (hang here if an error occured)
    I2CStopTransfer(bus);

    // poll the device until it responds indicating the write is complete
    while (!I2CPoll(slave_addr, bus));

    return result;
}

/*!
 * \brief Gets multiple bytes from an I2C slave.
 *
 * This function supports two different types of I2C address formatting:
 *  -# The device does not have a register map and only the slave address needs
 * to be sent for a read (e.g. AD5274).
 *  -# The device has a register map, and the slave address and register address
 * need to be sent to read from the device (e.g. M41T62).
 *
 * \note This is not a blocking function but makes calls to blocking functions.
 *
 * \param[in] slave_addr the I2C slave address of the device
 * \param[in] reg_addr_buf a pointer to a buffer storing optional register addresses
 * \param[in] num_address_bytes the number of bytes in reg_adder_buf
 * \param[in] bus the I2C_MODULE to use (e.g. I<sup>2</sup>C)
 * \param[out] data_buf a pointer to a buffer to store the bytes read
 * \param[in] num_data_bytes the number of data bytes to read
 *
 * \return an I2C_RESULT indicating the success or failure of the operation
 */
I2C_RESULT I2CGetBytes(UINT8 slave_addr, UINT8 *reg_addr_buf,
            int num_reg_addr_bytes, I2C_MODULE bus, UINT8 *data_buf, int num_data_bytes)
{
    I2C_RESULT result = I2C_SUCCESS;
    UINT8 tmp_slv_addr = slave_addr;
    int i;

    if ( (result = I2CStartTransfer(FALSE, bus)) != I2C_SUCCESS) {
        return result;
    }

    if (reg_addr_buf != NULL) {
        tmp_slv_addr |= I2C_WRITE;
        if ( (result = I2CSendOneByte(tmp_slv_addr, bus)) != I2C_SUCCESS) {
            return result;
        }

        if (reg_addr_buf != NULL) {
            for (i = 0; i < num_reg_addr_bytes; i++) {
                if ( (result = I2CSendOneByte(reg_addr_buf[i], bus)) != I2C_SUCCESS) {
                    return result;
                } else {
                    if (!I2CByteWasAcknowledged(bus)) {
                        DEBUG_PRINT(("Error: Address byte was not acknowledged\r\n"));
                        I2CStopTransfer(bus);
                        result = I2C_ERROR;
                        return result;
                    }
                }
            }
        }
    }

    tmp_slv_addr = slave_addr;
    tmp_slv_addr |= I2C_READ;

    if (reg_addr_buf != NULL) {
        // Send a Repeated Started condition
        if ( (result = I2CStartTransfer(TRUE, bus)) != I2C_SUCCESS) {
            return result;
        }
    }

    // Transmit the address with the READ bit set
    if ( (result = I2CSendOneByte(tmp_slv_addr, bus)) != I2C_SUCCESS) {
        return result;
    } else {
        // Verify that the byte was acknowledged
        if (!I2CByteWasAcknowledged(bus)) {
            DEBUG_PRINT(("Error: Address + read byte was not acknowledged\r\n"));
            I2CStopTransfer(bus);
            result = I2C_ERROR;
            return result;
        }
    }

    // Read the data from the desired address
    for (i = 0; i < num_data_bytes; i++) {
        if (i == (num_data_bytes - 1)) {
            if ( (result = I2CGetOneByte(FALSE, bus, &data_buf[i])) != I2C_SUCCESS) {
                DEBUG_PRINT(("I2CGetOneByte with nack failed\r\n"));
                I2CStopTransfer(bus);
                return result;
            }
        } else {
            if ( (result = I2CGetOneByte(TRUE, bus, &data_buf[i])) != I2C_SUCCESS) {
                DEBUG_PRINT(("I2CGetOneByte with ack failed\r\n"));
                I2CStopTransfer(bus);
                return result;
            }
        }
    }

    // End the transfer (stop here if an error occured)
    I2CStopTransfer(bus);

    // poll the device until it responds, indicating the read is complete
    while (!I2CPoll(slave_addr, bus));

    return result;
}

/*!
 * \brief Polls an I2C device to see if it responds, indicating its previous
 * operation is complete.
 *
 * \param slave_addr the I2C slave address of the device to poll
 * \param bus the I2C_MODULE the slave device is on (i.e. I<sup>2</sup>C bus)
 *
 * \return TRUE if the device acknowledges, FALSE if not
 */
BOOL I2CPoll(UINT8 slave_addr, I2C_MODULE bus)
{
    I2C_RESULT result;
    UINT8 tmp_slv_addr = slave_addr;

    if ( (result = I2CStartTransfer(FALSE, bus)) != I2C_SUCCESS) {
        return FALSE;
    }

    tmp_slv_addr |= I2C_WRITE;
    if ( (result = I2CSendOneByte(tmp_slv_addr, bus)) != I2C_SUCCESS) {
        return FALSE;
    }

    if (I2CByteWasAcknowledged(bus)) {
        I2CStopTransfer(bus);
        return TRUE;
    } else {
        I2CStopTransfer(bus);
        return FALSE;
    }
}
