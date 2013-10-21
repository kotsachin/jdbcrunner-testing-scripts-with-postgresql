#!/bin/bash -ex
(
ip_addr=$1

                ssh -n $USER_NAME@$ip_addr "$PGPATH/pg_ctl -D $PGDATA start 1>/dev/null" 2> error.log

                started="no"
                while [ "$started" == "no" ]
                do
                        status=`ssh -n $USER_NAME@$ip_addr "$PGPATH/pg_ctl -D $PGDATA status"`
                        status=`echo $status | awk '{print $2}' | awk '{print $1}'`
                        if [ "$status" == "server" ]
                        then
                                ssh -n $USER_NAME@$ip_addr "ps -ef | grep postgres | grep recovering | grep -v bash" 1>/dev/null
                                if [ $? == 1 ]
                                then
                                        started="yes"
                                fi
                        fi
                done
               
) 2> error.log
