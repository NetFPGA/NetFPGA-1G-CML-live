#include <fcntl.h>
#include <sys/ioctl.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdlib.h>
#include "/root/NetFPGA-10G-live/tools/lib/nf10_lib.c"


int main(){

    printf("---------------------------------------------------------\n");
    printf("|             Switch pcore registers                    |\n");
    printf("---------------------------------------------------------\n");
    printf("Type\t\t\t\t|offset |\tValue   |\n");
    printf("---------------------------------------------------------\n");
    printf("RESET_CNTRS\t\t\t|00\t|       %llx \t|\n", regread(0x5a000000));
    printf("enabled_signal1\t\t\t|00\t|       %llx \t|\n", regread(0x5a000004));
/*    printf("enable_tuser\t\t\t|00\t|       %llx \t|\n", regread(0x5a000008));
    printf("enable_tdata\t\t\t|00\t|       %llx \t|\n", regread(0x5a00000c));
    printf("dummy\n");
    printf("lut_hit_cntr\t\t\t|00\t|       %llx \t|\n", regread(0x5a000010));
    printf("real\n");
    printf("tuser\t\t\t\t|04\t|       %llx \t|\n", regread(0x5a000014));
    printf("tvalid\t\t\t\t|08\t|       %llx \t|\n", regread(0x5a000018));
    printf("tready\t\t\t\t|04\t|       %llx \t|\n", regread(0x5a00001c));
    printf("tlast\t\t\t\t|08\t|       %llx \t|\n", regread(0x5a000020));
    printf("tstrobe\t\t\t\t|04\t|       %llx \t|\n", regread(0x5a000024));
    printf("data\n");
    printf("data1\t\t\t\t|08\t|       %llx \t|\n", regread(0x5a000028));
    printf("data2\t\t\t\t|04\t|       %llx \t|\n", regread(0x5a00002c));
    printf("data3\t\t\t\t|08\t|       %llx \t|\n", regread(0x5a000030));
    printf("data4\t\t\t\t|04\t|       %llx \t|\n", regread(0x5a000034));
    printf("data5\t\t\t\t|08\t|       %llx \t|\n", regread(0x5a000038));
    printf("data6\t\t\t\t|04\t|       %llx \t|\n", regread(0x5a00003c));
    printf("data7\t\t\t\t|08\t|       %llx \t|\n", regread(0x5a000040));
    printf("data8\t\t\t\t|08\t|       %llx \t|\n", regread(0x5a000044));
*/
    printf("---------------------------------------------------------\n");
}
