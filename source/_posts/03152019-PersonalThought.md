---
title: 个人经验总结散记
categories: Thought
tags:
  - Thought

abbrlink: b703434b
updated: 2021-08-10 14:31:22
date: 2019-03-15 20:05:01
---
Test-driven Coding
<!-- more -->
## 测试驱动开发
问题:
> 今天下午在写一个微服务调用的挡板，但是报错javax-message找不到，因为jar包都是建行里自己
封装的包，所以确定是jar包冲突了，其中还有jar包版本号的问题，开始不知道怎么处理，最后才
开始想到一个个添加jar包来查看是哪个包的问题，最后终于找到了出问题的包，后面才能把交易
跑通。

分析:
> 因为之前做过demo，对于需要配置哪些依赖包，哪些注解，接口都很清楚，所以就一下子把
所有的代码，配置等全写好，但这样一报错就无法找出问题根源。因为底层的jar包依赖发生了变化，所以
会出现之前没有发现过的问题。

总结:
> 除非是百分百确定没有任何变数(基本是不可能的，实际工作中不可能会重复做相同的工作),我们
> 做开发(做其他事情也一样)时，需要阶段性的做测试工作，可以借助版本控制工具等来确定前期
> 工作的正确和稳定性，相当于快速迭代开发。如建房子一样，先打好地基，一步一步稳步前行，这样
> 才能及时发现问题，保证工作质量。

## 上线总结
after I changed my career path, this kind of publish code online activities will be less 
in the future. So it is reasonable and valuable to record the lessons learned from the 
mistakes I have made.

 2020-12-25 07:18:47 added:
Last night, after about 2.5 months developing time, the gis 2.0 web site finally go online,
here is two lessons I learned:
1.  press ctrl + z in one directory in windows server affects other directories as well, 
as it rolls back my uploaded code in other directories.
2. if simply change data in database is difficult, like change different fields in different
tables, but it have fixed pattern, like uploaded files path, then just modify the 
**sql script** with replaceAll method is convenient, **always remember the text file power**

## how to write recursive method easily

yesterday I write a tree-building class with ruby, I use recursive method to build it,
after working hard I finally made it, and I summarize the points to write recursive method:

1. do your own job first
2. handle your children's job nicely
PS: the input to you and to your children is the same!

It feels like the Chinese traditional philosophy, pursuit the inner saint and outer king.
The truth is the same. Not only to hierarchical data but also network data as well.


<hr />
<img src="http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20190315_1.jpg" class="full-image" />
