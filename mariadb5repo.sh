cat <<EOF > /etc/yum.repos.d/MariaDB5.repo
# MariaDB 5.5 CentOS repository list - created 2014-03-24 03:14 UTC
# http://mariadb.org/mariadb/repositories/
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/5.5/centos6-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1

EOF

