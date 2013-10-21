/*
 * pgsql_interaction_buy_request.h
 *
 * This file is released under the terms of the Artistic License.  Please see
 * the file LICENSE, included in this package, for details.
 *
 * Copyright (C) 2002 Mark Wong & Jenny Zhang &
 *                    Open Source Development Lab, Inc.
 * Copyright (C) 2003 Satoshi Nagayasu & Hideyuki Kawashima &
 *                    Sachi Osawa & Hirokazu Kondo & Satoru Satake
 *
 * $Id: pgsql_interaction_buy_request.h,v 1.1.2.2 2003/08/05 07:22:00 snaga Exp $
 */

#ifndef _LIBPQ_INTERACTION_BUY_REQUEST_H_
#define _LIBPQ_INTERACTION_BUY_REQUEST_H_

#include <libpq_interaction.h>

#define STMT_BUYREQ "SELECT * FROM buy_request( %d,'%s',%lld,%f,'%s','%s'," \
                                    "'%s','%s','%s'," \
                                    "'%s','%s','%s','%s','%s','%s','%s' ) " \
  "AS l(" \
  "   local_c_discount NUMERIC(5,2)," \
  "   c_fname VARCHAR(15)," \
  "   c_lname VARCHAR(15)," \
  "   addr_street1 VARCHAR(40)," \
  "   addr_street2 VARCHAR(40)," \
  "   addr_city VARCHAR(30)," \
  "   addr_state VARCHAR(20)," \
  "   addr_zip VARCHAR(10)," \
  "   co_name VARCHAR(50)," \
  "   c_phone VARCHAR(16)," \
  "   c_email VARCHAR(50)," \
  "   c_birthday CHAR(10)," \
  "   c_data VARCHAR(500)," \
  "   c_passwd VARCHAR(20)," \
  "   c_id NUMERIC(10)," \
  "   sc_sub_total NUMERIC(17,2)," \
  "   sc_tax NUMERIC(17,2)," \
  "   sc_ship_cost NUMERIC(5,2)," \
  "   sc_total NUMERIC(17,2)," \
  "   num_item NUMERIC(2)," \
  "   scl_i_id1 NUMERIC(10)," \
  "   scl_title1 VARCHAR(60)," \
  "   scl_cost1 NUMERIC(17,2)," \
  "   scl_srp1 NUMERIC(17,2)," \
  "   scl_backing1 VARCHAR(15)," \
  "   scl_qty1 NUMERIC(3)," \
  "   scl_i_id2 NUMERIC(10)," \
  "   scl_title2 VARCHAR(60)," \
  "   scl_cost2 NUMERIC(17,2)," \
  "   scl_srp2 NUMERIC(17,2)," \
  "   scl_backing2 VARCHAR(15)," \
  "   scl_qty2 NUMERIC(3)," \
  "   scl_i_id3 NUMERIC(10)," \
  "   scl_title3 VARCHAR(60)," \
  "   scl_cost3 NUMERIC(17,2)," \
  "   scl_srp3 NUMERIC(17,2)," \
  "   scl_backing3 VARCHAR(15)," \
  "   scl_qty3 NUMERIC(3)," \
  "   scl_i_id4 NUMERIC(10)," \
  "   scl_title4 VARCHAR(60)," \
  "   scl_cost4 NUMERIC(17,2)," \
  "   scl_srp4 NUMERIC(17,2)," \
  "   scl_backing4 VARCHAR(15)," \
  "   scl_qty4 NUMERIC(3)," \
  "   scl_i_id5 NUMERIC(10)," \
  "   scl_title5 VARCHAR(60)," \
  "   scl_cost5 NUMERIC(17,2)," \
  "   scl_srp5 NUMERIC(17,2)," \
  "   scl_backing5 VARCHAR(15)," \
  "   scl_qty5 NUMERIC(3)," \
  "   scl_i_id6 NUMERIC(10)," \
  "   scl_title6 VARCHAR(60)," \
  "   scl_cost6 NUMERIC(17,2)," \
  "   scl_srp6 NUMERIC(17,2)," \
  "   scl_backing6 VARCHAR(15)," \
  "   scl_qty6 NUMERIC(3)," \
  "   scl_i_id7 NUMERIC(10)," \
  "   scl_title7 VARCHAR(60)," \
  "   scl_cost7 NUMERIC(17,2)," \
  "   scl_srp7 NUMERIC(17,2)," \
  "   scl_backing7 VARCHAR(15)," \
  "   scl_qty7 NUMERIC(3)," \
  "   scl_i_id8 NUMERIC(10)," \
  "   scl_title8 VARCHAR(60)," \
  "   scl_cost8 NUMERIC(17,2)," \
  "   scl_srp8 NUMERIC(17,2)," \
  "   scl_backing8 VARCHAR(15)," \
  "   scl_qty8 NUMERIC(3)," \
  "   scl_i_id9 NUMERIC(10)," \
  "   scl_title9 VARCHAR(60)," \
  "   scl_cost9 NUMERIC(17,2)," \
  "   scl_srp9 NUMERIC(17,2)," \
  "   scl_backing9 VARCHAR(15)," \
  "   scl_qty9 NUMERIC(3)," \
  "   scl_i_id10 NUMERIC(10)," \
  "   scl_title10 VARCHAR(60)," \
  "   scl_cost10 NUMERIC(17,2)," \
  "   scl_srp10 NUMERIC(17,2)," \
  "   scl_backing10 VARCHAR(15)," \
  "   scl_qty10 NUMERIC(3)," \
  "   scl_i_id11 NUMERIC(10)," \
  "   scl_title11 VARCHAR(60)," \
  "   scl_cost11 NUMERIC(17,2)," \
  "   scl_srp11 NUMERIC(17,2)," \
  "   scl_backing11 VARCHAR(15)," \
  "   scl_qty11 NUMERIC(3)," \
  "   scl_i_id12 NUMERIC(10)," \
  "   scl_title12 VARCHAR(60)," \
  "   scl_cost12 NUMERIC(17,2)," \
  "   scl_srp12 NUMERIC(17,2)," \
  "   scl_backing12 VARCHAR(15)," \
  "   scl_qty12 NUMERIC(3)," \
  "   scl_i_id13 NUMERIC(10)," \
  "   scl_title13 VARCHAR(60)," \
  "   scl_cost13 NUMERIC(17,2)," \
  "   scl_srp13 NUMERIC(17,2)," \
  "   scl_backing13 VARCHAR(15)," \
  "   scl_qty13 NUMERIC(3)," \
  "   scl_i_id14 NUMERIC(10)," \
  "   scl_title14 VARCHAR(60)," \
  "   scl_cost14 NUMERIC(17,2)," \
  "   scl_srp14 NUMERIC(17,2)," \
  "   scl_backing14 VARCHAR(15)," \
  "   scl_qty14 NUMERIC(3)," \
  "   scl_i_id15 NUMERIC(10)," \
  "   scl_title15 VARCHAR(60)," \
  "   scl_cost15 NUMERIC(17,2)," \
  "   scl_srp15 NUMERIC(17,2)," \
  "   scl_backing15 VARCHAR(15)," \
  "   scl_qty15 NUMERIC(3)," \
  "   scl_i_id16 NUMERIC(10)," \
  "   scl_title16 VARCHAR(60)," \
  "   scl_cost16 NUMERIC(17,2)," \
  "   scl_srp16 NUMERIC(17,2)," \
  "   scl_backing16 VARCHAR(15)," \
  "   scl_qty16 NUMERIC(3)," \
  "   scl_i_id17 NUMERIC(10)," \
  "   scl_title17 VARCHAR(60)," \
  "   scl_cost17 NUMERIC(17,2)," \
  "   scl_srp17 NUMERIC(17,2)," \
  "   scl_backing17 VARCHAR(15)," \
  "   scl_qty17 NUMERIC(3)," \
  "   scl_i_id18 NUMERIC(10)," \
  "   scl_title18 VARCHAR(60)," \
  "   scl_cost18 NUMERIC(17,2)," \
  "   scl_srp18 NUMERIC(17,2)," \
  "   scl_backing18 VARCHAR(15)," \
  "   scl_qty18 NUMERIC(3)," \
  "   scl_i_id19 NUMERIC(10)," \
  "   scl_title19 VARCHAR(60)," \
  "   scl_cost19 NUMERIC(17,2)," \
  "   scl_srp19 NUMERIC(17,2)," \
  "   scl_backing19 VARCHAR(15)," \
  "   scl_qty19 NUMERIC(3)," \
  "   scl_i_id20 NUMERIC(10)," \
  "   scl_title20 VARCHAR(60)," \
  "   scl_cost20 NUMERIC(17,2)," \
  "   scl_srp20 NUMERIC(17,2)," \
  "   scl_backing20 VARCHAR(15)," \
  "   scl_qty20 NUMERIC(3) )"

int execute_buy_request(struct db_context_t *, struct buy_request_t *);

#endif /* _LIBPQ_INTERACTION_BUY_REQUEST_H_ */
