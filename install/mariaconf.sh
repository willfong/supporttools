cat <<EOF > /etc/my.cnf
[mysql]
socket=/var/lib/mysql/mysql.sock

[mysqld]
log_error=/var/lib/mysql/mysql.err
datadir=/var/lib/mysql
pid_file=/var/lib/mysql/mysql.pid
socket=/var/lib/mysql/mysql.sock

innodb_buffer_pool_size=1G
innodb_log_file_size=1G
sync_binlog=0
innodb_flush_log_at_trx_commit=2
skip-innodb_doublewrite
innodb_old_blocks_time=1000
innodb_purge_threads=1
innodb_file_per_table=1
performance_schema=off

# slave_parallel_threads=4

# Replication

#server-id=1

#log-bin=binlog
#log-bin-index=binlog.index

#relay-log=relay
#relay-log-index=relay.index

# CREATE USER 'repl'@'%'; GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%';

# CHANGE MASTER TO MASTER_HOST='192.168.0.0', MASTER_USER='repl', MASTER_LOG_FILE='binlog.000001', MASTER_LOG_POS=107;

#plugin_load="rpl_semi_sync_master=semisync_master.so;rpl_semi_sync_slave=semisync_slave.so"
#rpl_semi_sync_master_enabled = ON
#rpl_semi_sync_slave_enabled = ON



EOF
