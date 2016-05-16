#!/bin/bash

if [ -z $1 ]
then
    echo "Need to specify sleep interval."
    echo "Usage: $0 <seconds>"
    exit
else
    SLEEP=$1
fi

echo "select_total,select_rate,insert_total,insert_rate,update_total,update_rate,delete_total,delete_rate"

OUT=`mysql -e 'SHOW GLOBAL STATUS' | grep 'Com_select\W\|Com_insert\W\|Com_update\W\|Com_delete\W'`
xDEL=`echo $OUT|cut -d " " -f 2`
xINS=`echo $OUT|cut -d " " -f 4`
xSEL=`echo $OUT|cut -d " " -f 6`
xUPD=`echo $OUT|cut -d " " -f 8`

sleep $SLEEP

while true
do
    OUT=`mysql -e 'SHOW GLOBAL STATUS' | grep 'Com_select\W\|Com_insert\W\|Com_update\W\|Com_delete\W'`

    DEL=`echo $OUT|cut -d " " -f 2`
    INS=`echo $OUT|cut -d " " -f 4`
    SEL=`echo $OUT|cut -d " " -f 6`
    UPD=`echo $OUT|cut -d " " -f 8`

    rDEL=$(((DEL-xDEL)/SLEEP))
    rINS=$(((INS-xINS)/SLEEP))
    rSEL=$(((SEL-xSEL)/SLEEP))
    rUPD=$(((UPD-xUPD)/SLEEP))

    echo "$SEL,$rSEL,$INS,$rINS,$UPD,$rUPD,$DEL,$rDEL"

    xDEL=$DEL
    xINS=$INS
    xSEL=$SEL
    xUPD=$UPD

    sleep $SLEEP
done
