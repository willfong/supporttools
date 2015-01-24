cat <<EOF > /etc/yum.repos.d/MariaDB10.repo
# MariaDB 10.0 CentOS repository list - created 2014-03-24 03:15 UTC
# http://mariadb.org/mariadb/repositories/
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.0/centos6-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
EOF

