#!/bin/bash -ex

#===========================================
#---Read environment document before executing script.
#--Set IP addresses, port numbers, usernames and directory locations as per your environment setup.
#---Please put postgres configurations files like postgresql.conf, recovery.conf and pg_hba.conf etc. at proper place before 
#executing test and set that path to PG_CONF_FILES shell variable.
#---See sample_benchmark.conf to set values in benchmark.conf
#---Set value for each variable below carefully.


(
#============Server ip for benchmark test==========
export DRIVER_IP=172.26.139.1
export BKP_IP=172.26.139.5

export MASTER_IP=172.26.136.4
export MASTER_PORT=5432
export MASTER_IP_LOAD=172.26.139.4
export MASTER_IP_REPLICATION=172.26.136.4
export MASTER_IP_TEST=172.26.137.4

export STANDBY_1_IP=172.26.136.5
export STANDBY_1_PORT=5432

export STANDBY_2_IP=172.26.136.6
export STANDBY_2_PORT=6432


#export MASTER_IP=172.26.136.6
#export MASTER_PORT=6432
#export MASTER_IP_LOAD=172.26.139.6
#export MASTER_IP_REPLICATION=172.26.136.6
#export MASTER_IP_TEST=172.26.137.6

export STANDBY_1_IP=172.26.136.5
export STANDBY_1_PORT=5432

export STANDBY_2_IP=172.26.136.6
export STANDBY_2_PORT=6432



export USER_NAME='sachin'

export BENCH_DIR=/home/sachin/jdbcrunner-1.2/benchmark_scripts/

export PGDATA=/db/pgsql922-5432

export PGPATH=/usr/pgsql-9.2/bin
export PG_CONF_FILES=/home/sachin/pg_files
export BKP_DIR=/home/sachin/backups/test_backups
export PGLOG=/var/log/pgsql-9.2
export PGARC=/archive/pgsql922-5432
export PGXLOG=/xlog/pgsql922-5432

cd $BENCH_DIR

#---command to execute main benchmark script----
sh benchmark_main.sh ../scripts/tpcc.js

) 2> error.log

