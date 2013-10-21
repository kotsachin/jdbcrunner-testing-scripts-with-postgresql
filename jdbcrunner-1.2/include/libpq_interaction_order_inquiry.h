/*
 * pgsql_interaction_order_inquiry.h
 *
 * This file is released under the terms of the Artistic License.  Please see
 * the file LICENSE, included in this package, for details.
 *
 * Copyright (C) 2002 Mark Wong & Jenny Zhang &
 *                    Open Source Development Lab, Inc.
 * Copyright (C) 2003 Satoshi Nagayasu & Hideyuki Kawashima &
 *                    Sachi Osawa & Hirokazu Kondo & Satoru Satake
 *
 * $Id: pgsql_interaction_order_inquiry.h,v 1.1.2.3 2003/08/05 07:22:00 snaga Exp $
 */

#ifndef _LIBPQ_INTERACTION_ORDER_INQUIRY_H 
#define _LIBPQ_INTERACTION_ORDER_INQUIRY_H

#include <libpq_interaction.h>

#define STMT_ORDER_INQUIRY "SELECT order_inquiry(%lld)"

int execute_order_inquiry(struct db_context_t *, struct order_inquiry_t *);

#endif /* _LIBPQ_INTERACTION_ORDER_INQUIRY_H */
