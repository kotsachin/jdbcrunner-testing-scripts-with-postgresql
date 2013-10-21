cat  ./benchmark/2013-03-06-15-48-18/*/*/jdbcRunnerLogs/*.txt | grep -e "Response\|Total\|Throughput"  | cut -c 18-74 | \
awk \
'{ \
	if( $3 == "count]" )\
	{\
		print "TX-1 (New-Order) Total Count: ",substr($4,1,index($4,",")-1)\
	}\
	if($1 == "[Throughput]" )\
	{\
		print "TX-1 (New-Order) Throughput: ",substr($2,1,index($2,",")-1)\
	}\
	if($3 == "(minimum)]" )\
	{\
		print "TX-1 (New-Order) min RT: ",substr($4,1,index($4,",")-1), " msec"\
	}\
	if($3 == "(50%tile)]" )\
        {\
                print "TX-1 (New-Order) 50%tile RT: ",substr($4,1,index($4,",")-1), " msec"\
        }\
	if($3 == "(90%tile)]" )\
        {\
                print "TX-1 (New-Order) 90%tile RT: ",substr($4,1,index($4,",")-1), " msec"\
        }\
	if($3 == "(95%tile)]" )\
        {\
                print "TX-1 (New-Order) 95%tile RT: ",substr($4,1,index($4,",")-1), " msec"\
        }\
	if($3 == "(99%tile)]" )\
        {\
                print "TX-1 (New-Order) 99%tile RT: ",substr($4,1,index($4,",")-1), " msec"\
        }\
	if($3 == "(maximum)]" )\
        {\
                print "TX-1 (New-Order) max RT: ",substr($4,1,index($4,",")-1), " msec"\
        }\
}'
		
