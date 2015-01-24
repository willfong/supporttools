cat <<EOF > /etc/yum.repos.d/MariaDB10.repo
# MariaDB 10.0 CentOS repository list - created 2014-03-24 03:15 UTC
# http://mariadb.org/mariadb/repositories/
[mariadb]
name = MariaDB
baseurl = https://portaluser:testing@code.mariadb.com/mariadb-enterprise/10.0/yum/rhel6-amd64
gpgkey= https://downloads.mariadb.com/files/MariaDB/RPM-GPG-KEY-MariaDB-Ent
gpgcheck=1
EOF

