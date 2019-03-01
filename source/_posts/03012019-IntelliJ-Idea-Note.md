---
title: IntelliJ Idea 简明笔记
categories: Tool
tags:
  - IntelliJ Idea
image: 'http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20190301_1.jpg'
updated: 2019-03-01 18:03:59
date: 2019-03-01 10:21:17
abbrlink:
---
IntelliJ Idea Note
<!-- more -->
## 安装
![20190301_2](C:\Users\LYPC\AppData\Roaming\Typora\typora-user-images\20190301_2.jpg)
![20190301_3](C:\Users\LYPC\AppData\Roaming\Typora\typora-user-images\20190301_3.jpg)
![20190301_4](C:\Users\LYPC\AppData\Roaming\Typora\typora-user-images\20190301_4.jpg)
![20190301_5](C:\Users\LYPC\AppData\Roaming\Typora\typora-user-images\20190301_5.jpg)
![20190301_6](C:\Users\LYPC\AppData\Roaming\Typora\typora-user-images\20190301_6.jpg)
注册激活码，如果失效去这个网站获取[http://idea.lanyus.com/](http://idea.lanyus.com/)
![20190301_7](C:\Users\LYPC\AppData\Roaming\Typora\typora-user-images\20190301_7.jpg)
## 导入项目
1. 新建一个文件夹，可以命名为ideaWorkspace(已经有父子模块项目关系的可以直接open即可)
2. 将需要导入的项目文件夹拷贝到里面
3. open该工作空间文件夹
4. 设置成maven项目
![20190301_9](C:\Users\LYPC\AppData\Roaming\Typora\typora-user-images\20190301_9.jpg)
![20190301_10](C:\Users\LYPC\AppData\Roaming\Typora\typora-user-images\20190301_10.jpg)
到此项目就算导入完成了。

Idea中没有workspace的概念，它顶级目录叫Project,次级目录是Module,每个project都有自己的
.idea文件夹。

## 设置
1. 设置jdk
![20190301_11](C:\Users\LYPC\AppData\Roaming\Typora\typora-user-images\20190301_11.jpg)
![20190301_12](C:\Users\LYPC\AppData\Roaming\Typora\typora-user-images\20190301_12.jpg)
到这里就可以直接运行项目了。
![20190301_13](C:\Users\LYPC\AppData\Roaming\Typora\typora-user-images\20190301_13.jpg)

2. 修改字体大小
![20190301_14](C:\Users\LYPC\AppData\Roaming\Typora\typora-user-images\20190301_14.jpg)

3. 修改文件编码
![20190301_15](C:\Users\LYPC\AppData\Roaming\Typora\typora-user-images\20190301_15.jpg)
注：如果Tomcat 控制台输出乱码，并且控制台字体设置的字体包含中文，可以在 Tomcat 的 VM 
参数上加上：-Dfile.encoding=UTF-8
![20190301_16](C:\Users\LYPC\AppData\Roaming\Typora\typora-user-images\20190301_16.jpg)

4. 清楚缓存和索引
Idea利用缓存和索引来加快搜索查询的速度，但有时也会出现问题，这时可以清除缓存来解决问题：
![20190301_17](C:\Users\LYPC\AppData\Roaming\Typora\typora-user-images\20190301_17.jpg)
一般选择第一个就可以，清除并重启，这里实际上就是删除了system文件夹，可以手动删除，重启
Idea它会自动创建新的system文件夹，system路径位于自己的用户目录下：
> /c/Users/LYPC/.IntelliJIdea2018.3/system

5. 自动编译
因为自动编译比较耗费资源，所以idea默认没有开启自动编译，可以手动设置：
![20190301_18](C:\Users\LYPC\AppData\Roaming\Typora\typora-user-images\20190301_18.jpg)
注意：这里的自动编译不是保存后自动编译，而是在编辑器里输入代码的时候自动编译，
所以比较耗费资源，可以用快捷键`ctrl + F9`来进行项目编译。

## 常用快捷键
idea默认快捷键查看及修改地址：
![20190301_8](C:\Users\LYPC\AppData\Roaming\Typora\typora-user-images\20190301_8.jpg)
在设置前，应注意快捷键冲突，关掉搜狗输入法等的快捷键。
```txt
ctrl + f,z,c,x,/  功能不变: 搜索，撤销，复制，剪切,粘贴, 注释
ctrl + shift + z  恢复撤销，相当于前进
ctrl + r  替换
ctrl + y  删除光标所在行 或 选中的行
ctrl + d  复制当前行并粘贴到下一行 或 复制选中内容并粘贴到光标后
ctrl + w  智能选择代码块
ctrl + e  最近打开的文件列表
ctrl + n  搜索类文件
ctrl + p  方法参数提示
ctrl + q  显示光标所在变量，类名，方法名上的文档内容
ctrl + u  显示光标所在方法的父类方法或接口定义
ctrl + b  等同于ctrl+鼠标左键，进入方法或变量定义处
ctrl + o  选择可重写的方法
ctrl + I  选择可继承的方法
ctrl + F4 关闭当前编辑文件
ctrl + F9  make project编译项目
ctrl + tab  切换到前一个编辑器窗口，多次按是在2个tab间循环
ctrl + space  这个windows系统上时切换输入法，可修改为ctrl + ; 表示基本代码补全
ctrl + delete  删除光标后单词或中文句
ctrl + backspace  删除光标前单词或中文句
ctrl + 左方向键   光标跳到左侧单词开头
ctrl + 右方向键  光标跳到右侧单词开头
ctrl + 上/下    等同于鼠标上下滚动
ctrl + + 展开代码
ctrl + - 折叠代码

alt + enter   智能辅助，跟据位置不同提示结果不同，可用于生成get/set方法，生成接口或实现类，
              还可以进行重构
alt + insert  同eclipse,生成set/get,constructor,toString()等
alt + 左方向键  前一个编辑器tab
alt + 右方向键  后一个编辑器tab
alt + 1        显示project视图

shift + tab  取消缩进

ctrl + alt + l  格式化代码，可以对当前文件或整个包目录使用
ctrl + alt + o  优化import的包
ctrl + alt + t  对选中代码弹出环绕层，有if/else, try/catch等
ctrl + alt + c  重构：快速提取当前类常量
ctrl + alt + f  重构：快速提取当前类成员变量
ctrl + alt + v  重构: 快速提变变量
ctrl + alt + enter  光标所在行上空出一行，光标定位到新行
ctrl + alt + s     打开idea setting 设置
ctrl + alt + 左   退回上一个操作地方
ctrl + alt + 右   前进到上一个操作地方
ctrl + alt + [    打开多个项目时，跳到上一个项目窗口
ctrl + alt + ]    打开多个项目时，跳到下一个项目窗口

ctrl + shift + f   查找整个项目或指定目录内文件
ctrl + shift + r   替换内容 整个项目或指定目录
ctrl + shift + j   将下一行合并到当前行末尾
ctrl + shift + w   与ctrl+w配合使用，是递进取消选择单词
ctrl + shift + n   打开文件或目录
ctrl + shift + u   选中代码大小写切换
ctrl + shift + t   对当前类生成单元测试类
ctrl + shift + c   复制当前文件路径到剪贴板
```
inject language

注：如习惯vim操作，可以下载插件IdeaVim
![20190301_19](C:\Users\LYPC\AppData\Roaming\Typora\typora-user-images\20190301_19.jpg)
安装后重启，设置开关vim模式快捷键,默认ctrl+alt+v,改成F1,同时把context help的remove掉。
![20190301_20](C:\Users\LYPC\AppData\Roaming\Typora\typora-user-images\20190301_20.jpg)




<hr />
<img src="http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20190301_1.jpg" class="full-image" />
