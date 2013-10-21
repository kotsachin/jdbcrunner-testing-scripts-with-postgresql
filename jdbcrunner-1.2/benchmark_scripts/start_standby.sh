#!/bin/bash -ex
(
ip_addr=$1
                ssh -n $USER_NAME@$ip_addr ' '$PGPATH'/pg_ctl -D '$PGDATA'/ start 1>/dev/null'

                started="no"
                #----Waiting to start to database------
                while [ "$started" == "no" ]
                do
                        status=`ssh -n $USER_NAME@$ip_addr ' '$PGPATH'/pg_ctl -D '$PGDATA'/ status' | awk '{print $2}'`
                        status=`echo $status | awk '{print $1}'`
                        if [ "$status" == "server" ]
                        then
                                started="yes"
                        fi
                done

		
) 2> error.log


