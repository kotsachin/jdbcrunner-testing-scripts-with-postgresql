/*
 * pgsql_interaction_order_display.h
 *
 * This file is released under the terms of the Artistic License.  Please see
 * the file LICENSE, included in this package, for details.
 *
 * Copyright (C) 2002 Mark Wong & Jenny Zhang &
 *                    Open Source Development Lab, Inc.
 * Copyright (C) 2003 Satoshi Nagayasu & Hideyuki Kawashima &
 *                    Sachi Osawa & Hirokazu Kondo & Satoru Satake
 *
 * $Id: pgsql_interaction_order_display.h,v 1.1.2.2 2003/08/05 07:22:00 snaga Exp $
 */

#ifndef _LIBPQ_INTERACTION_ORDER_DISPLAY_H_
#define _LIBPQ_INTERACTION_ORDER_DISPLAY_H_

#include <libpq_interaction.h>

#define STMT_ORDER_DISPLAY \
  "SELECT * FROM order_display( '%s', '%s' ) " \
  "AS l( c_fname VARCHAR(15)," \
        "c_lname VARCHAR(15)," \
        "c_phone VARCHAR(16)," \
        "c_email VARCHAR(50)," \
        "o_id NUMERIC(10)," \
        "o_date CHAR(26)," \
        "o_sub_total NUMERIC(17, 2)," \
        "o_tax NUMERIC(17, 2)," \
        "o_total NUMERIC(17, 2)," \
        "o_ship_type VARCHAR(10)," \
        "o_ship_date CHAR(26)," \
        "o_status VARCHAR(15)," \
        "cx_type VARCHAR(10)," \
        "cx_auth_id VARCHAR(15)," \
        "bill_addr_street1 VARCHAR(40)," \
        "bill_addr_street2 VARCHAR(40)," \
        "bill_addr_city VARCHAR(30)," \
        "bill_addr_state VARCHAR(20)," \
        "bill_addr_zip VARCHAR(10)," \
        "bill_co_name VARCHAR(50)," \
        "ship_addr_street1 VARCHAR(40)," \
        "ship_addr_street2 VARCHAR(40)," \
        "ship_addr_city VARCHAR(30)," \
        "ship_addr_state VARCHAR(20)," \
        "ship_addr_zip VARCHAR(10)," \
        "ship_co_name VARCHAR(50)," \
        "num_item NUMERIC(3,0)," \
        "i_id1 NUMERIC(10)," \
        "i_title1 VARCHAR(60)," \
        "i_publisher1 VARCHAR(60)," \
        "i_cost1 NUMERIC(17, 2)," \
        "ol_qty1 NUMERIC(3)," \
        "ol_discount1 NUMERIC(17, 2)," \
        "ol_comments1 VARCHAR(100)," \
        "i_id2 NUMERIC(10)," \
        "i_title2 VARCHAR(60)," \
        "i_publisher2 VARCHAR(60)," \
        "i_cost2 NUMERIC(17, 2)," \
        "ol_qty2 NUMERIC(3)," \
        "ol_discount2 NUMERIC(17, 2)," \
        "ol_comments2 VARCHAR(100)," \
        "i_id3 NUMERIC(10)," \
        "i_title3 VARCHAR(60)," \
        "i_publisher3 VARCHAR(60)," \
        "i_cost3 NUMERIC(17, 2)," \
        "ol_qty3 NUMERIC(3)," \
        "ol_discount3 NUMERIC(17, 2)," \
        "ol_comments3 VARCHAR(100)," \
        "i_id4 NUMERIC(10)," \
        "i_title4 VARCHAR(60)," \
        "i_publisher4 VARCHAR(60)," \
        "i_cost4 NUMERIC(17, 2)," \
        "ol_qty4 NUMERIC(3)," \
        "ol_discount4 NUMERIC(17, 2)," \
        "ol_comments4 VARCHAR(100)," \
        "i_id5 NUMERIC(10)," \
        "i_title5 VARCHAR(60)," \
        "i_publisher5 VARCHAR(60)," \
        "i_cost5 NUMERIC(17, 2)," \
        "ol_qty5 NUMERIC(3)," \
        "ol_discount5 NUMERIC(17, 2)," \
        "ol_comments5 VARCHAR(100)," \
        "i_id6 numeric(10)," \
        "i_title6 VARCHAR(60)," \
        "i_publisher6 VARCHAR(60)," \
        "i_cost6 numeric(17, 2)," \
        "ol_qty6 numeric(3)," \
        "ol_discount6 numeric(17, 2)," \
        "ol_comments6 VARCHAR(100)," \
        "i_id7 numeric(10)," \
        "i_title7 VARCHAR(60)," \
        "i_publisher7 VARCHAR(60)," \
        "i_cost7 numeric(17, 2)," \
        "ol_qty7 numeric(3)," \
        "ol_discount7 numeric(17, 2)," \
        "ol_comments7 VARCHAR(100)," \
        "i_id8 numeric(10)," \
        "i_title8 VARCHAR(60)," \
        "i_publisher8 VARCHAR(60)," \
        "i_cost8 numeric(17, 2)," \
        "ol_qty8 numeric(3)," \
        "ol_discount8 numeric(17, 2)," \
        "ol_comments8 VARCHAR(100)," \
        "i_id9 numeric(10)," \
        "i_title9 VARCHAR(60)," \
        "i_publisher9 VARCHAR(60)," \
        "i_cost9 numeric(17, 2)," \
        "ol_qty9 numeric(3)," \
        "ol_discount9 numeric(17, 2)," \
        "ol_comments9 VARCHAR(100)," \
        "i_id10 numeric(10)," \
        "i_title10 VARCHAR(60)," \
        "i_publisher10 VARCHAR(60)," \
        "i_cost10 numeric(17, 2)," \
        "ol_qty10 numeric(3)," \
        "ol_discount10 numeric(17, 2)," \
        "ol_comments10 VARCHAR(100)," \
        "i_id11 numeric(10)," \
        "i_title11 VARCHAR(60)," \
        "i_publisher11 VARCHAR(60)," \
        "i_cost11 numeric(17, 2)," \
        "ol_qty11 numeric(3)," \
        "ol_discount11 numeric(17, 2)," \
        "ol_comments11 VARCHAR(100)," \
        "i_id12 numeric(10)," \
        "i_title12 VARCHAR(60)," \
        "i_publisher12 VARCHAR(60)," \
        "i_cost12 numeric(17, 2)," \
        "ol_qty12 numeric(3)," \
        "ol_discount12 numeric(17, 2)," \
        "ol_comments12 VARCHAR(100)," \
        "i_id13 numeric(10)," \
        "i_title13 VARCHAR(60)," \
        "i_publisher13 VARCHAR(60)," \
        "i_cost13 numeric(17, 2)," \
        "ol_qty13 numeric(3)," \
        "ol_discount13 numeric(17, 2)," \
        "ol_comments13 VARCHAR(100)," \
        "i_id14 numeric(10)," \
        "i_title14 VARCHAR(60)," \
        "i_publisher14 VARCHAR(60)," \
        "i_cost14 numeric(17, 2)," \
        "ol_qty14 numeric(3)," \
        "ol_discount14 numeric(17, 2)," \
        "ol_comments14 VARCHAR(100)," \
        "i_id15 numeric(10)," \
        "i_title15 VARCHAR(60)," \
        "i_publisher15 VARCHAR(60)," \
        "i_cost15 numeric(17, 2)," \
        "ol_qty15 numeric(3)," \
        "ol_discount15 numeric(17, 2)," \
        "ol_comments15 VARCHAR(100)," \
        "i_id16 numeric(10)," \
        "i_title16 VARCHAR(60)," \
        "i_publisher16 VARCHAR(60)," \
        "i_cost16 numeric(17, 2)," \
        "ol_qty16 numeric(3)," \
        "ol_discount16 numeric(17, 2)," \
        "ol_comments16 VARCHAR(100)," \
        "i_id17 numeric(10)," \
        "i_title17 VARCHAR(60)," \
        "i_publisher17 VARCHAR(60)," \
        "i_cost17 numeric(17, 2)," \
        "ol_qty17 numeric(3)," \
        "ol_discount17 numeric(17, 2)," \
        "ol_comments17 VARCHAR(100)," \
        "i_id18 numeric(10)," \
        "i_title18 VARCHAR(60)," \
        "i_publisher18 VARCHAR(60)," \
        "i_cost18 numeric(17, 2)," \
        "ol_qty18 numeric(3)," \
        "ol_discount18 numeric(17, 2)," \
        "ol_comments18 VARCHAR(100)," \
        "i_id19 numeric(10)," \
        "i_title19 VARCHAR(60)," \
        "i_publisher19 VARCHAR(60)," \
        "i_cost19 numeric(17, 2)," \
        "ol_qty19 numeric(3)," \
        "ol_discount19 numeric(17, 2)," \
        "ol_comments19 VARCHAR(100)," \
        "i_id20 numeric(10)," \
        "i_title20 VARCHAR(60)," \
        "i_publisher20 VARCHAR(60)," \
        "i_cost20 numeric(17, 2)," \
        "ol_qty20 numeric(3)," \
        "ol_discount20 numeric(17, 2)," \
        "ol_comments20 VARCHAR(100) )"

int execute_order_display(struct db_context_t *, struct order_display_t *);

#endif /* _LIBPQ_INTERACTION_ORDER_DISPLAY_H_ */
