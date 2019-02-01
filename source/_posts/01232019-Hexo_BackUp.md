---
title: Hexo托管源文件办法
tags:
  - Hexo
  - Git
categories: Hexo
image: http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/201901295.jpg
abbrlink: 576ffe4
date: 2019-01-23 10:11:32
---
<p class="description">hexo源码管理</p>
<!-- more -->
#### 前言
---
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
    （后来试了一下，没有安装hexo,用`npm install -g hexo --save`运行了下，以后应该就只用npm install就行。
    注意： npm install可能速度较慢，可以挂上淘宝代理`npm config set registry https://registry.npm.taobao.org`
    5. 以后修改前也是先拉取源码`git pull`,`hexo n test`,write,`hexo s -g`本地调试,`git add . & git commit -m "" & git push`
    提交代码，`hexo d -g`部署到服务器上(最后这部可以用持续集成工具实现自动部署)
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
1月23日：
1. 今天把hexo的源码托管到coding上去了，可以在thinkpad上更新博客了，但是域名解析还没这么快，只能明天再看看效果，现在博客是404状态。
2. 发现coding上push了静态文件后，不像github一样有自动部署的功能，它需要手动部署，上网搜索发现它提供了一个webhook可以进行自动部署，还得看看怎么搞。不管持续集成省略了hexo d -g这一步，coding静态文件有更新都不能自动部署，在国内访问走的coding服务器，所以这个自动化还是必须要搞的,等域名解析出来以后再试试。
1月24日：
1. 昨晚部署到tencent dev服务器上，地址wutaotao.coding.me可以访问，域名解析等了很久都没好，后来发现它有一个持续集成的功能，
需要编写jenkinsfile，还没搞懂这个怎么写，用简易模块手动构建可以成功，但push代码代码却报找不到jenkinsfile的错误；又发现它有
一天只能构建20次的限制，现在觉得没什么，也还行，手动部署倒是没有限制，anyway,还是先把服务器放在github上，等其他博客的其他功能都
搞得差不多了，再迁移到国内来。

2月1日:
1. Hexo + Next主题优化受益最大也最靠谱的2个网站：
> [打造个性超赞Hexo](https://reuixiy.github.io/technology/computer/computer-aided-art/2017/06/09/hexo-next-optimization.html)
> [Hexo搭建博客2018心得汇总](https://zealot.top/Hexo-Github%E6%90%AD%E5%BB%BA%E8%87%AA%E5%B7%B1%E7%9A%84%E5%8D%9A%E5%AE%A22.html)

2. Hexo部署travis集成
> [Hexo + Travis](https://www.itfanr.cc/2017/08/09/using-travis-ci-automatic-deploy-hexo-blogs/)

3. 主题Next作为git module
> [git module1](http://saili.science/2017/04/02/github-for-win/#more)
> [git module2](https://segmentfault.com/a/1190000003076028)

git module是可以一个公共仓库在自己的项目下存在的解决方案，子项目在git操作上是完全独立的，
它在父项目中只是记录了一个commitId，当子项目提交(要记得推送)后，父项目会在`git status`中
检测到子项目的变化，这是父项目再进行提交加相当于更新了它保存的commitId,这样就实现了更新子
项目的目的。我之前已经把next文件夹的.git文件夹删除了以进行统一git管理，这时就只能另外建一个
新的子项目，内容拷贝到新项目后再将老的next主题包删除。

   1. 新建自己的next theme仓库

   2. 博客源目录下执行命令
   `git submodule add git@github:... themes/myNext`

   3. 拷贝文件
   `cp -r ../next/ ./`

   4. 推送到新仓库
   ```txt
   git add -A
   git commit -m 'my next theme'
   git push
   ```

   5. 添加原有的next theme为自己的仓库源
   `git remote add nextOrigin git@github...`

   6. 拉取最新的next theme代码，看看你有没有冲突！
   `git pull nextOrigin master`

   7. 推送到自己的主题库，别忘了还有父项目！！！
   ```txt
   git add .
   git commit -m 'next主题更新'
   git push
   blog
   git status
   git add .
   git commit -m 'next theme update'
   git push
   ```

4. travis对子模块的处理


<hr />
<img src="http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/201901295.jpg" class="full-image" />


