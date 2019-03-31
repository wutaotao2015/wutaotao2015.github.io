---
title: Shell笔记
categories: Shell
tags:
  - Shell
image: 'http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20190330_1.jpg'
updated: 2019-03-31 18:09:18
date: 2019-03-30 11:40:15
abbrlink:
---
Shell
<!-- more -->
## 使用shell脚本来重启sprintboot应用
通过查资料和以前的一些印象终于搞出个能用的......
```txt
#!/bin/bash

export SPRING_PROFILE=prod
export APP_NAME=pra-plat
export VERSION=1.0.0-SNAPSHOT
export SERVER_PORT=8080

## setting log home
export JAR_HOME=/home/ap/cloudapp
export LOG_HOME=/home/ap/cloudapp/logs
export LOG_NAME=${APP_NAME}


# =两边不能有空格,命令输出结果用$()来赋给变量,注意awk的写法
pid=$(ps -ef | grep java | grep ${APP_NAME}| awk '{print $2}')
# 注意如何判断变量为空
if [ ${pid} ]
then # then需要另起一行，与if在同一行时需要在then前加分号
    echo "stop ${APP_NAME}_${SERVER_PORT} service"
    echo "kill process ${pid}"
    kill -9 ${pid}
fi

echo "start ${APP_NAME}_${SERVER_PORT} service"
JAVA_OPTS="-Dspring.profiles.active=${SPRING_PROFILE}"
# 直接jar包报cannot access jar file错误
nohup java -jar ${JAVA_OPTS} ${JAR_HOME}/${APP_NAME}-${VERSION}.jar >${LOG_HOME}/${LOG_NAME}.out 2>&1 &

echo "tail -f ${LOG_HOME}/${LOG_NAME}.out"
```

## Mac parallel安装centos虚拟机
1. 下载centos最小安装镜像,我选择的版本是CentOS-7-x86_64-Minimal-1810.iso
官网地址: [centos下载](https://www.centos.org/download/)

2. 一步步安装，登录后发现命令界面太小，网上搜索后没有解决办法，突然想到可以用远程ssh
登录，自己装的iterm2已经非常美观实用了。
已找到方法：[修改centos分辨率](https://superuser.com/questions/816528/with-centos-7-as-a-virtualbox-guest-on-a-mac-host-how-can-i-change-the-screen-r)
```txt
$ sudo su
$ vi /etc/default/grub 
add vga=792 to the end of GRUB_CMDLINE_LINUX
$ grub2-mkconfig -o /boot/grub2/grub.cfg
$ reboot
```

3. centos开通root远程ssh访问权限
```txt
$ ssh -V    # 查看ssh 版本
$ vi /etc/ssh/sshd_config 
将配置中的 #PermitRootLogin yes 这一行前面的＃号去掉
$ service sshd restart  # 重启ssh服务
$ ip addr   # 查看ip地址，eth0中的inet值即是

本地mac iterm2 登录ssh
$ ssh -l tao 10.211.55.9
输入密码链接成功！
```
4. centos关机命令
`sudo shutdown 0`

5. iterm2配置自动登录ssh
网上说的是配置profile,但启动还需要定义快捷键，可以直接定义别名

6. 用item2登录后发现centos界面颜色与真实的一致，所以还是需要修改centos上自带的颜色
```txt
$ cp /etc/DIR_COLORS ~/.dir_colors
vim ~/.dir_colors
第59行：DIR 01;34（01：粗体，34：蓝色）
修改为：DIR 01;33（01：粗体，33：黄色）
```
## 老mac安装Ubantu
昨天在新mac上用parallel成功安装了centos虚拟机，想到我那个小的mid-2011的macbook air,
突然萌生了要改装linux系统的想法，马上google搜索一番，发现果然有人在网上说可以这样干，
因为老mac带不动最新的macOs系统，却可以带动最新的linux系统，但linux系统版本众多，选择
哪一个版本也是问题，google上有人测评过，说还是ubantu靠谱,所以就决定装它了!
具体安装过程参考这篇文章：
[try out linux on aging mac](https://www.imore.com/how-try-out-linux-aging-mac)

具体安装过程就按这篇文章进行即可，找个u盘用软件Ether做成系统光盘，然后在老mac上启动时
按option键选择install ubantu即可。
安装过程中可以先不连wifi，语言可以选英文，选中文的话会出现中文目录。

ubantu下载软件比较慢，可以换成阿里云的源，不同版本的ubantu源也不一样，
我装的是最新的LTS版18.04。
   1. 备份原来的源文件
   sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
   2. 安装vim
   sudo apt-get install vim
   3. 编辑源文件
   sudo vim /etc/apt/sources.list
   4. 可以全部删除原来的，新增以下内容
```txt
deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
```
  
   5. 更新软件列表
    sudo apt-get update
   6. 更新软件包
   sudo apt-get upgrade

   7. 其中系统的复制粘贴命令同windows，ctrl+c,ctrl+v。终端(ctrl + option + t)中的复制粘贴
   可以从preference中看出，复制ctrl+shift+c,粘贴ctrl+shift+v.

   8. 安装蓝灯，github上有ubantu版

   9. 安装google浏览器。
      1. 在ubantu中访问[google官网](https://www.google.com/chrome/),
   点击下载会自动出现linux版，下载到Downloads下面。
      2. 终端中执行：
      > dpkg -i google-chrome-stable_current_amd64.deb

      3. 网上说可能报错，需要按提示的命令执行apt-get -f install,我这边没有报错，直接按
      command键输入google，愉快的打开并登陆了！
   10. 使用vim经常要用到esc键，所以我习惯将capslock与esc键交换位置
   tweak-tool的工具。
   > sudo apt-get install gnome-tweak-tool -y && gnome-tweak-tool

   装好后有一个tweaks应用，在keyboard&Mouse>additional layout>capslock behavior>
   swap esc and capslock

   11. 完全卸载ubantu里的软件
```txt
apt-get purge / apt-get --purge remove 
删除已安装包（不保留配置文件)。如软件包a，依赖软件包b，则执行该命令会删除a，
而且不保留配置文件

apt-get autoremove 
删除为了满足依赖而安装的，但现在不再需要的软件包（包括已安装包），保留配置文件。

apt-get remove 
删除已安装的软件包（保留配置文件），不会删除依赖软件包，且保留配置文件。

apt-get autoclean 
APT的底层包是dpkg, 而dpkg 安装Package时, 会将 *.deb 放在 /var/cache/apt/archives/中，
apt-get autoclean 只会删除 /var/cache/apt/archives/ 已经过期的deb。

apt-get clean 
使用 apt-get clean 会将 /var/cache/apt/archives/ 的 所有 deb 删掉，可以理解为 
rm /var/cache/apt/archives/*.deb。

实际使用：
# 删除软件及其配置文件
apt-get --purge remove <package>
# 删除没用的依赖包
apt-get autoremove <package>
```

   12. tbd

<hr />
<img src="http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20190330_1.jpg" class="full-image" />
