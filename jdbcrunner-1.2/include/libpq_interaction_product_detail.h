/*
 * pgsql_interaction_product_detail.h
 *
 * This file is released under the terms of the Artistic License.  Please see
 * the file LICENSE, included in this package, for details.
 *
 * Copyright (C) 2002 Mark Wong & Jenny Zhang &
 *                    Open Source Development Lab, Inc.
 * Copyright (C) 2003 Satoshi Nagayasu & Hideyuki Kawashima &
 *                    Sachi Osawa & Hirokazu Kondo & Satoru Satake
 *
 * $Id: pgsql_interaction_product_detail.h,v 1.1.2.3 2003/08/05 13:46:23 snaga Exp $
 */

#ifndef _LIBPQ_INTERACTION_PRODUCT_DETAIL_H_
#define _LIBPQ_INTERACTION_PRODUCT_DETAIL_H_

#include <libpq_interaction.h>

#define STMT_PRODUCT_DETAIL \
  "SELECT * FROM product_detail( %lld )" \
  "  AS l( i_title VARCHAR(60)," \
  "        a_fname VARCHAR(20)," \
  "        a_lname VARCHAR(20)," \
  "        i_pub_date VARCHAR(10)," \
  "        i_publisher VARCHAR(60)," \
  "        i_subject VARCHAR(60)," \
  "        i_desc VARCHAR(500)," \
  "        i_image NUMERIC(10)," \
  "        i_cost NUMERIC(17,2)," \
  "        i_srp NUMERIC(17,2)," \
  "        i_avail VARCHAR(10)," \
  "        i_isbn VARCHAR(13)," \
  "        i_page NUMERIC(4)," \
  "        i_backing VARCHAR(15)," \
  "        i_dimensions VARCHAR(25) )"

int execute_product_detail(struct db_context_t *, struct product_detail_t *);

#endif /* _LIBPQ_INTERACTION_PRODUCT_DETAIL_H_ */
