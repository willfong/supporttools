cat <<EOF > /etc/yum.repos.d/MariaDB.repo
# MariaDB 5.5 Fedora repository list - created 2013-12-05 02:11 UTC
# http://mariadb.org/mariadb/repositories/
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/5.5/fedora19-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1

EOF
