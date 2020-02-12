#!/bin/bash

# Description: MySQL 主从监控邮件报警
# Author     : tu
# Contact    : lihuimintu@gmail.com

# 脚本说明:
# 根据端口监控下 MySQL 是否正常运行
# Slave 机器的 IO 和 SQL 状态都必须为YES，缺一不可

USER="dbUser"
PASSWORD="xxxx"

MYSQLPORT='netstat -na|grep "LISTEN"|grep "3306"|awk -F［:" "］+ '{print $4}''
MYSQLIP='ifconfig eth0|grep "inet addr" | awk -F［:" "］+ '{print $4}''
STATUS=$(mysql -u$USER -p$PASSWORD -e "show slave status＼G" | grep -i "running")
IO_env='echo $STATUS | grep IO | awk '{print $2}''
SQL_env='echo $STATUS | grep SQL | awk '{print $2}''

if [[ "$MYSQLPORT" == "3306" ]]
then
　echo "mysql is running"
else
　mail -s "warn!server: $MYSQLIP mysql is down" lihuimintu@gmail.com
fi


if [[ "$IO_env" == "Yes" && "$SQL_env" == "Yes" ]]; then
　echo "Slave is running!"
else
　echo "####### $date #########">> /data/log/check_mysql_slave.log
　echo "Slave is not running!" >> /data/log/check_mysql_slave.log
　mail -s "warn! $MySQLIP_replicate_error" magedu@gmail.com << /data/log/check_mysql_slave.log
fi

