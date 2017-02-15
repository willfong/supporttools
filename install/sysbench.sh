yum -y install mysql-devel git automake libtool zlib-devel openssl-devel
git clone https://github.com/akopytov/sysbench.git
cd sysbench
./autogen.sh
./configure
make
make install

cd

echo "


Sample Sysbench Command:

sysbench /usr/local/share/sysbench/oltp_read_write.lua --mysql-user=root --mysql-password= --mysql-db=test --max-requests=0 --report-interval=30 --threads=8 --mysql-host=127.0.0.1 --mysql-port=3306 --table-size=5000000 --tables=1 --time=600

5M Rows = 1.2G
"

