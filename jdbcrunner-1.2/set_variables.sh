#!/bin/bash

dr_ip=`cat ~/.bash_profile | grep  "DRIVER_IP" `
echo $dr_ip
export BKP_IP=172.26.139.2

export MASTER_IP=172.26.136.4
export MASTER_PORT=5432
export MASTER_IP_LOAD=172.26.139.4
export MASTER_IP_REPLICATION=172.26.136.4
export MASTER_IP_TEST=172.26.137.4

export STANDBY_1_IP=172.26.136.5
export STANDBY_1_PORT=5432

export STANDBY_2_IP=172.26.136.6
export STANDBY_2_PORT=6432

export USER_NAME='sachin'


