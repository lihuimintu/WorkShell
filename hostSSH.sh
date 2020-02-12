#!/bin/bash

# Description: 批量机器互相免密从脚本
# Author     : tu
# Contact    : lihuimintu@gmail.com

masterHost="192.168.1.xx"
username="user"
password="xxxx"

auto_ssh_keygen() {
  echo "生成密钥"
  /usr/bin/expect <<-EOF
  set timeout 30
  spawn ssh-keygen
  expect {
    "Enter file in which to save the key (/root/.ssh/id_rsa):" { send "\r"; exp_continue}
    "Overwrite (y/n)?" { send "n\r" }
    "Enter passphrase (empty for no passphrase):" { send "\r"; exp_continue}
    "Enter same passphrase again:" { send "\r"}
  }
  expect eof
  EOF
  echo ""
}

auto_ssh_copy_id(){
  /usr/bin/expect <<-EOF
  set timeout -1
  spawn ssh-copy-id $1@$2
  expect {
    "*yes/no" { send "yes\r"; exp_continue }
    "*password:" { send "$3\r" }
  }
  expect eof
  EOF
}

yum -y install expect
auto_ssh_keygen
auto_ssh_copy_id $username $masterHost $password
