
maxkeys /var/lib/maxscale/
MAXSCALEPASSWORD=$(maxpasswd /var/lib/maxscale/ password | head -n1)
chown maxscale /var/lib/maxscale/

cat <<EOF > /etc/maxscale.cnf
[maxscale]
threads=1

[Service]
type=service
router=readconnroute
router_options=running
servers=db
user=maxscale
passwd=$MAXSCALEPASSWORD
enable_root_user=true

[Listener]
type=listener
service=Service
protocol=MySQLClient
port=4306

[db]
type=server
address=127.0.0.1
port=3307
protocol=MySQLBackend

[CLI]
type=service
router=cli

[CLI Listener]
type=listener
service=CLI
protocol=maxscaled
address=localhost
port=6603


[rwsplit]
type=service
router=readwritesplit
servers=node1,node2,node3
user=maxscale
passwd=$MAXSCALEPASSWORD
enable_root_user=true

[rwsplitlistener]
type=listener
service=rwsplit
protocol=MySQLClient
port=4307

[Replication Monitor]
type=monitor
module=mysqlmon
servers=node1,node2,node3
user=maxscale
passwd=$MAXSCALEPASSWORD
#detect_stale_master=true

[node1]
type=server
address=127.0.0.1
port=3307
protocol=MySQLBackend

[node2]
type=server
address=127.0.0.1
port=3308
protocol=MySQLBackend

[node3]
type=server
address=127.0.0.1
port=3309
protocol=MySQLBackend


EOF

echo "

Users that need to be created for MaxScale:

CREATE USER 'maxscale'@'%' IDENTIFIED BY 'password';
GRANT SELECT ON mysql.user TO 'maxscale'@'%';
GRANT SELECT ON mysql.tables_priv TO 'maxscale'@'%';
GRANT SELECT ON mysql.db TO 'maxscale'@'%';
GRANT SHOW DATABASES ON *.* TO 'maxscale'@'%';
GRANT REPLICATION CLIENT ON *.* TO 'maxscale'@'%';
GRANT REPLICATION SLAVE ON *.* TO 'maxscale'@'%';

"
