#!/bin/bash

if [ -z $1 ]
then
    echo "Need to specify sleep interval."
    echo "Usage: replication.sh <seconds>"
    exit
else
    SLEEP=$1
fi

echo "delete_total,delete_rate,insert_total,insert_rate,update_total,update_rate,seconds_behind_master"

# TODO: First run loop, kinda ugly
OUT=`mysql -e 'SHOW GLOBAL STATUS; SHOW SLAVE STATUS' | grep 'Com_insert\W\|Com_update\W\|Com_delete\W\|Seconds_Behind_Master'`
xDEL=`echo $OUT|cut -d " " -f 2`
xINS=`echo $OUT|cut -d " " -f 4`
xUPD=`echo $OUT|cut -d " " -f 6`

sleep $SLEEP


while true
do
    OUT=`mysql -e 'SHOW GLOBAL STATUS; SHOW SLAVE STATUS\G' | grep 'Com_insert\W\|Com_update\W\|Com_delete\W\|Seconds_Behind_Master'`

    # TODO: Isn't there a better way to do this??? 
    DEL=`echo $OUT|cut -d " " -f 2`
    INS=`echo $OUT|cut -d " " -f 4`
    UPD=`echo $OUT|cut -d " " -f 6`
    SBM=`echo $OUT|cut -d " " -f 8`

    rDEL=$(((DEL-xDEL)/SLEEP))
    rINS=$(((INS-xINS)/SLEEP))
    rUPD=$(((UPD-xUPD)/SLEEP))

    echo "$DEL,$rDEL,$INS,$rINS,$UPD,$rUPD,$SBM"

    xDEL=$DEL
    xINS=$INS
    xUPD=$UPD

    sleep $SLEEP
done
