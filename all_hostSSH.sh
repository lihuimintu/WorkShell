#!/bin/bash

# Description: 批量机器互相免密主脚本
# Author     : tu
# Contact    : lihuimintu@gmail.com

hosts=(10.0.0.122 10.0.0.123)
username="user"
password="xxxx"

auto_scp_host(){
  /usr/bin/expect <<-EOF
  set timeout -1
  spawn scp hostSSH.sh $1@$2:~
  expect {
    "*yes/no" { send "yes\r"; exp_continue }
    "*password:" { send "$3\r" }
  }
  expect eof
  EOF
}

auto_ssh_host(){
  /usr/bin/expect <<-EOF
  set timeout -1
  spawn ssh $1@$2 "bash hostSSH.sh"
  expect {
    "*yes/no" { send "yes\r"; exp_continue }
    "*password:" { send "$3\r" }
  }
  expect eof
  EOF
}


auto_scp_key(){
  /usr/bin/expect <<-EOF
  set timeout -1
  spawn scp ~/.ssh/authorized_keys $1@$2:~/.ssh/
  expect {
    "*yes/no" { send "yes\r"; exp_continue }
    "*password:" { send "$3\r" }
  }
  expect eof
  EOF
}



yum -y install expect

for hs in hosts
do
  auto_scp_host $username $hs $password
done

for hs in hosts
do
  auto_ssh_host $username $hs $password
done

for hs in hosts
do
  auto_scp_key $username $hs $password
done



