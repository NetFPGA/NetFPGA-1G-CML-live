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
    printf("LPM_IP\t\t\t\t|00\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_LPM_IP));
    printf("LPM_IP_MASK\t\t\t|04\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_LPM_IP_MASK));
    printf("LPM_NEXT_HOP_IP\t\t\t|08\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_LPM_NEXT_HOP_IP));
    printf("LPM_OQ\t\t\t\t|0c\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_LPM_OQ));
    printf("LPM_WR_ADDR\t\t\t|10\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_LPM_WR_ADDR));
    printf("LPM_RD_ADDR\t\t\t|14\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_LPM_RD_ADDR));

    printf("ARP_IP\t\t\t\t|20\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_ARP_IP));
    printf("ARP_MAC_LOW\t\t\t|24\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_ARP_MAC_LOW));
    printf("ARP_MAC_HIGH\t\t\t|28\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_ARP_MAC_HIGH));
    printf("ARP_WR_ADDR\t\t\t|2c\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_ARP_WR_ADDR));
    printf("ARP_RD_ADDR\t\t\t|30\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_ARP_RD_ADDR));

    printf("FILTER_IP\t\t\t|40\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_FILTER_IP));
    printf("FILTER_WR_ADDR\t\t\t|44\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_FILTER_WR_ADDR));
    printf("FILTER_RD_ADDR\t\t\t|48\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR1_FILTER_RD_ADDR));

    printf("RESET_CNTRS\t\t\t|00\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_RESET_CNTRS)); 
    printf("MAC_0_LOW\t\t\t|04\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_MAC_0_LOW));
    printf("MAC_0_HIGH\t\t\t|08\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_MAC_0_HIGH));
    printf("MAC_1_LOW\t\t\t|0c\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_MAC_1_LOW));
    printf("MAC_1_HIGH\t\t\t|10\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_MAC_1_HIGH));
    printf("MAC_2_LOW\t\t\t|14\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_MAC_2_LOW));
    printf("MAC_2_HIGH\t\t\t|18\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_MAC_2_HIGH));
    printf("MAC_3_LOW\t\t\t|1c\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_MAC_3_LOW));
    printf("MAC_3_HIGH\t\t\t|20\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_MAC_3_HIGH));

    printf("PKT_DROPPED_WRONG_DST_MAC\t|24\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_PKT_DROPPED_WRONG_DST_MAC)); 
    printf("PKT_SENT_CPU_LPM_MISS\t\t|28\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_PKT_SENT_CPU_LPM_MISS));
    printf("PKT_SENT_CPU_ARP_MISS\t\t|2c\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_PKT_SENT_CPU_ARP_MISS));
    printf("PKT_SENT_CPU_NON_IP\t\t|30\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_PKT_SENT_CPU_NON_IP));
    printf("PKT_DROPPED_CHECKSUM\t\t|34\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_PKT_DROPPED_CHECKSUM));
    printf("PKT_FORWARDED\t\t\t|38\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_PKT_FORWARDED));
    printf("PKT_SENT_CPU_DEST_IP_HIT\t|3c\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_PKT_SENT_CPU_DEST_IP_HIT));
    printf("PKT_SENT_TO_CPU_BAD_TTL\t\t|40\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_PKT_SENT_TO_CPU_BAD_TTL));
    printf("PKT_SENT_CPU_OPTION_VER\t\t|44\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_PKT_SENT_CPU_OPTION_VER));
    printf("PKT_SENT_FROM_CPU\t\t|48\t|       %llx \t|\n", regread(XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0_BAR0_PKT_SENT_FROM_CPU));
    printf("---------------------------------------------------------\n");


}
