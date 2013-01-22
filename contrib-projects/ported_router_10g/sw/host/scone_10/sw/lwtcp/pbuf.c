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
 * $Id: pbuf.c 2430 2007-04-06 22:29:40Z paun $
 */

/*-----------------------------------------------------------------------------------*/
/* pbuf.c
 *
 * Functions for the manipulation of pbufs. The pbufs holds all packets in the
 * system.
 *
 */
/*-----------------------------------------------------------------------------------*/
#include "lwip/debug.h"

#include "lwip/stats.h"

#include "lwip/def.h"
#include "lwip/mem.h"
#include "lwip/memp.h"
#include "lwip/pbuf.h"

#include "lwip/sys.h"

static uint8_t pbuf_pool_memory[(PBUF_POOL_SIZE * MEM_ALIGN_SIZE(PBUF_POOL_BUFSIZE + sizeof(struct pbuf)))];
static volatile uint8_t pbuf_pool_free_lock, pbuf_pool_alloc_lock;
static sys_sem_t pbuf_pool_free_sem;
static struct pbuf *pbuf_pool = NULL;
static struct pbuf *pbuf_pool_alloc_cache = NULL;
static struct pbuf *pbuf_pool_free_cache = NULL;

/*-----------------------------------------------------------------------------------*/
/* pbuf_init():
 *
 * Initializes the pbuf module. A large part of memory is allocated
 * for holding the pool of pbufs. The size of the individual pbufs in
 * the pool is given by the size parameter, and the number of pbufs in
 * the pool by the num parameter.
 *
 * After the memory has been allocated, the pbufs are set up. The
 * ->next pointer in each pbuf is set up to point to the next pbuf in
 * the pool.
 */
/*-----------------------------------------------------------------------------------*/
void
pbuf_init(void)
{
  struct pbuf *p, *q;
  uint8_t i;

  pbuf_pool = (struct pbuf *)&pbuf_pool_memory[0];
  ASSERT("pbuf_init: pool aligned", (long)pbuf_pool % MEM_ALIGNMENT == 0);

#ifdef PBUF_STATS
  stats.pbuf.avail = PBUF_POOL_SIZE;
#endif /* PBUF_STATS */

  /* Set up ->next pointers to link the pbufs of the pool together. */
  p = pbuf_pool;

  for(i = 0; i < PBUF_POOL_SIZE; ++i) {
    p->next = (struct pbuf *)((uint8_t *)p + PBUF_POOL_BUFSIZE + sizeof(struct pbuf));
    p->len = p->tot_len = PBUF_POOL_BUFSIZE;
    p->payload = MEM_ALIGN((void *)((uint8_t *)p + sizeof(struct pbuf)));
    q = p;
    p = p->next;
  }

  /* The ->next pointer of last pbuf is NULL to indicate that there
     are no more pbufs in the pool. */
  q->next = NULL;

  pbuf_pool_alloc_lock = 0;
  pbuf_pool_free_lock = 0;
  pbuf_pool_free_sem = sys_sem_new(1);

}
/*-----------------------------------------------------------------------------------*/
/* The following two functions are only called from pbuf_alloc(). */
/*-----------------------------------------------------------------------------------*/
static struct pbuf *
pbuf_pool_alloc(void)
{
  struct pbuf *p = NULL;

  /* First, see if there are pbufs in the cache. */
  if(pbuf_pool_alloc_cache) {
    p = pbuf_pool_alloc_cache;
    if(p) {
      pbuf_pool_alloc_cache = p->next;
    }
  } else {
    /* Next, check the actual pbuf pool, but if the pool is locked, we
       pretend to be out of buffers and return NULL. */
    if(pbuf_pool_free_lock) {
#ifdef PBUF_STATS
      ++stats.pbuf.alloc_locked;
#endif /* PBUF_STATS */
      return NULL;
    }
    ++pbuf_pool_alloc_lock;
    if(!pbuf_pool_free_lock) {
      p = pbuf_pool;
      if(p) {
	pbuf_pool = p->next;
      }
#ifdef PBUF_STATS
    } else {
      ++stats.pbuf.alloc_locked;
#endif /* PBUF_STATS */
    }
    --pbuf_pool_alloc_lock;
  }

#ifdef PBUF_STATS
  if(p != NULL) {
    ++stats.pbuf.used;
    if(stats.pbuf.used > stats.pbuf.max) {
      stats.pbuf.max = stats.pbuf.used;
    }
  }
#endif /* PBUF_STATS */

  return p;
}
/*-----------------------------------------------------------------------------------*/
static void
pbuf_pool_free(struct pbuf *p)
{
  struct pbuf *q;

#ifdef PBUF_STATS
    for(q = p; q != NULL; q = q->next) {
      --stats.pbuf.used;
    }
#endif /* PBUF_STATS */

  if(pbuf_pool_alloc_cache == NULL) {
    pbuf_pool_alloc_cache = p;
  } else {
    for(q = pbuf_pool_alloc_cache; q->next != NULL; q = q->next);
    q->next = p;
  }
}
/*-----------------------------------------------------------------------------------*/
/* pbuf_alloc():
 *
 * Allocates a pbuf at protocol layer l. The actual memory allocated
 * for the pbuf is determined by the layer at which the pbuf is
 * allocated and the requested size (from the size parameter). The
 * flag parameter decides how and where the pbuf should be allocated
 * as follows:
 *
 * * PBUF_RAM: buffer memory for pbuf is allocated as one large
 *             chunk. This includes protocol headers as well.
 * * RBUF_ROM: no buffer memory is allocated for the pbuf, even for
 *             protocol headers. Additional headers must be prepended
 *             by allocating another pbuf and chain in to the front of
 *             the ROM pbuf.
 * * PBUF_ROOL: the pbuf is allocated as a pbuf chain, with pbufs from
 *              the pbuf pool that is allocated during pbuf_init().
 */
/*-----------------------------------------------------------------------------------*/
struct pbuf *
pbuf_alloc(pbuf_layer l, uint16_t size, pbuf_flag flag)
{
  struct pbuf *p, *q, *r;
  uint16_t offset;
  int32_t rsize;

  offset = 0;
  switch(l) {
	  case PBUF_TRANSPORT:
		  offset += PBUF_TRANSPORT_HLEN;
		  /* FALLTHROUGH */
	  case PBUF_IP:
		  offset += PBUF_IP_HLEN;
		  offset += PBUF_LINK_HLEN;
		  /* FALLTHROUGH */
	  case PBUF_LINK:
		  break;
	  case PBUF_RAW:
		  break;
	  default:
		  ASSERT("pbuf_alloc: bad pbuf layer", 0);
		  return NULL;
  }

  switch(flag)
  {
	  case PBUF_POOL:
		  /* Allocate head of pbuf chain into p. */
		  p = pbuf_pool_alloc();
		  if(p == NULL) {
#ifdef PBUF_STATS
			  ++stats.pbuf.err;
#endif /* PBUF_STATS */
			  return NULL;
		  }
		  p->next = NULL;

		  /* Set the payload pointer so that it points offset bytes into
			 pbuf data memory. */
		  p->payload = MEM_ALIGN((void *)((uint8_t *)p + (sizeof(struct pbuf) + offset)));

		  /* The total length of the pbuf is the requested size. */
		  p->tot_len = size;

		  /* Set the length of the first pbuf is the chain. */
		  p->len = size > PBUF_POOL_BUFSIZE - offset? PBUF_POOL_BUFSIZE - offset: size;

		  p->flags = PBUF_FLAG_POOL;

		  /* Allocate the tail of the pbuf chain. */
		  r = p;
		  rsize = size - p->len;
		  while(rsize > 0) {
			  q = pbuf_pool_alloc();
			  if(q == NULL) {
				  DEBUGF(PBUF_DEBUG, ("pbuf_alloc: Out of pbufs in pool,\n"));
#ifdef PBUF_STATS
				  ++stats.pbuf.err;
#endif /* PBUF_STATS */
				  pbuf_pool_free(p);
				  return NULL;
			  }
			  q->next = NULL;
			  r->next = q;
			  q->len = rsize > PBUF_POOL_BUFSIZE? PBUF_POOL_BUFSIZE: rsize;
			  q->flags = PBUF_FLAG_POOL;
			  q->payload = (void *)((uint8_t *)q + sizeof(struct pbuf));
			  r = q;
			  q->ref = 1;
			  q = q->next;
			  rsize -= PBUF_POOL_BUFSIZE;
		  }
		  r->next = NULL;

		  ASSERT("pbuf_alloc: pbuf->payload properly aligned",
				  ((uint32_t)p->payload % MEM_ALIGNMENT) == 0);
		  break;
	  case PBUF_RAM:
		  /* If pbuf is to be allocated in RAM, allocate memory for it. */
		  p = (struct pbuf*)mem_malloc(MEM_ALIGN_SIZE(sizeof(struct pbuf) + size + offset));
		  if(p == NULL)
		  { return NULL; }

		  /* Set up internal structure of the pbuf. */
		  p->payload = MEM_ALIGN((void *)((uint8_t *)p + sizeof(struct pbuf) + offset));
		  p->len = p->tot_len = size;
		  p->next = NULL;
		  p->flags = PBUF_FLAG_RAM;

		  ASSERT("pbuf_alloc: pbuf->payload properly aligned",
				  ((uint32_t)p->payload % MEM_ALIGNMENT) == 0);
		  break;
	  case PBUF_ROM:
		  /* If the pbuf should point to ROM, we only need to allocate
			 memory for the pbuf structure. */
		  p = (struct pbuf*)memp_mallocp(MEMP_PBUF);
		  if(p == NULL) {
			  return NULL;
		  }
		  p->payload = NULL;
		  p->len = p->tot_len = size;
		  p->next = NULL;
		  p->flags = PBUF_FLAG_ROM;
		  break;
	  default:
		  ASSERT("pbuf_alloc: erroneous flag", 0);
		  return NULL;
  }
  p->ref = 1;
  return p;
}
/*-----------------------------------------------------------------------------------*/
/* pbuf_refresh():
 *
 * Moves free buffers from the pbuf_pool_free_cache to the pbuf_pool
 * list (if possible).
 *
 */
/*-----------------------------------------------------------------------------------*/
void
pbuf_refresh(void)
{
  struct pbuf *p;

  sys_sem_wait(pbuf_pool_free_sem);

  if(pbuf_pool_free_cache != NULL) {
    ++pbuf_pool_free_lock;
    if(!pbuf_pool_alloc_lock) {
      if(pbuf_pool == NULL) {
	pbuf_pool = pbuf_pool_free_cache;
      } else {
	for(p = pbuf_pool; p->next != NULL; p = p->next);
	p->next = pbuf_pool_free_cache;
      }
      pbuf_pool_free_cache = NULL;
#ifdef PBUF_STATS
    } else {
      ++stats.pbuf.refresh_locked;
#endif /* PBUF_STATS */
    }

    --pbuf_pool_free_lock;
  }

  sys_sem_signal(pbuf_pool_free_sem);
}
#define PBUF_POOL_FREE(p)  do {                             \
                             sys_sem_wait(pbuf_pool_free_sem);   \
                             p->next = pbuf_pool_free_cache;           \
                             pbuf_pool_free_cache = p;                 \
                             sys_sem_signal(pbuf_pool_free_sem); \
                           } while(0)
/*-----------------------------------------------------------------------------------*/
/* pbuf_realloc:
 *
 * Reallocates the memory for a pbuf. If the pbuf is in ROM, this as
 * simple as to adjust the ->tot_len and ->len fields. If the pbuf is
 * a pbuf chain, as it might be with both pbufs in dynamically
 * allocated RAM and for pbufs from the pbuf pool, we have to step
 * through the chain until we find the new endpoint in the pbuf chain.
 * Then the pbuf that is right on the endpoint is resized and any
 * further pbufs on the chain are deallocated.
 */
/*-----------------------------------------------------------------------------------*/
void
pbuf_realloc(struct pbuf *p, uint16_t size)
{
  struct pbuf *q, *r;
  uint16_t rsize;

  ASSERT("pbuf_realloc: sane p->flags", p->flags == PBUF_FLAG_POOL ||
         p->flags == PBUF_FLAG_ROM ||
         p->flags == PBUF_FLAG_RAM);


  if(p->tot_len <= size) {
    return;
  }

  switch(p->flags) {
  case PBUF_FLAG_POOL:
    /* First, step over any pbufs that should still be in the chain. */
    rsize = size;
    q = p;
    while(rsize > q->len) {
      rsize -= q->len;
      q = q->next;
    }
    /* Adjust the length of the pbuf that will be halved. */
    q->len = rsize;

    /* And deallocate any left over pbufs. */
    r = q->next;
    q->next = NULL;
    q = r;
    while(q != NULL) {
      r = q->next;
      PBUF_POOL_FREE(q);
#ifdef PBUF_STATS
      --stats.pbuf.used;
#endif /* PBUF_STATS */
      q = r;
    }
    break;
  case PBUF_FLAG_ROM:
    p->len = size;
    break;
  case PBUF_FLAG_RAM:
    /* First, step over the pbufs that should still be in the chain. */
    rsize = size;
    q = p;
    while(rsize > q->len) {
      rsize -= q->len;
      q = q->next;
    }
    if(q->flags == PBUF_FLAG_RAM) {
    /* Reallocate and adjust the length of the pbuf that will be halved. */
      mem_realloc(q, (uint8_t *)q->payload - (uint8_t *)q + rsize);
    }

    q->len = rsize;

    /* And deallocate any left over pbufs. */
    r = q->next;
    q->next = NULL;
    q = r;
    while(q != NULL) {
      r = q->next;
      pbuf_free(q);
      q = r;
    }
    break;
  }
  p->tot_len = size;

  pbuf_refresh();
}
/*-----------------------------------------------------------------------------------*/
/* pbuf_header():
 *
 * Adjusts the ->payload pointer so that space for a header appears in
 * the pbuf. Also, the ->tot_len and ->len fields are adjusted.
 */
/*-----------------------------------------------------------------------------------*/
uint8_t
pbuf_header(struct pbuf *p, int16_t header_size)
{
  void *payload;

  payload = p->payload;
  p->payload = (uint8_t *)p->payload - header_size/sizeof(uint8_t);

  DEBUGF(PBUF_DEBUG, ("pbuf_header: old %p new %p (%d)\n", payload, p->payload, header_size));

  if((uint8_t *)p->payload < (uint8_t *)p + sizeof(struct pbuf)) {
    DEBUGF(PBUF_DEBUG, ("pbuf_header: failed %p %p\n",
			(uint8_t *)p->payload,
			(uint8_t *)p + sizeof(struct pbuf)));
    p->payload = payload;
    return -1;
  }
  p->len += header_size;
  p->tot_len += header_size;

  return 0;
}
/*-----------------------------------------------------------------------------------*/
/* pbuf_free():
 *
 * Decrements the reference count and deallocates the pbuf if the
 * reference count is zero. If the pbuf is a chain all pbufs in the
 * chain are deallocated.
 */
/*-----------------------------------------------------------------------------------*/
uint8_t
pbuf_free(struct pbuf *p)
{
  struct pbuf *q;
  uint8_t count = 0;

  if(p == NULL) {
    return 0;
  }

  ASSERT("pbuf_free: sane flags", p->flags == PBUF_FLAG_POOL ||
         p->flags == PBUF_FLAG_ROM ||
         p->flags == PBUF_FLAG_RAM);

  ASSERT("pbuf_free: p->ref > 0", p->ref > 0);

  /* Decrement reference count. */
  p->ref--;

  q = NULL;
  /* If reference count == 0, actually deallocate pbuf. */
  if(p->ref == 0) {

    while(p != NULL) {
      /* Check if this is a pbuf from the pool. */
      if(p->flags == PBUF_FLAG_POOL) {
	p->len = p->tot_len = PBUF_POOL_BUFSIZE;
	p->payload = (void *)((uint8_t *)p + sizeof(struct pbuf));
	q = p->next;
	PBUF_POOL_FREE(p);
#ifdef PBUF_STATS
	--stats.pbuf.used;
#endif /* PBUF_STATS */
      } else if(p->flags == PBUF_FLAG_ROM) {
	q = p->next;
	memp_freep(MEMP_PBUF, p);
      } else {
	q = p->next;
	mem_free(p);
      }
      p = q;
      count++;
    }
    pbuf_refresh();
  }

  return count;
}
/*-----------------------------------------------------------------------------------*/
/* pbuf_clen():
 *
 * Returns the length of the pbuf chain.
 */
/*-----------------------------------------------------------------------------------*/
uint8_t
pbuf_clen(struct pbuf *p)
{
  uint8_t len;

  if(p == NULL) {
    return 0;
  }

  for(len = 0; p != NULL; p = p->next) {
    ++len;
  }
  return len;
}
/*-----------------------------------------------------------------------------------*/
/* pbuf_ref():
 *
 * Increments the reference count of the pbuf.
 */
/*-----------------------------------------------------------------------------------*/
void
pbuf_ref(struct pbuf *p)
{
  if(p == NULL) {
    return;
  }
  ++(p->ref);
}
/*-----------------------------------------------------------------------------------*/
/* pbuf_chain():
 *
 * Chains the two pbufs h and t together. The ->tot_len field of the
 * first pbuf (h) is adjusted.
 */
/*-----------------------------------------------------------------------------------*/
void
pbuf_chain(struct pbuf *h, struct pbuf *t)
{
  struct pbuf *p;

  for(p = h; p->next != NULL; p = p->next);
  p->next = t;
  h->tot_len += t->tot_len;
}
/*-----------------------------------------------------------------------------------*/
/* pbuf_dechain():
 *
 * Adjusts the ->tot_len field of the pbuf and returns the tail (if
 * any) of the pbuf chain.
 */
/*-----------------------------------------------------------------------------------*/
struct pbuf *
pbuf_dechain(struct pbuf *p)
{
  struct pbuf *q;

  q = p->next;
  if (q != NULL) {
    q->tot_len = p->tot_len - p->len;
  }
  p->tot_len = p->len;
  p->next = NULL;
  return q;
}
/*-----------------------------------------------------------------------------------*/
