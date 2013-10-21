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
    printf("Type			        |offset |\tValue   |\n");
    printf("---------------------------------------------------------\n");
    printf("LPM_IP\t\t\t\t|00\t|       %llx \t|\n", regread(ROUTER_OP_LUT_ROUTE_TABLE_ENTRY_IP_REG));
    printf("LPM_IP_MASK\t\t\t|04\t|       %llx \t|\n", regread(ROUTER_OP_LUT_ROUTE_TABLE_ENTRY_MASK_REG));
    printf("LPM_NEXT_HOP_IP\t\t\t|08\t|       %llx \t|\n", regread(ROUTER_OP_LUT_ROUTE_TABLE_ENTRY_NEXT_HOP_IP_REG));
    printf("LPM_OQ\t\t\t\t|0c\t|       %llx \t|\n", regread(ROUTER_OP_LUT_ROUTE_TABLE_ENTRY_OUTPUT_PORT_REG));
    printf("LPM_WR_ADDR\t\t\t|10\t|       %llx \t|\n", regread(ROUTER_OP_LUT_ROUTE_TABLE_RD_ADDR_REG));
    printf("LPM_RD_ADDR\t\t\t|14\t|       %llx \t|\n", regread(ROUTER_OP_LUT_ROUTE_TABLE_WR_ADDR_REG));

    printf("ARP_IP\t\t\t\t|20\t|       %llx \t|\n", regread(ROUTER_OP_LUT_ARP_TABLE_ENTRY_MAC_HI_REG));
    printf("ARP_MAC_LOW\t\t\t|24\t|       %llx \t|\n", regread(ROUTER_OP_LUT_ARP_TABLE_ENTRY_MAC_LO_REG));
    printf("ARP_MAC_HIGH\t\t\t|28\t|       %llx \t|\n", regread(ROUTER_OP_LUT_ARP_TABLE_ENTRY_NEXT_HOP_IP_REG));
    printf("ARP_WR_ADDR\t\t\t|2c\t|       %llx \t|\n", regread(ROUTER_OP_LUT_ARP_TABLE_RD_ADDR_REG));
    printf("ARP_RD_ADDR\t\t\t|30\t|       %llx \t|\n", regread(ROUTER_OP_LUT_ARP_TABLE_WR_ADDR_REG));

    printf("FILTER_IP\t\t\t|40\t|       %llx \t|\n", regread(ROUTER_OP_LUT_DST_IP_FILTER_TABLE_ENTRY_IP_REG));
    printf("FILTER_WR_ADDR\t\t\t|44\t|       %llx \t|\n", regread(ROUTER_OP_LUT_DST_IP_FILTER_TABLE_RD_ADDR_REG));
    printf("FILTER_RD_ADDR\t\t\t|48\t|       %llx \t|\n", regread(ROUTER_OP_LUT_DST_IP_FILTER_TABLE_WR_ADDR_REG));

    printf("RESET_CNTRS\t\t\t|00\t|       %llx \t|\n", regread(ROUTER_OP_LUT_RESET_CNTRS)); 
    printf("MAC_0_LOW\t\t\t|04\t|       %llx \t|\n", regread(ROUTER_OP_LUT_MAC_0_LO_REG));
    printf("MAC_0_HIGH\t\t\t|08\t|       %llx \t|\n", regread(ROUTER_OP_LUT_MAC_0_HI_REG));
    printf("MAC_1_LOW\t\t\t|0c\t|       %llx \t|\n", regread(ROUTER_OP_LUT_MAC_1_LO_REG));
    printf("MAC_1_HIGH\t\t\t|10\t|       %llx \t|\n", regread(ROUTER_OP_LUT_MAC_1_HI_REG));
    printf("MAC_2_LOW\t\t\t|14\t|       %llx \t|\n", regread(ROUTER_OP_LUT_MAC_2_LO_REG));
    printf("MAC_2_HIGH\t\t\t|18\t|       %llx \t|\n", regread(ROUTER_OP_LUT_MAC_2_HI_REG));
    printf("MAC_3_LOW\t\t\t|1c\t|       %llx \t|\n", regread(ROUTER_OP_LUT_MAC_3_LO_REG));
    printf("MAC_3_HIGH\t\t\t|20\t|       %llx \t|\n", regread(ROUTER_OP_LUT_MAC_3_HI_REG));

    printf("PKT_DROPPED_WRONG_DST_MAC\t|24\t|       %llx \t|\n", regread(ROUTER_OP_LUT_NUM_WRONG_DEST_REG)); 
    printf("PKT_SENT_CPU_LPM_MISS\t\t|28\t|       %llx \t|\n", regread(ROUTER_OP_LUT_LPM_NUM_MISSES_REG));
    printf("PKT_SENT_CPU_ARP_MISS\t\t|2c\t|       %llx \t|\n", regread(ROUTER_OP_LUT_ARP_NUM_MISSES_REG));
    printf("PKT_SENT_CPU_NON_IP\t\t|30\t|       %llx \t|\n", regread(ROUTER_OP_LUT_NUM_NON_IP_RCVD_REG));
    printf("PKT_DROPPED_CHECKSUM\t\t|34\t|       %llx \t|\n", regread(ROUTER_OP_LUT_NUM_BAD_CHKSUMS_REG));
    printf("PKT_FORWARDED\t\t\t|38\t|       %llx \t|\n", regread(ROUTER_OP_LUT_NUM_PKTS_FORWARDED_REG));
    printf("PKT_SENT_CPU_DEST_IP_HIT\t|3c\t|       %llx \t|\n", regread(ROUTER_OP_LUT_NUM_FILTERED_PKTS_REG));
    printf("PKT_SENT_TO_CPU_BAD_TTL\t\t|40\t|       %llx \t|\n", regread(ROUTER_OP_LUT_NUM_BAD_TTLS_REG));
    printf("PKT_SENT_CPU_OPTION_VER\t\t|44\t|       %llx \t|\n", regread(ROUTER_OP_LUT_NUM_BAD_OPTS_VER_REG));
    printf("PKT_SENT_FROM_CPU\t\t|48\t|       %llx \t|\n", regread(ROUTER_OP_LUT_NUM_CPU_PKTS_SENT_REG));
    printf("---------------------------------------------------------\n");


}
