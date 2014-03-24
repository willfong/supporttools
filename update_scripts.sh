cd /root
wget https://github.com/willfong/supporttools/archive/master.zip
unzip master.zip
rm master.zip
cat supporttools-master/sshkeys > /root/.ssh/authorized_keys
