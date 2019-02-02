---
title: Hexo源码托管
tags:
  - Hexo
categories: Hexo
image: http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/201901296.jpg
updated: 2019-01-25 14:39:16
abbrlink: 65f9a4be
date: 2019-01-25 14:39:16
---
<p class="description">hexo源码托管</p>
<!-- more -->

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

5. 因为我的源码之前托管到coding上了，所以也算迁移回github上，如果是全新的hexo项目，可以直接这样
```txt
git init
git remote add origin git@...
git checkout --orphan source
git add -A  // 所有文件,追踪和未追踪的
git commit -m "source"
git push -u origin source
```
6. 回到家，发现本地电脑还是blog的origin/master追踪着coding的master,进行一番尝试，最后也成功了。
```
git remote set-url origin git@...  // 切换到github仓库
git checkout -b source
git branch -u origin/source source
git branch -vv     // 查看当前分支追踪情况
git branch -a
git branch -d master
git remote set-url --add origin git@git...   // coding仓库
git remote -v
git pull
git push
```
<hr />
<img src="http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/201901296.jpg" class="full-image" />

