/*
 * odbc_interaction_order_inquiry.h
 *
 * This file is released under the terms of the Artistic License.  Please see
 * the file LICENSE, included in this package, for details.
 *
 * Copyright (C) 2002 Mark Wong & Jenny Zhang &
 *                    Open Source Development Lab, Inc.
 *
 */

#ifndef _ODBC_INTERACTION_ORDER_INQUIRY_H 
#define _ODBC_INTERACTION_ORDER_INQUIRY_H

#include <odbc_interaction.h>

#define STMT_ORDER_INQUIRY "CALL order_inquiry(?,?)"

int execute_order_inquiry(struct db_context_t *odbcc,
	struct order_inquiry_t *data);

#endif /* _ODBC_INTERACTION_ORDER_INQUIRY_H */
