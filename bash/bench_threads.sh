#!/bin/bash

# Core Sysbench command
SYSB="sysbench/sysbench/sysbench --test=sysbench/sysbench/tests/db/oltp.lua --mysql-host=127.0.0.1 --mysql-port=3306 --mysql-user=root --mysql-password= --mysql-db=test --mysql-table-engine=innodb --mysql-ignore-duplicates=on --oltp-read-only=on --oltp-dist-type=uniform --oltp-skip-trx=off --init-rng=on --oltp-test-mode=complex --max-requests=0"

function starttest {
  echo -n "$THREADS,"
  # TODO: clean up this grep
  $SYSB --num-threads=$THREADS --oltp-tables-count=$TABLES --oltp-table-size=$ROWS --max-time=$RUNTIME run | grep -e 'transactions:\|read/write requests:\|95 percentile:' | sed 's/.*(\(.*\))/\1/' | tr -s ' ' | paste -s -d, | sed 's/ per sec.\| approx. 95 percentile: \|ms//g'
}

function show_help {
  echo "Usage: $0 <tables> <rows> <runtime>"
}

if [ $# -ne 3  ]; then
  show_help
  exit 1
else
  TABLES=$1
  ROWS=$2
  RUNTIME=$3
fi

THREADS=1

echo "threads,transactions,readwrite,response"
while [ $THREADS -le 1024 ]; do
  starttest
  THREADS=$(($THREADS*2))
done

