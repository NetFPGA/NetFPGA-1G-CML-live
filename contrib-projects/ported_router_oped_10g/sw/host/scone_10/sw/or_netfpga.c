/*
 * Authors: David Erickson, Filip Paun, Gianni Antichi
 * Date: 14/2013
 *
 */

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <pcap.h>
#include <libnet.h>
#include <netlink/netlink.h>

#include "or_data_types.h"
#include "or_netfpga.h"
#include "or_output.h"
#include "or_main.h"
#include "def_router.h"
#include "nf10_reg_lib.h"
#include "sr_dumper.h"
#include "or_utils.h"

unsigned char getPortNumber(char* name) {
	if (strcmp(ETH0, name) == 0) {
		return 0;
	} else if (strcmp(ETH1, name) == 0) {
		return 1;
	} else if (strcmp(ETH2, name) == 0) {
		return 2;
	} else if (strcmp(ETH3, name) == 0) {
		return 3;
	} else {
		printf("FAILURE MATCHING PORT NAME TO NUMBER\n");
		assert(0);
	}

	return 0xFF;
}

unsigned int getOneHotPortNumber(char* name) {
	if (strcmp(ETH0, name) == 0) {
		return 1;
	} else if (strcmp(ETH1, name) == 0) {
		return 4;
	} else if (strcmp(ETH2, name) == 0) {
		return 16;
	} else if (strcmp(ETH3, name) == 0) {
		return 64;
	} else if (strcmp(CPU0, name) == 0) {
		return 2;
	} else if (strcmp(CPU1, name) == 0) {
		return 8;
	} else if (strcmp(CPU2, name) == 0) {
		return 32;
	} else if (strcmp(CPU3, name) == 0) {
		return 128;
	} else {
		printf("FAILURE MATCHING NAME TO ONE HOT PORT NUMBER\n");
		assert(0);
	}

	return 0;
}


void getIfaceFromOneHotPortNumber(char *name, unsigned int len, unsigned int port) {
	assert(name);

	switch(port) {
		case 1: strncpy(name, ETH0, len); break;
		case 2: strncpy(name, CPU0, len); break;
		case 4: strncpy(name, ETH1, len); break;
		case 8: strncpy(name, CPU1, len); break;
		case 16: strncpy(name, ETH2, len); break;
		case 32: strncpy(name, CPU2, len); break;
		case 64: strncpy(name, ETH3, len); break;
		case 128: strncpy(name, CPU3, len); break;
		default:
			//printf("FAILURE MATCHING ONE HOT PORT NUMBER TO NAME: %d\n", port);
			bzero(name, len);
			break;
	}
}

void netfpga_input(struct sr_instance* sr) {
	router_state* rs = get_router_state(sr);
	int i;
	char* internal_names[4] = {"eth0", "eth1", "eth2", "eth3"};

	/* setup select */
	fd_set read_set;
	FD_ZERO(&read_set);
	int READ_BUF_SIZE = 16384;
	unsigned char readBuf[READ_BUF_SIZE];

	while (1) {
		for (i = 0; i < 4; ++i) {
			FD_SET(rs->raw_sockets[i], &read_set);
		}

		struct timeval t;
		t.tv_usec = 500; // timeout every half a millisecond

		if (select(getMax(rs->raw_sockets, 4)+1, &read_set, NULL, NULL, NULL) < 0) {
			perror("select");
			exit(1);
		}

		for (i = 0; i < 4; ++i) {
			if (FD_ISSET(rs->raw_sockets[i], &read_set)) {
				// assume each read is a full packet
				int read_bytes = read(rs->raw_sockets[i], readBuf, READ_BUF_SIZE);

				/* log packet */
				pthread_mutex_lock(rs->log_dumper_mutex);
				sr_log_packet(sr, (unsigned char*)readBuf, read_bytes);
				pthread_mutex_unlock(rs->log_dumper_mutex);

				/* send packet */
				sr_integ_input(sr, readBuf, read_bytes, internal_names[i]);
			}
		}

	}

}

void netfpga_input_callback(unsigned char* arg, const struct pcap_pkthdr * pkt_hdr, unsigned char const* packet) {
	netfpga_input_arg* input_arg = (netfpga_input_arg*)arg;
	router_state* rs = input_arg->rs;
	struct sr_instance* sr = rs->sr;


	char* internal_names[4] = {"eth0", "eth1", "eth2", "eth3"};

	/* log packet */
	pthread_mutex_lock(rs->log_dumper_mutex);
	sr_log_packet(sr, (unsigned char*)packet, pkt_hdr->caplen);
	pthread_mutex_unlock(rs->log_dumper_mutex);

	/* send packet */
	sr_integ_input(sr, packet, pkt_hdr->caplen, internal_names[input_arg->interface_num]);
}


void netfpga_input_threaded_np(void* arg) {
	netfpga_input_threaded(arg);
}

void* netfpga_input_threaded(void* arg) {
/**
	netfpga_input_arg* input_arg = (netfpga_input_arg*)arg;
	router_state* rs = input_arg->rs;
	int rc;

	while (1) {
		if ((rc = pcap_dispatch(rs->pcap_context[input_arg->interface_num], -1, &netfpga_input_callback, (unsigned char*)arg)) == -1) {
			pcap_perror(rs->pcap_context[0], "failure calling dispatch");
			exit(1);
		}
	}
**/
}

int netfpga_output(struct sr_instance* sr, uint8_t* packet, unsigned int len, const char* iface) {
	router_state* rs = get_router_state(sr);
	int written_length = 0;
	int i = 0;

	/* log the packet */
	pthread_mutex_lock(rs->log_dumper_mutex);
	sr_log_packet(sr, packet, len);
	pthread_mutex_unlock(rs->log_dumper_mutex);


	char* internal_names[4] = {"eth0", "eth1", "eth2", "eth3"};
	for (i = 0; i < 4; ++i) {
		if (strcmp(iface, internal_names[i]) == 0) {
			break;
		}
	}

	/* setup select */
	fd_set write_set;
	FD_ZERO(&write_set);

	while (written_length < len) {
		FD_SET(rs->raw_sockets[i], &write_set);

		struct timeval t;
		t.tv_sec = 0;
		t.tv_usec = 500; // timeout every half a millisecond

		if (select(rs->raw_sockets[i]+1, NULL, &write_set, NULL, NULL) < 0) {
			perror("select");
			exit(1);
		}

		if (FD_ISSET(rs->raw_sockets[i], &write_set)) {
			int w = 0;
			if ((w = write(rs->raw_sockets[i], packet+written_length, len-written_length)) == -1) {
				perror("write");
				exit(1);
			}
			written_length += w;
		}

	}



	/*
	if ((written_length = libnet_adv_write_link((libnet_t*)rs->libnet_context[i], packet, len)) != len) {
		printf("Error writing packet using libnet, expected length: %i returned length: %i\n", len, written_length);
	}
	*/
	return 0;
}

unsigned get_rd_data_reg(unsigned int queue) {
	assert((0 <= queue) && (queue <= 3));
/*	switch(queue) {
		case 0: return CPU_REG_Q_0_RD_DATA_WORD_REG;
		case 1: return CPU_REG_Q_1_RD_DATA_WORD_REG;
		case 2: return CPU_REG_Q_2_RD_DATA_WORD_REG;
		case 3: return CPU_REG_Q_3_RD_DATA_WORD_REG;
		default: return 0;
	}
*/
}

unsigned get_rd_ctrl_reg(unsigned int queue) {
	assert((0 <= queue) && (queue <= 3));
/*	switch(queue) {
		case 0: return CPU_REG_Q_0_RD_CTRL_WORD_REG;
		case 1: return CPU_REG_Q_1_RD_CTRL_WORD_REG;
		case 2: return CPU_REG_Q_2_RD_CTRL_WORD_REG;
		case 3: return CPU_REG_Q_3_RD_CTRL_WORD_REG;
		default: return 0;
	}
*/
}

unsigned get_rd_num_of_words_avail_reg(unsigned int queue) {
	assert((0 <= queue) && (queue <= 3));
/*	switch(queue) {
		case 0: return CPU_REG_Q_0_RD_NUM_WORDS_AVAIL_REG;
		case 1: return CPU_REG_Q_1_RD_NUM_WORDS_AVAIL_REG;
		case 2: return CPU_REG_Q_2_RD_NUM_WORDS_AVAIL_REG;
		case 3: return CPU_REG_Q_3_RD_NUM_WORDS_AVAIL_REG;
		default: return 0;
	}
*/
}

unsigned get_rd_num_of_pckts_in_queue_reg(unsigned int queue) {
	assert((0 <= queue) && (queue <= 3));
/*	switch(queue) {
		case 0: return CPU_REG_Q_0_RD_NUM_PKTS_IN_Q_REG;
		case 1: return CPU_REG_Q_1_RD_NUM_PKTS_IN_Q_REG;
		case 2: return CPU_REG_Q_2_RD_NUM_PKTS_IN_Q_REG;
		case 3: return CPU_REG_Q_3_RD_NUM_PKTS_IN_Q_REG;
		default: return 0;
	}
*/
}



void get_incoming_interface(char *iface, unsigned int len, unsigned int queue) {
	assert((0 <= queue) && (queue <= 3));
	switch(queue) {
		case 0:
			bzero(iface, len);
			strncpy(iface, ETH0, len);
			break;
		case 1:
			bzero(iface, len);
			strncpy(iface, ETH1, len);
			break;
		case 2:
			bzero(iface, len);
			strncpy(iface, ETH2, len);
			break;
		case 3:
			bzero(iface, len);
			strncpy(iface, ETH3, len);
			break;
		default:
			bzero(iface, len);
			break;
	}
}

unsigned int get_wr_num_pkts_in_q(unsigned char port) {
	unsigned int retval = 0;
//	int err;
/*
	switch(port) {
		case 0:
        		err=nf10_reg_rd(CPU_REG_Q_0_WR_NUM_PKTS_IN_Q_REG, &retval);
        		if(err) printf("0x%08x: ERROR: %s\n", CPU_REG_Q_0_WR_NUM_PKTS_IN_Q_REG, nl_geterror(err));
			break;
		case 1:
                        err=nf10_reg_rd(CPU_REG_Q_1_WR_NUM_PKTS_IN_Q_REG, &retval);
                        if(err) printf("0x%08x: ERROR: %s\n", CPU_REG_Q_1_WR_NUM_PKTS_IN_Q_REG, nl_geterror(err));
			break;
		case 2:
                        err=nf10_reg_rd(CPU_REG_Q_2_WR_NUM_PKTS_IN_Q_REG, &retval);
                        if(err) printf("0x%08x: ERROR: %s\n", CPU_REG_Q_2_WR_NUM_PKTS_IN_Q_REG, nl_geterror(err));
			break;
		case 3:
                        err=nf10_reg_rd(CPU_REG_Q_3_WR_NUM_PKTS_IN_Q_REG, &retval);
                        if(err) printf("0x%08x: ERROR: %s\n", CPU_REG_Q_3_WR_NUM_PKTS_IN_Q_REG, nl_geterror(err));
			break;
	}
*/
	return retval;
}

unsigned int get_wr_num_words_left(unsigned char port) {
	unsigned int retval = 0;
//	int err;
/*
	switch(port) {
		case 0:
                        err=nf10_reg_rd(CPU_REG_Q_0_WR_NUM_PKTS_IN_Q_REG, &retval);
                        if(err) printf("0x%08x: ERROR: %s\n", CPU_REG_Q_0_WR_NUM_WORDS_LEFT_REG, nl_geterror(err));
			break;
		case 1:
                        err=nf10_reg_rd(CPU_REG_Q_1_WR_NUM_PKTS_IN_Q_REG, &retval);
                        if(err) printf("0x%08x: ERROR: %s\n", CPU_REG_Q_1_WR_NUM_WORDS_LEFT_REG, nl_geterror(err));
			break;
		case 2:
                        err=nf10_reg_rd(CPU_REG_Q_2_WR_NUM_PKTS_IN_Q_REG, &retval);
                        if(err) printf("0x%08x: ERROR: %s\n", CPU_REG_Q_2_WR_NUM_WORDS_LEFT_REG, nl_geterror(err));
			break;
		case 3:
                        err=nf10_reg_rd(CPU_REG_Q_3_WR_NUM_PKTS_IN_Q_REG, &retval);
                        if(err) printf("0x%08x: ERROR: %s\n", CPU_REG_Q_3_WR_NUM_WORDS_LEFT_REG, nl_geterror(err));
			break;
	}
*/
	return retval;
}

unsigned int set_wr_data_word(unsigned char port, unsigned int val) {
	int err = 0;
/*
	switch(port) {
		case 0:
        		err=nf10_reg_wr(CPU_REG_Q_0_WR_DATA_WORD_REG, val);
        		if(err) printf("0x%08x: ERROR: %s\n", CPU_REG_Q_0_WR_DATA_WORD_REG, nl_geterror(err));
			break;
		case 1:
                        err=nf10_reg_wr(CPU_REG_Q_1_WR_DATA_WORD_REG, val);
                        if(err) printf("0x%08x: ERROR: %s\n", CPU_REG_Q_1_WR_DATA_WORD_REG, nl_geterror(err));
			break;
		case 2:
                        err=nf10_reg_wr(CPU_REG_Q_2_WR_DATA_WORD_REG, val);
                        if(err) printf("0x%08x: ERROR: %s\n", CPU_REG_Q_2_WR_DATA_WORD_REG, nl_geterror(err));
			break;
		case 3:
                        err=nf10_reg_wr(CPU_REG_Q_3_WR_DATA_WORD_REG, val);
                        if(err) printf("0x%08x: ERROR: %s\n", CPU_REG_Q_3_WR_DATA_WORD_REG, nl_geterror(err));
			break;
	}
*/
	assert(!err);
	return err;
}

unsigned int set_wr_ctrl_word(unsigned char port, unsigned int val) {
	int err = 0;
/*	switch(port) {
		case 0:
			err=nf10_reg_wr(CPU_REG_Q_0_WR_CTRL_WORD_REG, val);
                        if(err) printf("0x%08x: ERROR: %s\n", CPU_REG_Q_0_WR_CTRL_WORD_REG, nl_geterror(err));
			break;
		case 1:
                        err=nf10_reg_wr(CPU_REG_Q_1_WR_CTRL_WORD_REG, val);
                        if(err) printf("0x%08x: ERROR: %s\n", CPU_REG_Q_1_WR_CTRL_WORD_REG, nl_geterror(err));
			break;
		case 2:
                        err=nf10_reg_wr(CPU_REG_Q_2_WR_CTRL_WORD_REG, val);
                        if(err) printf("0x%08x: ERROR: %s\n", CPU_REG_Q_2_WR_CTRL_WORD_REG, nl_geterror(err));
			break;
		case 3:
                        err=nf10_reg_wr(CPU_REG_Q_3_WR_CTRL_WORD_REG, val);
                        if(err) printf("0x%08x: ERROR: %s\n", CPU_REG_Q_3_WR_CTRL_WORD_REG, nl_geterror(err));
			break;
	}
*/
	assert(!err);
	return err;
}

/*
 * Stats thread for the NETFPGA Ports
 */
void* netfpga_stats(void* arg) {
	router_state* rs = (router_state*)arg;
	struct timeval now;
	uint32_t rx_packets, tx_packets, rx_bytes, tx_bytes;
	uint32_t packets_diff, bytes_diff;
	long double timeDiff;
	int i;

	while (1) {
    gettimeofday(&now, NULL);
		if (now.tv_sec == rs->stats_last_time.tv_sec) {
			/* must be a later usec time */
			timeDiff = (((long double)(now.tv_usec - rs->stats_last_time.tv_usec)) / (long double)1000000);
		} else {
			timeDiff = (now.tv_sec - rs->stats_last_time.tv_sec - 1) + ((long double)((1000000 - rs->stats_last_time.tv_usec) + now.tv_usec) / (long double)1000000);
		}

		lock_netfpga_stats(rs);

		for (i = 0; i < 8; ++i) {
			/* read all the values */
			rx_packets = get_rx_queue_num_pkts_received(i);
			tx_packets = get_tx_queue_num_pkts_sent(i);
			rx_bytes = get_rx_queue_num_bytes_received(i);
			tx_bytes = get_tx_queue_num_bytes_sent(i);

			/* compute differences */
			packets_diff = (rx_packets - rs->stats_last[i][0]) + (tx_packets - rs->stats_last[i][1]);
			bytes_diff = (rx_bytes - rs->stats_last[i][2]) + (tx_bytes - rs->stats_last[i][3]);

			/* bytes_diff will be in kB */
			bytes_diff /= 1000;

			/* update averages */
			rs->stats_avg[i][0] = ((double)packets_diff) / timeDiff;
			rs->stats_avg[i][1] = ((double)bytes_diff) / timeDiff;

			/* store data back */
			rs->stats_last[i][0] = rx_packets;
			rs->stats_last[i][1] = tx_packets;
			rs->stats_last[i][2] = rx_bytes;
			rs->stats_last[i][3] = tx_bytes;
			rs->stats_last_time = now;
		}

		unlock_netfpga_stats(rs);
		usleep(500000);
	}

	return NULL;
}

/* IS THREADSAFE */
void trigger_local_ip_filters_change(router_state* rs) {
	/* Bubble sort by name*/
	int swapped = 0;
	int err;

	lock_local_ip_filters(rs);

	do {
		swapped = 0;
		node* cur = rs->local_ip_filter_list;
		while (cur && cur->next) {
			local_ip_filter_entry* a = (local_ip_filter_entry*)cur->data;
			local_ip_filter_entry* b = (local_ip_filter_entry*)cur->next->data;
			if (strcmp(a->name, b->name) == 1) {
				cur->data = b;
				cur->next->data = a;
				swapped = 1;
			}

			cur = cur->next;
		}
	} while (swapped);

	/* write to hardware */
	if (rs->is_netfpga) {
		int i;
		node* cur = rs->local_ip_filter_list;
		for (i = 0; i < ROUTER_OP_LUT_DST_IP_FILTER_TABLE_DEPTH; ++i) {
			if (cur) {
				local_ip_filter_entry* entry = (local_ip_filter_entry*)cur->data;

				err=nf10_reg_wr(ROUTER_OP_LUT_DST_IP_FILTER_TABLE_ENTRY_IP_REG, ntohl(entry->ip.s_addr));
                        	if(err) printf("0x%08x: ERROR: %s\n", ROUTER_OP_LUT_DST_IP_FILTER_TABLE_ENTRY_IP_REG, nl_geterror(err));
                                err=nf10_reg_wr(ROUTER_OP_LUT_DST_IP_FILTER_TABLE_WR_ADDR_REG, i);
                                if(err) printf("0x%08x: ERROR: %s\n", ROUTER_OP_LUT_DST_IP_FILTER_TABLE_WR_ADDR_REG, nl_geterror(err));

				cur = cur->next;
			} else {
				/* zero them out */
                                err=nf10_reg_wr(ROUTER_OP_LUT_DST_IP_FILTER_TABLE_ENTRY_IP_REG, 0);
                                if(err) printf("0x%08x: ERROR: %s\n", ROUTER_OP_LUT_DST_IP_FILTER_TABLE_ENTRY_IP_REG, nl_geterror(err));
                                err=nf10_reg_wr(ROUTER_OP_LUT_DST_IP_FILTER_TABLE_WR_ADDR_REG, i);
                                if(err) printf("0x%08x: ERROR: %s\n", ROUTER_OP_LUT_DST_IP_FILTER_TABLE_WR_ADDR_REG, nl_geterror(err));
			}
		}
	}

	unlock_local_ip_filters(rs);
}

/*
 * IS THREADSAFE
 */
int add_local_ip_filter(router_state* rs, struct in_addr* ip, char* name) {
	if (get_local_ip_filter_by_ip(rs, ip) || get_local_ip_filter_by_name(rs, name)) {
		return 1;
	}

	node* cur = node_create();
	local_ip_filter_entry* entry = (local_ip_filter_entry*)calloc(1, sizeof(local_ip_filter_entry));
	strncpy(entry->name, name, (LOCAL_IP_FILTER_ENTRY_NAME_LEN - 1));
	entry->ip.s_addr = ip->s_addr;
	cur->data = entry;

	lock_local_ip_filters(rs);

	if (!rs->local_ip_filter_list) {
		rs->local_ip_filter_list = cur;
	} else {
		node_push_back(rs->local_ip_filter_list, cur);
	}

	unlock_local_ip_filters(rs);

	trigger_local_ip_filters_change(rs);

	return 0;
}

/*
 * NOT THREADSAFE, lock local_ip_filters mutex first
 */
local_ip_filter_entry* get_local_ip_filter_by_name(router_state*rs, char* name) {
	if (!name) {
		return NULL;
	}

	node* cur = rs->local_ip_filter_list;
	while (cur) {
		local_ip_filter_entry* entry = (local_ip_filter_entry*)cur->data;
		if (strcmp(entry->name, name) == 0) {
			return entry;
		}

		cur = cur->next;
	}

	return NULL;
}

/*
 * NOT THREADSAFE, lock local_ip_filters mutex first
 */
local_ip_filter_entry* get_local_ip_filter_by_ip(router_state*rs, struct in_addr* ip) {
	if (!ip) {
		return NULL;
	}

	node* cur = rs->local_ip_filter_list;
	while (cur) {
		local_ip_filter_entry* entry = (local_ip_filter_entry*)cur->data;
		if (entry->ip.s_addr == ip->s_addr) {
			return entry;
		}

		cur = cur->next;
	}

	return NULL;
}

void lock_local_ip_filters(router_state* rs) {
	pthread_mutex_lock(rs->local_ip_filter_list_mutex);
}

void unlock_local_ip_filters(router_state* rs) {
	pthread_mutex_unlock(rs->local_ip_filter_list_mutex);
}

void lock_netfpga_stats(router_state* rs) {
	pthread_mutex_lock(rs->stats_mutex);
}

void unlock_netfpga_stats(router_state* rs) {
	pthread_mutex_unlock(rs->stats_mutex);
}


unsigned int get_rx_queue_num_pkts_received(unsigned char port) {
	unsigned int retval = 0;
//	int err;
/*	switch(port) {
		case 0:
        		err=nf10_reg_rd(MAC_GRP_0_RX_QUEUE_NUM_PKTS_STORED_REG, &retval);
        		if(err) printf("0x%08x: ERROR: %s\n", MAC_GRP_0_RX_QUEUE_NUM_PKTS_STORED_REG, nl_geterror(err));
			break;
		case 1:
                        err=nf10_reg_rd(MAC_GRP_1_RX_QUEUE_NUM_PKTS_STORED_REG, &retval);
                        if(err) printf("0x%08x: ERROR: %s\n", MAC_GRP_1_RX_QUEUE_NUM_PKTS_STORED_REG, nl_geterror(err));
			break;
		case 2:
                        err=nf10_reg_rd(MAC_GRP_2_RX_QUEUE_NUM_PKTS_STORED_REG, &retval);
                        if(err) printf("0x%08x: ERROR: %s\n", MAC_GRP_2_RX_QUEUE_NUM_PKTS_STORED_REG, nl_geterror(err));
			break;
		case 3:
                        err=nf10_reg_rd(MAC_GRP_3_RX_QUEUE_NUM_PKTS_STORED_REG, &retval);
                        if(err) printf("0x%08x: ERROR: %s\n", MAC_GRP_3_RX_QUEUE_NUM_PKTS_STORED_REG, nl_geterror(err));
			break;
		case 4:
                        err=nf10_reg_rd(CPU_REG_Q_0_RX_NUM_PKTS_RCVD_REG, &retval);
                        if(err) printf("0x%08x: ERROR: %s\n", CPU_REG_Q_0_RX_NUM_PKTS_RCVD_REG, nl_geterror(err));
			break;
		case 5:
                        err=nf10_reg_rd(CPU_REG_Q_1_RX_NUM_PKTS_RCVD_REG, &retval);
                        if(err) printf("0x%08x: ERROR: %s\n", CPU_REG_Q_1_RX_NUM_PKTS_RCVD_REG, nl_geterror(err));
			break;
		case 6:
                        err=nf10_reg_rd(CPU_REG_Q_2_RX_NUM_PKTS_RCVD_REG, &retval);
                        if(err) printf("0x%08x: ERROR: %s\n", CPU_REG_Q_2_RX_NUM_PKTS_RCVD_REG, nl_geterror(err));
			break;
		case 7:
                        err=nf10_reg_rd(CPU_REG_Q_3_RX_NUM_PKTS_RCVD_REG, &retval);
                        if(err) printf("0x%08x: ERROR: %s\n", CPU_REG_Q_3_RX_NUM_PKTS_RCVD_REG, nl_geterror(err));
			break;
	}
*/
	return retval;
}

unsigned int get_tx_queue_num_pkts_sent(unsigned char port) {
	unsigned int retval = 0;
//	int err;
/*	switch(port) {
		case 0:
                        err=nf10_reg_rd(MAC_GRP_0_TX_QUEUE_NUM_PKTS_SENT_REG, &retval);
                        if(err) printf("0x%08x: ERROR: %s\n", MAC_GRP_0_TX_QUEUE_NUM_PKTS_SENT_REG, nl_geterror(err));
			break;
		case 1:
                        err=nf10_reg_rd(MAC_GRP_1_TX_QUEUE_NUM_PKTS_SENT_REG, &retval);
                        if(err) printf("0x%08x: ERROR: %s\n", MAC_GRP_1_TX_QUEUE_NUM_PKTS_SENT_REG, nl_geterror(err));
			break;
		case 2:
                        err=nf10_reg_rd(MAC_GRP_2_TX_QUEUE_NUM_PKTS_SENT_REG, &retval);
                        if(err) printf("0x%08x: ERROR: %s\n", MAC_GRP_2_TX_QUEUE_NUM_PKTS_SENT_REG, nl_geterror(err));
			break;
		case 3:
                        err=nf10_reg_rd(MAC_GRP_3_TX_QUEUE_NUM_PKTS_SENT_REG, &retval);
                        if(err) printf("0x%08x: ERROR: %s\n", MAC_GRP_3_TX_QUEUE_NUM_PKTS_SENT_REG, nl_geterror(err));
			break;
		case 4:
                        err=nf10_reg_rd(CPU_REG_Q_0_TX_NUM_PKTS_SENT_REG, &retval);
                        if(err) printf("0x%08x: ERROR: %s\n", CPU_REG_Q_0_TX_NUM_PKTS_SENT_REG, nl_geterror(err));
			break;
		case 5:
                        err=nf10_reg_rd(CPU_REG_Q_1_TX_NUM_PKTS_SENT_REG, &retval);
                        if(err) printf("0x%08x: ERROR: %s\n", CPU_REG_Q_1_TX_NUM_PKTS_SENT_REG, nl_geterror(err);
			break;
		case 6:
                        err=nf10_reg_rd(CPU_REG_Q_2_TX_NUM_PKTS_SENT_REG, &retval);
                        if(err) printf("0x%08x: ERROR: %s\n", CPU_REG_Q_2_TX_NUM_PKTS_SENT_REG, nl_geterror(err));
			break;
		case 7:
                        err=nf10_reg_rd(CPU_REG_Q_3_TX_NUM_PKTS_SENT_REG, &retval);
                        if(err) printf("0x%08x: ERROR: %s\n", CPU_REG_Q_3_TX_NUM_PKTS_SENT_REG, nl_geterror(err));
			break;
	}
*/
	return retval;
}
unsigned int get_rx_queue_num_bytes_received(unsigned char port) {
	unsigned int retval = 0;
//	int err;
/*	switch(port) {
		case 0:
                        err=nf10_reg_rd(MAC_GRP_0_RX_QUEUE_NUM_BYTES_PUSHED_REG, &retval);
                        if(err) printf("0x%08x: ERROR: %s\n", MAC_GRP_0_RX_QUEUE_NUM_BYTES_PUSHED_REG, nl_geterror(err));
			break;
		case 1:
                        err=nf10_reg_rd(MAC_GRP_1_RX_QUEUE_NUM_BYTES_PUSHED_REG, &retval);
                        if(err) printf("0x%08x: ERROR: %s\n", MAC_GRP_1_RX_QUEUE_NUM_BYTES_PUSHED_REG, nl_geterror(err));
			break;
		case 2:
                        err=nf10_reg_rd(MAC_GRP_2_RX_QUEUE_NUM_BYTES_PUSHED_REG, &retval);
                        if(err) printf("0x%08x: ERROR: %s\n", MAC_GRP_2_RX_QUEUE_NUM_BYTES_PUSHED_REG, nl_geterror(err));
			break;
		case 3:
                        err=nf10_reg_rd(MAC_GRP_3_RX_QUEUE_NUM_BYTES_PUSHED_REG, &retval);
                        if(err) printf("0x%08x: ERROR: %s\n", MAC_GRP_3_RX_QUEUE_NUM_BYTES_PUSHED_REG, nl_geterror(err));
			break;
		case 4:
                        err=nf10_reg_rd(CPU_REG_Q_0_RX_NUM_BYTES_RCVD_REG, &retval);
                        if(err) printf("0x%08x: ERROR: %s\n", CPU_REG_Q_0_RX_NUM_BYTES_RCVD_REG, nl_geterror(err));
			break;
		case 5:
                        err=nf10_reg_rd(CPU_REG_Q_1_RX_NUM_BYTES_RCVD_REG, &retval);
                        if(err) printf("0x%08x: ERROR: %s\n", CPU_REG_Q_1_RX_NUM_BYTES_RCVD_REG, nl_geterror(err));
			break;
		case 6:
                        err=nf10_reg_rd(CPU_REG_Q_2_RX_NUM_BYTES_RCVD_REG, &retval);
                        if(err) printf("0x%08x: ERROR: %s\n", CPU_REG_Q_2_RX_NUM_BYTES_RCVD_REG, nl_geterror(err));
			break;
		case 7:
                        err=nf10_reg_rd(CPU_REG_Q_3_RX_NUM_BYTES_RCVD_REG, &retval);
                        if(err) printf("0x%08x: ERROR: %s\n", CPU_REG_Q_3_RX_NUM_BYTES_RCVD_REG, nl_geterror(err));
			break;
	}
*/
	return retval;
}

unsigned int get_tx_queue_num_bytes_sent(unsigned char port) {
	unsigned int retval = 0;
//	int err;
/*	switch(port) {
		case 0:
                        err=nf10_reg_rd(MAC_GRP_0_TX_QUEUE_NUM_BYTES_PUSHED_REG, &retval);
                        if(err) printf("0x%08x: ERROR: %s\n", MAC_GRP_0_TX_QUEUE_NUM_BYTES_PUSHED_REG, nl_geterror(err));
			break;
		case 1:
                        err=nf10_reg_rd(MAC_GRP_1_TX_QUEUE_NUM_BYTES_PUSHED_REG, &retval);
                        if(err) printf("0x%08x: ERROR: %s\n", MAC_GRP_1_TX_QUEUE_NUM_BYTES_PUSHED_REG, nl_geterror(err));
			break;
		case 2:
                        err=nf10_reg_rd(MAC_GRP_2_TX_QUEUE_NUM_BYTES_PUSHED_REG, &retval);
                        if(err) printf("0x%08x: ERROR: %s\n", MAC_GRP_2_TX_QUEUE_NUM_BYTES_PUSHED_REG, nl_geterror(err));
			break;
		case 3:
                        err=nf10_reg_rd(MAC_GRP_3_TX_QUEUE_NUM_BYTES_PUSHED_REG, &retval);
                        if(err) printf("0x%08x: ERROR: %s\n", MAC_GRP_3_TX_QUEUE_NUM_BYTES_PUSHED_REG, nl_geterror(err));
			break;
		case 4:
                        err=nf10_reg_rd(CPU_REG_Q_0_TX_NUM_BYTES_SENT_REG, &retval);
                        if(err) printf("0x%08x: ERROR: %s\n", CPU_REG_Q_0_TX_NUM_BYTES_SENT_REG, nl_geterror(err));
			break;
		case 5:
                        err=nf10_reg_rd(CPU_REG_Q_1_TX_NUM_BYTES_SENT_REG, &retval);
                        if(err) printf("0x%08x: ERROR: %s\n", CPU_REG_Q_1_TX_NUM_BYTES_SENT_REG, nl_geterror(err));
			break;
		case 6:
                        err=nf10_reg_rd(CPU_REG_Q_2_TX_NUM_BYTES_SENT_REG, &retval);
                        if(err) printf("0x%08x: ERROR: %s\n", CPU_REG_Q_2_TX_NUM_BYTES_SENT_REG, nl_geterror(err));
			break;
		case 7:
                        err=nf10_reg_rd(CPU_REG_Q_3_TX_NUM_BYTES_SENT_REG, &retval);
                        if(err) printf("0x%08x: ERROR: %s\n", CPU_REG_Q_3_TX_NUM_BYTES_SENT_REG, nl_geterror(err));

	}			break;
*/

	return retval;
}

unsigned int get_rx_queue_num_pkts_dropped_full(unsigned char port) {
	unsigned int retval = 0;
//	int err;
/*	switch(port) {
		case 0:
                        err=nf10_reg_rd(MAC_GRP_0_RX_QUEUE_NUM_PKTS_DROPPED_FULL_REG, &retval);
                        if(err) printf("0x%08x: ERROR: %s\n", MAC_GRP_0_RX_QUEUE_NUM_PKTS_DROPPED_FULL_REG, nl_geterror(err));
			break;
		case 1:
                        err=nf10_reg_rd(MAC_GRP_1_RX_QUEUE_NUM_PKTS_DROPPED_FULL_REG, &retval);
                        if(err) printf("0x%08x: ERROR: %s\n", MAC_GRP_1_RX_QUEUE_NUM_PKTS_DROPPED_FULL_REG, nl_geterror(err));
			break;
		case 2:
                        err=nf10_reg_rd(MAC_GRP_2_RX_QUEUE_NUM_PKTS_DROPPED_FULL_REG, &retval);
                        if(err) printf("0x%08x: ERROR: %s\n", MAC_GRP_2_RX_QUEUE_NUM_PKTS_DROPPED_FULL_REG, nl_geterror(err));
			break;
		case 3:
                        err=nf10_reg_rd(MAC_GRP_3_RX_QUEUE_NUM_PKTS_DROPPED_FULL_REG, &retval);
                        if(err) printf("0x%08x: ERROR: %s\n", MAC_GRP_3_RX_QUEUE_NUM_PKTS_DROPPED_FULL_REG, nl_geterror(err));
			break;
	}
*/
	return retval;
}

unsigned int get_rx_queue_num_pkts_dropped_bad(unsigned char port) {
	unsigned int retval = 0;
//	int err;
/*	switch(port) {
		case 0:
                        err=nf10_reg_rd(MAC_GRP_0_RX_QUEUE_NUM_PKTS_DROPPED_BAD_REG, &retval);
                        if(err) printf("0x%08x: ERROR: %s\n", MAC_GRP_0_RX_QUEUE_NUM_PKTS_DROPPED_BAD_REG, nl_geterror(err));
			break;
		case 1:
                        err=nf10_reg_rd(MAC_GRP_1_RX_QUEUE_NUM_PKTS_DROPPED_BAD_REG, &retval);
                        if(err) printf("0x%08x: ERROR: %s\n", MAC_GRP_1_RX_QUEUE_NUM_PKTS_DROPPED_BAD_REG, nl_geterror(err));
			break;
		case 2:
                        err=nf10_reg_rd(MAC_GRP_2_RX_QUEUE_NUM_PKTS_DROPPED_BAD_REG, &retval);
                        if(err) printf("0x%08x: ERROR: %s\n", MAC_GRP_2_RX_QUEUE_NUM_PKTS_DROPPED_BAD_REG, nl_geterror(err));
			break;
		case 3:
                        err=nf10_reg_rd(MAC_GRP_3_RX_QUEUE_NUM_PKTS_DROPPED_BAD_REG, &retval);
                        if(err) printf("0x%08x: ERROR: %s\n", MAC_GRP_3_RX_QUEUE_NUM_PKTS_DROPPED_BAD_REG, nl_geterror(err));
			break;
	}
*/
	return retval;
}

unsigned int get_oq_num_pkts_dropped(unsigned char port) {
	unsigned int retval = 0;
//	int err;
/*	switch(port) {
		case 0:
                        err=nf10_reg_rd(OQ_QUEUE_0_NUM_PKTS_DROPPED_REG, &retval);
                        if(err) printf("0x%08x: ERROR: %s\n", OQ_QUEUE_0_NUM_PKTS_DROPPED_REG, nl_geterror(err));
			break;
		case 1:
                        err=nf10_reg_rd(OQ_QUEUE_1_NUM_PKTS_DROPPED_REG, &retval);
                        if(err) printf("0x%08x: ERROR: %s\n", OQ_QUEUE_1_NUM_PKTS_DROPPED_REG, nl_geterror(err));
			break;
		case 2:
                        err=nf10_reg_rd(OQ_QUEUE_2_NUM_PKTS_DROPPED_REG, &retval);
                        if(err) printf("0x%08x: ERROR: %s\n", OQ_QUEUE_2_NUM_PKTS_DROPPED_REG, nl_geterror(err));
			break;
		case 3:
                        err=nf10_reg_rd(OQ_QUEUE_3_NUM_PKTS_DROPPED_REG, &retval);
                        if(err) printf("0x%08x: ERROR: %s\n", OQ_QUEUE_3_NUM_PKTS_DROPPED_REG, nl_geterror(err));
			break;
		case 4:
                        err=nf10_reg_rd(OQ_QUEUE_4_NUM_PKTS_DROPPED_REG, &retval);
                        if(err) printf("0x%08x: ERROR: %s\n", OQ_QUEUE_4_NUM_PKTS_DROPPED_REG, nl_geterror(err));
			break;
		case 5:
                        err=nf10_reg_rd(OQ_QUEUE_5_NUM_PKTS_DROPPED_REG, &retval);
                        if(err) printf("0x%08x: ERROR: %s\n", OQ_QUEUE_5_NUM_PKTS_DROPPED_REG, nl_geterror(err));
			break;
		case 6:
                        err=nf10_reg_rd(OQ_QUEUE_6_NUM_PKTS_DROPPED_REG, &retval);
                        if(err) printf("0x%08x: ERROR: %s\n", OQ_QUEUE_6_NUM_PKTS_DROPPED_REG, nl_geterror(err));
			break;
		case 7:
                        err=nf10_reg_rd(OQ_QUEUE_7_NUM_PKTS_DROPPED_REG, &retval);
                        if(err) printf("0x%08x: ERROR: %s\n", OQ_QUEUE_7_NUM_PKTS_DROPPED_REG, nl_geterror(err));
			break;
	}
*/
	return retval;
}

void cli_hw_info(router_state *rs, cli_request *req) {

	if(rs->is_netfpga) {
		char *info;
		unsigned int len;
		int err;

		info = "HW STATS\n";
		send_to_socket(req->sockfd, info, strlen(info));

		sprint_hw_stats(rs, &info, &len);
		send_to_socket(req->sockfd, info, len);
		free(info);

		info = "\nHW DROPS\n";
		send_to_socket(req->sockfd, info, strlen(info));

		sprint_hw_drops(rs, &info, &len);
		send_to_socket(req->sockfd, info, len);
		free(info);

		sprint_hw_oq_drops(rs, &info, &len);
		send_to_socket(req->sockfd, info, len);
		free(info);

		info = "\nHW IFACE INFO\n";
		send_to_socket(req->sockfd, info, strlen(info));

		sprint_hw_iface(rs, &info, &len);
		send_to_socket(req->sockfd, info, len);
		free(info);

		info = "\nHW IP FILTERS INFO\n";
		send_to_socket(req->sockfd, info, strlen(info));

		sprint_hw_local_ip_filter(rs, &info, &len);
		send_to_socket(req->sockfd, info, len);
		free(info);

		info = "\nHW RTABLE INFO\n";
		send_to_socket(req->sockfd, info, strlen(info));

		sprint_hw_rtable(&info, &len);
		send_to_socket(req->sockfd, info, len);
		free(info);


		info = "\nHW ARP CACHE INFO\n";
		send_to_socket(req->sockfd, info, strlen(info));

		sprint_hw_arp_cache(&info, &len);
		send_to_socket(req->sockfd, info, len);
		free(info);

		unsigned int misses = 0;
                err=nf10_reg_rd(ROUTER_OP_LUT_ARP_NUM_MISSES_REG, &misses);
                if(err) printf("0x%08x: ERROR: %s\n", ROUTER_OP_LUT_ARP_NUM_MISSES_REG, nl_geterror(err));

	        info = (char *)calloc(80, sizeof(char));
	        snprintf(info, 80, "\nHW ARP CACHE MISSES: %d\n", misses);
	        send_to_socket(req->sockfd, info, strlen(info));
	        free(info);

		unsigned int number = 0;
                err=nf10_reg_rd(ROUTER_OP_LUT_NUM_PKTS_FORWARDED_REG, &number);
                if(err) printf("0x%08x: ERROR: %s\n", ROUTER_OP_LUT_NUM_PKTS_FORWARDED_REG, nl_geterror(err));

                info = (char *)calloc(80, sizeof(char));
                snprintf(info, 80, "HW NUMBER OF PACKETS FORWARDED: %d\n", number);
                send_to_socket(req->sockfd, info, strlen(info));
                free(info);

	}
}
