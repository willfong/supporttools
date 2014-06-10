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

sysbench-trunk/sysbench/sysbench --test=sysbench-trunk/sysbench/tests/db/oltp.lua --mysql-user=root --mysql-db=test --mysql-table-engine=innodb --mysql-ignore-duplicates=on --num-threads=4 --oltp-table-size=20000000 --oltp-read-only=off --oltp-test-mode=complex --max-requests=0 --report-interval=5 --max-time=600 {prepare|run}"
