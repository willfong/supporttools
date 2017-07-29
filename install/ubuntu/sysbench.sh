apt-get install -y git libmysqlclient-dev automake libtool make pkg-config
git clone https://github.com/akopytov/sysbench.git
cd sysbench
./autogen.sh
./configure
make

cd

echo "


Sample Sysbench Command:

sysbench/sysbench/sysbench --test=sysbench/sysbench/tests/db/oltp.lua --mysql-user=root --mysql-password= --mysql-db=test --mysql-table-engine=innodb --mysql-ignore-duplicates=on --oltp-read-only=off --oltp-dist-type=uniform --oltp-skip-trx=off --init-rng=on --oltp-test-mode=complex --max-requests=0 --report-interval=30 --num-threads=8 --mysql-host=127.0.0.1 --mysql-port=3306 --oltp-table-size=1000000 --oltp-tables-count=4 --max-time=600 {run|prepare|cleanup}

5M Rows = 1.2G
"

