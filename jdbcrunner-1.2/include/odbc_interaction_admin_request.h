/*
 * odbc_interaction_admin_request.h
 *
 * This file is released under the terms of the Artistic License.  Please see
 * the file LICENSE, included in this package, for details.
 *
 * Copyright (C) 2002 Mark Wong & Jenny Zhang &
 *                    Open Source Development Lab, Inc.
 *
 * 28 february 2002
 */

#ifndef _ODBC_INTERACTION_ADMIN_REQUEST_H_
#define _ODBC_INTERACTION_ADMIN_REQUEST_H_

#include <odbc_interaction.h>

#define STMT_ADMIN_REQUEST "CALL admin_request(?, ?, ?, ?, ?, ?, ?, ?)"

int execute_admin_request(struct db_context_t *odbcc,
	struct admin_request_t *data);

#endif /* _ODBC_INTERACTION_ADMIN_REQUEST_H_ */
