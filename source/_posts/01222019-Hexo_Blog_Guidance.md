---
title: Hexo博客搭建指南
tags: Hexo
categories: Hexo
image: http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/201901293.jpg
updated: 2019-01-22 21:51:18
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
<hr />
<img src="http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/201901293.jpg" class="full-image" />

