cd ~
wget --no-check-certificate -O master.zip https://github.com/willfong/supporttools/archive/master.zip
unzip -o master.zip
rm -f master.zip
mkdir -p .ssh
cat supporttools-master/sshkeys > .ssh/authorized_keys
