---
title: MacOS 重装笔记
categories: Mac
tags:
  - Mac

abbrlink: 8b2fd91d
updated: 2019-04-28 23:06:49
date: 2019-04-14 15:30:26
---
MacOS
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
5. 本来想装insomniax来使得合盖外接显示屏，highSeria上可以正常运行，但Mojava上就运行不了，
无论是开启允许任意来源`sudo spctl --master-enable`,还是辅助功能里允许InsomniaX完全控制都
不能实现合盖不休眠的功能，只能解释为Mojave把相应功能屏蔽了。习惯了合盖模式外接显示屏的我
甚至想装回原来的High Seira,但女朋友说辛苦装的，还是用几天，早上醒来想想，还是正常升级系统，
用不了合盖模式也行，苹果只支持充电的时候可以合盖，合盖容易引起发热问题等，所以我就把大显示
屏用鞋盒垫高，下面放笔记本，就用双屏吧，以后看看能实现Xmonad在ubantu虚拟机内的多屏显示功能
么，或者macOS的实现-Amethyst能支持么-----To be continued.

6. 安装vmware fusion 11,并安装ubantu 18.04 LTS,恢复备份等,想想还是不装parallel desktop了，
目前我的thinkpad用的是vmware workstation,为了以后迁移方便，就统一使用vm吧。

7. vmware中给ubantu虚拟机安装vmware-tools,在虚拟机选项中选择安装vmware-tools,ubantu中出现
一个外接光盘，将压缩包拷贝到download目录后解压(不能直接解压)，执行命令`sudo ./vmware-tool
-install.pl`, 一直回车即可。

8. mac自带vim不支持共享剪贴板的问题
mojave上的vim --version显示-clipboard,不支持共享系统剪贴板。
`brew install vim`
安装了python,sqllite,ruby,perl等依赖后，执行`which vim`，发现路径已经变掉了，
再重新打开一个终端，在.vimrc中加入（一开始字母写错了，总报错还不知道为什么......)
`set clipboard=unnamed`


<hr />
<img src="http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20190415_1.jpg" class="full-image" />
