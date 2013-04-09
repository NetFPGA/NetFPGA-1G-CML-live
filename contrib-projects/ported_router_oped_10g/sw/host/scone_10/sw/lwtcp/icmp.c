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
 * $Id: icmp.c 2430 2007-04-06 22:29:40Z paun $
 */

/* Some ICMP messages should be passed to the transport protocols. This
   is not implemented. */

#include <netinet/in.h>

#include "lwip/debug.h"

#include "lwip/icmp.h"
#include "lwip/inet.h"
#include "lwip/ip.h"
#include "lwip/def.h"

#include "lwip/stats.h"

#include "lwtcp_sr_integration.h"

#include <assert.h>

/*-----------------------------------------------------------------------------------*/
void
icmp_input(struct pbuf *p, struct netif *inp)
{
  unsigned char type;
  struct icmp_echo_hdr *iecho;
  struct ip_hdr *iphdr;
  struct ip_addr tmpaddr;
  uint16_t hlen;

#ifdef ICMP_STATS
  ++stats.icmp.recv;
#endif /* ICMP_STATS */


  iphdr = p->payload;
  hlen = IPH_HL(iphdr) * 4/sizeof(uint8_t);
  pbuf_header(p, -hlen);

  type = *((uint8_t *)p->payload);

  switch(type) {
  case ICMP_ECHO:
    if(ip_addr_isbroadcast(&iphdr->dest, &inp->netmask) ||
       ip_addr_ismulticast(&iphdr->dest)) {
      DEBUGF(ICMP_DEBUG, ("Smurf.\n"));
#ifdef ICMP_STATS
      ++stats.icmp.err;
#endif /* ICMP_STATS */
      pbuf_free(p);
      return;
    }
    DEBUGF(ICMP_DEBUG, ("icmp_input: ping\n"));
    DEBUGF(DEMO_DEBUG, ("Pong!\n"));
    if(p->tot_len < sizeof(struct icmp_echo_hdr)) {
      DEBUGF(ICMP_DEBUG, ("icmp_input: bad ICMP echo received\n"));
      pbuf_free(p);
#ifdef ICMP_STATS
      ++stats.icmp.lenerr;
#endif /* ICMP_STATS */

      return;
    }
    iecho = p->payload;
    if(inet_chksum_pbuf(p) != 0) {
      DEBUGF(ICMP_DEBUG, ("icmp_input: checksum failed for received ICMP echo\n"));
      pbuf_free(p);
#ifdef ICMP_STATS
      ++stats.icmp.chkerr;
#endif /* ICMP_STATS */
      return;
    }
    tmpaddr.addr = iphdr->src.addr;
    iphdr->src.addr = iphdr->dest.addr;
    iphdr->dest.addr = tmpaddr.addr;
    ICMPH_TYPE_SET(iecho, ICMP_ER);
    /* adjust the checksum */
    if(iecho->chksum >= htons(0xffff - (ICMP_ECHO << 8))) {
      iecho->chksum += htons(ICMP_ECHO << 8) + 1;
    } else {
      iecho->chksum += htons(ICMP_ECHO << 8);
    }
#ifdef ICMP_STATS
    ++stats.icmp.xmit;
#endif /* ICMP_STATS */

    pbuf_header(p, hlen);

    /* XXX .mc */
    assert(0);
    /*sr_lwip_output(p, IP_HDRINCL, IP_PROTO_ICMP);*/

    break;
  default:
    DEBUGF(ICMP_DEBUG, ("icmp_input: ICMP type not supported.\n"));
#ifdef ICMP_STATS
    ++stats.icmp.proterr;
    ++stats.icmp.drop;
#endif /* ICMP_STATS */
  }
  pbuf_free(p);
}
/*-----------------------------------------------------------------------------------*/
void
icmp_dest_unreach(struct pbuf *p, enum icmp_dur_type t)
{
  struct pbuf *q;
  struct ip_hdr *iphdr;
  struct icmp_dur_hdr *idur;

  q = pbuf_alloc(PBUF_TRANSPORT, 8 + IP_HLEN + 8, PBUF_RAM);
  /* ICMP header + IP header + 8 bytes of data */

  iphdr = p->payload;

  idur = q->payload;
  ICMPH_TYPE_SET(idur, ICMP_DUR);
  ICMPH_CODE_SET(idur, t);

  bcopy(p->payload, (char *)q->payload + 8, IP_HLEN + 8);

  /* calculate checksum */
  idur->chksum = 0;
  idur->chksum = inet_chksum(idur, q->len);
#ifdef ICMP_STATS
  ++stats.icmp.xmit;
#endif /* ICMP_STATS */

  sr_lwip_output(q,&(iphdr->dest), &(iphdr->src), IP_PROTO_ICMP);
  pbuf_free(q);
}
/*-----------------------------------------------------------------------------------*/
void
icmp_time_exceeded(struct pbuf *p, enum icmp_te_type t)
{
  struct pbuf *q;
  struct ip_hdr *iphdr;
  struct icmp_te_hdr *tehdr;

  q = pbuf_alloc(PBUF_TRANSPORT, 8 + IP_HLEN + 8, PBUF_RAM);

  iphdr = p->payload;
#if ICMP_DEBUG
  DEBUGF(ICMP_DEBUG, ("icmp_time_exceeded from "));
  ip_addr_debug_print(&(iphdr->src));
  DEBUGF(ICMP_DEBUG, (" to "));
  ip_addr_debug_print(&(iphdr->dest));
  DEBUGF(ICMP_DEBUG, ("\n"));
#endif /* ICMP_DEBNUG */

  tehdr = q->payload;
  ICMPH_TYPE_SET(tehdr, ICMP_TE);
  ICMPH_CODE_SET(tehdr, t);

  /* copy fields from original packet */
  bcopy((char *)p->payload, (char *)q->payload + 8, IP_HLEN + 8);

  /* calculate checksum */
  tehdr->chksum = 0;
  tehdr->chksum = inet_chksum(tehdr, q->len);
#ifdef ICMP_STATS
  ++stats.icmp.xmit;
#endif /* ICMP_STATS */
  sr_lwip_output(q, &(iphdr->dest), &(iphdr->src), IP_PROTO_ICMP);
  pbuf_free(q);
}








