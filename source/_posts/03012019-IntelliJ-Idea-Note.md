---
title: IntelliJ Idea 简明笔记
categories: Tool
tags:
  - IntelliJ Idea
image: 'http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20190301_1.jpg'
abbrlink: 481236cd
updated: 2019-03-17 22:37:16
date: 2019-03-01 10:21:17
---
IntelliJ Idea Note
<!-- more -->
[Idea教程https://github.com/judasn/IntelliJ-IDEA-Tutorial/](https://github.com/judasn/IntelliJ-IDEA-Tutorial/)

操作系统: win7 64位
Idea版本: 2018.3.5 (2019.1在beta中)
## 安装
![20190301_2](http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20190301_2.jpg)
![20190301_3](http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20190301_3.jpg)
![20190301_4](http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20190301_4.jpg)
![20190301_5](http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20190301_5.jpg)
![20190301_6](http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20190301_6.jpg)
注册激活码，如果失效去这个网站获取[http://idea.lanyus.com/](http://idea.lanyus.com/)
![20190301_7](http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20190301_7.jpg)
## 导入项目
1. 新建一个文件夹，可以命名为ideaWorkspace(已经有父子模块项目关系的可以直接open即可)
2. 将需要导入的项目文件夹拷贝到里面
3. open该工作空间文件夹
4. 设置成maven项目
![20190301_9](http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20190301_9.jpg)
![20190301_10](http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20190301_10.jpg)
到此项目就算导入完成了。

Idea中没有workspace的概念，它顶级目录叫Project,次级目录是Module,每个project都有自己的
.idea文件夹。

## 设置
1. 设置jdk
![20190301_11](http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20190301_11.jpg)
![20190301_12](http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20190301_12.jpg)
到这里就可以直接运行项目了。
![20190301_13](http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20190301_13.jpg)

2. 修改字体大小
![20190301_14](http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20190301_14.jpg)

3. 修改文件编码
![20190301_15](http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20190301_15.jpg)
注：如果Tomcat 控制台输出乱码，并且控制台字体设置的字体包含中文，可以在 Tomcat 的 VM 
参数上加上：-Dfile.encoding=UTF-8
![20190301_16](http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20190301_16.jpg)

4. 清楚缓存和索引
Idea利用缓存和索引来加快搜索查询的速度，但有时也会出现问题，这时可以清除缓存来解决问题：
![20190301_17](http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20190301_17.jpg)
一般选择第一个就可以，清除并重启，这里实际上就是删除了system文件夹，可以手动删除，重启
Idea它会自动创建新的system文件夹，system路径位于自己的用户目录下：
> /c/Users/LYPC/.IntelliJIdea2018.3/system

5. 自动编译
因为自动编译比较耗费资源，所以idea默认没有开启自动编译，可以手动设置：
![20190301_18](http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20190301_18.jpg)
注意：这里的自动编译不是保存后自动编译，而是在编辑器里输入代码的时候自动编译，
所以比较耗费资源，可以用快捷键`ctrl + F9`来进行项目编译。

## 常用快捷键
idea默认快捷键查看及修改地址：
![20190301_8](http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20190301_8.jpg)
在设置前，应注意快捷键冲突，关掉搜狗输入法等的快捷键。
```txt
windows版：

搜索：
ctrl + shift + n   查找文件Files  相当于eclipse ctrl + shift + r 可改为ctrl+shift+o
ctrl + shift + f   查找整个项目或指定目录内文件,相当于eclipse ctrl + h
ctrl + e  最近打开的文件列表->列表大小可调->在settings->editor->general->limits->recent files limit
ctrl + shift + e   最近修改文件列表
ctrl + shift + v   拷贝历史记录板
ctrl + F12   显示文件结构，相当于eclipse ctrl + o
ctrl + f  当前文件搜索

窗口处理：
ctrl + alt + s     打开idea setting 设置
alt + 1            显示project视图
alt + 2      # 收藏夹
ctrl + F4          关闭当前编辑文件 
ctrl + shift + F12 最大化编辑器

tab可以多行显示或只显示一个tab,在settings->editor->General->Editor tabs->placement

光标选择：
ctrl + w  智能选择代码块
ctrl + shift + w   与ctrl+w配合使用，是递进取消选择单词
ctrl + alt + 左   退回上一个操作地方  可以改成alt + [
ctrl + alt + 右   前进到上一个操作地方  可以改成alt + ]
ctrl + shift + backspace   退回上次修改的地方
F2  跳转到下一个错误或警告位置
shift + F2   上一个错误
ctrl + b   navigate-declaration  类的定义或变量的使用处显示
ctrl + alt + b   navigate-implementations 接口或抽象方法实现
ctrl + u    super method  父类方法

编辑：
ctrl + z,c,x,/  功能不变: 搜索，撤销，复制，剪切,粘贴, 注释
ctrl + shift + z  恢复撤销，相当于前进
ctrl + r  替换
ctrl + y  删除光标所在行 或 选中的行
ctrl + d  复制当前行并粘贴到下一行 或 复制选中内容并粘贴到光标后,可以改成粘贴到下一行而不是
            光标后，修改为duplicate entire lines
ctrl + alt + l  格式化代码，可以对当前文件或整个包目录使用
ctrl + alt + t  对选中代码弹出环绕层，有if/else, try/catch等
ctrl + shift + /   代码块注释
ctrl + alt + o  优化import的包
alt + shift + 上   当前行向上移动一行
alt + shift + 下   当前行向下移动一行

代码提示：
ctrl + space  这个windows系统上时切换输入法，可修改为ctrl + ; 表示基本代码补全
ctrl + shift + space   智能代码补全 可改为ctrl + shift + ;
ctrl + shift + enter   代码自动收尾，可生成if语句等
alt + enter   智能辅助，跟据位置不同提示结果不同，可用于生成get/set方法，生成接口或实现类，
              还可以进行重构
alt + insert  同eclipse,生成set/get,constructor,toString()等

postfix code completion:  for,nn,null,var #settings->editor->general->postfix completion

重构：
shift + F6       重构: 重新命名
ctrl + shift + r   替换内容 整个项目或指定目录
ctrl + alt + m   重构: 提取方法

其他：
ctrl + F9       make project编译项目
ctrl + shift + F9  重新编译 
alt + shift + f    加入到收藏夹中


mac 版：
option->alt

搜索：
command + shift + o  #  navigate File... 
command + shift + f   # find in path    
command + e          #   recent files   
command + shift + e   # recently changed files 
command + shift + v   # paste from history 
command + F12        #   file structure   
command + f          #   edit: Find find 

窗口处理：
command + ,      # file setting      $$ ctrl-alt-s
command + 1      # tool windows Project  $$ alt-1
command + 2      # favourite window   $$ alt-2
command + w      # editor tabs close  $$ ctrl-F4 window-w
command + shift + F12 # hide all tool windows

光标选择：
alt + up          #   extend selection  $$ ctrl-w
alt + down   # shrink selection        $$ ctrl-shift-w
command + [     # navigation back      $$ alt-[
command + ]     # navigation forward   $$ alt-]
command + shift + backspace # last edit location
F2  # next highlighted error

编辑：
command + z,c,x,/    #   find,undo,copy,cut,comment
command + shift + z  #   redo
command + r          #   replace
command + backspace  #   delete line  $$ ctrl-y
command + d          #   duplicate lines
command + alt + l  # reformat code
command + alt + t  # code surround with
ctrl + shift + /     # comment with block comment %同windows command+shift+/有help同时出现
ctrl + alt + o     # optimize imports             %同windows
alt + shift + up  # code move line up             %同windows
alt + shift + down  # code move line down         %同windows

代码提示：
ctrl + ;     # basic code complete           %同windows
ctrl + shift + ;  # smart code complete      %同windows
command + shift + enter  # complete current statement
alt + enter     # show intention actions      %同windows
ctrl + enter     # code generate             $$ alt-insert

重构：
shift + F6           # refactor rename    %同windows
command + shift + r   # replace in path
command + alt + m  # refactor extract method

其他：
command + F9         #   build project
command + shift + F9  # rebuild 
alt + shift + f    # other add to favourites   %同windows
```

注：如习惯vim操作，可以下载插件IdeaVim
![20190301_19](http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20190301_19.jpg)
安装后重启，设置开关vim模式快捷键,默认ctrl+alt+v,改成F1,同时把context help的remove掉。
![20190301_20](http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20190301_20.jpg)
vim默认寄存器和系统剪贴板共享:
在c:\Users\用户名\下新建文件_ideavimrc文件(mac是~目录.ideavimrc):
> set clipboard+=unnamed
let mapleader = ","
set backspace=eol,start,indent
set whichwrap+=<,>,h,l
set ignorecase
set smartcase
set hlsearch
set incsearch 
set showmatch 
set background=dark
set encoding=utf8
set nobackup
set nowb
set noswapfile
set smarttab
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
noremap <leader>v "0p
noremap <leader>V "0P
noremap <leader>ay "ay
noremap <leader>ap "ap
noremap <leader>by "by
noremap <leader>bp "bp
noremap <leader>cy "cy
noremap <leader>cp "cp
inoremap ( ()<Esc>i
inoremap [ []<Esc>i
inoremap { {}<Esc>i
inoremap " ""<Esc>i
imap ,, <Esc>la
noremap <leader>z G33o<Esc>H

热部署插件JRebel
修改java文件后可以不用重启，重新编译后即可生效，xml等配置文件仍然需要重启项目。

编辑器可视区域快速跳转神器AceJump
该插件提供了按行和按单词跳转功能,但是没什么太大作用，
最主要的功能还是自身的active acejump mode功能，可设置快捷键为ctrl + j

转换大小写插件String manipulation 可设置快捷键为alt + s

console日志警告或错误信息高亮颜色显示插件grep console
设置warn和error的前景色和背景色即可。

git提交commit模板idea插件git commit template

代码区小地图插件CodeGlance

## 小设置
scroll from source
设置自动导包: settings->editor->general->auto import->check 2
代码提示忽略大小写：settings->editor->general->code completion->match case uncheck
显示内存使用情况：settings->apperance->window options->show memory indication
inject language  json, xpath, regex

## 小问题
新建项目没有new java class选项？
> idea不同目录右键下有一个`mark directory as` 的功能，对应了maven通常项目结构,
> 有sources,tests,resources,test resources,excluded等不同的项目，将需要的包进行设定
> 即可。

光标处和相同变量颜色如何设置？
> settings -> editor -> color scheme -> general中
> code identifier under caret 相同变量名处
> code identifier under caret(write) 光标所在处  # 可以设置成黄底黑字
> editor caret -> 光标颜色 # 红色
> editor caret row -> 光标所在行 # 5D5973 或其他较深的颜色,区别黑色就可
> editor selection background -> 选中的文本颜色 绿底
> editor selection foreground -> 选中的文本颜色 黑字

自动生成的注释如何不在开头？
> settings -> editor -> code style -> java -> code generation -> comment code uncheck 2

每行最大字数的限制？
> settings -> editor -> code style首页 hard wrap, visual guides,建议100

<hr />
<img src="http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20190301_1.jpg" class="full-image" />
