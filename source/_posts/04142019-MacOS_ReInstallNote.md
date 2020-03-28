---
title: MacOS 重装笔记
categories: Mac
tags:
  - Mac

abbrlink: 8b2fd91d
updated: 2020-03-29 00:00:36
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

## mac崩溃记
昨天刚更新到macOS 10.15.4, 结果今天发现鼠标滑动变卡了，而且破解版的mac cleaner也不能用了，
又是一次头脑发热的升级......, 更致命是后面win10虚拟机的操作，当时刚把c盘压缩后新建了d盘，
并清理了软件安装包，然后我发现电脑空间还是不足，发现虚拟机总共才70G, 而parallel占用了140G,
应该是快照的原因， 这时致命操作来了， 我在虚拟机运行的情况下做删除快照的操作！并且是删除
当前和其子类快照，显示一个进度条缓慢增加到4%时，电脑卡住，再过一会直接关机报出日文错误。
重启后虚拟机启动不了，鼠标又卡的要命！只能重装系统！还好我有timeMachine之前的备份。

开机时应该是按住option键(不确定)进入修复页面，选择从timeMachine恢复，耐心等待，刚开始显示
有5,6个小时，还好后面实际不用这么久，大概2个多小时就好了，自动重启。这时另一个坑出来了，
登录后输入密码，回车，出现个框一直在转圈loading, 上网查有人说是要输入appleId, 他插根网线
就好了，我的苹果没法插网线！但是知道原因就好办了！原来是要连Apple服务器！我只需要反过来，
拔网线--即关闭路由器就可以了，它连不了网当然会乖乖进入脱机模式！事实证明果然如此，正常启动
成功后，wifi无法链接，这时进行常规操作，删除wifi后新建，成功上网，重新登录icloud, 成功！

总结：
1. 备份非常重要，timeMachine对mac外部系统备份，2个虚拟机，win10, ubuntu文件本身需要备份。
2. 虚拟机运行时严禁进行快照操作，要保存快照也应该挂起后进行，否则也非常慢，删除快照更是
致命，直接搞挂电脑。
切记切记！ written at 2020-03-29 00:00:13 


<hr />
<img src="http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20190415_1.jpg" class="full-image" />
