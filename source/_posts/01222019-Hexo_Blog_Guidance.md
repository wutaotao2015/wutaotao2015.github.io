---
title: Hexo博客搭建指南
tags: Hexo
categories: Hexo
image: http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/201901293.jpg
updated: 2019-02-03 11:00:48 
abbrlink: 938b0578
date: 2019-01-22 21:51:18
---
<p class="description">hexo + github静态博客搭建</p>
<!-- more -->
#### 需要材料
1. github账号及仓库
2. node.js
   (建议从官网上下载安装包安装，homebrew等下载速度太慢)
   安装好后用node -v查看是否安装成功
3. git
   安装好后用git --version查看是否安装成功

#### 简易步骤
##### 登录github创建仓库（username.github.io)
在本地生成公钥并上传到github上，输入命令
`ssh-keygen -t rsa -C "github注册邮箱地址"`

##### 在本地任意目录下初始化博客，输入命令

##### `hexo init blog`

这样创建了目录blog,这就是博客的项目
hexo常用命令有

```txt
hexo clean  // 清楚缓存，网页正常可不用
hexo n maven源码解析 // new,新建文章，后面为题目，默认是md格式
hexo s -g   // 生成静态文件并启动本地服务，默认端口4000
hexo d -g   // 生成静态文件并发布到github仓库中
```
##### 启动服务前需要修改blog根目录下的配置文件deploy选项
```txt
deploy:
type: git
repo: XXXX.github.io
branch: master
```
##### 修改完配置文件并保存后，直接起服务hexo s报错
`deployer not found: git`
这是正常的，需要安装hexo部署到git的插件，命令为
`npm install hexo-deployer-git --save`

##### 更换主题
##### 添加评论功能
##### 添加阅读次数
##### 打开标签等其他功能
##### 增加点赞功能
##### 文章字数统计
##### 头像显示
##### 收录到百度和谷歌
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


<hr />
<img src="http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/201901293.jpg" class="full-image" />

