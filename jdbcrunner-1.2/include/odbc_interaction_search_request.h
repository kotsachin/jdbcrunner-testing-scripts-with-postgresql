/*
 * odbc_interaction_search_request.h
 *
 * This file is released under the terms of the Artistic License.  Please see
 * the file LICENSE, included in this package, for details.
 *
 * Copyright (C) 2002 Mark Wong & Jenny Zhang &
 *                    Open Source Development Lab, Inc.
 *
 * 28 february 2002
 */

#ifndef _ODBC_INTERACTION_SEARCH_REQUEST_H_
#define _ODBC_INTERACTION_SEARCH_REQUEST_H_

#include <odbc_interaction.h>

#define STMT_SEARCH_REQUEST \
	"CALL GetPromoImages(?, " \
	"?, ?, ?, ?, ?, " \
	"?, ?, ?, ?, ?)"

int execute_search_request(struct db_context_t *odbcc,
	struct search_request_t *data);

#endif /* _ODBC_INTERACTION_SEARCH_REQUEST_H_ */
