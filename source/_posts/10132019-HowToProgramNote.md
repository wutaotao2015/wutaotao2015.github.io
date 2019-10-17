---
title: HowToProgramNote
categories: Method
tags:
  - Method
  - Racket
  - Lisp
image: 'http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20191013_1.jpg'
updated: 2019-10-17 10:27:53
date: 2019-10-13 22:14:01
abbrlink:
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


##
##
<hr />
<img src="http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20191013_1.jpg" class="full-image" />
