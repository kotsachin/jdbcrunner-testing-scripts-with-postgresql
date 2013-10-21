/*
 * db.h
 *
 * This file is released under the terms of the Artistic License.  Please see
 * the file LICENSE, included in this package, for details.
 *
 * Copyright (C) 2002 Mark Wong & Open Source Development Lab, Inc.
 *
 * 06 March 2003
 */

#ifndef _DB_H_
#define _DB_H_

#include <interaction_data.h>

#ifdef ODBC
/* ODBC include files. */
#include <odbc_interaction.h>
#endif

#ifdef LIBPQ
#include <libpq_interaction.h>
#endif

#define STATUS_ROLLBACK 4

int db_connect(struct db_context_t *dbc);
#ifdef ODBC
int db_init(char *sname, char *uname, char *auth);
#endif
#ifdef LIBPQ
int db_init(char *shost, char *dbname, char *uname, char *auth);
#endif
int db_connect(struct db_context_t *dbc);
int db_disconnect(struct db_context_t *dbc);
int process_interaction(int interaction, struct db_context_t *dbc,
	union interaction_data_t *data);

#endif /* _DB_H_ */
