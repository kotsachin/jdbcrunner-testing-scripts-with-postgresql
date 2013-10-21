/*
 * pgsql_interaction_home.h
 *
 * This file is released under the terms of the Artistic License.  Please see
 * the file LICENSE, included in this package, for details.
 *
 * Copyright (C) 2002 Mark Wong & Jenny Zhang &
 *                    Open Source Development Lab, Inc.
 * Copyright (C) 2003 Satoshi Nagayasu & Hideyuki Kawashima &
 *                    Sachi Osawa & Hirokazu Kondo & Satoru Satake
 *
 * $Id: pgsql_interaction_home.h,v 1.1.2.3 2003/08/05 13:22:17 snaga Exp $
 */

#ifndef _LIBPQ_INTERACTION_HOME_H_
#define _LIBPQ_INTERACTION_HOME_H_

#include <libpq_interaction.h>

#define STMT_HOME \
  "SELECT * FROM home( %lld,%lld )" \
  " AS l(" \
  "   C_FName char(15)," \
  "   C_LName char(15)," \
  "   pp_i_id1 numeric(10)," \
  "   pp_t_id1 numeric(10)," \
  "   pp_i_id2 numeric(10)," \
  "   pp_t_id2 numeric(10)," \
  "   pp_i_id3 numeric(10)," \
  "   pp_t_id3 numeric(10)," \
  "   pp_i_id4 numeric(10)," \
  "   pp_t_id4 numeric(10)," \
  "   pp_i_id5 numeric(10)," \
  "   pp_t_id5 numeric(10) )"

int execute_home(struct db_context_t *, struct home_t *);

#endif /* _LIBPQ_INTERACTION_HOME_H_ */
