#!/bin/bash -ex

date=$1
mt=$2
(
#Add seconds instead of data and time  count in .dat file for remote dstat
#-----------------------------------
        for file in ./benchmark/$date/*/*/jdbcRunnerLogs/*.txt
        do
                ts=`cat $file | grep " 1 sec" | awk '{print $1}'`
		path=`dirname $file`
                f=${path%/*}
              

#-----Creating result file----

cat  $file | grep -e "Response\|Total\|Throughput"  | cut -c 18-74 | \
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
}' > $f/result.txt

run=`echo ${f##*/}`
                for tfile in ./benchmark/$date/*/$run/dstatOutput/dstat.csv
                do
			path=`dirname $tfile`
                	ft=${path%/*}
                	
                        sed '/^"/ D; /^$/ D; s/,/ /g' $tfile | \
			awk 'BEGIN{ORS="";}{i=2; while(i<=NF) {if(i==2){ print substr($i,1,8), "\t";}  else{ print $i"\t";} i++;} print "\n";} ' | \
			awk -v str=$ts '{if($1>=str) print $0}' | \
			awk -v val=1 -v mtcnt=$mt 'BEGIN{ORS="";} {if(val<=mtcnt) {i=2; print val," "; while(i<=NF) {print $i," "; i=i+1; } print "\n";} val=val+1}' \
			>  $ft/gnuInput/stat.dat

                done


        done




#------------------------------------
#Add second instead of data and time  count in .dat file for Local dstat
#-----------------------------------

	for file in ./benchmark/$date/*/*/jdbcRunnerLogs/*.txt
	do
        	ts=`cat $file | grep " 1 sec" | awk '{print $1}'`
		path=`dirname $file`
                f=${path%/*}
                run=`echo ${f##*/}`

       		 for tfile in ./benchmark/$date/*/$run/dstatOutput/dstat_driver.csv
                do

			path=`dirname $tfile`
               		 ft=${path%/*}
           
               		sed '/^"/ D; /^$/ D; s/,/ /g' $tfile | awk 'BEGIN{ORS="";}{i=2; while(i<=NF) {if(i==2){ print substr($i,1,8), "\t";}  else{ print $i"\t";} i++;} print "\n";} ' | awk -v str=$ts '{if($1>=str) print $0}' | awk -v val=1 -v mtcnt=$mt 'BEGIN{ORS="";} {if(val<=mtcnt) {i=2; print val," "; while(i<=NF) {print $i," "; i=i+1; } print "\n";} val=val+1}' >  $ft/gnuInput/stat_driver.dat

                done

	done
            



#-------------Printing Server Machine Dstat----------------------

	for file in ./benchmark/$date/*/*/gnuInput/stat.dat
	do
		img=$(basename $file)
		path=`dirname $file`
                f=${path%/*}

# Make directory to store the results
		setdir(){
			directory=$(echo "$f/gnuPlot/serverMachineDstat")
  			mkdir -p $directory
  			cd $directory

		}


#############################################
# MAIN BLOCK
#############################################
# Use GNU plot to plot the graph
	graph () {
gnuplot << EOF
	set terminal $fileType size 840,480
	set size 1,1
	set lmargin at screen 0.12
	set rmargin at screen 0.70
	set key outside right top vertical Right noreverse enhanced autotitles box linetype -1 linewidth 1.000
	set output $output
	set title $title
	set xlabel $xlabel
	set ylabel $ylabel
	set yrange $yrange
	plot ${plot[*]}
EOF
	}

# Plot CPU usage
	plotcpu(){
 		fileType="png"
  		output='"cpu.png"'
  		title='"CPU Usage"'
  		xlabel='"time in seconds"'
  		ylabel='"percent"'
		yrange='[0:100]'

  		plot=( '"../../gnuInput/'$img'"'  using 1:2 title '"user"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:3 title '"system"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:4 title '"idle"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"' using 1:5 title '"iowait"' with points pointtype 7 pointsize 0.5  )

  		graph
	}

# Plot memory usage
	plotmem(){
  		fileType="png"
  		output='"memory.png"'
  		title='"Memory Usage"'
  		xlabel='"time in seconds"'
  		ylabel='"size(MB)"'
		yrange='[0:40000]'

  		plot=( '"../../gnuInput/'$img'"'  using 1:\(\$20/1048576\) title '"used"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$21/1048576\) title '"buff"' with points pointtype 7 pointsize 0.5 , '"../../gnuInput/'$img'"'  using 1:\(\$22/1048576\) title '"cach"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$23/1048576\) title '"free"' with points pointtype 7 pointsize 0.5  )

  		graph
	}

# Plot network usage
	plotnet1(){
  		fileType="png"
  		output='"network_eth1.png"'
  		title='"Network Usage"'
  		xlabel='"time in seconds"'
  		ylabel='"size(MB)"'
		yrange='[0:50]'

  		plot=( '"../../gnuInput/'$img'"'  using 1:\(\$8/1048576\) title '"eth1-receive"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$9/1048576\) title '"eth1-send"' with points pointtype 7 pointsize 0.5  )

  		graph
	}

	plotnet2(){
                fileType="png"
                output='"network_eth2.png"'
                title='"Network Usage"'
                xlabel='"time in seconds"'
                ylabel='"size(MB)"'
                yrange='[0:50]'

                plot=( '"../../gnuInput/'$img'"'  using 1:\(\$10/1048576\) title '"eth2-receive"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$11/1048576\) title '"eth2-send"' with points pointtype 7 pointsize 0.5   )

                graph
        }

	 plotnet3(){
                fileType="png"
                output='"network_eth3.png"'
                title='"Network Usage"'
                xlabel='"time in seconds"'
                ylabel='"size(MB)"'
                yrange='[0:50]'

                plot=(  '"../../gnuInput/'$img'"'  using 1:\(\$12/1048576\) title '"eth3-receive"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$13/1048576\) title '"eth3-send"' with points pointtype 7 pointsize 0.5 )

                graph
        }

	plotnet4(){
                fileType="png"
                output='"network_eth4.png"'
                title='"Network Usage"'
                xlabel='"time in seconds"'
                ylabel='"size(MB)"'
                yrange='[0:50]'

                plot=(  '"../../gnuInput/'$img'"'  using 1:\(\$14/1048576\) title '"eth4-receive"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$15/1048576\) title '"eth4-send"' with points pointtype 7 pointsize 0.5 )

                graph
        }

	plotnet5(){
                fileType="png"
                output='"network_eth5.png"'
                title='"Network Usage"'
                xlabel='"time in seconds"'
                ylabel='"size(MB)"'
                yrange='[0:50]'

                plot=(  '"../../gnuInput/'$img'"'  using 1:\(\$16/1048576\) title '"eth5-receive"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$17/1048576\) title '"eth5-send"' with points pointtype 7 pointsize 0.5 )

                graph
        }



# Plot disk usage
	plotdisk(){
  		fileType="png"
  		output='"disk.png"'
  		title='"Disk Usage"'
  		xlabel='"time in seconds"'
  		ylabel='"size(MB)"'
		yrange='[0:100]'

  		plot=( '"../../gnuInput/'$img'"'  using 1:\(\$24/1048576\) title '"read-sda2(db)"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$25/1048576\) title '"write-sda2(db)"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$26/1048576\) title '"read-sda3(archive)"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$27/1048576\) title '"write-sda3(archive)"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$28/1048576\) title '"read-sda5(xlog)"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$29/1048576\) title '"write-sda5(xlog)"' with points pointtype 7 pointsize 0.5 , '"../../gnuInput/'$img'"'  using 1:\(\$30/1048576\) title '"read-sda9(backup)"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$31/1048576\) title '"write-sda9(backup)"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$32/1048576\) title '"read-total"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$33/1048576\) title '"write-total"' with points pointtype 7 pointsize 0.5 )

  		graph
	}

# Plot load average
	plotload(){
  		fileType="png"
  		output='"cpu_load_average.png"'
  		title='"CPU Load Average"'
  		xlabel='"time in seconds"'
  		ylabel='"CPU Load Average"'
		yrange='[0:50]'
  		plot=( '"../../gnuInput/'$img'"'  using 1:34 title '"CPU load average for 1 minute"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:35 title '"CPU load average for 5 minute"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:36 title '"CPU load average for 15 minute"' with points pointtype 7 pointsize 0.5  )

  	graph
	}

# Plot swap usage
	plotswap(){
  		fileType="png"
  		output='"swap.png"'
  		title='"Swap Usage"'
  		xlabel='"time in seconds"'
  		ylabel='"size(MB)"'
		yrange='[0:40000]'
  		plot=( '"../../gnuInput/'$img'"'  using 1:\(\$37/1048576\) title '"used"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$38/1048576\) title '"free"' with points pointtype 7 pointsize 0.5  )

  		graph
	}

	plotdiskutil(){
                fileType="png"
                output='"disk-util.png"'
                title='"Disk Utilization"'
                xlabel='"time in seconds"'
                ylabel='"percent"'
  		yrange='[0:100]'
		plot=( '"../../gnuInput/'$img'"'  using 1:39 title '"util-sda2(db)"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:40 title '"util-sda3(archive)"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:41 title '"util-sda5(xlog)"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"' using 1:42 title '"util-sda9(/)"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"' using 1:43 title '"util-total"' with points pointtype 7 pointsize 0.5 )

                graph
        }


	setdir
# Plot results
	#echo "Plot results into '$directory' directory"
	plotmem
	plotnet1
	plotnet2
	plotnet3
	plotnet4
	plotnet5
	plotcpu
	plotdisk
	plotload
	plotswap
	plotdiskutil
	cd $BENCH_DIR
	
	done 



#-------------Printing  Driver Machine Dstat----------------------

	for file in ./benchmark/$date/*/*/gnuInput/stat_driver.dat
	do
		img=$(basename $file)
		path=`dirname $file`
                f=${path%/*}

# Make directory to store the results
		setdir(){
			directory=$(echo "$f/gnuPlot/driverMachineDstat")
			mkdir -p $directory
			cd $directory

		}


#############################################
# MAIN BLOCK
#############################################
# Use GNU plot to plot the graph
	graph () {
gnuplot << EOF
	set terminal $fileType size 840,480
	set size 1,1
	set lmargin at screen 0.12
	set rmargin at screen 0.70
	set key outside right top vertical Right noreverse enhanced autotitles box linetype -1 linewidth 1.000
	set output $output
	set title $title
	set xlabel $xlabel
	set ylabel $ylabel
	set yrange $yrange
	plot ${plot[*]}
EOF
	}

# Plot CPU usage
	plotcpu(){
 		fileType="png"
  		output='"cpu.png"'
  		title='"CPU Usage"'
  		xlabel='"time in seconds"'
  		ylabel='"percent"'
		yrange='[0:100]'

  		plot=( '"../../gnuInput/'$img'"'  using 1:2 title '"user"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:3 title '"system"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:4 title '"idle"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"' using 1:5 title '"iowait"' with points pointtype 7 pointsize 0.5  )

  		graph
	}

# Plot memory usage
	plotmem(){
  		fileType="png"
  		output='"memory.png"'
  		title='"Memory Usage"'
  		xlabel='"time in seconds"'
  		ylabel='"size(MB)"'
		yrange='[0:40000]'

  		plot=( '"../../gnuInput/'$img'"'  using 1:\(\$20/1048576\) title '"used"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$21/1048576\) title '"buff"' with points pointtype 7 pointsize 0.5 , '"../../gnuInput/'$img'"'  using 1:\(\$22/1048576\) title '"cach"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$23/1048576\) title '"free"' with points pointtype 7 pointsize 0.5  )

  		graph
	}



# Plot network usage
	plotnet1(){
  		fileType="png"
  		output='"network_eth1.png"'
  		title='"Network Usage"'
  		xlabel='"time in seconds"'
  		ylabel='"size(MB)"'
		yrange='[0:50]'

  		plot=( '"../../gnuInput/'$img'"'  using 1:\(\$8/1048576\) title '"eth1-receive"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$9/1048576\) title '"eth1-send"' with points pointtype 7 pointsize 0.5  )

  		graph
	}

	plotnet2(){
                fileType="png"
                output='"network_eth2.png"'
                title='"Network Usage"'
                xlabel='"time in seconds"'
                ylabel='"size(MB)"'
                yrange='[0:50]'

                plot=( '"../../gnuInput/'$img'"'  using 1:\(\$10/1048576\) title '"eth2-receive"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$11/1048576\) title '"eth2-send"' with points pointtype 7 pointsize 0.5  )

                graph
        }

	plotnet3(){
                fileType="png"
                output='"network_eth3.png"'
                title='"Network Usage"'
                xlabel='"time in seconds"'
                ylabel='"size(MB)"'
                yrange='[0:50]'

                plot=( '"../../gnuInput/'$img'"'  using 1:\(\$12/1048576\) title '"eth3-receive"' with points pointtype 7 pointsize 0.5  , '"../../gnuInput/'$img'"'  using 1:\(\$13/1048576\) title '"eth3-send"' with points pointtype 7 pointsize 0.5 )

                graph
        }

	plotnet4(){
                fileType="png"
                output='"network_eth4.png"'
                title='"Network Usage"'
                xlabel='"time in seconds"'
                ylabel='"size(MB)"'
                yrange='[0:50]'

                plot=( '"../../gnuInput/'$img'"'  using 1:\(\$14/1048576\) title '"eth4-receive"' with points pointtype 7 pointsize 0.5  , '"../../gnuInput/'$img'"'  using 1:\(\$15/1048576\) title '"eth4-send"' with points pointtype 7 pointsize 0.5 )

                graph
        }

	plotnet5(){
                fileType="png"
                output='"network_eth5.png"'
                title='"Network Usage"'
                xlabel='"time in seconds"'
                ylabel='"size(MB)"'
                yrange='[0:50]'

                plot=( '"../../gnuInput/'$img'"'  using 1:\(\$16/1048576\) title '"eth5-receive"' with points pointtype 7 pointsize 0.5  , '"../../gnuInput/'$img'"'  using 1:\(\$17/1048576\) title '"eth5-send"' with points pointtype 7 pointsize 0.5 )

                graph
        }


# Plot disk usage
	plotdisk(){
  		fileType="png"
  		output='"disk.png"'
  		title='"Disk Usage"'
  		xlabel='"time in seconds"'
  		ylabel='"size(MB)"'
		yrange='[0:10]'

  		plot=( '"../../gnuInput/'$img'"'  using 1:\(\$24/1048576\) title '"read-total"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$25/1048576\) title '"write-total"' with points pointtype 7 pointsize 0.5 )
  		graph
	}

# Plot load average
	plotload(){
  		fileType="png"
  		output='"cpu_load_average.png"'
  		title='"CPU Load Average"'
  		xlabel='"time in seconds"'
  		ylabel='"CPU Load Average"'
		yrange='[0:50]'
  		plot=( '"../../gnuInput/'$img'"'  using 1:26 title '"CPU load average for 1 minute"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:27 title '"CPU load average for 5 minute"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:28 title '"CPU load average for 15 minute"' with points pointtype 7 pointsize 0.5  )

  	graph
	}

# Plot swap usage
	plotswap(){
  		fileType="png"
  		output='"swap.png"'
  		title='"Swap Usage"'
  		xlabel='"time in seconds"'
  		ylabel='"size(MB)"'
		yrange='[0:10000]'
  		plot=( '"../../gnuInput/'$img'"'  using 1:\(\$29/1048576\) title '"used"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$30/1048576\) title '"free"' with points pointtype 7 pointsize 0.5  )

  		graph
	}

	plotdiskutil(){
                fileType="png"
                output='"disk-util.png"'
                title='"Disk Utilization"'
                xlabel='"time in seconds"'
                ylabel='"percent"'
  		yrange='[0:100]'
		plot=( '"../../gnuInput/'$img'"' using 1:31 title '"util-total"' with points pointtype 7 pointsize 0.5  )

                graph
        }


	setdir
# Plot results
	#echo "Plot results into '$directory' directory"
	plotmem
	plotnet1
	plotnet2
	plotnet3
	plotnet4
	plotnet5
	plotcpu
	plotdisk
	plotload
	plotswap
	plotdiskutil
	cd $BENCH_DIR
	
	done 
) 2> error.log
