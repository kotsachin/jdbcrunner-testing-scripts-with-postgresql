#!/bin/bash -ex
(
ip_addr=$1

        #-----Cleaning old db_directory----
	echo "cleaning $ip_addr directories"
        ssh -n $USER_NAME@$ip_addr "rm -rf $PGDATA/*"
        ssh -n $USER_NAME@$ip_addr  "rm -rf $PGARC/*"
        ssh -n $USER_NAME@$ip_addr  "rm -rf $PGLOG/*"
        ssh -n $USER_NAME@$ip_addr  "rm -rf $PGXLOG/*"
) 2> error.log

