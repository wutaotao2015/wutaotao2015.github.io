---
title: IntelliJ Idea 简明笔记
categories: Tool
tags:
  - IntelliJ Idea

abbrlink: 481236cd
updated: 2020-01-19 11:56:57
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
```txt
set clipboard+=unnamed
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
```

热部署插件JRebel
修改java文件后可以不用重启，重新编译后即可生效，xml等配置文件仍然需要重启项目。
注：将resources下文件纳入jrebel监管范围，从而避免重启项目，
生成的rebel.xml文件中可以看到
```txt
<classpath><dir name="xxx"></dir></classpath>
改为
<classpath>
<dirset dir="/path_to_project_root/">
   <include name="**/target/classes"/>
   <include name="**/src/main/resources"/>
</dirset> 
</classpath>
```

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

## External Tools
因为ideaVim插件毕竟不是真正的vim，所以有些vim的功能支持不了，或者不全，
今天在网上发现了idea还支持将vim作为外部工具使用，即在vim中打开现在正在编辑的文件，
并将改动同步回idea中。
windows上使用gvim来实现，mac上可以使用iterm2(to be continued)
1. 下载gvim，直接官网上下载,版本为8.1
2. 安装
3. 打开发现菜单都是乱码，网上说修改配置文件`_vimrc`,但是修改后并没有用，于是用另外一种
方法：直接删除vim/vim81/lang包下所有文件，菜单按钮全部回复到默认英文。
(后来发现是安装包的问题....另外下的一个包是好的)
4. 设置默认的配色和字体,见下面的完整配置

5. 在idea中配置gvim
settings - external tool - + - 配置
> program: vim/vim81/gvim.exe
> arguments: +$LineNumber$ $FilePath$
> 其他默认，去掉advanced options - open console

6. `_vimrc`完整配置如下，需要新建环境变量VIM为E:\Vim来安装Vundle,

```txt
let mapleader = ","

set encoding=utf-8
set fileencodings=utf-8,chinese,latin-1
if has("win32")
set fileencoding=chinese
else
set fileencoding=utf-8
endif
"解决菜单乱码
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim
"解决consle输出乱码
language messages zh_CN.utf-8


source $VIMRUNTIME/vimrc_example.vim

set diffexpr=MyDiff()
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg1 = substitute(arg1, '!', '\!', 'g')
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg2 = substitute(arg2, '!', '\!', 'g')
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let arg3 = substitute(arg3, '!', '\!', 'g')
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '"' . $VIMRUNTIME . '\diff"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  let cmd = substitute(cmd, '!', '\!', 'g')
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  if exists('l:shxq_sav')
    let &shellxquote=l:shxq_sav
  endif
endfunction

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
"set rtp+=~/.vim/bundle/Vundle.vim
"call vundle#begin()
set rtp+=$VIM/vimfiles/bundle/Vundle.vim/
call vundle#begin('$VIM/vimfiles/bundle/')
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
"Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
""Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
""Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
""Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}
Plugin 'scrooloose/nerdtree'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'kien/ctrlp.vim'
Plugin 'tpope/vim-surround'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

""""""""""""""""""""""""""""""
" => CTRL-P
""""""""""""""""""""""""""""""
let g:ctrlp_working_path_mode = 0

let g:ctrlp_map = '<c-f>'
map <leader>p :CtrlP<cr>
map <c-b> :CtrlPBuffer<cr>

let g:ctrlp_max_height = 20
let g:ctrlp_custom_ignore = 'node_modules\|^\.DS_Store\|^\.git\|^\.coffee'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Nerd Tree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:NERDTreeWinPos = "left"
let NERDTreeShowHidden=0
let NERDTreeIgnore = ['\.pyc$', '__pycache__']
let g:NERDTreeWinSize=35
map <leader>nn :NERDTreeToggle<cr>
map <leader>nb :NERDTreeFromBookmark<Space>
map <leader>nf :NERDTreeFind<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-multiple-cursors
" 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:multi_cursor_next_key="\<C-s>"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => surround.vim config
" Annotate strings with gettext 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
vmap Si S(i_<esc>f)
au FileType mako vmap Si S"i${ _(<esc>2f"a) }<esc>


"设置gvim隐藏菜单栏，工具栏，滚动条
set guifont=Source\ Code\ Pro\ for\ Powerline:h11
colorscheme darkblue
set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar

set clipboard+=unnamed
set ignorecase
set smartcase
set hlsearch
set incsearch 
set showmatch 
set nobackup
set nowb
set noswapfile
set noundofile
set smarttab
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
noremap <Leader>v "0p
noremap <Leader>V "0P
noremap <Leader>ay "ay
noremap <Leader>ap "ap
noremap <Leader>by "by
noremap <Leader>bp "bp
noremap <Leader>cy "cy
noremap <Leader>cp "cp
inoremap ( ()<Esc>i
inoremap [ []<Esc>i
inoremap { {}<Esc>i
inoremap " ""<Esc>i
imap ,, <Esc>la

```

注: 回到公司电脑上重新安装gvim8,装在E:\Vim下,修改_vimrc怎么都不生效，又搞了很久做了
以下两步终于生效了：
  1. 添加用户变量VIM为E:\Vim,VIMRUNTIME为D:\Vim\vim81
  2. 将_vimrc放到用户目录下，我的为C:\Users\LYPC\下，生效了！！！
  另：重新安装gvim8发现Vim包下没有了vimfiles文件夹，只好手动复制进去。

再注：gvim可以正常使用了，但我真正想使用的是可以任意定位到一个项目下，方便的使用nerdtree来
查看项目代码。从这一点来看还是需要结合babun来实现快速打开项目,或者可以打开vim时自动打开
nerdTree,下面来讲这2种方法：
   1. 用babun打开gvim,在网上找到大神写的一个gvim别名，对环境变量的控制做的很好，结合我自己
   的$VIM变量配置，结果如下，可以正常使用插件nerdtree, ctrlp
   ```txt
gvim() {
   OLD_HOME=$HOME
   OLD_VIMRUNTIME=$VIMRUNTIME
   OLD_VIM=$VIM
   export HOME=/cygdrive/c/Users/LYPC/
   export VIMRUNTIME="E:\Vim\vim81"
   export VIM="E:\Vim"
   TARGET=$(cygpath -w $1)   
   (/cygdrive/e/Vim/vim81/gvim.exe $TARGET &)
   export HOME=$OLD_HOME
   export VIMRUNTIME=$OLD_VIMRUNTIME
   export VIM=$OLD_VIM
} 
   ```
   2. 启动gvim时自动打开指定位置的nerdTree, 这里指我的项目集中地code
  在`_vimrc`中添加配置:
  > autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

这样在babun中用code定位到code目录，用命令`gvim`即可打开带有nerdTree的gvim窗口了

   3. 像之前说的一样，babun里面包装了cygwin, 而vundle对cygwin里的安装现在官方不
   给予支持，它只提供了windows里gvim的支持，所以我上面通过别名的方式来调用windows
   里面的gvim.exe程序，这样通过gvim里的vundle来实现插件管理，这样曲线救国也能实现
   目的，同时babun里自带的vim也能使用，这种方式对于有多个插件来说比较好，但目前我
   需要的只是nerdTree一个插件，所以今天又发现可以手工把这个插件安装到vim里面:

      1. cd ~/.vim
      2. mkdir bundle
      3. cd bundle
      4. git clone https://github.com/scrooloose/nerdtree.git nerdtree
      5. 在.vimrc中添加
```txt      
set runtimepath+=~/.vim/bundle/nerdtree
let g:NERDTreeWinPos = "left"
let NERDTreeShowHidden=0
let NERDTreeIgnore = ['\.pyc$', '__pycache__']
let g:NERDTreeWinSize=35
map <leader>nn :NERDTreeToggle<cr>
map <leader>nb :NERDTreeFromBookmark<Space>
map <leader>nf :NERDTreeFind<cr>
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
```

   注：先命令行cd到相要的目录，直接vim打开，或者先打开，再,nf来打开nerdTree,
   有`<c-h>,<c-l>`来快速切换nerdtree和编辑窗口.
   退出时用:qa来一起关闭nerdtree和编辑器。
   同理安装ctrlp插件后ctrlp插件报错，nerdtree正常使用，网上说是依赖问题，还是
   需要插件管理软件，所以还是先用nerdtree吧，文件搜索可以放在命令行里find寻找。

7. 目前暂时发现的ideaVim插件不能实现的功能有:
   1. visual block paste, idea中需要配合idea自带的列模式才能实现，没有原生的vim好用。
   2. to be continued

## 使用idea操作mysql数据库
idea提供了console控制台进行sql语句的操作，相当于命令行一样，同样可以使用ideaVim插件和其他
快捷键来编写和执行命令，所以后来我基本放弃了navicat的使用，而且有次使用32位的navicat也出现
了问题，idea成功的进行了操作。
常用命令：
```txt
show grants;
show processlist;
select create table tablename;
show full columns from tablename;
delete t from tablename t where t.id = '1';
```
导入数据到表中：右键选择表，import data from files... 支持csv(comma-separated values)文件
tsv(tab-separated values)文件。

导出表结构：
用mysql自带的bin工具mysqldump.exe,有多个命令参数，
其中勾选第一个multiple rows insert后，只会生成一条insert语句，可以全部都不选。

只导出数据时，选择表右键有dump data to file选项。

## 小问题
idea记住git密码,在项目目录下执行
> git config --global credential.helper store

2019-08-27 10:08:32 添加:
编程时经常需要重命名变量名，idea下的快捷键是Shift + F6, 按下之后idea给出可选提示，不过这时
使用ideaVim插件时无法直接编辑，经网上搜索需要先进入编辑模式，这时候idea模式替换了vim模式，
再直接输入新的变量值可以发现整个变量名被清空了。该问题属于idea和ideaVim插件的模式替换问题。
命令顺序为`Shift + F6  -> i or s -> type new name -> enter`.

提取变量时先将ctrl + w快捷键设置为idea的extend selection智能选择功能(vim中这个快捷键没什么用)，
然后使用idea的快捷键ctrl + alt + v提取为本地变量。
命令顺序为`ctrl + w  -> ctrl + alt + v -> i or s-> type new name -> enter`.

总结: 由以上2个功能来看，当使用idea快捷键后编辑器选中了某个值并给出提示时(包括alt + enter
智能提示的结果, alt + j 选取相同变量的结果), 进入插入模式后再进行输入即可替换选中值。
注意这里的实现是必须清空，无法在提示内容上追加，直接按a是只修改当前值。
在不是手动输入，而是复制粘贴的情况下，因为使用编辑模式进入了idea模式，这时无法使用vim的p
进行粘贴，应当使用通用的shift + insert进行粘贴。

另: ctrl + w正式名称为structural selection, 属于idea快捷键，但它选中的内容在vim 普通模式下
还无法获得，需要先进入可视模式, 再使用ctrl + w进行选择后vim就可以获得选取的内容了，使用p
可以正常复制。(该bug再未来ideaVim中将会修复)

2019-09-10 16:21:34 加
Idea的alt + J快捷键在可视模式下进行操作会出现问题，而IdeaVim插件内置了一个原生的vim插件
vim-multiple-cursors, 默认快捷键是alt + n, 还支持取消选中(alt + p)，跳过选中功能(alt + x).
选中以后经测试直接a, i, A, I都无法使用(无反应或不是对选中值操作), 可用的只有c和s键，所以
若需要修改时需要先复制原内容，进行编辑模式后就是真正的多光标操作，vim的dw, vws等全都支持。
所以需要重构时应使用alt + n + c/s， 而不是用alt + j, 后者有很多问题。
又注: 单个变量应使用alt + n, 但对于整句的情况，multi-cursor出现无法选择全部的情况，而
ctrl + J可以，所以还是应根据场景结合使用这两者。

## ubantu上通过snap安装idea
在idea官网的安装教程上突然发现ubantu上可以通过一个叫"snap"的东西安装，还支持自动更新操作。
查看过大致资料后发现snap的目标是建立一个可以在所有不同版本的linux系统中通用的应用管理工具，
在ubantu, fedora, minx等不同linux流派中都能使用的包管理工具。它不能取代deb, 更多的是在应用
层为用户提供统一的服务，简化了安装过程，同时开发者也可以不用再针对不同平台开发不同的特定平台
的应用版本。

下面是使用snap安装idea的过程:
```txt
snap find "intelliJ idea"
snap info intellij-idea-ultimate
sudo snap install intellij-idea-ultimate --classic
设置代理
sudo snap set system proxy.http="http://addr:port"
sudo snap set system proxy.https="http://addr:port"
```
经过测试使用，即时挂上代理，速度也非常慢，所以无法使用(网上搜索到这是snap store本身的问题),
还是下载后安装单个版本吧。

## IntelliJ Idea在xmonad中显示问题
安装ToolTip博客中的步骤安装好jdk和Maven后，启动idea时窗口无法正常显示，开始一直以为是Idea
本身的问题，后来在ubuntu中发现可以正常打开，经网上查找原来是xmonad不在jdk的gui展示列表中，
(很多新的窗口管理工具jdk都不支持), 在mac上使用xmonad.hs中修改的setWMName  "LG3D"可以正常
打开，但thinkpad上就不行，后来在xmonad faq中发现最方便的方法是添加环境变量，thinkpad也能正常
打开Idea窗口了。
```txt
If you are using openjdk6 >= 1.6.1, the cleanest way to work around the hardcoded 
list is to warn the vm that xmonad is non-reparenting by exporting the appropriate 
environment variable:

_JAVA_AWT_WM_NONREPARENTING=1
// 经本人测试， jdk 8也有效
```

## IntelliJ idea新项目运行时警告编译的jdk版本问题
新建项目时默认是jdk5，会给出提示，即时在project module setting里面设置为jdk8，重启后又会
恢复原值，最根本的解决方法是在maven中指定具体的jdk版本，默认设置为jdk8时可以进行如下设置:
```txt
<properties>
  <java.version>1.8</java.version>
  <maven.compiler.source>${java.version}</maven.compiler.source>
  <maven.compiler.target>${java.version}</maven.compiler.target>
</properties>
```

## IntelliJ智能提示方向键重新映射
Idea的核心操作是键盘流,配合ideaVim插件非常好用, 在实际使用时, 在idea智能提示弹框出现时,
有时目标就是第二个或以下时(第一个直接回车), 如果要选中它, 这时可以多敲几个特定字符将它
筛选出来, 但实际上比较繁琐(相对于使用方向键而言, 直接多按2,3下简单直接), 但由于方向键
位置的天然劣势, 所以以下提出使用 alt + j/k 来映射到 up/down 方向键.
这本身是一个非常简单的映射, 因为它只特定针对idea进行设置, 用于编写代码开发时使用, 我目前是
在windows下开发, 所以使用autoHotKey进行修改, 这里附上相应配置文件.

放在开始的启动目录下, 开机自动执行:
`C:\Users\wutao\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\startUp.ahk`

```txt
#Persistent
SetTimer, PressTheKey, 5000
SetTimer, PressTwoKey, 10000
Return

PressTheKey:
Send, {ScrollLock}
Return

PressTwoKey:
Send, {NumLock}
Return

SetCapsLockState, alwaysoff
Capslock::
Send, {Esc}
Return

!k::Send, {UP}
!j::Send, {DOWN}

F12::run, D:\wtt\cmder\Cmder.exe
#c::run, C:\Windows\System32\cmd.exe
```
ps: 前面的自动点击scrollLock, numLock键是防止自动锁屏, 下面是将capslock映射为esc键.
然后是就是alt+j/k变为方向键, 最后是快速启动终端和命令行.

pps: 发现我可以直接修改idea的keymap, 不需要使用ahk.目前没有其他地方需要使用alt+j/k代替
方向键. 不过这样修改键盘的底层映射适用于那些没有方向键的超小键盘,如66键的键盘---不过
太贵了, 本人上次发烧买的filco还可以用很久很久....

ppps: idea下一个方法的快捷键是alt+down, 由于我上面使用alt+j/k代替了方向键, 所以这个快捷键
按不出来, 所以将不用的inline refactor method的快捷键ctrl + alt + n 追加到 next method
快捷键中.(本来想使用alt + n, 但ideaVim的multipleCursors扩展插件使用了它, 所以无法使用)

ps: 将alt + h/l同样映射为left and right, 但实际使用时和idea本身的菜单快捷键冲突, 如
alt + v/h会打开View/Help菜单, 网上搜索可以在settings-> appearance -> disable mnemonics 
in menu即可.

ps: 这样映射本来是想用在ideaVim的命令行模式中, 但发现idea的keyMap中映射alt + h/l对
ideaVim的命令行模式不生效. 所以还是要从vimrc的配置入手.具体vimrc配置请查看VimNote.

ps: 经过考虑, 决定统一使用ctrl键代替alt键进行方向键映射, 这样保持一致.
这样的话, 需要进行如下修改:
```txt
1. 将前面的ahk的键位配置注释掉(前面加分号)
2.  前面的next method可以由默认的alt + down改为ctrl + alt + n, 
因为ctrl + alt + j是激活aceJump快捷键;
3. next occurrence可以改回默认的alt + j; 
4. commit 默认的ctrl + k由于只有在vcs窗口生效, 所以不需要修改.
5. ctrl + j/k 分别在keymap中映射为down/up.
6. 修改.ideavimrc添加cnoremap注释:
   cnoremap <C-h> <left>
   cnoremap <C-l> <right>
   cnoremap <C-j> <down>
   cnoremap <C-k> <up>
```
final ps: 经测试发现以上cnoremap无效,而且与split view的carl + j/k冲突, 所以还是得
用alt键进行统一.
```txt
最终键位总结如下:
1.  前面的next method可以由默认的alt + down改为ctrl + alt + n, 
因为ctrl + alt + j是激活aceJump快捷键;
2. add selection for next occurrence可以改为alt + o; 
3. 因为即使像正常的vim里配置, ideaVim plugin也无法使用alt映射, 所以还是只能使用ahk进行
底层键盘映射:
!k::Send, {UP}
!j::Send, {DOWN}
!h::Send, {LEFT}
!l::Send, {RIGHT}
这样做的话也就不用disable idea菜单了, 因为idea不可能收到alt + h键了, 它只能得到left键. 
keymap中也不用配置up/down键了.  
```
结论: 用于ideaVim plugin的功能限制, vim command mode 不可能和真正的vim相同, 所以normal vim
可以正常使用的ctrl + h在ideaVim中无法使用, 最终解决办法就是使用ahk修改底层键位映射.
这样normal vim统一使用ctrl键, idea统一使用alt键(在windows的ahk作用下).


<hr />
<img src="http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20190301_1.jpg" class="full-image" />
