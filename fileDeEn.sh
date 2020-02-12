#!/bin/bash

# Description: 万能解压和压缩脚本                            
# Author     : tu                                          
# Contact    : lihuimintu@gmail.com                        

# 脚本说明
# 压缩案例: sh ext.sh en a.zip a 压缩类型 压缩后的文件名 要压缩的文件或者目录
# 解压案例: sh ext.sh de a.zip 压缩类型 解压的文件名 （默认当前目录）

# 压缩类型，en表示压缩，de表示解压
type=$1 
# 文件名
filename=$2 
# 如果是压缩则是选择压缩的文件，解压则是输出的文件路径
to_filename=$3 
# 获取到文件名的后缀
ext="${filename##*.}" 

if [[ ! $filename ]]
then
  # 没有传入参数
  echo 'error(100)not file(tar|gz|bz2|zip|rar)'
  exit 0
fi

if [[ "$to_filename" == "" ]]; then
  to_filename="."
fi


if [[ $type = 'en' ]]; then
  # 压缩至
  # 匹配相应的文件
  case $ext in
    'tar') eval "tar -cvf $filename $to_filename" ;;
    'gz') eval "tar -zcvf $filename $to_filename" ;;
    'bz2') eval "tar -jcvf $filename $to_filename" ;;
    'zip') eval "zip $filename $to_filename" ;;
     *)  echo 'error(101)This type is not supported(tar|gz|bz2|zip)' ;;
  esac
else
   #解压至
   #匹配相应的文件
  case $ext in
    'tar') eval "tar -xvf $filename -C $to_filename" ;;
    'gz') eval "tar -zxvf $filename -C $to_filename" ;;
    'bz2') eval "tar -jxvf $filename -C $to_filename" ;;
    'zip') eval "unzip -d $to_filename $filename " ;;
    *) echo 'error(101)This type is not supported(tar|gz|bz2|zip)' ;;
  esac
fi

