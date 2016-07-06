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

EOF

echo "

MaxScale configured to listen on port 4306

Make sure to add the MaxScale users!
"

