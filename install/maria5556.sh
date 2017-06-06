wget http://downloads.mariadb.com/MariaDB/mariadb-5.5.56/yum/centos6-amd64/rpms/MariaDB-5.5.56-centos6-x86_64-client.rpm
wget http://downloads.mariadb.com/MariaDB/mariadb-5.5.56/yum/centos6-amd64/rpms/MariaDB-5.5.56-centos6-x86_64-common.rpm
wget http://downloads.mariadb.com/MariaDB/mariadb-5.5.56/yum/centos6-amd64/rpms/MariaDB-5.5.56-centos6-x86_64-compat.rpm
wget http://downloads.mariadb.com/MariaDB/mariadb-5.5.56/yum/centos6-amd64/rpms/MariaDB-5.5.56-centos6-x86_64-server.rpm
wget http://downloads.mariadb.com/MariaDB/mariadb-5.5.56/yum/centos6-amd64/rpms/MariaDB-5.5.56-centos6-x86_64-shared.rpm
wget http://downloads.mariadb.com/MariaDB/mariadb-5.5.56/yum/centos6-amd64/rpms/MariaDB-5.5.56-centos6-x86_64-devel.rpm
yum -y install perl-DBI libaio
rpm -Uvh *.rpm
rm -rf *.rpm
