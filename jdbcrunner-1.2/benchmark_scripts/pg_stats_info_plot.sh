#!/bin/bash


date=$1

(
#-----------------------------
#--Generate graph for each file in .png format under pgStatsInfo directory.
# open .png files with gthumb in centos.
#----------------------------
	for file in ./benchmark/$date/*/*/pgStatsInfo/db_stats_2.txt
	do
		path=`dirname $file`
                f=${path%/*}

	mkdir -p $f/gnuPlot/pgStatsInfo 2> error.log
   

	graph () {
gnuplot << EOF
        set size 1,1
        set terminal $fileType size 840,480
        set output $output
        set key outside right top vertical Right noreverse enhanced autotitles box linetype -1 linewidth 1.000
        set title $title
        set xlabel $xlabel offset 38,1
        set ylabel $ylabel 
        set xdata time
        set timefmt "%H:%M:%S "
        set format x "%H:%M:%S"
        set xtics rotate autofreq
        set lmargin at screen 0.12
        set rmargin at screen 0.70
	set bmarg 4.40
        set autoscale yfixmin
	set autoscale yfixmax
        plot ${plot[*]}
EOF
        }
	plotdb1(){
                fileType="png"
                output='"db_size.png"'
                title='"DB_size"'
                xlabel='"Snap Time \(HH:MM:SS)"'


                xlabel='"Snap Time \(HH:MM:SS)"'
                ylabel='"Size of Database (in MB)"'
                yrange='[0:20000]'
                plot=( '"'$file'"'  using 2:\(\$6/1000000\) title '"pgStatsInfo with DB_size"' with lines  )
                graph
        }
        plotdb1
        mv db_size.png $f/gnuPlot/pgStatsInfo/db_size.png 2> error.log


        plotdb2(){
                fileType="png"
                output='"db_xact_commit.png"'
                title='"DB_xact_commit"'
                xlabel='"Snap Time \(HH:MM:SS)"'
                ylabel='"Number of xact_commit(in Millions)"'
                yrange='[0:100]'
                plot=( '"'$file'"'  using 2:\(\$8/1000000\) title '"pgStatsInfo with DB_xact_commit"' with lines  )
                graph
        }
        plotdb2
        mv db_xact_commit.png $f/gnuPlot/pgStatsInfo/db_xact_commit.png 2> error.log

        plotdb3(){
                fileType="png"
                output='"db_xact_rollback.png"'
                title='"DB_xact_rollback"'
                xlabel='"Snap Time \(HH:MM:SS)"'
                ylabel='"Number of xact_rollback (in Thousand)"'
                yrange='[0:200]'
                plot=( '"'$file'"'  using 2:\(\$9/1000\) title '"pgStatsInfo with DB_size"' with lines  )
                graph
        }
        plotdb3
                                                                                     
	mv db_xact_rollback.png $f/gnuPlot/pgStatsInfo/db_xact_rollback.png 2> error.log

        plotdb4(){
                fileType="png"
                output='"db_blks_read.png"'
                title='"DB_blks_read"'
                xlabel='"Snap Time \(HH:MM:SS)"'
                ylabel='"Number of blks_read (in Millions)"'
                yrange='[0:100]'
                plot=( '"'$file'"'  using 2:\(\$10/1000000\) title '"pgStatsInfo with DB_blks_read"' with lines  )
                graph
        }
        plotdb4
                                                                                     
	mv db_blks_read.png $f/gnuPlot/pgStatsInfo/db_blks_read.png 2> error.log
        plotdb5(){
                fileType="png"
                output='"db_bulks_hit.png"'
                title='"DB_bulks_hit"'
                xlabel='"Snap Time \(HH:MM:SS)"'
                ylabel='"Number of blks_hit (in Millions)"'
                yrange='[0:1000]'
                plot=( '"'$file'"'  using 2:\(\$11/1000000\) title '"pgStatsInfo with DB_bulks_hit"' with lines  )
                graph
        }
        plotdb5
                                                                                     
	mv db_bulks_hit.png $f/gnuPlot/pgStatsInfo/db_bulks_hit.png 2> error.log
        plotdb6(){
                fileType="png"
                output='"db_tup_returned.png"'
                title='"DB_tup_returned"'
                xlabel='"Snap Time \(HH:MM:SS)"'
                ylabel='"Number of tup_returned (in Millions)"'
                yrange='[0:1000]'
                plot=( '"'$file'"'  using 2:\(\$12/1000000\) title '"pgStatsInfo with DB_tup_returned"' with lines  )
                graph
        }
        plotdb6
	mv db_tup_returned.png $f/gnuPlot/pgStatsInfo/db_tup_returned.png 2> error.log
                                                                                     
        plotdb7(){
                fileType="png"
                output='"db_tup_fetched.png"'
                title='"DB_tup_fetched"'
                xlabel='"Snap Time \(HH:MM:SS)"'
                ylabel='"Number of tup_fetched (in Millions)"'
                yrange='[0:1000]'
                plot=( '"'$file'"'  using 2:\(\$13/1000000\) title '"pgStatsInfo with DB_tup_fetched"' with lines  )
                graph
        }
        plotdb7
                                                                                     
	mv db_tup_fetched.png $f/gnuPlot/pgStatsInfo/db_tup_fetched.png 2> error.log

        plotdb8(){
                fileType="png"
                output='"db_tup_inserted.png"'
                title='"DB_tup_inserted"'
                xlabel='"Snap Time \(HH:MM:SS)"'
                ylabel='"Number of tup_inserted (in Millions)"'
                yrange='[0:500]'
                plot=( '"'$file'"'  using 2:\(\$14/1000000\) title '"pgStatsInfo with DB_tup_inserted"' with lines  )
                graph
        }
        plotdb8
                                                                                     
	mv db_tup_inserted.png $f/gnuPlot/pgStatsInfo/db_tup_inserted.png 2> error.log

        plotdb9(){
                fileType="png"
                output='"db_tup_updated.png"'
                title='"DB_tup_updated"'
                xlabel='"Snap Time \(HH:MM:SS)"'
                ylabel='"Number of tup_updated (in Millions)"'
                yrange='[0:200]'
                plot=( '"'$file'"'  using 2:\(\$15/1000000\) title '"pgStatsInfo with DB_tup_updated"' with lines  )
                graph
        }
        plotdb9
                                                                                     
	mv db_tup_updated.png $f/gnuPlot/pgStatsInfo/db_tup_updated.png 2> error.log

        plotdb10(){
                fileType="png"
                output='"db_tup_deleted.png"'
                title='"DB_tup_deleted"'
                xlabel='"Snap Time \(HH:MM:SS)"'
                ylabel='"Number of tup_deleted (in Millions)"'
                yrange='[0:20]'
                plot=( '"'$file'"'  using 2:\(\$16/1000000\) title '"pgStatsInfo with DB_tup_deleted"' with lines  )
                graph
        }
        plotdb10
                                                                                     
	mv db_tup_deleted.png $f/gnuPlot/pgStatsInfo/db_tup_deleted.png 2> error.log
	

        done



#-----------------------------
#--Generate graph for each file in .png format under pgStatsInfo directory.
# open .png files with gthumb in centos.
#----------------------------
for file in ./benchmark/$date/*/*/pgStatsInfo/processes_ratio_2.txt
do
	path=`dirname $file`
        f=${path%/*}

	mkdir -p $f/gnuPlot/pgStatsInfo 2> error.log
           

	graph () {
gnuplot << EOF
        set size 1,1
        set terminal $fileType size 840,480
        set output $output
        set key outside right top vertical Right noreverse enhanced autotitles box linetype -1 linewidth 1.000
        set title $title
        set xlabel $xlabel offset 38,1
        set ylabel $ylabel 
        set xdata time
        set timefmt "%H:%M "
        set format x "%H:%M"
        set xtics rotate autofreq
        set lmargin at screen 0.12
        set rmargin at screen 0.70
	set bmarg 4.40
        set yrange $yrange
        set autoscale yfixmin
	set autoscale yfixmax
        plot ${plot[*]}
EOF
        }
        plotproc(){
                fileType="png"
                output='"processes_usage.png"'
                title='"Processes usage report"'
                xlabel='"Snap Time \(HH:MM)"'
                ylabel='"Processes usage in (precentage)"'
                yrange='[0:100]'
                plot=( '"'$file'"'  using 2:3 title '"idle"' with lines , '"'$file'"'  using 2:4 title '"idle_in_xact"' with lines , '"'$file'"'  using 2:5 title '"waiting"' with lines , '"'$file'"'  using 2:6 title '"running"' with lines )
                graph
        }
        plotproc
        mv processes_usage.png $f/gnuPlot/pgStatsInfo/processes_usage.png 2> error.log

done


for file in ./benchmark/$date/*/*/pgStatsInfo/xlog_2.txt
do
	path=`dirname $file`
        f=${path%/*}

	mkdir -p $f/gnuPlot/pgStatsInfo 2> error.log
           

	graph () {
gnuplot << EOF
        set size 1,1
        set terminal $fileType size 840,480
        set output $output
        set key outside right top vertical Right noreverse enhanced autotitles box linetype -1 linewidth 1.000
        set title $title
        set xlabel $xlabel offset 38,1
        set ylabel $ylabel 
        set xdata time
        set timefmt "%H:%M "
        set format x "%H:%M"
        set xtics rotate autofreq
	set ytics nomirror
	set y2tics
	set tics out
	set ytics nomirror
	set y2tics
	set tics out
	set autoscale  y
	set autoscale y2
	set y2label "xlog write in (MB/sec)"
        set lmargin at screen 0.12
        set rmargin at screen 0.70
	set bmarg 4.40
        set yrange $yrange
	set y2range [0:20]
        #set autoscale yfixmin
	#set autoscale yfixmax
        plot ${plot[*]}
EOF
        }
        plotxlog(){
                fileType="png"
                output='"xlog_stats.png"'
                title='"xlog write  report"'
                xlabel='"Snap Time \(HH:MM)"'
                ylabel='"xlog write in MB"'
                yrange='[0:1000]'
                plot=( '"'$file'"'  using 2:5  title '"write_size"' with lines axes x1y1 , '"'$file'"'  using 2:6  title '"write_size_per_sec"' with lines axes x1y2 )
                graph
        }
        plotxlog
        mv xlog_stats.png $f/gnuPlot/pgStatsInfo/xlog_stats.png 2> error.log


done



#------------Table level Disk activity statistics-----------------

for file in ./benchmark/$date/*/*/pgStatsInfo/db_disk_table_2.txt
do
	path=`dirname $file`
        f=${path%/*}

	mkdir -p $f/gnuPlot/pgStatsInfo 2> error.log
           

	graph () {
gnuplot << EOF
        set size 1,1
        set terminal $fileType size 840,480
	set xtic rotate by 90 offset 0.3,-4.5 
	set style data histograms
	set style fill solid 1.00 border -1
	set output $output
        set key outside right top vertical Right noreverse enhanced autotitles box linetype -1 linewidth 1.000
        set title $title
        set xlabel $xlabel offset 38,1
        set ylabel $ylabel 
        set lmargin at screen 0.14
        set rmargin at screen 0.70
	set bmarg 5.40
        set yrange $yrange
        #set autoscale xfixmin
	#set autoscale xfixmax
        plot ${plot[*]}
EOF
        }
        plot_table1(){
                fileType="png"
                output='"table_size.png"'
                title='"Disk activity of tables in tpcc"'
                xlabel='"All Tables"'
                ylabel='"Size in MB"'
                yrange='[0:4000]'
                plot=( '"'$file'"'  using 4:xtic\(3\) title '"table size"'  )
                graph
        }
        plot_table1
        mv table_size.png $f/gnuPlot/pgStatsInfo/table_size.png 2> error.log

        plot_table2(){
                fileType="png"
                output='"table_blocks_read.png"'
                title='"Disk activity of tables in tpcc"'
                xlabel='"All Tables"'
                ylabel='"Number of blocks read"'
                yrange='[0:150000]'
                plot=( '"'$file'"'  using 5:xtic\(3\) title '"table blocks read"'  )
                graph
        }
        plot_table2
        mv table_blocks_read.png $f/gnuPlot/pgStatsInfo/table_blocks_read.png 2> error.log

        plot_table3(){
                fileType="png"
                output='"table_index_read.png"'
                title='"Disk activity of tables in tpcc"'
                xlabel='"All Tables"'
                ylabel='"Number of index read"'
                yrange='[0:100000]'
                plot=( '"'$file'"'  using 6:xtic\(3\) title '"table index read"'  )
                graph
        }
        plot_table3
        mv table_index_read.png $f/gnuPlot/pgStatsInfo/table_index_read.png 2> error.log


done
) 2> error.log
