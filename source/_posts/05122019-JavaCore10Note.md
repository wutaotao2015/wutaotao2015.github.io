---
title: JavaCore10Note
categories: Java
tags:
  - Java
  - Unicode
image: 'http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20190512_1.jpg'
updated: 2019-05-22 17:40:58
date: 2019-05-12 20:10:28
abbrlink:
---
Java, Unicode, 
<!-- more -->
## 安装java
安装后将jdk安装目录/bin加入到path环境变量即可,不用设置其他。
## 基本程序设计结构
## 数据类型
java有8种基本类型，4种整型，2种浮点型，1个unicode字符类型char,1个boolean类型.
1. 整型
   java需要保证不同机器上相同程序运行结果相同，所以java的数据取值范围是固定的
   （C,C++在不同机器上数据取值范围不同，如在16位处理器上整型占2个字节，32位处理器上
   整型占4个字节，java没有无符号形式的数据类型unsigned）
   byte 1个字节 -127 ~ 127
   short 2个字节 -3万2 ~ 3万2
   int 4个字节  -21亿 ～ 21亿
   long 8个字节  -9（共19位） ～ 9（共19位）

   long类型有后缀L/l, 十六进制前缀0x/0X,八进制前缀0
   
   从java7开始，二进制可以加前缀0b/0B, 数字字面量可以加下划线，编译器会自动去除，如
   `10_00_1`代表数字10001。

2. 浮点类型
   float 4字节   有效位数6～7位（后缀f/F)
   double 8字节  有效位数15位(无后缀或后缀D/d)

   有3个特殊的浮点数，正无穷大，负无穷大，NaN
   Double中分别为`Double.POSITIVE_INFINITY,Double_NEGATIVE_INFINITY,Double_NaN`
   
   在整型中1/0会抛出算数异常，但1.0/0则会得到`Double.POSITIVE_INFINITY`,由于所有非
   数值都认为是不相等的，所以`1.0/0 == Double.POSITIVE_INFINITY`永远是false,可以
   这样判断Double.isInfinite(1.0/0),同理可以这样判断x是否是一个数字Double.isNaN(x)

   由于浮点数由二进制表示，所以它无法精确表示0.1,就像十进制中无法精确表示1/3一样，所以
   如果需要精确表示，需要用到bigDecimal.

3. char
   char字面量用单引号括起来，它的值可以表示为十六进制,范围是\u0000到\Uffff
   \u可以在引号外使用，它会在编译前转换为对应的符号，所以在注释中使用\u容易引起报错
   如`\\ C:\users\`会报错非法的unicode转义 因为\u后不是4位16进制数
   还有其他转义字符如'\n'，'\t'可以在引号内使用代表特殊含义。

   编码：
   UTF-16原来是定长16位的，但后来字符总数超过了65536（2^16)个，所以它变成了变长，
   原字符集为基本字符集，多的字符集称为增补字符集。

   unicode码点（code point)指编码表中与某个字符对应的代码值，用16进制数字表示，加上前缀U+
   码点可以分为不同的代码级别(code plane)，分基本多语言级别和其他级别;
   UTF-16使用变长长度来表示不同的unicode码点，针对基本多语言级别，使用16位表示一个字符，
   这也称为一个代码单元(code unit)，其他级别使用2个代码单元来表示该字符。

   java char类型表示UTF-16编码中的一个代码单元。
   由此可知：
   1. 大部分unicode字符可以用一个char值表示（基本多语言级别），少部分特殊字符（增补字符）
   需要用2个char值表示。
   2. 1 byte = 8 bit, 1个字节代表8位，说明char类型是占用2个字节的。

  注： 
   1. UTF-8是变长编码，它用1到4个字节表示不同区间的代码点。
   2. 增补字符集用2个代码单元表示一个字符，其范围是U+D800到U+DFFF,这个范围内的码点值没有
   分配给任何字符，所以可以通过一个代码单元的码点值来判断它是基本字符还是增补字符的高/低位。

  show the code:
  `System.out.println("𐐷".length());` 输出2

  最佳实践：不要在程序中使用char类型，尽量使用String类型。

4. boolean类型
   java的布尔类型和整数值之间无法转换，而C++中数值或指针都可以代替布尔值，0代表false,非
   0代表true.如下java代码：
  ```txt
  int x = 11;
  System.out.println(x = 0); // 输出0
  if (x = 1) {} // 编译报错incompatible types,即表达式值为1时，它不会自动转换成bool值true.
  ```
### 变量
变量由字母开头，由字母和数字构成，字母和数字的范围很大。字母包括`a-z,A-Z,_,$和其他表示字母
unicode字符`,数字也包括0-9和其他表示数字unicode字符。

c,c++中变量的声明和定义是不同的，java中则不区分，声明和定义是一个意思。
java使用final定义常量，常量名全大写。

### 运算符
像前面说的一样，整数除以0会产生异常，浮点数除0得到无穷大或NaN.
由于数学上默认余数都要大于0,但是-6%4表达式执行结果为-2,可以用Math.floorMod(-6,4)来得到正
数的结果。
不同数值类型之间转换可能会产生精度丢失。如int->float,long->float,long->double等。
强制类型转换是直接截断小数部分，如(int)9.99999的结果是9,如果需要四舍五入，可以使用
Math.round方法。
注：将boolean类型和数值类型进行转换会产生错误，应使用三目运算符。

自增自减运算符与c,c++相同，不建议在表达式中使用该运算符，容易产生bug.

位运算
可以使用掩码技术来得到某个数二进制表示的某一位是0还是1,如`(15&0b1000)/0b1000`结果为1代表15
右起第4位是1，同理`(24&0b1000)/0b1000`也是1,注意括号不可少，限制了运算符顺序。
<<表示位模式左移,>>表示右移，具体来说
```txt
10<<2等同于0b1010 数字左移，其后补0变为0b101000 = 40.
10>>2等同于ob1010数字右移，高位补符号位，变为0b0010 = 2.
-10>>2 结果为-3,高位补符号位1
-10>>>2 结果为1073741821,高位补0
注： 二进制和十进制转换
System.out.println(0b1010);  //10
System.out.println(Integer.toBinaryString(-10));//111111...补码，反码......
```
java中没有逗号运算符
### 字符串
子串： substring(0,3)包头不包尾，包括0,1,2,这样子串长度可以很容易的由3-0=3得出。
拼接： 2个或较少的字符串拼接可以用'+'，多个字符串用一个指定分隔符拼接可以用String.join
      方法，如String.join("/", "A", "B","C");为A/B/C.
不可变字符串： 因为实际字符串修改需求较少，而且共享字符串的性能提高比拼接的耗费要多很多。
注：java字符串不等同于c中的字符数组，而是类似于`char*`指针。

比较字符串：因为只有字符串常量是共享的，其他如+或substring是不共享的，所以无法用==来判断
字符串相等，而因使用equals方法。
空串""与null串

码点与代码单元： char代表采用UTF-16编码一个码点需要的代码单元，string.length()方法返回的
就是字符串需要的代码单元个数，这样也就解释了"𐐷".length() = 2，这个字符需要2个代码单元。
同时"𐐷".codePointCount(0,2)返回了码点个数，即实际的长度。
```txt
码点和代码单元都是从0开始（和C一样）。
使用"XXX".codePointAt(i)来得到第i个码点的值
如遍历字符串"𐐷 is good",无论使用toCharArray还是使用"𐐷 is good".charAt(i)遍历得到的都是
2个代码单元，可以使用如下的条件判断来遍历输出字符串的各个码点。
for(int i = 0; i < test.length() - 1;) {
  int cp = test.codePointAt(i);
  System.out.print(cp+",");
  if (Character.isSupplementaryCodePoint(cp)) {
    i += 2;   // 补充字符占用2个代码单元
  }else{
    i++;
  }
}
更简单的方法，使用intstream流。
int codePoints = test.codePoints().toArray();
for(int codePoint: codePoints) {
  System.out.print((char)codePoint + ",");  //转换得到另一个特殊字符...
}
System.out.println();
System.out.print(new String(codePoints, 0, codePoints.length())); //由数组反转得到字符串成功
```

构建字符串
StringBuffer是多线程安全的，但性能不如StringBuilder,单线程时应使用StringBuilder.

### 输入输出
读取输入：可以使用System.console对象来从控制台获取密码
printf格式化输出：
% 1 $ , 8.2 f 
参数索引 标志(用,区分3位) 宽度.精度 转换符号
注： 经测试(负数用括号括起与宽度标志冲突，只能使用一个。

文件输入与输出：
Scanner in = new Scanner(Paths.get("D:\\a.txt")), "utf-8");
PrintWriter out = new PrintWriter("D:\\b.txt", "utf-8");

### 控制流程
java break语句可以带标签，从而实现从内层循环跳出，C语言中使用goto语句，java没有goto.
另外java有foreach循环，C,C++没有。

块：
大括号内的内容叫做块，java不允许在嵌套块内重复定义相同变量，C++可以，它允许内层块覆盖外
层块的变量。

while语句的循环体可能一次也不执行，如果想循环体至少执行一次，可以使用
do{...}while(...)语句。

switch语句可能会导致执行多个case语句（在没有break语句的时候），所以一般程序中不使用switch
语句。（jdk 7之后case语句中可以为String类型）

带标签的break与continue语句：
```txt
label{
  ...
  if(condition) break label;  
  ...
}
```
注： break与continue是可选的，完全可以避免使用它们（使用合理的判断条件即可）

### 大数值
BigInteger和BigDecimal
可以使用valueOf将基本类型数值转换为bigInteger或bigDecimal类型

这2个对象加法用add方法，乘法用multiply方法...
注： C++可以自定义重载运算符，Java只重载了+号，它没有并且不允许程序员自己重定义重载运算符。

### 数组

##
<hr />
<img src="http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20190512_1.jpg" class="full-image" />
