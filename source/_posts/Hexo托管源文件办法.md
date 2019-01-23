---
title: Hexo托管源文件办法
date: 2019-01-23 10:11:32
tags: [Hexo,Git]
categories: 学习
toc: true
mathjax: true
---
[TOC]
#### 前言
---
preface
#### 正文
1. 实现hexo博客源码托管，新机器都可以更新博客。
网上有教程说在hexo部署的github仓库下新建一个分支来管理源码，但是这样配置文件中的key都泄露出去了，还是不好，
github私有仓库收费，所以还是在腾讯开发平台（coding)上新建了一个私有仓库来管理源码。
主要步骤为
	1. 删除theme下主题的.git/文件夹内容，防止影响push,同一个git仓库下不能有2个.git配置文件。
	2. 在源码hexo目录下执行`git init`命令生成git仓库环境
	3. 再push到刚建立的私有仓库
	```txt
    	git remote add origin https://git地址
        git add .
        git commit -m "hexo source code"
        git push -u origin master   // -u是将当前分支追踪到origin主机master分支
    ```
    4. 新电脑先clone代码到本地，再npm install一下就可以发布了。
    5. 以后修改前也是先拉取源码再进行修改。
	6. 由于源码这样被托管后，下面的主题theme就不能同时有自己的仓库了（这样对主题包的修改无法push成功),所以需要另外建一个目录来获取最新的next主题,完后再把相应的包拷贝到theme包下来实现更新。next主题的github地址为https://github.com/theme-next/hexo-theme-next.git
2. 在coding上也搭建一个服务器，国内服务器比github快，同时可以被百度收录
3. 搞完上面2件事就行，早点睡。如果快，就搞百度和谷歌收录
4. 七牛云上传文件外链
5. hexo markdown支持流程图插件
6. 如果还有时间，可以搞下自动部署，不过这样也只是省略了hexo d -g这一步？还得看看自动部署到底做了啥。
7. 文章阅读次数，文章字数统计
8. 访客地图
---
#### 结语
---
1. 1月23日：今天把hexo的源码托管到coding上去了，可以在thinkpad上更新博客了，但是域名解析还没这么快，只能明天再看看效果，现在博客是404状态。
2. 发现coding上push了静态文件后，不像github一样有自动部署的功能，它需要手动部署，上网搜索发现它提供了一个webhook可以进行自动部署，还得看看怎么搞。不管持续集成省略了hexo d -g这一步，coding静态文件有更新都不能自动部署，在国内访问走的coding服务器，所以这个自动化还是必须要搞的,等域名解析出来以后再试试。





















