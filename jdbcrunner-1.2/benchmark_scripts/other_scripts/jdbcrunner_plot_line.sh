#!/bin/bash

#----THIS PROGRAM IS WRAPPER ON TOP OF THE JDBCRUNNER TOOL USED FOR BENCHMARKING OF DIFFERNENT DATABASES LIKE POSTGRES,ORACLE,MYSQL ETC.----
#--IN THIS WRAPPER WE CAN SET THE CONFIGURABLE PARAMETSRS OF THE JDBCRUNNER AND RUN THE TEST OVER NIGHT.

date=$1
st1=$2
st2=$3
st3=$4
st4=$5
st5=$6

#--Generate graph for each file in .png format under graphs directory.
# open .png files with gthumb in centos.
#----------------------------
	#for file in ./benchmark/$date/*/*/gnuInput/*_t.dat
	for file in ./benchmark/$date/*/*/gnuInput/chk3.dat
	do
		path=`dirname $file`
		f=${path%/*}
		mkdir -p $f/gnuPlot
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
                plot=( '"'$file'"'  using 1:2 title '"Transaction Type-1"' with lines , '"'$file'"'  using 1:7 title '"Checkpoint_1 Write"' with lines , '"'$file'"'  using 1:8 title '"Checkpoint_1 Sync"' with lines  , '"'$file'"'  using 1:9 title '"Checkpoint_2 Write"' with lines , '"'$file'"'  using 1:10 title '"Checkpoint_2 Sync"' with lines ,'"'$file'"'  using 1:11 title '"Backup_Activity"' with lines )
                graph
        }
	plot1_t
	mv TransactionType-1_t.png $f/gnuPlot/TransactionType-1_t.png

	plot2_t(){
                fileType="png"
                output='"TransactionType-2_t.png"'
                title='"tx2 : Payment transaction | steep time: '$st2'"'
                xlabel='"Elapsed Time \(seconds)"'
                ylabel='"Throughput (Number of transaction)"'
                plot=( '"'$file'"'  using 1:3 title '"Transaction Type-2"' with lines , '"'$file'"'  using 1:7 title '"Checkpoint_1 Write"' with lines , '"'$file'"'  using 1:8 title '"Checkpoint_1 Sync"' with lines , '"'$file'"'  using 1:9 title '"Checkpoint_2 Write"' with lines , '"'$file'"'  using 1:10 title '"Checkpoint_2 Sync"' with lines ,'"'$file'"'  using 1:11 title '"Backup_Activity"' with lines )
                graph
        }
	plot2_t
	mv TransactionType-2_t.png $f/gnuPlot/TransactionType-2_t.png

	plot3_t(){
                fileType="png"
                output='"TransactionType-3_t.png"'
                title='"tx3 : Order-Status transaction | sleep time: '$st3'"'
                xlabel='"Elapsed Time \(seconds)"'
                ylabel='"Throughput (Number of transaction)"'
                plot=( '"'$file'"'  using 1:4 title '"Transaction Type-3"' with lines , '"'$file'"'  using 1:7 title '"Checkpoint_1 Write"' with lines , '"'$file'"'  using 1:8 title '"Checkpoint_1 Sync"' with lines , '"'$file'"'  using 1:9 title '"Checkpoint_2 Write"' with lines , '"'$file'"'  using 1:10 title '"Checkpoint_2 Sync"' with lines ,'"'$file'"'  using 1:11 title '"Backup_Activity"' with lines )
                graph
        }
	plot3_t
	mv TransactionType-3_t.png $f/gnuPlot/TransactionType-3_t.png


	plot4_t(){
                fileType="png"
                output='"TransactionType-4_t.png"'
                title='"tx4 : Delivery transaction | sleep time: '$st4'"'
                xlabel='"Elapsed Time \(seconds)"'
                ylabel='"Throughput (Number of transaction)"'
                plot=( '"'$file'"'  using 1:5 title '"Transaction Type-4"' with lines , '"'$file'"'  using 1:7 title '"Checkpoint_1 Write"' with lines  , '"'$file'"'  using 1:8 title '"Checkpoint_1 Sync"' with lines , '"'$file'"'  using 1:9 title '"Checkpoint_2 Write"' with lines , '"'$file'"'  using 1:10 title '"Checkpoint_2 Sync"' with lines ,'"'$file'"'  using 1:11 title '"Backup_Activity"' with lines )
                graph
        }
	plot4_t
	mv TransactionType-4_t.png $f/gnuPlot/TransactionType-4_t.png

	plot5_t(){
                fileType="png"
                output='"TransactionType-5_t.png"'
                title='"tx5 : Stock-Level transaction | sleep time: '$st5'"'
                xlabel='"Elapsed Time \(seconds)"'
                ylabel='"Throughput (Number of transaction)"'
                plot=( '"'$file'"'  using 1:6 title '"Transaction Type-5"' with lines , '"'$file'"'  using 1:7 title '"Checkpoint_1 Write"' with lines , '"'$file'"'  using 1:8 title '"Checkpoint_1 Sync"' with lines , '"'$file'"'  using 1:9 title '"Checkpoint_2 Write"' with lines , '"'$file'"'  using 1:10 title '"Checkpoint_2 Sync"' with lines ,'"'$file'"'  using 1:11 title '"Backup_Activity"' with lines )
                graph
        }
	plot5_t
	mv TransactionType-5_t.png $f/gnuPlot/TransactionType-5_t.png


	done

