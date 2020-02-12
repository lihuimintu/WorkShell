#!/bin/bash

# Description: MySQL 数据库备份脚本
# Author     : tu
# Contact    : lihuimintu@gmail.com

# 脚本说明:
# 在MYSQL从库上执行全量备份+增量备份方式
# 在从库备份避免Mysql主库备份的时候锁表造成业务影响


# 环境变量
source /etc/profile

# 备份的数据库名
DATABASES=(
  "scm"
  "hive"                    
)

USER="dbUser"
PASSWORD="xxxx"

MAIL="lihuimintu@gmail.com" 
BACKUP_DIR=/data/backup
LOGFILE=/data/backup/data_backup.log 
DATE=`date +%Y%m%d_%H%M`

cd $BACKUP_DIR
# 开始备份之前，将备份信息头写入日记文件   
echo "--------START--------" >> $LOGFILE   
echo "BACKUP DATE:" $(date +"%y-%m-%d %H:%M:%S") >> $LOGFILE   

for DATABASE in ${DATABASES}
do
  mysqldump -u$USER -p$PASSWORD --single-transaction -q $DATABASE | gzip >${BACKUP_DIR}\/${DATABASE}_${DATE}.sql.gz
  if [ $? == 0 ]; then
    echo "$DATE--$DATABASE is backup succeed" >> $LOGFILE
  else
    echo "Database Backup Fail!" >> $LOGFILE
  fi
done

# 判断数据库备份是否全部成功，全部成功就同步到异地备份服务器
# -z表示"--compress"，即传输时对数据进行压缩处理
# -r表示"--recursive"，即对子目录以递归的模式处理
# -t是"--time"，即保持文件时间信息
# -o表示"owner"，用来保持文件属主信息
# -p是"perms”，用来保持文件权限
# -g是"group"，用来保持文件的属组信息
# --delete选项指定以rsync服务器端为基础进行数据镜像同步，也就是要保持rsync服务器端目录与客户端目录的完全一致

if [ $? == 0 ];then
  rsync -zrtopg  --delete  /data/backup/* root@192.168.10.10:/data/backup/  >/dev/null 2>&1
else
  echo "Database Backup Fail!" >> $LOGFILE   
  #备份失败后向管理者发送邮件提醒
  mail -s "database Daily Backup Fail!" $MAIL   
fi

# 删除30天以上的备份文件 
find $BACKUP_DIR  -type f -mtime +30 -name "*.gz" -exec rm -f {} \;

echo "---------END---------" >> $LOGFILE
