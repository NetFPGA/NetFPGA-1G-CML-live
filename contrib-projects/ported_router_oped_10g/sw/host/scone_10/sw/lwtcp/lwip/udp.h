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
 * $Id: udp.h 2430 2007-04-06 22:29:40Z paun $
 */
#ifndef __LWIP_UDP_H__
#define __LWIP_UDP_H__

#include "lwip/arch.h"

#include "lwip/pbuf.h"
#include "lwip/inet.h"
#include "lwip/ip.h"

#include "lwip/err.h"

#define UDP_HLEN 8

struct udp_hdr {
  PACK_STRUCT_FIELD(uint16_t src);
  PACK_STRUCT_FIELD(uint16_t dest);  /* src/dest UDP ports */
  PACK_STRUCT_FIELD(uint16_t len);
  PACK_STRUCT_FIELD(uint16_t chksum);
} PACK_STRUCT_STRUCT;

#define UDP_FLAGS_NOCHKSUM 0x01
#define UDP_FLAGS_UDPLITE  0x02

struct udp_pcb {
  struct udp_pcb *next;

  struct ip_addr local_ip, remote_ip;
  uint16_t local_port, remote_port;

  uint8_t flags;
  uint16_t chksum_len;

  void (* recv)(void *arg, struct udp_pcb *pcb, struct pbuf *p,
		struct ip_addr *addr, uint16_t port);
  void *recv_arg;
};

/* The following functions is the application layer interface to the
   UDP code. */
struct udp_pcb * udp_new        (void);
void             udp_remove     (struct udp_pcb *pcb);
err_t            udp_bind       (struct udp_pcb *pcb, struct ip_addr *ipaddr,
				 uint16_t port);
err_t            udp_connect    (struct udp_pcb *pcb, struct ip_addr *ipaddr,
				 uint16_t port);
void             udp_recv       (struct udp_pcb *pcb,
				 void (* recv)(void *arg, struct udp_pcb *upcb,
					       struct pbuf *p,
					       struct ip_addr *addr,
					       uint16_t port),
				 void *recv_arg);
err_t            udp_send       (struct udp_pcb *pcb, struct pbuf *p);

#define          udp_flags(pcb)  ((pcb)->flags)
#define          udp_setflags(pcb, f)  ((pcb)->flags = (f))


/* The following functions is the lower layer interface to UDP. */
uint8_t             udp_lookup     (struct ip_hdr *iphdr, struct netif *inp);
void             udp_input      (struct pbuf *p, struct netif *inp);
void             udp_init       (void);


#endif /* __LWIP_UDP_H__ */


