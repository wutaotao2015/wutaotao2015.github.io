---
title: Hexo博客搭建指南
tags: Hexo
categories: Hexo
image: http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/201901293.jpg
updated: 2019-02-05 21:22:03
abbrlink: 938b0578
date: 2019-01-22 21:51:18
---
<p class="description">hexo + github静态博客搭建</p>
<!-- more -->
## 需要材料
1. github账号及仓库
2. node.js
   (建议从官网上下载安装包安装，homebrew等下载速度太慢)
   安装好后用node -v查看是否安装成功
3. git
   安装好后用git --version查看是否安装成功

## 简易步骤
### 登录github创建仓库（username.github.io)
在本地生成公钥并上传到github上，输入命令
`ssh-keygen -t rsa -C "github注册邮箱地址"`

### 在本地任意目录下初始化博客，输入命令

`hexo init blog`

这样创建了目录blog,这就是博客的项目
hexo常用命令有

```txt
hexo clean  // 清楚缓存，网页正常可不用
hexo n maven源码解析 // new,新建文章，后面为题目，默认是md格式
hexo s -g   // 生成静态文件并启动本地服务，默认端口4000
hexo d -g   // 生成静态文件并发布到github仓库中
```
### 启动服务前需要修改blog根目录下的配置文件deploy选项
```txt
deploy:
type: git
repo: XXXX.github.io
branch: master
```
### 修改完配置文件并保存后，直接起服务hexo s报错
`deployer not found: git`
这是正常的，需要安装hexo部署到git的插件，命令为
`npm install hexo-deployer-git --save`

[七牛云批量获取文件外链接](https://developer.qiniu.com/kodo/kb/4072/batch-obtains-download-chain-method/)
[不同电脑更新博客](https://www.zhihu.com/question/21193762/)

昨天用来必力韩国棒子做的评论系统，手机上无法评论，弃用了。
今天换了valine,网上各种说好，用了也是报错，code 401找不到资源！之后发现是appid和appkey输完后还需要输入
一个**空格**!
完后又说安全域名的问题，我设置了啊，又是各种找，最后是仿照别人这样写的，加了个https吧
```txt
http://taoblog.cn
https://taoblog.cn
```
终于搞好了，真不容易，
太晚了，要睡了。
leanCloud还可以对评论进行后台管理，可以删除差评，这个以后有时间再搞搞。
[cleanCloud后管部署1](https://deserts.io/valine-admin-document/)
[valine后管部署2](https://deserts.io/diy-a-comment-system/)

明天把百度收录搞定。
另：今天发现typora显示的效果和实际部署页面的效果还是有差距的，markdown语法还是不一样，hexo应该还是
用的github支持的markdown语法，在网上又下了个haroopad编辑器，居然有我想要的vim输入模式，牛！
但是字体太小了，调整字体的快捷键option+U没有效果。。。。，用鼠标在标题栏上点个3次也
能看吧，vim模式确实很强，比typora好。

2019.2.2注：
今天在旧的电脑上又重新建立博客，原以为是很轻松的事情，毕竟之前在thinkpad上已经成功了一次，
但是还是折腾了一会儿，还是对安装hexo这个基本命令没有认识清楚。

1. 先完全卸载npm, node
> To completely uninstall node + npm is to do the following:
go to /usr/local/lib and delete any node and node_modules
go to /usr/local/include and delete any node and node_modules directory
if you installed with brew install node, then run brew uninstall node in your terminal
check your Home directory for any local or lib or include folders, and delete any node or node_modules from there
go to /usr/local/bin and delete any node executable
You may also need to do:
```txt
sudo rm -rf /opt/local/bin/node /opt/local/include/node /opt/local/lib/node_modules
sudo rm -rf /usr/local/bin/npm /usr/local/share/man/man1/node.1 /usr/local/lib/dtrace/node.d
```
> Additionally, NVM modifies the PATH variable in $HOME/.bashrc, which must be reverted manually.
Then download nvm and follow the instructions to install node. The latest versions of node come with npm, I believe, but you can also reinstall that as well.
```txt
node -v
npm -v
```

2. 官方文档推荐从官网下载安装包，就这样干吧！装在根目录下。

3. 之前已经用`git clone http://... --recursive`拉取了代码，所以我以为可以直接
在代码目录下`npm install`, 因为package.json中已经有hexo了，但是执行`hexo cl`
报`no command hexo`,所以我就紧接着在代码目录下执行`sudo npm install hexo-cli -g`,
但还是报一些相关权限的错误...

4. 最后发现不是代码目录，到根目录下执行`sudo npm install hexo-cli -g`成功！！

5. 这样看，Hexo还是要全局安装，不仅是执行用户，执行的目录环境也会影响到权限的问题。

6. 按以上步骤执行后发现后面执行`hexo cl`等命令时也需要sudo来执行，于是又返回根目录
去执行`sudo npm uninstall hexo-cli -g && npm install hexo-cli -g`,有权限报错，但是重启
终端后执行hexo命令无问题。

7. 经过以上折腾，第二天再查找，终于找对了npm的官网，上面有说改变npm默认全局目录来解决的，
不过感觉略麻烦，可以看看[Resoving EACCES permissions errors](https://docs.npmjs.com/resolving-eacces-permissions-errors-when-installing-packages-globally/),不过后来又找到了中文版的npm，
上面改变权限命令更直接[npm中文文档](https://www.kancloud.cn/shellway/npm-doc/199985/):
```txt
npm config get prefix   // output /usr/local
sudo chown -R $(whoami) $(npm config get prefix)/{lib/node_modules,bin,share} 
# -R 递归改变下属文件权限
```

### 测试图片上传
看看玛雅人的智慧，多霸气！
<div align="center">
    <img src="http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/maya.jpg" width="300" alt="No Picture, No NetWork"/>
</div>

下面就放下本人的玉照，就拿他当头像了！
<div align="center">
    <img src="http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/me.jpg" width="300" alt="No Picture, No NetWork"/>
</div>

目前是用了hexo-asset-image插件本地上传的图片，
正在申请七牛云图床，方便图片视频管理，以后再改动下。

2019-01-21加：

终于搞好了七牛图床问题，使用管理台只能单个上传文件，比较麻烦，而使用七牛云自己的命令行工具
qshell可以在本地进行批量上传操作，非常方便。
简记如下：

1. 下载qshell包

2. 将目录添加到环境变量

   > export PATH=$PATH:/home/qshell

3. 从七牛云管理台中获取账户密钥信息，AK,SK

   > 个人中心 —> 秘钥管理

   使用命令建立账号信息

   > qshell account  AK  SK accountName

   执行后，生成~/.qshell/目录，可以查看account.json有刚输入的账户信息，

   在该目录下新建upload.conf文件，输入如下配置信息

   ```json
   {
       "src_dir": "/stuff/localImageFolder",   # 图片存放的本地目录
       "bucket": "yourBucketName"             # 你的存储空间名
   }
   ```

   建好后就可以进行批量上传图片了

   > cd ~/.qshell/        # 切换到.qshell目录来使用上传配置文件upload.conf
   >
   > qshell qupload upload.conf

   OK，上传成功，赶紧到管理台看看成功没？在图片后方点击复制外链，愉快的粘贴到md文件中吧！

   参考[qshell gitHub地址](https://github.com/qiniu/qshell)，[qshell 使用指南](https://developer.qiniu.com/kodo/kb/1685/using-qshell-synchronize-directories)

4. 2019.1.24日补：
   上传完以后可以通过`qshell listbucket bucketname`来查看仓库里的图片列表， 判断是否上传成功。
   实际编写博客时，这样上传图片肯定很麻烦，我的thinkpad上装的是windows系统，用cmder来模拟
   linux终端操作，自带git, vim, grep, sed等命令，也是个神器， 研究了半天它的别名alias操作，
   最后发现非常简单。
   ```txt
   cd /d/cmder/config    # 到cmder安装目录下
   vi user_profile.sh
   
   # 在其中加入以下别名
   alias blog='cd /e/taoblogSource'
   alias post='cd /e/taoblogSource/source/_posts'
   alias img='cd /e/imageTmp/' 
   # 需要先清缓存
   alias upimg='cd /c/Users/LYPC/.qshell && rm -rf qupload/ 
     && qshell qupload /c/Users/LYPC/.qshell/upload.conf && echo "done"'
   alias sub='/d/SublimeText3/sublime_text.exe'
   alias ..='cd ..'
   function pull(){
     blog && git pull && echo "done"
   }
   function push(){
    blog && git add . && git commit -m "$1" && git push && echo "done"
   }
   alias pub='hexo cl && hexo d -g && echo "done"'
   alias next='cd /e/taoblogSource/themes/next'
   # local是关键字
   function loc(){
     blog && hexo cl && hexo s -g
   }
   ```
   设置好以后，windows重启cmder,mac需要执行source命令来启用别名。
   这样以后写博客可以这样

   1. post

   2. hexo n postname
      这里修改下新建post的默认模板
      ```
      blog
      cd scaffolds/
      vi post.md
      ```

   3. 写完后用`hexo s -g`查看效果

   4. push

   5. pub

5. 可以用`hexo list post`查看所有博客基本情况

6. 修改配置文件中的new_post_name来默认新的post的文件名，可以默认为月日年-名字.md

7. 提交注释有空格时用单引号括起来`push 'comment space'`

8. git在windows和mac系统的换行符问题
> Git can handle this by auto-converting CRLF line endings into LF when you add a file to 
the index, and vice versa when it checks out code onto your filesystem. You can turn on 
this functionality with the core.autocrlf setting. If you're on a Windows machine, set it 
to true – this converts LF endings into CRLF when you check out code:
`$ git config --global core.autocrlf true`
If you're on a Linux or Mac system that uses LF line endings, then you don't want Git to 
automatically convert them when you check out files; however, if a file with CRLF endings 
accidentally gets introduced, then you may want Git to fix it. You can tell Git to convert 
CRLF to LF on commit but not the other way around by setting core.autocrlf to input:
`$ git config --global core.autocrlf input`

9. git的大小写问题
windows和Mac系统都是大小写不敏感的系统，Hexo在生成tags和categories文件时如果后来修改了文件
夹名字就会报404错误。一般可以用`git add -A`解决，这里可以用
`$ git config core.ignorecase false`
来使git支持大小写，并可以使用`git mv -f oldname newname`来实现大小写的更改，同时该命令会
将文件暂存起来,可以通过git status发现只有旧文件已经被删除的信息，这时通过commit可以将新
文件提交成功。

10. 排版问题，给vim设置`set colorcolumn=90`

11. git命令
```txt
git diff   // workspace and index's diff
git diff head  // workspace and repo's diff
git diff --cached  // index and repo's diff
git diff --name-only  // show the changed file names
git diff <system file path>  // show the file's diff
git checkout <system file path>  // get stashed file to workspace
git revert head   // 重做上一次commit
```
12. 七牛云测试域名1个月就要回收了，本想转又拍云，但是它需要植入广告，云服务器控制台又太挫
了，搞了搞还是算了，转OSS!下面是一些简单命令：
```txt
# 上传
./ossutilmac64 cp -r stuff/image oss://wutaotaospace/image/

# 查看图片列表
./ossutilmac64 ls oss://wutaotaospace/image/
```

13. 统一将七牛外链替换为oss命令：
```txt
#  sed -i "s#old#new#g" `grep old -rl ./`

sed -i "s #http://ploojkqh4.bkt.clouddn.com/
#http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/#g" 
`grep http://ploojkqh4.bkt.clouddn.com/ -rl ./`
```

14. vim配置
```txt
set colorcolumn=90
map <leader>t i<Space><C-R>=strftime("\%Y-\%m-\%d \%H:\%M:\%S")<CR><Esc>

autocmd BufWrite,BufWritePre *.md ks|call LastModified()|'s
func LastModified()
    if line("$") > 20
        let l = 20
    else
        let l = line("$")
    endif
    exe "1,".l."g/updated: /s/updated: .*/updated:".
        \strftime(" \%Y-\%m-\%d \%H:\%M:\%S" ) . "/e"
endfunc'
```

### Hexo源码托管
1. 实现hexo博客源码托管，新机器都可以更新博客。
网上有教程说在hexo部署的github仓库下新建一个分支来管理源码，但是这样配置文件中的key都泄露出去了，还是不好， github私有仓库收费，所以还是在腾讯开发平台（coding)上新建了一个私有仓库来管理源码。
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

4. travis对子模块的处理, 在CIShell脚本中加入--recurse-submodules同步拉取主题更新！
`git clone --recursive http://.. .deploy`


5. 经过上面的子模块操作后，next主题文件夹的名字变成了MyNext,导致hexo s -g进去直接白屏，
报没有index的错，原来想直接`mv MyNext next`,发现它不是一个git仓库了，好吧，想一想又跑去改
站点配置文件_config中的theme配置项为MyNext,成功了！

6. 前面我是先新建了一个自己的next theme仓库，再用git submodule add https://... themes/MyNext
来建立子模块，结果发现没有教程中说的.gitmodules文件产生，后来反应过来应该是这个新的远程仓库
的问题导致的，不过即使这样，MyNext也和新仓库建立了联系，我已将本地代码冲突解决后提交到远程仓库，
这时只要将产生的.git/modules/下和themes/MyNext包删除，推送后，再使用`git submodule add`命令
即可以产生.gitmodules, .git/config, .git/modules/这3个变动的文件，再add, commit, push即可成功
产生子模块。

7. 在父项目中用`git status`看不到子模块的变化，可以用命令来显示相关信息：
`git config --global status.submoduleSummary true`
参考来源[Mastering Git submodules](https://medium.com/@porteneuve/mastering-git-submodules-34c65e940407)

8. git submodules常用命令
```txt
# add
git submodule add https://... ./sub
cd ..
git add . && git commit -m 'add new submodule' && git push


# clone
git clone --recursive https://...   //  whole has not been cloned
git submodule upate --init         // whole has been cloned

# modify
cd ./module
git add . && git commit -m 'update submodule' && git push
cd ..
git status
git commit -m 'submodule has been updated'
git push

# update
git submodule foreach git pull
git submodule foreach --recursive git pull   // many submodules recursive existed 

# delete(whole code delete)
git submodule deinit -f -- ./submodule
rm -rf .git/modules  
git rm -f ./submodule    // this command delete both worktree and index,--cached only index
git add . &&  git commit -m 'delete submodule'

# delete(remove the submodule but code remains as common folder)
mv ./submodule ./subTmp
git submodule deinit -f -- ./submodule
rm -rf .git/modules  
git rm --cached ./submodule  // only delete cache, files remains
mv ./subTmo ./submodule

# delete explanation
git submodule deinit   // change the .git/config
git rm                 // change the .gitmdules
rm -rf .git/modules    // manual delete .git/modules
```
[stack overflow git delete submodule](https://stackoverflow.com/questions/1260748/how-do-i-remove-a-submodule)

9. 发现travis生成的文章的修改时间都是当前时间，应该是travis的集成环境影响到了渲染生成的
html更新时间的缘故，开始想成了是travis部署脚本的问题，后来发现并没有关系，它只是移动了一个
.git文件夹，并没有移动其他文件，而且生成后的html文件时间都固定了......无论如何，搜索文章
这个更新时间updated是记录在db.json文件里的一个update参数，travis是每次都是全新的环境，这样
每篇文章都是最新的了，所以这样我们可以在post模版中手动添加updated参数，这样就不用依赖db.json
来记录更新时间了。同时文章修改的具体时间直接修改站点配置文件即可
`date_format: YYYY-MM-DD HH:mm:ss`

10. 使用发现手动增加updated标签值相当于写死了更新时间，所以还是需要手动修改，可以用vim的
键位映射,我设置成,t来生成。
`map <leader>t i<C-R>=strftime("\%Y-\%m-\%d \%H:\%M:\%S")<CR><Esc>`



### coding上已有私有库，再切换回github上
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
<img src="http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/201901293.jpg" class="full-image" />

