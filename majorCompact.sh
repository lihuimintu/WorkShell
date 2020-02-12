#!/bin/bash

# Description: HBase 手动触发 Major Compaction 脚本         
# Author     : tu                                          
# Contact    : lihuimintu@gmail.com                        


LOGFILE=/var/log/hbase/majorComapct.log
timeStart=`date "+%Y-%m-%d %H:%M:%S"`

echo "--------START--------" >> $LOGFILE   
echo "Begion HBase majorComapct time: ${timeStart}" >> $LOGFILE
  
str=`echo list | hbase shell | sed -n '$p'`

str=${str//,/ }
arr=($str)
length=${#arr[@]}
current=1
 

echo "HThere are ${length} tables in HBase that need to be merged" >> $LOGFILE
echo "balance_switch false" | hbase shell | > /dev/null
echo "HBase balance_switch false"  >> $LOGFILE

for each in ${arr[*]}
do
        table=`echo $each | sed 's/]//g' | sed 's/\[//g'`
        echo "Start merging the ${current}/${length} table, tableName:${table}" >> $LOGFILE
        echo "major_compact ${table}" | hbase shell | > /dev/null
        let current=current+1
done
  
echo "balance_switch true" | hbase shell | > /dev/null
echo "HBase balance_switch true" >> $LOGFILE
  
timeEnd=`date "+%Y-%m-%d %H:%M:%S"`
echo "Complete HBase majorComapct time: ${timeEnd}" >> $LOGFILE
duration=$($(date +%s -d "$finish_time")-$(date +%s -d "$start_time"))
echo "Time consuming: ${duration}s" >> $LOGFILE
echo "---------END---------" >> $LOGFILE

