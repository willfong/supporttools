cat <<EOF > /etc/my.cnf.d/server.cnf
[mysqld]
log_error=/var/lib/mysql/mysql.err

innodb_buffer_pool_size=256M
innodb_log_file_size=256M
sync_binlog=0
innodb_flush_log_at_trx_commit=2
skip-innodb_doublewrite
innodb_old_blocks_time=1000
innodb_purge_threads=1
innodb_file_per_table=1
performance_schema=off

# Replication

#server-id=1

#log-bin=binlog
#log-bin-index=binlog.index

#relay-log=relay
#relay-log-index=relay.index

# CREATE USER 'repl'@'%';
# GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%';

# CHANGE MASTER TO MASTER_HOST='192.168.0.0', MASTER_USER='repl', MASTER_LOG_FILE='binlog.000001', MASTER_LOG_POS=107;

EOF
