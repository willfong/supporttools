URL=http://downloads.mariadb.com/files/MariaDB/mariadb-10.1.8/bintar-linux-x86_64/mariadb-10.1.8-linux-x86_64.tar.gz

yum -y install libaio
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
