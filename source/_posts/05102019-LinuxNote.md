---
title: LinuxNote
categories: Linux
tags:
  - Linux
  - RHEL 7
image: 'http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20190510_1.jpg'
updated: 2019-05-17 17:27:23
date: 2019-05-10 09:57:10
abbrlink:
---
Linux, RHEL 7
<!-- more -->
## RHEL 7 虚拟机安装
我是在ubantu LTS 18.04 系统中 xfce 桌面下用vmware workstation pro 15安装的
rhel-server-7.6-x86_64-dvd.iso
安装过程参照《linux就该这么学》一书，本文也是学习该书的笔记，
以后翻看《鸟哥的linux私房菜》时相应笔记也会补充到其中。
## 常用linux命令
在使用命令前，在终端上编辑bash终端命令本身有快捷键可以使用，记录如下
```txt
move
ctrl + f   move forward a character
ctrl + b   move backward a character
alt  + f   move forward a word
alt  + b   move backward a word
ctrl + a   move to the beginning 
ctrl + e   move to the end

edit
backspace  delete backward  a character
delete     delete forward   a character
ctrl + d  命令行为空时为退出终端，不为空时删除光标下的字符，应谨慎使用
ctrl + u  cut from cursor to the beginning (bash中叫kill and yank)
ctrl + k  cut from cursor to the end
ctrl + w  cut backward a word, 注意没有cut forward a word的快捷键，
          可以使用alt+f再ctrl+w来向前删除。
ctrl + y  paste what you have cut. 之后可以用alt+y来切换剪贴板的记录。
ctrl + l  clean the screen 当前命令行字符不会受影响
```
1. echo
   echo $SHELL  输出SHELL变量的值
2. date
   date "+%Y-%m-%d %H:%M:%S"  格式化输出当前时间
   date -s "20170901 8:30:00" 设置当前时间
   date "+%j" 用来显示当前时间是今年中的第几天，可以方便用来比较文件距离当前时间的新旧程度。
3. reboot
   重启命令需要管理员权限，有管理员权限的可以使用sudo reboot，没有的可以su root切换到root用户
4. poweroff
   关机命令需要管理员权限
5. wget
   从`man wget`的description中可以对wget命令有大概的认识,这里总结如下：
   wget是一个非交互方式的网络下载器，它可以在后台运行，这意味者用户不需要登录也可以在后台
   进行下载操作。它还支持递归下载，跟踪网页中的链接。同时支持断点续传。
   常用参数：
   -b  --backgroud 后台下载模式
   -p  --page-requisites  下载需要正常展示一个页面的所有资源，包括图片，视频等
   -P  prefix 指定下载目录
   -t  retries 最大尝试次数 默认20次，拒绝链接或404时不会尝试
   -c  --continue  断点续传
   -r  --recursive  递归下载，默认层数是5层
   -l  --level  指定最大递归层数
6. ps
   report a snapshot of current process 当前进程的快照
   ps -ef  是standard sympton
   ps -aux 是BSD语法
   进程状态：
   R run运行状态或等待运行
   S 中断
   D 不可中断，不响应异步信号，无法kill
   Z 僵死 进程已经中止，但描述符仍存在
   T 停止运行
7. top
   ps是快照，top是动态监控系统进程信息
8. pidof
   查询某个进程的pid值,如 pidof sshd
9. kill
   终止某个进程，如kill 2856
10. killall
   用来杀死某个服务的所有进程，如killall httpd

## 系统状态检测命令
1. ifconfig
   默认查看活动的网卡接口，-a查看所有网卡接口
   inet后是ip地址，ether后是物理网卡地址（MAC地址）
   ifconfig -a 

2. uname
   查看系统内核和系统版本等信息
   uname -a 
   rhel可以使用cat /etc/redhat-release查看当前系统版本的详细信息
   
3. uptime
   查看系统负载信息
   具体显示系统启动时间，已运行时间，运行中的和不可中断的进程的平均负载情况，1,5,15分钟时间内,
   建议不要长期超过1,生产不超过5.
   注: 由fish shell切换回bash时，发现系统启动时间是bash切换的时间

4. free
   内存使用量
   free -h 将数字转化为G为单位，方便阅读

5. who
   显示正在登录的用户终端信息
   用户名 终端设备 登录时间（不受终端Shell影响）

6. last
   查看系统登录记录
   查询的是日志文件，黑客可以修改，所以无法作为是否被入侵的依据。

7. history
   显示最近使用的命令，默认1000条
   bash上有数字显示,其显示的是~/.bash_history内容（fish上执行history是不同的命令，没有数字）
   可以使用！15来执行第15条命令
   history -c 可以清除命令

8. sosreport
   输出系统配置和诊断信息
   rhel上执行报no plugins enabled,使用sosreport -l发现插件都需要root权限。
   注：针对打出的诊断包.tar.xz格式可以使用`tar -Jxf XX.tar.xz`来解压

## 工作目录切换
1. pwd  显示当前目录
2. cd  切换工作路径
   cd -  切换到上一次所处的目录
3. ls
   目录中的文件信息
   ls -al  显示所有文件
## 文本文件编辑命令

<hr />
<img src="http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20190510_1.jpg" class="full-image" />
