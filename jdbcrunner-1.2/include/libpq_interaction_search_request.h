/*
 * pgsql_interaction_search_request.h
 *
 * This file is released under the terms of the Artistic License.  Please see
 * the file LICENSE, included in this package, for details.
 *
 * Copyright (C) 2002 Mark Wong & Jenny Zhang &
 *                    Open Source Development Lab, Inc.
 * Copyright (C) 2003 Satoshi Nagayasu & Hideyuki Kawashima &
 *                    Sachi Osawa & Hirokazu Kondo & Satoru Satake
 *
 * $Id: pgsql_interaction_search_request.h,v 1.1.2.3 2003/08/05 14:06:12 snaga Exp $
 */

#ifndef _LIBPQ_INTERACTION_SEARCH_REQUEST_H_
#define _LIBPQ_INTERACTION_SEARCH_REQUEST_H_

#include <libpq_interaction.h>

#define STMT_SEARCH_REQUEST \
  "SELECT * FROM GetPromoImages( %lld )" \
   " AS l( I_ID1 numeric(10)," \
          "I_T1 numeric(10)," \
          "I_ID2 numeric(10)," \
          "I_T2 numeric(10)," \
          "I_ID3 numeric(10)," \
          "I_T3 numeric(10)," \
          "I_ID4 numeric(10)," \
          "I_T4 numeric(10)," \
          "I_ID5 numeric(10)," \
          "I_T5 numeric(10) )"

int execute_search_request(struct db_context_t *, struct search_request_t *);

#endif /* _LIBPQ_INTERACTION_SEARCH_REQUEST_H_ */
