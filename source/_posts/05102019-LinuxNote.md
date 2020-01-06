---
title: LinuxNote
categories: Linux
tags:
  - Linux
  - RHEL 7

abbrlink: 1604d5df
updated: 2020-01-06 15:50:50
date: 2019-05-10 09:57:10
---
Linux, RHEL 7
<!-- more -->
## RHEL 7 虚拟机安装
我是在ubantu LTS 18.04 系统中 xfce 桌面下用vmware workstation pro 15安装的
`rhel-server-7.6-x86_64-dvd.iso`

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
### 简单命令
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

### 系统状态检测命令
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
   bash上有数字显示,其显示的是`~/.bash_history`内容（fish上执行history是不同的命令，没有数字）
   可以使用！15来执行第15条命令
   history -c 可以清除命令

8. sosreport
   输出系统配置和诊断信息
   rhel上执行报no plugins enabled,使用sosreport -l发现插件都需要root权限。
   注：针对打出的诊断包.tar.xz格式可以使用`tar -Jxf XX.tar.xz`来解压

### 工作目录切换
1. pwd  显示当前目录
2. cd  切换工作路径
   cd -  切换到上一次所处的目录
3. ls
   目录中的文件信息
   ls -al  显示所有文件

### 文本文件编辑命令
1. cat
   cat -n 查看文本内容并显示行号
2. more
   显示部分文本文件，会显示当前行所在百分比，用空格会查看下一页内容，回车查看下一行内容
   推荐使用less命令
3. head  默认10行
   head -n 20 XX.file   显示XX文件前20行内容，显示后无法进一步操作
4. tail  默认10行
   tail -100f XX.file   显示文件最后100行内容并持续刷新
5. tr 简化版的sed命令，可以进行简单删除，替换操作。
   echo "hello 23 world 45" | tr -d '2345'  删除 输出hello world
   echo "helllllo wooorld" | tr -s 'lo'     压缩 输出helo world
   echo "helllllo wooorld" | tr [a-z] [A-Z]   转换大小写 输出HELLLLLO WOOORLD
6. wc  word count
   wc XXX    依次显示XXX文件的行数，单词数，字节数
   也可以单独显示某个信息，如:
   wc -l XXX   只显示行数lines
   wc -w XXX   只显示单词个数words
   wc -c XXX   只显示字节数bytes
7. stat  
   stat XXX   显示XXX文件的存储信息和access,modify,change时间
8. cut  按列提取文件数据
   cut -d: -f1 /etc/passwd   -d为delimiter为:, -f1指定第一列
9. diff
   diff -q A.txt B.txt   相当于--brief 显示是否不同
   diff -c A.txt B.txt   显示2个文件，并用感叹号显示出不同的行

### 文件目录管理命令
1. touch 新建一个文件或修改一个文件的修改时间，读取时间等
   touch -a    只修改文件读取时间 atime   access
   touch -m    只修改文件修改时间 mtime   modify
   touch -d    同时修改atime和mtime    date
   如touch -d "2019-01-01 10:00" XXX   修改XXX文件的读取和修改时间 
2. mkdir  创建文件夹
   mkdir dir   
   mkdir -p a/d/b  创建所需的层级目录(parent, 必要时创建父目录)
3. cp
   -a   保留文件属性 同-pdr 权限，软链接，递归复制 
   -r   递归持续复制
   -i   若目标文件存在则进行询问
   cp a.txt aBack.txt
4. mv
   mv a.txt b.txt
5. rm
   rm -rf dir/
6. dd
   复制或转换一个文件，可用来创建指定大小的文件，或快速制作iso文件
   if  输入文件
   of  输出文件
   bs  每个块的大小
   count 块的个数

   dd if=/dev/zero of=aFile count=1 bs=560M  创建一个560M的文件aFile(/dev/zero为无限空间设备名)
   dd if=/dev/cdrom of=RHEL-server-7-x86_64.iso  从光盘中制作镜像文件
7. file
   由于linux中文本，目录，设备都是文件，可以使用file命令来查看文件类型
   file a         ASCII text 
   file /dev/sda    block special

### 打包压缩与搜索命令
1. tar
   tar option file 
   -c  压缩  create a archive
   -x  解压  extract  
   -z  使用gzip压缩或解压  
   -j  使用bzip2压缩或解压
   -v  显示压缩或解压过程 verbose
   -f  指定目标文件名 file   (需要在参数的最后一位)
   -C  指定解压到的目录 --directory
   -p  保留权限与属性信息  --preserve-permissions
   -P  使用绝对路径来压缩 --absolute-names
   -t  显示压缩包内的文件列表  --list
   常用用法
   tar -czvf a.tar.gz /a
   mkdir ss
   tar -xzvf a.tar.gz -C ./ss/   解压无法自动创建目录，需要手动创建，使用-C指定解压目录  

2. grep
  grep [options] pattern [file]
  -i    --ignore-case 忽略大小写
  -n    --line-number 显示行号 
  -v    --invert-match 反向选择，列出不匹配的行
  -c    --count  仅显示行数
  -b    将可执行文件作为text文本搜索 
  grep -n /sbin/nologin /etc/passwd

3. find
   find path expression(expression由options, tests, actions组成)
   其中tests有以下选项：
  -name  按文件名搜索
  -perm  按权限搜索 -perm mode 为完全匹配， -perm -mode为包含即可
  -user  匹配拥有者
  -group 匹配组
  -mtime 匹配修改的时间 -n n天以内 +n n天以前
  -atime 匹配访问的时间 -n n天以内 +n n天以前
  -ctime 匹配修改文件权限的时间  -n n天以内 +n n天以前
  -nouser  匹配无拥有者的文件
  -nogroup 匹配无拥有组的文件
  -newer f1 !f2  匹配比f1新，比f2旧的文件
  --type 匹配文件类型 
     b 块设备 d 目录 c 字符设备 p 管道 l 链接文件 f 文本文件
  -size  匹配文件大小 +50KB查找大于50KB的文件，-50KB查找小于50KB的文件
  -prune  忽略某个目录
  -exec {} \;  对搜索结果进行处理, {}表示匹配成功的每一个文件，命令以\;结尾
  `find /etc -name "host*" -print`   
  find / -perm -4000 -print
  find / -user linuxprobe -exec cp -a {} /root/findresults/ \;

## 管道符、重定向与环境变量

### 输入输出重定向

标准输入重定向(STDIN, 文件描述符为0)  默认从键盘输入，也可为其他文件或命令
标准输出重定向(STDOUT，文件描述符为1) 默认输出到屏幕
错误输出重定向(STDERR, 文件描述符为2) 默认输出到屏幕

```txt
< aFile   将文件作为命令的标准输入
<< ;    从标准输入中读取，直到分界符;才停止
< afile > bifle  afile作为标准输入，bfile作为标准输出

> afile   标准输出重定向到afile,并清空afile原有内容
2> afile  将错误输出重定向到afile中，并清空afile原有内容(注意2后没有空格)
>> afile  标准输出重定向到afile,追加到afile原有内容后
2>> afile 错误输出重定向到afile,追加到afile原有内容后
>> afile 2>&1 或 &>> afile  这2个命令都代表标准输出和错误输出共同重定向到afile文件(追加)
> afile 2>&1 或 &> afile 这2个命令都代表标准输出和错误输出共同重定向到afile文件(清空)
```
其中，文件描述符1可以忽略不写，如`1> afile`写为`> afile`, 2不能省略

输入重定向如`wc -l < a.txt`显示a.txt文件中内容的行数
(可用cat a.txt | wc -l代替)

### 管道命令符
如grep会打印出符合条件的行内容，wc -l会显示文件行数，可以使用管道符来打印出符合条件的行数
(虽然可以用grep的-c参数...).

在修改密码时要求从键盘中输入密码，在自动化脚本中无法实现，可以使用管道符和passwd命令的
--stdin参数完成这一功能。
```txt
su root
echo "root" | passwd --stdin root
```

不同用户间发送邮件,如用户root发送给用户tao,标题为subject,内容为hello tao
`echo "hello tao" | mail -s "subject" tao`
注：经测试用户tao给root写信没有成功...

使用<< ;重定向输入直到分界符;可以连续输入多行邮件内容，如
```txt
mail -s "test" tao << over
```
可以输入多行内容，直到最后一行以精准的over结束为止，不能多或少字符，空格等。

### 命令行的通配符
与正则表达式不完全相同的是通配符的含义：
* 表示0个或多个字符(相同)
? 表示1个字符(不同)
[] 匹配中括号中的一个字符(相同)

### 常用的转义字符
\  使特殊字符变为普通字符
'  使引号中的变量变为单纯字符
"  将其中的变量求值后输出
`  执行其中的命令后返回结果

如执行命令echo "price is $PRICE" 会输出price is 5,双引号对变量求值。
而$$会打印出当前程序的进程ID,所以可以使用echo "price is \$$PRICE"来输出price is $5.
需要某个命令的输出值时可以使用反引号。

### 重要的环境变量
linux终端执行命令步骤:
1. 检查用户命令是否以绝对路径或相对路径输入命令，如果是则直接执行。
2. 检查命令是否是别名alias,如根用户执行命令`alias rm`可以看见输出
`alias rm='rm -i'`, 说明系统默认将rm命令加上-i参数执行。
3. 判断命令是内部命令还是外部命令，内部命令是解释器内部的指令，它会直接执行;外部命令会由
步骤4继续执行。如执行命令`type cd`或`type pwd`可以看见输出为XXX is a shell builtin，说明
其为内部命令。
4. 系统在PATH变量中寻找该命令文件执行。PATH变量是由多个路径组成的变量，由冒号分割，可以使用
命令`echo $PATH`查看PATH变量的值。

不能将当前目录添加到PATH变量的原因为: 黑客可以将一个与ls命令(本身是别名)同名的木马文件存放
到某个常用公共目录中，用户在该目录执行ls命令时会根据环境变量找到当前目录下的木马文件执行，
从而中招。

最重要的10个环境变量:
```txt
1. HOME    家目录
2. SHELL   当前使用的Shell解释器名称
3. HISTSIZE        输出的历史命令记录条数
4. HISTFILESIZE    保存的历史命令记录条数
5. MAIL       邮件保存路径
6. LANG    系统语言
7. RANDOM   生成一个随机数字
8. PS1     Bash解释器提示符
9. PATH    解释器搜索用户执行命令路径
10. EDITOR 用户默认文本
```
不同用户看到的相同环境变量可能不同，如root用户与普通用户查看到的HOME变量就不同。
可以使用export命令导出自定义的环境变量，这样做相当于将其提升为全局变量。

## vim编辑器与Shell命令脚本
TBD

## scp命令
因为工作中经常需要上传前台页面的jsp和js文件到服务器上(只有服务器上才能调用后台接口), 一直
使用ftp工具图形化界面上传，用久了突然反应过来可以用ssh远程登录和scp命令进行操作，方便快捷。

```txt
upload to server
scp 1.txt 2.txt user@ip:/home/XXX/XXX

download from server
  // many files
scp user@ip:"/path/of/file1 /path/of/file2" ./
  // recursive download, such a dir 
scp -r user@ip:/path/of/dir ./
```
scp默认覆盖已经存在的文件和目录。

## cdh 和 pushd
vim作为文本编辑器非常强大，但很多时候还是要跳出vim到命令行进行操作，如复制文件，运行命令
行命令等。vim中可以使用ctrlp的MRU File功能，但命令行中切换mru dir怎么办？
我记得之前有个autojump插件(fish shell也支持), 打算装上，但在stack overflow上看到了更多
的解决方案，相比这个简单需要完全不需要装插件。
```txt
1. cd -  在2个目录间进行跳转，类似于vim的ctrl+6交互文件
2. pushd/popd  
   下面这个是fish shell的man页面
   The pushd function adds DIRECTORY to the top of the directory stack and makes it the 
   current working directory. popd will pop it off and return to the original directory.

   Without arguments, it exchanges the top two directories in the stack.

   pushd +NUMBER rotates the stack counter-clockwise i.e. from bottom to top
   pushd -NUMBER rotates clockwise i.e. top to bottom.

   See also dirs and dirs -c.
   You may be interested in the cdh command which provides a more intuitive way to navigate to recently visited directories.

   经测试，bash下pushd, dirs也可以使用，cdh是fish shell自己封装的一个交互跳转页面
```
总体来说，我本地是fish, 用cdh比较方便，其他环境使用以下命令组合:
```txt
pushd /path/of/dir
dirs -v
pushd +n // n 是dirs -v显示的序号
pushd    // 等同于 pushd +0
```

## .bashrc和.bash_profile
由于我想使用xcape修改键盘，按网上博客将相关命令代码放在.bashrc中，代码如下:
```txt
# Run xcape once.
if [ -z $XCAPE ];then
  export XCAPE=1
  /usr/bin/xcape -e 'Super_L=Escape;Shift_R=parenleft' 
fi
```
可以看到，它通过判断XCAPE变量长度是否为0进行操作，如果为空，就执行xcape命令，否则就不会重复
执行。之前没在意这点，后来发现多次打开终端terminator窗口，发现按右shift产生了多个括号，
开始以为是xcape命令的问题，后来"不小心"发现有多个xcape进程同时运行！

问题就出在.bashrc中没有实现需要的export出全局变量的功能！那么这段代码应该放在哪里？

寻找了好久，试了/etc/profile, .profile, `.bash_profile`, /etc/init.d/rc.local, .xsessionrc,
全都不行！

经网上资料查找到bash manual, 其中对它们的区别作出了说明。这里翻译一下bash manual相关内容。
```txt
1. 通过登录的交互式shell登录， 或是--login参数登录时:
 先读取/etc/profile,再是`~/.bash_profile`,`~/.bash_login`, ~/.profile.会顺序查找执行第一个
 找到的可执行文件，剩下的会被忽略。执行exit命令退出时，会尝试执行`~/.bash_logout`.
 有些shell没有按照这个顺序查找，如dash,它只看.profile, 所以如果使用其他shell作为
 login shell时(如使用了命令chsh -s), 这时应当修改.profile才会生效。

2. 如果是交互式非登录方式(一般的默认方式).
 会执行.bashrc, 即打开一个终端实例，即会执行一次.bashrc, 通常推荐在`.bash_profile`中包含
 执行.bashrc文件，为
```txt
  if [ -f ~/.bashrc ]; then . ~/.bashrc; fi
```

3. 当不是交互式执行bash时，如执行脚本时
 终端会执行`$BASH_ENV`变量，执行过程等同与执行以下命令:
```txt
  if [ -n "$BASH_ENV" ]; then . "$BASH_ENV"; fi
```

4. 通过sh命令执行命令
基本等同于以上步骤，如果是login或--login的终端中执行的sh命令，会读取/etc/profile, ~/.profile;
如果是交互式shell, 会读取变量ENV.非交互式的Shell执行sh命令不会尝试读取任何其他的启动文件，
如脚本中的sh命令。
```
由上可知，每次打开新的终端窗口，都会执行.bashrc文件，所以我将想只在登录时执行一次的代码
放到.bash_profile中，可以登录后手动source .bash_profile, 但不能重复执行。

注: /etc/environment是适用于所有用户的，归root用户管理，需要sudo进行修改，不应当修改它，
它通常只包含一行:
```txt
PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"
```
如果只适用与当前用户的环境变量应当放在.profile中，如果想适用到所有用户，也不应当直接修改
/etc/profile, 而是应当在/etc/profile.d/下新建可执行的XX.sh脚本。

我使用的xmonad,通过以上方法新建脚本，在其中export相应的环境变量，发现xmonad也能获取到相应的
环境变量，这样就不用额外执行对应的脚本了。同时在.xsessionrc执行xcape ... & 也能正确响应，
成功！

注: .xsessionrc在每次X的session启动时都会执行，而/etc/init.d/rc.local说是只有第一次启动时
会执行，后面xserver重启时就不会执行(待测试)。

## Teminator主题精选
以下是我精选的Terminator主题，来源是[github](https://github.com/EliverLara/terminator-themes)
```txt
Cai, Cobalt2, Dracula(default), Elio, Glacier, Homebrew, Jellybeans, Monokai Vivid, 
Pandora, pro
```
字体选择自带的Nimbus Mono L Bold 13即可。
注: terminator copy and paste: 
ctrl + shift + c
ctrl + shift + v
这适用于提取fish命令到剪切板中。

## kitty and fira-code
昨天刚刚找了很多Terminator的主题,今天想找到能够区分1和l(lowercase of L)的字体，结果发现了
fira-code! 感觉非常神奇，但是Terminator还不能支持它，linux上可以装kitty支持它。
但kitty虽然速度快，但目前还非常小众，没有Terminator的精美样式。
所以我先装下网上推荐的input字体看看效果，毕竟我本来是要装字体的....
清晰的字体要能明显区分以下内容:
```txt
1 l
O 0
S 5
0 o
```
ubuntu上安装过程:
```txt
1. 在input页面自己定制字体，尤其是上面的l, i部分
2. 下载自定义的input包，里面除了自定义的字体包外，有一个可以修改自定义的python脚本，先不管它。
3. mkdir ~/.fonts
4. cp -r ~/Downloads/input/* ~/.fonts   // 将所有的ttf格式字体拷贝到.fonts目录下
5. fc-cache -f -v   // 强制刷新字体缓存，使得新装字体生效 
6. 在teminator中选择input bold字体，done!
```

## vmware workstation 虚拟机减小硬盘容量(decrease vmware workstation hard disk size)
vmware虚拟机扩大硬盘容量非常简单，直接在设置中扩容即可，但想要减小容量确不能直接操作。
在网上搜索到quora中有人提供了3种方法。
1. vSphere Manager. 经搜索每找到对应的工具
2. vmware converter. vmware推荐工具, 我最后采用的方法
3. qemu-img工具。它是属于QEMU的工具。

第3种方法看起来最简单方便，经查看是对单个vmdk包进行大小修改，我的虚拟机中有好几个vmdk文件，
所有操作起来有一定风险。

第2种方法是官方工具，但使用下来主要是速度非常慢，我失败了1次，第2次成功，前后接近2小时多
时间才得到转换后的包。下面记录下过程和坑。
1. 下载vmware converter, 我的版本是6.2.0-8466193.exe版本。支持转换win 10.
2. 需要关闭windows实时防护等，我自己是关闭所有防火墙。否则转换中会失败。
3. 用管理员运行converter, 否则选择local merchine时报错permission not allowed.
4. 开始转换，source 选local machine, destination选vmware workstation, 这里只能选到
vmware workstation 11/12. 在后面的edit界面中重新选择磁盘大小。
5. 转换结束，因为我的workstation是15版本，直接启动始终转圈，后面看到有个upgrade选项，
果断点击clone 升级。

## xfce使用快捷键将窗口在多显示器之间移动
本来我是用xmonad的，经过不少折腾，基本上能流畅使用了，但xmonad有个问题: 即如果在vim中使用
如ctrlp插件快速切换多个文本文件时，vim会明显卡住，导致屏幕显示内容出现问题，该问题后来
没有找到合适的解决方法，个人感觉和xmonad的标准输入记录有关(即上面显示当前工作区和内容的区域),
怀疑是快速切换时造成xmonad的输入管道堵塞引起(纯粹个人猜测，因为目前还没有去专门学习haskell)。
Anyway, 后来发现wayland和xfce没有vim的该问题，快速切换时非常流畅，没有卡屏现象; 而且又发现
xfce提供了windows manager设置功能，完全可以将xmonad的快捷键照搬到其中，非常方便，而且它还
可以删减工作区(alt + insert/delete即可)，这也是我想要的一个功能，xmonad目前默认9个，想减少
还没有找到合适方法(同样，没有专门学习haskell). 

那么最后的问题是，如何在xfce中实现多显示屏之间的窗口移动和焦点切换？
xfce本身没有支持，网上有提供脚本实现，这里记录下尝试过程。
1. sudo apt install xdotool wmctrl
2. vi moveWindow.sh
```txt
#!/bin/bash
#
# Move the current window to the next monitor.
#
# Also works only on one X screen (which is the most common case).
#
# Props to
# http://icyrock.com/blog/2012/05/xubuntu-moving-windows-between-monitors/
#
# Unfortunately, both "xdotool getwindowgeometry --shell $window_id" and
# checking "-geometry" of "xwininfo -id $window_id" are not sufficient, as
# the first command does not respect panel/decoration offsets and the second
# will sometimes give a "-0-0" geometry. This is why we resort to "xwininfo".

screen_width=$(xdpyinfo | awk -F" |x" '/dimensions:/ { print $7 }')
screen_height=$(xdpyinfo | awk -F" |x" '/dimensions:/ { print $8 }')
window_id=$(xdotool getactivewindow)

case $1 in
    -l )
        display_width=$((screen_width / 3 * 2)) ;;
    -r )
        display_width=$((screen_width / 3)) ;;
esac

# Remember if it was maximized.
window_state=$(xprop -id $window_id _NET_WM_STATE | awk '{ print $3 }')

# Un-maximize current window so that we can move it
wmctrl -ir $window_id -b remove,maximized_vert,maximized_horz

# Read window position
x=$(xwininfo -id $window_id | awk '/Absolute upper-left X:/ { print $4 }')
y=$(xwininfo -id $window_id | awk '/Absolute upper-left Y:/ { print $4 }')

# Subtract any offsets caused by window decorations and panels
x_offset=$(xwininfo -id $window_id | awk '/Relative upper-left X:/ { print $4 }')
y_offset=$(xwininfo -id $window_id | awk '/Relative upper-left Y:/ { print $4 }')
x=$((x - x_offset))
y=$((y - y_offset))

# Fix Chromium app view issue of small un-maximized size
width=$(xdotool getwindowgeometry $window_id | awk -F" |x" '/Geometry:/ { print $4 }')
if [ "$width" -lt "150" ]; then
  display_width=$((display_width + 150))
fi

# Compute new X position
new_x=$((x + display_width))
# Compute new Y position
new_y=$((y + screen_height))

# If we would move off the right-most monitor, we set it to the left one.
# We also respect the window's width here: moving a window off more than half its width won't happen.
if [ $((new_x + width / 2)) -gt $screen_width ]; then
  new_x=$((new_x - screen_width))
fi

height=$(xdotool getwindowgeometry $window_id | awk -F" |x" '/Geometry:/ { print $5 }')
if [ $((new_y + height / 2)) -gt $screen_height ]; then
  new_y=$((new_y - screen_height))
fi

# Don't move off the left side.
if [ $new_x -lt 0 ]; then
  new_x=0
fi

# Don't move off the bottom
if [ $new_y -lt 0 ]; then
  new_y=0
fi

# Move the window
xdotool windowmove $window_id $new_x $new_y

# Maintain if window was maximized or not
if [ "${window_state}" = "_NET_WM_STATE_MAXIMIZED_HORZ," ]; then
    wmctrl -ir $window_id -b add,maximized_vert,maximized_horz
fi
```
3. chmod +x moveWindow.sh
4. application -> settings -> keyboard -> add
command: sh /home/tao/Documents/moveWindow.sh
shortcut: super + shift + o

经测试，在双屏显示中完美生效，多次按键相同窗口在左右显示屏中来回切换。
网上还有针对三屏显示器的改进脚本，这里不再记述。

## vmware 合并多个vmdk文件
vmware有个vmware-vdiskmanager工具, mac上的fusion中路径是
`/Applications/VMware\ Fusion.app/Contents/Library/vmware-vdiskmanager`
linux上的workstation是`/usr/bin/vmware-vdiskmanager --help`, help中有合并多个为一个的例子
`即 vmware-vdiskmanager -r source.vmdk -t 0 destination.vmdk`



<hr />
<img src="http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20190510_1.jpg" class="full-image" />
