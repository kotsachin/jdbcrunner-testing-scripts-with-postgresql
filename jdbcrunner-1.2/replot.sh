#!/bin/bash
            

#-----------------------------
#--Generate graph for each file in .png format under graphs directory.
# open .png files with gthumb in centos.
#----------------------------
	for file in ./benchmark/*/*/*/gnuInput/*_t.dat
	do
	date=$(echo "$file" | cut -c 13-31)
	server=$(echo "$file" | cut -c 33-39)
	run=$(echo "$file" | cut -c 41-44)
	img=$(echo "$file" | cut -c 55-71)
	st1=$(cat benchmark/$date/RUNCONF.txt | grep "Sleep Times" | awk '{ print substr($3,1,length($3)-1)}')
	st2=$(cat benchmark/$date/RUNCONF.txt | grep "Sleep Times" | awk '{ print substr($4,1,length($4)-1)}')
	st3=$(cat benchmark/$date/RUNCONF.txt | grep "Sleep Times" | awk '{ print substr($5,1,length($5)-1)}')
	st4=$(cat benchmark/$date/RUNCONF.txt | grep "Sleep Times" | awk '{ print substr($6,1,length($6)-1)}')
	st5=$(cat benchmark/$date/RUNCONF.txt | grep "Sleep Times" | awk '{ print $7}')

	mkdir -p ./benchmark/$date/$server/$run/gnuPlot

	   graph () {
gnuplot << EOF
	set size 1,1
        set terminal $fileType size 840,480
        set output $output
	set key outside right top vertical Right noreverse enhanced autotitles box linetype -1 linewidth 1.000
        set title $title
        set xlabel $xlabel
        set ylabel $ylabel
	set lmargin at screen 0.10
	set rmargin at screen 0.70
	set yrange [0:500]
        plot ${plot[*]}
EOF
        }
	plot1_t(){
                fileType="png"
                output='"TransactionType-1_t.png"'
                title='"tx1 : New-Order transaction | sleep time: '$st1'"'
                xlabel='"Elapsed Time \(seconds)"'
                ylabel='"Throughput (Number of transaction)"'
                plot=( '"'$file'"'  using 1:2 title '"Transaction Type-1"' with points pointtype 7 pointsize 0.5  )
                graph
        }
	plot1_t
	mv TransactionType-1_t.png ./benchmark/$date/$server/$run/gnuPlot/TransactionType-1_t.png

	plot2_t(){
                fileType="png"
                output='"TransactionType-2_t.png"'
                title='"tx2 : Payment transaction | steep time: '$st2'"'
                xlabel='"Elapsed Time \(seconds)"'
                ylabel='"Throughput (Number of transaction)"'
                plot=( '"'$file'"'  using 1:3 title '"Transaction Type-2"' with points pointtype 7 pointsize 0.5  )
                graph
        }
	plot2_t
	mv TransactionType-2_t.png ./benchmark/$date/$server/$run/gnuPlot/TransactionType-2_t.png

	plot3_t(){
                fileType="png"
                output='"TransactionType-3_t.png"'
                title='"tx3 : Order-Status transaction | sleep time: '$st3'"'
                xlabel='"Elapsed Time \(seconds)"'
                ylabel='"Throughput (Number of transaction)"'
                plot=( '"'$file'"'  using 1:4 title '"Transaction Type-3"' with points pointtype 7 pointsize 0.5  )
                graph
        }
	plot3_t
	mv TransactionType-3_t.png ./benchmark/$date/$server/$run/gnuPlot/TransactionType-3_t.png


	plot4_t(){
                fileType="png"
                output='"TransactionType-4_t.png"'
                title='"tx4 : Delivery transaction | sleep time: '$st4'"'
                xlabel='"Elapsed Time \(seconds)"'
                ylabel='"Throughput (Number of transaction)"'
                plot=( '"'$file'"'  using 1:5 title '"Transaction Type-4"' with points pointtype 7 pointsize 0.5  )
                graph
        }
	plot4_t
	mv TransactionType-4_t.png ./benchmark/$date/$server/$run/gnuPlot/TransactionType-4_t.png

	plot5_t(){
                fileType="png"
                output='"TransactionType-5_t.png"'
                title='"tx5 : Stock-Level transaction | sleep time: '$st5'"'
                xlabel='"Elapsed Time \(seconds)"'
                ylabel='"Throughput (Number of transaction)"'
                plot=( '"'$file'"'  using 1:6 title '"Transaction Type-5"' with points pointtype 7 pointsize 0.5  )
                graph
        }
	plot5_t
	mv TransactionType-5_t.png ./benchmark/$date/$server/$run/gnuPlot/TransactionType-5_t.png


	done

#-----------------------------------------------------------------

	for file in ./benchmark/*/*/*/gnuInput/*_r.dat
	do
	date=$(echo "$file" | cut -c 13-31)
	server=$(echo "$file" | cut -c 33-39)
	run=$(echo "$file" | cut -c 41-44)
	img=$(echo "$file" | cut -c 55-71)
	st1=$(cat benchmark/$date/RUNCONF.txt | grep "Sleep Times" | awk '{ print substr($3,1,length($3)-1)}')
	st2=$(cat benchmark/$date/RUNCONF.txt | grep "Sleep Times" | awk '{ print substr($4,1,length($4)-1)}')
	st3=$(cat benchmark/$date/RUNCONF.txt | grep "Sleep Times" | awk '{ print substr($5,1,length($5)-1)}')
	st4=$(cat benchmark/$date/RUNCONF.txt | grep "Sleep Times" | awk '{ print substr($6,1,length($6)-1)}')
	st5=$(cat benchmark/$date/RUNCONF.txt | grep "Sleep Times" | awk '{ print $7}')
	mkdir -p ./benchmark/$date/$server/$run/gnuPlot

	   graph () {
gnuplot << EOF
        set terminal $fileType size 840,480
        set output $output
	set size 1,1
	set lmargin at screen 0.10
	set rmargin at screen 0.70
	set key outside right top vertical Right noreverse enhanced autotitles box linetype -1 linewidth 1.000
        set title $title
        set xlabel $xlabel
        set ylabel $ylabel
	set yrange [0:500]
        plot ${plot[*]}
EOF
        }
	plot1_r(){
                fileType="png"
                output='"TransactionType-1_r.png"'
                title='"tx1 : New-Order transaction | sleep time: '$st1'"'
                xlabel='"Response Time \(seconds)"'
                ylabel='"Count (Number of transaction)"'
                plot=( '"'$file'"'  using\(\$1/1000\):2 title '"Transaction Type-1"' with points pointtype 7 pointsize 0.5  )
                graph
        }
	plot1_r
	mv TransactionType-1_r.png ./benchmark/$date/$server/$run/gnuPlot/TransactionType-1_r.png

	plot2_r(){
                fileType="png"
                output='"TransactionType-2_r.png"'
                title='"tx2 : Payment transaction | sleep time: '$st2'"'
                xlabel='"Response Time \(seconds)"'
                ylabel='"Count (Number of transaction)"'
                plot=( '"'$file'"'  using \(\$1/1000\):3 title '"Transaction Type-2"' with points pointtype 7 pointsize 0.5  )
                graph
        }
	plot2_r
	mv TransactionType-2_r.png ./benchmark/$date/$server/$run/gnuPlot/TransactionType-2_r.png

	plot3_r(){
                fileType="png"
                output='"TransactionType-3_r.png"'
                title='"tx3 : Order-Status transaction | sleep time :'$st3'"'
                xlabel='"Response Time \(seconds)"'
                ylabel='"Count (Number of transaction)"'
                plot=( '"'$file'"'  using \(\$1/1000\):4 title '"Transaction Type-3"' with points pointtype 7 pointsize 0.5  )
                graph
        }
	plot3_r
	mv TransactionType-3_r.png ./benchmark/$date/$server/$run/gnuPlot/TransactionType-3_r.png

	plot4_r(){
                fileType="png"
                output='"TransactionType-4_r.png"'
                title='"tx4 : Delivery transaction | sleep time: '$st4'"'
                xlabel='"Response Time \(seconds)"'
                ylabel='"Count (Number of transaction)"'
                plot=( '"'$file'"'  using \(\$1/1000\):5 title '"Transaction Type-4"' with points pointtype 7 pointsize 0.5  )
                graph
        }
	plot4_r
	mv TransactionType-4_r.png ./benchmark/$date/$server/$run/gnuPlot/TransactionType-4_r.png

	plot5_r(){
                fileType="png"
                output='"TransactionType-5_r.png"'
                title='"tx5 : Stock-Level transaction | sleep time: '$st5'"'
                xlabel='"Response Time \(seconds)"'
                ylabel='"Count (Number of transaction)"'
                plot=( '"'$file'"'  using \(\$1/1000\):6 title '"Transaction Type-5"' with points pointtype 7 pointsize 0.5  )
                graph
        }
	plot5_r
	mv TransactionType-5_r.png ./benchmark/$date/$server/$run/gnuPlot/TransactionType-5_r.png


	done

#-------------Printing Server Machine Dstat----------------------

	for file in ./benchmark/*/*/*/gnuInput/stat.dat
	do
		date=$(echo "$file" | cut -c 13-31)
		server=$(echo "$file" | cut -c 33-39)
		run=$(echo "$file" | cut -c 41-44)
		img=$(echo "$file" | cut -c 55-68)


# Make directory to store the results
		setdir(){
			directory=$(echo "./benchmark/$date/$server/$run/gnuPlot/ServerMachineDstat")
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
	set lmargin at screen 0.10
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
  		xlabel='"time"'
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
  		xlabel='"time"'
  		ylabel='"size(MB)"'
		yrange='[0:100]'

  		plot=( '"../../gnuInput/'$img'"'  using 1:\(\$10/1000000\) title '"used"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$11/1000000\) title '"buff"' with points pointtype 7 pointsize 0.5 , '"../../gnuInput/'$img'"'  using 1:\(\$12/1000000\) title '"cach"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$13/1000000\) title '"free"' with points pointtype 7 pointsize 0.5  )

  		graph
	}

# Plot network usage
	plotnet(){
  		fileType="png"
  		output='"network.png"'
  		title='"Network Usage"'
  		xlabel='"time"'
  		ylabel='"size(KB)"'
		yrange='[0:10000]'

  		plot=( '"../../gnuInput/'$img'"'  using 1:\(\$8/1000\) title '"recv"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$9/1000\) title '"send"' with points pointtype 7 pointsize 0.5  )

  		graph
	}

# Plot disk usage
	plotdisk(){
  		fileType="png"
  		output='"disk.png"'
  		title='"Disk Usage"'
  		xlabel='"time"'
  		ylabel='"size(KB)"'
		yrange='[0:100000]'

  		plot=( '"../../gnuInput/'$img'"'  using 1:\(\$14/1000\) title '"read-sda2(db)"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$15/1000\) title '"write-sda2(db)"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$16/1000\) title '"read-sda3(archive)"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$17/1000\) title '"write-sda3(archive)"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$18/1000\) title '"read-sda5(xlog)"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$19/1000\) title '"write-sda5(xlog)"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$20/1000\) title '"read-total"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$21/1000\) title '"write-total"' with points pointtype 7 pointsize 0.5 )

  		graph
	}

# Plot load average
	plotload(){
  		fileType="png"
  		output='"cpu_load_average.png"'
  		title='"CPU Load Average"'
  		xlabel='"time"'
  		ylabel='"CPU Load Average"'
		yrange='[0:500]'
  		plot=( '"../../gnuInput/'$img'"'  using 1:22 title '"1m"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:23 title '"5m"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:24 title '"15m"' with points pointtype 7 pointsize 0.5  )

  	graph
	}

# Plot swap usage
	plotswap(){
  		fileType="png"
  		output='"swap.png"'
  		title='"Swap Usage"'
  		xlabel='"time"'
  		ylabel='"size(MB)"'
		yrange='[0:100]'
  		plot=( '"../../gnuInput/'$img'"'  using 1:\(\$25/1000000\) title '"used"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$26/1000000\) title '"free"' with points pointtype 7 pointsize 0.5  )

  		graph
	}

	plotdiskutil(){
                fileType="png"
                output='"disk-util.png"'
                title='"Disk Utilization"'
                xlabel='"time"'
                ylabel='"percent"'
  		yrange='[0:100]'
		plot=( '"../../gnuInput/'$img'"'  using 1:27 title '"util-sda2(db)"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:28 title '"util-sda3(archive)"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:29 title '"util-sda5(xlog)"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"' using 1:30 title '"util-total"' with points pointtype 7 pointsize 0.5  )

                graph
        }


	setdir
# Plot results
	echo "Plot results into '$directory' directory"
	plotmem
	plotnet
	plotcpu
	plotdisk
	plotload
	plotswap
	plotdiskutil
	cd /home/sachin/jdbcrunner-1.2/
	#cd /usr/local/jdbcrunner-1.2/jdbcrunner-1.2/
	
	done 



#-------------Printing  Driver Machine Dstat----------------------

	for file in ./benchmark/*/*/*/gnuInput/stat_local.dat
	do
		date=$(echo "$file" | cut -c 13-31)
		server=$(echo "$file" | cut -c 33-39)
		run=$(echo "$file" | cut -c 41-44)
		img=$(echo "$file" | cut -c 55-68)


# Make directory to store the results
		setdir(){
			directory=$(echo "./benchmark/$date/$server/$run/gnuPlot/DriverMachineDstat")
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
	set lmargin at screen 0.10
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
  		xlabel='"time"'
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
  		xlabel='"time"'
  		ylabel='"size(MB)"'
		yrange='[0:100]'

  		plot=( '"../../gnuInput/'$img'"'  using 1:\(\$10/1000000\) title '"used"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$11/1000000\) title '"buff"' with points pointtype 7 pointsize 0.5 , '"../../gnuInput/'$img'"'  using 1:\(\$12/1000000\) title '"cach"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$13/1000000\) title '"free"' with points pointtype 7 pointsize 0.5  )

  		graph
	}

# Plot network usage
	plotnet(){
  		fileType="png"
  		output='"network.png"'
  		title='"Network Usage"'
  		xlabel='"time"'
  		ylabel='"size(KB)"'
		yrange='[0:10000]'

  		plot=( '"../../gnuInput/'$img'"'  using 1:\(\$8/1000\) title '"recv"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$9/1000\) title '"send"' with points pointtype 7 pointsize 0.5  )

  		graph
	}

# Plot disk usage
	plotdisk(){
  		fileType="png"
  		output='"disk.png"'
  		title='"Disk Usage"'
  		xlabel='"time"'
  		ylabel='"size(KB)"'
		yrange='[0:100000]'

  	#	plot=( '"../../gnuInput/'$img'"'  using 1:\(\$14/1000\) title '"read-sda2(db)"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$15/1000\) title '"write-sda2(db)"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$16/1000\) title '"read-sda3(archive)"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$17/1000\) title '"write-sda3(archive)"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$18/1000\) title '"read-sda5(xlog)"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$19/1000\) title '"write-sda5(xlog)"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$20/1000\) title '"read-total"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$21/1000\) title '"write-total"' with points pointtype 7 pointsize 0.5 )
  		plot=( '"../../gnuInput/'$img'"'  using 1:\(\$20/1000\) title '"read-total"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$21/1000\) title '"write-total"' with points pointtype 7 pointsize 0.5 )
  		graph
	}

# Plot load average
	plotload(){
  		fileType="png"
  		output='"cpu_load_average.png"'
  		title='"CPU Load Average"'
  		xlabel='"time"'
  		ylabel='"CPU Load Average"'
		yrange='[0:500]'
  		plot=( '"../../gnuInput/'$img'"'  using 1:22 title '"1m"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:23 title '"5m"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:24 title '"15m"' with points pointtype 7 pointsize 0.5  )

  	graph
	}

# Plot swap usage
	plotswap(){
  		fileType="png"
  		output='"swap.png"'
  		title='"Swap Usage"'
  		xlabel='"time"'
  		ylabel='"size(MB)"'
		yrange='[0:100]'
  		plot=( '"../../gnuInput/'$img'"'  using 1:\(\$25/1000000\) title '"used"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$26/1000000\) title '"free"' with points pointtype 7 pointsize 0.5  )

  		graph
	}

	plotdiskutil(){
                fileType="png"
                output='"disk-util.png"'
                title='"Disk Utilization"'
                xlabel='"time"'
                ylabel='"percent"'
  		yrange='[0:100]'
	#	plot=( '"../../gnuInput/'$img'"'  using 1:27 title '"util-sda2(db)"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:28 title '"util-sda3(archive)"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:29 title '"util-sda5(xlog)"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"' using 1:30 title '"util-total"' with points pointtype 7 pointsize 0.5  )
		plot=( '"../../gnuInput/'$img'"' using 1:30 title '"util-total"' with points pointtype 7 pointsize 0.5  )

                graph
        }


	setdir
# Plot results
	echo "Plot results into '$directory' directory"
	plotmem
	plotnet
	plotcpu
	plotdisk
	plotload
	plotswap
	plotdiskutil
	cd /home/sachin/jdbcrunner-1.2/
	#cd /usr/local/jdbcrunner-1.2/jdbcrunner-1.2/
	
	done 


