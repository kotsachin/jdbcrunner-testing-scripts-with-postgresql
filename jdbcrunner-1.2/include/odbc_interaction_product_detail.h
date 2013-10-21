/*
 * odbc_interaction_product_detail.h
 *
 * This file is released under the terms of the Artistic License.  Please see
 * the file LICENSE, included in this package, for details.
 *
 * Copyright (C) 2002 Mark Wong & Jenny Zhang &
 *                    Open Source Development Lab, Inc.
 *
 * 28 february 2002
 */

#ifndef _ODBC_INTERACTION_PRODUCT_DETAIL_H_
#define _ODBC_INTERACTION_PRODUCT_DETAIL_H_

#include <odbc_interaction.h>

#define STMT_PRODUCT_DETAIL \
	"CALL product_detail(?, ?, ?, ?, ?, ?, ?, ?, " \
	"?, ?, ?, ?, ?, ?, ?, ?)"

int execute_product_detail(struct db_context_t *odbcc,
	struct product_detail_t *data);

#endif /* _ODBC_INTERACTION_PRODUCT_DETAIL_H_ */
