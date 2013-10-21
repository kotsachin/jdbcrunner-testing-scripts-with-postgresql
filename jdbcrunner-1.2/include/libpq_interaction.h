/*
 * pgsql_interaction.h
 *
 * This file is released under the terms of the Artistic License.  Please see
 * the file LICENSE, included in this package, for details.
 *
 * Copyright (C) 2002 Mark Wong & Jenny Zhang &
 *                    Open Source Development Lab, Inc.
 * Copyright (C) 2003 Satoshi Nagayasu & Hideyuki Kawashima &
 *                    Sachi Osawa & Hirokazu Kondo & Satoru Satake
 *
 * $Id: pgsql_interaction.h,v 1.1.2.2 2003/08/05 07:22:00 snaga Exp $
 */

#ifndef _LIBPQ_INTERACTION_H_
#define _LIBPQ_INTERACTION_H_

#include <stdlib.h>
#include <string.h>
#include <libpq-fe.h>

#include <assert.h>

#include <common.h>
#include <interaction_data.h>

#include <libpq_interaction_debug.h>

struct db_context_t
{
	PGconn *conn;
};

/* Prototypes */
int _db_connect(struct db_context_t *pgsqlc);
int _db_disconnect(struct db_context_t *pgsqlc);
int pgsql_error(PGconn *);
int _db_init(const char *, const char *, const char *, const char *);
PGresult *pgsql_execute(PGconn *, const char *, ...);
int commit_transaction(struct db_context_t *dbc);
int rollback_transaction(struct db_context_t *dbc);

#endif /* _LIBPQ_INTERACTION_H_ */
