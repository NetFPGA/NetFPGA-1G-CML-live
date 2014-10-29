#!/usr/bin/python

# ******************************************************************
# 
# CAUTION: This file is automatically generated by libgen.
# Version: Xilinx EDK 14.6 EDK_P.68d
# DO NOT EDIT.
# 
# Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.

# 
# Description: Driver parameters
# 
# *****************************************************************/

def STDIN_BASEADDRESS():
    return 0x40600000
def STDOUT_BASEADDRESS():
    return 0x40600000

# *****************************************************************/

#  Definitions for driver UARTLITE */
def XPAR_XUARTLITE_NUM_INSTANCES():
    return 2

#  Definitions for peripheral DEBUG_MODULE */
def XPAR_DEBUG_MODULE_BASEADDR():
    return 0x41400000
def XPAR_DEBUG_MODULE_HIGHADDR():
    return 0x4140FFFF
def XPAR_DEBUG_MODULE_DEVICE_ID():
    return 0
def XPAR_DEBUG_MODULE_BAUDRATE():
    return 0
def XPAR_DEBUG_MODULE_USE_PARITY():
    return 0
def XPAR_DEBUG_MODULE_ODD_PARITY():
    return 0
def XPAR_DEBUG_MODULE_DATA_BITS():
    return 0


#  Definitions for peripheral RS232_UART_1 */
def XPAR_RS232_UART_1_BASEADDR():
    return 0x40600000
def XPAR_RS232_UART_1_HIGHADDR():
    return 0x4060FFFF
def XPAR_RS232_UART_1_DEVICE_ID():
    return 1
def XPAR_RS232_UART_1_BAUDRATE():
    return 115200
def XPAR_RS232_UART_1_USE_PARITY():
    return 0
def XPAR_RS232_UART_1_ODD_PARITY():
    return 1
def XPAR_RS232_UART_1_DATA_BITS():
    return 8


# *****************************************************************/

#  Canonical definitions for peripheral DEBUG_MODULE */
def XPAR_UARTLITE_0_DEVICE_ID():
    return XPAR_DEBUG_MODULE_DEVICE_ID
def XPAR_UARTLITE_0_BASEADDR():
    return 0x41400000
def XPAR_UARTLITE_0_HIGHADDR():
    return 0x4140FFFF
def XPAR_UARTLITE_0_BAUDRATE():
    return 0
def XPAR_UARTLITE_0_USE_PARITY():
    return 0
def XPAR_UARTLITE_0_ODD_PARITY():
    return 0
def XPAR_UARTLITE_0_DATA_BITS():
    return 0
def XPAR_UARTLITE_0_SIO_CHAN():
    return -1

#  Canonical definitions for peripheral RS232_UART_1 */
def XPAR_UARTLITE_1_DEVICE_ID():
    return XPAR_RS232_UART_1_DEVICE_ID
def XPAR_UARTLITE_1_BASEADDR():
    return 0x40600000
def XPAR_UARTLITE_1_HIGHADDR():
    return 0x4060FFFF
def XPAR_UARTLITE_1_BAUDRATE():
    return 115200
def XPAR_UARTLITE_1_USE_PARITY():
    return 0
def XPAR_UARTLITE_1_ODD_PARITY():
    return 1
def XPAR_UARTLITE_1_DATA_BITS():
    return 8
def XPAR_UARTLITE_1_SIO_CHAN():
    return 0


# *****************************************************************/

#  Definitions for driver WDTTB */
def XPAR_XWDTTB_NUM_INSTANCES():
    return 1

#  Definitions for peripheral AXI_TIMEBASE_WDT_0 */
def XPAR_AXI_TIMEBASE_WDT_0_DEVICE_ID():
    return 0
def XPAR_AXI_TIMEBASE_WDT_0_BASEADDR():
    return 0x41A00000
def XPAR_AXI_TIMEBASE_WDT_0_HIGHADDR():
    return 0x41A0FFFF


# *****************************************************************/

#  Canonical definitions for peripheral AXI_TIMEBASE_WDT_0 */
def XPAR_WDTTB_0_DEVICE_ID():
    return XPAR_AXI_TIMEBASE_WDT_0_DEVICE_ID
def XPAR_WDTTB_0_BASEADDR():
    return 0x41A00000
def XPAR_WDTTB_0_HIGHADDR():
    return 0x41A0FFFF


# *****************************************************************/


#  Definitions for peripheral DMA_0 */
def XPAR_DMA_0_BASEADDR():
    return 0x7A800000
def XPAR_DMA_0_HIGHADDR():
    return 0x7A80FFFF


#  Definitions for peripheral MDIO_CTRL_0 */
def XPAR_MDIO_CTRL_0_BASEADDR():
    return 0x7A400000
def XPAR_MDIO_CTRL_0_HIGHADDR():
    return 0x7A40FFFF


#  Definitions for peripheral NF1_CML_INTERFACE_0 */
def XPAR_NF1_CML_INTERFACE_0_BASEADDR():
    return 0x78260000
def XPAR_NF1_CML_INTERFACE_0_HIGHADDR():
    return 0x7826FFFF


#  Definitions for peripheral NF1_CML_INTERFACE_1 */
def XPAR_NF1_CML_INTERFACE_1_BASEADDR():
    return 0x78240000
def XPAR_NF1_CML_INTERFACE_1_HIGHADDR():
    return 0x7824FFFF


#  Definitions for peripheral NF1_CML_INTERFACE_2 */
def XPAR_NF1_CML_INTERFACE_2_BASEADDR():
    return 0x78220000
def XPAR_NF1_CML_INTERFACE_2_HIGHADDR():
    return 0x7822FFFF


#  Definitions for peripheral NF1_CML_INTERFACE_3 */
def XPAR_NF1_CML_INTERFACE_3_BASEADDR():
    return 0x78200000
def XPAR_NF1_CML_INTERFACE_3_HIGHADDR():
    return 0x7820FFFF


#  Definitions for peripheral VERSION_ID_0 */
def XPAR_VERSION_ID_0_BASEADDR():
    return 0x78218000
def XPAR_VERSION_ID_0_HIGHADDR():
    return 0x78218FFF


# *****************************************************************/

#  Definitions for driver BRAM */
def XPAR_XBRAM_NUM_INSTANCES():
    return 2

#  Definitions for peripheral MICROBLAZE_0_D_BRAM_CTRL */
def XPAR_MICROBLAZE_0_D_BRAM_CTRL_DEVICE_ID():
    return 0
def XPAR_MICROBLAZE_0_D_BRAM_CTRL_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_0_D_BRAM_CTRL_ECC():
    return 0
def XPAR_MICROBLAZE_0_D_BRAM_CTRL_FAULT_INJECT():
    return 0
def XPAR_MICROBLAZE_0_D_BRAM_CTRL_CE_FAILING_REGISTERS():
    return 0
def XPAR_MICROBLAZE_0_D_BRAM_CTRL_UE_FAILING_REGISTERS():
    return 0
def XPAR_MICROBLAZE_0_D_BRAM_CTRL_ECC_STATUS_REGISTERS():
    return 0
def XPAR_MICROBLAZE_0_D_BRAM_CTRL_CE_COUNTER_WIDTH():
    return 0
def XPAR_MICROBLAZE_0_D_BRAM_CTRL_ECC_ONOFF_REGISTER():
    return 0
def XPAR_MICROBLAZE_0_D_BRAM_CTRL_ECC_ONOFF_RESET_VALUE():
    return 1
def XPAR_MICROBLAZE_0_D_BRAM_CTRL_WRITE_ACCESS():
    return 2
def XPAR_MICROBLAZE_0_D_BRAM_CTRL_BASEADDR():
    return 0x00000000
def XPAR_MICROBLAZE_0_D_BRAM_CTRL_HIGHADDR():
    return 0x00003FFF
def XPAR_MICROBLAZE_0_D_BRAM_CTRL_S_AXI_CTRL_BASEADDR():
    return 0xFFFFFFFF 
def XPAR_MICROBLAZE_0_D_BRAM_CTRL_S_AXI_CTRL_HIGHADDR():
    return 0xFFFFFFFF 


#  Definitions for peripheral MICROBLAZE_0_I_BRAM_CTRL */
def XPAR_MICROBLAZE_0_I_BRAM_CTRL_DEVICE_ID():
    return 1
def XPAR_MICROBLAZE_0_I_BRAM_CTRL_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_0_I_BRAM_CTRL_ECC():
    return 0
def XPAR_MICROBLAZE_0_I_BRAM_CTRL_FAULT_INJECT():
    return 0
def XPAR_MICROBLAZE_0_I_BRAM_CTRL_CE_FAILING_REGISTERS():
    return 0
def XPAR_MICROBLAZE_0_I_BRAM_CTRL_UE_FAILING_REGISTERS():
    return 0
def XPAR_MICROBLAZE_0_I_BRAM_CTRL_ECC_STATUS_REGISTERS():
    return 0
def XPAR_MICROBLAZE_0_I_BRAM_CTRL_CE_COUNTER_WIDTH():
    return 0
def XPAR_MICROBLAZE_0_I_BRAM_CTRL_ECC_ONOFF_REGISTER():
    return 0
def XPAR_MICROBLAZE_0_I_BRAM_CTRL_ECC_ONOFF_RESET_VALUE():
    return 1
def XPAR_MICROBLAZE_0_I_BRAM_CTRL_WRITE_ACCESS():
    return 2
def XPAR_MICROBLAZE_0_I_BRAM_CTRL_BASEADDR():
    return 0x00000000
def XPAR_MICROBLAZE_0_I_BRAM_CTRL_HIGHADDR():
    return 0x00003FFF
def XPAR_MICROBLAZE_0_I_BRAM_CTRL_S_AXI_CTRL_BASEADDR():
    return 0xFFFFFFFF 
def XPAR_MICROBLAZE_0_I_BRAM_CTRL_S_AXI_CTRL_HIGHADDR():
    return 0xFFFFFFFF 


# *****************************************************************/

#  Canonical definitions for peripheral MICROBLAZE_0_D_BRAM_CTRL */
def XPAR_BRAM_0_DEVICE_ID():
    return XPAR_MICROBLAZE_0_D_BRAM_CTRL_DEVICE_ID
def XPAR_BRAM_0_DATA_WIDTH():
    return 32
def XPAR_BRAM_0_ECC():
    return 0
def XPAR_BRAM_0_FAULT_INJECT():
    return 0
def XPAR_BRAM_0_CE_FAILING_REGISTERS():
    return 0
def XPAR_BRAM_0_UE_FAILING_REGISTERS():
    return 0
def XPAR_BRAM_0_ECC_STATUS_REGISTERS():
    return 0
def XPAR_BRAM_0_CE_COUNTER_WIDTH():
    return 0
def XPAR_BRAM_0_ECC_ONOFF_REGISTER():
    return 0
def XPAR_BRAM_0_ECC_ONOFF_RESET_VALUE():
    return 1
def XPAR_BRAM_0_WRITE_ACCESS():
    return 2
def XPAR_BRAM_0_BASEADDR():
    return 0x00000000
def XPAR_BRAM_0_HIGHADDR():
    return 0x00003FFF

#  Canonical definitions for peripheral MICROBLAZE_0_I_BRAM_CTRL */
def XPAR_BRAM_1_DEVICE_ID():
    return XPAR_MICROBLAZE_0_I_BRAM_CTRL_DEVICE_ID
def XPAR_BRAM_1_DATA_WIDTH():
    return 32
def XPAR_BRAM_1_ECC():
    return 0
def XPAR_BRAM_1_FAULT_INJECT():
    return 0
def XPAR_BRAM_1_CE_FAILING_REGISTERS():
    return 0
def XPAR_BRAM_1_UE_FAILING_REGISTERS():
    return 0
def XPAR_BRAM_1_ECC_STATUS_REGISTERS():
    return 0
def XPAR_BRAM_1_CE_COUNTER_WIDTH():
    return 0
def XPAR_BRAM_1_ECC_ONOFF_REGISTER():
    return 0
def XPAR_BRAM_1_ECC_ONOFF_RESET_VALUE():
    return 1
def XPAR_BRAM_1_WRITE_ACCESS():
    return 2
def XPAR_BRAM_1_BASEADDR():
    return 0x00000000
def XPAR_BRAM_1_HIGHADDR():
    return 0x00003FFF


# *****************************************************************/

def XPAR_INTC_MAX_NUM_INTR_INPUTS():
    return 3
def XPAR_XINTC_HAS_IPR():
    return 1
def XPAR_XINTC_HAS_SIE():
    return 1
def XPAR_XINTC_HAS_CIE():
    return 1
def XPAR_XINTC_HAS_IVR():
    return 1
def XPAR_XINTC_USE_DCR():
    return 0
#  Definitions for driver INTC */
def XPAR_XINTC_NUM_INSTANCES():
    return 1

#  Definitions for peripheral MICROBLAZE_0_INTC */
def XPAR_MICROBLAZE_0_INTC_DEVICE_ID():
    return 0
def XPAR_MICROBLAZE_0_INTC_BASEADDR():
    return 0x41200000
def XPAR_MICROBLAZE_0_INTC_HIGHADDR():
    return 0x4120FFFF
def XPAR_MICROBLAZE_0_INTC_KIND_OF_INTR():
    return 0xFFFFFFFD
def XPAR_MICROBLAZE_0_INTC_HAS_FAST():
    return 0
def XPAR_MICROBLAZE_0_INTC_IVAR_RESET_VALUE():
    return 0x00000010
def XPAR_MICROBLAZE_0_INTC_NUM_INTR_INPUTS():
    return 3


# *****************************************************************/

def XPAR_INTC_SINGLE_BASEADDR():
    return 0x41200000
def XPAR_INTC_SINGLE_HIGHADDR():
    return 0x4120FFFF
def XPAR_INTC_SINGLE_DEVICE_ID():
    return XPAR_MICROBLAZE_0_INTC_DEVICE_ID
def XPAR_MICROBLAZE_0_INTC_TYPE():
    return 0
def XPAR_RS232_UART_1_INTERRUPT_MASK():
    return 0X000001
def XPAR_MICROBLAZE_0_INTC_RS232_UART_1_INTERRUPT_INTR():
    return 0
def XPAR_AXI_TIMEBASE_WDT_0_WDT_INTERRUPT_MASK():
    return 0X000002
def XPAR_MICROBLAZE_0_INTC_AXI_TIMEBASE_WDT_0_WDT_INTERRUPT_INTR():
    return 1
def XPAR_AXI_TIMEBASE_WDT_0_TIMEBASE_INTERRUPT_MASK():
    return 0X000004
def XPAR_MICROBLAZE_0_INTC_AXI_TIMEBASE_WDT_0_TIMEBASE_INTERRUPT_INTR():
    return 2

# *****************************************************************/

#  Canonical definitions for peripheral MICROBLAZE_0_INTC */
def XPAR_INTC_0_DEVICE_ID():
    return XPAR_MICROBLAZE_0_INTC_DEVICE_ID
def XPAR_INTC_0_BASEADDR():
    return 0x41200000
def XPAR_INTC_0_HIGHADDR():
    return 0x4120FFFF
def XPAR_INTC_0_KIND_OF_INTR():
    return 0xFFFFFFFD
def XPAR_INTC_0_HAS_FAST():
    return 0
def XPAR_INTC_0_IVAR_RESET_VALUE():
    return 0x00000010
def XPAR_INTC_0_NUM_INTR_INPUTS():
    return 3
def XPAR_INTC_0_INTC_TYPE():
    return 0

def XPAR_INTC_0_UARTLITE_1_VEC_ID():
    return XPAR_MICROBLAZE_0_INTC_RS232_UART_1_INTERRUPT_INTR
def XPAR_INTC_0_WDTTB_0_WDT_INTERRUPT_VEC_ID():
    return XPAR_MICROBLAZE_0_INTC_AXI_TIMEBASE_WDT_0_WDT_INTERRUPT_INTR
def XPAR_INTC_0_WDTTB_0_TIMEBASE_INTERRUPT_VEC_ID():
    return XPAR_MICROBLAZE_0_INTC_AXI_TIMEBASE_WDT_0_TIMEBASE_INTERRUPT_INTR

# *****************************************************************/


#  Definitions for peripheral NF10_SWITCH_OUTPUT_PORT_LOOKUP_0 */
def XPAR_NF10_SWITCH_OUTPUT_PORT_LOOKUP_0_BASEADDR():
    return 0x74800000
def XPAR_NF10_SWITCH_OUTPUT_PORT_LOOKUP_0_HIGHADDR():
    return 0x7480FFFF
def XPAR_NF10_SWITCH_OUTPUT_PORT_LOOKUP_0_RESET_CNTRS():
    return 0x74800000
def XPAR_NF10_SWITCH_OUTPUT_PORT_LOOKUP_0_LUT_NUM_HITS_REG():
    return 0x74800004
def XPAR_NF10_SWITCH_OUTPUT_PORT_LOOKUP_0_LUT_NUM_MISSES_REG():
    return 0x74800008


# *****************************************************************/

#  Definitions for bus frequencies */
def XPAR_CPU_M_AXI_DP_FREQ_HZ():
    return 100000000
# *****************************************************************/

#  Canonical definitions for bus frequencies */
def XPAR_PROC_BUS_0_FREQ_HZ():
    return 100000000
# *****************************************************************/

def XPAR_CPU_CORE_CLOCK_FREQ_HZ():
    return 100000000
def XPAR_MICROBLAZE_CORE_CLOCK_FREQ_HZ():
    return 100000000

# *****************************************************************/


#  Definitions for peripheral MICROBLAZE_0 */
def XPAR_MICROBLAZE_0_SCO():
    return 0
def XPAR_MICROBLAZE_0_FREQ():
    return 100000000
def XPAR_MICROBLAZE_0_DATA_SIZE():
    return 32
def XPAR_MICROBLAZE_0_DYNAMIC_BUS_SIZING():
    return 1
def XPAR_MICROBLAZE_0_AVOID_PRIMITIVES():
    return 0
def XPAR_MICROBLAZE_0_FAULT_TOLERANT():
    return 0
def XPAR_MICROBLAZE_0_ECC_USE_CE_EXCEPTION():
    return 0
def XPAR_MICROBLAZE_0_LOCKSTEP_SLAVE():
    return 0
def XPAR_MICROBLAZE_0_ENDIANNESS():
    return 1
def XPAR_MICROBLAZE_0_AREA_OPTIMIZED():
    return 0
def XPAR_MICROBLAZE_0_OPTIMIZATION():
    return 0
def XPAR_MICROBLAZE_0_INTERCONNECT():
    return 2
def XPAR_MICROBLAZE_0_STREAM_INTERCONNECT():
    return 0
def XPAR_MICROBLAZE_0_BASE_VECTORS():
    return 0x00000000
def XPAR_MICROBLAZE_0_DPLB_DWIDTH():
    return 32
def XPAR_MICROBLAZE_0_DPLB_NATIVE_DWIDTH():
    return 32
def XPAR_MICROBLAZE_0_DPLB_BURST_EN():
    return 0
def XPAR_MICROBLAZE_0_DPLB_P2P():
    return 0
def XPAR_MICROBLAZE_0_IPLB_DWIDTH():
    return 32
def XPAR_MICROBLAZE_0_IPLB_NATIVE_DWIDTH():
    return 32
def XPAR_MICROBLAZE_0_IPLB_BURST_EN():
    return 0
def XPAR_MICROBLAZE_0_IPLB_P2P():
    return 0
def XPAR_MICROBLAZE_0_M_AXI_DP_SUPPORTS_THREADS():
    return 0
def XPAR_MICROBLAZE_0_M_AXI_DP_THREAD_ID_WIDTH():
    return 1
def XPAR_MICROBLAZE_0_M_AXI_DP_SUPPORTS_READ():
    return 1
def XPAR_MICROBLAZE_0_M_AXI_DP_SUPPORTS_WRITE():
    return 1
def XPAR_MICROBLAZE_0_M_AXI_DP_SUPPORTS_NARROW_BURST():
    return 0
def XPAR_MICROBLAZE_0_M_AXI_DP_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_0_M_AXI_DP_ADDR_WIDTH():
    return 32
def XPAR_MICROBLAZE_0_M_AXI_DP_PROTOCOL():
    return AXI4LITE
def XPAR_MICROBLAZE_0_M_AXI_DP_EXCLUSIVE_ACCESS():
    return 0
def XPAR_MICROBLAZE_0_INTERCONNECT_M_AXI_DP_READ_ISSUING():
    return 1
def XPAR_MICROBLAZE_0_INTERCONNECT_M_AXI_DP_WRITE_ISSUING():
    return 1
def XPAR_MICROBLAZE_0_M_AXI_IP_SUPPORTS_THREADS():
    return 0
def XPAR_MICROBLAZE_0_M_AXI_IP_THREAD_ID_WIDTH():
    return 1
def XPAR_MICROBLAZE_0_M_AXI_IP_SUPPORTS_READ():
    return 1
def XPAR_MICROBLAZE_0_M_AXI_IP_SUPPORTS_WRITE():
    return 0
def XPAR_MICROBLAZE_0_M_AXI_IP_SUPPORTS_NARROW_BURST():
    return 0
def XPAR_MICROBLAZE_0_M_AXI_IP_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_0_M_AXI_IP_ADDR_WIDTH():
    return 32
def XPAR_MICROBLAZE_0_M_AXI_IP_PROTOCOL():
    return AXI4LITE
def XPAR_MICROBLAZE_0_INTERCONNECT_M_AXI_IP_READ_ISSUING():
    return 1
def XPAR_MICROBLAZE_0_D_AXI():
    return 1
def XPAR_MICROBLAZE_0_D_PLB():
    return 0
def XPAR_MICROBLAZE_0_D_LMB():
    return 1
def XPAR_MICROBLAZE_0_I_AXI():
    return 0
def XPAR_MICROBLAZE_0_I_PLB():
    return 0
def XPAR_MICROBLAZE_0_I_LMB():
    return 1
def XPAR_MICROBLAZE_0_USE_MSR_INSTR():
    return 1
def XPAR_MICROBLAZE_0_USE_PCMP_INSTR():
    return 1
def XPAR_MICROBLAZE_0_USE_BARREL():
    return 1
def XPAR_MICROBLAZE_0_USE_DIV():
    return 0
def XPAR_MICROBLAZE_0_USE_HW_MUL():
    return 1
def XPAR_MICROBLAZE_0_USE_FPU():
    return 0
def XPAR_MICROBLAZE_0_USE_REORDER_INSTR():
    return 1
def XPAR_MICROBLAZE_0_UNALIGNED_EXCEPTIONS():
    return 0
def XPAR_MICROBLAZE_0_ILL_OPCODE_EXCEPTION():
    return 0
def XPAR_MICROBLAZE_0_M_AXI_I_BUS_EXCEPTION():
    return 0
def XPAR_MICROBLAZE_0_M_AXI_D_BUS_EXCEPTION():
    return 0
def XPAR_MICROBLAZE_0_IPLB_BUS_EXCEPTION():
    return 0
def XPAR_MICROBLAZE_0_DPLB_BUS_EXCEPTION():
    return 0
def XPAR_MICROBLAZE_0_DIV_ZERO_EXCEPTION():
    return 0
def XPAR_MICROBLAZE_0_FPU_EXCEPTION():
    return 0
def XPAR_MICROBLAZE_0_FSL_EXCEPTION():
    return 0
def XPAR_MICROBLAZE_0_USE_STACK_PROTECTION():
    return 0
def XPAR_MICROBLAZE_0_PVR():
    return 0
def XPAR_MICROBLAZE_0_PVR_USER1():
    return 0x00
def XPAR_MICROBLAZE_0_PVR_USER2():
    return 0x00000000
def XPAR_MICROBLAZE_0_DEBUG_ENABLED():
    return 1
def XPAR_MICROBLAZE_0_NUMBER_OF_PC_BRK():
    return 1
def XPAR_MICROBLAZE_0_NUMBER_OF_RD_ADDR_BRK():
    return 0
def XPAR_MICROBLAZE_0_NUMBER_OF_WR_ADDR_BRK():
    return 0
def XPAR_MICROBLAZE_0_INTERRUPT_IS_EDGE():
    return 0
def XPAR_MICROBLAZE_0_EDGE_IS_POSITIVE():
    return 1
def XPAR_MICROBLAZE_0_RESET_MSR():
    return 0x00000000
def XPAR_MICROBLAZE_0_OPCODE_0X0_ILLEGAL():
    return 0
def XPAR_MICROBLAZE_0_FSL_LINKS():
    return 0
def XPAR_MICROBLAZE_0_FSL_DATA_SIZE():
    return 32
def XPAR_MICROBLAZE_0_USE_EXTENDED_FSL_INSTR():
    return 0
def XPAR_MICROBLAZE_0_M0_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_0_S0_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_0_M1_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_0_S1_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_0_M2_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_0_S2_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_0_M3_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_0_S3_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_0_M4_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_0_S4_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_0_M5_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_0_S5_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_0_M6_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_0_S6_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_0_M7_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_0_S7_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_0_M8_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_0_S8_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_0_M9_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_0_S9_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_0_M10_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_0_S10_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_0_M11_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_0_S11_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_0_M12_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_0_S12_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_0_M13_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_0_S13_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_0_M14_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_0_S14_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_0_M15_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_0_S15_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_0_M0_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_0_S0_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_0_M1_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_0_S1_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_0_M2_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_0_S2_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_0_M3_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_0_S3_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_0_M4_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_0_S4_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_0_M5_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_0_S5_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_0_M6_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_0_S6_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_0_M7_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_0_S7_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_0_M8_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_0_S8_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_0_M9_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_0_S9_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_0_M10_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_0_S10_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_0_M11_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_0_S11_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_0_M12_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_0_S12_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_0_M13_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_0_S13_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_0_M14_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_0_S14_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_0_M15_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_0_S15_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_0_ICACHE_BASEADDR():
    return 0x00000000
def XPAR_MICROBLAZE_0_ICACHE_HIGHADDR():
    return 0x3FFFFFFF
def XPAR_MICROBLAZE_0_USE_ICACHE():
    return 0
def XPAR_MICROBLAZE_0_ALLOW_ICACHE_WR():
    return 1
def XPAR_MICROBLAZE_0_ADDR_TAG_BITS():
    return 0
def XPAR_MICROBLAZE_0_CACHE_BYTE_SIZE():
    return 8192
def XPAR_MICROBLAZE_0_ICACHE_USE_FSL():
    return 0
def XPAR_MICROBLAZE_0_ICACHE_LINE_LEN():
    return 4
def XPAR_MICROBLAZE_0_ICACHE_ALWAYS_USED():
    return 0
def XPAR_MICROBLAZE_0_ICACHE_INTERFACE():
    return 0
def XPAR_MICROBLAZE_0_ICACHE_VICTIMS():
    return 0
def XPAR_MICROBLAZE_0_ICACHE_STREAMS():
    return 0
def XPAR_MICROBLAZE_0_ICACHE_FORCE_TAG_LUTRAM():
    return 0
def XPAR_MICROBLAZE_0_ICACHE_DATA_WIDTH():
    return 0
def XPAR_MICROBLAZE_0_M_AXI_IC_SUPPORTS_THREADS():
    return 0
def XPAR_MICROBLAZE_0_M_AXI_IC_THREAD_ID_WIDTH():
    return 1
def XPAR_MICROBLAZE_0_M_AXI_IC_SUPPORTS_READ():
    return 1
def XPAR_MICROBLAZE_0_M_AXI_IC_SUPPORTS_WRITE():
    return 0
def XPAR_MICROBLAZE_0_M_AXI_IC_SUPPORTS_NARROW_BURST():
    return 0
def XPAR_MICROBLAZE_0_M_AXI_IC_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_0_M_AXI_IC_ADDR_WIDTH():
    return 32
def XPAR_MICROBLAZE_0_M_AXI_IC_PROTOCOL():
    return AXI4
def XPAR_MICROBLAZE_0_M_AXI_IC_USER_VALUE():
    return 0b11111
def XPAR_MICROBLAZE_0_M_AXI_IC_SUPPORTS_USER_SIGNALS():
    return 1
def XPAR_MICROBLAZE_0_M_AXI_IC_AWUSER_WIDTH():
    return 5
def XPAR_MICROBLAZE_0_M_AXI_IC_ARUSER_WIDTH():
    return 5
def XPAR_MICROBLAZE_0_M_AXI_IC_WUSER_WIDTH():
    return 1
def XPAR_MICROBLAZE_0_M_AXI_IC_RUSER_WIDTH():
    return 1
def XPAR_MICROBLAZE_0_M_AXI_IC_BUSER_WIDTH():
    return 1
def XPAR_MICROBLAZE_0_INTERCONNECT_M_AXI_IC_READ_ISSUING():
    return 2
def XPAR_MICROBLAZE_0_DCACHE_BASEADDR():
    return 0x00000000
def XPAR_MICROBLAZE_0_DCACHE_HIGHADDR():
    return 0x3FFFFFFF
def XPAR_MICROBLAZE_0_USE_DCACHE():
    return 0
def XPAR_MICROBLAZE_0_ALLOW_DCACHE_WR():
    return 1
def XPAR_MICROBLAZE_0_DCACHE_ADDR_TAG():
    return 0
def XPAR_MICROBLAZE_0_DCACHE_BYTE_SIZE():
    return 8192
def XPAR_MICROBLAZE_0_DCACHE_USE_FSL():
    return 0
def XPAR_MICROBLAZE_0_DCACHE_LINE_LEN():
    return 4
def XPAR_MICROBLAZE_0_DCACHE_ALWAYS_USED():
    return 0
def XPAR_MICROBLAZE_0_DCACHE_INTERFACE():
    return 0
def XPAR_MICROBLAZE_0_DCACHE_USE_WRITEBACK():
    return 0
def XPAR_MICROBLAZE_0_DCACHE_VICTIMS():
    return 0
def XPAR_MICROBLAZE_0_DCACHE_FORCE_TAG_LUTRAM():
    return 0
def XPAR_MICROBLAZE_0_DCACHE_DATA_WIDTH():
    return 0
def XPAR_MICROBLAZE_0_M_AXI_DC_SUPPORTS_THREADS():
    return 0
def XPAR_MICROBLAZE_0_M_AXI_DC_THREAD_ID_WIDTH():
    return 1
def XPAR_MICROBLAZE_0_M_AXI_DC_SUPPORTS_READ():
    return 1
def XPAR_MICROBLAZE_0_M_AXI_DC_SUPPORTS_WRITE():
    return 1
def XPAR_MICROBLAZE_0_M_AXI_DC_SUPPORTS_NARROW_BURST():
    return 0
def XPAR_MICROBLAZE_0_M_AXI_DC_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_0_M_AXI_DC_ADDR_WIDTH():
    return 32
def XPAR_MICROBLAZE_0_M_AXI_DC_PROTOCOL():
    return AXI4
def XPAR_MICROBLAZE_0_M_AXI_DC_EXCLUSIVE_ACCESS():
    return 0
def XPAR_MICROBLAZE_0_M_AXI_DC_USER_VALUE():
    return 0b11111
def XPAR_MICROBLAZE_0_M_AXI_DC_SUPPORTS_USER_SIGNALS():
    return 1
def XPAR_MICROBLAZE_0_M_AXI_DC_AWUSER_WIDTH():
    return 5
def XPAR_MICROBLAZE_0_M_AXI_DC_ARUSER_WIDTH():
    return 5
def XPAR_MICROBLAZE_0_M_AXI_DC_WUSER_WIDTH():
    return 1
def XPAR_MICROBLAZE_0_M_AXI_DC_RUSER_WIDTH():
    return 1
def XPAR_MICROBLAZE_0_M_AXI_DC_BUSER_WIDTH():
    return 1
def XPAR_MICROBLAZE_0_INTERCONNECT_M_AXI_DC_READ_ISSUING():
    return 2
def XPAR_MICROBLAZE_0_INTERCONNECT_M_AXI_DC_WRITE_ISSUING():
    return 32
def XPAR_MICROBLAZE_0_USE_MMU():
    return 0
def XPAR_MICROBLAZE_0_MMU_DTLB_SIZE():
    return 4
def XPAR_MICROBLAZE_0_MMU_ITLB_SIZE():
    return 2
def XPAR_MICROBLAZE_0_MMU_TLB_ACCESS():
    return 3
def XPAR_MICROBLAZE_0_MMU_ZONES():
    return 16
def XPAR_MICROBLAZE_0_MMU_PRIVILEGED_INSTR():
    return 0
def XPAR_MICROBLAZE_0_USE_INTERRUPT():
    return 1
def XPAR_MICROBLAZE_0_USE_EXT_BRK():
    return 1
def XPAR_MICROBLAZE_0_USE_EXT_NM_BRK():
    return 1
def XPAR_MICROBLAZE_0_USE_BRANCH_TARGET_CACHE():
    return 0
def XPAR_MICROBLAZE_0_BRANCH_TARGET_CACHE_SIZE():
    return 0
def XPAR_MICROBLAZE_0_PC_WIDTH():
    return 32

# *****************************************************************/

def XPAR_CPU_ID():
    return 0
def XPAR_MICROBLAZE_ID():
    return 0
def XPAR_MICROBLAZE_SCO():
    return 0
def XPAR_MICROBLAZE_FREQ():
    return 100000000
def XPAR_MICROBLAZE_DATA_SIZE():
    return 32
def XPAR_MICROBLAZE_DYNAMIC_BUS_SIZING():
    return 1
def XPAR_MICROBLAZE_AVOID_PRIMITIVES():
    return 0
def XPAR_MICROBLAZE_FAULT_TOLERANT():
    return 0
def XPAR_MICROBLAZE_ECC_USE_CE_EXCEPTION():
    return 0
def XPAR_MICROBLAZE_LOCKSTEP_SLAVE():
    return 0
def XPAR_MICROBLAZE_ENDIANNESS():
    return 1
def XPAR_MICROBLAZE_AREA_OPTIMIZED():
    return 0
def XPAR_MICROBLAZE_OPTIMIZATION():
    return 0
def XPAR_MICROBLAZE_INTERCONNECT():
    return 2
def XPAR_MICROBLAZE_STREAM_INTERCONNECT():
    return 0
def XPAR_MICROBLAZE_BASE_VECTORS():
    return 0x00000000
def XPAR_MICROBLAZE_DPLB_DWIDTH():
    return 32
def XPAR_MICROBLAZE_DPLB_NATIVE_DWIDTH():
    return 32
def XPAR_MICROBLAZE_DPLB_BURST_EN():
    return 0
def XPAR_MICROBLAZE_DPLB_P2P():
    return 0
def XPAR_MICROBLAZE_IPLB_DWIDTH():
    return 32
def XPAR_MICROBLAZE_IPLB_NATIVE_DWIDTH():
    return 32
def XPAR_MICROBLAZE_IPLB_BURST_EN():
    return 0
def XPAR_MICROBLAZE_IPLB_P2P():
    return 0
def XPAR_MICROBLAZE_M_AXI_DP_SUPPORTS_THREADS():
    return 0
def XPAR_MICROBLAZE_M_AXI_DP_THREAD_ID_WIDTH():
    return 1
def XPAR_MICROBLAZE_M_AXI_DP_SUPPORTS_READ():
    return 1
def XPAR_MICROBLAZE_M_AXI_DP_SUPPORTS_WRITE():
    return 1
def XPAR_MICROBLAZE_M_AXI_DP_SUPPORTS_NARROW_BURST():
    return 0
def XPAR_MICROBLAZE_M_AXI_DP_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_M_AXI_DP_ADDR_WIDTH():
    return 32
def XPAR_MICROBLAZE_M_AXI_DP_PROTOCOL():
    return AXI4LITE
def XPAR_MICROBLAZE_M_AXI_DP_EXCLUSIVE_ACCESS():
    return 0
def XPAR_MICROBLAZE_INTERCONNECT_M_AXI_DP_READ_ISSUING():
    return 1
def XPAR_MICROBLAZE_INTERCONNECT_M_AXI_DP_WRITE_ISSUING():
    return 1
def XPAR_MICROBLAZE_M_AXI_IP_SUPPORTS_THREADS():
    return 0
def XPAR_MICROBLAZE_M_AXI_IP_THREAD_ID_WIDTH():
    return 1
def XPAR_MICROBLAZE_M_AXI_IP_SUPPORTS_READ():
    return 1
def XPAR_MICROBLAZE_M_AXI_IP_SUPPORTS_WRITE():
    return 0
def XPAR_MICROBLAZE_M_AXI_IP_SUPPORTS_NARROW_BURST():
    return 0
def XPAR_MICROBLAZE_M_AXI_IP_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_M_AXI_IP_ADDR_WIDTH():
    return 32
def XPAR_MICROBLAZE_M_AXI_IP_PROTOCOL():
    return AXI4LITE
def XPAR_MICROBLAZE_INTERCONNECT_M_AXI_IP_READ_ISSUING():
    return 1
def XPAR_MICROBLAZE_D_AXI():
    return 1
def XPAR_MICROBLAZE_D_PLB():
    return 0
def XPAR_MICROBLAZE_D_LMB():
    return 1
def XPAR_MICROBLAZE_I_AXI():
    return 0
def XPAR_MICROBLAZE_I_PLB():
    return 0
def XPAR_MICROBLAZE_I_LMB():
    return 1
def XPAR_MICROBLAZE_USE_MSR_INSTR():
    return 1
def XPAR_MICROBLAZE_USE_PCMP_INSTR():
    return 1
def XPAR_MICROBLAZE_USE_BARREL():
    return 1
def XPAR_MICROBLAZE_USE_DIV():
    return 0
def XPAR_MICROBLAZE_USE_HW_MUL():
    return 1
def XPAR_MICROBLAZE_USE_FPU():
    return 0
def XPAR_MICROBLAZE_USE_REORDER_INSTR():
    return 1
def XPAR_MICROBLAZE_UNALIGNED_EXCEPTIONS():
    return 0
def XPAR_MICROBLAZE_ILL_OPCODE_EXCEPTION():
    return 0
def XPAR_MICROBLAZE_M_AXI_I_BUS_EXCEPTION():
    return 0
def XPAR_MICROBLAZE_M_AXI_D_BUS_EXCEPTION():
    return 0
def XPAR_MICROBLAZE_IPLB_BUS_EXCEPTION():
    return 0
def XPAR_MICROBLAZE_DPLB_BUS_EXCEPTION():
    return 0
def XPAR_MICROBLAZE_DIV_ZERO_EXCEPTION():
    return 0
def XPAR_MICROBLAZE_FPU_EXCEPTION():
    return 0
def XPAR_MICROBLAZE_FSL_EXCEPTION():
    return 0
def XPAR_MICROBLAZE_USE_STACK_PROTECTION():
    return 0
def XPAR_MICROBLAZE_PVR():
    return 0
def XPAR_MICROBLAZE_PVR_USER1():
    return 0x00
def XPAR_MICROBLAZE_PVR_USER2():
    return 0x00000000
def XPAR_MICROBLAZE_DEBUG_ENABLED():
    return 1
def XPAR_MICROBLAZE_NUMBER_OF_PC_BRK():
    return 1
def XPAR_MICROBLAZE_NUMBER_OF_RD_ADDR_BRK():
    return 0
def XPAR_MICROBLAZE_NUMBER_OF_WR_ADDR_BRK():
    return 0
def XPAR_MICROBLAZE_INTERRUPT_IS_EDGE():
    return 0
def XPAR_MICROBLAZE_EDGE_IS_POSITIVE():
    return 1
def XPAR_MICROBLAZE_RESET_MSR():
    return 0x00000000
def XPAR_MICROBLAZE_OPCODE_0X0_ILLEGAL():
    return 0
def XPAR_MICROBLAZE_FSL_LINKS():
    return 0
def XPAR_MICROBLAZE_FSL_DATA_SIZE():
    return 32
def XPAR_MICROBLAZE_USE_EXTENDED_FSL_INSTR():
    return 0
def XPAR_MICROBLAZE_M0_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_S0_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_M1_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_S1_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_M2_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_S2_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_M3_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_S3_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_M4_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_S4_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_M5_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_S5_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_M6_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_S6_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_M7_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_S7_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_M8_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_S8_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_M9_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_S9_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_M10_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_S10_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_M11_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_S11_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_M12_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_S12_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_M13_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_S13_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_M14_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_S14_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_M15_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_S15_AXIS_PROTOCOL():
    return GENERIC
def XPAR_MICROBLAZE_M0_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_S0_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_M1_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_S1_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_M2_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_S2_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_M3_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_S3_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_M4_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_S4_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_M5_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_S5_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_M6_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_S6_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_M7_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_S7_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_M8_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_S8_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_M9_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_S9_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_M10_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_S10_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_M11_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_S11_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_M12_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_S12_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_M13_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_S13_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_M14_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_S14_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_M15_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_S15_AXIS_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_ICACHE_BASEADDR():
    return 0x00000000
def XPAR_MICROBLAZE_ICACHE_HIGHADDR():
    return 0x3FFFFFFF
def XPAR_MICROBLAZE_USE_ICACHE():
    return 0
def XPAR_MICROBLAZE_ALLOW_ICACHE_WR():
    return 1
def XPAR_MICROBLAZE_ADDR_TAG_BITS():
    return 0
def XPAR_MICROBLAZE_CACHE_BYTE_SIZE():
    return 8192
def XPAR_MICROBLAZE_ICACHE_USE_FSL():
    return 0
def XPAR_MICROBLAZE_ICACHE_LINE_LEN():
    return 4
def XPAR_MICROBLAZE_ICACHE_ALWAYS_USED():
    return 0
def XPAR_MICROBLAZE_ICACHE_INTERFACE():
    return 0
def XPAR_MICROBLAZE_ICACHE_VICTIMS():
    return 0
def XPAR_MICROBLAZE_ICACHE_STREAMS():
    return 0
def XPAR_MICROBLAZE_ICACHE_FORCE_TAG_LUTRAM():
    return 0
def XPAR_MICROBLAZE_ICACHE_DATA_WIDTH():
    return 0
def XPAR_MICROBLAZE_M_AXI_IC_SUPPORTS_THREADS():
    return 0
def XPAR_MICROBLAZE_M_AXI_IC_THREAD_ID_WIDTH():
    return 1
def XPAR_MICROBLAZE_M_AXI_IC_SUPPORTS_READ():
    return 1
def XPAR_MICROBLAZE_M_AXI_IC_SUPPORTS_WRITE():
    return 0
def XPAR_MICROBLAZE_M_AXI_IC_SUPPORTS_NARROW_BURST():
    return 0
def XPAR_MICROBLAZE_M_AXI_IC_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_M_AXI_IC_ADDR_WIDTH():
    return 32
def XPAR_MICROBLAZE_M_AXI_IC_PROTOCOL():
    return AXI4
def XPAR_MICROBLAZE_M_AXI_IC_USER_VALUE():
    return 0b11111
def XPAR_MICROBLAZE_M_AXI_IC_SUPPORTS_USER_SIGNALS():
    return 1
def XPAR_MICROBLAZE_M_AXI_IC_AWUSER_WIDTH():
    return 5
def XPAR_MICROBLAZE_M_AXI_IC_ARUSER_WIDTH():
    return 5
def XPAR_MICROBLAZE_M_AXI_IC_WUSER_WIDTH():
    return 1
def XPAR_MICROBLAZE_M_AXI_IC_RUSER_WIDTH():
    return 1
def XPAR_MICROBLAZE_M_AXI_IC_BUSER_WIDTH():
    return 1
def XPAR_MICROBLAZE_INTERCONNECT_M_AXI_IC_READ_ISSUING():
    return 2
def XPAR_MICROBLAZE_DCACHE_BASEADDR():
    return 0x00000000
def XPAR_MICROBLAZE_DCACHE_HIGHADDR():
    return 0x3FFFFFFF
def XPAR_MICROBLAZE_USE_DCACHE():
    return 0
def XPAR_MICROBLAZE_ALLOW_DCACHE_WR():
    return 1
def XPAR_MICROBLAZE_DCACHE_ADDR_TAG():
    return 0
def XPAR_MICROBLAZE_DCACHE_BYTE_SIZE():
    return 8192
def XPAR_MICROBLAZE_DCACHE_USE_FSL():
    return 0
def XPAR_MICROBLAZE_DCACHE_LINE_LEN():
    return 4
def XPAR_MICROBLAZE_DCACHE_ALWAYS_USED():
    return 0
def XPAR_MICROBLAZE_DCACHE_INTERFACE():
    return 0
def XPAR_MICROBLAZE_DCACHE_USE_WRITEBACK():
    return 0
def XPAR_MICROBLAZE_DCACHE_VICTIMS():
    return 0
def XPAR_MICROBLAZE_DCACHE_FORCE_TAG_LUTRAM():
    return 0
def XPAR_MICROBLAZE_DCACHE_DATA_WIDTH():
    return 0
def XPAR_MICROBLAZE_M_AXI_DC_SUPPORTS_THREADS():
    return 0
def XPAR_MICROBLAZE_M_AXI_DC_THREAD_ID_WIDTH():
    return 1
def XPAR_MICROBLAZE_M_AXI_DC_SUPPORTS_READ():
    return 1
def XPAR_MICROBLAZE_M_AXI_DC_SUPPORTS_WRITE():
    return 1
def XPAR_MICROBLAZE_M_AXI_DC_SUPPORTS_NARROW_BURST():
    return 0
def XPAR_MICROBLAZE_M_AXI_DC_DATA_WIDTH():
    return 32
def XPAR_MICROBLAZE_M_AXI_DC_ADDR_WIDTH():
    return 32
def XPAR_MICROBLAZE_M_AXI_DC_PROTOCOL():
    return AXI4
def XPAR_MICROBLAZE_M_AXI_DC_EXCLUSIVE_ACCESS():
    return 0
def XPAR_MICROBLAZE_M_AXI_DC_USER_VALUE():
    return 0b11111
def XPAR_MICROBLAZE_M_AXI_DC_SUPPORTS_USER_SIGNALS():
    return 1
def XPAR_MICROBLAZE_M_AXI_DC_AWUSER_WIDTH():
    return 5
def XPAR_MICROBLAZE_M_AXI_DC_ARUSER_WIDTH():
    return 5
def XPAR_MICROBLAZE_M_AXI_DC_WUSER_WIDTH():
    return 1
def XPAR_MICROBLAZE_M_AXI_DC_RUSER_WIDTH():
    return 1
def XPAR_MICROBLAZE_M_AXI_DC_BUSER_WIDTH():
    return 1
def XPAR_MICROBLAZE_INTERCONNECT_M_AXI_DC_READ_ISSUING():
    return 2
def XPAR_MICROBLAZE_INTERCONNECT_M_AXI_DC_WRITE_ISSUING():
    return 32
def XPAR_MICROBLAZE_USE_MMU():
    return 0
def XPAR_MICROBLAZE_MMU_DTLB_SIZE():
    return 4
def XPAR_MICROBLAZE_MMU_ITLB_SIZE():
    return 2
def XPAR_MICROBLAZE_MMU_TLB_ACCESS():
    return 3
def XPAR_MICROBLAZE_MMU_ZONES():
    return 16
def XPAR_MICROBLAZE_MMU_PRIVILEGED_INSTR():
    return 0
def XPAR_MICROBLAZE_USE_INTERRUPT():
    return 1
def XPAR_MICROBLAZE_USE_EXT_BRK():
    return 1
def XPAR_MICROBLAZE_USE_EXT_NM_BRK():
    return 1
def XPAR_MICROBLAZE_USE_BRANCH_TARGET_CACHE():
    return 0
def XPAR_MICROBLAZE_BRANCH_TARGET_CACHE_SIZE():
    return 0
def XPAR_MICROBLAZE_PC_WIDTH():
    return 32
def XPAR_MICROBLAZE_HW_VER():
    return "8.50.b"

# *****************************************************************/
