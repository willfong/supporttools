wget http://archive.mariadb.org/mariadb-5.5.24/centos6-amd64/rpms/MariaDB-5.5.24-centos6-x86_64-client.rpm
wget http://archive.mariadb.org/mariadb-5.5.24/centos6-amd64/rpms/MariaDB-5.5.24-centos6-x86_64-common.rpm
wget http://archive.mariadb.org/mariadb-5.5.24/centos6-amd64/rpms/MariaDB-5.5.24-centos6-x86_64-compat.rpm
wget http://archive.mariadb.org/mariadb-5.5.24/centos6-amd64/rpms/MariaDB-5.5.24-centos6-x86_64-server.rpm
wget http://archive.mariadb.org/mariadb-5.5.24/centos6-amd64/rpms/MariaDB-5.5.24-centos6-x86_64-shared.rpm
yum -y install perl-DBI
rpm -Uvh *.rpm
rm -rf *.rpm
/root/supporttools-master/mariaconf.sh
