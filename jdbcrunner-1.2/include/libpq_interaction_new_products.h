/*
 * pgsql_interaction_new_products.h
 *
 * This file is released under the terms of the Artistic License.  Please see
 * the file LICENSE, included in this package, for details.
 *
 * Copyright (C) 2002 Mark Wong & Jenny Zhang &
 *                    Open Source Development Lab, Inc.
 * Copyright (C) 2003 Satoshi Nagayasu & Hideyuki Kawashima &
 *                    Sachi Osawa & Hirokazu Kondo & Satoru Satake
 *
 * $Id: pgsql_interaction_new_products.h,v 1.1.2.3 2003/08/05 13:38:16 snaga Exp $
 */

#ifndef _LIBPQ_INTERACTION_NEW_PRODUCTS_H_
#define _LIBPQ_INTERACTION_NEW_PRODUCTS_H_

#include <libpq_interaction.h>

#define STMT_NEW_PRODUCTS \
  "SELECT * FROM new_products ( '%s', %lld )" \
   " AS l( i_related1 NUMERIC(10)," \
          "i_related2 NUMERIC(10)," \
          "i_related3 NUMERIC(10)," \
          "i_related4 NUMERIC(10)," \
          "i_related5 NUMERIC(10)," \
          "i_thumbnail1 NUMERIC(10)," \
          "i_thumbnail2 NUMERIC(10)," \
          "i_thumbnail3 NUMERIC(10)," \
          "i_thumbnail4 NUMERIC(10)," \
          "i_thumbnail5 NUMERIC(10)," \
          "items NUMERIC(2)," \
          "i_id1 NUMERIC(10)," \
          "i_title1 VARCHAR(60)," \
          "a_fname1 VARCHAR(20)," \
          "a_lname1 VARCHAR(20)," \
          "i_id2 NUMERIC(10)," \
          "i_title2 VARCHAR(60)," \
          "a_fname2 VARCHAR(20)," \
          "a_lname2 VARCHAR(20)," \
          "i_id3 NUMERIC(10)," \
          "i_title3 VARCHAR(60)," \
          "a_fname3 VARCHAR(20)," \
          "a_lname3 VARCHAR(20)," \
          "i_id4 NUMERIC(10)," \
          "i_title4 VARCHAR(60)," \
          "a_fname4 VARCHAR(20)," \
          "a_lname4 VARCHAR(20)," \
          "i_id5 NUMERIC(10)," \
          "i_title5 VARCHAR(60)," \
          "a_fname5 VARCHAR(20)," \
          "a_lname5 VARCHAR(20)," \
          "i_id6 NUMERIC(10)," \
          "i_title6 VARCHAR(60)," \
          "a_fname6 VARCHAR(20)," \
          "a_lname6 VARCHAR(20)," \
          "i_id7 NUMERIC(10)," \
          "i_title7 VARCHAR(60)," \
          "a_fname7 VARCHAR(20)," \
          "a_lname7 VARCHAR(20)," \
          "i_id8 NUMERIC(10)," \
          "i_title8 VARCHAR(60)," \
          "a_fname8 VARCHAR(20)," \
          "a_lname8 VARCHAR(20)," \
          "i_id9 NUMERIC(10)," \
          "i_title9 VARCHAR(60)," \
          "a_fname9 VARCHAR(20)," \
          "a_lname9 VARCHAR(20)," \
          "i_id10 NUMERIC(10)," \
          "i_title10 VARCHAR(60)," \
          "a_fname10 VARCHAR(20)," \
          "a_lname10 VARCHAR(20)," \
          "i_id11 NUMERIC(10)," \
          "i_title11 VARCHAR(60)," \
          "a_fname11 VARCHAR(20)," \
          "a_lname11 VARCHAR(20)," \
          "i_id12 NUMERIC(10)," \
          "i_title12 VARCHAR(60)," \
          "a_fname12 VARCHAR(20)," \
          "a_lname12 VARCHAR(20)," \
          "i_id13 NUMERIC(10)," \
          "i_title13 VARCHAR(60)," \
          "a_fname13 VARCHAR(20)," \
          "a_lname13 VARCHAR(20)," \
          "i_id14 NUMERIC(10)," \
          "i_title14 VARCHAR(60)," \
          "a_fname14 VARCHAR(20)," \
          "a_lname14 VARCHAR(20)," \
          "i_id15 NUMERIC(10)," \
          "i_title15 VARCHAR(60)," \
          "a_fname15 VARCHAR(20)," \
          "a_lname15 VARCHAR(20)," \
          "i_id16 NUMERIC(10)," \
          "i_title16 VARCHAR(60)," \
          "a_fname16 VARCHAR(20)," \
          "a_lname16 VARCHAR(20)," \
          "i_id17 NUMERIC(10)," \
          "i_title17 VARCHAR(60)," \
          "a_fname17 VARCHAR(20)," \
          "a_lname17 VARCHAR(20)," \
          "i_id18 NUMERIC(10)," \
          "i_title18 VARCHAR(60)," \
          "a_fname18 VARCHAR(20)," \
          "a_lname18 VARCHAR(20)," \
          "i_id19 NUMERIC(10)," \
          "i_title19 VARCHAR(60)," \
          "a_fname19 VARCHAR(20)," \
          "a_lname19 VARCHAR(20)," \
          "i_id20 NUMERIC(10)," \
          "i_title20 VARCHAR(60)," \
          "a_fname20 VARCHAR(20)," \
          "a_lname20 VARCHAR(20)," \
          "i_id21 NUMERIC(10)," \
          "i_title21 VARCHAR(60)," \
          "a_fname21 VARCHAR(20)," \
          "a_lname21 VARCHAR(20)," \
          "i_id22 NUMERIC(10)," \
          "i_title22 VARCHAR(60)," \
          "a_fname22 VARCHAR(20)," \
          "a_lname22 VARCHAR(20)," \
          "i_id23 NUMERIC(10)," \
          "i_title23 VARCHAR(60)," \
          "a_fname23 VARCHAR(20)," \
          "a_lname23 VARCHAR(20)," \
          "i_id24 NUMERIC(10)," \
          "i_title24 VARCHAR(60)," \
          "a_fname24 VARCHAR(20)," \
          "a_lname24 VARCHAR(20)," \
          "i_id25 NUMERIC(10)," \
          "i_title25 VARCHAR(60)," \
          "a_fname25 VARCHAR(20)," \
          "a_lname25 VARCHAR(20)," \
          "i_id26 NUMERIC(10)," \
          "i_title26 VARCHAR(60)," \
          "a_fname26 VARCHAR(20)," \
          "a_lname26 VARCHAR(20)," \
          "i_id27 NUMERIC(10)," \
          "i_title27 VARCHAR(60)," \
          "a_fname27 VARCHAR(20)," \
          "a_lname27 VARCHAR(20)," \
          "i_id28 NUMERIC(10)," \
          "i_title28 VARCHAR(60)," \
          "a_fname28 VARCHAR(20)," \
          "a_lname28 VARCHAR(20)," \
          "i_id29 NUMERIC(10)," \
          "i_title29 VARCHAR(60)," \
          "a_fname29 VARCHAR(20)," \
          "a_lname29 VARCHAR(20)," \
          "i_id30 NUMERIC(10)," \
          "i_title30 VARCHAR(60)," \
          "a_fname30 VARCHAR(20)," \
          "a_lname30 VARCHAR(20)," \
          "i_id31 NUMERIC(10)," \
          "i_title31 VARCHAR(60)," \
          "a_fname31 VARCHAR(20)," \
          "a_lname31 VARCHAR(20)," \
          "i_id32 NUMERIC(10)," \
          "i_title32 VARCHAR(60)," \
          "a_fname32 VARCHAR(20)," \
          "a_lname32 VARCHAR(20)," \
          "i_id33 NUMERIC(10)," \
          "i_title33 VARCHAR(60)," \
          "a_fname33 VARCHAR(20)," \
          "a_lname33 VARCHAR(20)," \
          "i_id34 NUMERIC(10)," \
          "i_title34 VARCHAR(60)," \
          "a_fname34 VARCHAR(20)," \
          "a_lname34 VARCHAR(20)," \
          "i_id35 NUMERIC(10)," \
          "i_title35 VARCHAR(60)," \
          "a_fname35 VARCHAR(20)," \
          "a_lname35 VARCHAR(20)," \
          "i_id36 NUMERIC(10)," \
          "i_title36 VARCHAR(60)," \
          "a_fname36 VARCHAR(20)," \
          "a_lname36 VARCHAR(20)," \
          "i_id37 NUMERIC(10)," \
          "i_title37 VARCHAR(60)," \
          "a_fname37 VARCHAR(20)," \
          "a_lname37 VARCHAR(20)," \
          "i_id38 NUMERIC(10)," \
          "i_title38 VARCHAR(60)," \
          "a_fname38 VARCHAR(20)," \
          "a_lname38 VARCHAR(20)," \
          "i_id39 NUMERIC(10)," \
          "i_title39 VARCHAR(60)," \
          "a_fname39 VARCHAR(20)," \
          "a_lname39 VARCHAR(20)," \
          "i_id40 NUMERIC(10)," \
          "i_title40 VARCHAR(60)," \
          "a_fname40 VARCHAR(20)," \
          "a_lname40 VARCHAR(20)," \
          "i_id41 NUMERIC(10)," \
          "i_title41 VARCHAR(60)," \
          "a_fname41 VARCHAR(20)," \
          "a_lname41 VARCHAR(20)," \
          "i_id42 NUMERIC(10)," \
          "i_title42 VARCHAR(60)," \
          "a_fname42 VARCHAR(20)," \
          "a_lname42 VARCHAR(20)," \
          "i_id43 NUMERIC(10)," \
          "i_title43 VARCHAR(60)," \
          "a_fname43 VARCHAR(20)," \
          "a_lname43 VARCHAR(20)," \
          "i_id44 NUMERIC(10)," \
          "i_title44 VARCHAR(60)," \
          "a_fname44 VARCHAR(20)," \
          "a_lname44 VARCHAR(20)," \
          "i_id45 NUMERIC(10)," \
          "i_title45 VARCHAR(60)," \
          "a_fname45 VARCHAR(20)," \
          "a_lname45 VARCHAR(20)," \
          "i_id46 NUMERIC(10)," \
          "i_title46 VARCHAR(60)," \
          "a_fname46 VARCHAR(20)," \
          "a_lname46 VARCHAR(20)," \
          "i_id47 NUMERIC(10)," \
          "i_title47 VARCHAR(60)," \
          "a_fname47 VARCHAR(20)," \
          "a_lname47 VARCHAR(20)," \
          "i_id48 NUMERIC(10)," \
          "i_title48 VARCHAR(60)," \
          "a_fname48 VARCHAR(20)," \
          "a_lname48 VARCHAR(20)," \
          "i_id49 NUMERIC(10)," \
          "i_title49 VARCHAR(60)," \
          "a_fname49 VARCHAR(20)," \
          "a_lname49 VARCHAR(20)," \
          "i_id50 NUMERIC(10)," \
          "i_title50 VARCHAR(60)," \
          "a_fname50 VARCHAR(20)," \
          "a_lname50 VARCHAR(20) )"

int execute_new_products(struct db_context_t *,	struct new_products_t *);

#endif /* _LIBPQ_INTERACTION_NEW_PRODUCTS_H_ */
