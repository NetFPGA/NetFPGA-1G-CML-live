#include <fcntl.h>
#include <sys/ioctl.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdlib.h>
#include "../../../../../tools/lib/nf10_lib.c"
#include "../reg_defines.h"

int main(){


    printf("--------------------------------------------------------------------\n");
    printf("|                      Input Arbiter registers                         |\n");
    printf("--------------------------------------------------------------------\n");

    printf("rst_counter\t|      %llx |\n",    regread(XPAR_NF10_INPUT_ARBITER_0_RESET_CNTRS));
    printf("pkts_processed\t|      %llx |\n",    regread(XPAR_NF10_INPUT_ARBITER_0_NUM_PKTS_PROCESSED));

    printf("\n");

    printf("--------------------------------------------------------------------------------------------\n");
    printf("|                      Output Queues registers                                              |\n");
    printf("--------------------------------------------------------------------------------------------\n");
    printf("interface\t|      nf0       |      nf1       |      nf2     |      nf3     |   host     |\n");
    printf("--------------------------------------------------------------------------------------------\n");
 
    printf("rst_counter\t|      %llx      |\n",    regread(XPAR_NF10_BRAM_OUTPUT_QUEUES_0_RESET_CNTRS));
    printf("pkts_stored\t|       %llx     |      %llx      |      %llx    |       %llx       |       %llx       |\n",    regread(XPAR_NF10_BRAM_OUTPUT_QUEUES_0_PKT_STORED_PORT_0),regread(XPAR_NF10_BRAM_OUTPUT_QUEUES_0_PKT_STORED_PORT_1),regread(XPAR_NF10_BRAM_OUTPUT_QUEUES_0_PKT_STORED_PORT_2),regread(XPAR_NF10_BRAM_OUTPUT_QUEUES_0_PKT_STORED_PORT_3),regread(XPAR_NF10_BRAM_OUTPUT_QUEUES_0_PKT_STORED_PORT_4));
    printf("bytes_stored\t|       %llx     |      %llx      |      %llx    |       %llx       |       %llx       |\n",   regread(XPAR_NF10_BRAM_OUTPUT_QUEUES_0_BYTES_STORED_PORT_0),regread(XPAR_NF10_BRAM_OUTPUT_QUEUES_0_BYTES_STORED_PORT_1),regread(XPAR_NF10_BRAM_OUTPUT_QUEUES_0_BYTES_STORED_PORT_2),regread(XPAR_NF10_BRAM_OUTPUT_QUEUES_0_BYTES_STORED_PORT_3),regread(XPAR_NF10_BRAM_OUTPUT_QUEUES_0_BYTES_STORED_PORT_4));
    printf("pkts_removed\t|      %llx      |      %llx      |      %llx    |       %llx       |       %llx       |\n",   regread(XPAR_NF10_BRAM_OUTPUT_QUEUES_0_PKT_REMOVED_PORT_0),regread(XPAR_NF10_BRAM_OUTPUT_QUEUES_0_PKT_REMOVED_PORT_1),regread(XPAR_NF10_BRAM_OUTPUT_QUEUES_0_PKT_REMOVED_PORT_2),regread(XPAR_NF10_BRAM_OUTPUT_QUEUES_0_PKT_REMOVED_PORT_3),regread(XPAR_NF10_BRAM_OUTPUT_QUEUES_0_PKT_REMOVED_PORT_4));
    printf("bytes_removed\t|       %llx     |      %llx      |      %llx    |       %llx       |       %llx       |\n",  regread(XPAR_NF10_BRAM_OUTPUT_QUEUES_0_BYTES_REMOVED_PORT_0),regread(XPAR_NF10_BRAM_OUTPUT_QUEUES_0_BYTES_REMOVED_PORT_1),regread(XPAR_NF10_BRAM_OUTPUT_QUEUES_0_BYTES_REMOVED_PORT_2),regread(XPAR_NF10_BRAM_OUTPUT_QUEUES_0_BYTES_REMOVED_PORT_3),regread(XPAR_NF10_BRAM_OUTPUT_QUEUES_0_BYTES_REMOVED_PORT_4));
    printf("pkts_dropped\t|       %llx     |      %llx      |      %llx    |       %llx       |       %llx       |\n",   regread(XPAR_NF10_BRAM_OUTPUT_QUEUES_0_PKT_DROPPED_PORT_0),regread(XPAR_NF10_BRAM_OUTPUT_QUEUES_0_PKT_DROPPED_PORT_1),regread(XPAR_NF10_BRAM_OUTPUT_QUEUES_0_PKT_DROPPED_PORT_2),regread(XPAR_NF10_BRAM_OUTPUT_QUEUES_0_PKT_DROPPED_PORT_3),regread(XPAR_NF10_BRAM_OUTPUT_QUEUES_0_PKT_DROPPED_PORT_4));
    printf("bytes_dropped\t|       %llx     |      %llx      |      %llx    |       %llx       |       %llx       |\n",  regread(XPAR_NF10_BRAM_OUTPUT_QUEUES_0_BYTES_DROPPED_PORT_0),regread(XPAR_NF10_BRAM_OUTPUT_QUEUES_0_BYTES_DROPPED_PORT_1),regread(XPAR_NF10_BRAM_OUTPUT_QUEUES_0_BYTES_DROPPED_PORT_2),regread(XPAR_NF10_BRAM_OUTPUT_QUEUES_0_BYTES_DROPPED_PORT_3),regread(XPAR_NF10_BRAM_OUTPUT_QUEUES_0_BYTES_DROPPED_PORT_4));
    printf("pkts_in_queue\t|       %llx     |      %llx      |      %llx    |       %llx       |       %llx       |\n",  regread(XPAR_NF10_BRAM_OUTPUT_QUEUES_0_PKT_IN_QUEUE_PORT_0),regread(XPAR_NF10_BRAM_OUTPUT_QUEUES_0_PKT_IN_QUEUE_PORT_1),regread(XPAR_NF10_BRAM_OUTPUT_QUEUES_0_PKT_IN_QUEUE_PORT_2),regread(XPAR_NF10_BRAM_OUTPUT_QUEUES_0_PKT_IN_QUEUE_PORT_3),regread(XPAR_NF10_BRAM_OUTPUT_QUEUES_0_PKT_IN_QUEUE_PORT_4));
    printf("bytes_in_queue\t|       %llx     |      %llx      |      %llx    |       %llx       |       %llx       |\n", regread(XPAR_NF10_BRAM_OUTPUT_QUEUES_0_BYTES_IN_QUEUE_PORT_0),regread(XPAR_NF10_BRAM_OUTPUT_QUEUES_0_PKT_IN_QUEUE_PORT_1),regread(XPAR_NF10_BRAM_OUTPUT_QUEUES_0_PKT_IN_QUEUE_PORT_2),regread(XPAR_NF10_BRAM_OUTPUT_QUEUES_0_PKT_IN_QUEUE_PORT_3),regread(XPAR_NF10_BRAM_OUTPUT_QUEUES_0_PKT_IN_QUEUE_PORT_4));

}

