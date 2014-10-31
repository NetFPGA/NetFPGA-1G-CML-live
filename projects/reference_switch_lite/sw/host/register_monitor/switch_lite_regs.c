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
    printf("|                      Interface registers                          |\n");
    printf("--------------------------------------------------------------------\n");
    printf("reg\t|      nf0       |      nf1       |      nf2     |       nf3|\n");
    printf("--------------------------------------------------------------------\n");
    printf("rst_counters\t|      %llx      |      %llx      |      %llx    |       %llx       |\n",    regread(XPAR_NF10_10G_INTERFACE_0_RESET_CNTRS),regread(XPAR_NF10_10G_INTERFACE_1_RESET_CNTRS),regread(XPAR_NF10_10G_INTERFACE_2_RESET_CNTRS),regread(XPAR_NF10_10G_INTERFACE_3_RESET_CNTRS));
    printf("bad_frames\t|       %llx     |      %llx      |      %llx    |       %llx       |\n", regread(XPAR_NF10_10G_INTERFACE_0_BAD_FRAMES_COUNTER),regread(XPAR_NF10_10G_INTERFACE_1_BAD_FRAMES_COUNTER),regread(XPAR_NF10_10G_INTERFACE_2_BAD_FRAMES_COUNTER),regread(XPAR_NF10_10G_INTERFACE_3_BAD_FRAMES_COUNTER));
    printf("good_frames\t|       %llx     |      %llx      |      %llx    |       %llx       |\n",   regread(XPAR_NF10_10G_INTERFACE_0_GOOD_FRAMES_COUNTER),regread(XPAR_NF10_10G_INTERFACE_1_GOOD_FRAMES_COUNTER),regread(XPAR_NF10_10G_INTERFACE_2_GOOD_FRAMES_COUNTER),regread(XPAR_NF10_10G_INTERFACE_3_GOOD_FRAMES_COUNTER));
    printf("bytes_from_mac\t|      %llx      |      %llx      |      %llx    |       %llx       |\n",regread(XPAR_NF10_10G_INTERFACE_0_BYTES_FROM_MAC),regread(XPAR_NF10_10G_INTERFACE_1_BYTES_FROM_MAC),regread(XPAR_NF10_10G_INTERFACE_2_BYTES_FROM_MAC),regread(XPAR_NF10_10G_INTERFACE_3_BYTES_FROM_MAC));
    printf("rx_enq_pkt\t|       %llx     |      %llx      |      %llx    |       %llx       |\n",  regread(XPAR_NF10_10G_INTERFACE_0_RX_ENQUEUED_PKTS),regread(XPAR_NF10_10G_INTERFACE_1_RX_ENQUEUED_PKTS),regread(XPAR_NF10_10G_INTERFACE_2_RX_ENQUEUED_PKTS),regread(XPAR_NF10_10G_INTERFACE_3_RX_ENQUEUED_PKTS));
    printf("rx_enq_bytes\t|       %llx     |      %llx      |      %llx    |       %llx       |\n",regread(XPAR_NF10_10G_INTERFACE_0_RX_ENQUEUED_BYTES),regread(XPAR_NF10_10G_INTERFACE_1_RX_ENQUEUED_BYTES),regread(XPAR_NF10_10G_INTERFACE_2_RX_ENQUEUED_BYTES),regread(XPAR_NF10_10G_INTERFACE_3_RX_ENQUEUED_BYTES));
    printf("rx_deq_pkt\t|       %llx     |      %llx      |      %llx    |       %llx       |\n",  regread(XPAR_NF10_10G_INTERFACE_0_RX_DEQUEUED_PKTS),regread(XPAR_NF10_10G_INTERFACE_1_RX_DEQUEUED_PKTS),regread(XPAR_NF10_10G_INTERFACE_2_RX_DEQUEUED_PKTS),regread(XPAR_NF10_10G_INTERFACE_3_RX_DEQUEUED_PKTS));
    printf("rx_deq_bytes\t|       %llx     |      %llx      |      %llx    |       %llx       |\n",regread(XPAR_NF10_10G_INTERFACE_0_RX_DEQUEUED_BYTES),regread(XPAR_NF10_10G_INTERFACE_1_RX_DEQUEUED_BYTES),regread(XPAR_NF10_10G_INTERFACE_2_RX_DEQUEUED_BYTES),regread(XPAR_NF10_10G_INTERFACE_3_RX_DEQUEUED_BYTES));
    printf("tx_enq_pkts\t|       %llx     |      %llx      |      %llx    |       %llx       |\n",regread(XPAR_NF10_10G_INTERFACE_0_TX_ENQUEUED_PKTS),regread(XPAR_NF10_10G_INTERFACE_1_TX_ENQUEUED_PKTS),regread(XPAR_NF10_10G_INTERFACE_2_TX_ENQUEUED_PKTS),regread(XPAR_NF10_10G_INTERFACE_3_TX_ENQUEUED_PKTS));
    printf("tx_enq_bytes\t|       %llx     |      %llx      |      %llx    |       %llx       |\n",regread(XPAR_NF10_10G_INTERFACE_0_TX_ENQUEUED_BYTES),regread(XPAR_NF10_10G_INTERFACE_1_TX_ENQUEUED_BYTES),regread(XPAR_NF10_10G_INTERFACE_2_TX_ENQUEUED_BYTES),regread(XPAR_NF10_10G_INTERFACE_3_TX_ENQUEUED_BYTES));
    printf("tx_deq_pkts\t|       %llx     |      %llx      |      %llx    |       %llx       |\n",  regread(XPAR_NF10_10G_INTERFACE_0_TX_DEQUEUED_PKTS),regread(XPAR_NF10_10G_INTERFACE_1_TX_DEQUEUED_PKTS),regread(XPAR_NF10_10G_INTERFACE_2_TX_DEQUEUED_PKTS),regread(XPAR_NF10_10G_INTERFACE_3_TX_DEQUEUED_PKTS));
    printf("tx_deq_bytes\t|       %llx     |      %llx      |      %llx    |       %llx       |\n",regread(XPAR_NF10_10G_INTERFACE_0_TX_DEQUEUED_BYTES),regread(XPAR_NF10_10G_INTERFACE_1_TX_DEQUEUED_BYTES),regread(XPAR_NF10_10G_INTERFACE_2_TX_DEQUEUED_BYTES),regread(XPAR_NF10_10G_INTERFACE_3_TX_DEQUEUED_BYTES));
    printf("pkts_in_rxq\t|       %llx     |      %llx      |      %llx    |       %llx       |\n",regread(XPAR_NF10_10G_INTERFACE_0_RX_PKTS_IN_QUEUE),regread(XPAR_NF10_10G_INTERFACE_1_RX_PKTS_IN_QUEUE),regread(XPAR_NF10_10G_INTERFACE_2_RX_PKTS_IN_QUEUE),regread(XPAR_NF10_10G_INTERFACE_3_RX_PKTS_IN_QUEUE));
    printf("bytes_in_rxq\t|       %llx     |      %llx      |      %llx    |       %llx       |\n",regread(XPAR_NF10_10G_INTERFACE_0_RX_BYTES_IN_QUEUE),regread(XPAR_NF10_10G_INTERFACE_1_RX_BYTES_IN_QUEUE),regread(XPAR_NF10_10G_INTERFACE_2_RX_BYTES_IN_QUEUE),regread(XPAR_NF10_10G_INTERFACE_3_RX_BYTES_IN_QUEUE));
    printf("pkts_in_txq\t|       %llx     |      %llx      |      %llx    |       %llx       |\n",regread(XPAR_NF10_10G_INTERFACE_0_TX_PKTS_IN_QUEUE),regread(XPAR_NF10_10G_INTERFACE_1_TX_PKTS_IN_QUEUE),regread(XPAR_NF10_10G_INTERFACE_2_TX_PKTS_IN_QUEUE),regread(XPAR_NF10_10G_INTERFACE_3_TX_PKTS_IN_QUEUE));
    printf("bytes_in_txq\t|       %llx     |      %llx      |      %llx    |       %llx       |\n",regread(XPAR_NF10_10G_INTERFACE_0_TX_BYTES_IN_QUEUE),regread(XPAR_NF10_10G_INTERFACE_1_TX_BYTES_IN_QUEUE),regread(XPAR_NF10_10G_INTERFACE_2_TX_BYTES_IN_QUEUE),regread(XPAR_NF10_10G_INTERFACE_3_TX_BYTES_IN_QUEUE)); 
    printf("rx_pkts_dropped\t|       %llx     |      %llx      |      %llx    |       %llx       |\n",regread(XPAR_NF10_10G_INTERFACE_0_RX_PKTS_DROPPED),regread(XPAR_NF10_10G_INTERFACE_1_RX_PKTS_DROPPED),regread(XPAR_NF10_10G_INTERFACE_2_RX_PKTS_DROPPED),regread(XPAR_NF10_10G_INTERFACE_3_RX_PKTS_DROPPED));
    printf("rx_bytes_dropped|       %llx     |      %llx      |      %llx    |       %llx       |\n",regread(XPAR_NF10_10G_INTERFACE_0_RX_BYTES_DROPPED),regread(XPAR_NF10_10G_INTERFACE_1_RX_BYTES_DROPPED),regread(XPAR_NF10_10G_INTERFACE_2_RX_BYTES_DROPPED),regread(XPAR_NF10_10G_INTERFACE_3_RX_BYTES_DROPPED));


    printf("\n");
    
    printf("--------------------------------------------------------------------\n");
    printf("|                      Input Arbiter registers                         |\n");
    printf("--------------------------------------------------------------------\n");

    printf("rst_counter\t|      %llx |\n",    regread(XPAR_NF10_INPUT_ARBITER_0_RESET_CNTRS));
    printf("pkts_processed\t|      %llx |\n",    regread(XPAR_NF10_INPUT_ARBITER_0_NUM_PKTS_PROCESSED));

    printf("\n");

    printf("---------------------------------------------------------\n");
    printf("|             Switch-lite pcore registers               |\n");
    printf("---------------------------------------------------------\n");
    printf("Type\t\t\t\t|offset |\tValue\t|\n");
    printf("---------------------------------------------------------\n");
    printf("RESET_CNTRS\t\t\t|00\t|       %llx \t|\n", regread(XPAR_NF10_SWITCH_OUTPUT_PORT_LOOKUP_0_RESET_CNTRS));
    printf("SWITCH_OP_LUT_NUM_HITS_REG\t|04\t|       %llx \t|\n", regread(XPAR_NF10_SWITCH_OUTPUT_PORT_LOOKUP_0_LUT_NUM_HITS_REG));
    printf("SWITCH_OP_LUT_NUM_MISSES_REG\t|08\t|       %llx \t|\n", regread(XPAR_NF10_SWITCH_OUTPUT_PORT_LOOKUP_0_LUT_NUM_MISSES_REG));
    printf("---------------------------------------------------------\n");
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
