URL=http://downloads.mariadb.com/files/MariaDB/mariadb-10.0.22/bintar-linux-x86_64/mariadb-10.0.22-linux-x86_64.tar.gz

yum -y install libaio
rpm -Uvh http://downloads.mariadb.com/files/MariaDB/mariadb-10.1.8/yum/centos6-amd64/rpms/jemalloc-3.6.0-1.el6.x86_64.rpm
groupadd mysql
useradd -r -g mysql mysql
cd /usr/local
wget $URL
tar xvzf m*.tar.gz
ls -d m*/ | xargs -I dirname ln -s dirname mysql
cd mysql
chown -R mysql .
chgrp -R mysql .
rm -rf /var/lib/mysql
mkdir /var/lib/mysql
scripts/mysql_install_db --user=mysql --datadir=/var/lib/mysql
chown -R root .
chown -R mysql /var/lib/mysql

echo "
Start with /usr/local/mysql/bin/mysqld_safe --user=mysql &
"
