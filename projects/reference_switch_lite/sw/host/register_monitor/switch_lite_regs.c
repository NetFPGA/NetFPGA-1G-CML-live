#include <fcntl.h>
#include <sys/ioctl.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdlib.h>
#include "../../../../../tools/lib/nf10_lib.c"
#include "../reg_defines.h"

int main(){

    printf("---------------------------------------------------------\n");
    printf("|             Switch-lite pcore registers               |\n");
    printf("---------------------------------------------------------\n");
    printf("Type\t\t\t\t|offset |\tValue\t|\n");
    printf("---------------------------------------------------------\n");
    printf("RESET_CNTRS\t\t\t|00\t|       %llx \t|\n", regread(XPAR_NF10_SWITCH_OUTPUT_PORT_LOOKUP_0_RESET_CNTRS));
    printf("SWITCH_OP_LUT_NUM_HITS_REG\t|04\t|       %llx \t|\n", regread(XPAR_NF10_SWITCH_OUTPUT_PORT_LOOKUP_0_LUT_NUM_HITS_REG));
    printf("SWITCH_OP_LUT_NUM_MISSES_REG\t|08\t|       %llx \t|\n", regread(XPAR_NF10_SWITCH_OUTPUT_PORT_LOOKUP_0_LUT_NUM_MISSES_REG));
    printf("---------------------------------------------------------\n");
}
