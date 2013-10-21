#!/bin/bash

date=$1
count=$2
(
	#--------------Retrieve resultant stats from pg_statsinfo. ---------------------------------------------------
	#---It retrives data for the snapshots that were taken within the measurement interval of the benchmark-------
		

                startts=`cat ./benchmark/$date/Master/run$count/jdbcRunnerLogs/jdbcrunner.log | grep " 1 sec" | awk '{print $1, $2}'`
                endts=`cat ./benchmark/$date/Master/run$count/jdbcRunnerLogs/jdbcrunner.log | grep "Total tx count" | awk '{print $1, $2}'`

                snapids=`psql -h $MASTER_IP -d postgres -c "copy( \
                                        select \
                                                min(sn.snapid), \
                                                max(sn.snapid) \
                                        from statsrepo.snapshot sn\
                                        where \
                                                to_char(sn.time::timestamp, 'YYYY-MM-DD HH24:MI:SS')::timestamp between '$startts'::timestamp  and '$endts'::timestamp
                                        ) \
                                        to stdout \
                                        with delimiter ' '"`

                min=`echo $snapids | awk '{print $1}'`
                max=`echo $snapids | awk '{print $2}'`

		ssh -n  $USER_NAME@$MASTER_IP "/usr/pgsql-9.2/bin/pg_statsinfo -b $min -e $max -h localhost -d postgres -p 5432 -U sachin -r All " > ./benchmark/$date/Master/run$count/pgStatsInfo/pg_stats_info_report.txt

                psql -h $MASTER_IP -d postgres -c "copy( \
                                        select \
                                                to_char(sn.time::timestamp,'YYYY-MM-DD HH24:MI:SS')::timestamp, \
                                                x.* \
                                        from statsrepo.snapshot sn, statsrepo.database x \
                                        where \
                            			to_char(sn.time::timestamp, 'YYYY-MM-DD HH24:MI:SS')::timestamp between '$startts'::timestamp  and '$endts'::timestamp and x.snapid=sn.snapid and x.name='tpcc' \

                                        ) \
                                        to stdout \
                                        with delimiter ' '" > ./benchmark/$date/Master/run$count/pgStatsInfo/db_stats_2.txt



		psql -h $MASTER_IP -d postgres -c "select \
                                                cp.instid, \
                                                to_char(cp.start::timestamp - interval '3 hour' - interval '30 minute','YYYY-MM-DD HH24:MI:SS')::timestamp as start, \
						instid,flags,num_buffers,xlog_added,xlog_removed,xlog_recycled,write_duration,sync_duration,total_duration \
                                        from statsrepo.checkpoint cp\
                                        where \
                                                to_char(cp.start::timestamp,'YYYY-MM-DD HH24:MI:SS')::timestamp between \
                                                to_char('$startts'::timestamp,'YYYY-MM-DD HH24:MI:SS')::timestamp  + interval '3 hour' + interval '10 minute' and \
                                                to_char('$endts'::timestamp,'YYYY-MM-DD HH24:MI:SS')::timestamp + interval '3 hour' + interval '29 minute' \
                                        "> ./benchmark/$date/Master/run$count/pgStatsInfo/checkpoint_1.csv


		psql -h $MASTER_IP -d postgres -c "copy( \
					select \
                                                cp.instid, \
                                                to_char(cp.start::timestamp - interval '3 hour' - interval '30 minute','YYYY-MM-DD HH24:MI:SS')::timestamp as start, \
                                                instid,flags,num_buffers,xlog_added,xlog_removed,xlog_recycled,write_duration,sync_duration,total_duration \
                                        from statsrepo.checkpoint cp\
					where \
                                                to_char(cp.start::timestamp,'YYYY-MM-DD HH24:MI:SS')::timestamp between \
                                                to_char('$startts'::timestamp,'YYYY-MM-DD HH24:MI:SS')::timestamp  + interval '3 hour' + interval '10 minute' and \
                                                to_char('$endts'::timestamp,'YYYY-MM-DD HH24:MI:SS')::timestamp + interval '6 hour' + interval '29 minute' \
					) \
                                        to stdout \
                                        with delimiter ' '"> ./benchmark/$date/Master/run$count/pgStatsInfo/checkpoint_2.csv



		psql -h $MASTER_IP -d postgres -c "select \
                                                av.instid, \
                                                to_char(av.start::timestamp - interval '3 hour' - interval '30 minute','YYYY-MM-DD HH24:MI:SS')::timestamp as start, \
                                                av.database, \
                                                av.schema, \
                                                av.table, \
                                                av.index_scans, \
                                                av.page_removed, \
                                                av.page_remain, \
                                                av.tup_removed, \
                                                av.tup_remain, \
                                                av.page_hit, \
                                                av.page_miss, \
                                                av.page_dirty, \
                                                av.read_rate, \
                                                av.write_rate, \
                                                av.duration \
                                        from statsrepo.autovacuum av \
                                        where \
                                                database='tpcc' and \
                                                to_char(av.start::timestamp,'YYYY-MM-DD HH24:MI:SS')::timestamp between \
                                                to_char('$startts'::timestamp,'YYYY-MM-DD HH24:MI:SS')::timestamp  + interval '3 hour' + interval '10 minute' and \
                                                to_char('$endts'::timestamp,'YYYY-MM-DD HH24:MI:SS')::timestamp + interval '3 hour' + interval '40 minute' \
                                        "> ./benchmark/$date/Master/run$count/pgStatsInfo/db_autovacuum_1.csv                                                                                                     


# Database stats for tpcc
#Fields: datname, size, size_incr, xact_commit_tps, xact_rollback_tps, blks_hit_rate, blks_hit_tps, blks_read_tps, 
#	 tup_fetch_tps, temp_files, temp_bytes, deadlocks, blk_read_time, blk_write_time
psql -h $MASTER_IP -d postgres -c "select * \
					from statsrepo.get_dbstats($min, $max) \
					where datname='tpcc' \
					" > ./benchmark/$date/Master/run$count/pgStatsInfo/db_stats_1.txt

#Transaction tendency report for tpcc
#Fields: timestamp, datname, commit_tps, rollback_tps

psql -h $MASTER_IP -d postgres -c "select * \
                                        from statsrepo.get_xact_tendency_report($min, $max) \
					where datname='tpcc' \
					" > ./benchmark/$date/Master/run$count/pgStatsInfo/db_xact_1.txt

# Fields: idle, idle_in_xact, waiting, running

psql -h $MASTER_IP -d postgres -c "select * \
                                        from statsrepo.get_proc_ratio($min, $max) \
                                        " > ./benchmark/$date/Master/run$count/pgStatsInfo/processes_ratio_1.txt
# Processes usage tendency report
# fields: timestamp, idle, idle_in_xact, waiting, running

psql -h $MASTER_IP -d postgres -c "copy( \
                                        select * \
                                        from statsrepo.get_proc_tendency_report($min, $max) \
                                        ) \
                                        to stdout \
                                        with delimiter ' '" > ./benchmark/$date/Master/run$count/pgStatsInfo/processes_ratio_2.txt

# xlog stats
# Fields: write_total, write_speed

psql -h $MASTER_IP -d postgres -c "select * \
                                        from statsrepo.get_xlog_stats($min, $max) \
                                        " > ./benchmark/$date/Master/run$count/pgStatsInfo/xlog_1.txt
# xlog tendency report
# fields: timestamp, location, xlogfile, write_size, write_size_per_sec

psql -h $MASTER_IP -d postgres -c "copy( \
                                        select * \
                                        from statsrepo.get_xlog_tendency($min, $max) \
                                        ) \
                                        to stdout \
                                        with delimiter ' '" > ./benchmark/$date/Master/run$count/pgStatsInfo/xlog_2.txt


# sda2 io usage
# fields: device_name, device_tblspaces, total_read, total_write, total_read_time, total_write_time, io_queue, total_io_time
psql -h $MASTER_IP -d postgres -c "select * \
                                        from statsrepo.get_io_usage($min, $max) \
					where device_name='sda2' \
                                        " > ./benchmark/$date/Master/run$count/pgStatsInfo/device_pg_default_1.txt

# sda5 io usage
# fields: device_name, device_tblspaces, total_read, total_write, total_read_time, total_write_time, io_queue, total_io_time

psql -h $MASTER_IP -d postgres -c "select * \
                                        from statsrepo.get_io_usage($min, $max) \
                                        where device_name='sda5' \
                                        " > ./benchmark/$date/Master/run$count/pgStatsInfo/device_pg_xlog_1.txt



# Disk activity of tables in tpcc
# fields: datname, nspname, relname, size, table_reads, index_reads, toast_reads

psql -h $MASTER_IP -d postgres -c "select * \
                                        from statsrepo.get_disk_usage_table($min, $max) \
                                        where datname='tpcc' \
                                        " > ./benchmark/$date/Master/run$count/pgStatsInfo/db_disk_table_1.txt

psql -h $MASTER_IP -d postgres -c "copy( \
					select * \
                                        from statsrepo.get_disk_usage_table($min, $max) \
                                        where datname='tpcc' \
                                        ) \
                                        to stdout \
                                        with delimiter ' '" > ./benchmark/$date/Master/run$count/pgStatsInfo/db_disk_table_2.txt



# replication activity
# fields: usename, application_name, client_addr, client_hostname, client_port, backend_start, state, current_location, 
#	  sent_location, write_location, flush_location, replay_location, sync_priority, sync_state

psql -h $MASTER_IP -d postgres -c "select * \
                                        from statsrepo.get_replication_activity($min, $max) \
                                        " > ./benchmark/$date/Master/run$count/pgStatsInfo/replication_1.txt


# instid | start   | database | schema  |  table   | duration 
psql -h $MASTER_IP -d postgres -c "select to_char(at.start::timestamp - interval '3 hour' - interval '30 minute','YYYY-MM-DD HH24:MI:SS')::timestamp as start, \
					at.instid,at.database,at.schema,at.table,at.duration \
                                        from statsrepo.autoanalyze at where at.database='tpcc' \
                                        " > ./benchmark/$date/Master/run$count/pgStatsInfo/db_autoanalyze_1.txt


#instid |  name | hostname | port | pg_version
psql -h $MASTER_IP -d postgres -c "select * \
                                        from statsrepo.instance \
                                        " > ./benchmark/$date/Master/run$count/pgStatsInfo/instance_1.txt
#snapid |  name    |   setting    |  source       
psql -h $MASTER_IP -d postgres -c "select * \
                                        from statsrepo.setting where snapid between $min and $max  \
                                        " > ./benchmark/$date/Master/run$count/pgStatsInfo/setting_1.txt


#snapid | instid |  time  | comment |  exec_time   | snapshot_increase_size
psql -h $MASTER_IP -d postgres -c "select \
                                                min(sn.snapid), \
                                                max(sn.snapid) \
                                        from statsrepo.snapshot sn\
                                        where \
                                                to_char(sn.time::timestamp, 'YYYY-MM-DD HH24:MI:SS')::timestamp between '$startts'::timestamp  and '$endts'::timestamp
                                 	" > ./benchmark/$date/Master/run$count/pgStatsInfo/snapshot_1.txt
) 2> error.log
