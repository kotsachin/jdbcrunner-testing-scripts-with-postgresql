		echo "Starting DB server..."

                #ssh -n sachin@172.26.139.4 '/usr/pgsql-9.2/bin/pg_ctl -D /db/pgsql922-5432/ start 1>/dev/null'

                started="no"
                while [ "$started" == "no" ]
                do
                        status=`ssh -n sachin@172.26.139.4 '/usr/pgsql-9.2/bin/pg_ctl -D /db/pgsql922-5432 status' | awk '{print $2}'`
                        status=`echo $status | awk '{print $1}'`
                        if [ "$status" == "server" ]
                        then
                                ssh -n sachin@172.26.139.4 "ps -ef | grep postgres | grep recovering | grep -v bash" 1>/dev/null
				if [ $? == 1 ] 
				then
                                	started="yes"
				fi
                        fi
                done
                echo "DB Server started."

