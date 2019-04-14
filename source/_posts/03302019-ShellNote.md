---
title: Shell笔记
categories: Shell
tags:
  - Shell
  - ubantu
  - vmware workstation
image: 'http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20190330_1.jpg'
updated: 2019-04-14 14:30:18
date: 2019-03-30 11:40:15
abbrlink:
---
Shell,ubantu,vmware workstation
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

   12. gnome用上面的gnome-tweak-tool软件可以成功，但后面又看到阮一峰推荐的fish+Xfce+
   xmonad+vim的工作套件，尤其是xmonad窗口管理工具简直是分屏利器，于是把我的老mac也整
   这样一套。
     1. ubantu上安装xfce桌面，登录时可以选择桌面系统，ubantu(gnome)或xfce(更轻更快)
     > sudo apt install xfce4  #xfce最新的为2015年的4.2版本

     2. 交换xfce中的esc和capslock键，新建文件~/.Xmodmap,其中内容为
```txt
clear Lock
keysym Caps_Lock = Escape
keysym Escape = Caps_Lock
add Lock = Caps_Lock
```
    3. 重启后修改也生效！蓝灯和google浏览器也能访问之前安装的程序。
    注：xfce下之前测了可以，但在ubantu默认的gnome3下该交换重启后又不行了，gnome3下重启后
    仍生效的是执行下面这个命令，使用gnome3默认安装的dconf工具：
    > dconf write "/org/gnome/desktop/input-sources/xkb-options" "['caps:swapescape']"

    4. 安装fish shell.
    > sudo apt-get install fish
    > fish  #启动shell,不建议设置为默认shell

    5. 安装xmonad
    > sudo apt-get install xmonad
    > sudo apt-get install xmobar dmenu  #小工具

    安装完之后只logout发现没有xmonad桌面，重启后才出来那个全黑的界面，果断alt+shift+enter,
    当当！终端出来了，vim看看capslock和esc也已经交换了，证明了它确实只是一个窗口管理软件，
    至此，fish+xfce+xmonad+vim的一套已经搞定，具体使用和问题后面再写，今天到点睡觉了！
    -- 2019-03-31 23:00:21 

    xmonad下蓝灯无效果，而且中文输入法也出不来，只能暂时放弃，等以后有需求和时间再来折腾
    一下。

   13. 安装fcitx来使用小鹤双拼，以及vim中输入中文输入的插件
```txt
sudo apt install fcitx
sudo apt install fcitx-pinyin
fcitx
在桌面图标上选择config current input method
为配合插件使用，第一位选择keyboard-English,第一个加上Shuangpin,
这里加上以后默认的不是小鹤双拼，需要修改默认双拼方案
cd ~/.config/fcitx/conf
vi fcitx-pinyin.config
设置为DefaultShuangpinSchema=XiaoHe
```

   14. 在ubantu系统启动时执行某些命令，如`sudo tlp start`软件减少散热的，还有命令别名
   设置等，之前放到.bash_profile中不行，网上搜索到可以放在.bashrc中，查看.bashrc文件，发现
   它有检查.bash_aliases文件，于是新建该文件，将命令放入其中即可。

   15. shell基本使用

      1. 不建议设置为默认shell,在.bashrc或.bash_aliases中写入`exec fish`来实现启动终端时执行
   fish。
      2. 执行命令`fish_config`进入网页配置界面，默认8000端口打开的本地网页，可以设置颜色
      主题和提示符prompt等。
      3. 自定义别名
      ```txt
 alias post 'cd /home/tao/wtt/blog/source/_posts'
 funcsave post     #可以在.config/fish/config.fish/functions下找到生成的fish文件
 alias pull 'git pull; and echo "done"'
 funcsave pull
 alias push 'git add . ;and git commit -m $argv[1];and git push origin source; and echo "done"'
 funcsave push
 alias pub 'git push github source;and echo "done"'
 funcsave pub
      ```
   16. vim中输入中文的插件，实现插入模式中自动切换为中文，leave insertMode时切换为英文，
   按教程安装vundle,plugin有
  ```txt
Plugin 'scrooloose/nerdtree'
Plugin 'lilydjwg/fcitx.vim'
  ```
  fcitx.vim针对的是fcitx下的中文输入，其脚本中也是切换键盘输入，所以前面设置fcitx时需要
  将第一位设置为英文，第二位设置为双拼。其插件脚本为
```txt
"##### auto fcitx  ###########
let g:input_toggle = 1
function! Fcitx2en()
   let s:input_status = system("fcitx-remote")
   if s:input_status == 2
      let g:input_toggle = 1
      let l:a = system("fcitx-remote -c")
   endif
endfunction

function! Fcitx2zh()
   let s:input_status = system("fcitx-remote")
   if s:input_status != 2 && g:input_toggle == 1
      let l:a = system("fcitx-remote -o")
      let g:input_toggle = 0
   endif
endfunction

set ttimeoutlen=150
"退出插入模式
autocmd InsertLeave * call Fcitx2en()
"进入插入模式
autocmd InsertEnter * call Fcitx2zh()
"##### auto fcitx end ######
```

## ubantu下vim的粘贴复制问题
昨天使用ubantu默认的gnome-teminal时，发现多个tab间无法进行复制粘贴操作，经网上搜索发现
以前gnome-terminal确实有这个bug,但是后来已经修复了，回到家用自己电脑下了一个terminator
来替代gnome-terminal，发现还是有这个问题。本来已经放弃了，但是今天无意中搜索到原来是vim的
问题，原生的vim不能与系统剪切板进行交互，需要下载vim-gnome！
```txt
sudo apt --purge remove vim
sudo apt install vim-gnome
```

OK!将原来的.vimrc中
```txt
#set clipboard+=unnamed
noremap <Leader>y "+y
noremap <Leader>v "+p
noremap <Leader>V "+P
```

## ubantu下vmware虚拟机网络设置问题
终于这个困扰本人许久的问题终于正式解决了！
首先看一下引发解决的关键点：
1. vmware workstation的editor->virtual network editor
2. bridge,nat,host等概念
3. 有限网络的默认网关屏蔽

首先介绍一下操作背景，银行通过有线网线来链接内网，平时查资料需要通过个人热点来链接外网，
同时因本人喜欢终端命令行操作及vim编辑等功能，打算放弃windows操作系统，但银行内部需要
windows来进行工作，所以是重装了ThinkPad T540P笔记本为ubantu LTS 18.04系统，安装了
linux版的vmware workstation,其中安装了用于工作的windows10系统————这就是操作环境。

1. 插上网线和链接上个人热点后，通过`ip route show`看到有两个默认网关，链接外网失败。
在网络设置中-wired connected-settings-ipv4中，先关闭链接，再勾选
use this connection only for resources on its network
再链接后，可以发现默认网关只有一个热点了，此时可以上外网。

2. 配置vmware workstation的网络设置，在editor->virtual network editor中进行配置，可以
选择对应的网卡。
```txt
Bridge mode:This connects the virtual network adapter directly to the physical network
NAT: This allows the virtual network adapter to share the host’s IP address
Host Only: This creates a private network that the virtual network adapter shares with the host
Custom: This allows you to create your own virtual network

Note: Although VMnet0, VMnet1 and VMnet8 are technically available in this menu, 
they are usually used for bridged, host-only, and NAT configurations, respectively.
```
由以上概念可知，这里实际需要的就只是桥接模式，直接接入物理网络，nat模式选择时还需要进行
手动网络转换，而且之前使用也达不到目地，就不选这个了，host模式只能宿主机访问，也不满足要求。
这里为避开0,1,8的默认名字，可以取名VMnet11,12代表有线和无线2个网卡。

3. 为工作的虚拟机配置里选择网络设置为custom，选择刚才新建的虚拟有限网卡，为自己玩的
centos配置虚拟无线网卡。

4. 登录工作虚拟机，发现链接内网成功！

5. 登录centos7,这里时新建的minimal安装，执行以下命令：
```txt
cd /etc/sysconfig/network-scripts/
ip addr // 查看除了lo外的另一个网卡名字如ens33
su root  // enter password
vi ifcfg-ens33
onboot=no 改为 yes
systemctl restart network
ping www.baidu.com   // done!
```

## ubantu修改swap文件
```txt
sudo swapoff /swapfile
sudo rm -rf /swapfile
sudo dd if=/dev/zero of=swap bs=1024 count=2000000^C  #建立swap文件
sudo chmod -R 600 /swapfile     
sudo mkswap /swapfile    #创建系统
sudo swapon /swapfile   # 开启swap
sudo vi /etc/fstab
/swapfile   none     swap    sw      0       0
```
## ubantu备份和还原
终于完美从thinkpad迁移到mac的虚拟机上！
1. 备份老系统
由于我是默认用的fish,所以为防止报错，写了一个bash shell脚本来执行打包命令
```txt
vi bashShell.sh

内容如下
#!/bin/bash
tar cvpzf /media/tao/ExFAT/backup.tgz --exclude=/media/* --exclude=/sys/* 
--exclude=/proc/* --exclude=/dev/* --exclude=/run/* --exclude=/snap/* 
--exclude=/home/tao/vmware/* 
--exclude=/home/tao/Documents/CentOS-7-x86_64-DVD-1804.iso /

sudo su
chmod +x bashShell.sh
sudo ./bashShell.sh
```

2.如果是原来机子回复系统，可以这样做（未测试）
```txt
cd /
sudo su
sudo tar -xvpzf /media/tao/ExFAT/backup.tgz -C /
sudo reboot 0
```
done!
注： tar命令只会覆盖已有的文件，备份后新增的文件不会修改或删除。

3.如果是虚拟机或其他电脑，因为硬盘的uuid不同，所以需要多些步骤
```txt
备份fstab,得到其中的uuid
cd /etc/
sudo cp fsta ~/back
备份grub.cfg
sudo cp /boot/grub/grub.cfg ~/back

恢复旧系统备份
cd /
sudo su
sudo tar -xvpzf /media/tao/ExFAT/backup.tgz -C /

回复fstab和grub
sudo cp ~/back/fstab /etc/
sudo cp ~/back/grub.cfg /boot/grub/

重启
sudo reboot 0
```
done!
 
4. 卸载ubantu虚拟机上的vmware-workstation软件
sudo ./VMware-Workstation-Full-15.0.3-12422535.x86_64.bundle -u vmware-workstaion

## vmware workstation上修改ubantu分辨率
27寸的HKC屏幕最佳分辨率是2560X1440,ubantu虚拟机给出的最大分辨率是2560X1600,网上找到可以
修改的方案，记录如下：
```txt
xrandr   # 得到第二行的第一个单词，connected primary前的单词为显示设备名称Virtual1

cvt 2560 1440   # 输入需要的分辨率
# 得到一行modeline
# Modeline "2560x1440_60.00"  312.25  2560 2752 3024 3488  1440 1443 1448 1493 -hsync +vsync

# 添加新mode, --newmode后为前面的modeline
sudo xrandr --newmode "2560x1440_60.00"  312.25  2560 2752 3024 3488  1440 1443 1448 1493 -hsync +vsync

# 将新模式应用到显示设备中,设备名和分辨率分别取前面的值
sudo xrandr --addmode Virtual1 "2560x1440_60.00"

# 在settings->resolution中可以看到需要的分辨率了，apply即可成功！

# 编辑～/.profile使ubantu下次以这个分辨率启动
加入上面2行命令
sudo xrandr --newmode "2560x1440_60.00"  312.25  2560 2752 3024 3488  1440 1443 1448 1493 -hsync +vsync
sudo xrandr --addmode Virtual1 "2560x1440_60.00"
```
注！按以上配置，重新登录后黑屏，只好在登录界面按ctrl+alt+F3进入命令登录界面，
删除刚才修改的~/.profile文件。
具体原因明天再看吧！


<hr />
<img src="http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20190330_1.jpg" class="full-image" />
