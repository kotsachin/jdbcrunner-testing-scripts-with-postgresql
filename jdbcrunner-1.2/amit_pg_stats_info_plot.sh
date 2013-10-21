#!/bin/bash

#----THIS PROGRAM IS WRAPPER ON TOP OF THE JDBCRUNNER TOOL USED FOR BENCHMARKING OF DIFFERNENT DATABASES LIKE POSTGRES,ORACLE,MYSQL ETC.----
#--IN THIS WRAPPER WE CAN SET THE CONFIGURABLE PARAMETSRS OF THE JDBCRUNNER AND RUN THE TEST OVER NIGHT.

date=$1

#-----------------------------
#--Generate graph for each file in .png format under pg_Stats directory.
# open .png files with gthumb in centos.
#----------------------------
for file in ./benchmark/$date/*/*/pg_stats_info/proc_ratio_2.txt
do
	server=$(echo "$file" | cut -c 33-39)
	run=$(echo "$file" | cut -c 41-44)
	img=$(echo "$file" | cut -c 55-71)

	mkdir -p ./benchmark/$date/$server/$run/gnuPlot/pg_Stats
           

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
                output='"processor_usage.png"'
                title='"Processor usage tendency report"'
                xlabel='"Snap Time \(HH:MM)"'
                ylabel='"Processor usage tendency in (precentage)"'
                yrange='[0:100]'
                plot=( '"'$file'"'  using 2:3 title '"idle"' with lines , '"'$file'"'  using 2:4 title '"idle_in_xact"' with lines , '"'$file'"'  using 2:5 title '"waiting"' with lines , '"'$file'"'  using 2:6 title '"running"' with lines )
                graph
        }
        plotproc
        mv processor_usage.png ./benchmark/$date/$server/$run/gnuPlot/pg_Stats/processor_usage.png

done


for file in ./benchmark/$date/*/*/pg_stats_info/xlog_2.txt
do
	server=$(echo "$file" | cut -c 33-39)
	run=$(echo "$file" | cut -c 41-44)
	img=$(echo "$file" | cut -c 55-71)

	mkdir -p ./benchmark/$date/$server/$run/gnuPlot/pg_Stats
           

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
        plotxlog(){
                fileType="png"
                output='"xlog_stats.png"'
                title='"xlog write tendency report"'
                xlabel='"Snap Time \(HH:MM)"'
                ylabel='"xlog write tendency in MB(MB/sec)"'
                yrange='[0:1000]'
                plot=( '"'$file'"'  using 2:5 title '"write_size"' with lines , '"'$file'"'  using 2:6 title '"write_size_per_sec"' with lines  )
                graph
        }
        plotxlog
        mv xlog_stats.png ./benchmark/$date/$server/$run/gnuPlot/pg_Stats/xlog_stats.png


done

for file in ./benchmark/$date/*/*/pg_stats_info/io_sda2_2.txt
do
	server=$(echo "$file" | cut -c 33-39)
	run=$(echo "$file" | cut -c 41-44)
	img=$(echo "$file" | cut -c 55-71)

	mkdir -p ./benchmark/$date/$server/$run/gnuPlot/pg_Stats
           

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
        plotio_sda2(){
                fileType="png"
                output='"io_sda2.png"'
                title='"sda2 io tendency report"'
                xlabel='"Snap Time \(HH:MM)"'
                ylabel='"sda2 io usage in Thousands"'
                yrange='[0:200]'
                plot=( '"'$file'"'  using 2:\(\$4/1000\) title '"read_size_tps"' with lines , '"'$file'"'  using 2:\(\$5/1000\) title '"write_size_tps"' with lines , '"'$file'"'  using 2:\(\$6/1000\) title '"read_time_tps"' with lines , '"'$file'"'  using 2:\(\$7/1000\) title '"write_time_tps"' with lines )
                graph
        }
        plotio_sda2
        mv io_sda2.png ./benchmark/$date/$server/$run/gnuPlot/pg_Stats/io_sda2.png

done


for file in ./benchmark/$date/*/*/pg_stats_info/io_sda5_2.txt
do
	server=$(echo "$file" | cut -c 33-39)
	run=$(echo "$file" | cut -c 41-44)
	img=$(echo "$file" | cut -c 55-71)

	mkdir -p ./benchmark/$date/$server/$run/gnuPlot/pg_Stats
           

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
        plotio_sda5(){
                fileType="png"
                output='"io_sda5.png"'
                title='"sda5 io tendency report"'
                xlabel='"Snap Time \(HH:MM)"'
                ylabel='"sda5 io usage in Thousands"'
                yrange='[0:100]'
                plot=( '"'$file'"'  using 2:\(\$4/1000\) title '"read_size_tps"' with lines , '"'$file'"'  using 2:\(\$5/1000\)  title '"write_size_tps"' with lines , '"'$file'"'  using 2:\(\$6/1000\)  title '"read_time_tps"' with lines , '"'$file'"'  using 2:\(\$7/1000\)  title '"write_time_tps"' with lines )
                graph
        }
        plotio_sda5
        mv io_sda5.png ./benchmark/$date/$server/$run/gnuPlot/pg_Stats/io_sda5.png

done

for file in ./benchmark/$date/*/*/pg_stats_info/disk_table_1.txt
do
	server=$(echo "$file" | cut -c 33-39)
	run=$(echo "$file" | cut -c 41-44)
	img=$(echo "$file" | cut -c 55-71)

	mkdir -p ./benchmark/$date/$server/$run/gnuPlot/pg_Stats
           

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
        mv table_size.png ./benchmark/$date/$server/$run/gnuPlot/pg_Stats/table_size.png

        plot_table2(){
                fileType="png"
                output='"table_reads.png"'
                title='"Disk activity of tables in tpcc"'
                xlabel='"All Tables"'
                ylabel='"Size in MB"'
                yrange='[0:150000]'
                plot=( '"'$file'"'  using 5:xtic\(3\) title '"table size"'  )
                graph
        }
        plot_table2
        mv table_reads.png ./benchmark/$date/$server/$run/gnuPlot/pg_Stats/table_reads.png

        plot_table3(){
                fileType="png"
                output='"index_reads.png"'
                title='"Disk activity of tables in tpcc"'
                xlabel='"All Tables"'
                ylabel='"Size in MB"'
                yrange='[0:100000]'
                plot=( '"'$file'"'  using 6:xtic\(3\) title '"table size"'  )
                graph
        }
        plot_table3
        mv index_reads.png ./benchmark/$date/$server/$run/gnuPlot/pg_Stats/index_reads.png

        plot_table4(){
                fileType="png"
                output='"toast_reads.png"'
                title='"Disk activity of tables in tpcc"'
                xlabel='"All Tables"'
                ylabel='"Size in MB"'
                yrange='[0:10]'
                plot=( '"'$file'"'  using 7:xtic\(3\) title '"table size"'   )
                graph
        }
        plot_table4
        mv toast_reads.png ./benchmark/$date/$server/$run/gnuPlot/pg_Stats/toast_reads.png

done

for file in ./benchmark/$date/*/*/pg_stats_info/memory_2.txt
do
	server=$(echo "$file" | cut -c 33-39)
	run=$(echo "$file" | cut -c 41-44)
	img=$(echo "$file" | cut -c 55-71)

	mkdir -p ./benchmark/$date/$server/$run/gnuPlot/pg_Stats
           

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
        plotmemory(){
                fileType="png"
                output='"memory_usage.png"'
                title='"Memory tendency report"'
                xlabel='"Snap Time \(HH:MM)"'
                ylabel='"Memory usage tendency in (MB)"'
                yrange='[0:3000]'
                plot=( '"'$file'"'  using 2:3 title '"memfree"' with lines , '"'$file'"'  using 2:4 title '"buffers"' with lines , '"'$file'"'  using 2:5 title '"cached"' with lines , '"'$file'"'  using 2:6 title '"swap"' with lines , '"'$file'"'  using 2:7 title '"dirty"' with lines )
                graph
        }
        plotmemory
        mv memory_usage.png ./benchmark/$date/$server/$run/gnuPlot/pg_Stats/memory_usage.png

done
