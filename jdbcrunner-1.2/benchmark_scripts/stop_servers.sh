#!/bin/bash -ex
(
# stop the postgreSQL server

ip_addr=$1	
                ssh -n $USER_NAME@$ip_addr ' '$PGPATH'/pg_ctl -D '$PGDATA' stop 1>/dev/null 2>/dev/null '

                stopped="no"
                while [ "$stopped" == "no" ]
                do
                        status=`ssh -n $USER_NAME'@'$ip_addr ' '$PGPATH'/pg_ctl -D '$PGDATA' status' | awk '{print $2}'`
                        if [ "$status" == "no" ]
                        then
                                stopped="yes"
                        fi
                done

) 2> error.log
