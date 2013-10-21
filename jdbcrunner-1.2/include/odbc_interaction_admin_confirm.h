/*
 * odbc_interaction_admin_confirm.h
 *
 * This file is released under the terms of the Artistic License.  Please see
 * the file LICENSE, included in this package, for details.
 *
 * Copyright (C) 2002 Mark Wong & Jenny Zhang &
 *                    Open Source Development Lab, Inc.
 *
 * 1 march 2002
 */

#ifndef _ODBC_INTERACTION_ADMIN_CONFIRM_H_
#define _ODBC_INTERACTION_ADMIN_CONFIRM_H_

#include <odbc_interaction.h>

#define STMT_ADMIN_CONFIRM \
	"CALL admin_confirm(?, ?, ?, ?, ?, ?, ?, ?, " \
	"?, ?, ?, ?, ?, ?, ?, ?)"

int execute_admin_confirm(struct db_context_t *odbcc,
    struct admin_confirm_t *data);

#endif /* _ODBC_INTERACTION_ADMIN_CONFIRM_H_ */
