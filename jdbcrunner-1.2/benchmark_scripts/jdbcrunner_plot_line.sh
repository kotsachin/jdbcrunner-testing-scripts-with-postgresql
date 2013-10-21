#!/bin/bash -ex


date=$1
st1=$2
st2=$3
st3=$4
st4=$5
st5=$6
(
#----------------------------Formating jdbcrunner csv files---
	for file in ./benchmark/$date/*/*/jdbcRunnerLogs/*_r.csv
	do

		fwp=$(basename $file)
	        img=${fwp%.*}

		path=`dirname $file`
		f=${path%/*}
		mkdir -p $f/gnuInput
		sed 's/,/\t/g' $file | sed 1d > $f/gnuInput/$img.dat
	done

	for file in ./benchmark/$date/*/*/jdbcRunnerLogs/*_t.csv
	do
		fwp=$(basename $file)
	        img=${fwp%.*}

		path=`dirname $file`
		f=${path%/*}
		mkdir -p $f/gnuInput
		cat $file | sed 1d | sed s/','/' '/g | awk '{print $2, $3, $4, $5, $6}' | ./movavg 10 | awk 'BEGIN{ line=1;}{print line,"\t", $0; line=line+1;}' > $f/gnuInput/$img.dat
	done


            
	for file in ./benchmark/$date/*/*/gnuInput/*_t.dat
        do

                fwp=$(basename $file)
                img=${fwp%.*}

                path=`dirname $file`
                f=${path%/*}

                chk=`cat $f/pgStatsInfo/checkpoint_2.csv | head -n 1  | awk '{ print $3}'`
                if [ ! -z $chk ]
                then

                        st=`cat $f/jdbcRunnerLogs/jdbcrunner.log | grep "$chk" | awk '{ print $6}'`

                        chk_type=`cat $f/pgStatsInfo/checkpoint_2.csv | head -n 1  | awk '{ print $5}'`
                        if [ "$chk_type" == "time" ]
                        then
                                nd=`cat $f/pgStatsInfo/checkpoint_2.csv | head -n 1  | awk '{ print $12}'`
                                sync=`cat $f/pgStatsInfo/checkpoint_2.csv | head -n 1  | awk '{ print $11}'`
                        else

                                nd=`cat $f/pgStatsInfo/checkpoint_2.csv | head -n 1  | awk '{ print $13}'`
                                sync=`cat $f/pgStatsInfo/checkpoint_2.csv | head -n 1  | awk '{ print $12}'`
                        fi

			nd=`echo "$st + $nd" | bc`
                        sync=`echo "$nd - $sync" | bc`

                        cat $file | awk \
                        -v ts=$st -v val=0 -v val1=0 -v end=$nd -v sy=$sync \
                        'BEGIN{ORS="";} {if( ($1<ts) || ($1>end) ){ val=0; i=1; val1=0; while(i<=NF) {print $i," "; i=i+1; } print val,"   "val1"  ""\n";} \
                        else if($1>sy){ val=50; i=1; val1=50; while(i<=NF) {print $i," "; i=i+1; } print val,"   "val1"  ""\n";} \
                        else{ val=50; i=1; val1=0;  while(i<=NF) {print $i," "; i=i+1; } print val,"   "val1"  ""\n";} }' \
                        > $f/gnuInput/chk.dat

                fi


		chk=`cat $f/pgStatsInfo/checkpoint_2.csv | sed -n 2p  | awk '{ print $3}'`
                if [ ! -z $chk ]
                then

                        st=`cat $f/jdbcRunnerLogs/jdbcrunner.log | grep "$chk" | head -n 1 | awk '{ print $6}'`

                        chk_type=`cat $f/pgStatsInfo/checkpoint_2.csv | head -n 1  | awk '{ print $5}'`
                        if [ "$chk_type" == "time" ]
                        then
                                nd=`cat $f/pgStatsInfo/checkpoint_2.csv | head -n 1  | awk '{ print $12}'`
                                sync=`cat $f/pgStatsInfo/checkpoint_2.csv | head -n 1  | awk '{ print $11}'`
                        else

                                nd=`cat $f/pgStatsInfo/checkpoint_2.csv | head -n 1  | awk '{ print $13}'`
                                sync=`cat $f/pgStatsInfo/checkpoint_2.csv | head -n 1  | awk '{ print $12}'`
                        fi

                        nd=`echo "$st + $nd" | bc`
                        sync=`echo "$nd - $sync" | bc`

                        cat $f/gnuInput/chk.dat | awk \
                        -v ts=$st -v val=0 -v val1=0 -v end=$nd -v sy=$sync \
                        'BEGIN{ORS="";} {if( ($1<ts) || ($1>end) ){ val=0; i=1; val1=0; while(i<=NF) {print $i," "; i=i+1; } print val,"   "val1"\n";} \
                        else if($1>sy){ val=50; i=1; val1=50; while(i<=NF) {print $i," "; i=i+1; } print val,"   "val1"\n";} \
                        else{ val=50; i=1; val1=0;  while(i<=NF) {print $i," "; i=i+1; } print val,"   "val1"\n";} }' \
                        > $f/gnuInput/chk2.dat

                fi


	done

#-----------------------------
#--Generate graph for each file in .png format under graphs directory.
# open .png files with gthumb in centos.
#----------------------------
	for file in ./benchmark/$date/*/*/gnuInput/chk2.dat
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
                plot=( '"'$file'"'  using 1:2 title '"Transaction Type-1"' with lines , '"'$file'"'  using 1:7 title '"Checkpoint_1 Write"' with lines , '"'$file'"'  using 1:8 title '"Checkpoint_1 Sync"' with lines  , '"'$file'"'  using 1:9 title '"Checkpoint_2 Write"' with lines , '"'$file'"'  using 1:10 title '"Checkpoint_2 Sync"' with lines )
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
                plot=( '"'$file'"'  using 1:3 title '"Transaction Type-2"' with lines , '"'$file'"'  using 1:7 title '"Checkpoint_1 Write"' with lines , '"'$file'"'  using 1:8 title '"Checkpoint_1 Sync"' with lines , '"'$file'"'  using 1:9 title '"Checkpoint_2 Write"' with lines , '"'$file'"'  using 1:10 title '"Checkpoint_2 Sync"' with lines )
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
                plot=( '"'$file'"'  using 1:4 title '"Transaction Type-3"' with lines , '"'$file'"'  using 1:7 title '"Checkpoint_1 Write"' with lines , '"'$file'"'  using 1:8 title '"Checkpoint_1 Sync"' with lines , '"'$file'"'  using 1:9 title '"Checkpoint_2 Write"' with lines , '"'$file'"'  using 1:10 title '"Checkpoint_2 Sync"' with lines )
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
                plot=( '"'$file'"'  using 1:5 title '"Transaction Type-4"' with lines , '"'$file'"'  using 1:7 title '"Checkpoint_1 Write"' with lines  , '"'$file'"'  using 1:8 title '"Checkpoint_1 Sync"' with lines , '"'$file'"'  using 1:9 title '"Checkpoint_2 Write"' with lines , '"'$file'"'  using 1:10 title '"Checkpoint_2 Sync"' with lines )
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
                plot=( '"'$file'"'  using 1:6 title '"Transaction Type-5"' with lines , '"'$file'"'  using 1:7 title '"Checkpoint_1 Write"' with lines , '"'$file'"'  using 1:8 title '"Checkpoint_1 Sync"' with lines , '"'$file'"'  using 1:9 title '"Checkpoint_2 Write"' with lines , '"'$file'"'  using 1:10 title '"Checkpoint_2 Sync"' with lines )
                graph
        }
	plot5_t
	mv TransactionType-5_t.png $f/gnuPlot/TransactionType-5_t.png


	done

#-----------------------------------------------------------------

	for file in ./benchmark/$date/*/*/gnuInput/*_r.dat
	do
		path=`dirname $file`
                f=${path%/*}
                mkdir -p $f/gnuPlot

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
                plot=( '"'$file'"'  using \(\$1/1000\):2 title '"Transaction Type-1"' with lines  )
                graph
        }
	plot1_r
	mv TransactionType-1_r.png $f/gnuPlot/TransactionType-1_r.png

	plot2_r(){
                fileType="png"
                output='"TransactionType-2_r.png"'
                title='"tx2 : Payment transaction | sleep time: '$st2'"'
                xlabel='"Response Time \(seconds)"'
                ylabel='"Count (Number of transaction)"'
                plot=( '"'$file'"'  using \(\$1/1000\):3 title '"Transaction Type-2"' with lines  )
                graph
        }
	plot2_r
	mv TransactionType-2_r.png $f/gnuPlot/TransactionType-2_r.png

	plot3_r(){
                fileType="png"
                output='"TransactionType-3_r.png"'
                title='"tx3 : Order-Status transaction | sleep time :'$st3'"'
                xlabel='"Response Time \(seconds)"'
                ylabel='"Count (Number of transaction)"'
                plot=( '"'$file'"'  using \(\$1/1000\):4 title '"Transaction Type-3"' with lines  )
                graph
        }
	plot3_r
	mv TransactionType-3_r.png $f/gnuPlot/TransactionType-3_r.png

	plot4_r(){
                fileType="png"
                output='"TransactionType-4_r.png"'
                title='"tx4 : Delivery transaction | sleep time: '$st4'"'
                xlabel='"Response Time \(seconds)"'
                ylabel='"Count (Number of transaction)"'
                plot=( '"'$file'"'  using \(\$1/1000\):5 title '"Transaction Type-4"' with lines  )
                graph
        }
	plot4_r
	mv TransactionType-4_r.png $f/gnuPlot/TransactionType-4_r.png

	plot5_r(){
                fileType="png"
                output='"TransactionType-5_r.png"'
                title='"tx5 : Stock-Level transaction | sleep time: '$st5'"'
                xlabel='"Response Time \(seconds)"'
                ylabel='"Count (Number of transaction)"'
                plot=( '"'$file'"'  using \(\$1/1000\):6 title '"Transaction Type-5"' with lines  )
                graph
        }
	plot5_r
	mv TransactionType-5_r.png $f/gnuPlot/TransactionType-5_r.png


	done
) 2> error.log
