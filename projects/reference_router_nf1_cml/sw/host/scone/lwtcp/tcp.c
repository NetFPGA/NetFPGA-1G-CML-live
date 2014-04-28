/*
 * Copyright (c) 2001, Swedish Institute of Computer Science.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. Neither the name of the Institute nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE INSTITUTE AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE INSTITUTE OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 * This file is part of the lwIP TCP/IP stack.
 *
 * Author: Adam Dunkels <adam@sics.se>
 *
 * $Id: tcp.c 2430 2007-04-06 22:29:40Z paun $
 */

/*-----------------------------------------------------------------------------------*/
/* tcp.c
 *
 * This file contains common functions for the TCP implementation, such as functinos
 * for manipulating the data structures and the TCP timer functions. TCP functions
 * related to input and output is found in tcp_input.c and tcp_output.c respectively.
 *
 */
/*-----------------------------------------------------------------------------------*/

#include "lwip/debug.h"

#include "lwip/def.h"
#include "lwip/mem.h"
#include "lwip/memp.h"

#include "lwip/tcp.h"

/* Incremented every coarse grained timer shot
   (typically every 500 ms, determined by TCP_COARSE_TIMEOUT). */
uint32_t tcp_ticks;
const uint8_t tcp_backoff[13] =
    { 1, 2, 4, 8, 16, 32, 64, 64, 64, 64, 64, 64, 64 };

/* The TCP PCB lists. */
struct tcp_pcb_listen *tcp_listen_pcbs;  /* List of all TCP PCBs in LISTEN state. */
struct tcp_pcb *tcp_active_pcbs;  /* List of all TCP PCBs that are in a
				 state in which they accept or send
				 data. */
struct tcp_pcb *tcp_tw_pcbs;      /* List of all TCP PCBs in TIME-WAIT. */

struct tcp_pcb *tcp_tmp_pcb;

#define MIN(x,y) (x) < (y)? (x): (y)

#if MEMP_RECLAIM
static uint8_t tcp_memp_reclaim(void *arg, memp_t type);
#endif
#if MEM_RECLAIM
static mem_size_t tcp_mem_reclaim(void *arg, mem_size_t size);
#endif

static uint8_t tcp_timer;

/*-----------------------------------------------------------------------------------*/
/*
 * tcp_init():
 *
 * Initializes the TCP layer.
 */
/*-----------------------------------------------------------------------------------*/
void
tcp_init(void)
{
  /* Clear globals. */
  tcp_listen_pcbs = NULL;
  tcp_active_pcbs = NULL;
  tcp_tw_pcbs = NULL;
  tcp_tmp_pcb = NULL;

  /* Register memory reclaim function */
#if MEM_RECLAIM
  mem_register_reclaim((mem_reclaim_func)tcp_mem_reclaim, NULL);
#endif /* MEM_RECLAIM */

#if MEMP_RECLAIM
  memp_register_reclaim(MEMP_PBUF, (memp_reclaim_func)tcp_memp_reclaim, NULL);
  memp_register_reclaim(MEMP_TCP_SEG, (memp_reclaim_func)tcp_memp_reclaim, NULL);
  memp_register_reclaim(MEMP_TCP_PCB, (memp_reclaim_func)tcp_memp_reclaim, NULL);
#endif /* MEMP_RECLAIM */

  /* initialize timer */
  tcp_ticks = 0;
  tcp_timer = 0;

}
/*-----------------------------------------------------------------------------------*/
/*
 * tcp_tmr():
 *
 * Called periodically to dispatch TCP timers.
 *
 */
/*-----------------------------------------------------------------------------------*/
void
tcp_tmr()
{
  ++tcp_timer;
  if(tcp_timer == 10) {
    tcp_timer = 0;
  }

  if(tcp_timer & 1) {
    /* Call tcp_fasttmr() every 200 ms, i.e., every other timer
       tcp_tmr() is called. */
    tcp_fasttmr();
  }
  if(tcp_timer == 0 || tcp_timer == 5) {
    /* Call tcp_slowtmr() every 500 ms, i.e., every fifth timer
       tcp_tmr() is called. */
    tcp_slowtmr();
  }
}
/*-----------------------------------------------------------------------------------*/
/*
 * tcp_close():
 *
 * Closes the connection held by the PCB.
 *
 */
/*-----------------------------------------------------------------------------------*/
err_t
tcp_close(struct tcp_pcb *pcb)
{
  err_t err;

#if TCP_DEBUG
  DEBUGF(TCP_DEBUG, ("tcp_close: closing in state "));
  tcp_debug_print_state(pcb->state);
  DEBUGF(TCP_DEBUG, ("\n"));
#endif /* TCP_DEBUG */
  switch(pcb->state) {
  case LISTEN:
    err = ERR_OK;
    tcp_pcb_remove((struct tcp_pcb **)&tcp_listen_pcbs, pcb);
    memp_free(MEMP_TCP_PCB_LISTEN, pcb);
    pcb = NULL;
    break;
  case SYN_SENT:
    err = ERR_OK;
    tcp_pcb_remove(&tcp_active_pcbs, pcb);
    memp_free(MEMP_TCP_PCB, pcb);
    pcb = NULL;
    break;
  case SYN_RCVD:
    err = tcp_send_ctrl(pcb, TCP_FIN);
    if(err == ERR_OK) {
      pcb->state = FIN_WAIT_1;
    }
    break;
  case ESTABLISHED:
    err = tcp_send_ctrl(pcb, TCP_FIN);
    if(err == ERR_OK) {
      pcb->state = FIN_WAIT_1;
    }
    break;
  case CLOSE_WAIT:
    err = tcp_send_ctrl(pcb, TCP_FIN);
    if(err == ERR_OK) {
      pcb->state = LAST_ACK;
    }
    break;
  default:
    /* Has already been closed, do nothing. */
    err = ERR_OK;
    pcb = NULL;
    break;
  }

  if(pcb != NULL && err == ERR_OK) {
    err = tcp_output(pcb);
  }
  return err;
}
/*-----------------------------------------------------------------------------------*/
/*
 * tcp_abort()
 *
 * Aborts a connection by sending a RST to the remote host and deletes
 * the local protocol control block. This is done when a connection is
 * killed because of shortage of memory.
 *
 */
/*-----------------------------------------------------------------------------------*/
void
tcp_abort(struct tcp_pcb *pcb)
{
  uint32_t seqno, ackno;
  uint16_t remote_port, local_port;
  struct ip_addr remote_ip, local_ip;
  void (* errf)(void *arg, err_t err);
  void *errf_arg;


  /* Figure out on which TCP PCB list we are, and remove us. If we
     are in an active state, call the receive function associated with
     the PCB with a NULL argument, and send an RST to the remote end. */
  if(pcb->state == TIME_WAIT) {
    tcp_pcb_remove(&tcp_tw_pcbs, pcb);
    memp_free(MEMP_TCP_PCB, pcb);
  } else if(pcb->state == LISTEN) {
    tcp_pcb_remove((struct tcp_pcb **)&tcp_listen_pcbs, pcb);
    memp_free(MEMP_TCP_PCB_LISTEN, pcb);
  } else {
    seqno = pcb->snd_nxt;
    ackno = pcb->rcv_nxt;
    ip_addr_set(&local_ip, &(pcb->local_ip));
    ip_addr_set(&remote_ip, &(pcb->remote_ip));
    local_port = pcb->local_port;
    remote_port = pcb->remote_port;
    errf = pcb->errf;
    errf_arg = pcb->callback_arg;
    tcp_pcb_remove(&tcp_active_pcbs, pcb);
    memp_free(MEMP_TCP_PCB, pcb);
    if(errf != NULL) {
      errf(errf_arg, ERR_ABRT);
    }
    DEBUGF(TCP_RST_DEBUG, ("tcp_abort: sending RST\n"));
    tcp_rst(seqno, ackno, &local_ip, &remote_ip, local_port, remote_port);
  }
}
/*-----------------------------------------------------------------------------------*/
/*
 * tcp_bind():
 *
 * Binds the connection to a local portnumber and IP address. If the
 * IP address is not given (i.e., ipaddr == NULL), the IP address of
 * the outgoing network interface is used instead.
 *
 */
/*-----------------------------------------------------------------------------------*/
err_t
tcp_bind(struct tcp_pcb *pcb, struct ip_addr *ipaddr, uint16_t port)
{
  struct tcp_pcb *cpcb;

  /* Check if the address already is in use. */
  for(cpcb = (struct tcp_pcb *)tcp_listen_pcbs;
      cpcb != NULL; cpcb = cpcb->next) {
    if(cpcb->local_port == port) {
      if(ip_addr_isany(&(cpcb->local_ip)) ||
	 ip_addr_isany(ipaddr) ||
	 ip_addr_cmp(&(cpcb->local_ip), ipaddr)) {
	return ERR_USE;
      }
    }
  }
  for(cpcb = tcp_active_pcbs;
      cpcb != NULL; cpcb = cpcb->next) {
    if(cpcb->local_port == port) {
      if(ip_addr_isany(&(cpcb->local_ip)) ||
	 ip_addr_isany(ipaddr) ||
	 ip_addr_cmp(&(cpcb->local_ip), ipaddr)) {
	return ERR_USE;
      }
    }
  }
  if(!ip_addr_isany(ipaddr)) {
    pcb->local_ip = *ipaddr;
  }
  pcb->local_port = port;
  DEBUGF(TCP_DEBUG, ("tcp_bind: bind to port %d\n", port));
  return ERR_OK;
}
/*-----------------------------------------------------------------------------------*/
/*
 * tcp_listen():
 *
 * Set the state of the connection to be LISTEN, which means that it
 * is able to accept incoming connections. The protocol control block
 * is reallocated in order to consume less memory. Setting the
 * connection to LISTEN is an irreversible process.
 *
 */
/*-----------------------------------------------------------------------------------*/
struct tcp_pcb *
tcp_listen(struct tcp_pcb *pcb)
{
  pcb->state = LISTEN;
  pcb = (struct tcp_pcb*)memp_realloc(MEMP_TCP_PCB, MEMP_TCP_PCB_LISTEN, pcb);
  if(pcb == NULL) {
    return NULL;
  }
  TCP_REG((struct tcp_pcb **)&tcp_listen_pcbs, pcb);
  return pcb;
}
/*-----------------------------------------------------------------------------------*/
/*
 * tcp_recved():
 *
 * This function should be called by the application when it has
 * processed the data. The purpose is to advertise a larger window
 * when the data has been processed.
 *
 */
/*-----------------------------------------------------------------------------------*/
void
tcp_recved(struct tcp_pcb *pcb, uint16_t len)
{
  pcb->rcv_wnd += len;
  if(pcb->rcv_wnd > TCP_WND) {
    pcb->rcv_wnd = TCP_WND;
  }
  if(!(pcb->flags & TF_ACK_DELAY) ||
     !(pcb->flags & TF_ACK_NOW)) {
    tcp_ack(pcb);
  }
  DEBUGF(TCP_DEBUG, ("tcp_recved: recveived %d bytes, wnd %u (%u).\n",
		     len, pcb->rcv_wnd, TCP_WND - pcb->rcv_wnd));
}
/*-----------------------------------------------------------------------------------*/
/*
 * tcp_new_port():
 *
 * A nastly hack featuring 'goto' statements that allocates a
 * new TCP local port.
 */
/*-----------------------------------------------------------------------------------*/
static uint16_t
tcp_new_port(void)
{
  struct tcp_pcb *pcb;
  static uint16_t port = 4096;

 again:
  if(++port > 0x7fff) {
    port = 4096;
  }

  for(pcb = tcp_active_pcbs; pcb != NULL; pcb = pcb->next) {
    if(pcb->local_port == port) {
      goto again;
    }
  }
  for(pcb = tcp_tw_pcbs; pcb != NULL; pcb = pcb->next) {
    if(pcb->local_port == port) {
      goto again;
    }
  }
  for(pcb = (struct tcp_pcb *)tcp_listen_pcbs; pcb != NULL; pcb = pcb->next) {
    if(pcb->local_port == port) {
      goto again;
    }
  }
  return port;
}
/*-----------------------------------------------------------------------------------*/
/*
 * tcp_connect():
 *
 * Connects to another host. The function given as the "connected"
 * argument will be called when the connection has been established.
 *
 */
/*-----------------------------------------------------------------------------------*/
err_t
tcp_connect(struct tcp_pcb *pcb, struct ip_addr *ipaddr, uint16_t port,
	    err_t (* connected)(void *arg, struct tcp_pcb *tpcb, err_t err))
{
  uint32_t optdata;
  err_t ret;
  uint32_t iss;

  DEBUGF(TCP_DEBUG, ("tcp_connect to port %d\n", port));
  if(ipaddr != NULL) {
    pcb->remote_ip = *ipaddr;
  } else {
    return ERR_VAL;
  }
  pcb->remote_port = port;
  if(pcb->local_port == 0) {
    pcb->local_port = tcp_new_port();
  }
  iss = tcp_next_iss();
  pcb->rcv_nxt = 0;
  pcb->snd_nxt = iss;
  pcb->lastack = iss - 1;
  pcb->snd_lbb = iss - 1;
  pcb->rcv_wnd = TCP_WND;
  pcb->snd_wnd = TCP_WND;
  pcb->mss = TCP_MSS;
  pcb->cwnd = 1;
  pcb->ssthresh = pcb->mss * 10;
  pcb->state = SYN_SENT;
  pcb->connected = connected;
  TCP_REG(&tcp_active_pcbs, pcb);

  /* Build an MSS option */
  optdata = HTONL(((uint32_t)2 << 24) |
		  ((uint32_t)4 << 16) |
		  (((uint32_t)pcb->mss / 256) << 8) |
		  (pcb->mss & 255));

  ret = tcp_enqueue(pcb, NULL, 0, TCP_SYN, 0, (uint8_t *)&optdata, 4);
  if(ret == ERR_OK) {
    tcp_output(pcb);
  }
  return ret;
}
/*-----------------------------------------------------------------------------------*/
/*
 * tcp_slowtmr():
 *
 * Called every 500 ms and implements the retransmission timer and the timer that
 * removes PCBs that have been in TIME-WAIT for enough time. It also increments
 * various timers such as the inactivity timer in each PCB.
 */
/*-----------------------------------------------------------------------------------*/
void
tcp_slowtmr(void)
{
  static struct tcp_pcb *pcb, *pcb2, *prev;
  static struct tcp_seg *seg, *useg;
  static uint32_t eff_wnd;
  static uint8_t pcb_remove;      /* flag if a PCB should be removed */

  ++tcp_ticks;

  /* Steps through all of the active PCBs. */
  prev = NULL;
  pcb = tcp_active_pcbs;
  while(pcb != NULL) {
    ASSERT("tcp_timer_coarse: active pcb->state != CLOSED", pcb->state != CLOSED);
    ASSERT("tcp_timer_coarse: active pcb->state != LISTEN", pcb->state != LISTEN);
    ASSERT("tcp_timer_coarse: active pcb->state != TIME-WAIT", pcb->state != TIME_WAIT);

    pcb_remove = 0;

    if(pcb->state == SYN_SENT && pcb->nrtx == TCP_SYNMAXRTX) {
      ++pcb_remove;
    } else if(pcb->nrtx == TCP_MAXRTX) {
      ++pcb_remove;
    } else {
      ++pcb->rtime;
      seg = pcb->unacked;
      if(seg != NULL && pcb->rtime >= pcb->rto) {

        DEBUGF(TCP_RTO_DEBUG, ("tcp_timer_coarse: rtime %ld pcb->rto %d\n",
                               tcp_ticks - pcb->rtime, pcb->rto));

	/* Double retransmission time-out unless we are trying to
           connect to somebody (i.e., we are in SYN_SENT). */
	if(pcb->state != SYN_SENT) {
	  pcb->rto = ((pcb->sa >> 3) + pcb->sv) << tcp_backoff[pcb->nrtx];
	}

        /* Move all other unacked segments to the unsent queue. */
        if(seg->next != NULL) {
          for(useg = seg->next; useg->next != NULL; useg = useg->next);
          /* useg now points to the last segment on the unacked queue. */
          useg->next = pcb->unsent;
          pcb->unsent = seg->next;
          seg->next = NULL;
          pcb->snd_nxt = ntohl(pcb->unsent->tcphdr->seqno);
        }

	/* Do the actual retransmission. */
        tcp_rexmit_seg(pcb, seg);

        /* Reduce congestion window and ssthresh. */
        eff_wnd = MIN(pcb->cwnd, pcb->snd_wnd);
        pcb->ssthresh = eff_wnd >> 1;
        if(pcb->ssthresh < pcb->mss) {
          pcb->ssthresh = pcb->mss * 2;
        }
        pcb->cwnd = pcb->mss;

        DEBUGF(TCP_CWND_DEBUG, ("tcp_rexmit_seg: cwnd %u ssthresh %u\n",
                                pcb->cwnd, pcb->ssthresh));
      }
    }

    /* Check if this PCB has stayed too long in FIN-WAIT-2 */
    if(pcb->state == FIN_WAIT_2) {
      if((uint32_t)(tcp_ticks - pcb->tmr) >
	 TCP_FIN_WAIT_TIMEOUT / TCP_SLOW_INTERVAL) {
        ++pcb_remove;
      }
    }

    /* If this PCB has queued out of sequence data, but has been
       inactive for too long, will drop the data (it will eventually
       be retransmitted). */
#if TCP_QUEUE_OOSEQ
    if(pcb->ooseq != NULL &&
       (uint32_t)tcp_ticks - pcb->tmr >=
       pcb->rto * TCP_OOSEQ_TIMEOUT) {
      tcp_segs_free(pcb->ooseq);
      pcb->ooseq = NULL;
    }
#endif /* TCP_QUEUE_OOSEQ */

    /* Check if this PCB has stayed too long in SYN-RCVD */
    if(pcb->state == SYN_RCVD) {
      if((uint32_t)(tcp_ticks - pcb->tmr) >
	 TCP_SYN_RCVD_TIMEOUT / TCP_SLOW_INTERVAL) {
        ++pcb_remove;
      }
    }


    /* If the PCB should be removed, do it. */
    if(pcb_remove) {
      tcp_pcb_purge(pcb);
      /* Remove PCB from tcp_active_pcbs list. */
      if(prev != NULL) {
	ASSERT("tcp_timer_coarse: middle tcp != tcp_active_pcbs", pcb != tcp_active_pcbs);
        prev->next = pcb->next;
      } else {
        /* This PCB was the first. */
        ASSERT("tcp_timer_coarse: first pcb == tcp_active_pcbs", tcp_active_pcbs == pcb);
        tcp_active_pcbs = pcb->next;
      }

      if(pcb->errf != NULL) {
	pcb->errf(pcb->callback_arg, ERR_ABRT);
      }

      pcb2 = pcb->next;
      memp_free(MEMP_TCP_PCB, pcb);
      pcb = pcb2;
    } else {

      /* We check if we should poll the connection. */
      ++pcb->polltmr;
      if(pcb->polltmr >= pcb->pollinterval &&
	 pcb->poll != NULL) {
	pcb->polltmr = 0;
	pcb->poll(pcb->callback_arg, pcb);
	tcp_output(pcb);
      }

      prev = pcb;
      pcb = pcb->next;
    }
  }


  /* Steps through all of the TIME-WAIT PCBs. */
  prev = NULL;
  pcb = tcp_tw_pcbs;
  while(pcb != NULL) {
    ASSERT("tcp_timer_coarse: TIME-WAIT pcb->state == TIME-WAIT", pcb->state == TIME_WAIT);
    pcb_remove = 0;

    /* Check if this PCB has stayed long enough in TIME-WAIT */
    if((uint32_t)(tcp_ticks - pcb->tmr) > 2 * TCP_MSL / TCP_SLOW_INTERVAL) {
      ++pcb_remove;
    }



    /* If the PCB should be removed, do it. */
    if(pcb_remove) {
      tcp_pcb_purge(pcb);
      /* Remove PCB from tcp_tw_pcbs list. */
      if(prev != NULL) {
	ASSERT("tcp_timer_coarse: middle tcp != tcp_tw_pcbs", pcb != tcp_tw_pcbs);
        prev->next = pcb->next;
      } else {
        /* This PCB was the first. */
        ASSERT("tcp_timer_coarse: first pcb == tcp_tw_pcbs", tcp_tw_pcbs == pcb);
        tcp_tw_pcbs = pcb->next;
      }
      pcb2 = pcb->next;
      memp_free(MEMP_TCP_PCB, pcb);
      pcb = pcb2;
    } else {
      prev = pcb;
      pcb = pcb->next;
    }
  }
}
/*-----------------------------------------------------------------------------------*/
/*
 * tcp_fasttmr():
 *
 * Is called every TCP_FINE_TIMEOUT (100 ms) and sends delayed ACKs.
 */
/*-----------------------------------------------------------------------------------*/
void
tcp_fasttmr(void)
{
  struct tcp_pcb *pcb;

  /* send delayed ACKs */
  for(pcb = tcp_active_pcbs; pcb != NULL; pcb = pcb->next) {
    if(pcb->flags & TF_ACK_DELAY) {
      DEBUGF(TCP_DEBUG, ("tcp_timer_fine: delayed ACK\n"));
      tcp_ack_now(pcb);
      pcb->flags &= ~(TF_ACK_DELAY | TF_ACK_NOW);
    }
  }
}
/*-----------------------------------------------------------------------------------*/
/*
 * tcp_segs_free():
 *
 * Deallocates a list of TCP segments (tcp_seg structures).
 *
 */
/*-----------------------------------------------------------------------------------*/
uint8_t
tcp_segs_free(struct tcp_seg *seg)
{
  uint8_t count = 0;
  struct tcp_seg *next;
 again:
  if(seg != NULL) {
    next = seg->next;
    count += tcp_seg_free(seg);
    seg = next;
    goto again;
  }
  return count;
}
/*-----------------------------------------------------------------------------------*/
/*
 * tcp_seg_free():
 *
 * Frees a TCP segment.
 *
 */
/*-----------------------------------------------------------------------------------*/
uint8_t
tcp_seg_free(struct tcp_seg *seg)
{
  uint8_t count = 0;

  if(seg != NULL) {
    if(seg->p == NULL) {
      memp_free(MEMP_TCP_SEG, seg);
    } else {
      count = pbuf_free(seg->p);
#if TCP_DEBUG
      seg->p = NULL;
#endif /* TCP_DEBUG */
      memp_free(MEMP_TCP_SEG, seg);
    }
  }
  return count;
}
/*-----------------------------------------------------------------------------------*/
/*
 * tcp_seg_copy():
 *
 * Returns a copy of the given TCP segment.
 *
 */
/*-----------------------------------------------------------------------------------*/
struct tcp_seg *
tcp_seg_copy(struct tcp_seg *seg)
{
  struct tcp_seg *cseg;

  cseg = (struct tcp_seg*)memp_malloc(MEMP_TCP_SEG);
  if(cseg == NULL) {
    return NULL;
  }
  bcopy(seg, cseg, sizeof(struct tcp_seg));
  pbuf_ref(cseg->p);
  return cseg;
}
/*-----------------------------------------------------------------------------------*/
/*
 * tcp_new():
 *
 * Creates a new TCP protocol control block but doesn't place it on
 * any of the TCP PCB lists.
 *
 */
/*-----------------------------------------------------------------------------------*/
struct tcp_pcb *
tcp_new(void)
{
  struct tcp_pcb *pcb;
  uint32_t iss;

  pcb = (struct tcp_pcb*)memp_malloc2(MEMP_TCP_PCB);
  if(pcb != NULL) {
    bzero(pcb, sizeof(struct tcp_pcb));
    pcb->snd_buf = TCP_SND_BUF;
    pcb->snd_queuelen = 0;
    pcb->rcv_wnd = TCP_WND;
    pcb->mss = TCP_MSS;
    pcb->rto = 3000 / TCP_SLOW_INTERVAL;
    pcb->sa = 0;
    pcb->sv = 3000 / TCP_SLOW_INTERVAL;
    pcb->rtime = 0;
    pcb->cwnd = 1;
    iss = tcp_next_iss();
    pcb->snd_wl2 = iss;
    pcb->snd_nxt = iss;
    pcb->snd_max = iss;
    pcb->lastack = iss;
    pcb->snd_lbb = iss;
    pcb->tmr = tcp_ticks;

    pcb->polltmr = 0;

    return pcb;
  }
  return NULL;
}
/*-----------------------------------------------------------------------------------*/
/*
 * tcp_mem_reclaim():
 *
 * Tries to free up TCP memory. This function is called from the memory manager
 * when memory is scarce.
 *
 */
/*-----------------------------------------------------------------------------------*/
#if MEM_RECLAIM
static mem_size_t
tcp_mem_reclaim(void *arg, mem_size_t size)
{
  static struct tcp_pcb *pcb, *inactive;
  static uint32_t inactivity;
  static mem_size_t reclaimed;

  reclaimed = 0;

  /* Kill the oldest active connection, hoping that there may be
     memory associated with it. */
  inactivity = 0;
  inactive = NULL;
  for(pcb = tcp_active_pcbs; pcb != NULL; pcb = pcb->next) {
    if((uint32_t)(tcp_ticks - pcb->tmr) > inactivity) {
      inactivity = tcp_ticks - pcb->tmr;
      inactive = pcb;
    }
  }
  if(inactive != NULL) {
    DEBUGF(TCP_DEBUG, ("tcp_mem_reclaim: killing oldest PCB 0x%p (%ld)\n",
		       inactive, inactivity));
    tcp_abort(inactive);
  }
  return reclaimed;
}
#endif /* MEM_RECLAIM */
/*-----------------------------------------------------------------------------------*/
/*
 * tcp_memp_reclaim():
 *
 * Tries to free up TCP memory. This function is called from the
 * memory pool manager when memory is scarce.
 *
 */
/*-----------------------------------------------------------------------------------*/
#if MEMP_RECLAIM
static uint8_t
tcp_memp_reclaim(void *arg, memp_t type)
{
  struct tcp_pcb *pcb, *inactive;
  uint32_t inactivity;

  switch(type) {
  case MEMP_TCP_SEG:
#if TCP_QUEUE_OOSEQ
    /* Try to find any buffered out of sequence data. */
    for(pcb = tcp_active_pcbs; pcb != NULL; pcb = pcb->next) {
      if(pcb->ooseq) {
	DEBUGF(TCP_DEBUG, ("tcp_memp_reclaim: reclaiming memory from PCB 0x%lx\n", (long)pcb));
	tcp_segs_free(pcb->ooseq);
	pcb->ooseq = NULL;
	return 1;
      }
    }

#else /* TCP_QUEUE_OOSEQ */
    return 0;
#endif /* TCP_QUEUE_OOSEQ */
    break;

  case MEMP_PBUF:
    return tcp_memp_reclaim(arg, MEMP_TCP_SEG);

  case MEMP_TCP_PCB:
    /* We either kill off a connection in TIME-WAIT, or the oldest
       active connection. */
    pcb = tcp_tw_pcbs;
    if(pcb != NULL) {
      tcp_tw_pcbs = tcp_tw_pcbs->next;
      memp_free(MEMP_TCP_PCB, pcb);
      return 1;
    } else {
      inactivity = 0;
      inactive = NULL;
      for(pcb = tcp_active_pcbs; pcb != NULL; pcb = pcb->next) {
	if((uint32_t)(tcp_ticks - pcb->tmr) > inactivity) {
	  inactivity = tcp_ticks - pcb->tmr;
	  inactive = pcb;
	}
      }
      if(inactive != NULL) {
	DEBUGF(TCP_DEBUG, ("tcp_mem_reclaim: killing oldest PCB 0x%p (%ld)\n",
			   inactive, inactivity));
	tcp_abort(inactive);
	return 1;
      }
    }
    break;

  default:
    ASSERT("tcp_memp_reclaim: called with wrong type", 0);
    break;
  }
  return 0;
}
#endif /* MEM_RECLAIM */
/*-----------------------------------------------------------------------------------*/
/*
 * tcp_arg():
 *
 * Used to specify the argument that should be passed callback
 * functions.
 *
 */
/*-----------------------------------------------------------------------------------*/
void
tcp_arg(struct tcp_pcb *pcb, void *arg)
{
  pcb->callback_arg = arg;
}
/*-----------------------------------------------------------------------------------*/
/*
 * tcp_recv():
 *
 * Used to specify the function that should be called when a TCP
 * connection receives data.
 *
 */
/*-----------------------------------------------------------------------------------*/
void
tcp_recv(struct tcp_pcb *pcb,
	 err_t (* recv)(void *arg, struct tcp_pcb *tpcb, struct pbuf *p, err_t err))
{
  pcb->recv = recv;
}
/*-----------------------------------------------------------------------------------*/
/*
 * tcp_sent():
 *
 * Used to specify the function that should be called when TCP data
 * has been successfully delivered to the remote host.
 *
 */
/*-----------------------------------------------------------------------------------*/
void
tcp_sent(struct tcp_pcb *pcb,
	 err_t (* sent)(void *arg, struct tcp_pcb *tpcb, uint16_t len))
{
  pcb->sent = sent;
}
/*-----------------------------------------------------------------------------------*/
/*
 * tcp_err():
 *
 * Used to specify the function that should be called when a fatal error
 * has occured on the connection.
 *
 */
/*-----------------------------------------------------------------------------------*/
void
tcp_err(struct tcp_pcb *pcb,
	 void (* errf)(void *arg, err_t err))
{
  pcb->errf = errf;
}
/*-----------------------------------------------------------------------------------*/
/*
 * tcp_poll():
 *
 * Used to specify the function that should be called periodically
 * from TCP. The interval is specified in terms of the TCP coarse
 * timer interval, which is called twice a second.
 *
 */
/*-----------------------------------------------------------------------------------*/
void
tcp_poll(struct tcp_pcb *pcb,
	 err_t (* poll)(void *arg, struct tcp_pcb *tpcb), uint8_t interval)
{
  pcb->poll = poll;
  pcb->pollinterval = interval;
}
/*-----------------------------------------------------------------------------------*/
/*
 * tcp_accept():
 *
 * Used for specifying the function that should be called when a
 * LISTENing connection has been connected to another host.
 *
 */
/*-----------------------------------------------------------------------------------*/
void
tcp_accept(struct tcp_pcb *pcb,
	   err_t (* accept)(void *arg, struct tcp_pcb *newpcb, err_t err))
{
  pcb->accept = accept;
}
/*-----------------------------------------------------------------------------------*/
/*
 * tcp_pcb_purge():
 *
 * Purges a TCP PCB. Removes any buffered data and frees the buffer memory.
 *
 */
/*-----------------------------------------------------------------------------------*/
void
tcp_pcb_purge(struct tcp_pcb *pcb)
{
  if(pcb->state != CLOSED &&
     pcb->state != TIME_WAIT &&
     pcb->state != LISTEN) {

#if TCP_DEBUG
    if(pcb->unsent != NULL) {
      DEBUGF(TCP_DEBUG, ("tcp_pcb_purge: not all data sent\n"));
    }
    if(pcb->unacked != NULL) {
      DEBUGF(TCP_DEBUG, ("tcp_pcb_purge: data left on ->unacked\n"));
    }
    if(pcb->ooseq != NULL) {
      DEBUGF(TCP_DEBUG, ("tcp_pcb_purge: data left on ->ooseq\n"));
    }
#endif /* TCP_DEBUG */
    tcp_segs_free(pcb->unsent);
#if TCP_QUEUE_OOSEQ
    tcp_segs_free(pcb->ooseq);
#endif /* TCP_QUEUE_OOSEQ */
    tcp_segs_free(pcb->unacked);
    pcb->unacked = pcb->unsent =
#if TCP_QUEUE_OOSEQ
      pcb->ooseq =
#endif /* TCP_QUEUE_OOSEQ */
      NULL;
  }
}
/*-----------------------------------------------------------------------------------*/
/*
 * tcp_pcb_remove():
 *
 * Purges the PCB and removes it from a PCB list. Any delayed ACKs are sent first.
 *
 */
/*-----------------------------------------------------------------------------------*/
void
tcp_pcb_remove(struct tcp_pcb **pcblist, struct tcp_pcb *pcb)
{
  TCP_RMV(pcblist, pcb);

  tcp_pcb_purge(pcb);

  /* if there is an outstanding delayed ACKs, send it */
  if(pcb->state != TIME_WAIT &&
     pcb->state != LISTEN &&
     pcb->flags & TF_ACK_DELAY) {
    pcb->flags |= TF_ACK_NOW;
    tcp_output(pcb);
  }
  pcb->state = CLOSED;

  ASSERT("tcp_pcb_remove: tcp_pcbs_sane()", tcp_pcbs_sane());
}
/*-----------------------------------------------------------------------------------*/
/*
 * tcp_next_iss():
 *
 * Calculates a new initial sequence number for new connections.
 *
 */
/*-----------------------------------------------------------------------------------*/
uint32_t
tcp_next_iss(void)
{
  static uint32_t iss = 6510;

  iss += tcp_ticks;       /* XXX */
  return iss;
}
/*-----------------------------------------------------------------------------------*/
#if TCP_DEBUG || TCP_INPUT_DEBUG || TCP_OUTPUT_DEBUG
void
tcp_debug_print(struct tcp_hdr *tcphdr)
{
  DEBUGF(TCP_DEBUG, ("TCP header:\n"));
  DEBUGF(TCP_DEBUG, ("+-------------------------------+\n"));
  DEBUGF(TCP_DEBUG, ("|      %04x     |      %04x     | (src port, dest port)\n",
		     tcphdr->src, tcphdr->dest));
  DEBUGF(TCP_DEBUG, ("+-------------------------------+\n"));
  DEBUGF(TCP_DEBUG, ("|            %x           | (seq no)\n",
			    tcphdr->seqno));
  DEBUGF(TCP_DEBUG, ("+-------------------------------+\n"));
  DEBUGF(TCP_DEBUG, ("|            %08lu           | (ack no)\n",
		     tcphdr->ackno));
  DEBUGF(TCP_DEBUG, ("+-------------------------------+\n"));
  DEBUGF(TCP_DEBUG, ("| %2d |    |%d%d%d%d%d|    %5d      | (offset, flags (",
		     TCPH_FLAGS(tcphdr) >> 4 & 1,
		     TCPH_FLAGS(tcphdr) >> 4 & 1,
		     TCPH_FLAGS(tcphdr) >> 3 & 1,
		     TCPH_FLAGS(tcphdr) >> 2 & 1,
		     TCPH_FLAGS(tcphdr) >> 1 & 1,
		     TCPH_FLAGS(tcphdr) & 1,
		     tcphdr->wnd));
  tcp_debug_print_flags(TCPH_FLAGS(tcphdr));
  DEBUGF(TCP_DEBUG, ("), win)\n"));
  DEBUGF(TCP_DEBUG, ("+-------------------------------+\n"));
  DEBUGF(TCP_DEBUG, ("|    0x%04x     |     %5d     | (chksum, urgp)\n",
		     ntohs(tcphdr->chksum), ntohs(tcphdr->urgp)));
  DEBUGF(TCP_DEBUG, ("+-------------------------------+\n"));
}
/*-----------------------------------------------------------------------------------*/
void
tcp_debug_print_state(enum tcp_state s)
{
  DEBUGF(TCP_DEBUG, ("State: "));
  switch(s) {
  case CLOSED:
    DEBUGF(TCP_DEBUG, ("CLOSED\n"));
    break;
 case LISTEN:
   DEBUGF(TCP_DEBUG, ("LISTEN\n"));
   break;
  case SYN_SENT:
    DEBUGF(TCP_DEBUG, ("SYN_SENT\n"));
    break;
  case SYN_RCVD:
    DEBUGF(TCP_DEBUG, ("SYN_RCVD\n"));
    break;
  case ESTABLISHED:
    DEBUGF(TCP_DEBUG, ("ESTABLISHED\n"));
    break;
  case FIN_WAIT_1:
    DEBUGF(TCP_DEBUG, ("FIN_WAIT_1\n"));
    break;
  case FIN_WAIT_2:
    DEBUGF(TCP_DEBUG, ("FIN_WAIT_2\n"));
    break;
  case CLOSE_WAIT:
    DEBUGF(TCP_DEBUG, ("CLOSE_WAIT\n"));
    break;
  case CLOSING:
    DEBUGF(TCP_DEBUG, ("CLOSING\n"));
    break;
  case LAST_ACK:
    DEBUGF(TCP_DEBUG, ("LAST_ACK\n"));
    break;
  case TIME_WAIT:
    DEBUGF(TCP_DEBUG, ("TIME_WAIT\n"));
   break;
  }
}
/*-----------------------------------------------------------------------------------*/
void
tcp_debug_print_flags(uint8_t flags)
{
  if(flags & TCP_FIN) {
    DEBUGF(TCP_DEBUG, ("FIN "));
  }
  if(flags & TCP_SYN) {
    DEBUGF(TCP_DEBUG, ("SYN "));
  }
  if(flags & TCP_RST) {
    DEBUGF(TCP_DEBUG, ("RST "));
  }
  if(flags & TCP_PSH) {
    DEBUGF(TCP_DEBUG, ("PSH "));
  }
  if(flags & TCP_ACK) {
    DEBUGF(TCP_DEBUG, ("ACK "));
  }
  if(flags & TCP_URG) {
    DEBUGF(TCP_DEBUG, ("URG "));
  }
}
/*-----------------------------------------------------------------------------------*/
void
tcp_debug_print_pcbs(void)
{
  struct tcp_pcb *pcb;
  DEBUGF(TCP_DEBUG, ("Active PCB states:\n"));
  for(pcb = tcp_active_pcbs; pcb != NULL; pcb = pcb->next) {
    DEBUGF(TCP_DEBUG, ("Local port %d, foreign port %d snd_nxt %lu rcv_nxt %lu ",
                       pcb->local_port, pcb->remote_port,
                       pcb->snd_nxt, pcb->rcv_nxt));
    tcp_debug_print_state(pcb->state);
  }
  DEBUGF(TCP_DEBUG, ("Listen PCB states:\n"));
  for(pcb = (struct tcp_pcb *)tcp_listen_pcbs; pcb != NULL; pcb = pcb->next) {
    DEBUGF(TCP_DEBUG, ("Local port %d, foreign port %d snd_nxt %lu rcv_nxt %lu ",
                       pcb->local_port, pcb->remote_port,
                       pcb->snd_nxt, pcb->rcv_nxt));
    tcp_debug_print_state(pcb->state);
  }
  DEBUGF(TCP_DEBUG, ("TIME-WAIT PCB states:\n"));
  for(pcb = tcp_tw_pcbs; pcb != NULL; pcb = pcb->next) {
    DEBUGF(TCP_DEBUG, ("Local port %d, foreign port %d snd_nxt %lu rcv_nxt %lu ",
                       pcb->local_port, pcb->remote_port,
                       pcb->snd_nxt, pcb->rcv_nxt));
    tcp_debug_print_state(pcb->state);
  }
}
/*-----------------------------------------------------------------------------------*/
int
tcp_pcbs_sane(void)
{
  struct tcp_pcb *pcb;
  for(pcb = tcp_active_pcbs; pcb != NULL; pcb = pcb->next) {
    ASSERT("tcp_pcbs_sane: active pcb->state != CLOSED", pcb->state != CLOSED);
    ASSERT("tcp_pcbs_sane: active pcb->state != LISTEN", pcb->state != LISTEN);
    ASSERT("tcp_pcbs_sane: active pcb->state != TIME-WAIT", pcb->state != TIME_WAIT);
  }
  for(pcb = tcp_tw_pcbs; pcb != NULL; pcb = pcb->next) {
    ASSERT("tcp_pcbs_sane: tw pcb->state == TIME-WAIT", pcb->state == TIME_WAIT);
  }
  for(pcb = (struct tcp_pcb *)tcp_listen_pcbs; pcb != NULL; pcb = pcb->next) {
    ASSERT("tcp_pcbs_sane: listen pcb->state == LISTEN", pcb->state == LISTEN);
  }
  return 1;
}
#endif /* TCP_DEBUG */
/*-----------------------------------------------------------------------------------*/









