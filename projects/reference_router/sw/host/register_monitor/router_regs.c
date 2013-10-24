#include <fcntl.h>
#include <sys/ioctl.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdlib.h>
#include "../../../../../tools/lib/nf10_lib.c"
#include "../reg_defines.h"
#define NF10_IOCTL_CMD_READ_REG (SIOCDEVPRIVATE+2)
int system(const char *string);

int main(){

    printf("|             Router pcore registers                    |\n");
    printf("---------------------------------------------------------\n");
    printf("Type\t\t\t\t|offset |\tValue   |\n");
    printf("---------------------------------------------------------\n");
    printf("LPM_IP\t\t\t\t|00\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_LPM_IP_OFFSET));
    printf("LPM_IP_MASK\t\t\t|04\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_LPM_IP_MASK_OFFSET));
    printf("LPM_NEXT_HOP_IP\t\t\t|08\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_LPM_NEXT_HOP_IP_OFFSET));
    printf("LPM_OQ\t\t\t\t|0c\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_LPM_OQ_OFFSET));
    printf("LPM_WR_ADDR\t\t\t|10\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_LPM_WR_ADDR_OFFSET));
    printf("LPM_RD_ADDR\t\t\t|14\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_LPM_RD_ADDR_OFFSET));

    printf("ARP_IP\t\t\t\t|20\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_ARP_IP_OFFSET));
    printf("ARP_MAC_LOW\t\t\t|24\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_ARP_MAC_LOW_OFFSET));
    printf("ARP_MAC_HIGH\t\t\t|28\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_ARP_MAC_HIGH_OFFSET));
    printf("ARP_WR_ADDR\t\t\t|2c\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_ARP_WR_ADDR_OFFSET));
    printf("ARP_RD_ADDR\t\t\t|30\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_ARP_RD_ADDR_OFFSET));

    printf("FILTER_IP\t\t\t|40\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_FILTER_IP_OFFSET));
    printf("FILTER_WR_ADDR\t\t\t|44\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_FILTER_WR_ADDR_OFFSET));
    printf("FILTER_RD_ADDR\t\t\t|48\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_FILTER_RD_ADDR_OFFSET));

    printf("RESET_CNTRS\t\t\t|00\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_RESET_CNTRS_OFFSET)); 
    printf("MAC_0_LOW\t\t\t|04\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_MAC_0_LOW_OFFSET));
    printf("MAC_0_HIGH\t\t\t|08\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_MAC_0_HIGH_OFFSET));
    printf("MAC_1_LOW\t\t\t|0c\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_MAC_1_LOW_OFFSET));
    printf("MAC_1_HIGH\t\t\t|10\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_MAC_1_HIGH_OFFSET));
    printf("MAC_2_LOW\t\t\t|14\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_MAC_2_LOW_OFFSET));
    printf("MAC_2_HIGH\t\t\t|18\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_MAC_2_HIGH_OFFSET));
    printf("MAC_3_LOW\t\t\t|1c\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_MAC_3_LOW_OFFSET));
    printf("MAC_3_HIGH\t\t\t|20\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_MAC_3_HIGH_OFFSET));

    printf("PKT_DROPPED_WRONG_DST_MAC\t|24\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_PKT_DROPPED_WRONG_DST_MAC_OFFSET)); 
    printf("PKT_SENT_CPU_LPM_MISS\t\t|28\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_PKT_SENT_CPU_LPM_MISS_OFFSET));
    printf("PKT_SENT_CPU_ARP_MISS\t\t|2c\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_PKT_SENT_CPU_ARP_MISS_OFFSET));
    printf("PKT_SENT_CPU_NON_IP\t\t|30\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_PKT_SENT_CPU_NON_IP_OFFSET));
    printf("PKT_DROPPED_CHECKSUM\t\t|34\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_PKT_DROPPED_CHECKSUM_OFFSET));
    printf("PKT_FORWARDED\t\t\t|38\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_PKT_FORWARDED_OFFSET));
    printf("PKT_SENT_CPU_DEST_IP_HIT\t|3c\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_PKT_SENT_CPU_DEST_IP_HIT_OFFSET));
    printf("PKT_SENT_TO_CPU_BAD_TTL\t\t|40\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_PKT_SENT_TO_CPU_BAD_TTL_OFFSET));
    printf("PKT_SENT_CPU_OPTION_VER\t\t|44\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_PKT_SENT_CPU_OPTION_VER_OFFSET));
    printf("PKT_SENT_FROM_CPU\t\t|48\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_PKT_SENT_FROM_CPU_OFFSET));
    printf("---------------------------------------------------------\n");


}
