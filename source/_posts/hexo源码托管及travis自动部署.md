---
title: hexo源码托管及travis自动部署
date: 2019-01-25 14:39:16
tags: hexo,travis
categories: hexo
---
{% img full-image http://ploojkqh4.bkt.clouddn.com/maya.jpg 180 180 hello %}
hexo源码托管,travis集成来省去hexo d -g部署步骤
<!-- more -->

**因为travis只支持github,本地部署`hexo d -g`较慢,所以还是得改造**

coding上已有私有库，再切换回github上
```txt
git remote -v
git remote set-url origin https://github.com/wutaotao2015/wutaotao2015.github.io.git
```

在本地新建已有的源码分支
```txt
git checkout -b source
git branch -a
git push origin --all
```
在github上设置source为默认分支
再把本地的master删除
`git branch -d master`
(删除远程分支 `git push origin --delete remotebranchname`)

添加多个远程仓库

1. `git remote add coding https://...`
	pull和push都可以
2. `git remote set-url --add github https://...`  # 给远程仓库加上了push的url,fetch没变，
可以在.git/config中看到remote的情况
3. coding中的分支为master,与本地source不一样，这样最好办法还是在coding管理台上新建分支source,再把master删除最好
4. 添加多仓库后，默认的git pull不行了
需要追踪
`git branch -u origin/source source`
最后，执行`git branch -a`看到remotes/origin/head指向的是origin/master,因为origin/master只是本地一个副本，
可以用`git remote set-head origin source`即可修改。

#### 因为我的源码之前托管到coding上了，所以也算迁移回github上，如果是全新的hexo项目，可以直接这样
```txt
git init
git remote add origin git@...
git checkout --orphan source
git add -A  // 所有文件,追踪和未追踪的
git commit -m "source"
git push -u origin source
```
