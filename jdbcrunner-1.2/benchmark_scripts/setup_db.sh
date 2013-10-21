#!/bin/bash -ex
#---Please put postgres configurations file at proper place before executing test.
#and set that path to PG_CONF_FILES shell variable.
tt=$1
(
	#-----Cleaning old Master db_directory----
	sh clean_dir.sh $MASTER_IP
	#-----Initialize Master data directory and create tpcc user and database for benchmarking---
        echo "Initializing Master database...."
        ssh -n $USER_NAME@$MASTER_IP "$PGPATH/initdb -D $PGDATA -X $PGXLOG/" 1>/dev/null 2>/dev/null

	#-------Replacing appropriate postgresql.conf and pg_hba.conf on different server Machines---- 
	ssh -n $USER_NAME@$MASTER_IP "cp $PG_CONF_FILES/postgresql.conf.standalone $PGDATA/postgresql.conf"
	ssh -n $USER_NAME@$MASTER_IP "cp $PG_CONF_FILES/pg_hba.conf $PGDATA/pg_hba.conf"
	
        sh start_master.sh $MASTER_IP
	sleep 10

        psql -h $MASTER_IP -d postgres -c "create user tpcc with superuser" 1>/dev/null
        psql -h $MASTER_IP -d postgres -c "alter user tpcc with login" 1>/dev/null
        psql -h $MASTER_IP -d postgres -c "alter user tpcc with PASSWORD 'tpcc' " 1>/dev/null
        psql -h $MASTER_IP -d postgres -c "create database tpcc with owner tpcc" 1>/dev/null

	sh stop_servers.sh $MASTER_IP

if [ "$tt" == "SR" ] || [ "$tt" == "ncSR" ] || [ "$tt" == "cSR" ]
then

	#-----Cleaning old Standby-I db_directory----
        sh clean_dir.sh $STANDBY_1_IP
	
	#-------Setting up Standby-I server data directory using backup--------
	echo "Initializing Standby-I server...."	
	ssh -n $USER_NAME@$MASTER_IP "cp $PG_CONF_FILES/postgresql.conf.SR $PGDATA/postgresql.conf"

	sh start_master.sh $MASTER_IP
	sleep 10
	
	ssh -n $USER_NAME@$MASTER_IP "$PGPATH/pg_basebackup -D $BKP_DIR/backup-1 -l 'backup-1' 1>/dev/null 2>/dev/null"
	#ssh -n $USER_NAME@$MASTER_IP "/usr/pgsql-9.2/bin/pg_basebackup -D backups/test_backups/backup-1 -l 'backup-1' 1>/dev/null 2>/dev/null"
	sh stop_servers.sh $MASTER_IP
	
	# case of 1 standby (SR)
	ssh -n $USER_NAME@$MASTER_IP "scp -r $BKP_DIR/backup-1/* $USER_NAME@$STANDBY_1_IP:$PGDATA/"
	ssh -n $USER_NAME@$STANDBY_1_IP "cp $PG_CONF_FILES/postgresql.conf.SR $PGDATA/postgresql.conf"
        ssh -n $USER_NAME@$STANDBY_1_IP "cp $PG_CONF_FILES/pg_hba.conf $PGDATA/pg_hba.conf"
	ssh -n $USER_NAME@$STANDBY_1_IP "cp $PG_CONF_FILES/recovery.conf $PGDATA/recovery.conf"

	# case of 2 standbys (cSR and ncSR)
	if [ "$tt" == "ncSR" ]
	then
		#-----Cleaning old Standby-I db_directory----
      	  	sh clean_dir.sh $STANDBY_2_IP
		echo "Initializing Standby-II server...." 
		ssh -n $USER_NAME@$MASTER_IP "scp -r $BKP_DIR/backup-1/* $USER_NAME@$STANDBY_2_IP:$PGDATA/"
	
		ssh -n $USER_NAME@$STANDBY_2_IP "cp $PG_CONF_FILES/postgresql.conf.standalone $PGDATA/postgresql.conf"
        	ssh -n $USER_NAME@$STANDBY_2_IP "cp $PG_CONF_FILES/pg_hba.conf $PGDATA/pg_hba.conf"
		ssh -n $USER_NAME@$STANDBY_2_IP "cp $PG_CONF_FILES/recovery.conf.ncSR $PGDATA/recovery.conf"
	fi

	if [ "$tt" == "cSR" ]
        then
		#-----Cleaning old Standby-I db_directory----
        	sh clean_dir.sh $STANDBY_2_IP
		echo "Initializing Standby-II server...." 
                ssh -n $USER_NAME@$MASTER_IP "scp -r $BKP_DIR/backup-1/* $USER_NAME@$STANDBY_2_IP:$PGDATA/"

        	ssh -n $USER_NAME@$STANDBY_2_IP "cp $PG_CONF_FILES/postgresql.conf.standalone $PGDATA/postgresql.conf"
       		ssh -n $USER_NAME@$STANDBY_2_IP "cp $PG_CONF_FILES/pg_hba.conf $PGDATA/pg_hba.conf"
        	ssh -n $USER_NAME@$STANDBY_2_IP "cp $PG_CONF_FILES/recovery.conf.cSR $PGDATA/recovery.conf"
        fi

	
	ssh -n $USER_NAME@$MASTER_IP "rm -rf $BKP_DIR/*"	
fi

) 2> error.log

