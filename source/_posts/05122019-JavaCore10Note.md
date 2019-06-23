---
title: JavaCore10Note
categories: Java
tags:
  - Java
  - Char with UTF-16
  - C++
image: 'http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20190512_1.jpg'
abbrlink: 2a1ddb5b
updated: 2019-06-23 21:54:35
date: 2019-05-12 20:10:28
---
Java, Char with UTF-16, C++, 数组，  
<!-- more -->

**以下是阅读javaCore第10版中文版pdf的笔记，看熟2卷后可以再翻看第11版，因为11目前没找到
中文版>_<**

## 安装java
安装后将jdk安装目录/bin加入到path环境变量即可,不用设置其他。
## 基本程序设计结构
### 数据类型
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
java允许数组长度为0，长度为0的数组也是一个对象，可以用来作为方法返回值，避免返回null，造成
空指针。
数组扩容可以使用
`luckyNumbers = Arrays.copyOf(luckyNumbers, 2 * luckyNumbers.length);`

java数组与C++数组指针基本一致，但它没有指针运算，即不能通过a加1得到数组的下一个元素。

数组排序可以使用Arrays.sort方法，它使用了快速排序算法，
使用Arrays.binarySearch方法实现二分查找
使用Arrays.fill方法将所有元素值设置为统一值
使用Arrays.equals方法比较两个数组是否相同

反转数组：
1. 面试时的回答
先Arrays.sort升序排列，再将第一个元素和最后一个元素互换，直到指针小于length/2(索引从0开始)
2. 实际工作使用
   1. 将数组转换为List,再用Collections.reverse(list)方法反转，最后用list.toArray(newArray)来
   得到反转后的数组。
```txt
  Integer[] c = new Integer[5];
  c[0] = 8;
  c[1] = 3;
  c[2] = 6;
  c[3] = 5;
  c[4] = 2;
  Arrays.sort(c);
  System.out.println(Arrays.toString(c));
  List<Integer> blist = Arrays.asList(c);
  Collections.reverse(blist);
  Integer[] newC = new Integer[c.length];
  blist.toArray(newC);
  System.out.println(Arrays.toString(newC));
```
   2. 使用commons.lang3包中的ArrayUtils工具类，支持int,float,object.
   通过查看源码可见，它也是使用了前后元素交换的算法实现的

随机打乱数组：
1. 网上说比较经典的方法是用Arrays.sort(array, comparator)，其中comparator的compare方法
使用Math.random()来实现在比较时随机产生正负数从而实现乱序，但由于sort排序底层实现中无论是
插入还是快排的比较次数都做了优化，达不到全部元素两两比较的绝对乱序要求。下面是sort的java
代码实现：
```txt
 Integer[] c = new Integer[5];
 c[0] = 8;
 c[1] = 3;
 c[2] = 6;
 c[3] = 5;
 c[4] = 2;
 System.out.println(Arrays.toString(c));

 // Arrays.sort(c, new Comparator<Integer>() {
 //         @Override
 //         public int compare(Integer x, Integer y) {
 //                 double i = 0.5 - Math.random();
 //                 int flag = i < 0 ? -1 : (i > 0 ? 1 : 0);
 //                 System.out.print(flag + ",");
 //                 return flag;
 //         }
 // });
 Arrays.sort(c, (x, y) -> {
   double i = 0.5 - Math.random();
   int flag = i < 0 ? -1 : (i > 0 ? 1 : 0);
   System.out.print(flag + ",");
   return flag;
 });
System.out.println();
System.out.println(Arrays.toString(c));
```
2. 想实现绝对乱序，每个元素都参与比较，可以使用Fisher-Yates shuffle算法，基本思路是通过
随机数得到一个随机索引，将索引的元素值和最后一个元素进行交换，然后是倒数第二个元素，依次
进行即可，这样每个元素都得到了比较和交换的机会，实现了绝对乱序。
```txt
Integer[] c = new Integer[5];
c[0] = 8;
c[1] = 3;
c[2] = 6;
c[3] = 5;
c[4] = 2;
System.out.println(Arrays.toString(c));

int i = c.length;
while (i > 1) {   // i = 1时picked和后面的i都为0，交换自身可省略,选随机数次数为c.length-1
  int picked = new Double(Math.floor(Math.random() * i--)).intValue();
  System.out.print(picked + ",");
  int tmp = c[i];
  c[i] = c[picked];
  c[picked] = tmp;
}
System.out.println();
System.out.println(Arrays.toString(c));
```
注： javaCore书中的抽彩游戏算法与这里的洗牌算法思路相同，不同的是它不是原地排序，而是
将抽中的数字放到一个新数组中。

多维数组的快速打印可以使用Arrays.deepToString(array)方法

### for each循环
必须是一个数组或一个实现Iterable接口的集合，才能使用foreach循环


## 对象与类
面向对象的程序设计过程
1. 识别类
简单的将名词作为类，动词作为方法
注：根据设计模式的解析，类的作用应该是封装变化，应将变化的部分作为一个类
2. 绘制UML图确定类之间的关系

### 使用jdk包中预定义类
1. 对象与对象变量
java对象变量等同于C++中的对象指针
C++对象拷贝可以在类的内部进行，但Java只能通过clone方法。

2. 访问器方法和更改器方法
Java更改器方法会修改类的对象状态，如set方法，而访问器方法不改变当前对象，如get方法。
C++中访问器方法有const后缀，而java中没有语法区别。

3. date
jdk8引入了LocalDate类，可以操作时间
常用api有now(),of(int year,int month,int day),getYear(),getMonthValue(),getDayOfMonth(),
getDayOfWeek(),plusDays(),minusDays(),进一步用法在卷2里有。

### 自定义类
C++构造器可以省略new关键字正常运行，但Java不可以

C++可以在类的外部定义方法，在类内部定义的方法自动成为内联方法（直接用方法体替换方法调用
代码的操作为内联），Java方法是否内联需要由jvm决定，需要内联时首先方法必须为final修饰，
即时编译器才会判断是否需要内联。

LocalDate没有更改器方法，无法改变对象状态，Date有一个setTime方法，可以改变对象状态，
实际上破坏了对象的封装性。如get方法返回Date对象，实际上可以拿到这个date引用对原对象状态
进行改变从而带来危险。
所以，访问器方法应避免返回一个可变对象的引用，若无法避免，应当clone后再返回，从而保护
原对象的封装性。
注：java.time.LocalDate是一个不可变的，线程安全的类。

基于类的访问权限
一个类的方法可以访问所属类的所有对象的私有属性，这在C++中同样适用。

私有方法
如果不想自己的方法被他人调用，应当将方法设置为private,这样当以后删除该方法时就不用担心
有其他地方调用该方法了。

### 静态域与静态方法
静态域
private static修饰一个域时，它也被称为类域，可以修改,但该域无法被其他类访问到(private)，
用public static final修饰常量时，因为常量不可变（final控制），所以可以用public修饰供其他
类使用，同时不用担心封装性被破坏。

注：private限制的是访问范围，static限制的是类变量-无需实例化即可使用。

静态方法
静态方法可以认为是没有this参数的方法，有2种情况使用它
1. 不需要对象状态，只需要显式参数。
2. 只需要访问静态域的方法。
注： C++使用::访问自身作用域之外的静态域和静态方法。
C++与java中static关键字的意义是一样的：即属于类且不属于类对象的变量与函数。

静态工厂优点
1. 因为构造器必须与类名相同，静态工厂不受此限制，相当于带名字的构造器。
2. 构造器没有返回值，它构造的对象类型就是当前类，静态工厂可以构造当前类的子类对象返回，
更加灵活。

### 方法参数
值传递 call by value
引用传递 call by reference
java只有值传递，针对基本数据类型很好理解，被传的参数值无法被改变;针对对象引用类型，java
会拷贝一份该对象的引用，该引用和原参数对象引用指向同一个对象，改变其中一个另外一个引用也受到
了影响，从而实现了改变对象的目的。

证明java是值传递-即拷贝了引用的值，而不是引用传递-传递对象地址的是如下代码：
```txt
public class A{
  public void main(String[] args){
    P a = new P(1);
    P b = new P(2);
    swap(a,b);     
     //执行可以发现swap没有生效，因为swap内交换了拷贝的引用，对原来的a,b对象引用无影响
    System.out.println(a.getId());
    System.out.println(b.getId());
  }  
  public static void swap(P x, P y){
     P tmp = x;
     x = y;
     y = tmp;
  }
}
class P{
  private int id;
  ...
}
```
从这个程序可以总结出下面这个关键的结论：
**一个java方法不能让参数对象指向一个新的引用，它在方法内始终是以拷贝的形式存在的。**

这一点从以下代码片段看的更清楚：
```txt
public class A{
  public void main(String[] args){
    P a = new P(1);
    newP(a);
    System.out.println(a.getId());  //还是打印1
  }  
  public static void newP(P x){
    x = new P(888);    // 对传递进来的a对象无影响
  }
}
class P{
  private int id;
  ...
}
```
1. 方法无法改变基本类型的参数对象。
2. 方法可以改变引用类型对象的状态。
3. 方法无法将引用类型参数对象指向一个新的引用。

注：C++有值传递和引用传递，引用参数使用&来进行标识。

### 对象构造
重载
方法签名不能重复，它包括方法名和参数类型，返回值不是签名的一部分

域初始化
java可以直接初始化各个域，C++不行，C++只能在构造器中对域进行设值，但它有特殊语法连续调用
多个构造器。

参数名
C++通常对实例域加上特定的前缀`_`,x,m等，java没有。

调用另一个构造器
java可以使用this(...)来调用另一个构造器,这样可以使得公共构造器编写一次即可。
C++无法进行构造器间调用,必须将公共部分编写成一个独立的方法。

构造器执行顺序
1. 所有域被初始化成默认值。
2. 按照声明顺序依次执行域初始化语句和初始化块。
3. 如果第一行调用了其他构造器，执行其他构造器。
4. 执行接下来的构造器主体。

注：jdk 6以前可以使用静态初始化块来打印hello world，jdk7以后则会先检查是否有main方法
```txt
public class Hello{
 static {
  System.out.println("hello world"); //类第一次加载的时候会进行静态域的初始化
 }
}
```

C++有显式的析构器方法，Java因为有自动垃圾回收机制，所以不需要手动回收内存。
finalize方法会在垃圾回收器清除对象前被调用，但无法确定时间,所以不推荐使用它。

### 包
包名层级通常是域名的倒序。以前没有注意过这一点，这样我写的代码包应为cn.taoblog

一个类可以使用所属包中的其他类和其他包中的公有类。
由此可知，同私有方法一样，如果不想外界调用该类，可以将其设置为私有类，仅供同包的其他类使用。
这种情况该私有类一般作为内部类。

静态导入
import是导入一个类，import static可以导入静态方法和静态域，如使用
`import static java.lang.System.*`之后可以将
`System.out.println(...)`直接写为`out.println(...)`

不过实际这样写不好理解，可以针对特定类使用，如
`sqrt(pow(x,2) + pow(y,2))`比
`Math.sqrt(Math.pow(x,2) + Math.pow(y,2))`要清晰很多。

编译器不会检查目录结构，即如果package声明错误，如果该类没有依赖其他包，编译不会报错，
程序可以正常执行...
(经实际测试，比如一个在目录com.demo下的类Test，如果包声明为com,编译后可以发现它的class
文件是出现在target/com目录下的。同样的javac命令指定-d选项时它也是根据包声明来生成字节码
文件目录的(如javac -d . Test.java)，这样如果Test类中需要引用com.demo包下的其他类时，
同样需要import语句，这就违反了目录和包的一致性，造成程序理解困难和隐藏问题，
所以包声明报错虽然不影响程序编译和运行，但可能会需要不必要的import和其他潜在问题)

类或域如果没有public，private修饰，默认是同一个包内的方法可以访问到（default).
而默认情况下，包是可见的，即任何人都可以向一个包中添加更多的类，如在自定义的类中修改
package声明，并将该类放置在对应目录下即可访问目标包中的其他类。

jdk本身由于修改了类加载器，禁止加载用户自定义的，包名以java.开始的包来达到安全防范的目的，
但用户自己的包没有这个特性，不过可以通过包密封(package sealing)机制来解决这个问题。
包被密封之后，就不能再向这个包中添加类了。
(经实际测试，自定义一个包java.mypack,实例化其中的类编译成功，运行报错
java.lang.SecurityException: Prohibited package name: java.mypack,
说明了自定义包不能以java开头)

可以使用jdk自带的jar工具来生成自己需要的jar包。可以使用如下命令来指定Manifest文件：
先新建一个名为manifest.txt的文件，内容可以为
`Sealed: true
` // 需要一个回车才能生效
然后执行命令
`jar cvfm  XXX.jar .\manifest.txt .`(可以查看jar --help)

而jar包是否密封可以通过Manifest中的`Sealed: true`进行配置，可以指定多个包或整个jar包
进行密封，如果包密封后发现有相同包在不同类中的情况出现，会抛出sealing violation异常。
主要有以下2种情况：

(在URLClassLoader类的源码中可以看见)
1. 尝试加载一个已经被密封的包,报错sealing violation: package is sealed.
2. 尝试密封一个已经被加载的包，触发安全异常，报错sealing violation: already loaded.

这样，包密封增强了版本的一致性和安全性。
(查看spring和mybatis的jar包可以发现它们都没有进行包密封，应该是开源的原因，不过目前都是
统一由maven或gradle统一管理jar包，也不用担心这个问题，自己的项目产品还是应注意这个问题。)

[**密封性测试代码地址**](https://dev.tencent.com/u/wutaotao/p/mybatis-demo/git/tree/master/self-stuff/src/main/java/com)

测试时先将Test1,Test2打成jar包(注意检查生成的jar包的包目录结构和MANIFEST.MF文件内容)，
然后注释掉相应代码，运行TestSealException类来进行测试，因为类加载后无法卸载，所有需要
一个个案例单独测试。
结论在代码中已指出：
1. sealing violation: package is sealed.
2. sealing violation: already loaded.
3. sealed package不包括被密封的父类包
3. sealed package不包括被密封的子类包

关于jar和包密封性在javacore version10的第13章，书中说第9章，也算一个小错误。

### 类路径
类路径是所有包含类的路径的集合。
windows中用;分隔，unix下中用:分隔。
(刚学java时配置环境变量我们被要求配置classpath变量(这是不好的行为)，其值类似为
`.;%JAVA_HOME%\lib;%JAVA_HOME%\lib\tools.jar`，其中.代表当前目录，默认的类路径中包含了
当前目录，如果自定义的类路径中少了.,会导致类编译通过，运行失败，具体测试如下：
使用javac命令进行编译时注意包结构，如以下命令
```txt
javac .\com\demo\Test.java
java com.demo.Test   //测试成功
java -classpath %JAVA_HOME%\lib com.demo.Test   //运行失败，报错找不到或无法加载主类Test
java -classpath %JAVA_HOME%\lib;. com.demo.Test   //加上当前目录后运行成功
```
)
虚拟机搜寻一个类时，首先查看jdk自带的lib中是否包含，若未找到，再根据类路径进行逐个查找。

注：java -jar运行jar包时会屏蔽环境变量和命令行中的classpath，可以使用下列方法来引用其他的
jar包：
1. -Xbootclasspath/a: 后缀。将classpath添加在核心class搜索路径后面。常用!!
2. 在jar包内的MANIFEST.MF文件中添加`Class-Path: XXX.jar`,路径为该jar包对当前jar包的
相对路径。

### 文档注释
只需要对公有域(静态常量)建立注释
生成javadoc文档
`javadoc -d D:\javadoc\ com.demo`
若想生成的文档详细，文档注释需要很详细

### 类设计技巧
1. 保证数据私有
   即不要破坏封装性，如访问器方法返回一个可变对象显然不行，应clone后再返回。
2. 明确初始化数据
3. 不要使用过多基本类型
   可以将部分域分离为另外一个类，实现类的单一职责和灵活性
4. 不是所有域都需要get和set方法
5. 职责过多的类分解
   同3
6. 类名和方法名要体现职责
   命名明确
7. 优先使用不可变的类
   同1保护封装性原则

## 继承 
is-a关系是继承的一个明显特征。
注： java中所有继承都是共有继承，没有C++中的私有继承和保护继承。

子类虽然继承了父类的域和方法，但由于域的私有性，子类中不能直接访问这些域，所以它需要通过
访问器来访问这些域，如调用`super.getId()`来获取。
注：C++中使用父类名::方法名来获取父类域的值，如`Parent::getId`.

同样的，子类的构造器也无法直接访问这些私有的父类域，所以需要通过如`super(id,name)`调用
父类的构造器来对这些域进行初始化。
注： 调用其他构造器的语句必须是第一条语句，如`this(xxx,xxx)`,`super(xxx,xxx)`.

如果没有这样显式的调用父类构造器时，默认调用父类的无参构造器，如找不到编译器会报错。
注：C++不使用super调用父类构造器，它使用初始化列表，如
```txt
Manager::Manager(String name,int salary)
: Employee(name, salary)
{
  bonus = 0; 
}
```

注： 经测试，子类会继承父类实现的接口，如父类实现了记号接口RandomAccess,子类对象使用
instanceof关键字可以测试出子类也实现了RandomAccess接口。另外，子类中与父类的同名属性
不会覆盖父类的属性，它们可以拥有不同的值。


多态： 一个变量可以指示多种实际类型的现象叫多态。
动态绑定： 运行时能自动选择调用哪个方法的现象叫动态绑定。
注： java中动态绑定是默认行为，不用声明为虚拟方法(C++中需要),可以声明为final来取消虚拟特征。

子类和父类数组转换问题
有如下代码:
```txt
class Parent{
} 
class Child extend Parent{
} 
public class Test {
 public static void main(String[] args) {
     
   Child[] cs = new Child[];
   Parent[] ps = cs;   // 子类元素数组向上转型为父类元素
   ps[0] = new Parent();
 }
}
```
如上代码编译成功，但运行时报错java.lang.ArrayStoreException,因为ps[0]和cs[0]指向的是
同一个对象，ps[0] = new Parent()就相当于cs[0] = new Parent(),父类转化为子类，从而引起
了数组存储异常。因编译器无法检查出这个问题，所以当使用数组时，需要牢记它的元素类型，只
向其中存储能够转化为该元素类型的元素。

对象调用过程x.f(args)
1. 查找对象x类型和方法名f
2. 重载解析(子类重写方法返回值可以为父类方法的子类型，称为具有可协变的返回值类型，同时
重写的子类方法的可见性(public,private等)不能低于父类方法.

经测试，父类私有(private)的方法不能被重写(破坏了封装性),其他default,protected,public可以
被重写，如果子类的可见性更低，如父类是protected,子类是private,那么根据替换原则(子类可以替代
所有父类对象出现的地方)子类可见性更低可能会导致原代码无法访问的情况，所以重写的方法需要
可见性更强来避免这个问题，这种情况编译器会报错：attempting to assign weaker access privileges.)
这样看，public access privilege is strongest.

3. 如果方法是private, static,final修饰或构造器，则编译器可以准确找到需要调用的方法，这
称为静态绑定，相反，调用方法依赖于对象x的实际类型称为动态绑定(多态)。
4. 动态绑定时，会从最接近x实际类型的方法开始匹配，如子类无该方法，会在它的父类去查找，
依次类推。

为了加快方法查找过程，虚拟机会为每个类生成一个方法表，列出它的所有方法(包含继承自父类的
方法)。即在查找需要调用的方法时，虚拟机根据实际对象类型调出对应类的方法表，在该表中查找
对应的方法并进行调用即可。

阻止继承：final类
使用final修饰的类无法被继承(public final class A{}),
使用final修饰的方法无法被重写(public final void B(){}),
由于final类无法被继承，它里面的方法都是final方法，没有子类，没有重写,final修饰符不用
写明。但是它的域没有自动变为final，实例化后还是可以改变值的。
(经测试，声明域为final后，编译器会检查是否有赋予初始值，可以在域声明后赋予初始值，也可以
在无参构造器中赋值，只在有参构造器中赋值无效，同时如果有对该域的set方法存在，编译器同样
会报错: cannot assign value to final variable)

注：C++和C#中，所有方法默认都没有多态性，相当于默认全都加了final修饰，无法被重写。

早期的时候，使用final修饰一个方法，编译器检测到该方法没有被覆盖并且很简短，编译器就会对它
进行内联处理。
现在即时编译器处理能力强很多，如果方法简短，频繁被调用并且没有被覆盖，它会自动进行内联处理，
如果虚拟机加载了另一个类，它有覆盖该内联的方法，虚拟机又会取消内联。

向下转型
父类对象可以强制转换为子类对象，如果转换不成功，会抛出ClassCastException.
应养成判断的习惯(if xxx instanceof yyy)
另外，如果强转类型不是子类，编译器会报错。
注： null instanceof XXX 是false,不会产生空指针异常
注2： 如果碰到需要强制转型的情况，应考虑父类的设计是否合理。
注3： 强制转型类似于C++中的`dynamic_cast`操作，只是如果转换失败，它不会抛出异常，而是生成
一个null对象。类型测试和转换代码如下：
```txt
Child* ch = dynamic_cast<Parent*>(pa);
if (ch != null) {...}
```

抽象类
有一个或多个抽象方法的类必须被声明为抽象类。
反过来，抽象类中可以没有抽象方法。
抽象类无法被实例化，但可以作为变量引用非抽象子类的实例。
注：C++中用尾部 = 0的方式来标记一个抽象方法，称为纯虚函数。
有纯虚函数即为抽象类，C++中没有抽象类的关键字。

受保护访问
protected访问范围是所有子类以及同包的其他类，这与C++的保护机制不同。
protected域由于可以被子类直接访问到，变动父类时需要通知子类，违反了封装性。protected方法
适用性强一点。

Object
Object是所有类的超类，包括基本数据类型和引用类型的数组！如`Object obj = new int[3];`
只有基本类型(数值，字符，布尔)不是对象——通过自动装箱技术它们会转成对应的包装类。
注：C++没有超类，但指针都可以转成`void*`.

equals方法
Object的equals方法只有一句`return this==obj`,它只比较2个对象的地址。
如果想要调用this或obj的equals方法进行自定义比较，可以使用`java.util.Objects`(jdk7引入)的
equals方法`return （a == b) || (a != null && a.equals(b))`.

(经测试，如Child类继承Parent类，则
```txt
Child ch = new Child();
if (ch instanceof Parent) {...}  // 表达式为true
```
即instanceof是检测对象是否是后者的实例或子类实例，在equals方法中检验2个对象的类型是否相同，
以前是使用instanceof来进行检验，但根据equals要求的对称性(x.equals(y)与y.equals(x)结果相同)
, 当parent.equals(child)为真时，child.equals(parent)也为真，这样就使得Child类中的equals方法
无法对Child类扩展的域进行检验的问题，这个问题本质还是出在instanceof关键字允许子类也为真的
情况上。
针对这个问题，有2种情况，一个是子类的扩展域不影响相等性，即不进入比较的话，可以使用
instanceof关键字，另一个是如果扩展域也需要比较的话，就不能使用instanceof关键字，可以使用
getClass()来明确指定类必须相同;所以如果一个类的equals方法使用了instanceof关键字，那么
它的子类重写equals方法就几乎没有意义了，因为如果它比较了扩展域，就违反了对称性原则，所以
一般应该将instanceof与final修饰符配合使用，反之则使用getClass()方法)

注：该问题具体案例可见jdk源码中的
```txt
父类： java.util.Date  其中的equals(Object obj)方法使用了instanceof
子类： java.sql.Timestamp  其中equals(Object obj)方法中注释指明了这一点
"Note: This method is not symmetric with respect to the equals method in the base class"
```
注：equals方法应满足自反性，对称性，传递性，一致性。

完美equals方法建议:方法签名为equals(Object otherObject)
1. if (this == otherObject) return true; 是否是同一个对象
2. if (otherObject == null) return false; 是否为null
3. if (getClass() != otherObject.getClass()) return false; // 不用instanceof
或 if(!(otherObject instanceof  ClassName)) return false;
   // 建议方法更改为final，final可以与@Override共存
4. 若使用了instanceof，将其强制转换类型
5. return 各个域的比较结果，基本类型使用==，引用类型使用java.util.Objects的equals方法，
它可以进行null值判断和调用域自身的equals方法，数组类型使用Arrays.equals方法。

hashCode方法
Object的hashCode方法默认是对象的存储地址。
一般来说：
1. 将对象放入容器中，需要重写equals方法，可以通过比较对象内容来进行判定业务上对象相等。
2. 将对象放入散列表中(如HashMap,HashSet等),需要重写hashCode方法，以保证equals相等的2个
对象在散列表中对应着同一个键！
3. 将对象放入有序列表中，需要实现Comparable接口，重写compareTo(T o)方法，或者自定义一个外部
比较器Comparator,重写compare(T o1, T o2)方法。

针对多个域的hashCode计算可以调用java.util.Objects.hashCode(Object... values)方法，其中有
对null值的处理。
如上面总结的一样，equals方法返回true时，hashCode方法也必须返回true.
具体表现为equals处理的域必须出现在hashCode方法中。
注： 数组类型的域可以使用Arrays.hashCode方法。

toString方法
查看Object的toString源码可见toString方法为
`return getClass().getName() + "@" + Integer.toHexString(hashCode());`
可以看出对象默认输出的是类名+哈希码的16进制表示，数组也是Object类型，
只不过它前面的类名比较特别，如[I表示的是整型数组，[Lcom.demo.Test;@XXX表示的是对象Test数组

泛型数组列表-ArrayList
java5以后提供了泛型，使用时可以省略右边的泛型参数
`ArrayList<String> list = new ArrayList<>(100);`
ArrayList默认大小是10。
注：arraylist类似于C++中的vector,vector可以使用[]来访问元素，因为它重载了[]运算符，
另外vector a = b;语句会重新拷贝一个vector赋给a,而ArrayList a = b;只是让a,b指向同一个
引用。

arraylist使用add,set,get方法来对元素进行控制，某些情况下转换成数组更加方便：
```txt
ArrayList<P> list = new ArrayList<>();
list.add(new P(1));
list.add(new P(2));

P[] pa = new P[list.size()];
list.toArray(pa);
```

泛型仅在编译时有效，编译成的字节码中没有任何泛型参数，即类型擦除。
这个特性会造成以下问题：
1. 泛型重载无效(编译报错)，
2. 泛型类中静态域共享(不同泛型类对应同一个类),
3. 捕捉异常catch语句内泛型参数无效(java运行时处理异常)

自动装箱
所有的对象包装器类都是不可变，无法继承(final)的。
通过反编译代码`Integer a = 100`编译后的字节码，可以发现对于自动装箱，编译器会自动调用
`Integer.valueOf(100)`方法，同理自动调用`i.intValue()`方法。
即自动装箱和泛型参数一样，属于编译器层面的操作，与虚拟机无关，可以看作语法糖。

自动装箱规范要求boolean,byte,char<=127, short and int between -128 to 127这之间的数值
被包装到固定的对象中，所有有以下代码：
```txt
Integer a = 100;
Integer b = 100;
Integer c = 1000;
Integer d = 1000;
System.out.println(a == b); // true: same wrapping objects
System.out.println(c == d);  // false: different wrapping objects
Character e = (char)128;
Character f = (char)128;
System.out.println(e == f);  // false: different wrapping objects
Character g = (char)127;
Character h = (char)127;
System.out.println(g == h); // true: same wrapping objects
```

自动装箱在运算符中也能自动进行：
```txt
Integer i = 10;
i++;
```
包装器内还包含了如`int i = Integer.parseInt(string)`这样对于不同类型间转换的静态方法。

注：包装器是不可变的，所以方法参数值传递也无法通过包装器对象来改变值，可以使用如IntHolder
类（jdk自带）来变更基本类型的值，它的域value是public访问权限，这样通过改变参数对象状态来
改变基本类型值。

可变参数
可变参数也是编译器层面的语法糖，它将实际传入的多个参数转化为对应的数组。
反过来，如果原来代码的最后一个参数是数组类型，就可以将它变为可变参数，这样对生成的字节码
文件没有任何变化。如`public static void main(String[] args){}`可变为`public static void
main(String... args){}`.

枚举
枚举也是编译器层面的语法糖，它将枚举类编译成一个继承了Enum类的final类。
```txt
enum Size{

  SMALL("s"), MEDIUM("m"), LARGE("l"); // 调用构造器创建多个枚举实例

  private String abbr;   // 自定义域
  private Size(String abbr){//私有构造器
     this.abbr = abbr;
  }  
  public String getAbbr(){return abbr;}
}
```
编译后使用`javap Size.class`进行反编译可以看到生成的枚举类。
上面例子中S,M,L都是Size类的public static final实例，
可以使用`Size size = Size.S`直接得到一个枚举值。
`size.toString()`得到枚举常量名，`Size s = Enum.valueOf(Size.class, "S");`可以通过字符串
得到枚举值。`Size.values()`返回一个包含所有枚举值的数组，(Enum类中的valueOf与枚举类中参数
不同，并且Enum也没有values方法，它们应该是编译器自动添加的),Enum和枚举类都有ordinal()方法
返回枚举的索引值，从0开始。compareTo方法比较的即为2个枚举的索引大小。

反射
获取class对象
1. object.getClass();
2. Class.forName("XXX");
3. T.class (如Random.class, int.class, Double[].class)
Class类实际是一个泛型类，如String.class类型为`Class<String>`，大多数时候可以忽略这个泛型
参数，直接使用原始class类。
可以使用==来比较2个class对象是否相同，使用`Class.forName("XXX").newInstance()`来根据字符串
调用无参构造器得到一个对象。(调用有参构造器需要Constructor类)
```txt
class P{
  private int id;
  public P(int id){this.id = id;}
  public int getId(){return id;}
}
public class Test{
 public static void main(String[] args) {
   Class pc = P.class;
   try{
     Constructor con = pc.getConstructor(int.class);  // 获取构造器，带上参数类型
     P p = con.newInstance(667);  // 调用有参构造器
     System.out.println(p.getId());
   }catch(Exception e){
     e.printStackTrace();
   }
 } 
}
```

捕获异常
异常分2种，已检查异常(需要使用try-catch捕获)和未检查异常(如空指针等)
对于已检查异常，如果没有进行捕获，编译器会报错：unhandled exception.

利用反射分析类
Class类的getFields,getMethods,getConstructors方法返回类提供的公有域，方法，构造器(fields和
methods会包含父类的公共域和方法，构造器只会显示本类构造器，另外不会显示未写明的默认无参构造器),
getDeclaredFields,...Methods,...Constrcutors方法会返回类声明的所有域，方法和构造器，包括
私有和保护成员(它们都只针对本类，不包括父类信息)。
(getDeclaredFields如果class是基本类型或数组类型，或者没有任何域，它将返回一个长度为0的数组。)

Field, Method, Constructor常用方法
all.getName(), 
F.getType(),
M&C.getParameterTypes(),
M.getReturnType(),
all.getModifiers()    // 返回int值以指示修饰符

注：使用Modifier.toString(int i)可以获得修饰符的字符串表示。
Modifier.isFinal(int i)可以判断修饰符是否是final，其他方法同理。

利用反射分析对象
对于编译时无法确定域值的对象(如外界传递过来的参数对象)可以利用反射得到它的域值。
```txt
class C{
 private int bonus;
 public C(int bonus) {this.bonus = bonus;}
}
public class Test{
 public static void main(String[] args){
   C c = new C(1000);
   Field[] fields = c.getDeclaredFields();
   for(Field f : fields) {
     System.out.println(f.get(c)); //编译器报错unhandled exception:IllegalAccessException
   }
 }
}
```
因为bonus是私有的，所以无法直接访问，即反射受到访问权限限制。
这时需要调用Field,Method,Constructor共同父类AccessibleObject中的一个方法
`setAccessible(true)`
来解除限制。这里f.get(c)返回的是object类型，进行了自动装箱，如果想返回int，
可以使用getInt()方法，同理getDouble()等。

ObjectAnalyzer程序分析：
class.isArray()  判断class类型是否是数组
class.isPrimitive()   判断class类型是否是基本类型：
   boolean,character,byte,short,integer,long,float,double,void(java.lang.Void) 
class.getComponentType()  返回数组元素类型，如果不是数组class返回null

Array.getLength()   java.reflect.Array类中的方法，返回数组长度
Array.get(Object, int) java.reflect.Array类中的方法，返回数组中第i个元素值
AccessibleObject.setAccessible(AccessibleObject[], boolean) 对AccessibleObject数组统一赋予
   访问权限，其子类包括Constructor, Field, Method
Modifier.isStatic()  判断是否是static修饰符，程序中不打印静态域
field.getType()  获取域类型，程序中判断是否是基本类型
field.get(Object) 获取域的值对象
field.set(Object classObj, Object newvalue)  使用新值替换object中的当前域

class.getSuperclass()  获取当前class类的父类 

注：程序执行是先打印本类的非静态域类型和值，然后是逐层向上，查看父类的非静态域值，所以可以
看到每个类后都至少有一个`[]`(因为java.lang.Object类无域);
同时可以看到它把ArrayList的初始值10个后面未用到的null值元素都打印出来了;
实现循环引用很简单，在类中定义一个自身的实例指向this即可:
```txt
class C{
 private C c = this;
}
```

使用反射编写泛型数组
使用`System.arrayCopy(oldArray, startIdx, newArray, startIdx, length)`来扩充数组时，在编写
泛型化时，由于Object[]无法强转为具体的数组类型，所以需要通过java.reflect.Array来获取具体的
数组元素类型并进行初始化，主要用到以下三个方法：
```txt
class.isArray()  判断class类型是否是数组
class.getComponentType()  返回数组元素类型，如果不是数组class返回null
Array.getLength()   java.reflect.Array类中的方法，返回数组长度
Array.newInstance(Class componentType, int length)  元素类型和数组长度(一维) 
Array.newInstance(Class componentType, int... dimensions)  元素类型和数组长度(多维) 
```
newInstance方法可以让我们动态的创建一个与原数组相同类型的空数组，这样再使用System.arrayCopy()
方法即可以获得一个可以进行强转的数组了。
(基本类型数组拷贝需要方法的参数和返回值为Object,因为如int[]可以转成Object,无法转成Object[]，
反过来这样Object也可以强转为int[])

方法指针
可以通过
`class.getMethod(String methodName, Class... parameterTypes)`
指定方法名和参数类型列表(完整方法签名区别重载)来获得方法指针，再通过
`method.invoke(Object implicitObject, Object... parameters)`
指定调用的隐式和显式参数来调用该方法。
通过invoke方法进行回调比直接调用速度要慢一些，所以一般不推荐使用，建议使用接口或lambda表达式。

继承设计技巧
1. 公共操作和域放在超类中
2. 不要使用protected域
   protected域子类和同包类都能访问，破坏了封装性。
   protected方法适用于不能作为公共public接口，同时需要在子类中重新定义的方法
   (default只有同包可见，经测试在其他包中定义的子类无法重写父类方法，同理父类private方法
   子类不可见，也不可重写，由此可见，是否能重写受到被重写方法能否被子类访问的限制，不一定
   是这个原因，但可以这样记忆)。

   注：static是静态绑定，重写多态是动态绑定，运行时确定，所以static方法不能被重写。

3. 继承是is-a关系，不是的情况应不使用继承。
4. 除非继承的所有方法都有意义，否则就不应使用继承。 
5. 覆盖方法时不要偏离该方法最初的设计目的，预期行为。 
6. 如果代码有对于不同类型的判断并进行相同概念的行为，应使用多态或接口实现。
7. 不要过多使用反射，因为编译器难以发现错误。

## 接口，lambda表达式，内部类
### 接口
接口中的方法默认public，public可省略，所以重写接口方法时必须为public(重写访问限制)
接口没有实例域，
jdk8之后可以实现简单方法。

如实现`Comparable<T>`接口，重写compareTo(T t)方法。
因为Arrays.sort(Object[] obj)源码实现中进行了Comparable强转并使用compareTo方法，
所以如果obj中元素类型没有实现Comparable接口，会在运行中报错ClassCastException，而关于这点，
编译器并不会给出报错信息。
注：compareTo方法与equals方法一样，关于继承重写有对称性的问题(x.compareTo(y) < 0则
y.compareTo(x) > 0)，解决方法也类似，分2种情况：
1. 比较时涉及到子类属性时，应使用getClass()方法进行类型判断，类型相同才进行比较，否则抛出
类型转换异常。
2. 比较时不涉及子类的属性，应在父类中定义compareTo方法并定义为final.
(经测试情况2,父类实现了泛型的Comparable接口，子类就不能实现自己的泛型类型了，编译器报错(XXX
interface cannot be inherited with different type arguments)，因为子类会继承父类的接口类型。
这样在对子类数组进行排序后，虽然实现了排序，但其中的元素都自动向上转型为父类类型了...)

接口特性
同抽象类一样，不能使用new运算符实例化一个接口。
同抽象类一样，可以声明接口变量，指向接口的实现类。
可以使用instanceof关键字判断一个对象是否实现了某一个接口，如`obj instanceof Comparable`.
接口中的方法默认public,接口中的域默认public static final,
实现了接口的类自动继承了接口中的常量，可以直接使用如NORTH,而不用使用TestInterface.NORTH。

接口和抽象类的区别
1. 方法实现：抽象类可以有方法实现，作为普通方法可以被子类继承，接口在jdk1.8以后可以定义
默认方法和静态方法，在这一点上两者相同。
2. 继承或实现：抽象类使用extends来继承抽象类，子类如果不是抽象类，需要实现父类的所有抽象
方法;接口使用implements实现接口，需要实现类实现所有抽象方法。
3. 构造器：抽象类可以有构造器，接口不能有(定义时报错abstract method cannot have body)
4. 访问修饰符：抽象类没有限制，接口方法默认public,无法修改。
5. main方法： 抽象类有，接口没有
6. 多继承： 抽象类只能继承一个类，接口可以继承多个接口
7. 添加新方法： 抽象类添加了新方法，如果有具体实现，不影响子类，同理接口的默认方法也不影响。
如果添加的是抽象方法，抽象类的子类和接口实现类都需要提供该方法的具体实现。

注： C++支持多继承，带来了很多复杂特性，也很少被使用。

静态方法
jdk8中接口可以定义静态方法，以前静态方法通常是放在伴生类中，如Collection/Collections,
Path/Paths，jdk8以后可以合并到接口中。

默认方法
jdk8后接口可以使用default关键字定义默认方法。
定义了默认方法后实现类就可以不必强制实现这些默认方法了，同抽象类一样，可以让某些方法提供
默认行为，从而实现类无需管理。
默认方法可以调用任何其他方法，包括抽象方法。

接口演化(interface evolution): 指接口新增了一个抽象方法，遗留的类重新编译会由于没有实现
该方法而产生编译错误，如果不重新编译(如使用jar包),在遗留类的实例上调用该新增方法将抛出异常，
默认方法即解决了这个问题。重新编译时遗留类不必实现默认方法，调用新方法时也会直接调用接口的
方法。

解决默认方法冲突
一个接口定义了一个默认方法，又在超类或另一个接口中定义了同样的方法，会发生什么？
1.超类优先。超类方法会覆盖所有同名同参数类型的默认方法。
2.接口冲突。实现类实现了2个接口，这2个接口都实现了相同的方法，编译器报错：
`inherits unrelated defaults for XXX() from I1 and I2`,
这时首先需要在实现类中重写这个方法，在该方法内可以通过如`I1.super.XXX();`的方法来调用I1或
I2的默认方法。
注： 如果相同的默认方法中有一个是抽象方法，实现类编译器也会报错，要求实现该方法，而不是
自动使用另一个接口的默认方法。
3. 在2中报错是unrelated defaults,如果I2 extends I1,则以I2中的默认方法为准，这样就不存在
冲突了，class A implements I1, I2 与 class A implements I2是等价的。此时再调用
`I1.super.XXX()`时编译器报错：`redundant interface I1 is extended by I2`

注：由于类优先的原则，自定义接口并实现equals,toString等默认方法无效果，应在类中重写这些方法。

### 接口示例
1. java.swing.Timer定时回调实现了ActionListener接口的类对象
2. 在无法改变源码或已有compareTo方法的情况下，可以自定义一个实现了Comparator<T>接口的类，
T为需要比较的对象类型，实际使用时还需要实例化该比较类(使用lambda表达式更方便)。
3. 对象克隆需要实现Cloneable接口,这是一个标记接口，无任何实际作用(唯一作用是可以使用
instanceof判断类是否实现了它),对象克隆需要以下几步：
   1. 实现cloneable接口
   2. 重新定义clone方法，修改访问权限为public，返回值为当前类型对象以供外界使用。
   3. 拷贝被克隆对象中是否有可变域，即是需要浅克隆(调用(XXX)super.clone()即可)还是深度克隆
      (考虑给可变子域也实现clone方法)。

  Object中clone方法为protected的原因: 
  因为Object是所有类的父类，不能保证Object类的
  子类中所有域都是不可变或是可以克隆的，所以Object中clone方法不是public,而是protected,
  希望子类能根据自己的情况重写clone方法。
  
  注：
  1. 所有数组默认可以使用clone方法进行拷贝，经测试对象数组直接调用clone方法为复用对象
  引用，并没有克隆对象。
  2. 原想可以使用上文中的反射Array.getComponentType(),Array.newInstance(),System.arrayCopy
  来实现克隆，后来查看了Arrays.copyOf()方法的源码，正是这样的实现思路，测试后发现它
  仍然是复用引用，即浅拷贝。问题出在System.arrayCopy上，这是一个native方法，它拷贝的结果
  即为直接复用了对象引用,它的内部实现应该是`copy[i] = original[i]`。
  3. 同理，ArrayList的clone方法中使用了Arrays.copyOf()方法，同样是浅拷贝。
  4. 由以上可知，想实现对象数组或集合的深拷贝，需要自己遍历数组或集合对每个元素调用clone方法，
  数组自身clone,Arrays.copyOf,arraylist.clone方法都不能实现这个目的，它们仅适用于基本类型。

### λ表达式 
为什么需要λ表达式？
在上文的定时器Timer调用ActionEvent接口实现类和排序需要的compare方法中，定义的代码块都是
在以后将会被调用的方法，这里都通过实例化一个对象来调用这个方法，比较麻烦，λ表达式
以更为简洁的方式来解决这个问题。

λ表达式原义为带参数的表达式,如(String x, String y) -> x.length() - y.length().
如果没有参数，括号也不能省略，如() -> System.out.println("hello world").
如果参数类型可以推导得出，可以省略参数类型，如
`Comparator<String> comp = (x,y) -> x.length() - y.length();
如果方法只有一个参数，且类型可推导，则可省略小括号，如
`ActionListener listener = event -> System.out.println("now is " + new Date());`
λ表达式不需要指定返回值类型，它会根据上下文推导得出。

函数式接口
主要是java.lang.FunctionalInterface注解，它本身也是一个记号接口，无任何内容，由其注释可知：
一个接口如果只有一个抽象方法(除了java.lang.Object类中的public方法),那么它就是一个函数接口，
不管该接口有没有添加FunctionalInterface注解。Comparator接口就只有一个compare方法和equals
方法(与Object相同),它就是一个函数接口。因为所有类都继承自Object类，Object public方法全都
默认有实现，所以它不计入抽象方法中。

函数式接口的作用也体现在FunctionalInterface注解的注释中：
`Note that instances of functional interfaces can be created with lambda expression,
method references, or constructor references`,说明λ表达式，方法引用，构造器引用的使用
对象就是这个函数式接口。

λ表达式的作用就是转化为函数接口，其他语言的函数特性都不支持。
java.util.Function包中定义了大量的函数式接口，常用的如Consumer,Predicate,Supplier等。
即如果想使用λ表达式，除了已有的之外，可以自定义一个函数式接口来接收λ表达式，加上
FunctionalInterface注解。如
```txt
@FunctionalInterface
interface OI{        // public无论class, enum, interface，@interface都要求和文件名一致
  int oper(int x, int y);
}
public class Test{
 public static void main(String[] args) {
  print((x,y) -> x + y, 10, 2);  // 调用者通过λ表达式来确定对操作数的操作逻辑
  print((x,y) -> x - y, 10, 2);  // 实现了操作逻辑的动态变化
  print((x,y) -> x * y, 10, 2); 
  print((x,y) -> x / y, 10, 2); 
 }  
 private static void print(OI o, int x, int y) {   // 操作逻辑，操作数
   //这里进行简单的打印，实际上可以在操作之前和之后进行一些自定义的操作。
   System.out.println(o.oper(x,y));  
 }
}
```
即分三步来使用λ表达式：
1. 自定义函数式接口(jdk自带的可省略)
2. 定义接收1中接口为参数的方法
3. 调用2中方法使用λ表达式定义想要实现的操作

如下调用java.util.functino.predicate函数接口：
```txt
public class Test{
 public static void main(String[] args) {

   print(x -> (Integer)x == 0, 0);  // int类型为Object，需要转为Integer进行比较
   print(x -> (Integer)x - 1 == 0, 2);  // int类型为Object，需要转为Integer进行比较

   // 调用Arraylist的removeIf方法
   ArrayList<Integer> list = new ArrayList<>();
   list.add(2);
   list.add(null);
   list.add(3);
   System.out.println(list.size());  //3
   list.removeIf(e -> e == null);  //这里e的类型为Integer
   System.out.println(list.size());  //2
 }  
 private static void print(Predicate filter, int x) {   // 操作逻辑，操作数
    // 非空判断
    if(filter == null) throw new NullPointerException("no predicate defined.");
    if (filter.test(x)) {  //直接调用即可，关注参数和返回值，具体操作逻辑交给调用者
      System.out.println(true);  
    }else{
      System.out.println(false);  
    }
 }
}
```

注： 如何在jdk8以前的版本中实现函数式编程？这时无法用λ表达式来传递计算函数，还是使用具体
对象来实现，代码如下:
```txt
interface Inter{     // 函数式接口不可少，定义操作数和返回值
    int oper(int x, int y);
}
public class TestLambda {
    public static void main(String[] args) {
        // 传递具体的对象来调用自定义的操作
        f(new InterClass(), 4,5);    
    }
    private static void f(Inter inter, int x, int y) {  // 接收函数表达式的方法
        System.out.println(inter.oper(x,y));
    }

}
class InterClass implements Inter{   // 定义函数接口实现类以符合参数，返回值的约束
    @Override
    public int oper(int x, int y) {
        return x + y;
    }
}
```
可以看到，在不使用λ表达式时，需要多定义一个接口实现类和初始化一个实现类对象，此方法适用于
jdk8以前需要函数式编程的功能。

再注： 使用下方的匿名内部类更为简便，函数接口与接受函数接口的方法不变，只不过需要将λ表达式
替换为匿名内部类即可，不过需要在其中重写方法，代码没有λ表达式整洁，但它是jdk8前的最佳替代
方案了。


方法引用
如果λ表达式定义的处理逻辑已经有某个方法定义了，可以使用该方法来替代λ表达式，即方法引用。
方法引用即为简化的λ表达式。

它分3种情况：
1. object.instanceMethod   如System.out::println  out是静态对象，println是实例方法
2. Class.staticMethod      如Math::max
3. Class.instanceMethod    如String::compareToIgnoreCase,这种情况方法调用者是第一个参数

注：方法引用相当于λ表达式的简写，最终也是要转化为函数式接口的实例，所以如Math::max出现
方法重载时，具体调用哪一个取决于调用方法引用的函数接口使用了什么类型的参数。

另：由方法引用的作用来看，自定义方法引用适用于某个λ表达式经常被使用到，可以像提取常量一样，
将该λ表达式定义为一个具体的方法，然后在接收函数式接口处调用该方法即可。代码如下：
```txt
@FunctionalInterface
interface OI<T>{        // 使用泛型处理不同类型参数
  T oper(T x, T y);
}
public class Test{
 public static void main(String[] args) {
   printInteger(Math::max, 3, 5);     // 5
   printDouble(Math::max, 33.2l, 5.3);  // 33.21
   printInteger(Test::ss, 3, 10);      // 19
 }  
 // 这里函数式接口需要指明泛型类型，否则默认Object,编译报错找不到Math.max(Object,Object)
 private static void printInteger(OI<Integer> oi, int x, int y) {   // 操作逻辑，操作数
   System.out.println(oi.oper(x,y));  
 }
 private static void printDouble(OI<Double> oi, double x, double y) {   // 操作逻辑，操作数
   System.out.println(oi.oper(x,y));  
 }
 private static int ss(int x, int y) {
   return (x * x) + y;   //这是一个简单的运算，只有复杂的操作提取才有意义  
 }
}
```
在方法引用的第一种情况对象引用中，可以使用this和super关键字。


构造器引用
构造器引用即方法为new的方法引用，快捷调用某个类的构造器。如String::new,本质上说，它还是
方法引用，即λ表达式。
新建一个对象的λ表达式，这决定了构造器引用的用途不是非常广，只有需要批量初始化的时候(如
stream流中)可以简化写法。

数组也可以使用构造器引用，如int[]::new，这个表达式需要的唯一参数为数组的长度。利用这一点
可以让工具类绕过java的限制创建泛型数组，代码如下：
```txt
public class Test2 {
    public static void main(String[] args) {
        ArrayList<Integer> list = new ArrayList<>();
        list.add(2);
        list.add(3);
        list.add(4);

        // 常见方法，直接创建数组即可，这个例子里也是最快的
        // Integer[] integers = new Integer[list.size()];

        // 使用数组构造器引用。Function和BiFunction函数接口变量可以接收λ表达式，
        // 通过调用其apply方法将参数应用到表达式中得到计算结果，这里返回值即为需要的数组
        // Function<Integer, Integer[]> function = Integer[]::new;
        // Integer[] integers = function.apply(list.size());

        // 调用支持泛型方法，传递数组构造器引用，元素类型，数组大小即可。 
        // 这里是大费周张了，但价值在于调用的泛型方法中
        Integer[] integers = newTArray(Integer[]::new, Integer.class, list.size());

        list.toArray(integers);
        System.out.println(Arrays.toString(integers));
    }

 // 绕过了java不能创建T[]的限制，可以在其中进行需要的通用数组处理。这里创建后就直接返回了
    private static <T> T[] newTArray(Function<Integer, T[]> f, Class T, Integer size) {
        T[] genericArray = f.apply(size);
        //  do something with genericArray
        return genericArray;
    }
}
```

变量作用域
λ表达式就是闭包。
λ表达式实际由3部分组成：
1. 参数
2. 表达式代码块
3. 自由变量——即λ表达式外的变量，既不是参数也不是代码块中定义的变量。

λ表达式引用的自由变量必须是最终变量(final)或实际上的最终变量(effectively final)。
即事实上的final变量。
最佳实践： 应将使用到的自由变量都用final修饰。

因为自由变量如果可以被改变，当λ表达式并发执行时，会产生问题(具体问题卷2有)。

λ表达式的作用域与它所有的代码块是相同的，即λ表达式的参数和局部变量不能与所在代码块的变量
冲突，如
```txt
int x = 3;
Function<Integer, Integer> f = x -> x * x; 
//error: variable x is already defined in the scope
```
λ表达式中this是指λ表达式所在方法的所属类，与它的返回值没有关系。如
```txt
package com.test;

public class Test2() {
 public static void main(String[] args){
   new Test2().go(1000); 
   JOptionPane.showMessageDialog(null, "stop");
   System.exit(0);
 }
 private void go(int delay){
  ActionListener listener = e -> {
    System.out.println(this);  // will print com.test.Test2@XXXX  
  }  
  new Timer(delay, listener).start();  // java.swing.Timer
 }  
}
```

处理λ表达式
λ表达式重点在于延后执行(deferred execution),可以控制代码的运行时间，条件，线程等。

jdk提供了很多函数式接口的模板，可以根据λ表达式的参数和返回值个数和类型直接使用：
```txt
1. Runnable       void run()  适合无参数，无返回值的λ表达式，单纯的方法本身与线程无关
2. Supplier<T>    T get()              无参数, 返回T
3. Consumer<T>    void accept(T)       1个参数，无返回
4. BiConsumer<T,U>  void accept(T,U)  2个参数，无返回
5. Function<T,R>      R  apply(T)     1个参数，返回R
6. BiFunction<T,U,R>  R apply(T,U)    2个参数，返回R
下面是上面接口的特例
7. UnaryOperator<T>   T apply(T)   Function<T,T>的子类，参数和返回值是相同类型
8. BinaryOperator<T>  T apply(T,T) BiFunction<T,T,T>的子类，参数和返回值是相同类型
9. Predicate<T>      boolean test(T)   1个参数,返回boolean值
10. BiPredicate<T,U>  boolean test(T,U)  2个参数，返回boolean值
```
对于基本类型int,long,double,jdk为了省去自动装箱的开销提供了一些专门的函数式接口，如
IntConsumer等。
这些接口有一些默认方法，提供了如级联调用，返回相同方法等功能。
如consumer.andThen(Consumer after)返回的是一个lambda表达式
`(T t) -> {accept(t), after.accept(t);}`,
该表达式只有一个参数，调用了2个accept方法，无返回值，其本身也是一个Consumer类型，
需要执行该表达式时，也是调用其accept方法，代码如下：
```txt
public class Test{
 public static void main(String[] args) {
   Consumer<Integer> first = System.out::println;  
   Consumer<Integer> second = System.out::println;
   first.andThen(second).accept(666);   // output 666 twice   
 } 
}
```

再谈Comparator
Comparator是一个常用的比较器和函数式接口。抽象方法为`int compare(T o1, T o2);`,可以通过
多种方式得到自己需要的Comparator比较器，如Person类对象按域name长度排序：
```txt
public class TestPerson {
    public static void main(String[] args) {

        Person[] ps = new Person[]{new Person("wtt"), new Person("wttsan"), new Person("wt")};
        System.out.println(Arrays.toString(ps));

        // 直接自己想要的比较方式，idea会给出提示可以使用comparing
        // Comparator<Person> comparator =
        //         (Person p1, Person p2) -> p1.getName().length() - p2.getName().length();

        // comparing有多个变体，主要参数为keyextractor,即需要比较的键的function,这里后面
        // 一个参数为键本身的比较器，即字符串长度
        // Comparator<Person> comparator = Comparator.comparing(Person::getName,
        //         (x,y) -> x.length() - y.length());

        // 最终结果是比较int值大小，可以提取到外面，使用comparingInt,参数为ToIntFunction,
        // 需要传递返回值为int,只有一个参数的function.此方法最为简洁。
        Comparator<Person> comparator = Comparator.comparingInt(p -> p.getName().length());
        Arrays.sort(ps, comparator);
        System.out.println(Arrays.toString(ps));
    }
}
class Person{
    private String name;

    public Person(){}
    public Person(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    @Override
    public String toString() {
        return "Person{" +
                "name='" + name + '\'' +
                '}';
    }

    public void setName(String name) {
        this.name = name;
    }
}
```
同consumer.andThen(Consumer con)一样，Comparator有thenComparing方法实现级联调用，目的是
第一个比较器比较结果为相等时可以调用第二个比较器继续比较：
```txt
public class TestPerson {
    public static void main(String[] args) {
        Person[] ps = new Person[]{
          new Person("wtt", 5), new Person("wttsan",1), new Person("cll",3)};
        System.out.println(Arrays.toString(ps));

        // 第一个p的参数类型Person不可少，应是λ表达式无法推断出来，anyway,最好是
        // 指明参数类型
        Comparator<Person> comparator = Comparator.comparingInt(
         (Person p) -> p.getName().length()).thenComparingInt(p -> p.getId());

        Arrays.sort(ps, comparator);
        System.out.println(Arrays.toString(ps));
    }
}
class Person{
    private String name;
    private int id;

    public Person(){}

    public Person(String name, int id) {
        this.name = name;
        this.id = id;
    }

    @Override
    public String toString() {
        return "Person{" +
                "name='" + name + '\'' +
                ", id=" + id +
                '}';
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }
}
```
如果比较的键函数可以返回null,可以使用Comparator.nullsFirst()或nullsLast来对null值进行排序。

### 内部类
使用内部类的三个原因：
1. 可以访问类定义所在作用域中的数据，包括私有数据。
2. 内部类可以对同包的其他类隐藏
3. 使用匿名内部类可以快捷定义回调函数。
注： C++有嵌套类，它只是类之间的关系，对象之间没有关系。命名控制和访问控制同java相似，但
java内部类对象有一个指向外部类对象的隐式指针，可以访问其全部状态。静态内部类没有该指针。

```txt
public class TimerTest{
    public static void main(String[] args) {

        TimerClock timerClock = new TimerClock(1000, false);
        timerClock.start();

        // 当内部类为public时，可以在外界使用outerObject.new InnerClass(xxx)创建内部类对象
        // 使用OuterClass.InnerClass来引用内部类对象
        // 内部类为private时，无法在外界创建对象
        TimerClock.TimePrinter timePrinter = timerClock.new TimePrinter();

        JOptionPane.showMessageDialog(null, "Quit program?");
        System.exit(0);
    }
}
class TimerClock {
    private int interval;
    private boolean beep;

    public TimerClock(int interval, boolean beep) {
        this.interval = interval;
        this.beep = beep;
    }

    public void start() {
      // 创建内部类对象的规范写法，因为在作用域内，也可以直接new
        ActionListener listener = this.new TimePrinter();
        Timer t = new Timer(interval, listener);
        t.start();
    }
    // 只有内部类可以作为private类，其他类只能为default或public
    public class TimePrinter implements ActionListener {
        public void actionPerformed(ActionEvent event) {
            System.out.println("At the tone, the time is " + new Date());
            // 引用外部类域的规范写法，因为在作用域内，也可以直接写beep
            // 同时，这样写确定了调用的是TimerClock类中的域beep，避免了被同名属性覆盖
            if (TimerClock.this.beep) Toolkit.getDefaultToolkit().beep();
            System.out.println(interval);
        }
    }

}
```
对于上面的程序使用命令`javac .\TimerTest.java`进行编译后发现生成了3个class文件，
`TimerTest.class, TimerClock.class, TimerClock$TimerPrinter.class`文件。
最后一个即为定义的内部类，使用命令`javap -p '.\TimerClock$TimePrinter.class'`进行反编译：
```txt
public class com.test.TimerClock$TimePrinter implements java.awt.event.ActionListener {

  // 内部类自动添加了对外部类的引用域
  final com.test.TimerClock this$0;       
  // 内部类构造器中自动添加了对外部类的引用参数
  public com.test.TimerClock$TimePrinter(com.test.TimerClock);
  public void actionPerformed(java.awt.event.ActionEvent);
}
```
由此可知，内部类只是编译器层面的语法糖，虚拟机对此一无所知。
使用命令`javap -p '.\TimerClock.class'`查看外部类的反编译代码为:
```txt
class com.test.TimerClock {
  private int interval;
  private boolean beep;
  public com.test.TimerClock(int, boolean);
  public void start();
  // 自动生成域的访问方法供内部类调用
  static boolean access$000(com.test.TimerClock);
  static int access$100(com.test.TimerClock);
}
```
可以看到针对内部类访问的2个域生成了对应的2个access方法(如果只访问了一个域只会生成对应的一个
access方法),内部类实际上就是通过这个自动生成的方法来访问外部类的私有属性，结合内部类反编译
代码，即调用了如`TimerClock.access$000(this$0)`来得到beep值。

注：编译生成的access$XXX方法实际上可以被任何同包的类调用,不仅限于内部类。由于access方法是
编译器自动生成的，无法在编译前直接调用，所以需要编写虚拟机指令来完成，而且还需要获得对应的
TimeClock对象作为方法参数，操作还是有难度的。

注2: 外部类可以访问内部类的所有成员，包括内部类的私有属性(无需如access方法等附加条件)，
这点可以从类包含的关系去理解，也无法解释太多。不过对于下面的局部内部类外部类将无法访问。


局部内部类
局部类是在方法中定义的内部类，它不能用public，private修饰，使用default,它的作用域限定在
这个方法中，外部类的其他方法不能访问它，内部类本身仍然可以访问外部类属性。
局部类实现了更深层次的封装。
将上面程序的TimePrint类移到start方法中，此时不能再使用`this.new TimePrint()`了，外部类对象
不能直接访问局部类。同样编译后再使用javap反编译可得，生成的内部类名字变了，中间变为`$1`:
```txt
class com.test.TimerClock$1TimePrinter implements java.awt.event.ActionListener {
  final com.test.TimerClock this$0;       
  com.test.TimerClock$1TimePrinter(com.test.TimerClock);
  public void actionPerformed(java.awt.event.ActionEvent);
}
```
同λ表达式一样，局部类也可以访问作用域内的局部变量，但它必须是final类型的，代码变为如下：

```txt
public class TimerTest{
    public static void main(String[] args) {

        TimerClock.start(1000, false);

        JOptionPane.showMessageDialog(null, "Quit program?");
        System.exit(0);
    }
}
class TimerClock {

   public static void start(int interval, boolean beep) {

     class TimePrinter implements ActionListener {
        public void actionPerformed(ActionEvent event) {
            System.out.println("At the tone, the time is " + new Date());
            if (beep) Toolkit.getDefaultToolkit().beep();
            System.out.println(interval);
        }
     }
     ActionListener listener = new TimePrinter();
     Timer t = new Timer(interval, listener);
     t.start();
   }
}
```
使用命令`javap '.\TimerClock$1TimePrinter.class'`可得
```txt
class com.test.TimerClock$1TimePrinter implements java.awt.event.ActionListener {
  final boolean val$beep;
  final int val$interval;
  com.test.TimerClock$1TimePrinter();
  public void actionPerformed(java.awt.event.ActionEvent);
}
```
与以上引用外部类域的反编译结果可知，没有引用外部类域后，局部类没有了外部类域的引用this$0,
构造器参数也去掉了，同时由于actionPerformed方法需要在start方法结束调用后仍然需要得到beep和
interval的值以继续执行，所以在内部类中相应的生成了域val$beep和val$interval来保存局部变量的
拷贝值。出于并发的考虑，访问的局部变量需要为final变量，最好是显式的声明出来。

可以看到，使用局部类极大的简化了代码，同时使用局部变量替代外部类实例域提高了安全性，无需
生成不安全的access方法供内部类调用。

注：如果需要在内部类中改变局部变量的值，可以将该变量封装在一个数组中，这时变量对该数组的
引用是final的，但其中的元素值可以被改变，从而避开了final的限制。start方法如下：
```txt
   public static void start(int interval, boolean beep) {

     int[] count = {1};
     class TimePrinter implements ActionListener {
        public void actionPerformed(ActionEvent event) {
            // OK to change count[0] value, array reference not changed
            System.out.println(count[0]++);  
        }
     }
     // ...
  }
```

匿名内部类
匿名内部类即没有名字的内部类，因为这个类只需要创建一个对象，所以它不需要给类命名，只需要
以特定的语法指明父类或实现的接口即可。

因为匿名内部类没有名字，而构造器需要与类名相同，所以匿名内部类没有构造器，它将构造器参数
传递给父类构造器，因为接口没有构造器，所以匿名内部类实现接口时，也没有参数，直接为
`new InterfaceType(){...}`.

λ表达式可以用匿名内部类替换，如上文中λ表达式的例子可改写为
```txt
interface Inter{     // 函数式接口不可少，定义操作数和返回值
    int oper(int x, int y);
}
public class TestLambda {
  public static void main(String[] args) {
      f(new Inter(){
         @Override
         public int oper(int x, int y) {
           return x + y;  
         }
        }, 4,5);    
  }
  private static void f(Inter inter, int x, int y) {  // 接收函数表达式的方法
      System.out.println(inter.oper(x,y));
  }
}
```
下面是继承一个类的匿名内部类：
```txt
class Person{
  private int id;
  public Person(int id) {
    this.id = id;
  }
  public void say(){
   System.out.println("person");
  }
  public int getId(){return id;}
  @Override
  public String toString(){
    return "Person{id=" + id + "}";  
  }
}
public class Test{
  public static void main(String[] args) {
    final String x = "hello";
    Person p = new Person(88) {
      @Override
      public void say(){
        // 匿名内部类实际上是Person的子类，无法直接访问Person私有属性id,也getId访问
        System.out.println(x + getId());  // output hello88
        System.out.println(this); // output Person{id=88}
      }
      public void test(){}
    };
    p.say();
    // p.test();   // 编译报错无法解析，原因在于多态
  }  
}
```
由以上程序可以看出，匿名内部类与局部类的作用域相同，可以对所在作用域(即声明的所在方法)内
的final or effective final变量有访问权限。
关于p.test()多态报错的问题，网上找到一个经测试可以运行的办法：
```txt
new Person(88) {
  @Override
  public void say(){
    // 匿名内部类实际上是Person的子类，无法直接访问Person私有属性id,也getId访问
    System.out.println(x + getId());  // output hello88
    System.out.println(this); // output Person{id=88}
  }
  public void test(){}
}.test();  // 直接在类声明后调用可以调用成功，未进行向上转型
```
无论如何，匿名内部类主要还是用于重写方法。

还是使用javap命令反编译以上程序，匿名内部类会自动生成一个Outerclass$1.class：
```txt
final class com.test.InnerTest$1 extends com.test.Person{ // 证实了子类的关系
  com.test.InnerTest$1(int);   // 构造器参数与Person一致
  public void say();
  public void test();
}
```
注：有时需要传递一个匿名数组列表，可以是使用双括号初始化(double brace initialization):
```txt
public class SimpleTest{
 public static void main(String[] args){
   showList(new ArrayList<Integer>() {{
    add(6);
    add(5);
    add(111);
   }});      // 适用于只需要使用一次的list参数
 }
 private static void showList(List<Integer> list) {
   System.out.println(Arrays.toString(list.toArray())); 
 }
}
```

静态内部类
如果不需要在内部类中引用外部类对象属性，可以将其设置为静态内部类。

静态态可以有静态域和静态方法，非静态类不可以。
因为静态变量和方法属于类的范围，它们会在具体的对象初始化前被加载，而非静态内部类的初始化
依托于外部类对象，所以非静态内部类中不能定义静态变量和方法，因为加载它们时需要的内部类
还未生成。

对静态内部类进行反编译可以发现其类名与普通内部类组成相同：Outerclass$Innerclass,类中没有
对外部类的引用,无构造器参数，为普通类编译结果。

静态类初始化语法`Outer.Inner inner = new Outer.Inner(XXX);`
```txt
public class StaticTest{
  public static void main(String[] args) {
     Outer.Inner inner = new Outer.Inner(66); 
  }  
}
class Outer{
  public static class Inner{
    private int id;
    public Inner(int id){
      this.id = id;
    }
  }  
}
```

### 代理
代理是一种设计模式，主要作用为对被代理对象的方法调用进行监控或加工处理等，是AOP和其他开发
框架常用的技术。

代理分为静态代理和动态代理，静态代理为显式的定义一个被代理对象的包装类，
实现与被代理对象相同的接口，该方法不具有广泛性，每个代理类都写死为某个接口与对象。
代码如下:
```txt
public class StaticProxy {
  public static void main(String[] args) {
     Bird bird = new Bird();
     BirdProxy birdProxy = new BirdProxy(bird);
     birdProxy.fly();
  }
  interface Fly{
     void fly();
  }
  static class Bird implements Fly{
     @Override
     public void fly() {
        System.out.println("bird fly");
     }
  }
  static class BirdProxy implements Fly{
     private Fly target;
     public BirdProxy(Fly target) {
       this.target = target;
     }

     @Override
     public void fly() {
       System.out.println("do something before");
       target.fly();
       System.out.println("do something after");
     }
  }
}
```
动态代理使用jdk的Proxy类和InvocationHandler接口，自定义代理类实现InvocationHandler接口，
同样包装被代理对象，重写invoke方法调用被代理对象的具体方法。调用时使用Proxy.newProxyInstance
(classloader, class[] interfaces, invocationHandler)方法在运行时生成代理对象。
代码如下：
```txt
public class DynamicProxy {
  public static void main(String[] args) {
     Bird bird = new Bird();
     Object proxy = Proxy.newProxyInstance(bird.getClass().getClassLoader(),
                     bird.getClass().getInterfaces(),
                     new ProxyFactory(bird));
     Fly birdProxy = (Fly)proxy;  // proxy instance implements the interfaces assigned
     birdProxy.fly();
     System.out.println(birdProxy);  // toString方法同样调用invoke方法
  }
  interface Fly{
     void fly();
  }
  static class Bird implements Fly{
     @Override
     public void fly() {
       System.out.println("bird fly");
     }
  }
  static class ProxyFactory implements InvocationHandler {

     private Object target;
     public ProxyFactory(Object target) {
       this.target = target;
     }

     @Override
     public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
       System.out.println("do sth before");
       Object result = method.invoke(target, args);
       System.out.println("do sth after");
       // System.out.println(proxy);       // error and exception
       return result;
     }
  }
}
```

(参照java.reflect.Proxy类注释和javaCore书)
1. newProxyInstance方法会在运行时生成一个代理类，类名以`$Proxy`开头，它继承了
`java.reflect.Proxy`类，并以相同顺序实现方法参数中传递的的接口列表。

2. 如果接口组都是public访问权限，代理类就是public final的，并且该代理类不指定包名;
如果接口组中有一个非public，则代理类就是非public的，并且代理类处于和其他非公有包的相同包中，
其中所有的非public接口需要在同一个包中。

3. 对于相同类加载器和相同接口组生成的proxy不同实例是属于同一个proxy类的不同对象。

4. 每个代理对象都只有一个实例域——invocationHandler,代理对象本身可以向上转型为某个实现的接口
引用，而通过此种方法调用代理对象的接口方法时，代理对象会调用其invocationHandler的invoke
方法(由于该invocationHandler会在初始化时通过参数传入，即调用了自定义的invoke方法)，invoke
方法中可以自定义操作，如通过反射Method调用被代理对象的方法等，invoke方法的返回值即为该次
代理对象上方法调用的返回值。

5. 生成的代理类会自动重写Object的hashCode，equals,toString方法，这些方法也会被转向
invocationHandler的invoke方法进行处理，在实际使用中应当注意这一点，防止不必要的invoke
方法调用。其他的Object方法没有被重写。

6. 如果不同代理接口中出现了重复方法，不管代理对象引用是什么接口类型，代理对象调用的
都是第一个出现的拥有此方法的接口(直接声明或继承而来的)，因为生成的代理类对应方法实现中
无法确定调用哪一个接口--都是接口数组元素。

注：调用接口方法时转向调用invoke方法的实现原理是在生成的代理类代码中写明的，查看Proxy类
源码，其中有一个ProxyClassFactory静态内部类，其中的apply方法调用了
ProxyGenerator.generateProxyClass方法来生成Proxy类。我们可以自己调用该方法来查看生成的
Proxy类代码，通过类代码可以清楚的证明上述的1、4、5点。该类一旦被生成就是一个普通类。
```txt
public class GenerateProxyTest {
  public static void main(String[] args) {

    byte[] $Proxy6s = ProxyGenerator.generateProxyClass("$Proxy6", new Class[]{Inte.class});

    // jdk 1.7后的try-with-resource语法糖，可以对实现了autoCloseable接口的资源自动关闭
    // 编译后为原来的try-catch-finally语句(如果用户代码和关闭代码都有异常，关闭异常被抑制，
    // 可以通过getSuppressed方法获得该被抑制的异常)

    try(FileOutputStream fos = new FileOutputStream("D:\\$Proxy6.class")) {
            fos.write($Proxy6s);
            fos.flush();
    } catch (IOException e) {
            e.printStackTrace();
    }
  }
}
interface Inte{
      void say();
}
```
取出该文件，使用jd-gui反编译(直接打开无效，进去后使用open file功能),内容如下：
```txt
import com.example.demo.Inte;
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;
import java.lang.reflect.UndeclaredThrowableException;

public final class $Proxy6     // 继承Proxy,实现Inte接口
  extends Proxy
  implements Inte
{
  private static Method m1;
  private static Method m2;
  private static Method m3;
  private static Method m0;
  
  public $Proxy6(InvocationHandler paramInvocationHandler)
  {
      super(paramInvocationHandler);
  }
  
  public final boolean equals(Object paramObject)
  {
      try
      {
          return ((Boolean)this.h.invoke(this, m1, new Object[] { paramObject })).booleanValue();
      }
      catch (Error|RuntimeException localError)
      {
          throw localError;
      }
      catch (Throwable localThrowable)
      {
          throw new UndeclaredThrowableException(localThrowable);
      }
  }
  
  public final String toString()
  {
      try
      {
          return (String)this.h.invoke(this, m2, null);
      }
      catch (Error|RuntimeException localError)
      {
          throw localError;
      }
      catch (Throwable localThrowable)
      {
          throw new UndeclaredThrowableException(localThrowable);
      }
  }
  // 代理类中只是简单的调用了invoke方法 
  public final void say()
  {
      try
      {
          this.h.invoke(this, m3, null);
          return;
      }
      catch (Error|RuntimeException localError)
      {
          throw localError;
      }
      catch (Throwable localThrowable)
      {
          throw new UndeclaredThrowableException(localThrowable);
      }
  }
  
  public final int hashCode()
  {
      try
      {
          return ((Integer)this.h.invoke(this, m0, null)).intValue();
      }
      catch (Error|RuntimeException localError)
      {
          throw localError;
      }
      catch (Throwable localThrowable)
      {
          throw new UndeclaredThrowableException(localThrowable);
      }
  }
  
  static
  {
      try
      {
          m1 = Class.forName("java.lang.Object").getMethod("equals", new Class[] { Class.forName("java.lang.Object") });
          m2 = Class.forName("java.lang.Object").getMethod("toString", new Class[0]);
          m3 = Class.forName("com.example.demo.Inte").getMethod("say", new Class[0]);
          m0 = Class.forName("java.lang.Object").getMethod("hashCode", new Class[0]);
          return;
      }
      catch (NoSuchMethodException localNoSuchMethodException)
      {
          throw new NoSuchMethodError(localNoSuchMethodException.getMessage());
      }
      catch (ClassNotFoundException localClassNotFoundException)
      {
          throw new NoClassDefFoundError(localClassNotFoundException.getMessage());
      }
  }
}
```
因为生成的代理类继承了java.reflect.Proxy类(和枚举继承了Enum一样),而java是单继承机制，
所以jdk动态代理只能代理接口，无法代理一个类，想要代理一个类，可以使用cglib包，它是通过
生成子类的方式实现的，据说spring的面向切面就是代理类时使用cglib,代理接口时使用proxy(这
一点以后研究AOP时再细看)

注：可以使用Proxy.isProxyClass来判断一个class对象是否是代理类。

## 异常，断言和日志
来自Throwable类注解：
所有errors和exceptions都继承自Throwable类，只有Throwable或其子类的实例才可以被java虚拟机
处理，才能被throw，catch关键字抛出或捕获。

在Throwable子类中，RunTimeException和Error下属异常属于非检查异常，不属于它们的子类异常
则是检查异常，检查异常(checked exceptions)是用于编译期进行检查的异常。

异常的抛出是一个传递链，Throwable有以自身为参数的构造器，即一个Throwable中包含了另一个
Throwable作为引发该异常的异常原因。
这样设计有以下原因：

1. 可以让用户自定义异常包装底层实现的异常，通过抛出包装异常，而不直接抛出原生异常，
可以在更换方法的实现方式时，用户层面不用更改抛出的异常类型，从而避免了修改代码，保持了灵活性。
下面的ExceptionTest类代码以更强的方式实现了解耦合。

2. 如某些接口或父类的方法本身并没有抛出异常，如果实现类需要抛出一个检查异常时，如果直接抛出
编译器会报错，提示父类或接口方法未抛出该异常。这时我们可以将这个检查异常用一个自定义的
未检查异常包装起来(通过Throwable cause参数)，从而绕开编译器检查。代码如下：
```txt
public class ExceptionTest implements IF{

  public static void main(String[] args) {
     new ExceptionTest().add();
  }
  // 不用声明运行时异常
  @Override
  public void add(){
    System.out.println("test");
    // 使用自定义的运行时异常包装被检查异常
    throw new WttException("null", new ParseException("parse", 0));
  }
  // 定义为运行时异常
  private class WttException extends RuntimeException{
    // 将检查异常包装起来
    public WttException(String msg, Throwable clause){
      super(msg, clause);
    }
  }
}
interface IF{
  void add();
}
```
运行以上程序，结果为：
```txt
Exception in thread "main" com.demo.ExceptionTest$WttException: null   // 先抛出上层异常
  at XXX
  at XXX
caused by: java.text.ParseException: parse    // 再是clause Throwable底层异常
...
```
将cause Throwable链接到当前异常类，除了可以使用构造器，还可以使用initCause方法，代码如下:
```txt
public class ExceptionTest implements IF{

  public static void main(String[] args) {
     new ExceptionTest().add();
  }
  @Override
  public void add(){

    System.out.println("test");
    // 使用自定义的运行时异常包装被检查异常
    WttException wttException = new WttException("wttException");   
    wttException.initCause(new ParseException("wttParse", 0));
    throw wttException;  
// 注意initCause返回的是Throwable对象，如果返回它也会引起编译报错，
// 这里直接返回外层包装的异常对象即可
  }
  // 定义为运行时异常
  private class WttException extends RuntimeException{
    public WttException(){}
    public WttException(String msg){
      super(msg);
    }
  }
}
interface IF{
  void add();
}
```
Throwable一般有4个构造器：
1. default: no param
2. one param: String message
3. one param: Throwable cause
4. two params: String message, Throwable cause

注： C++中2个基本的异常类，一个是`logic_error`,它相当于java的RunTimeException;另一个是
`runtime_error`,它是由于不可预测原因引发的异常，相当于java的非RunTimeException.

注2： 绕过编译器抛出受查异常除了上述这样用一个运行时异常包装起来以外，还有其他方法可以直接
抛出受查异常并且通过编译，网上搜索到有以下2种方法：
1. 使用sun.misc.Unsafe类，由于它是私有构造器，所以需要使用反射。代码如下：
```txt
public class CheckedExceptionTest {
  public static void main(String[] args) {
    try {
       Class unsafeClass = Class.forName("sun.misc.Unsafe");
      // 反射使用私有无参构造器构造对象
       Constructor<Unsafe> defaultConstructor = unsafeClass.getDeclaredConstructor(null);
       defaultConstructor.setAccessible(true);
       Unsafe unsafe = defaultConstructor.newInstance(null);
       // 本地方法
       unsafe.throwException(new Exception("wwwttt"));

    } catch (ReflectiveOperationException e) {
       // 这里统一抛出上层异常
       e.printStackTrace();
    }
  }
}
```
这里可以看到，使用反射也需要抛出多个ReflectiveOperationException的子类异常，它本身也是一个
受查异常，如果需要抛出的是它，那么这样做就没有意义了。
2. 利用泛型擦除机制绕过编译器检查。代码如下：
```txt
public class CheckedExceptionTest {
  public static void main(String[] args) {
    throwExp(new Exception("tt"));
  }
  private static <T extends Throwable> void throwExp(Throwable th) throws T {
    throw (T) th;
  }
}
```
猜想：泛型擦除将`throws T`这一句去除了。如果直接`throws Throwable`编译器会报错。

经过测试，子类重写方法抛出的受查异常类型同方法返回值一样，子类方法只能抛出更具体的受查异常
或不抛受查异常，否则编译报错。使用throws关键字抛出运行时异常没有意义，因为所有方法都有可能
抛出运行时异常。

注: java throws与C++ throw说明符基本相同，不过C++ throw没有编译检查，如果抛出的异常未在
throw列表中，会调用unexpected函数中止程序执行。同理，java由于编译检查，它如果需要明确
抛出受查异常(不使用以上技术方案情况下),需要使用throws进行声明，而C++没有检查，没有限制。


抛出异常
java中需要抛出一个异常时，使用throw关键字抛出该异常类的一个对象即可。
注： Java中只能抛出Throwable子类的对象，C++可以抛出任何类型的值。

捕获异常
捕获还是抛出异常？
对于知道如何进行处理的异常可以进行捕获并处理，不知道如何处理的异常可以抛给调用者。
实际捕获的异常可能是catch中声明异常的子类，可以通过e.getClass().getName()来获取其实际类型。

捕获多个异常
可以使用多个catch语句对不同的异常进行处理。
jdk7以后可以在一个catch语句中对不同的异常进行相同的操作,
如`catch(AException | BException e)`,其中A和B异常是相互独立的，不能有继承关系;并且该异常
对象变量e默认为final变量，不能在处理中改变其值。

捕获到异常后又再次抛出它， 原因可能有：
1. 改变异常类型，可以创建自定义异常对象，将实际异常对象作为自定义异常的cause，通过这种包装
方式，调用者使用e.getCause()方法即可以拿到真正的异常原因，同时由于包装获得了异常对象的
系统一致性。
2. 记录日志，用于在抛出异常前记录日志。这种情况下受查异常的声明(throws)与捕获的异常
类型(catch)应尽量保持一致。

finally子句
finally语句是任何情况下都会执行的代码块，无论是否有异常发生。如果使用固定格式
`try{}catch(){}finally{}`进行处理，由于finally语句块中代码也可能发生异常，这时候还需要
在finally中进行异常捕获，显得很繁琐。可以使用嵌套来进行解耦：finally专职于资源处理，catch
专职于捕获异常，格式如下：
```txt
try{
  try{
    ... 
    ...  // normal code
  }finally{
    XX.close(); // do with resources 
  }
}catch(Exception e){
  ... // do with exception
}
```
通过嵌套使用try-finally和try-catch，finally块中可能抛出的异常也被catch语句捕获到了。
但还有另一个问题，由于finally语句块始终会被执行，所以当正常代码和finally同时抛出异常时，
finally异常会覆盖掉正常代码的异常，这个问题在jdk7的try-with-resource语法得到了解决,前面
有提到过它，它会自动抑制finally的异常。

注：finally语句块的return语句会覆盖正常代码的return语句，所以应避免在finally中使用return.
```txt
public int doubleX(int x) {
  try{
    return x * 2; 
  }finally{
    if (x == 2) return 0;  
  }
}
```
调用doubleX(2)，得到结果0,可以理解为finally语句在`return x * 2`后执行。

try-with-resource
jdk7针对实现了AutoCloseable接口的资源类提供了一个语法糖，语法格式为:
```txt
try(Resource res1 = ...;
    Resource res2 = ...){
  ...  // do sth with res1, res2
}
```
它会自动调用res1,res2的close方法，用javap查看反编译结果，可以看见它自动添加了finally语句，
并且抑制close方法中抛出的异常，可以使用getSuppressed()得到这个被抑制的异常。

堆栈轨迹
Throwable有一个getStackTrace()方法，返回的是一个StackTraceElement数组，这个数组的第一个元素
是最后执行或抛出异常的位置信息，后面的每个元素都代表了一个方法的调用。StackTraceElement
对象记录了所在类，方法名，文件名，当前代码所在行号的信息。StackTraceElement的toString方法
输出的即是我们经常见到的异常位置信息：方法名(文件名:行号).

注：Thread.getAllStackTraces()方法可以得到所有线程的堆栈轨迹map：它的key为线程对象，value为
StackTraceElement数组，在遍历map集合时调用map.get(thread)和使用thread.getStackTrace()方法
得到的结果相同，都是每个线程各自的方法调用轨迹数组。

注2: 如果想查看代码中某个位置的堆栈轨迹，可以使用`Thread.dumpStack()`方法，它会通过抛出一个
异常来打印轨迹，这适用于调试时查看某个方法从入口到被执行时经过的方法调用。

使用异常机制技巧
1. 异常处理不能代替简单测试。
   如判断某个对象是否为null，捕获空指针异常要比使用if语句进行判断速度慢很多(显然捕获一个异常
   后台需要做大量工作)。这说明了异常不应当被用于正常业务逻辑处理中，具体就是说不应当
   在catch语句中进行业务逻辑处理。
2. 不要过分的细化异常 
  即不要使用多个try-catch语句将正常业务逻辑处理分隔开，可以使用一个try语句块，多个catch语句
  块将正常处理和异常处理分隔开，使代码清晰化。
3. 利用异常层次结构
  可以自定义异常来代替简单的RuntimeException或Throwable。
  不要将业务逻辑异常定义为受查异常，这样做会提高耦合度，业务发生变化时无法灵活修改。
  可以在catch语句中将捕获到的异常转换为另一种更合适的异常类型后再抛出，这样方便管理。
4. 压制异常
  如果调用的方法有受查异常，而该异常对于方法调用者来说可以忽略，这时可以使用try-catch语句捕获
  后不做任何处理，直接忽视它。
5. 严格检测错误(早抛出)
  在方法处理完成后，有时要面对特殊情况下是抛出异常还是返回一个特殊值(如-1,null等)的选择，
  一般建议抛出异常要比返回特殊值好，因为特殊值在以后的逻辑处理中如果没有判断处理，可能
  会导致空指针等其他异常。但如果是工具类或其他类库工具，可以返回特殊值并给出注释告知调用者。
  可以大概总结为：合理的边界情况可以使用特殊值，如果是明显不合理或错误的情况，应当抛出异常。
6. 不要羞于抛出异常(晚捕获)
  有时抛出异常让方法调用者处理是更为明智的选择。

断言
格式为`assert x == 1;`或`assert x == 1: "x == 1"`,后一种语法格式可以在抛出AssertionError
时打印出自定义的表达式信息。

使用java命令运行程序时使用-ea开启断言，-da关闭断言，默认是关闭状态。
启用或关闭是类加载器的行为，即开启断言不需要重新编译，断言关闭时类加载器会自动跳过断言代码，
因此使用断言不会影响运行速度。
1. 断言失败是致命的，不可恢复
2. 断言只适用于开发和测试阶段。
注： -ea无法应用到没有类加载器的"系统类"(jdk中的类)中，对于它们可以使用-esa
(-enableSystemAssertions).

记录日志
java自带的日志记录器为java.util.logging.Logger类。

默认情况下，日志记录器把日志记录发送到consoleHandler处理器中，再由它输出到System.err流打印
出来。日志API提供了2个处理器，SocketHandler和FileHandler.
```txt
FileHandler fileHandler = new FileHandler();
logger.addHandler(fileHandler);
logger.info("test log");
```
运行以上代码，程序默认会在windows的用户目录下生成一个javaX.log文件，其中使用xml格式记录了
输出的日志信息。jdk logger提供了过滤器和格式化器进行日志过滤和格式化操作。
如上面程序中使用以下语句可以将xml格式转化为String:
```txt
  fileHandler.setFormatter(new SimpleFormatter());
```
这样文件内容就与console管理台输出的内容一致了，这样倒是省去了在idea中配置日志输出重定向。

调试技巧
1. 使用java命令运行程序时使用-verbose参数可以查看虚拟机加载类的过程，对于诊断类路径问题很
方便。
2. jdk/bin目录下有一些可以查看程序性能的工具

## 泛型程序设计
类型参数(type parameter)规定了元素类型，并省去了类型转换，使程序有更好的可读性和安全性。
jdk7以后在构造函数中可以省略泛型类型，因为它们可以从变量类型中推导出，如返回值可以直接返回
`return new ArrayList<>();`.

泛型类
类名后使用如`<T>`或`<T,U>`声明一个类型变量，经测试`<T,T>`报错:重复类型参数。

泛型方法
```txt
public class Test{
 public static void main(String[] args){
   // 在方法名前指定类型参数
   System.out.println(Test.<Object>middle(null, 0, "sd"));
   //编译报错， 0是int，要求为String
   System.out.println(Test.<String>middle(null, 0, "sd"));  
 }  
 private static <T> T middle(T... ts) {
   return ts[ts.length / 2];  
 }
}
```
大部分情况下，调用泛型方法时可以省略指定泛型类型，因为编译器可以从参数类型推导出泛型类型。
如使用以下语句`double x = cal(3.3, 23, 0);`，编译报错，错误信息提示'incompatible type:
Number & Comparable...',说明编译器根据参数推导得出T为Number类型或Comparable类型，可以改为
`Number x = cal(3.3, 23, 0);`或`Comparable x = cal(3.3, 23, 0);`.
同理`double x = cal(3.3, 2, "34");`可以看到推导出T类型为Serializable或Comparable.
由此可知，当不同类型的参数对应于一个类型参数时，最好将参数转化为统一类型，或使用明确类型
的变量接受返回值。

注：java泛型类似于C++中的template模板，但它们有本质区别。

类型变量的限定
如果想要对类型参数对应的类型增加某些参数，如指定实际类型必须实现Comparable接口，可以使用
extends关键字，如以上代码：
```txt
public static <T extends Comparable> T middle(T... ts){...}
```
当传入如`Pair<Integer>(2,3)`对象时，编译报错: 
`no instances of type variables exists so that Pair<Integer> conforms to Comparable`.

可以使用`&`来区分多个限定，使用逗号区分不同的类型参数，如
```txt
public static <T extends Number & Comparable & Serializable, U extends Cloneable> 
  T middle(U u,T... ts){...}
```
类型变量的限定与类的继承机制保持一致，类型参数的限定也只能继承自一个类，实现多个接口，
并且类必须是限定列表的第一个。


泛型代码和虚拟机
虚拟机没有泛型类型对象：即虚拟机中只有普通类。泛型仅仅是编译时的语法糖，同枚举，内部类，
try-with-resource等语法一样。

每个泛型类型都有自己的原始类型(raw type),程序执行时会擦除泛型，将变量类型替换为泛型
的第一个限定类型,无限定类型的转为Object.
如`T extends Comparable & Serializable`会转化为限定类型Comparable,而
`T extends Serializable & Comparable`会转化为Serializable,当代码里执行compareTo方法时，
程序会强制转型为Comparable，所以为了提高效率，应当将无方法的记号接口放在限定列表的最后。

泛型擦除后编译器会增加必要的强制类型转换，如代码
`List<Integer> list = ...; int a = list.get(0)`执行时，编译器会自动转化为
`int a = (Integer)list.get(0);`.


泛型擦除机制导致的问题及解决方法

泛型方法擦除泛型后，类型转化为限定类型(如Object)，如果其子类使用具体类型(如String)进行
方法重写时将会出现问题：如果是set方法将与多态调用产生冲突(产生2个不同类型参数的方法)，
如果是get方法则产生了方法签名相同而返回值不同的方法。

对于get方法，方法签名是由方法名和参数列表决定的，如果方法重载时方法签名相同，返回值不同，
编译器会报错(因为调用者可以忽略返回值).但是虚拟机是根据方法签名和返回值来确定方法调用的，
所以即使泛型擦除导致出现了相同签名的方法出现，虚拟机也可以解决。相当于用户自己编写这样的
代码经过编译检查会报错无法执行，而编译器自动产生的绕过了检查机制可以被虚拟机执行。

针对set方法编译器会修改继承的限定类型(如Object)方法，在其中调用重写的新方法，这也称为
桥方法(bridge method).实际上桥方法也应用在重写方法时子类方法返回协变类型上，它也是合成了
桥方法调用重写的方法。桥方法的作用就是保持多态。

将泛型类型参数赋值给无泛型参数变量时，会得到编译器警告信息，一般情况下可以使用
@SuppressWarnings("unchecked")注解来压制警告。


泛型的约束和影响
1. 泛型类型参数不能是基本数据类型
  因为泛型擦除后泛型类型需要转化为Object类型，基本类型无法转化为Object,所以需要对应的包装类。
2. 运行时类型检查不支持泛型参数
  即无法使用instanceof关键字判断泛型类型，`if(pair instanceof Pair<LocalDate>){...}`会
  得到编译报错：illegal generic type for instanceof. 关键字instanceof只能用来判断原始类型:
  `if(pair instanceof Pair){...}`。
  同样的，使用getClass()得到的结果始终是原始类型。
 ```txt
Pair<String> pair1 = new Pair<>();
Pair<Integer> pair2 = new Pair<>();
System.out.println(pair1.getClass() == pair2.getClass());  // 都是Pair.class
 ```
3. 无法创建泛型数组
  代码`List<String>[] listArray = new List<String>[10];`报错：generic array creation.
其中泛型数组可以声明，但无法进行初始化。原因在于泛型数组破坏了泛型的类型安全。
因为数组是可协变的，子类数组可以转化为父类数组，用户可以通过父类数组引用破坏泛型类型安全，
代码如下：
 ```txt
 // 使用强制类型转换得到泛型数组，后面也可以写为new List<?>[10]
 List<String>[] listArray = (List<String>[])new List[10];
 Object[] objects = listArray;  // 向上转型为Object[]
 objects[0] = Arrays.asList(1);   // 通过objects存入一个List<Integer>
 String s = listArray[0].get(0);  // 运行报错，类型转换异常
 ```
4. 可以在@SafeVarargs注解的注释上看到上面的这个例子。
5. 不能实例化类型变量，如T.class, new T[...],new T(...)都会产生编译错误。在jdk8以前，只能
使用Class.newInstance方法来构造需要的类型对象，而jdk8以后可以使用构造器引用。
如创建一个pair对象的泛型方法，代码如下：
```txt
public class GenericTest {

  public static void main(String[] args) {

    Pair<String> stringPair = makePair(String.class, "s", "w");
    System.out.println(stringPair.getF());
    System.out.println(stringPair.getS());

    Pair<String> stringPair2 = makePair2(String::new, "d", "f");
    System.out.println(stringPair2.getF());
    System.out.println(stringPair2.getS());
  }
  private static <T> Pair<T> makePair(Class<T> tClass, T f, T s) {
    try {
      return new Pair<>(tClass.getDeclaredConstructor(tClass).newInstance(f),
                        tClass.getDeclaredConstructor(tClass).newInstance(s));
    } catch (ReflectiveOperationException e) {
      return null;
    }
  }
  private static <T> Pair<T> makePair2(Function<T,T> function, T f, T s) {
      return new Pair<>(function.apply(f), function.apply(s));
  }
}
```
注： String.class实际为`Class<String>`的唯一实例，所以makePair方法可以得到T类型(值得注意
的是T类型无法从参数f,s获得，代码`Class<T> tClass = f.getClass()`报错：
`Found Class<T>, Required Class<capture<? extends java.lang.Object>>`,可以看到由于泛型擦除，
f变为Object类型，无法强转为具体的T类型)。
构造器引用使用的构造器为new String(String),对应的函数接口为`Function<T,T>`,

6. 不能实例化泛型数组。像上面说的那样，不能直接初始化泛型数组，实际使用时有
`E[] = (E[])new Object[10];`这是因为初始元素null可以转化为任意的Object子类型，
但针对已经存在数组元素的数组就无法使用这种方式强转了，如数组拷贝等需求。在前面的数组反射和
数组构造器引用已经分别写过解决方案，下面统一一下代码：
```txt
public class ArrayGenericTest {
  public static void main(String[] args) {
    // 可变参数可以直接传递数组
    Integer[] integers = makeGenericArray(new Integer[]{23, 23, 45});
    System.out.println(Arrays.toString(integers));

    // 构造器引用
    String[] strings = makeGenericArray2(String[]::new, "d", "s", "f");
    System.out.println(Arrays.toString(strings));
  }
  private static <T> T[] makeGenericArray(T... ts) {
    T[] newT = (T[])Array.newInstance(ts.getClass().getComponentType(), ts.length);
    // do something else with T[]
    // 对于引用类型数组必须需要使用clone方法才能得到新的对象引用, 不能单纯使用下面的方法
    System.arraycopy(ts, 0, newT, 0, ts.length);
    return newT;
  }
  private static <T> T[] makeGenericArray2(Function<Integer, T[]> function, T... ts) {
    T[] newT = function.apply(ts.length);
    // do something else with T[]
    System.arraycopy(ts, 0, newT, 0, ts.length);
    return newT;
  }
}
```

7. 不能在静态域或静态方法中使用泛型变量。如下代码：
```txt
class Pair<T> {
  private static T tt;    // 编译报错，pair.this cannot be referenced from a static context
  private static T getTt(){
    return tt;
  }
}
```
可以从报错信息知，类型变量默认是与实例进行绑定的，可以理解为类在实例化前尚未确定T类型，所以
无法确定静态域tt的类型，静态方法也是一样道理。
注： 同样的，如下代码同基本的static域无任何不同:
```txt
class Person<T>{
 public static int id;
}
Person<Integer> p1 = new Person<>();
p1.id = 3;
Person<String> p2 = new Person<>();
p2.id = 4;
System.out.println(p1.id);
```
这个例子其实和泛型变量没有太大关系，id只是一个普通的静态域罢了。

8. 无法捕获泛型异常，也不能使用泛型类继承Throwable类(正因为无法继承，所以也不存在带有泛型
变量的异常类型，也就无法抛出带有泛型类型的异常对象)，但可以声明Throwable类限定的泛型
类型并抛出它。因为泛型是编译时生效，而异常是运行时处理，所以异常无法支持泛型。如：
```txt

class Person<T> extends Throwable{}  // error: generic class may not extend Throwable

class Person<T extends Throwable> {
  public void say() {
    try{
      System.out.println("go");  
    }catch(T e) {  // error: cannot catch type parameters
    }
  }
}
// 因MyException<T>无法继承Throwable,所以throw new MyException<String>()也不可能存在
// 泛型参数不能被抛出，但可以将整个异常类作为泛型参数抛出，如前面利用泛型绕过受查异常
// 编译检查的例子:
public static <T extends Throwable> void f(Throwable th) throws T {
  throw (T)th;  
} 
```
9.消除受查异常检查。
代码即如上所示，调用时如"f(new ParseException("sd", 0));"编译通过，运行时抛出受查异常
ParseException.但这种简略写法其实默认等同于
`OuterTest.<RuntimeException>f(new ParseException("sd", 0));`,即指定T类型为RuntimeException
(或者Error类型);如果改为`OuterTest.<Exception>f(new ParseException("sd", 0));`，
编译器同样报错unhandled exception.

10. 泛型冲突
如类Child继承Parent类，而Parent实现了`Comparable<Parent>`接口，此时Child类再次实现接口
`Comparable<Child>`编译报错，因为Child会同时实现`Comparable<Parent>和Comparable<Child>`,
由于前面说过的泛型擦除和重写泛型方法问题，编译器会自动合成对应的桥方法，在桥方法中调用重写
的方法，此时子类同时拥有不同的参数类型，桥方法即无法确定调用哪一个，所以这种情况是不被允许的。

11. 泛型与继承
泛型参数本身的继承关系对其实际类型无关，即`ArrayList<Number>和ArrayList<Integer>`类型没有
任何关系:这一点其实也是由泛型擦除决定的。
```txt
ArrayList<Integer> integers = new ArrayList<>();
ArrayList<Number> numbers = integers;   // Error: incompatible types
numbers.set(0, 3.444);                 // cannot be allowed to happen
```
(如果这2者可以转换，理由类似于无法创建泛型数组一样:
经过向上转型传递引用，破坏了类型安全。数组本身的可协变性则是由其自身的保护机制决定的，如果
元素类型没有严格相符，它会抛出ArrayStoreException.)

另一方面，当泛型参数相同的情况下，类或接口本身的继承关系仍然有效，如`ArrayList<Integer>是
List<Integer>的子类`(如果泛型参数Integer不同，转换类型时会产生编译错误，不符合泛型要求)。

如果`ArrayList<Integer>`转换为原生类型ArrayList,则相当于里面的元素都转换为Object类型，原有
泛型类型限制就全部失效了。

12. 通配符
由于上面说的`ArrayList<Number>和ArrayList<Integer>`毫无关系，但有时候一个方法的参数类型需要
能同时处理这2种类型，这时候可以使用通配符`?`，它又分子类型限定通配符和超类限定通配符2种，
总体来说，**子类限定可以读，超类限定可以写**(或者理解为指定了父类可以读，指定了子类可以写)

   1. 需要访问值时，使用子类通配符(? extends XX)对子类型统一访问，但不能更改子类型的值。
   对于子类限定的set方法来说,? extends Number指Number类的**某一个**子类类型，可以认为它
   不能接收任何具体的类型(包括Number本身和其下的任何子类型)，以这种类型的区别来禁止使用。
   而对于get方法它就可以成功转化，统一转型为Number类型。
```txt
ArrayList<Integer> integers = new ArrayList<>();
integers.add(2);
// 引用传递可以为Number本身或其子类型
ArrayList<? extends Number> numbers = integers;     // OK  

// 对子类型限定通配符的泛型对象无法设置值
// compilation Error: wrong type,Found Integer, required ? extends Number 
numbers.set(0, (Integer)3);     

// compilation Error: wrong type,Found Number, required ? extends Number 
numbers.set(0, (Number)3);     

// OK, 整型元素可以向上转型为Number类型被统一访问到 
Number first = numbers.get(0); 
```

   2. 需要更改参数值时，使用超类通配符(? super XXX)传入各个父类型泛型的对象，当使用符合
   泛型要求的子类型XXX的值传入set方法时，可以向上转型从而成功赋值。而get方法因无法确定
   父类型，所以只能转换为Object类型。代码如下：
```txt
ArrayList<Number> nums = new ArrayList<>();
nums.add(2);
// 引用传递可以为Double本身或其父类型
ArrayList<? super Double> doubleSupers = nums;     // OK  

// OK，double可以像上转型为Number类型，没有违反nums的泛型安全
doubleSupers.set(0, 6.32);

//compilation error: wrong type:found Integer, required ? super Double
doubleSupers.set(0, 33); 

// OK，get方法得到Object类型，需要强制转型。
// 实际使用时在库方法中无法得知参数的具体类型为Number
Number one = (Number)doubleSupers.get(0); 
```

注： 如以上提到的泛型冲突问题：时间类LocalDate实现了接口ChronoLocalDate,而ChronoLocalDate
接口继承了Compare(ChronoLocalDate)接口，所以LocalDate就无法实现Compare(LocalDate)接口。
这对于方法`public <T extends Comparable<T>> T getMax(T... ts){...}`来说就无法使用LocalDate
作为参数类型，我们可以使用超类限定通配符将其中的泛型声明部分改为
`<T extends Comparable<? super T>>`，使得compare方法参数类型可以是被比较元素T的父类，从而
解决这个问题。

   3. 无限定通配符
如`ArrayList<?>`,它和原生类型的区别即在于无限定通配符无法使用set方法修改对象，原生对象可以。
```txt
ArrayList<?> list = new ArrayList<>();
list.add(23);  // 编译报错：add(capture<?>)in ArrayList cannot be applied to (int)
ArrayList list2 = new ArrayList<>();
list2.add(23);  // OK
```
使用无限定通配符有时可以对一些简单操作方法省去泛型类型T.如
```txt
public <T> boolean isNull(Pair<T> p){...}
```
可写为
```txt
public void boolean isNull(Pair<?> p){...}
```

   4. 通配符捕获
以上例子中方法`public void boolean isNull(Pair<?> p){...}`并不是一个泛型方法，它有着一个
固定类型为`Pair<?>`的参数,有时在方法内需要捕获该类型进行对象处理，如`? f = p.getF()`,但
?并不是一个实际类型，这样写会报错，这时可以另写一个泛型方法捕获这个通配符类型。
```txt
public class Test{
  public static void main(String[] args) {
    ArrayList<Number> list = new ArrayList<>();
    list.add(3.67);
    f(list);
  }  
  // 这个例子仅为演示通配符捕获的作用，实际上可以直接使用ArrayList<T>
  private static void f(ArrayList<? extends Number> list){
    getType(list);
  }
  // 使用通配符捕获在库方法中得到具体的类型
  private static <T> void getType(ArrayList<T> list){
    T t = list.get(0); 
    System.out.println(t.getClass());
  }
}
```
值得注意的是，只有通配符匹配的类型可以唯一确定的情况下才能捕获，否则无法捕获。
```txt
// 使用上面的Pair<T>类
public class Test{
 public static void main(String[] args) {
   ArrayList<Pair<?>> list = new ArrayList<>();
   list.add(new Pair<String>("sd", "f"));  // OK
// list.add(new Pair<Integer>(32, 34));   // OK
   //编译报错: reason: incompatible equality constraint: T and ?
   cap(list);
 }  
 private static <T> void cap(ArrayList<Pair<T>> list) {
   ...
 }
}
```
注: 通配符泛型对象如Pair<?>, Pair<? extends XXX>是无法修改值的(? super XXX除外),
所以它们一般都是作为引用的接收对象，在引用传递过程中通配符类型可以被唯一确定。
而在上面的例子`ArrayList<Pair<?>>`中,`Pair<?>`整体作为泛型参数实际上等同于Pair原生类型，
无法确定`Pair<T>`中T的具体类型。

13. 反射和泛型
   1. 泛型Class类
   反射关键类Class本身是一个泛型类`Class<T>`,String.class其实是`Class<String>`的唯一实例。
   2. 使用`Class<T> c`作为方法参数接受XXX.class类型，在方法中可以使用T作方便的处理。
   3. 虽然泛型参数在虚拟机中被擦除，但可以通过java.lang.reflect.Type接口下的几个子接口
   获得泛型参数的相关信息。
```txt
Type:  只有一个接口默认方法getTypeName

对于Type类型的变量type可以使用type instanceof XXX(XXX为以下类型)来判断具体类型
Class:   普通类型，如类，接口，数组等

   TypeVariable[] getTypeParameters()  该类型如果带有泛型，则返回其泛型类型变量列表;否则
   返回长度为0的数组。(经测试类，接口都可以成功取得泛型变量，由于无法创建泛型数组，所以
   数组类型如Comparable[].class调用该方法都是返回0长度数组)

   Type[] getGenericInterfaces()  返回当前类型(类或者接口)实现的泛型接口列表。

   Type getGenericSuperclass()  返回当前类型的父类泛型信息(父类无泛型返回父类类型即可)，
   该方法限定为类类型使用，其他如Object本身或接口类型会返回null,数组类型统一返回
   java.lang.Object。

   Method类中关于泛型的方法:
     TypeVariable[] getTypeParameters()  返回方法声明的泛型变量列表，同Class类中方法
     Type getGenericReturnType()       获得泛型返回值 
     Type[] getGenericParameterTypes()  获得方法泛型参数

TypeVariable: 描述了泛型变量，如T extends Number
    String getName()  获取类型变量名称，如T,E,K等
    Type[] getBounds()  获取类型变量的子类限定列表，超类，接口等，
       如T extends Object & Comparable,若无限定，返回长度为0的数组。
       不存在T super XXX语法，因为T为确定类型，super无法确定类型，只有通配符才有super.

WildcardType: 描述通配符类型，如? super T
   Type[] getUpperBounds()  获取通配符子类限定(extends)列表，无则返回长度为0数组
   Type[] getLowerBounds()  获取通配符超类限定(super)列表，无则返回长度为0数组

ParameterizedType: 描述泛型类或泛型接口，如Comparable<T>
   Type getRawType()  获取泛型类原始类型 
   Type[] getActualTypeArguments()  获取实际的类型参数 如Map<K,V>中的K,V列表
   Type getOwnerType()  获取所在类，如内部类O<T>.I<S>类型调用该方法返回外部类O<T>，
      否则返回null

GenericArrayType: 描述泛型数组，如T[]或Comparable<T>[]
   Type getGenericComponentType(); 获取数组元素泛型类型,泛型数组不可创建，但可以作为引用
     接收，如Comparable<String>[] carr = (Comparable<String>[])new Comparable<?>[10];
      但这种做法存在类型转换隐患。
```
书中的代码示例GenericReflectionTest非常经典，总结如下：
1. 一个泛型类继承另一个泛型类时，当前类的泛型是定义(相当于程序中的isDefinition = true),
如`class C<K,S> extends P<K,S>`,父类的泛型参数只能为`<K,S>或<S,K>`，即只能在当前类的泛型
中定义泛型变量，后面父类的泛型只能使用定义好的泛型变量; 类似的，泛型方法返回值前也是泛型
变量的定义区。
2. 只有在定义泛型变量(除去通配符的情况)时，允许出现限定符extends,在使用变量时不能进行限定。
这一点可以从isDefinition变量只有在printType方法的TypeVariable类别中进行判断添加Bound限定
看出。
3. 通配符符号?在WildcardType接口中没有方法获得，所以需要手动打印。

## 集合
### java集合框架
1. 接口和实现分离
  如List接口和它的具体实现ArrayList,LinkedList.使用List接口作为引用操作集合时，如果需要
  更换实现，只需要改变初始化集合对象一处即可以，这样就实现了解耦。
2. Collection接口
   boolean add(E e) 和Iterator<E> iterator()
3. 迭代器
   for each循环是语法糖，会转化为带迭代器的循环。Collection接口定义为
   `public interface Collection<E> extends Iterable<E>{...}`,
   Iterable接口只有一个抽象方法`Iterator<T> iterator();`,因此，对于任何一个Collection集合
   都可以使用for each循环。
   Iterator接口在jdk8后新增了一个默认方法forEachRemaining,可以使用它配合λ表达式不使用for
   循环即可遍历处理元素。
  ```txt
  List<Integer> list = new ArrayList<>(3);
  list.add(3);
  list.add(4);
  list.add(2);
  list.iterator().forEachRemaining(System.out::println);
  ```
java迭代器并不存储元素的位置信息，查找元素和指针位置变动是结合在next()方法中一起执行的，
它无法像数组索引一样在迭代器中查找位于中间或后面随机位置的元素(即随机访问)，只能依次读取。
可以认为java迭代器指针指向的是2个元素之间的位置，调用next方法时"越过"下一个元素并返回它。

注: C++的迭代器是根据数组索引创建的，指针指向每个元素，同数组索引一样，不需要查找元素就可以
移动指针。

Iterator的remove()方法必须在next()方法后调用，每个next()方法后只能调用一次remove()方法删除
刚刚"越过"的这个元素，否则将抛出异常IllegalStateException.
因此，需要连续删除2个元素时只能这样做：
```txt
iterator.next();
iterator.remove();
iterator.next();
iterator.remove();
```
注：ArrayList遍历同时删除元素的问题是一个老问题了：
这个问题其实主要是在于ArrayList的2处源码：ArrayList.Itr的remove方法和ArrayList.remove方法。

   1. ConcurrentModificationException: 经测试，使用foreach循环遍历ArrayList集合时
调用list.remove()方法时可能会报这个异常，但并不是一定会报: ArrayList继承了List接口，
iterator()方法返回的是其内部定义的一个迭代器Itr,Itr的next方法中第一步即为
CheckForComodification()检查计数值modCount和expectedModCount值是否相等，不等时即抛出该异常。
经测试发现，当使用foreach循环list.remove删除倒数第二个元素时，程序不会抛出该异常，可以
理解为foreach语法糖转化后的迭代器执行完list.remove方法后没有下一个元素了，
即iterator.hasNext() == false,从而跳出了循环，没有进入到循环中继续执行将抛出异常的next方法。

使用迭代器对ArrayList遍历时调用iterator.remove()方法可以正确删除，这是因为
iterator.remove()方法中有对modCount的重新赋值操作，能够保证检查的2个值相等。

   2. ArrayList的迭代器有检查机制会抛出异常。如果不用迭代器而使用普通索引for循环会怎么样？
由于ArrayList本身是数组实现的，查看remove(obj)方法源码可知，该方法是通过将删除元素
后的元素使用System.arrayCopy方法统一前进一位，删除最后一个元素来实现的。

这样的话如果对列表"2,3,3,4"删除其中的元素3,会发现结果为"2,3,4",即删除了第一个3后，后面一个
3元素由于移位避开了遍历从而跳过了删除判断。对于这个问题，可以使用倒序遍历的方式来解决：
由于是倒序遍历，删除某个元素后，后面的元素统一前移一位，这时使用list.get(i)时i由于是减法
所有刚好能取到后面前移的那个元素，从而实现正确遍历。

总结以上2点，使用迭代器的hasNext()，next(),remove()方法对集合进行遍历同时修改的操作才是
最佳实践，另外也可以使用普通for循环倒序遍历集合调用list.remove()方法。

4. 泛型实用方法
Collection接口声明了很多有用的方法，如int size(), boolean isEmpty(),boolean contains(obj),
boolean remove(obj),Object[] toArray()等，对于部分方法由AbstractCollection抽象类提供了具体
实现，自定义的接口实现类继承它只需要实现部分抽象方法即可。

对于jdk8以后的类，在Collection接口中添加了很多默认方法，更加方便，如
boolean removeIf(Predicate<? super E> filter)按条件删除(使用超类限定符可以使用Object类的方法)。
还有其他一些与流相关的操作方法。

5. 集合框架中的接口
集合有2个基本接口，Collection和Map,Collection下主要有List,Set,Queue子接口。

List是有序列表，支持随机访问，方法如E get(index),void add(index, element), 
boolean remove(index)等支持按索引进行操作。但实际上List可以由数组或链表来实现，链表虽然也
实现了相应随机访问方法，但是效率非常低。为了解决这个问题，jdk1.4引入了一个记号接口
RandomAccess,它本身同Cloneable一样，没有任何方法，仅是一个接口。可以通过
`XXX instanceof RandomAccess`判断XXX类是否支持高效随机访问，如ArrayList就实现了RandomAccess
接口，LinkedList没有实现它。这时可以使用迭代器来顺序遍历链表。

迭代器Iterator针对List上的遍历有一个ListIterator子接口，它新增了hasPrevious(), previous(),
add(),set()等额外的方法以更方便的在list上使用迭代器。

### 具体的集合
具体实际使用的集合有以下这些：
```txt
1. ArrayList           可以动态改变大小的索引序列(动态数组)
2. LinkedList          可以在任意位置高效插入和删除元素的有序序列(双向链表)
3. ArrayDeque          用循环数组实现的双端队列 
4. HashSet             无序集(无重复元素)
5. TreeSet             有序集(无重复元素)
6. EnumSet             枚举集(无重复元素)
7. LinkedHashSet       可以记住元素插入次序的集 
8. PriorityQueue       允许高效删除最小元素的集合(优先队列)
9. HashMap             键值对
10. TreeMap            键值有序排列的映射表
11. EnumMap            键是枚举类型的映射表
12. LinkedHashMap      可以记住键值对添加顺序的映射表
13. WeakHashMap        值无用后可以被GC回收的映射表
14. IdentityHashMap    用==而不是equals比较键值的映射表
```
AbstractCollection: 
   为方便实现Collection接口，jdk提供了AbstractCollection抽象类。其中对很多方法都提供了默认实现,
如contains(object)，toArray(),remove(object),addAll(collection)等。

类注释中说明，如果需要实现的是一个不可变的类，则只需要实现iterator()和size()方法，
其中iterator()返回的迭代器需要实现hasNext和next方法(add方法默认实现是抛出UnsupportedException).

如果需要实现一个可变集合，就需要额外实现add方法，并且迭代器还需要实现remove()方法。
*可以看到ArrayDeque是直接继承了AbstractCollection类*。

AbstractCollection主要有以下子类，AbstractList,AbstractSet,AbstractQueue,ArrayDeque,
ConcurrentLinkedDeque.

   1. AbstractList:
AbstractList继承自AbstractCollection类，实现了List接口。前面已提到，List接口对于Collection
接口扩展了一些随机访问方法，AbstractList类同样继承了这些方法，并针对其中部分方法如
indexOf(object),lastIndexOf(object)方法提供了实现。

对于上面说的AbstractCollection实现要求，可以看到AbstractList简单实现了add方法，相当于增加了
一个索引作为参数，具体处理还是抽象的。迭代器实现有内部类Itr,同时还有一个ListIterator接口
实现的内部类ListItr，它们实现了hasNext(), next(), remove()方法。size方法没有给出默认实现。
同时，还给出了获取子列表subList(from,to)方法。

同AbstractCollection一样，AbstractList类注释中也给出了实现类的要求：
如果是实现一个不可变list集合，实现类只需要提供get(index)和size()方法的实现。
如果是实现一个可修改的list集合，实现类需要额外实现set(index, object),set(index, E)方法。如果
该集合大小可变，实现类需要额外实现add(index, object),add(index, E)和remove(index)方法。

AbstractList的主要子类有ArrayList, Vector,  主要子接口有AbstractSequentialList.

      1. ArrayList
```txt
ArrayList<E> extends AbstractList<E> implements List<E>, RandomAcess, Cloneable, 
   java.io.Serializable
```
      可变大小数组实现的list集合。在add方法中添加元素前会检查数组容量，如果数组容量不够，具体
为grow方法中的`int newCapacity = oldCapacity + (oldCapacity >> 1);`,即每次扩容都扩大
现有容量的一半，直到符合要求为止。所以在初始化ArrayList时指定大小可以提高程序性能，
减少自动扩容的次数，由于默认容量是10, 所以初始化大小如果指定容量小于10没有意义，程序中有
取值比较`minCapacity = Math.max(DEFAULT_CAPACITY, minCapacity)`，扩容从10开始。
   同样的，如果显式的调用ensureCapacity(int)方法，它也是调用grow方法，一半一半的扩容直到
符合容量要求，效率较低，所以如果初始化时可以确定大概大小最好指明容量，然后调用完毕后使用
trimToSize()方法将容量变为与数组大小一致，去除list中多余的null元素。

ArrayList的类注释概述了上面的扩容机制，并提到ArrayList本身并不是线程安全的，可以使用
`Collections.synchronizedList(new ArrayList());`来获得线程安全的list集合。同时，也提到
ArrayList中的迭代器在创建迭代器后对list做结构修改会引发快速失败(即抛出并发修改异常)的机制
并不是非常确定的(如上面说的删除倒数第二个元素的例子)，不能依靠这个来写程序，只应作为检测bug的
手段。实际上前面异常章节中有提到不应当依靠任何异常进行逻辑处理，不在catch语句中做业务逻辑。


      2. Vector
```txt
Vector<E> extends AbstractList<E> implements List<E>, RandomAcess, Cloneable, 
   java.io.Serializable
```
Vector是线程安全的，而ArrayList是线程不安全的。Vector的elements()返回的是一个类似于迭代器
的Enumeration接口，属于遗留代码。

      3. AbstractSequentialList
AbstractSequentialList是继承自AbstractList的抽象类。正如名字所示，是为了方便顺序访问list
集合而创建的抽象类，如LinkedList,对于支持如数组一样随机访问的实现类，应直接继承AbstractList.

对于继承自AbstractList而来的随机访问方法如get(index),set(index), add(index), remove(index)
方法，AbstractSequentialList全部使用迭代器进行了重写，其中具体的迭代器实现是抽象的。
同AbstractCollection和AbstractList一样，实现者需要根据不可变或可变list集合实现不同的方法。

AbstractSequentialList主要子类为LinkedList.

      1. LinkedList:
   Queue: Queue比Collection提供了额外的插入，提取和检查方法。
   
    队列一般是FIFO，先进先出，但不是必须的，也有例外，如优先队列是根据提供的比较器排列元素，
或自然排序;栈是先进后出的顺序。无论是用什么顺序存储元素，队列的头都是那个可以调用remove()
或者poll()方法删除的元素。先进先出的队列是从队列尾部插入新元素的。 
   
   队列操作根据操作错误主要分2类：

  | 异常情况处理 | 新增 | 删除 | 查看 |
  | 抛出异常  | add(e) | remove()| element()|
  | 返回特殊值| offer(e)| poll()| peek()|


offer(e)方法通过返回特殊值来告知调用者新增失败适用于失败是普通的行为，如向一个固定容量的
队列中新增元素的情况。add(e)方法只能通过抛出非受查异常来告知失败，只适用于失败是异常情况时。

remove()和poll()方法都会删除并返回队列的头元素，具体的元素由队列的排序规则而定。当在一个
空队列上执行这2个操作时，remove()方法抛出异常，poll()方法返回null值。

element()和peek()方法会返回当前的队列头元素。

对于并发编程中常见的阻塞队列的方法是定义在Queue的子接口BlockingQueue中，Queue本身没有定义
相关操作。
队列的实现一般不允许插入null元素，但也有例外，如LinkedList就没有禁止这样做。但是并不建议
这样做，因为poll()方法是通过返回null值来表示当前是空队列的异常情况，插入null元素会与该
方法产生冲突。
队列实现的equals和hashCode方法并没有基于元素来定义，它只是继承了Object的相关方法，因为根据
元素来定义的话，相同的元素组由于不同的排序规则会对这2个方法的实现产生影响。
    
实现Queue接口的主要类有AbstractQueue,ConcurrentLinkedQueue, 子接口有BlockingQueue，Deque.

    Deque: double ended queue 双端队列。队列两端都能进行新增删除元素的队列
大部分Deque实现都没有容量限制，但Deque接口本身也支持固定大小的实现。
   |            | Head  || Tail ||      
   |异常情况处理| 抛异常|返回错误值|抛异常|返回错误值|
   |    新增    |  addFirst(e)|offerFirst(e)| addLast(e)|offLast(e)|
   |    删除    |  removeFirst()|pollFirst()| removeLast()|pollLast()|
   |   查看    |  getFirst() | peekFirst() | getLast() | peekLast() |   

当Deque被当作Queue使用时，它遵循的是先进先出(FIFO)的原则,从队尾添加元素，队头删除元素。
同样分异常情况不同处理方式有等效方法如下表：
     |         | Queue方法  |  等效的Deque方法 |        
     |队尾新增1| add(e) |  addLast(e) |  
     |队尾新增2| offer(e)| offerlast(e) |
     |队头删除1| remove() | removeFirst()|
     |队头删除2| poll() | pollFirst()| 
     |队头查看1| element() | getFirst()|
     |队头查看2| peek() | peekFirst()|

另一方面Deque也可以被用作后进先出(LIFO)的栈使用(优于遗留类Stack).这时候，元素是在deque
的头部进行入栈和出栈操作的。以下是栈操作的等效方法：
    |     | Stack方法 | 等效Deque方法 | 
    | 入栈| push(e) | addFirst(e)   | 
    | 出栈| pop()   | removeFirst() | 
    | 查看| peek()  | peekFirst() |

不过，Deque接口中同样提供了push(e),pop()方法，它们就是直接调用addFirst(e),removeFirst()。
将Deque用作栈时，使用这2个方法具有更强的可读性。

Deque接口还提供了2个方法用于删除内部的元素: removeFirstOccurrence(object)和
removeLastOccurrence(object).Deque继承自Queue接口，没有随机访问的方法。
同Queue接口保持一致，Deque实现也不应该插入null元素，equals和hashCode方法也是直接继承自
Object类。

Deque也继承了总接口Collection的方法，如remove(object):实现为调用removeFirstOccurrence(obj),
contains(obj), size()方法。提供了迭代器iterator(): 遍历顺序为从队列头到队列尾; 
descendingIterator():遍历顺序与iterator()相反，从队列尾到队列头。

Deque接口的主要实现类为LinkedList, ArrayDeque, ConcurrentLinkedDeque,子接口为BlockingDeque.

LinkedList:
```txt
LinkedList<E> extends AbstractSequentialList<E> implements List<E>,Deque<E>,Cloneable,
    java.io.Serializable
```
LinkedList是双向链表，同时实现了List和Deque接口，这意味着它同时支持随机访问方法和双端队列
相关的操作。从get(index)方法的实现看，它会将参数index同中间索引进行比较，index较小时从
头开始遍历链表，index较大时从尾开始遍历。

同ArrayList一样，LinkedList一样也是线程不安全的，也一样可以使用以下方法进行包装:
`List list = Collections.synchronizedList(new LinkedList(...));`

LinkedList返回的迭代器同ArrayList的迭代器机制相同，同样是快速失败机制但并不确保必定发生。
不同的是ArrayList定义了2个迭代器Itr和ListItr, LinkedList(重写了AbstractList中的2个迭代器)，
LinkedList定义了一个ListItr和一个倒序遍历迭代器DescendingIterator.

总之，LinkedList是链表结构，使用它的随机访问方法如get(index)效率较低，应使用迭代器进行遍历
处理。随机访问方法的效率应查看是否实现了RandomAccess接口。

   2. AbstractSet:
AbstractSet继承自AbstractCollection类，同时实现了Set接口。
AbstractSet没有重写AbstractCollection的任何方法实现，它只是增加了equals(object), 
hashCode(), removeAll(collection)方法的实现。

   Set接口:
Set接口是Collection接口的三大接口之一(前面已经总结了List和Queue).
Set集合即为不含重复元素的集合。确切的说，Set集合不包含这样一对元素e1,e2,其中
e1.equals(e2) = true, 并且Set集合最多只能包含一个null元素。在数学上，
a set is a collection of distinct objects.

AbstractSet的主要子类有HashSet, TreeSet, EnumSet.

      1. HashSet
```txt
public class HashSet<E> extends AbstractSet<E> implements Set<E>, Cloneable, 
   java.io.Serializable
```
--TBC



   3. AbstractQueue:
 

   4. ArrayDeque

### 映射
### 视图与包装器
### 算法
### 遗留的集合

## 图形程序设计，事件处理，Swing用户界面组件(略)
## 部署java应用程序
## 并发

<hr />
<img src="http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20190512_1.jpg" class="full-image" />
