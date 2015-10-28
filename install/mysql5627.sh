URL=http://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.27-linux-glibc2.5-x86_64.tar.gz

yum -y install libaio
groupadd mysql
useradd -r -g mysql mysql
cd /usr/local
wget $URL
tar xvzf mysql*.tar.gz
ls -d mysql*/ | xargs -I dirname ln -s dirname mysql
cd mysql
chown -R mysql .
chgrp -R mysql .
rm -rf /var/lib/mysql
mkdir /var/lib/mysql
scripts/mysql_install_db --user=mysql --datadir=/var/lib/mysql
chown -R root .
chown -R mysql /var/lib/mysql

echo "
You probably want to run: mysqlconf.sh
Start with /usr/local/mysql/bin/mysqld_safe --user=mysql &"
"
