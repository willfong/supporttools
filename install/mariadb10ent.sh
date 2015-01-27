cat <<EOF > /etc/yum.repos.d/MariaDB10.repo
[mariadb]
name = MariaDB
baseurl = https://portaluser:testing@code.mariadb.com/mariadb-enterprise/10.0/yum/rhel6-amd64
gpgkey= https://downloads.mariadb.com/files/MariaDB/RPM-GPG-KEY-MariaDB-Ent
gpgcheck=1
EOF
echo "Install socat for Galera first"
echo "yum install MariaDB-Galera-server MariaDB-client"
