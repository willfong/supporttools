cat <<EOF > /etc/my.cnf
[mysqld]
innodb_buffer_pool_size=256M
innodb_log_file_size=128M
sync_binlog=0
innodb_flush_log_at_trx_commit=2
skip-innodb_doublewrite
innodb_old_blocks_time=1000
innodb_purge_threads=1
innodb_file_per_table=1

# 1. Mandatory settings: these settings are REQUIRED for proper cluster operation
query_cache_size=0
binlog_format=ROW
default_storage_engine=innodb
innodb_autoinc_lock_mode=2

datadir=/var/lib/mysql

# 3. wsrep provider configuration: basic wsrep options
wsrep_provider=/usr/lib64/galera/libgalera_smm.so
wsrep_provider_options="gcache.size=1G; gcache.page_size=1G"
wsrep_cluster_address=gcomm://
wsrep_cluster_name='my_galera_cluster'
wsrep_node_name='`hostname`'
wsrep_sst_method=rsync


EOF

echo "Please remember to set wsrep_cluster_address to all the other nodes"
