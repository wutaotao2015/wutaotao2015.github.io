---
title: MacOS 重装笔记
categories: Mac
tags:
  - Mac
image: 'http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20190131_1.jpg'
updated: 2019-04-14 19:16:25
date: 2019-04-14 15:30:26
abbrlink:
---
description
<!-- more -->
## 重装mac
1. 重启mac,command+R进入恢复模式
2. 抹掉整个硬盘，重新安装
3. 升级到MacOS Mojave
## 装软件
1. 修改输入法，简体双拼中有小鹤输入，不用装搜狗了！
2. 装百度网盘，从上面下载lantern客户端，这样下载快一点，github很慢。
3. lantern授权后，装google浏览器，登录，同步。
4. 安装homebrew，
```txt
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
# 现在不用再手动装cask了，homebrew里已自带
```
注： 在以上安装过程中，发现会卡死，速度很慢，网上有很多说使用镜像的，但有人觉得不好，
又发现有人说使用SS代理，我使用的是蓝灯，所以搜到了使用lantern来为git http方法进行代理的
方法，其他命令如curl等也可以设置。

git为设置
```txt
git config --global http.proxy 'http://127.0.0.1:49612'
git config --global https.proxy 'https://127.0.0.1:49612'
```
以上具体端口查看lantern高级设置里有。

curl等其他工具http代理
```txt
export http_proxy=http://127.0.0.1:49612
export https_proxy=http://127.0.0.1:49612
```
5. 本来想装insomniax来使得合盖外接显示屏，但始终没有找到，后来反应过来这只是让笔记本不
要在合盖时休眠即可，又在网上查到mac系统已经集成了以前用过的一个工具caffeinate,只要
在终端中输入该命令即可实现合盖不休眠。
6. 安装vmware fusion 11,并安装ubantu 18.04 LTS,恢复备份等。
7. 安装parallel Desktop 14, 安装带了office 2019的win10.
##
<hr />
<img src="http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20190131_1.jpg" class="full-image" />
