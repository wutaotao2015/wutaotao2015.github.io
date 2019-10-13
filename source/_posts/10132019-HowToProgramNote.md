---
title: HowToProgramNote
categories: Method
tags:
  - Method
  - Racket
  - Lisp
image: 'http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20191013_1.jpg'
updated: 2019-10-13 22:25:02
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
  (define (render x) backgroundImage)
  
  ; worldstate -> worldstate
  ; add 3 to x to move the car right
  (define (tock x) x)
 ```
  
  4. write a main function. 它不需要设计和测试，作为就是方便在交互区启动世界项目。需要考虑的
  仅为它的方法参数。如初始状态等。代码为
```txt
  ; worldstate -> worldstate   (big-bang方法返回值也为状态)
  ; launch program from some initial state
  (define (main ws) (big-bang ws [on-tick tock] [to-draw render]))
```

##
##
<hr />
<img src="http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20191013_1.jpg" class="full-image" />
