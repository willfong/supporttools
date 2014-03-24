wget http://`cat /webserver.txt`/mysql5611.el6.x86_64.tar
tar xf mysql5611.el6.x86_64.tar
rpm -Uvh *.rpm
rm mysql5611.el6.x86_64.tar
rm -rf *.rpm
service mysql start
./reset_mysql_password.sh
