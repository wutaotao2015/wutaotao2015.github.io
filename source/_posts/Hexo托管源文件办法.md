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
---
normal
#### 结语
---
end


1. 搞定source分支，实现hexo博客源码托管，新机器都可以更新博客。
由于源码这样被托管后，下面的主题theme就不能同时有自己的仓库了（这样对
主题包的修改无法push成功),所以需要另外建一个目录来获取最新的next主题,完后再把相应的包拷贝到theme包下。next主题的github地址为https://github.com/theme-next/hexo-theme-next.git
2. 在coding上也搭建一个服务器，国内服务器比github快，同时可以被百度收录,其中coding只需要部署master就行，
只在上面保留静态文件，hexo源文件只在github上保留，需要时直接从它上面拉取即可。
3. 搞完上面2件事就行，早点睡。如果快，就搞百度和谷歌收录
4. 七牛云上传文件外链
5. hexo markdown支持流程图插件
6. 如果还有时间，可以搞下自动部署，不过这样也只是省略了hexo d -g这一步？还得看看自动部署到底做了啥。
7. 文章阅读次数，文章字数统计
8. 访客地图

