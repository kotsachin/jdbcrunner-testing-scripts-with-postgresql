/*
 * pgsql_interaction_admin_confirm.h
 *
 * This file is released under the terms of the Artistic License.  Please see
 * the file LICENSE, included in this package, for details.
 *
 * Copyright (C) 2002 Mark Wong & Jenny Zhang &
 *                    Open Source Development Lab, Inc.
 * Copyright (C) 2003 Satoshi Nagayasu & Hideyuki Kawashima &
 *                    Sachi Osawa & Hirokazu Kondo & Satoru Satake
 *
 * $Id: pgsql_interaction_admin_confirm.h,v 1.1.2.1 2003/08/04 11:31:04 snaga Exp $
 */

#ifndef _LIBPQ_INTERACTION_ADMIN_CONFIRM_H_
#define _LIBPQ_INTERACTION_ADMIN_CONFIRM_H_

#include <libpq_interaction.h>

#define STMT_ADMIN_CONFIRM \
  "SELECT * FROM admin_confirm( %lld, %lld, %lld, %f )" \
  "  AS l( i_image numeric(8)," \
  "        i_thumbnail NUMERIC(8)," \
  "        i_cost NUMERIC (17,2)," \
  "        i_title VARCHAR(60)," \
  "        a_fname VARCHAR(20)," \
  "        a_lname VARCHAR(20)," \
  "        i_subject VARCHAR(60)," \
  "        i_desc VARCHAR(500)," \
  "        i_srp NUMERIC(17,2)," \
  "        i_backing VARCHAR(15)," \
  "        i_page NUMERIC(4)," \
  "        i_publisher VARCHAR(60)," \
  "        i_pub_date date," \
  "        i_dimensions VARCHAR(25)," \
  "        i_isbn CHAR(13) )"

int execute_admin_confirm(struct db_context_t *, struct admin_confirm_t *);

#endif /* _LIBPQ_INTERACTION_ADMIN_CONFIRM_H_ */
