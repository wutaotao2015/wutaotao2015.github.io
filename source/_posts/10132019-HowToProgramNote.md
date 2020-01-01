---
title: HowToProgramNote
categories: Method
tags:
  - Method
  - Racket
  - Lisp
abbrlink: fff758e4
updated: 2020-01-01 19:29:23
date: 2019-10-13 22:14:01
---
note of how to program
<!-- more -->
## 程序设计步骤

### 设计方法步骤

  1. data represents information. 数据代表了什么现实世界的信息
     这一步实际是程序的数据结构设计，或是表设计的步骤。
  
  2. a signature, a purpose statement, test cases, a function header
  
     数据结构设计好后开始编写方法模板
  
     注释signature: 方法签名，输入到输出 如; number -> string
     注释purpose:  方法的目的。 如 ; move x pixels down from the center of scene y
     test  测试案例， 使用前面给出的例子测试
     header:  方法模板，输出最简单的形式。 如 (define (change num) "string")
  
  3. code  实现方法， 按照给定的输入参数实现方法目的(purpose)。
  4. run

### 设计世界程序步骤
  
  1. 确定世界中不随时间变化的性质作为常量。一种是对象的物理性质常量，另一种是对象的图片常量.
  后者通常使用前者进行复合计算得到。这些图片常量组合起来即可得到世界的某个完整状态。

  常量的表达式可以在交互区测试得到。
  同状态的最小集类似，在编写常量实现时应尽可能减小变量个数，这称为"单点控制"(single control)
  
  2. 确定世界中随时间变化的性质，将它们集合起来用一个数据对象来表示，它应该是能确定整个世界
  图像的最小集。这个最小集就是该世界的状态。
  应给出注释说明如何将现实世界的信息表示成该状态对象，同时将该状态对象解释成现实世界的信息。
 ```txt
  ; A WorldState is a Number  (info -> state)
  ; the number is the time passed from the start to current time (state -> info)
 ```
  注: 有时最小集有多个，任意选择一个作为状态对象即可。
  
  3. 确定好状态对象后，编写多个方法以完成一个bigbang表达式。如渲染方法(render)将状态显示为
  一个图像，哪些事件处理对象影响了状态对象的哪些属性，如时间，键盘，鼠标事件等，最后根据
  需求，确定当状态对象满足了哪些条件时需要停止程序，即end?方法。
  将每个需要编写的方法放在wish list中，方法为模板方法，提供简单实现，符合方法签名即可。如
 ```txt
  ; worldstate -> image
  ; place image of car x pixels from the left of margin of the background image
  (define (render x) (place-image CAR X Y BG))
  
  ; worldstate -> worldstate
  ; add 3 to x to move the car right
  (define (tock x) (+ x 3))

  ; worldstate -> boolean
  ; when to stop, 注意这里不能只用=号，toc + 3可能取不到该值，
  ; 跳过后继续运行，end?一直为#f
  (define (end? ws) (>= ws 100))
 ```

  4. write a main function. 它不需要设计和测试，作为就是方便在交互区启动世界项目。需要考虑的
  仅为它的方法参数。如初始状态等。代码为
```txt
  ; worldstate -> worldstate   (big-bang方法返回值也为状态)
  ; launch program from some initial state
  (define (main ws) (big-bang ws [on-tick tock] [to-draw render]))
```
  on-tick默认计数频率为1/28, 即1秒28次tick.
  mouse-event:  button-down, button-up, drag, move, enter, leave
  
  下面为我的exercise 47的习题答案，主要是
  place-image的用法花了较多时间，搞清楚图片的定位(anchor)和偏移距离的计算起始点。
  代码如下, language: BSL, beginning student language
 ```txt
;; using up and down to charge battery

(require 2htdp/image)
(require 2htdp/universe)

; constants
(define BGW 100)
(define BGH 200)
(define MS 5)
(define RW (- BGW (* 2 MS)))
(define RH (- BGH  MS))
; number -> number
; the height of red bar, hap is happiness, 0 to 100
(define (RHF hap) (* RH hap 0.01))
(define BG (rectangle BGW BGH "solid" "black"))

; world state is a number [0,100]
; number is height of red bar's height ratio to RH

; ws -> image
; place-image would crop image to meet the need, place-image/align's function
; is to anchor the image, here it stick the red bar at the x's center and y's bottom
; x is distance from middle to the left, y is distance from the top to the bottom 
; so the distance is always counted from left and top
(define (render ws)(place-image/align (rectangle RW (RHF ws) "solid" "red")
             (+ MS (* 0.5 RW)) RH "center" "bottom" BG)
)

; ws->ws
; each tick ws decrease by 0.5
(define (tock ws) (- ws 0.5))

; number,number -> number
; over 100 set to 100, or set to num * fac
(define (feed num fac) (if (>= (* num fac) 100) 100 (* num fac)))      

; ws->ws
; key event handler, down arrow key increase ws by 1/5, up arrow key increase ws by 1/3 
; maximum can not be bigger than 100
(define (kh ws key) 
  (cond 
    [(string=? key "down") (feed ws 6/5)]
    [(string=? key "up")  (feed ws 4/3)]
    [else ws]
    ))
(check-expect (kh 30 "down") 36)
(check-expect (kh 30 "up") 40)
(check-expect (kh 30 "left") 30)

; ws->ws
; stop when ws = 0, because of multiplying, it can never equal to 0
(define (end? ws) (<= ws 0) )
; ws -> image
; last image when world ended 
(define (last-pic ws) (text "your\nbattery\nis\nout!" 30 "red"))

; main
(define (main ws) 
  (big-bang ws 
    [to-draw render]
    [on-tick tock]
    [on-key kh]
    [stop-when end? last-pic]))

(main 100)

 ```
 
### 枚举，区间和泛化
除了用基本数据类型，如string, number, image, boolean作为状态对象，我们还可以使用枚举，
区间和条目作为数据类型，它们使用cond表达式在基本类型的基础上进行处理，按照各自概念进行定义。
如枚举使用=, string=?, false?(没有true?的定义)等判断每一个条件，区间使用>, <判断每一个条件。
泛化适用于不同判断条件类型的cond表达式，如NorF即为元素类型在num和#f中进行判断。

注: cond表达式可以嵌套在其他方法中，使用时应包含最小变量集合表达式。
新的数据类型为更复杂的控制提供了可能，下面是我写的用空格键触发火箭升空的小动画(在查看
教程代码之前)。
```txt
;; using space key to launch ufo, with counting down feature

(require 2htdp/image)
(require 2htdp/batch-io)
(require 2htdp/universe)

; constants
(define BGW 400)
(define BGH 600)
(define BG (empty-scene BGW BGH))
(define UFO (overlay/align "middle" "bottom" 
                           (ellipse 40 10 "solid" "blue")
                           (circle 10 "solid" "red")))
(define V 4)
; 6 seconds
(define C -3)
(define CN (* C 28))
;(place-image/align UFO (/ BGW 2) BGH "middle" "bottom" BG)

; world state is LR(itemization)
; LR is "starting" or the pixels to the bottom(it is getting bigger as ticks go)
; or -N is countDown

; ws -> image
(define (place ws) (place-image/align UFO (/ BGW 2) ws "middle" "bottom" BG))

; ws -> ws
; render ws to image
(define (render ws) 
  (cond
    [(string? ws) (place BGH)]
    [(> ws 0) (place (- BGH ws))]
    [else (place-image 
            (text (number->string ws)
                  20 "red") 100 100 (place BGH))]
    )
)
(check-expect (render "s") (place-image/align UFO (/ BGW 2) BGH  "middle" "bottom" BG))
(check-expect (render 30) (place-image/align UFO (/ BGW 2) (- BGH 30) "middle" "bottom" BG))
(check-expect (render CN) (place-image (text  (number->string CN) 20 "red") 100 100 (place BG)))

; ws -> ws
; tick handler "stop" is static, number means ufo is getting up
(define (tock ws) 
          (cond 
           [(string? ws) ws] 
           [(<= ws 0) (+ ws 1)]
           [else (+ ws V)] 
          )
)
(check-expect (tock "s") "s")
(check-expect (tock CN) (+ CN 1))
(check-expect (tock 10) (+ 10 V))

; ws->ws
; only when ufo is not launching, press space key will launch ufo
(define (kh ws key) 
  (if (and (string=? key " ") (string? ws)) CN ws))

(check-expect (kh "s" " ") CN)
(check-expect (kh "s" "r") "s")
(check-expect (kh 1 "r") 1)
(check-expect (kh 6 " ") 6)

; ws->boolean
; when getting to the top, world ends
; because of cond mechanism, it must judge string first, than it can use <= 0 operation
(define (end? ws) 
          (cond 
           [(string? ws) #f] 
           [(>= ws BGH) #t] 
           [else #f] 
          ))
(check-expect (end? "s") #f)
(check-expect (end? -6) #f)
(check-expect (end? 23) #f)
(check-expect (end? (+ 1 BGH)) #t)

; ws->image
(define (last ws) (text "UFO\nfly\naway!" 20 "red"))

; ws -> ws 
; if main function here has no parameter, it is just a constant, using (define main ...),
; drrackt will evaluate it and execute big-bang,
; using (main ws) will make it a function and do not execute big-bang
(define (main ws)
  (big-bang "starting"
    [on-tick tock]
    [to-draw render]
    [stop-when end? last]
    [on-key kh]
    ))

(main "go")
```
通过阅读后面教程的实现，发现了自己编程的一些问题:

1. state状态对象是变量性质的最小集，它集成了按空格键，倒计时，升空这3种状态，
即需要在设计时就将变量通过泛化(itemization)的形式纳入到world state中来。这一点在实现倒计时
功能时没有考虑到，所以刚开始实现较困难。

2. 实现方法时应根据不同的条件先写单元测试(check-expect)(在交互区测试语句), 
再根据不同条件编写cond表达式，最后组合成方法的实现，这种方式最稳妥，其实也是最快的。

3. 区间的边界情况我的程序中没有加以判断，如倒计时为-1时需要将ws变为height.但由于我考虑的是
ws从负数一直递增到BGH,中间没有转折。从下面书中的示例可以看出先递增后递减也是可以实现的
(end? 方法加以判断即可，本质还是因为ws的区间范围是明确划分的，所以先递增后递减也行)。
但书中也提出，使用负数作为倒计时的设计是比较脆弱的。如我将ufo的速度YDELTA调整为40，程序
结束后提示show中的cond表达式全部为false, 即升空后ws以YDELTA速度递减，到顶后变为负数
(小于-3)，调整V大小ws甚至可能落入-3至0的区间内，从而导致bug。所以这里使用负数表示倒计时
是不合适的。

下面为书中程序代码:
```txt
;; using space key to launch ufo, with counting down feature

(require 2htdp/image)
(require 2htdp/universe)
(require 2htdp/batch-io)

(define HEIGHT 300) ; distances in pixels 
(define WIDTH  100)
(define YDELTA 40)
 
(define BACKG  (empty-scene WIDTH HEIGHT))
(define ROCKET (rectangle 5 30 "solid" "red"))
 
(define CENTER (/ (image-height ROCKET) 2))

; An LRCD (for launching rocket countdown) is one of:
; – "resting"
; – a Number between -3 and -1
; – a NonnegativeNumber 
; interpretation a grounded rocket, in countdown mode,
; a number denotes the number of pixels between the
; top of the canvas and the rocket (its height)

(check-expect
 (show HEIGHT)
 (place-image ROCKET 10 (- HEIGHT CENTER) BACKG))
 
(check-expect
 (show 53)
 (place-image ROCKET 10 (- 53 CENTER) BACKG))

(define (place x)(place-image ROCKET 10 (- x CENTER) BACKG))

(define (show x)
  (cond
    [(string? x) (place HEIGHT)]
    [(<= -3 x -1)
     (place-image (text (number->string x) 20 "red") 10 (* 3/4 WIDTH) (place HEIGHT))]
    [(>= x 0) (place x)]))

(check-expect (launch "resting" " ") -3)
(check-expect (launch "resting" "a") "resting")
(check-expect (launch -3 " ") -3)
(check-expect (launch -1 " ") -1)
(check-expect (launch 33 " ") 33)
(check-expect (launch 33 "a") 33)

(define (launch x ke)
  (cond
    [(string? x) (if (string=? " " ke) -3 x)]
    [(<= -3 x -1) x]
    [(>= x 0) x]))

; LRCD -> LRCD
(define (main1 s)
  (big-bang s
    [to-draw show]
    [on-key launch]))

; LRCD -> LRCD
; raises the rocket by YDELTA if it is moving already 
 
(check-expect (fly "resting") "resting")
(check-expect (fly -3) -2)
(check-expect (fly -2) -1)
(check-expect (fly -1) HEIGHT)
(check-expect (fly 10) (- 10 YDELTA))
(check-expect (fly 22) (- 22 YDELTA))
 
(define (fly x)
  (cond
    [(string? x) x]
    [(<= -3 x -1) (if (= x -1) HEIGHT (+ x 1))]
    [(>= x 0) (- x YDELTA)]))


; ws->image
(define (end? ws) (cond 
                    [(string? ws) #f]
                    [(<= 0 ws CENTER) #t]
                    [else false]))

; LRCD -> LRCD
(define (main2 s)
  (big-bang s
    [to-draw show]
    [on-key launch]
    [on-tick fly 1]
    [stop-when end?]
    ))
(main2 "test")
```
### finite states worlds
有穷状态图中状态可以使用符号常量来表示，如红绿灯中的红灯可以使用(define RED 0)或
(define RED "red")来定义，因为Racket是动态语言，(eq? 0 0)和(eq? "s" "s")同时为#t，
甚至(eq? "s" 0)也能正常运行，不报错，值为false. (其他比较方法还有eqv? equal?), 所以它为状态实际数据类型的变化提供了支持，这就是动态类型的好处。

### adding structure 
前面的火箭倒计时程序中，状态虽然使用不同类型的数据("stop"字符串和代表高度的数字)来表示
火箭不同的状态，但整个程序中变量只有一个("stop"时火箭是静止的，升空后变化的是高度)，如果
程序中有2个或2个以上的性质同时发生变化怎么办? 如支持往返飞行火箭的高度和方向。
这就是类似面向对象中对象的概念, structure.

(define-struct person [name age])类似于定义常量，方法，但它定义了一组方法(包括构造器
make-person, get方法person-name, person-age(可以看到racket中的-号类似于java中的.号)，
对象的equal方法person?), 与此同时还有对于structure的计算规则(类似cond语句的计算规则)，
如(person-name (make-person "wtt" 29)) == "wtt".

注: 我还在想为什么racket的对象没有set方法，后来看到tock方法的返回对象时才意识到，函数式
编程中对象是不可变的！所以没有set方法，当需要进行修改时，使用make-XXX返回一个新对象
就可以了!

程序中使用structure作为数据定义时，由于racket的数据类型是动态的，所以对于同样的structure
定义可以使用不同的方式来使用它。如书中的ball例子:
```txt
(define-structure ball [location velocity])
1. 在一维时，这样构造实例 (make-ball 10 -5) 可以代表如距离top 10px, -5px的速度向上运动
   (通常left top most is original point)
2. 在二维时，这样构造实例 (make-ball (make-posn 3 4) (make-velo -2 3)), 其中需要额外定义
   (define velo [dx dy])。
```
正是由于racket类型的动态性，使得ball的定义无法具体规定location, velocity的具体类型，所以
以上两种构造实例的方式都是正确的。这种自由度一方面让库函数真正变得抽象化，函数性或功能性
更强，另一方面程序员自己编程时应当坚持某一特定的定义方式，避免给自己挖坑。

当实例间进行嵌套时，即对象的属性是另一个对象，也称为复合对象时，这时与java的级联调用如
person.house.price不同的是，racket的获取方法是反过来的，可以理解为of结构，price of house
of person, 具体语法为(house-price (person-house p)).当层级较多时，可以利用定义方法进行
简化。


### design with structure

由于racket的类型动态性，data definition给出了其中属性的具体类型。定义的structure扩展了已有
的数据世界集合，而data definition则是通过限定类型划出了其中一部分在程序中使用。
下面是使用structure进行方法设计的步骤。

1. 定义structure, 给出instance和example, 这里的data example主要用来给后面的function单元
测试作测试数据对象使用。
  如:
```txt
(define-struct r3 [x y z])
 ; an R3 is a structure:
 ; (make-r3 number number number)
 
 (define ex1 (make-r3 3 4 5))
 (define ex2 (make-r3 -3 0 7))
```

2. 定义方法的签名，目的和模板, 如下:
```txt
; r3->number
; calculate the distance from r3 to the original point
(define (dis r) (r3-x r))
```
3. 使用前面的对象例子定义方法例子，如:
```txt
(define (dis ex1) (r3-x ex1))
(define (dis ex2) (r3-x ex2))
```
4. 将属性的get方法写入方法模板中。
5. 编写代码实现方法。
6. 进行测试。

### 使用vim和tmux搭建编写运行Racket环境
学(玩)Racket有一段时间了，跟着教程写了不少习题程序，我通常是用vim写好后在drracket中运行，
这也没太大问题，就是Racket编写括号和括号跳转较麻烦(括号键现在按的很熟了shift+9, 不过
%号还是够呛...),就想到在网上搜索有没有用vim来写Racket的文章。果然找到了，而且意外找到了
SICP的LaTex精美排版电子书和H5网站，这书现在还没学习(看完HowToProgram可以看看)，看网页效果
非常精美，也算意外之福, 由此可见网上好的资源如果搜到了，还是有很多的。

vim环境安装，链接为[crash.net.nz](https://crash.net.nz/posts/2014/08/configuring-vim-for-sicp/)

1. 在应用文章前，我先将%改为,a键，.vimrc中加入:
```txt
noremap <Leader>a %
vnoremap <Leader>a %
   " note that using split can swap 4 file totally, 2 files for each pane
noremap <Leader>g <C-^>
```

2. 在命令中运行命令`racket -i -p neil/sicp -l xrepl`， neil/sicp是对SICP书进行支持的第三方
库，xrepl是Racket extended REPL模式。
 2019-11-01 21:39:01 添加:
 加载自己编写的模块程序后，可以同drracket一样在交互区执行命令查看相应结果的命令行为
 `racket -it self.rkt -l xrepl`, 进入后可以使用`,h`查看xrepl的相关命令，`,e`进入自己模块的
 内部命令空间，这时就可以获取到对应的变量值了。
 其中，通过,h可以看到使用命令,install!可以将xrepl设置为默认选项，其实就是将
`(require xrepl)`写入~/.racketrc文件中。这样以上命令可以简化为`racket -it xxx.rkt`即可直接
使用xrepl.

3. 安装tmux.
`sudo apt install tmux`.
基本命令:
```txt
; create session
tmux new -s sessionName

; list all sessions
tmux ls 

; detach from session
prefix + d

; attach to tmux  
tmux attach -t sessionName

; windows operation
p+c p+& p+p/n/l p+w p+, p+f 

; panes operation
p+"/% p+x p+o p+ctrl+up/down p+alt+up/down 

; tmux kill server
tmux kill-server
```
修改默认前缀快捷键ctrl+b为ctrl+a, 修改~/.tmux.conf
```txt
# remap prefix to Control + a
set -g prefix C-a
unbind C-b
bind C-a send-prefix
```
保存后即可，对于已有的session使用命令`tmux source-file ~/.tmux.conf`使配置生效。
注: 不应当修改为ctrl+a, 与全选冲突，弃用！

6. 使用额外脚本对lisp文件进行格式化，下载scmindent.rkt.
.vimrc中配置
```txt
autocmd filetype lisp,scheme,art setlocal equalprg=scmindent.rkt
```
使用ggVG=即可。

7. 安装vim插件
```txt
Plugin 'tpope/vim-surround'
Plugin 'sjl/tslime.vim'
Plugin 'kien/rainbow_parentheses.vim'

" tslime {{{
let g:tslime_ensure_trailing_newlines = 1
let g:tslime_normal_mapping = '<leader>m'
let g:tslime_visual_mapping = '<leader>m'
let g:tslime_vars_mapping = '<leader>M'
" }}}
```

### 在泛化(itemization)中使用对象(structure)
当world中有多个独立的对象时，某些对象出现时机可能是动态的，如书中的坦克，UFO和导弹的例子，
这时的数据定义可以使用泛化来表示2个对象的世界和3个对象的世界状态。

泛化——这个东西很神奇，前面提到过，它就表示函数中的一个变量，其类型不受限制，使用时根据
具体的值具有不同的类型，如火箭倒计时发射程序中的number类型，string类型。这里将这些基本类型
替换为structure对象类型，实现了更高的控制，更明确的表示出itemization是一个万花筒，可以真正
变成任何自己需要的对象。

使用泛化结构设计方法的步骤:
1. 根据问题描述确定是否需要这种泛化的数据定义，即如果问题描述中有多个不同类型的对象信息(或者
不同类型信息间有局部不同)，这时候就需要使用泛化;

如果需要将不同的信息组合起来就需要结构(即组合成对象)。需要记住的是，如果对象结构太复杂，
应当拆分成独立的小结构。

最后，列出几个数据的例子，一方面检查对象结构，另一方面为测试数据
作准备。

2. 同前面的基本方法设计，写方法签名，方法目的，方法模板。 

3. 写出方法的测试案例，对泛化中的每种情况写一个测试案例。

4. 实现方法模板。这里涉及到泛化本身的处理和内部结构的处理。泛化同前面一样，每种情况对应cond
语句的一种情况，如果泛化使用了结构，每种情况中就需要使用到对应属性的get方法。

这里容易犯的错误是，直接根据问题描述开始写内部属性的get方法(如书中的spaceWar程序，这里就
开始写place-image,因为前面画静态图时已经有写好的表达式了)，这里其实应当写一个方法模板来
处理这条具体的cond语句情况，**这个方法模板根据问题描述提取出合理的操作步骤**，如spaceWar
程序中需要将UFO,TANK这2个物体常量添加背景图片中，就可以相应设计出ufo-render, tank-render
方法将处理步骤抽象出来。

这样做的好处比直接写place-image的好处很明显，直接写place-image完成后明显可以看到render方法
中ufo,tank的渲染在aim和fire中重复处理了，这时再优化代码还是需要将类似ufo-render, tank-render
的方法提取出来。从这里也看出，方法实现时做好api设计是非常重要的，节省了后期很多代码优化的
工作。

注: 在使用函数式编程时，有个最简单的是有时需要顺序执行2条不同的语句，因为lisp中没有语句的
概念，所有命令都是表达式，所以它更多是一种包含的关系，后者将前者的计算结果作为计算因子，如
这里的render, ufo-render, tank-render的关系，这一点在编写函数式编程时应当注意。这种机制也
确定了程序运行过程中每一步程序的状态都是确定的。

5. 确定好方法模板后，这一步才是真正实现具体的方法。实现过程中如果某些独立功能，可以使用
前面提到的wish-list功能。

6. 测试

书中给出了一个问题，以下2个表达式什么时候会得到相同的结果?
```txt
(ufo-render ufo (tank-render tank bg))
(tank-render tank (ufo-render ufo bg))
```
这个问题一看就是数学问题，f(g(x)) = g(f(x)), 那么符合这个条件的f(x),g(x)满足什么条件呢？
可以肯定是某种对称性，经过网上搜索，quora上找到答案:原来是f(x),g(x)互为反函数(初高中的数学
知识早忘了...), 也可以理解为它们是按y=x这条直线对称的。如y=x^2和x=sqrt(x)就满足这样的条件，
f(g(x)) == g(f(x)) = x.从这里也可以看出如何求反函数(inverse function), 将x,y位置互换，再
对y进行求值即可...汗！

spaceWar程序总结:
1. 单个属性的structure,如(define-struct ufo [p])是没有必要的，单个属性的structure可以用
该属性类型直接取代。这里ufo即等同于posn类型，没有必要额外定义structure.
如后面的(posn-x (ufo-p (aim-ufo aim1)))完全可以直接写为(posn-x (aim-ufo aim1))。

2. 对于包含不同数据类型(包括基本类型和structure)的泛化的数据定义，通过注释来说明它的取值范围
明显是没有约束力，容易被忽略和违反约定。所以我们可以对于这样的数据定义自定义一个predicate
方法来进行约束。如missileOrNot的泛化可以定义如下方法:
```txt
 (define (mis? m) (cond
                    [(or (false? m) (posn? m)) #t]
                    [else #f]
                  ))
```
对mis进行处理时，可以加上该predicate判断，属于防御性编程的一部分，让程序更健壮, 同时在
开发中这样做利于在复杂的程序中定位到数据类型不匹配的问题。
在big-bang表达式中有一个check-with从句(类似on-tick)，它的参数即可以接受这样一个wordstate?
的predicate方法，使得程序在运行中类型出错能及时停止程序运行并给出提示的功能。这在某种程序
上其实弥补了world program无法分步调试的缺陷。

## 任意多的数据
第一章讲完了基本数据类型和结构(对象), 这一章开始讲集合。
因为对象的数量是对象的外部性质，不属于对象本身的属性，所以这就涉及到数据结构的问题。
Racket也正是通过上面的data definition(其实也可以翻译为数据结构)来实现的集合。
同java中的内置数组不同，Racket使用了递归定义(自引用)实现了list集合。

### 自引用数据定义设计
1. 数据定义必须包含2个条件从句，一个是没有自引用的表达式，如list集合定义中的'().另一个则是
包含自引用的表达式。可以通过构造例子来验证数据定义是否定义正确。

2. 设计方法步骤不变，方法签名，目的，模板。只需要关注方法的参数类型即可，无需关心具体实现
步骤。

3. 造方法例子时需要多造几个应用了自引用条件从句的例子。

4. 因为一个自引用的数据定义本质上还是泛型数据定义, 所以实现方法时仍然是根据泛型的实现步骤
来实现，如构造与泛型的条件对应的cond条件从句。其中，模板中的自引用位置应当与数据定义中的
自引用位置保持一致，图示中的箭头可以使用本方法的再次应用来体现。这样的方法自引用即为
递归，或自然递归。

5. 实现方法时应从无递归的条件从句(或基础例子)开始，再实现递归从句。对于自然递归，使用时应当
假设本方法已经实现了相应的功能，这样就可以得到需要的递归处理。剩下的步骤就是如何将不同的
值连接起来，这里包括数据定义中属性的get方法和自然递归方法调用。如计算list列表中元素的个数
可以想到就是在(how-many (rest list))的基础上加1即可得到需要的当前list集合的元素个数。有时候
这样的关系比较复杂，可以利用书中建议的表格方法，将方法例子中单个值和需要的值进行比对猜测得到
之间的关系，随后验证该猜测适用于所有的list元素。必要时可以借助辅助方法或嵌套条件得到需要的
链接方法。

6. 最后将所有方法的例子转变为测试案例(最好是一开始就写为测试案例)，并确保测试覆盖率。

### 以集合为单元进行操作
以上模板只适用于list集合的直接操作，对于如需要求list集合所有元素平均值的非直接处理，可以
先以list集合为单位进行操作拆分后再使用以上模板处理，如平均值=元素和/元素个数，后两者都
可以直接使用自然递归处理。

### 自然数
如果想要得到一个包含了n个重复元素e的list集合怎么处理？作为一个java程序员，第一反应就是写一个
循环，以n为计数器，每次向集合中添加元素e. racket作为函数式编程语言，目前没有看到提供循环
功能，更多是使用递归。书中通过解析自然数(这里的计数器)的本质——自然数自带递归属性。
这样精妙的利用递归代替循环实现了同样的功能。代码如下:
```txt
; a N is one of
; 0
; (add1 N)

; 这里add1类似于cons的使用方式
(define a (add1 (add1 (add1 0))))
(define b (add1 (add1 0)))
(define c 0)

; N string -> list
;  get a N's string list
(define (replist n str) (cond
                          [(zero? n) '()]
                          [(positive? n) (cons str (replist (sub1 n) str))]))

(check-expect (replist a "wtt") (cons "wtt" (cons "wtt" (cons "wtt" '()))))
(check-expect (replist b "cll") (cons "cll" (cons "cll" '())))
(check-expect (replist c "ss") '())
```
从这里自然数的定义也可以看出，这种自引用的机制确实实现了书中的章节题目"无限大的数据"。
本质上还是利用了递归的无限性从而得到无限大的数据集合。

注：racket中没有方法重载的概念，重复定义相同的方法名会报错。

### russian doll
俄罗斯套娃的本质还是有自引用的对象，转换为java对象即为
```txt
class Rd {
 private String color;
 private Rd doll;
}
```

### 常用的list集合方法
这里列举出BSL中已经封装好有用的list集合方法:
```txt
(empty? null)  // null is '()
(list 2 4 6)   // simplify the list's initial step
(length (cons 2 (cons 3 (cons 4 '()))))   // list size
(member? 2 (cons 2 '()))   // list contains 
(make-list 4 "wtt")       // quickly make a list with same elements 
(reverse (list 1 2 3))   // reverse a list
(append (list 2 3) (list 4 5)) // merge lists as arguments order
```

### 组合函数 
工具函数准则:
1. 对每一个任务定义一个方法，对每一个存在依赖的数量关系定义一个工具函数。
2. 针对每一个数据定义定义一个方法模板，当一个数据定义引用到另外一个数据定义时，就使用一个
工具函数进行处理。

在实际实现方法模板的过程中，有以下几种情况需要使用工具函数:
1. 如果值的组合需要用到特定领域的知识，如合成图片，会计，音乐或科学知识等，这时应使用工具
函数。
2. 如果值的组合依赖某个条件，当该条件的逻辑处理过于复杂时，此时也应当使用工具函数。
3. 如果值的组合需要处理一个自引用数据定义中的元素时，如一个列表或自然数时，应考虑使用工具
函数。
4. 如果一切都失败了，可以考虑实现一个更加一般化的函数，将需要的函数作为特例来解决。

总体来说，程序设计的关键在于维护"方法愿望清单"。在向清单添加方法前，应先检查所使用的编程
语言提供的类库中是否已提供需要的功能。

### 递归的工具函数
经测试，对数列进行排序，由于list本身的自引用特性(first, rest方法的使用)，很容易就实现了
插入排序算法。

注： 经编写prefixes list练习题发现, list和cons的区别：
```txt
(cons (list "a") (list "b"))  -> '(("a") "b")
(list (list "a") (list "b"))  -> '(("a") ("b"))
```
可以看到，使用cons时后面的"b"是以元素的形式直接链接到最终结果中，说明cons适合作为同级元素
连接; 而使用list时后面的"b"被括号包裹起来是作为一个list集合链接到结果中，它是一个整体单元。

而prefixes练习中，`(add-head (first ls) (prefixes (rest ls)))`递归部分明显其中的元素需要被
填充进来，它不能作为一个整体，所以它需要使用cons与前面的(list (first ls))进行链接。
即最终结果为`(cons  (list (first ls))  (add-head (first ls) (prefixes (rest ls))) )`.

### 
### 















##
<hr />
<img src="http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20191013_1.jpg" class="full-image" />
