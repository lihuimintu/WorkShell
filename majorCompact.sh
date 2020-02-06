#!/bin/bash

#########################################################
# Function :HBase 手动触发 Major Compaction 脚本          #
# Platform :HBase                                       #
# Version  :1.0                                         #
# Date     :2019-06-09                                  #
# Author   :tu                                          #
# Contact  :lihuimintu@gmail.com                        #
#########################################################

time_start=`date "+%Y-%m-%d %H:%M:%S"`
echo "开始进行HBase的大合并.时间:${time_start}"
  
str=`echo list | hbase shell | sed -n '$p'`
 
str=${str//,/ }
arr=($str)
length=${#arr[@]}
current=1
 
echo "HBase中总共有${length}张表需要合并."
echo "balance_switch false" | hbase shell | > /dev/null
echo "HBase的负载均衡已经关闭"
  
for each in ${arr[*]}
do
        table=`echo $each | sed 's/]//g' | sed 's/\[//g'`
        echo "开始合并第${current}/${length}张表,表的名称为:${table}"
        echo "major_compact ${table}" | hbase shell | > /dev/null
        let current=current+1
done
  
echo "balance_switch true" | hbase shell | > /dev/null
echo "HBase的负载均衡已经打开."
  
time_end=`date "+%Y-%m-%d %H:%M:%S"`
echo "HBase的大合并完成.时间:${time_end}"
duration=$($(date +%s -d "$finish_time")-$(date +%s -d "$start_time"))
echo "耗时:${duration}s"
