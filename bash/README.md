# Bash Scripts

Just my collection of bash scripts...

----

### activity.sh

`Usage: ./activity.sh <sleep>`

Outputs activity of SELECT, INSERT, UPDATE, DELETE statements on a local MariaDB/MySQL instance into CSV format. 

Sample output:
<pre>
select_total,select_rate,insert_total,insert_rate,update_total,update_rate,delete_total,delete_rate
7050422,4947,504993,353,1007056,706,503502,353
7198467,4934,515563,352,1028202,704,514072,352
7343760,4843,525941,345,1048953,691,524450,345
</pre>

## bench_threads.sh

`Usage: ./bench_threads.sh <tables> <rows> <runtime>`

This is a simple wrapper script for sysbench that shows results for various thread counts.


### replication.sh

`Usage: ./replication.sh <sleep>`

Monitors DML activity on a slave into CSV output.


### sysbench.sh

`Usage: ./sysbench.sh <tables> <rows> <warmup> <runtime> [header (optional)]`

Wrapper script for my usual sysbench command. Outputs to a file for graphing.


### write_perf.sh

`Usage: ./write_perf.sh <datadir> <sleep>`

Watches over *.ibd files in `<datadir>` for `<sleep>` seconds, and gives the rate it grows by.


