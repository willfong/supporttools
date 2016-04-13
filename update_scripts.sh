cd /root
wget --no-check-certificate -O master.zip https://github.com/willfong/supporttools/archive/master.zip
unzip -o master.zip
rm -f master.zip
mkdir -p .ssh
cat supporttools-master/sshkeys > /root/.ssh/authorized_keys
