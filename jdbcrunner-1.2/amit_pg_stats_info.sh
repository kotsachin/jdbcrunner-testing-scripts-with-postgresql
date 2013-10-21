#!/bin/bash

date=$1
count=$2

#--------------Retrieve resultant stats from pg_statsinfo. ---------------------------------------------------
#---It retrives data for the snapshots that were taken within the measurement interval of the benchmark-------

startts=`cat ./benchmark/$date/Server1/Run$count/jdbcRunnerLogs/jdbcrunner.log | grep " 1 sec" | awk '{print $1, $2}'`
endts=`cat ./benchmark/$date/Server1/Run$count/jdbcRunnerLogs/jdbcrunner.log | grep "Total tx count" | awk '{print $1, $2}'`


#echo $startts, $endts
snapids=`psql -h 172.26.139.4 -d postgres -c "copy( \
                                        select \
                                                min(sn.snapid), \
                                                max(sn.snapid) \
                                        from statsrepo.snapshot sn\
                                        where \
                                                to_char(sn.time::timestamp, 'YYYY-MM-DD HH24:MI:SS')::timestamp between '$startts'::timestamp and '$endts'::timestamp
                                        ) \
                                        to stdout \
                                        with delimiter ' '"`

min=`echo $snapids | awk '{print $1}'`
max=`echo $snapids | awk '{print $2}'`


# Database stats for tpcc
#Fields: datname, size, size_incr, xact_commit_tps, xact_rollback_tps, blks_hit_rate, blks_hit_tps, blks_read_tps, 
#	 tup_fetch_tps, temp_files, temp_bytes, deadlocks, blk_read_time, blk_write_time
psql -h 172.26.139.4 -d postgres -c "copy( \
					select * \
					from statsrepo.get_dbstats($min, $max) \
					where datname='tpcc' \
					) \
					to stdout \
					with delimiter ' '" > ./benchmark/$date/Server1/Run$count/pg_stats_info/dbstats_1.txt

#Transaction tendency report for tpcc
#Fields: timestamp, datname, commit_tps, rollback_tps

psql -h 172.26.139.4 -d postgres -c "copy( \
                                        select * \
                                        from statsrepo.get_xact_tendency_report($min, $max) \
					where datname='tpcc' \
					) \
					to stdout \
                                        with delimiter ' '" > ./benchmark/$date/Server1/Run$count/pg_stats_info/xact_2.txt

# database size tendency report for tpcc
# Fields: timestamp, datname, size

psql -h 172.26.139.4 -d postgres -c "copy( \
                                        select * \
                                        from statsrepo.get_dbsize_tendency_report($min, $max) \
                                        where datname='tpcc' \
                                        ) \
                                        to stdout \
                                        with delimiter ' '" > ./benchmark/$date/Server1/Run$count/pg_stats_info/dbsize_2.txt

# Processor usage ratio
# Fields: idle, idle_in_xact, waiting, running

psql -h 172.26.139.4 -d postgres -c "copy( \
                                        select * \
                                        from statsrepo.get_proc_ratio($min, $max) \
                                        ) \
                                        to stdout \
                                        with delimiter ' '" > ./benchmark/$date/Server1/Run$count/pg_stats_info/proc_ratio_1.txt
# Processor usage tendency report
# fields: timestamp, idle, idle_in_xact, waiting, running

psql -h 172.26.139.4 -d postgres -c "copy( \
                                        select * \
                                        from statsrepo.get_proc_tendency_report($min, $max) \
                                        ) \
                                        to stdout \
                                        with delimiter ' '" > ./benchmark/$date/Server1/Run$count/pg_stats_info/proc_ratio_2.txt

# xlog stats
# Fields: write_total, write_speed

psql -h 172.26.139.4 -d postgres -c "copy( \
                                        select * \
                                        from statsrepo.get_xlog_stats($min, $max) \
                                        ) \
                                        to stdout \
                                        with delimiter ' '" > ./benchmark/$date/Server1/Run$count/pg_stats_info/xlog_1.txt
# xlog tendency report
# fields: timestamp, location, xlogfile, write_size, write_size_per_sec

psql -h 172.26.139.4 -d postgres -c "copy( \
                                        select * \
                                        from statsrepo.get_xlog_tendency($min, $max) \
                                        ) \
                                        to stdout \
                                        with delimiter ' '" > ./benchmark/$date/Server1/Run$count/pg_stats_info/xlog_2.txt

# cpu usage
# fields: user, system, idle, iowait

psql -h 172.26.139.4 -d postgres -c "copy( \
                                        select * \
                                        from statsrepo.get_cpu_usage($min, $max) \
                                        ) \
                                        to stdout \
                                        with delimiter ' '" > ./benchmark/$date/Server1/Run$count/pg_stats_info/cpu_1.txt

# cpu usage tendency report
# fields:  timestamp, user, system, idle, iowait

psql -h 172.26.139.4 -d postgres -c "copy( \
                                        select * \
                                        from statsrepo.get_cpu_usage_tendency_report($min, $max) \
                                        ) \
                                        to stdout \
                                        with delimiter ' '" > ./benchmark/$date/Server1/Run$count/pg_stats_info/cpu_2.txt
# cpu loadavg tendency report
# Fields: timestamp, 1min, 5min, 15min

psql -h 172.26.139.4 -d postgres -c "copy( \
                                        select * \
                                        from statsrepo.get_loadavg_tendency($min, $max) \
                                        ) \
                                        to stdout \
                                        with delimiter ' '" > ./benchmark/$date/Server1/Run$count/pg_stats_info/loadavg_2.txt

# memory tendency report
# fields: timestamp, memfree, buffers, cached, swap, dirty

psql -h 172.26.139.4 -d postgres -c "copy( \
                                        select * \
                                        from statsrepo.get_memory_tendency($min, $max) \
                                        ) \
                                        to stdout \
                                        with delimiter ' '" > ./benchmark/$date/Server1/Run$count/pg_stats_info/memory_2.txt

# sda2 io usage
# fields: device_name, device_tblspaces, total_read, total_write, total_read_time, total_write_time, io_queue, total_io_time
psql -h 172.26.139.4 -d postgres -c "copy( \
                                        select * \
                                        from statsrepo.get_io_usage($min, $max) \
					where device_name='sda2' \
                                        ) \
                                        to stdout \
                                        with delimiter ' '" > ./benchmark/$date/Server1/Run$count/pg_stats_info/io_sda2_1.txt
# sda2 io tendency report
# fields: timestamp, device_name, read_size_tps, write_size_tps, read_time_tps, write_time_tps
psql -h 172.26.139.4 -d postgres -c "copy( \
                                        select * \
                                        from statsrepo.get_io_usage_tendency_report($min, $max) \
					where device_name='sda2' \
                                        ) \
                                        to stdout \
                                        with delimiter ' '" > ./benchmark/$date/Server1/Run$count/pg_stats_info/io_sda2_2.txt

# sda5 io usage
# fields: device_name, device_tblspaces, total_read, total_write, total_read_time, total_write_time, io_queue, total_io_time

psql -h 172.26.139.4 -d postgres -c "copy( \
                                        select * \
                                        from statsrepo.get_io_usage($min, $max) \
                                        where device_name='sda5' \
                                        ) \
                                        to stdout \
                                        with delimiter ' '" > ./benchmark/$date/Server1/Run$count/pg_stats_info/io_sda5_1.txt
# sda5 io tendency report
# fields: timestamp, device_name, read_size_tps, write_size_tps, read_time_tps, write_time_tps

psql -h 172.26.139.4 -d postgres -c "copy( \
                                        select * \
                                        from statsrepo.get_io_usage_tendency_report($min, $max) \
                                        where device_name='sda5' \
                                        ) \
                                        to stdout \
                                        with delimiter ' '" > ./benchmark/$date/Server1/Run$count/pg_stats_info/io_sda5_2.txt
# Disk activity of tables in tpcc
# fields: datname, nspname, relname, size, table_reads, index_reads, toast_reads

psql -h 172.26.139.4 -d postgres -c "copy( \
                                        select * \
                                        from statsrepo.get_disk_usage_table($min, $max) \
                                        where datname='tpcc' \
                                        ) \
                                        to stdout \
                                        with delimiter ' '" > ./benchmark/$date/Server1/Run$count/pg_stats_info/disk_table_1.txt
# checkpoint activity
# fields: ckpt_total, ckpt_time, ckpt_xlog, avg_write_buff, max_write_buff, avg_duration, max_duration

psql -h 172.26.139.4 -d postgres -c "copy( \
                                        select * \
                                        from statsrepo.get_checkpoint_activity($min, $max) \
                                        ) \
                                        to stdout \
                                        with delimiter ' '" > ./benchmark/$date/Server1/Run$count/pg_stats_info/checkpoint_1.txt


# replication activity
# fields: usename, application_name, client_addr, client_hostname, client_port, backend_start, state, current_location, 
#	  sent_location, write_location, flush_location, replay_location, sync_priority, sync_state

psql -h 172.26.139.4 -d postgres -c "copy( \
                                        select * \
                                        from statsrepo.get_replication_activity($min, $max) \
                                        ) \
                                        to stdout \
                                        with delimiter ' '" > ./benchmark/$date/Server1/Run$count/pg_stats_info/replication_1.txt


# autovacuum-1
# fields: relname, count, avg_index_scans, avg_tup_removed, avg_tup_remain, avg_duration, max_duration

psql -h 172.26.139.4 -d postgres -c "copy( \
					SELECT * \
					FROM \
        					statsrepo.get_autovacuum_activity($min, $max) \
					) \
					to stdout \
                                        with delimiter ' '" > ./benchmark/$date/Server1/Run$count/pg_stats_info/autovacuum1_1.txt

# autovacuum-2
# fields: relname, avg_page_hit, avg_page_miss, avg_page_dirty, avg_read_rate, avg_write_rate

psql -h 172.26.139.4 -d postgres -c "copy( \
					SELECT * \
					FROM \
        					statsrepo.get_autovacuum_activity2($1, $2)
					) \
                                        to stdout \
                                        with delimiter ' '" > ./benchmark/$date/Server1/Run$count/pg_stats_info/autovacuum2_1.txt
