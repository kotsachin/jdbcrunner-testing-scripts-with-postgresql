/*
 * pgsql_interaction_admin_request.h
 *
 * This file is released under the terms of the Artistic License.  Please see
 * the file LICENSE, included in this package, for details.
 *
 * Copyright (C) 2002 Mark Wong & Jenny Zhang &
 *                    Open Source Development Lab, Inc.
 * Copyright (C) 2003 Satoshi Nagayasu & Hideyuki Kawashima &
 *                    Sachi Osawa & Hirokazu Kondo & Satoru Satake
 *
 * $Id: pgsql_interaction_admin_request.h,v 1.1.2.1 2003/08/04 11:31:04 snaga Exp $
 */

#ifndef _LIBPQ_INTERACTION_ADMIN_REQUEST_H_
#define _LIBPQ_INTERACTION_ADMIN_REQUEST_H_

#include <libpq_interaction.h>

#define STMT_ADMIN_REQUEST \
  "SELECT * FROM admin_request( %lld )" \
  "    AS l( i_srp NUMERIC(17,2)," \
  "        i_cost NUMERIC(17,2)," \
  "        i_title VARCHAR(60)," \
  "        i_image numeric(10)," \
  "        i_thumbnail numeric(10)," \
  "        a_fname VARCHAR(20)," \
  "        a_lname VARCHAR(20) )"

int execute_admin_request(struct db_context_t *, struct admin_request_t *);

#endif /* _LIBPQ_INTERACTION_ADMIN_REQUEST_H_ */
