yum -y install http://downloads.mariadb.com/enterprise/he05-e19h/mariadb-maxscale/1.4.3/rhel/6/x86_64/maxscale-1.4.3-1.rhel.6.x86_64.rpm 

maxkeys /var/lib/maxscale/
MAXSCALEPASSWORD=$(maxpasswd /var/lib/maxscale/ password | head -n1)

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
passwd=C1793512F3F7570A5CCBA7B04DF151BD
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
passwd=C1793512F3F7570A5CCBA7B04DF151BD

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

MaxScale configured to listen on port 4306

Make sure to add the MaxScale users, listed in maxscaleusers.sh
Make sure the 'maxscale' user can log in, might need to remove anonymous users

"

