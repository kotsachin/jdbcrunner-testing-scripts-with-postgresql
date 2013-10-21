/*
 * pgsql_interaction_debug.h
 *
 * This file is released under the terms of the Artistic License.  Please see
 * the file LICENSE, included in this package, for details.
 *
 * Copyright (C) 2003 Satoshi Nagayasu & Hideyuki Kawashima &
 *                    Sachi Osawa & Hirokazu Kondo & Satoru Satake
 *
 * $Id: pgsql_interaction_debug.h,v 1.1.2.2 2003/08/05 07:22:00 snaga Exp $
 */

#ifndef _LIBPQ_INTERACTION_DEBUG_
#define _LIBPQ_INTERACTION_DEBUG_

#include <interaction_data.h>

void print_admin_request_data(struct admin_request_t *);
void print_admin_confirm_data(struct admin_confirm_t *);
void print_product_detail_data(struct product_detail_t *);
void print_shopping_cart_data(struct shopping_cart_t *);
void print_home_data(struct home_t *);
void print_best_sellers_data(struct best_sellers_t *);
void print_buy_confirm_data(struct buy_confirm_t *);
void print_new_products_data(struct new_products_t *);
void print_order_display_data(struct order_display_t *);
void print_order_inquiry_data(struct order_inquiry_t *);
void print_search_request_data(struct search_request_t *);
void print_search_result_data(struct search_results_t *);

#endif /* _LIBPQ_INTERACTION_DEBUG_ */
