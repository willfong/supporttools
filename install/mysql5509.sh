VERSION=5.5.9

yum -y install libaio
groupadd mysql
useradd -r -g mysql mysql
cd /usr/local
wget http://downloads.mysql.com/archives/get/file/mysql-$VERSION-linux2.6-x86_64.tar.gz
tar xvzf mysql*.tar.gz
ln -s mysql-$VERSION-linux2.6-x86_64 mysql
cd mysql
chown -R mysql .
chgrp -R mysql .
rm -rf /var/lib/mysql
mkdir /var/lib/mysql
scripts/mysql_install_db --user=mysql --datadir=/var/lib/mysql
chown -R root .
chown -R mysql /var/lib/mysql



