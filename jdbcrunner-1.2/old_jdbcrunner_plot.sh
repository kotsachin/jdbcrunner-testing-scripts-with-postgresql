#!/bin/bash

#----THIS PROGRAM IS WRAPPER ON TOP OF THE JDBCRUNNER TOOL USED FOR BENCHMARKING OF DIFFERNENT DATABASES LIKE POSTGRES,ORACLE,MYSQL ETC.----
#--IN THIS WRAPPER WE CAN SET THE CONFIGURABLE PARAMETSRS OF THE JDBCRUNNER AND RUN THE TEST OVER NIGHT.

date=$1
st1=$2
st2=$3
st3=$4
st4=$5
st5=$6

#----------------------------Formating jdbcrunner csv files---
	for file in ./benchmark/$date/*/*/jdbcRunnerLogs/*_r.csv
	do
		server=$(echo "$file" | cut -c 33-39)
		run=$(echo "$file" | cut -c 41-44)
		img=$(echo "$file" | cut -c 65-81)
		mkdir -p ./benchmark/$date/$server/$run/gnuInput
		sed 's/,/\t/g' $file | sed 1d > ./benchmark/$date/$server/$run/gnuInput/$img.dat
	done

	for file in ./benchmark/$date/*/*/jdbcRunnerLogs/*_t.csv
	do
		server=$(echo "$file" | cut -c 33-39)
		run=$(echo "$file" | cut -c 41-44)
		img=$(echo "$file" | cut -c 65-81)
		mkdir -p ./benchmark/$date/$server/$run/gnuInput
		#sed 's/,/\t/g' $file | sed 1d > ./benchmark/$date/$server/$run/gnuInput/$img.dat
		cat $file | sed 1d | sed s/','/' '/g | awk '{print $2, $3, $4, $5, $6}' | ./movavg 10 | awk 'BEGIN{ line=1;}{print line,"\t", $0; line=line+1;}' > ./benchmark/$date/$server/$run/gnuInput/$img.dat
	done

            


#-----------------------------
#--Generate graph for each file in .png format under graphs directory.
# open .png files with gthumb in centos.
#----------------------------
	for file in ./benchmark/$date/*/*/gnuInput/*_t.dat
	do
	server=$(echo "$file" | cut -c 33-39)
	run=$(echo "$file" | cut -c 41-44)
	img=$(echo "$file" | cut -c 55-71)

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

	for file in ./benchmark/$date/*/*/gnuInput/*_r.dat
	do
	server=$(echo "$file" | cut -c 33-39)
	run=$(echo "$file" | cut -c 41-44)
	img=$(echo "$file" | cut -c 55-71)
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

