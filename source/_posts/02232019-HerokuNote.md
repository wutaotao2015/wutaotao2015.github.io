---
title: Heroku笔记
categories: Heroku
tags:
  - Heroku
  - JDK与JRE
  - Path Variable
  - PostgreSQL
image: 'http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/201901312.jpg'
abbrlink: fe2ee907
updated: 2019-02-27 23:17:13
date: 2019-02-23 21:03:08
---
Heroku学习笔记, JDK与JRE, clean add path variable(环境变量),PostgreSQL
<!-- more -->

相关文档
> [Heroku with Java](https://devcenter.heroku.com/articles/getting-started-with-java?singlepage=true/)

## 创建Heroku账号

在[Heroku官网](https://signup.heroku.com/login)注册即可，需要注意的是qq邮箱和网易邮箱等都
不支持，所以这里我用的是gmail邮箱，密码是字母，数字和特殊字符混合。
要求的jdk8，maven3已满足条件。
## 安装Heroku Command Line Interface(CLI)
> $ brew install heroku/brew/heroku

## 用Heroku的例子来练手
下载了Heroku的例子，在它的github页面上说clone完以后可以直接这样做:
> $ mvn install
> $ heroku local

结果在执行最简单的`mvn install`时报错`Maven Error: Perhapss you are Running on a JRE rather
than a JDK`,无语,用`mvn -v`查看始终是那个plugin的jre目录，网上说的设置JAVA_HOME环境变量
无效，还好最后发现了这个解决方案,在`$HOME/.mavenrc`文件中写入
> JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_201.jdk/Contents/Home

搞定！
## JDK和JRE的区别:
> 1.JVM -- java virtual machineJVM就是我们常说的java虚拟机，
它是整个java实现跨平台的最核心的部分，所有的java程序会首先被编译为.class的类文件，
这种类文件可以在虚拟机上执行，也就是说class并不直接与机器的操作系统相对应，
而是经过虚拟机间接与操作系统交互，由虚拟机将程序解释给本地系统执行。
2.JRE -- java runtime environmentJRE是指java运行环境。
光有JVM还不能成class的执行，因为在解释class的时候JVM需要调用解释所需要的类库lib。
在JDK的安装目录里你可以找到jre目录，里面有两个文件夹bin和lib,在这里可以认为bin里的就是jvm，
lib中则是jvm工作所需要的类库，而jvm和 lib和起来就称为jre。所以，
在你写完java程序编译成.class之后，你可以把这个.class文件和jre一起打包发给朋友，
这样你的朋友就可以运行你写程序了。（jre里有运行.class的java.exe）
3.JDK -- java development kitJDK是java开发工具包，基本上每个学java的人都会先在机器上
装一个JDK，那他都包含哪几部分呢？让我们看一下JDK的安装目录。在目录下面有六个文件夹、
一个src类库源码压缩包、和其他几个声明文件。其中，
真正在运行java时起作用的是以下四个文件夹：bin、include、lib、 jre。
现在我们可以看出这样一个关系 JDK包含JRE，而JRE包含JVM。bin:最主要的是编译器(javac.exe),
include: java和JVM交互用的头文件, lib：类库, jre:java运行环境
（注意：这里的bin、lib文件夹和jre里的bin、lib是不同的）
总的来说JDK是用于java程序的开发,而jre则是只能运行class而没有编译的功能。
eclipse、idea等其他IDE有自己的编译器而不是用JDK bin目录中自带的，
所以在安装时你会发现他们只要求你选中jre路径就ok了。

注：查看path变量时发现有很多重复的路径，但我只有.bash_profile中定义了path变量，后来发现是多次
source .bash_profile文件它多次追加上去的，重启终端就可以看见没有重复的了，网上有个简单的
方法可以判断path是否已经包含该路径，若没有，才进行追加。
## 干净添加环境变量
```txt
add() { case ":${PATH:=$1}:" in *:$1:*) ;; *) PATH="$1:$PATH" ;; esac; }
add $JAVA_HOME
```

经过以上步骤以后，可以在`localhost:5000`上看到Heroku的例子,
接着按其README.md步骤走：
```txt
heroku create # 在heroku上创建了一个仓库并且建立了远程分支heroku的追踪关系 
git push heroku master  # 推送代码到heroku分支
heroku open # 自动打开浏览器
```
这时可以看见在heroku域名上app发布运行了。
可以用以下命令查看一些app信息：
```txt
$ heroku config  # 查看配置的环境变量 这里显示的是实际的databaseURL，amazon的
$ heroku addons  # 相关插件，看到自动配了一个postgresql数据库
$ heroku open db   # 最后的db是项目目录后追加的路径，功能是访问一次就追加一条记录。
$ heroku pg      # show database information
```

## 自己的项目发布到Heroku
这里用于实验是springboot实战一书的例子，使用h2数据库，用Thymeleaf展示一个读书列表的页面，
已经同步到github上，下面来改造并部署到heroku上。
1. 项目根目录下新建system.properties文件
> java.runtime.version=1.8

2. 项目根目录下新建Procfile文件和app.json文件
> web: java -jar target/XXX-YYY.jar   # web代表接受外面的http请求

app.json中写明app名字，描述和使用的addon信息。

3. 创建heroku app,这一步主要是创建heroku的git仓库。
> $ heroku create appname
> $ mvn install 
> $ heroku local

4. 推送到heroku的仓库并打开页面访问app
> $ git push heroku master
> $ heroku open

Done!
### heroku发布后出问题时版本回退办法
> $ heroku releases   # 查看发布版本记录
> $ heroku releases:rollback v102  # v102改成相应版本记录

这里也就是说不管是改动代码(code),环境配置(config vars),插件(add-ons)都会产生一个新的release。

### Addons
Dyno可以看成是一个文件系统中包含了release的虚拟unix容器，比如说可以有3个web,2个queue的
dyno,具体情况通过`heroku ps`查看。
因为各个Dyno之间的文件状态是隔绝的，所以可以通过addOn来进行Dyno之间的通信，比如web Dyno
存储数据到数据库的addon中，queue Dyno可以从数据库addon中查询数据来进行操作。
> 通过hello的例子可以看出，addons信息配置在根目录下的app.json文件里。

### logging and monitoring
所有dyno的所有进程的信息会汇聚到一个高性能日志系统logplex中，使用命令
> $ heroku logs

查看所有dyno的日志信息,如包括router路由，web1,web2等,可以只查看某个dyno日志
> $ heroku logs --ps web.1 --tail   # --tail可以实时更新日志 

多个web dyno可以实现负载均衡。
> heroku ps:scale web+5

```txt
A single dyno runs a single instance of a process type (which itself can then spawn 
and manage several sub-processes). 
```

5. 将h2数据库改造成postgresql
## PostgreSQL

<hr />
<img src="http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/201901312.jpg" class="full-image" />
