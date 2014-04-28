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
 * $Id: err.h 2430 2007-04-06 22:29:40Z paun $
 */
#ifndef __LWIP_ERR_H__
#define __LWIP_ERR_H__

#include "lwip/debug.h"
#include "lwip/arch.h"

typedef int8_t err_t;

/* Definitions for error constants. */

#define ERR_OK    0      /* No error, everything OK. */
#define ERR_MEM  -1      /* Out of memory error.     */
#define ERR_BUF  -2      /* Buffer error.            */


#define ERR_ABRT -3      /* Connection aborted.      */
#define ERR_RST  -4      /* Connection reset.        */
#define ERR_CLSD -5      /* Connection closed.       */
#define ERR_CONN -6      /* Not connected.           */

#define ERR_VAL  -7      /* Illegal value.           */

#define ERR_ARG  -8      /* Illegal argument.        */

#define ERR_RTE  -9      /* Routing problem.         */

#define ERR_USE  -10     /* Address in use.          */



#ifdef LWIP_DEBUG
extern char *lwip_strerr(err_t err);
#else
#define lwip_strerr(x) ""
#endif /* LWIP_DEBUG */
#endif /* __LWIP_ERR_H__ */
