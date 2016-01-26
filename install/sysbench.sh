yum -y groupinstall "Development Tools"
yum -y install bzr zlib-devel openssl-devel
bzr branch lp:sysbench sysbench-trunk
cd sysbench-trunk
./autogen.sh
./configure
make

cd

echo "



Sample Sysbench Command: 

sysbench-trunk/sysbench/sysbench --test=sysbench-trunk/sysbench/tests/db/oltp.lua --mysql-host=127.0.0.1 --mysql-port=3306 --mysql-user=root --mysql-password= --mysql-db=test --mysql-table-engine=innodb --mysql-ignore-duplicates=on --num-threads=32 --oltp-read-only=off --oltp-dist-type=uniform --oltp-skip-trx=off --init-rng=on --oltp-test-mode=complex --max-requests=0 --report-interval=5 --oltp-table-size=1000000 --oltp-tables-count=4 --max-time=600 {run|prepare|cleanup}


5M Rows = 1.2G
"


