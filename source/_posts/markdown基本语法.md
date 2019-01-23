---
title: markdown基本语法
date: 2019-01-22 21:51:18
tags:
---
[TOC]
这里介绍的是基本markdown语法，使用工具为Typora.
#### 标题

​	1-6个\#号，后接空格

​	`## 标题`

#####		标题2

#### 字体

1. 加粗

   `**重点概念**`

   123**我是重点**456

2. 删除线

   `~~我被删了~~`

   123~~我被删了~~

#### 引用

   `> 4 = 2* 2`

   > 4 = 2 * 2

#### 超链接
   URL需要输入完整，不能漏掉`http://XXX/`

  `[去百度](http://www.baidu.com/)`

  [去百度](http://www.baidu.com/)

####  图片

   `![图片名](图片存放目录)`

   ![maya](http://ploojkqh4.bkt.clouddn.com/maya.jpg)

####  代码引用

   1. 单行

      \`one line code\`

      `one line code`

   2. 多行
	 ```txt
      \```js\
      	var s = 'hello world';
      	alert(s);
      \```\
     ```

      ```js
      var s = 'hello world';
      alert(s);
      ```

####  有序列表

   输完一点后，Typora中直接回车即可出现第二点，不用手动空格。

   `1. 第一点`

   1. 第一点
   2. 第二点

####  分割线

​	`---`

---

####  表格

Typora中的表格语法手工输入较麻烦，有2种方法。
       1. 使用其工具自带快捷键ctrl+t,注意输入第一行表头时选择居中，这样下面的内容就不用再重复选择了。（注意行数包括了表头）
       2. 也可以直接输入表头`|序号|姓名|分数|`，再统一调为居中后，再加上若干需要的行，需要多次点击下方加入一行，也较麻烦，可以确定大概行数最好

  ```txt
   | 序号 | 姓名 | 分数 |
   | :--: | :--: | :--: |
   | 1 | 吴涛涛 | 100 |
   | 2 | 王二 | 77 |
  ```
| 序号 | 姓名 | 分数 |
| :--: | :--: | :--: |
|  1   | 张三 |  77  |
|  2   | 王二 |  66  |
####  完成任务清单

```txt
 - [x] 任务A
 - [ ] 任务B # -space[space]space任务B  一共有3个空格
```
-  [x] 任务A
- [ ] 任务B

#### 目录

​	有的平台不支持

​	`[toc]`
[TOC]
#### 流程图
  还是引用代码块的语法，不过语言类型可以选择2个js包，一个是flowchart.js,它适用于画流程图，其他的时序图
  可以选择mermaid(美人鱼)，技术博客一般还是普通流程图用的多,掌握flow就可以。
  以下是网上一个写的比较好例子。
  ```txt
      // 首先，像定义变量一样将所有的节点定义出来，包括变量名，变量类型，节点显示名称
      st=>start: 开始
      e=>end: 结束
      cond1=>condition: 条件1
      opy1=>operation: 操作1
      opn1=>operation: 操作2
      cond2=>condition: 条件2
      io1=>inputoutput: 输出1
      io2=>inputoutput: 输出2
      // 指定流程的流转反向，通过括号给出判断条件和相对位置
      st->cond1
      cond1(yes)->opy1->io1->e
      cond1(no)->opn1(right)->cond2
      cond2(yes)->io2->e
      cond2(no)->cond1
  ```
```flow
    st=>start: 开始
    e=>end: 结束
    cond1=>condition: 条件1
    opy1=>operation: 操作1
    opn1=>operation: 操作2
    cond2=>condition: 条件2
    io1=>inputoutput: 输出1
    io2=>inputoutput: 输出2
    st->cond1
    cond1(yes)->opy1->io1->e
    cond1(no)->opn1(right)->cond2
    cond2(yes)->io2->e
    cond2(no)->cond1
```

写的过程中无法调试，最好是在typora中边写边查看效果，逐步完善，节点类型如start,end,

operation,condition,inputoutput等单词注意不要写错。

另外： typora支持目录生成[TOC]和流程图，github好像不支持。
