wget http://`cat /webserver.txt`/mysql5531.el6.x86_64.tar
tar xf mysql5531.el6.x86_64.tar
rpm -Uvh *.rpm
rm mysql5531.el6.x86_64.tar
rm -rf *.rpm
service mysql start
