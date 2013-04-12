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
 * $Id: api_msg.c 2430 2007-04-06 22:29:40Z paun $
 */

#include "lwip/debug.h"
#include "lwip/arch.h"
#include "lwip/api_msg.h"
#include "lwip/memp.h"
#include "lwip/sys.h"
#include "lwip/tcpip.h"

#include "lwip/transport_subsys.h"

/*-----------------------------------------------------------------------------------*/
static err_t
recv_tcp(void *arg, struct tcp_pcb *pcb, struct pbuf *p, err_t err)
{
  struct netconn *conn;

  conn = arg;

  if(conn == NULL) {
    pbuf_free(p);
    return ERR_VAL;
  }

  if(conn->recvmbox != SYS_MBOX_NULL) {
    conn->err = err;
    sys_mbox_post(conn->recvmbox, p);
  }
  return ERR_OK;
}
/*-----------------------------------------------------------------------------------*/
static void
recv_udp(void *arg, struct udp_pcb *pcb, struct pbuf *p,
	 struct ip_addr *addr, uint16_t port)
{
  struct netbuf *buf;
  struct netconn *conn;

  conn = arg;

  if(conn == NULL) {
    pbuf_free(p);
    return;
  }

  if(conn->recvmbox != SYS_MBOX_NULL) {
    buf = memp_mallocp(MEMP_NETBUF);
    if(buf == NULL) {
      pbuf_free(p);
      return;
    } else {
      buf->p = p;
      buf->ptr = p;
      buf->fromaddr = addr;
      buf->fromport = port;
    }

    sys_mbox_post(conn->recvmbox, buf);
  }
}
/*-----------------------------------------------------------------------------------*/
static err_t
poll_tcp(void *arg, struct tcp_pcb *pcb)
{
  struct netconn *conn;

  conn = arg;
  if(conn != NULL &&
     (conn->state == NETCONN_WRITE || conn->state == NETCONN_CLOSE) &&
     conn->sem != SYS_SEM_NULL) {
    sys_sem_signal(conn->sem);
  }
  return ERR_OK;
}
/*-----------------------------------------------------------------------------------*/
static err_t
sent_tcp(void *arg, struct tcp_pcb *pcb, uint16_t len)
{
  struct netconn *conn;

  conn = arg;
  if(conn != NULL && conn->sem != SYS_SEM_NULL) {
    sys_sem_signal(conn->sem);
  }
  return ERR_OK;
}
/*-----------------------------------------------------------------------------------*/
static void
err_tcp(void *arg, err_t err)
{
  struct netconn *conn;

  conn = arg;

  conn->pcb.tcp = NULL;


  conn->err = err;
  if(conn->recvmbox != SYS_MBOX_NULL) {
    sys_mbox_post(conn->recvmbox, NULL);
  }
  if(conn->mbox != SYS_MBOX_NULL) {
    sys_mbox_post(conn->mbox, NULL);
  }
  if(conn->acceptmbox != SYS_MBOX_NULL) {
    sys_mbox_post(conn->acceptmbox, NULL);
  }
  if(conn->sem != SYS_SEM_NULL) {
    sys_sem_signal(conn->sem);
  }
}
/*-----------------------------------------------------------------------------------*/
static void
setup_tcp(struct netconn *conn)
{
  struct tcp_pcb *pcb;

  pcb = conn->pcb.tcp;
  tcp_arg(pcb, conn);
  tcp_recv(pcb, recv_tcp);
  tcp_sent(pcb, sent_tcp);
  tcp_poll(pcb, poll_tcp, 4);
  tcp_err(pcb, err_tcp);
}
/*-----------------------------------------------------------------------------------*/
static err_t
accept_function(void *arg, struct tcp_pcb *newpcb, err_t err)
{
  sys_mbox_t *mbox;
  struct netconn *newconn;

#if API_MSG_DEBUG
#if TCP_DEBUG
  tcp_debug_print_state(newpcb->state);
#endif /* TCP_DEBUG */
#endif /* API_MSG_DEBUG */
  mbox = (sys_mbox_t *)arg;
  newconn = memp_mallocp(MEMP_NETCONN);
  if(newconn == NULL) {
    return ERR_MEM;
  }
  newconn->type = NETCONN_TCP;
  newconn->pcb.tcp = newpcb;
  setup_tcp(newconn);
  newconn->recvmbox = sys_mbox_new();
  if(newconn->recvmbox == SYS_MBOX_NULL) {
    memp_free(MEMP_NETCONN, newconn);
    return ERR_MEM;
  }
  newconn->mbox = sys_mbox_new();
  if(newconn->mbox == SYS_MBOX_NULL) {
    sys_mbox_free(newconn->recvmbox);
    memp_free(MEMP_NETCONN, newconn);
    return ERR_MEM;
  }
  newconn->sem = sys_sem_new(0);
  if(newconn->sem == SYS_SEM_NULL) {
    sys_mbox_free(newconn->recvmbox);
    sys_mbox_free(newconn->mbox);
    memp_free(MEMP_NETCONN, newconn);
    return ERR_MEM;
  }
  newconn->acceptmbox = SYS_MBOX_NULL;
  newconn->err = err;
  sys_mbox_post(*mbox, newconn);
  return ERR_OK;
}
/*-----------------------------------------------------------------------------------*/
static void
do_newconn(struct api_msg_msg *msg)
{
}
/*-----------------------------------------------------------------------------------*/
static void
do_delconn(struct api_msg_msg *msg)
{
  if(msg->conn->pcb.tcp != NULL) {
    switch(msg->conn->type) {
    case NETCONN_UDPLITE:
      /* FALLTHROUGH */
    case NETCONN_UDPNOCHKSUM:
      /* FALLTHROUGH */
    case NETCONN_UDP:
      msg->conn->pcb.udp->recv_arg = NULL;
      udp_remove(msg->conn->pcb.udp);
      break;
    case NETCONN_TCP:
      tcp_arg(msg->conn->pcb.tcp, NULL);
      tcp_sent(msg->conn->pcb.tcp, NULL);
      tcp_recv(msg->conn->pcb.tcp, NULL);
      tcp_accept(msg->conn->pcb.tcp, NULL);
      tcp_poll(msg->conn->pcb.tcp, NULL, 0);
      tcp_err(msg->conn->pcb.tcp, NULL);
      if(msg->conn->pcb.tcp->state == LISTEN) {
	tcp_close(msg->conn->pcb.tcp);
      } else {
	if(tcp_close(msg->conn->pcb.tcp) != ERR_OK) {
	  tcp_abort(msg->conn->pcb.tcp);
	}
      }
    break;
    }
  }
  if(msg->conn->mbox != SYS_MBOX_NULL) {
    sys_mbox_post(msg->conn->mbox, NULL);
  }
}
/*-----------------------------------------------------------------------------------*/
static void
do_bind(struct api_msg_msg *msg)
{
  if(msg->conn->pcb.tcp == NULL) {
    switch(msg->conn->type) {
    case NETCONN_UDPLITE:
      msg->conn->pcb.udp = udp_new();
      udp_setflags(msg->conn->pcb.udp, UDP_FLAGS_UDPLITE);
      udp_recv(msg->conn->pcb.udp, recv_udp, msg->conn);
      break;
    case NETCONN_UDPNOCHKSUM:
      msg->conn->pcb.udp = udp_new();
      udp_setflags(msg->conn->pcb.udp, UDP_FLAGS_NOCHKSUM);
      udp_recv(msg->conn->pcb.udp, recv_udp, msg->conn);
      break;
    case NETCONN_UDP:
      msg->conn->pcb.udp = udp_new();
      udp_recv(msg->conn->pcb.udp, recv_udp, msg->conn);
      break;
    case NETCONN_TCP:
      msg->conn->pcb.tcp = tcp_new();
      setup_tcp(msg->conn);
      break;
    }
  }
  switch(msg->conn->type) {
  case NETCONN_UDPLITE:
    /* FALLTHROUGH */
  case NETCONN_UDPNOCHKSUM:
    /* FALLTHROUGH */
  case NETCONN_UDP:
    udp_bind(msg->conn->pcb.udp, msg->msg.bc.ipaddr, msg->msg.bc.port);
    break;
  case NETCONN_TCP:
    msg->conn->err = tcp_bind(msg->conn->pcb.tcp,
			      msg->msg.bc.ipaddr, msg->msg.bc.port);
    break;
  }
  sys_mbox_post(msg->conn->mbox, NULL);
}
/*-----------------------------------------------------------------------------------*/
static err_t
do_connected(void *arg, struct tcp_pcb *pcb, err_t err)
{
  struct netconn *conn;

  conn = arg;

  if(conn == NULL) {
    return ERR_VAL;
  }

  conn->err = err;

  if(conn->type == NETCONN_TCP && err == ERR_OK) {
    setup_tcp(conn);
  }

  sys_mbox_post(conn->mbox, NULL);
  return ERR_OK;
}
/*-----------------------------------------------------------------------------------*/
static void
do_connect(struct api_msg_msg *msg)
{
  if(msg->conn->pcb.tcp == NULL) {
    switch(msg->conn->type) {
    case NETCONN_UDPLITE:
      msg->conn->pcb.udp = udp_new();
      if(msg->conn->pcb.udp == NULL) {
	msg->conn->err = ERR_MEM;
	sys_mbox_post(msg->conn->mbox, NULL);
	return;
      }
      udp_setflags(msg->conn->pcb.udp, UDP_FLAGS_UDPLITE);
      udp_recv(msg->conn->pcb.udp, recv_udp, msg->conn);
      break;
    case NETCONN_UDPNOCHKSUM:
      msg->conn->pcb.udp = udp_new();
      if(msg->conn->pcb.udp == NULL) {
	msg->conn->err = ERR_MEM;
	sys_mbox_post(msg->conn->mbox, NULL);
	return;
      }
      udp_setflags(msg->conn->pcb.udp, UDP_FLAGS_NOCHKSUM);
      udp_recv(msg->conn->pcb.udp, recv_udp, msg->conn);
      break;
    case NETCONN_UDP:
      msg->conn->pcb.udp = udp_new();
      if(msg->conn->pcb.udp == NULL) {
	msg->conn->err = ERR_MEM;
	sys_mbox_post(msg->conn->mbox, NULL);
	return;
      }
      udp_recv(msg->conn->pcb.udp, recv_udp, msg->conn);
      break;
    case NETCONN_TCP:
      msg->conn->pcb.tcp = tcp_new();
      if(msg->conn->pcb.tcp == NULL) {
	msg->conn->err = ERR_MEM;
	sys_mbox_post(msg->conn->mbox, NULL);
	return;
      }
      break;
    }
  }
  switch(msg->conn->type) {
  case NETCONN_UDPLITE:
    /* FALLTHROUGH */
  case NETCONN_UDPNOCHKSUM:
    /* FALLTHROUGH */
  case NETCONN_UDP:
    udp_connect(msg->conn->pcb.udp, msg->msg.bc.ipaddr, msg->msg.bc.port);
    sys_mbox_post(msg->conn->mbox, NULL);
    break;
  case NETCONN_TCP:
    /*    tcp_arg(msg->conn->pcb.tcp, msg->conn);*/
    setup_tcp(msg->conn);
    tcp_connect(msg->conn->pcb.tcp, msg->msg.bc.ipaddr, msg->msg.bc.port,
		do_connected);
    /*tcp_output(msg->conn->pcb.tcp);*/
    break;
  }
}
/*-----------------------------------------------------------------------------------*/
static void
do_listen(struct api_msg_msg *msg)
{
  if(msg->conn->pcb.tcp != NULL) {
    switch(msg->conn->type) {
    case NETCONN_UDPLITE:
      /* FALLTHROUGH */
    case NETCONN_UDPNOCHKSUM:
      /* FALLTHROUGH */
    case NETCONN_UDP:
      DEBUGF(API_MSG_DEBUG, ("api_msg: listen UDP: cannot listen for UDP.\n"));
      break;
    case NETCONN_TCP:
      msg->conn->pcb.tcp = tcp_listen(msg->conn->pcb.tcp);
      if(msg->conn->pcb.tcp == NULL) {
	msg->conn->err = ERR_MEM;
      } else {
	if(msg->conn->acceptmbox == SYS_MBOX_NULL) {
	  msg->conn->acceptmbox = sys_mbox_new();
	  if(msg->conn->acceptmbox == SYS_MBOX_NULL) {
	    msg->conn->err = ERR_MEM;
	    break;
	  }
	}
	tcp_arg(msg->conn->pcb.tcp, (void *)&(msg->conn->acceptmbox));
	tcp_accept(msg->conn->pcb.tcp, accept_function);
      }
      break;
    }
  }
  sys_mbox_post(msg->conn->mbox, NULL);
}
/*-----------------------------------------------------------------------------------*/
static void
do_accept(struct api_msg_msg *msg)
{
  if(msg->conn->pcb.tcp != NULL) {
    switch(msg->conn->type) {
    case NETCONN_UDPLITE:
      /* FALLTHROUGH */
    case NETCONN_UDPNOCHKSUM:
      /* FALLTHROUGH */
    case NETCONN_UDP:
      DEBUGF(API_MSG_DEBUG, ("api_msg: accept UDP: cannot accept for UDP.\n"));
      break;
    case NETCONN_TCP:
      break;
    }
  }
}
/*-----------------------------------------------------------------------------------*/
static void
do_send(struct api_msg_msg *msg)
{
  if(msg->conn->pcb.tcp != NULL) {
    switch(msg->conn->type) {
    case NETCONN_UDPLITE:
      /* FALLTHROUGH */
    case NETCONN_UDPNOCHKSUM:
      /* FALLTHROUGH */
    case NETCONN_UDP:
      udp_send(msg->conn->pcb.udp, msg->msg.p);
      break;
    case NETCONN_TCP:
      break;
    }
  }
  sys_mbox_post(msg->conn->mbox, NULL);
}
/*-----------------------------------------------------------------------------------*/
static void
do_recv(struct api_msg_msg *msg)
{
  if(msg->conn->pcb.tcp != NULL) {
    if(msg->conn->type == NETCONN_TCP) {
      tcp_recved(msg->conn->pcb.tcp, msg->msg.len);
    }
  }
  sys_mbox_post(msg->conn->mbox, NULL);
}
/*-----------------------------------------------------------------------------------*/
static void
do_write(struct api_msg_msg *msg)
{
  err_t err;
  if(msg->conn->pcb.tcp != NULL) {
    switch(msg->conn->type) {
    case NETCONN_UDPLITE:
      /* FALLTHROUGH */
    case NETCONN_UDPNOCHKSUM:
      /* FALLTHROUGH */
    case NETCONN_UDP:
      msg->conn->err = ERR_VAL;
      break;
    case NETCONN_TCP:
      err = tcp_write(msg->conn->pcb.tcp, msg->msg.w.dataptr,
                      msg->msg.w.len, msg->msg.w.copy);
      /* This is the Nagle algorithm: inhibit the sending of new TCP
	 segments when new outgoing data arrives from the user if any
	 previously transmitted data on the connection remains
	 unacknowledged. */
      if(err == ERR_OK && msg->conn->pcb.tcp->unacked == NULL) {
	tcp_output(msg->conn->pcb.tcp);
      }
      msg->conn->err = err;
      break;
    }
  }
  sys_mbox_post(msg->conn->mbox, NULL);
}
/*-----------------------------------------------------------------------------------*/
static void
do_close(struct api_msg_msg *msg)
{
  err_t err;
  if(msg->conn->pcb.tcp != NULL) {
    switch(msg->conn->type) {
    case NETCONN_UDPLITE:
      /* FALLTHROUGH */
    case NETCONN_UDPNOCHKSUM:
      /* FALLTHROUGH */
    case NETCONN_UDP:
      break;
    case NETCONN_TCP:
      if(msg->conn->pcb.tcp->state == LISTEN) {
	err = tcp_close(msg->conn->pcb.tcp);
      } else {
	err = tcp_close(msg->conn->pcb.tcp);
      }
      msg->conn->err = err;
      break;
    }
  }
  sys_mbox_post(msg->conn->mbox, NULL);
}
/*-----------------------------------------------------------------------------------*/
typedef void (* api_msg_decode)(struct api_msg_msg *msg);
static api_msg_decode decode[API_MSG_MAX] = {
  do_newconn,
  do_delconn,
  do_bind,
  do_connect,
  do_listen,
  do_accept,
  do_send,
  do_recv,
  do_write,
  do_close
  };
void
api_msg_input(struct api_msg *msg)
{
  decode[msg->type](&(msg->msg));
}
/*-----------------------------------------------------------------------------------*/
void
api_msg_post(struct api_msg *msg)
{
  transport_apimsg(msg);
}
/*-----------------------------------------------------------------------------------*/
