/*
 * odbc_interaction_best_sellers.h
 *
 * This file is released under the terms of the Artistic License.  Please see
 * the file LICENSE, included in this package, for details.
 *
 * Copyright (C) 2002 Mark Wong & Jenny Zhang &
 *                    Open Source Development Lab, Inc.
 *
 * 26 february 2002
 */

#ifndef _ODBC_INTERACTION_BEST_SELLERS_H_
#define _ODBC_INTERACTION_BEST_SELLERS_H_

#include <odbc_interaction.h>

#define STMT_BEST_SELLERS \
	"CALL best_sellers(?, ?, " \
	"?, ?, ?, ?, ?, "\
	"?, ?, ?, ?, ?, "\
	"?, "\
	"?, ?, ?, ?, " \
	"?, ?, ?, ?, " \
	"?, ?, ?, ?, " \
	"?, ?, ?, ?, " \
	"?, ?, ?, ?, " \
	"?, ?, ?, ?, " \
	"?, ?, ?, ?, " \
	"?, ?, ?, ?, " \
	"?, ?, ?, ?, " \
	"?, ?, ?, ?, " \
	"?, ?, ?, ?, " \
	"?, ?, ?, ?, " \
	"?, ?, ?, ?, " \
	"?, ?, ?, ?, " \
	"?, ?, ?, ?, " \
	"?, ?, ?, ?, " \
	"?, ?, ?, ?, " \
	"?, ?, ?, ?, " \
	"?, ?, ?, ?, " \
	"?, ?, ?, ?, " \
	"?, ?, ?, ?, " \
	"?, ?, ?, ?, " \
	"?, ?, ?, ?, " \
	"?, ?, ?, ?, " \
	"?, ?, ?, ?, " \
	"?, ?, ?, ?, " \
	"?, ?, ?, ?, " \
	"?, ?, ?, ?, " \
	"?, ?, ?, ?, " \
	"?, ?, ?, ?, " \
	"?, ?, ?, ?, " \
	"?, ?, ?, ?, " \
	"?, ?, ?, ?, " \
	"?, ?, ?, ?, " \
	"?, ?, ?, ?, " \
	"?, ?, ?, ?, " \
	"?, ?, ?, ?, " \
	"?, ?, ?, ?, " \
	"?, ?, ?, ?, " \
	"?, ?, ?, ?, " \
	"?, ?, ?, ?, " \
	"?, ?, ?, ?, " \
	"?, ?, ?, ?, " \
	"?, ?, ?, ?, " \
	"?, ?, ?, ?, " \
	"?, ?, ?, ?, " \
	"?, ?, ?, ?, " \
	"?, ?, ?, ?, " \
	"?, ?, ?, ?, " \
	"?, ?, ?, ?)"

int execute_best_sellers(struct db_context_t *odbcc,
	struct best_sellers_t *data);

#endif /* _ODBC_INTERACTION_BEST_SELLERS_H_ */
