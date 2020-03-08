#!/usr/bin/python
# -*- coding: utf-8 -*-

# Description: 用于与 ZK 连接进行一些操作
# Author     : tu
# Contact    : lihuimintu@gmail.com

# 安装 kazoo，pip install kazoo
from kazoo.client import KazooClient

import logging
logging.basicConfig()

# 连接 ZK
zk = KazooClient(hosts="192.168.0.162:2181,192.168.0.162:2182,192.168.0.162:2183")  

# 启动连接
zk.start()

# 创建节点，建立一个空的节点
def createNode():
    zk.ensure_path("/test")

# 节点添加数据，必须是byte
def createAdd():
    zk.create("/test/nodeA", b"a value")
    zk.create("/test/nodeB", b"b value")
    zk.create("/test/nodeC", b"c value")

# 获取节点数据
def getNode():
    data, stat = zk.get("/test/nodeA")
    print("Version: %s, data: %s" % (stat.version, data.decode("utf-8")))

# 列出节点数据
def getChildren():
    children = zk.get_children("/test")
    print("There are %s children with names %s" % (len(children), children))

# 修改节点数据，空节点的值不能用set修改，否则执行报错！
def modify():
    zk.set("test/nodeC", b"some data")

# 删除节点数据，recursive=True是递归删除，就是无视下面的节点是否是空，都干掉，不加上的话，会提示子节点非空，删除失败
def  delete():
    zk.delete("/test/nodeC", recursive=True)

# 与 ZK 断开
zk.stop()    



