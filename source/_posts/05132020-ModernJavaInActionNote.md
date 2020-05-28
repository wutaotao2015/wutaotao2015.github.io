---
title: ModernJavaInActionNote
categories: Java
tags:
  - Java
updated: 2020-05-28 16:39:38
date: 2020-05-13 07:08:24
abbrlink:
---
just the title
<!-- more -->

## part1 general
### Java 9 to 11
programming language climate changes
1. programmers need to deal with big data, it need to use the multicore cpu and parallel 
computing.  (stream api)
2. integrate old large subsystem with the new system (java9 module system and interface 
default method)

stream processing
   like unix pipeline commands or sql query, stream use concurrent processing. 
behavior parameterization
   将方法作为参数 
并行和共享的可变更数据
   需要并行处理时每一个操作步骤都必须是纯方法，无副作用或无状态方法。
   并发处理中使用synchronized性能损失非常大
使用java8 提高了java 程序员的竞争力

funtion和整型，对象引用等一样是一等公民 类也可以是(在js中已实现)
方法引用： 如 new File(".").listFiles(File::isHidden);
**方法引用和对象引用一样，方法和对象都是值, 方法作为值进行传递**
    在方法引用以前，需要传递方法只能将方法包裹在一个实例对象(匿名内部类)中进行传递, 现在
    可以直接传递方法。
方法引用只支持具名函数，即有名字的方法，没名字的只能使用匿名函数，或者lambda表达式。

**和对象使用接口类型进行传递一样，方法可以使用函数式接口(functional interface)进行传递**
如Predicate, Supplier, Consumer等，顶层是Function接口

低频使用'方法值'是lambda表达式，多次或'方法值'很长就需要方法引用语法

use stream.collect(groupingBy(Cst::getSliceTime)) to group a list with sliceTime
将展开的结果列表分组聚合，特别适用于树形数据的聚合！

自己使用for循环逐个遍历处理是外部遍历，使用stream不具体处理遍历过程是内部遍历
stream利用了多核cpu的并行计算能力。

list.stream().filter(...).collect(Collectors.toList());
和
list.parallelStream().filter(...).collect(Collectors.toList());
性能差异, 后者随着测试数据量增大和中间操作步骤增多, 性能优势体现明显.
注: 并行执行要求无共享的可变状态对象 mutable shared state

`optional<T>` can avoid null pointer exception

pattern matching:  can decompose type object to its components,such as 
`obj instanceof String s`  
`switch(obj) case String s: ...; Double d: ...`  
    // also called visitor patterns, walk through a family classes and do sth to each one

### passing code with behavior parameterization
#### 经常变动的需求
挑选苹果 
  绿色, 红色 -> color parameter
  轻重   -> weight parameter
 以上条件有重复的模板代码, 如果需要优化挑选的代码性能, 需要修改每一个方法!
 
 本质需求:输入是一个苹果, 根据苹果的某些性质输出一个boolean值, 所以可以采用策略模式, 将其
 定义为一个接口类型predicate, 应用方法接受该接口作为参数进行处理.
#### real examples
1. comparator
  `Collections.sort(cstDtos, Comparator.comparing(CstDto::getBeginDate));`

2. java.lang.Runnable
   // because thread.run method is void run(), no parameters and no return value
  `Thread t = new Thread(() -> System.out.println("hello"));` 

3. java.util.concurrent.Callable
```txt
  // Callable is also a functional interface,  it has V call()
  ExecutorService executor = Executors.newCachedThreadPool();
  Future<String> threadName = executor.submit(() -> Thread.currentThread.getName());
```

4. gui event handler 
void handle(ActionEvent event){}
代码略

### lambda expression

## part2 stream

## part3 lambda and stream

## part4 everyDay Java

## part5 concurrency

## part6 function programming and java future







##
<hr />
<img src="http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20200513_1.jpg" class="full-image" />
