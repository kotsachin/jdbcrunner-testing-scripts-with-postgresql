/*
 * odbc_interaction_buy_confirm.h
 *
 * This file is released under the terms of the Artistic License.  Please see
 * the file LICENSE, included in this package, for details.
 *
 * Copyright (C) 2002 Mark Wong & Jenny Zhang &
 *                    Open Source Development Lab, Inc.
 *
 */

#ifndef _ODBC_INTERACTION_BUY_CONFIRM_H
#define _ODBC_INTERACTION_BUY_CONFIRM_H

#include <odbc_interaction.h>

#define STMT_BUYCONF "CALL BUY_CONFIRM(?,?,?,?,?,?,?," \
				"?,?,?,?,?,?,?," \
				"?,?,?,?,?,?,?," \
				"?," \
				"?,?,?,?,?,?," \
				"?,?,?,?,?,?," \
				"?,?,?,?,?,?," \
				"?,?,?,?,?,?," \
				"?,?,?,?,?,?," \
				"?,?,?,?,?,?," \
				"?,?,?,?,?,?," \
				"?,?,?,?,?,?," \
				"?,?,?,?,?,?," \
				"?,?,?,?,?,?," \
				"?,?,?,?,?,?," \
				"?,?,?,?,?,?," \
				"?,?,?,?,?,?," \
				"?,?,?,?,?,?," \
				"?,?,?,?,?,?," \
				"?,?,?,?,?,?," \
				"?,?,?,?,?,?," \
				"?,?,?,?,?,?," \
				"?,?,?,?,?,?," \
				"?,?,?,?,?,?)"

int execute_buy_confirm(struct db_context_t *odbcc,
	struct buy_confirm_t *data);

#endif /* _ODBC_INTERACTION_BUY_CONFIRM_H */