---
title: JavaCore10Note
categories: Java
tags:
  - Java
  - Char with UTF-16
  - C++
image: 'http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20190512_1.jpg'
abbrlink: 2a1ddb5b
updated: 2019-08-15 23:12:40
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
iterator()方法返回的是其内部定义的一个迭代器Itr,Itr有一个实例域expectedModCount，
意思是expected modified count,预计修改过List集合结构的次数，如新增或删除元素会改变列表大小
的操作次数。AbstractList中有一个可继承的域modCount即用来统计该次数，迭代器初始化时
expectedModCount = modCount, Itr的next方法中第一步即为CheckForComodification()检查计数值
modCount和expectedModCount值是否相等，不等时即抛出该异常。

使用迭代器对ArrayList遍历时调用iterator.remove()方法可以正确删除，这是因为
iterator.remove()方法中有对modCount的重新赋值操作，能够保证检查的2个值相等。

经测试发现，当使用foreach循环list.remove删除倒数第二个元素时，程序不会抛出该异常，可以
理解为foreach语法糖转化后的迭代器执行完list.remove方法后没有下一个元素了，
即iterator.hasNext() == false,从而跳出了循环，没有进入到循环中继续执行将抛出异常的next方法。

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
boolean remove(index)(注意remove是删除第一次出现的该元素，即索引最小的元素，而不是所有相同的
重复元素)等支持按索引进行操作。但实际上List可以由数组或链表来实现，链表虽然也
实现了相应随机访问方法，但是效率非常低。为了解决这个问题，jdk1.4引入了一个记号接口
RandomAccess,它本身同Cloneable一样，没有任何方法，仅是一个接口。可以通过
`XXX instanceof RandomAccess`判断XXX类是否支持高效随机访问，如ArrayList就实现了RandomAccess
接口，LinkedList没有实现它。这时可以使用迭代器来顺序遍历链表。

迭代器Iterator针对List上的遍历有一个ListIterator子接口，它新增了hasPrevious(), previous(),
add(),set()等额外的方法以更方便的在list上使用迭代器。

List接口的主要实现类有AbstractList(ArrayList, Vector,LinkedList)

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

#### AbstractList:
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
public class ArrayList<E> extends AbstractList<E> implements List<E>, RandomAcess, Cloneable, 
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
public class Vector<E> extends AbstractList<E> implements List<E>, RandomAcess, Cloneable, 
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

 LinkedList:
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
public class LinkedList<E> extends AbstractSequentialList<E> implements List<E>,Deque<E>,
   Cloneable, java.io.Serializable
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

#### AbstractSet:
AbstractSet继承自AbstractCollection类，同时实现了Set接口。
AbstractSet没有重写AbstractCollection的任何方法实现，它只是增加了equals(object), 
hashCode(), removeAll(collection)方法的实现。

   Set接口:
Set接口是Collection接口的三大接口之一(前面已经总结了List和Queue).
Set集合即为不含重复元素的集合。确切的说，Set集合不包含这样一对元素e1,e2,其中
e1.equals(e2) = true, 并且Set集合最多只能包含一个null元素。在数学上，
a set is a collection of distinct objects.

Set接口的主要实现类有AbstractSet(HashSet(LinkedHashSet)),子接口有SortedSet.

   SortedSet:

SortedSet是一个给元素提供了排序规则的set集合。元素可以使用自带的Comparable接口进行排序或
是创建sortedSet时提供的Comparator接口。这也意味着sortedSet集合中的元素必须要实现Comparable
接口或是可以使用指定的Comparator接口进行排序，同时，元素之间需要能够进行双向比较，即
进行比较时不应抛出类型转换异常。

同时，sortedSet使用的排序规则应当与equals方法保持一致，即a.compareTo(b) == 0时\
a.equals(b) == true.这时因为set集合的操作都是建立在equals方法的基础上的(前面说的无重复元素
定义)，但sortedSet进行比较时使用的是compareTo或compare方法，sortedSet只有在这两个方法返回
0时才认为比较对象相同，所以如果equals和排序方法不保持一致，可能会产生意想不到的错误, 如
Comparable类注释中给出的例子:
```txt
a.equals(b) == false && a.compareTo(b) == 0
sortedSet.add(a); 
sortedSet.add(b);
```
添加元素b时会返回false并且sortedSet集合大小不变，因为在sortedSet看来，a与b是相同的元素。

SortedSet建议实现类应当提供4个构造器：
1. 无参构造器: 元素按自然排序排列
2. 有一个Comparator参数的构造器: 元素按指定的Comparator接口排列
3. 有一个Collection类型参数的构造器: 使用参数Collection中全部元素构造一个新SortedSet,按
元素的自然排序规则排序。
4. 有一个SortedSet类型参数的构造器: 使用与参数sortedSet中相同的元素和相同的排列规则建立
一个新的sortedSet.

值得注意的是, SortedSet有些方法是返回有区间限定的子set集合，子集元素的边界默认是半开区间，
即包含低边界，不包含高边界(包头不包尾).如果想得到全闭边界的子集，可以将高边界向后推进一个
元素。如以下例子:
```txt
SortedSet<String> sub = s.subSet(low, high+"\0");
```
同理可以得到全开边界区间:
```txt
SortdSet<String> sub = s.subSet(low + "\0", high);
```
SortedSet接口比Set接口主要新增了以下几个方法:
```txt
1. Comparator<? super E> comparator();
2. SortedSet<E> headSet(E toElement);
3. SortedSet<E> tailSet(E fromElement);
4. E first();
5. E last();
```

SortedSet的主要子接口为NavigableSet.
  
  NavigableSet:
NavigableSet比SortedSet多定义了一些方法，如返回集合中离被搜索元素最近的元素方法:
lower: 返回小于参数的元素，floor: 返回小于或等于参数的元素，ceiling:大于等于，
higher: 大于。NavigableSet集合支持升序遍历和倒序遍历，需要注意的是descendingSet方法
并没有新键一个set集合，它是在原集合的基础上进行处理的，如果改变其中的一个集合，另一个
集合也会受到影响(可以查看TreeSet的该方法实现，使用了navigableMap.descendingMap())。

Navigable接口还增加了pollFirst(),pollLast()用于删除第一个或最后一个元素(如pollFirst在升序
排列时删除最小值，倒序排列时删除最大值)。

不同于父类SortedSet中的subSet,headSet,tailSet方法，NavigableSet中的这些方法添加了是否包含
边界的参数，可以使调用者更方便的控制。
因为SortedSet集合需要元素间进行比较，所以不建议在其中插入null元素。

NavigableSet接口的主要实现类有TreeSet, ConcurrentSkipListSet.

AbstractSet的主要子类有HashSet, TreeSet, EnumSet.
      1. HashSet
```txt
public class HashSet<E> extends AbstractSet<E> implements Set<E>, Cloneable, 
   java.io.Serializable
```
从代码实现看，HashSet是用HashMap实现的，为了保证元素的唯一性，HashSet里的元素被当作
HashMap的键，值是一个简单的Object对象PRESENT = new Object().HashSet的add方法实现即为
`map.put(e, PRESENT) == null;`,remove方法实现为`map.remove(e) == null;`其中put和remove方法
返回的是value值。HashSet的迭代器实现为`map.keySet().iterator()`.

由HashMap实现的HashSet无法保证集合的元素遍历顺序，同时HashSet允许null元素(HashMap允许null
键),因为键的唯一性，null元素同其他元素一样，也只能有一个。
遍历HashSet集合的时间与HashSet元素数量加上内部实现HashMap的容量大小之和成正比。因为元素
之间无联系(散列算法放入)，需要遍历整个空间。
HashSet是线程不安全的，同ArrayList,LinkedList一样，可以使用如下方法
```txt
Set s = Collections.synchronizedSet(new HashSet(...));
```
HashSet的迭代器也是快速失败的。

HashSet有一个子类LinkedHashSet.

   LinkedHashSet:
```txt
public class LinkedHashSet<E> extends HashSet<E> implements Set<E>, Cloneable, 
   java.io.Serializable
```
查看LinkedHashSet的实现可知，它调用了定义在HashSet中的重载构造器(使用bool值dummy区分)，
在其中使用LinkedHashMap而不是HashMap实现Set集合，其他方法都使用默认的HashSet实现，没有进行
重写。
同LinkedHashMap一致，LinkedHashSet维护了一个双向链表来记录元素的插入顺序(重复插入相同元素
不会改变它的次序),可以使用它来记录参数set集合的元素顺序(底层是LinkedHashMap比HashMap在键上
新增了一个双向链表来记录键的插入顺序)，如
```txt
void foo(Set s) {
  Set copy = new LinkedHashSet(s);
  ...
}
```
由于维护了一个双向链表，LinkedHashSet效率比HashSet低一些，但遍历集合时，由于链表的存在，
它的时间是与元素个数成正比的，而HashSet(HashMap实现)它是与集合的容量成正比的。 

这样看来，当修改较少，遍历查询较多时，应使用LinkedHashMap或LinkedHashSet，而不是HashMap或
HashSet.
同HashSet一样，LinkedHashSet也是线程不安全的，可以使用
```txt
Set s = Collections.synchronizedSet(new LinkedHashSet(...));
```

   2. TreeSet
```txt
public class TreeSet<E> extends AbstractSet<E> implements NavigableSet<E>, Cloneable,
   java.io.Serializable
```
同HashSet类似，TreeSet底层也是使用了TreeMap实现的，TreeMap是NavigableMap接口的红黑树实现，
而NavigableMap继承自SortedMap,SortedMap继承自Map接口，它们之间的关系和Set,SortedSet,
NavigableSet的关系基本相同，都是sortedXXX新增了可排序功能，NavigableXXX进一步扩展:返回目标
附近元素，提供倒序遍历，优化获取子集合边界控制的方法。

同HashSet一样，TreeSet的add方法即`m.put(e, PRESENT) == null;`,remove为
`m.remove(o) == PRESENT;`,NavigableSet的first方法为`m.firstKey();`,last方法为`m.lastKey();`,
其他也都是类似的调用TreeMap中相应的方法。
TreeSet也是线程不安全的。

   3. EnumSet
枚举可以看作不可变的常量对象，当这些枚举对象需要批量处理时可以使用EnumSet。它有2个实现，
如果枚举值个数超过64个，使用JumboEnumSet实现类，如果小于等于64个，使用RegularEnumSet实现。
查看它们的实现可知，由于枚举的常量特性，RegularEnumSet使用一个long数值作为整个set集合的
容器，add,remove,get操作都是对该长整型数值的位操作(其中size方法是使用Long.bigCount()方法
来统计1的个数实现的)。同理，JumboEnumSet是使用一个long[]数组作为容器进行存储。

EnumSet使用noneOf(Class elementType)方法创建一个空的枚举集，方法中根据枚举值个数判断选择
是JumboEnumSet还是RegularEnumSet实现;使用allOf(Class elementType)创建一个包含了所有枚举值
的枚举集，还可以使用of方法对1到5个枚举值快速创建枚举集。

EnumSet集合中的所有元素都必须显式或隐式的来自同一个枚举类型.EnumSet是用位向量(bit vectors)
表示的。它返回的迭代器永远不会抛出ConcurrentModificationException(对位进行操作),无法得知
遍历过程中修改集合的影响。EnumSet不允许插入null元素，会抛出空指针异常。

EnumSet同样是线程不安全的，可以使用
```txt
Set<MyEnum> s = Collections.synchronizedSet(EnumSet.noneOf(MyEnum.class));
```
由于EnumSet是由位操作实现的，所以所有的集合基础操作都是常数时间内完成，比HashSet高效很多。
如果批量操作方法的参数也是EnumSet,它也是常数时间完成。由此可知，如果元素集合可以被定义为
枚举类型，使用EnumSet进行处理是非常高效的。

#### AbstractQueue:
AbstractQueue继承AbstractCollection类，实现了Queue接口。
从代码可以看出，AbstractQueue使用Queue接口的方法如offer,poll,peek实现了集合的基础操作如
add,remove,element,addAll方法，如果操作失败抛出相应的异常。clear()方法则是死循环出队操作:
```txt
while(poll()!=null);
```
像前面说的Queue接口一样，AbstractQueue的子类应实现一个不允许插入null元素的offer方法(因null
被当作特殊返回值),peek,poll,size,iterator方法。

AbstractQueue的主要子类有PriorityQueue,并发包下的ArrayBlockingQueue, LinkedTransferQueue,
SynchronousQueue,LinkedBlockingDeque, DelayQueue, LinkedBlockingQueue, ConcurrentLinkedQueue,
PriorityBlockingQueue.从这也可以看出，并发编程大量使用到了队列。

PriorityQueue:
二叉堆实现的优先队列。
现实生活中有时候我们需要在一堆元素中选出最大或最小值，然后插入一些新元素，再在其中选出最值，
或者是输入集合过于巨大，无法进行存储或存储后排序过于缓慢，这些场景都可以使用优先队列来解决。

使用场景:
比如输入N个字符串，每个字符串都有一个整数作为键，需要找出输入流中键最小的M个字符串。
(字符串的比较对象是一个整数，我们可以通过该索引来引用优先队列中的元素并进行操作，
这实际是索引优先队列的一个使用场景)

解决方案:
这里的整数索引即为对应字符串的优先级，我们可以将每个字符串存入优先队列中，并检查优先
队列中的元素是否超出M,如果超出则删除其中优先级最低(整数最大)的字符串。通过这种方式优先队列
中始终存储的都是优先级最高的M个字符串。

这就是优先队列的常见用法，使用者只需要执行入队和出队操作，并控制队列的大小，即可以得到需要
的元素集合，并且整个过程是动态的，支持无限输入。

那么优先队列是如何新增元素并确保每次出队操作都是优先级最低(值最小)的元素呢？可以使用
普通数组或链表实现:
1. 正常插入元素，删除时再找出最大的元素，最差时需要线性时间，即每个元素都比较了一遍。
2. 每次插入后都保持有序，较小元素都向后移动，保证第一个元素是最大值，删除时直接删除它即可。
同样，插入时最差也是线性时间，插入的是最小值，每个元素都被移动了。
优先队列实际使用的是一种叫二叉堆的数据结构，它可以保证插入和删除都是对数时间，最多只需要
处理一半的元素。

```txt
二叉堆定义: 二叉堆中的每个顶点都大于或等于它的两个子节点。二叉堆的根节点即为最大值。
```

二叉堆可以定义到数组a[]中，a[k]的子节点为a[2k]与a[2k+1].

当每次插入新的元素时，需要进行重新排列使得数组保持堆有序，这个过程叫堆的有序化(reheapifying).
具体为上浮或下沉，元素与父节点或子节点进行比较后决定是否需要互换位置。

PriorityQueue同样使用数组存储堆，默认升序排列，即队列头queue[0]存储的是最小值，这样执行
出队poll()操作后，删除的是最小值，队列中保存的是较大者的集合，即PriorityQueue是MaxQueue,
这一点在实际使用中应当注意。

与SortedSet相同，优先队列中的元素需要根据其自身进行排序(实现Comparable接口)或指定
Comparator比较器，所以优先队列不允许插入无法比较的元素或null元素。如果有多个相等的最小值，
优先队列会任选一个作队列头，方法poll,remove,peek,element处理的都是队列头的元素。
优先队列本身同ArrayList一样，内部实现的数组会自动进行扩容，同样是grow方法，当数组大小小于
64时扩大一倍，超过64时扩容原大小的一半。

PriorityQueue也提供了迭代器iterator,但同ArrayList或TreeSet不同的是，在遍历过程中调用迭代器
的remove方法进行删除时，实际调用的是PriorityQueue.this.removeAt(index)方法，其中同样会进行
堆的有序化操作，从而对剩余元素的顺序产生影响(实际上为了全部遍历到，迭代器中特意定义
了一个ArrayDeque来存储被影响到的元素)，所以无法保证元素的遍历顺序。若想要固定的遍历顺序，
可以使用`Arrays.sort(queue.toArray());`.

PriorityQueue与ArrayList,LinkedList, HashSet, TreeSet一样是线程不安全的，若需要线程安全可以
使用PriorityBlockingQueue.由于底层的数组实现和二叉堆的数据结构，add(e),offer(e),poll(),
remove()方法都是O(logN)时间，remove(object),contains(object)是线性时间，peek(),element(),
size()是常量时间。

从实现看，PriorityQueue的初始默认大小是11,定义了多个构造器:
```txt
1. 无参构造器: 使用默认大小，自身Comparable比较
2. 一个指定初始大小参数的构造器: 自身Comparable比较
3. 一个指定比较器Comparator参数的构造器: 使用默认大小
4. 同时指定初始大小和Comparator
5. 一个Collection集合参数的构造器: 如果参数是PriorityQueue类型，可以直接使用queue.toArray()
  方法快速新建对象，否则需要拷贝数组后进行堆有序化操作。
```
从offer(e)方法的实现可以看出，新增元素时需要执行上浮操作SiftUp(size,e),将新元素从队尾
开始循环与父节点比较直到新元素大于或等于父节点。

remove(object)实际调用的是removeAt(index)方法，如果删除的是队尾元素，则直接删除并返回null
不影响堆有序，否则将队尾元素先删除后再将其值插入到要删除的位置上，执行下沉操作，如果其位置
没变动，再执行上浮操作，以这种方式来保证堆有序(像这种执行上浮操作并位置确实变动的元素在
迭代器中刚好"逃过"了待遍历部分，removeAt(index)方法会直接返回该元素，迭代器的remove方法会
根据removeAt返回值是否为null来判断是否需要加入特殊ArrayDeque队列forgetMeNot中)。

heapify()方法保证了整个数组的堆有序，它从个数大小的一半开始倒序遍历直到为0，对每个元素
执行下沉操作。将被操作元素沿树向下比较，直到该元素小于或等于子节点。
在从Collection集合参数的构造器中有使用到heapify()方法，复制数组后调用它使得堆有序。

#### ArrayDeque
```txt
public class ArrayDeque<E> extends AbstractCollection<E> implements Deque<E>, Cloneable,
   Serializable
```
使用动态循环数组的Deque接口实现类。数组默认初始大小为8, 数组容量用完时(head == tail)固定
是扩大一倍现有容量。 

ArrayDeque也是线程不安全的，不允许插入null元素(Queue统一限制),被当作栈使用时比Stack类快，
当作队列使用时比LinkedList快。
ArrayDeque的迭代器同样基于快速失败机制，但不保证一定会抛异常。

总之，ArrayDeque应是最常用的普通栈和队列(无线程安全要求)的实现类，push(e),pop(),offer(e),
poll()方法也非常明确简洁，无需关心具体实现。同样，初始化时指定大小可以减少扩容次数。

#### AbstractMap
HashSet基于HashMap,TreeSet基于TreeMap,可知Map是比Set更通用的存在。

   `Map<K,V>`接口:
Map接口定义了键集合映射到值集合的关系，键不能重复，每个键最多只能映射一个值。
Map接口提供了3种集合视图展示Map集合中的内容，a set of keys(keySet()), 
a collection of values(values()), a set of key-value mappings(entrySet()).
Map集合中元素的顺序取决于迭代器遍历元素的顺序，如TreeMap是有序的，HashMap是无序的。

当使用可变对象作为键时，如果该对象发生了改变，改变了它的equals相等性，那么它对Map集合
产生的影响是无法确定的。

所有Map接口的实现类应当提供2个构造器，一个无参构造器，一个以单个Map集合为参数的构造器。
可以利用后者复制任意一个Map集合。一些Map实现对键或值的类型有限制，插入不相符的类型可能会
报空指针异常或类型转换异常，查询一个不相符的键或值可能抛异常，或者仅仅返回false，这取决于
具体的实现。

Map接口定义了很多对Map集合的通用操作方法，如boolean containsKey(key), 
boolean containsValue(value), Value get(key)。键集合视图`Set<K> keySet()`, 值集合视图
`Collection<V> values()`, 键值对集合`Set<Map.Entry<K,V>> entrySet()`.

最后一个视图是在Map接口中定义了一个内部接口`Entry<K,V>`, entrySet方法返回的set集合元素
即为该Entry类型，Map.Entry对象在整个遍历过程中都可以被有效访问。从另一方面来说，
如果在迭代器返回Map.Entry对象后修改了Map集合，Map.Entry的行为无法被确定，除非使用
Map.Entry的setValue()方法，这一点同其他集合的迭代器调用自身的remove()方法才可以正常删除
是一样的道理。

Entry接口本身代表了一对键值对，它定义了很多操作该键值对的方法，如K getKey(), V getValue(),
V setValue(V), 同时定义了很多利用λ表达式实现的Comparator比较器，如comparingByKey(),
comparingByValue(), comparingByKey(keyComparator), comparingByValue(valueComparator),
默认方法getOrDefault(key, defaultValue), replaceAll(BiFunction), putIfAbsent(K,V), 
remove(K,V), replace(key, oldValue, newValue), replace(key, value), 
computeIfAbsent(key, function), computeIfPresent(key, BiFunction), compute(key, BiFunction),
merge(key, value, BiFunction).

Map接口的主要实现类有AbstractMap(HashMap(LinkedHashMap), WeakHashMap, IdentityHashMap等), 
HashTable 主要子接口有CocurrentMap, SortedMap.

AbstractMap: 
  AbstractMap为Map接口的部分方法提供了实现，如containsValue(v), containsKey(k), get(k), 
remove(key), keySet()(定义AbstractSet的匿名内部类，复用EntrySet的迭代器)，values()
(实现方法类似keySet()).entrySet()方法为抽象方法，equals(object), hashCode(), toString()
方法。同时它提供了`SimpleEntry<K,V>`内部静态类实现Map.Entry接口，该类支持setValue(V)
方法修改map集合，类似的还有`SimpleImmutableEntry<K,V>`, 它没有setValue(V)方法，适合于
返回线程安全的map集合元素快照。

如果想实现一个不可变的Map集合，用户只需要继承AbstractMap类并实现entrySet()方法，通常它与
keySet()方法一样是基于AbstractSet类，由于它的不可变性，该Set集合不应当实现add(e), remove(obj)
方法，迭代器也不应实现remove()方法。(因为各个Map.Entry的具体实现类不同，所以entrySet()方法
只能写为抽象方法)

反之，如果需要实现一个可变的Map集合，用户需要重写put方法，并且entrySet().iterator必须实现
remove()方法。

AbstractMap的主要子类有HashMap, TreeMap, WeakHashMap, IdentityHashMap, EnumMap,
ConcurrentHashMap. 
   
   1. HashMap
```txt
public class HashMap<K,V> extends AbstractMap<K, V> implements Map<K,V>, Cloneable, 
   Serializable
```
用哈希表实现的Map接口，基本等同于HashTable, 只不过HashMap是线程不安全的，并且HashMap允许
null键和null值。在散列函数可以恰当散列元素到每个桶的情况下，基本操作如get和put方法的性能
是常量时间。HashMap中的元素遍历顺序是随机的。遍历HashMap的时间与以下两者之和成正比: 
hashMap的容量(桶的个数)与hashMap的元素个数。所以不应将HashMap的初始容量设置的太高, 或者
是加载因子设置的太低。

一个hashMap对象的性能主要受2个参数影响: 初始容量和加载因子。初始容量即为哈希表在创建时
哈希表中桶的个数，加载因子为哈希表中元素数量达到一定程度时才允许它自动扩容的比例大小。
当HashMap中的元素数量超过加载因子和现有容量的乘积时，HashMap会重新"哈希化"(rehash),过后
桶的数量会变为之前的两倍。

默认的加载因子0.75是在时间和空间消耗之间的平衡比例，高于0.75虽然提高了空间利用率，但是增加
了查询的时间消耗，包括get和put方法。低于0.75会浪费空间，所以在设置初始容量大小时应同时考虑
预计的元素个数和加载因子的大小。实际上如果初始容量大小大于最大的预计个数除以加载因子的得到
的值，就不会发生重新哈希化，不需要扩容。但如果容量太大可能查询较慢，同时遍历时间也长，还是
要看具体的性能要求。

使用一个足够大的hashMap来存储大量元素要比使用hashMap的动态扩容机制来存储效率高。使用相同
哈希值的元素作为键必定会降低HashMap的性能，HashMap使用CompareTo方法(假设不等)在重新哈希化
时打破相等性，如果CompareTo方法也相等，则使用System.identityHashCode()进行比较。具体可见
HashMap.TreeNode的TieBreakOrder方法实现。

HashMap也是线程不安全的，同样可以使用：
```txt
Map m = Collections.synchronizedMap(new HashMap(...));
```
HashMap的三个视图keySet(),values(), entrySet()中的迭代器都是快速失败的，同样不保证抛出异常。

当哈希表中桶过大时，HashMap会将桶的实现由list转换为树，如果元素变小，它又会转换回来
(像之前说的一样，它使用ComparaTo方法和identityHashCode值来区分HashCode值相同的树节点)。
HashMap定义了一个实例域`TREEIFY_THRESHOLD = 8`, 意味着一个桶中的元素超过8个时，HashMap 
就会开始树化。同理反转化有实例域`UNTREEIFY_THRESHOLD = 6`,少于6个时开始反转。还定义了
实例域`MIN_TREEIFY_CAPACITY = 64`,意味者如果HashMap的容量小于64时，如果这时一个桶过大，
它并不会树化，而会对HashMap实现扩容操作。

HashMap定义了`Node<K,V>`类实现Map.Entry接口，一个Node类实例就是一个键值对，Node有实例域
hash(key的hash值)，key(键), value(值)， next(相同hash值链表中的下一个Node节点)，Node类
实现了Entry接口的setValue(v), equals(object), hashCode()等方法。

HashMap最常用的get(key)是根据给定值查找对应的键，它返回null值代表两种情况，可能该键不存在，
也可能该键对应的值就是null值。所以get(key)方法通常是和contains(key)方法一起使用，以区分这
两种情况。
HashMap的存储容器其实是`Node<K,V>[]`数组，get(key)方法通过计算hash值定位到数组中某个索引的
位置(first = tab[(n -1) & hash]),再通过比较键来解决"哈希碰撞"(不同键产生相同哈希值)的问题
(`e.hash == hash && ((k = e.key) == key || (key != null && key.equals(k)))`)

get(key)实际调用的是getNode(hash, key)方法，它返回的是一个Node节点，
containsKey(key)方法也是通过getNode(hash, key)方法的返回对象是否为空来判断是否存在该键
对应的节点，从而判断出HashMap是否包含该键。

V put(key, value)方法将新的键值对节点追加到key对应的hash值链表中，方法的返回值是该键对应的
旧值，如果为null的话，像get(key)方法一样，可能是原来不存在这个键或原来映射的值就是null.
查看put方法的实现注意到，找到对应链表的最后一个节点并替换值以后或是新增一个节点以后，
它会调用afterNodeAccess()方法或AfterNodeInsertion方法，注释说是要回调LinkedHashMap的后
处理，这样做的原因待后续补充...(ToDo)

关于resize()方法的实现，网上搜索到jdk8以前扩容时需要根据`e.hash & (oldCap - 1)`重新计算
hash值，比较耗费性能，jdk8时改为根据`e.hash & oldCap == 0`判断是否需要移位。相当于原数组相同
索引的链条的后半部分被移动到扩增的数组部分了，前半部分保持原位不动。

HashMap中为树化定义了一个内部类TreeNode, 它继承自`LinkedHashMap.Entry<K, V>`,查看定义可知
后者是在继承HashMap.Node类的基础上新增了before, after的Node指针(即双向链表)。
而这个TreeNode中即是定义了红黑树的相关实例域和方法。

HashMap说到底还是一种符号表的实现，在《算法》第4版的第3章查找一章中对符号表的api, 使用场景
进行了详细的说明，尤其是红黑树的讲解是公认非常棒的。


以下为该书中相关知识的笔记:
符号表性能要求就是大量查询操作和一般插入的高效性，即对get和put方法的性能要求。

1. 最简单的实现: 无序单向列表
使用一长串无序单向链表来存储整个符号表，每次查询都从头节点开始查询，直到找到目标节点为止，
找到时修改目标节点的值为新值;若未查找到目标，则将该键值对作为新节点追加到链表的头部。
最差的情况是插入的键都是不同的，这时每次查找都需要比较全部的元素，总比较次数为n ^ 2 / 2。

2. 使用一个有序数组存储键，另一个数组相应位置存储对应值的方式存储整个符号表。由于数组的
有序性，可以使用二分查找法来实现对数级别的查找效率，但是进行插入时需要将比新键大的元素
统一向后移动一格以空出位置插入新元素。这样虽然查询很快，但插入操作效率太低: 因为查询时
元素的比较次数是对数级别，而put方法移动时最糟糕时是全部N个元素移动，一共有2个数组，所以
数组的访问次数是2N，N个元素进行插入时就是`N^2`级别。

3. 使用二叉查找树存储符号表。二叉查找树结合了链表新增节点的灵活性和有序数组的查找高效性，
是集成了链表和数组两者优点的数据结构。

```txt
二叉查找树(BST): 每个节点都含有一个Comparable的键(以及值), 每个根节点的键都大于左子树的
任意节点键，同时小于右子树的任意节点键。
```
即从左到右将每个节点的键映射到水平轴上可以得到一个从小到大的升序序列。
二叉查找树独特的结构使得(在树平衡的情况下)查找和插入都是对数级别，极大的提高了操作效率。

二叉查找树查询代码实现：
```txt
public V get(K key) {
  if (key == null) throw new NullPointerException("null key");
  return get(root, key);
}
public Node get(Node x, K key) {
  if (x == null) return null;
  int cmp = key.compareTo(x.key);
  if     (cmp < 0) return get(x.left, key);
  else if(cmp > 0) return get(x.right, key);
  else             return x;
}
```

二叉查找树最难实现的操作是删除的实现。
   1. deleteMin()方法实现。删除最小的节点很容易实现， 寻找根节点的左子树，一路向左直到某个
节点的左子树为空，则说明该节点为最小节点，返回它的右子树根节点即可。
   2. delete()方法删除任意一个节点。因为一个节点只有一个被指向的链接，但它有左子树和右子树
2个节点子链接，为了保持键的有序性，需要特殊处理。T.Hibbard提出可以使用被删节点的后继节点
来作为新的根节点代替被删节点的位置。后继节点为被删节点的右子树中最小的节点，新根节点的左
子树保持原有左子树不变，右节点指向删除了该后继节点后的新右子树。

这种解决方案确实保持了二叉树的有序性，但实际上也可以使用前继节点，即没有考虑删除后二叉树
的高度，多次删除后树的性能降低，所以应随机使用前继或后继节点作为新节点。
可以按键升序遍历整棵二叉查找树，即中序遍历： 先打印左子树的所有节点，再打印根节点，
最后打印右子树的所有节点。

为了提高性能，不管用户输入的键顺序如何，保证新增和查找都是对数级别，需要使用平衡二叉树。
(完美平衡即根节点到任意一个空节点的距离都是相等的，都是树的高度)

为了整体降低树的高度，平衡二叉树引入了3-节点，即它有2个键，3条链接。其中2个键将整个键的取值
范围分为3个区间，同样从左到右递增。
2-节点插入一个新键时可以变为3-节点，3-节点插入一个新键时可以临时变为一个4-节点，单独的一个
4-节点(如根节点)可以变为3个2-节点并保持平衡性，树高加1.如果原3-节点有一个2-节点，则将新的
4-节点中的中间键向上传递到上面的2-节点中，使之变为一个3-节点，具体是左键还是右键根据原来
的节点关系确定。通过这种层层"冒泡"的方式我们一直保持着树节点的有序性和平衡性，而这也为递归
处理的同时保持树的平衡性提供了保证。


红黑树: 它即是二叉查找树，又是上述的2-3节点二叉树。确切的说，其中的3-节点表示为使用一条
左斜的红色链接连接两个2-节点，黑色链接即为普通的2-3树链接。
由这样的定义出发可以得到红黑树的另一种定义或说是特性:
   1. 红链接都是左链接。
   2. 没有任何一个节点同时与两条红链接相连。
   3. 该树是完美黑色平衡的。(根节点到任意一个空节点上的黑色链接数量是相同的)
为了方便表示颜色，在Node类中定义域boolean red = true代表指向该节点的链接为红链接，即一个
节点是红色的说明它与父节点之间是红色链接，两者可看作一个3-节点。

旋转: 在红黑树操作过程中可能会出现红色右链接或一个节点有2个红链接的情况，这时我们可以使用
旋转使它变为正常的链接情况。如左旋转即从较小的键作为根节点转变为以较大的键作为根节点，同时
这2个节点下的左右子树也进行相应移动的过程。可以将这个旋转的过程动态的想象为节点与红色链接
向左平移的过程; 同理，右旋转是节点和红链接右移的过程(或者说拉扯更形象)。

实际新增时默认新增的节点都是红色的，再根据其是否是右链接，或父节点为2-节点、3-节点的情况
进行左旋转，右旋转，变色等处理。

旋转操作让红黑树这种特殊表示的2-3树能够真正实现上面说明的2-3树插入新节点时"冒泡"的概念过程。
如向一个3-节点中插入一个比3-节点中2个键都要大的新节点时，可以得到一棵已经有序的二叉树，它
有2条红色链接与中间键相连，此时只需要将2条红链接变为黑链接，最后根节点的颜色由黑变红！！
这整个变色的过程(链接和根节点)即实现了上面2-3树的冒泡过程, 同时也可以看到，这个新的红链接
一直沿着树在向上传递，直到遇到一个2-节点或根节点为止。

红黑树的插入在不同的情形下可以由每个节点顺序执行以下判断操作来实现:
1. 右子节点为红色，左子节点为黑色，则进行左旋转。
2. 左子节点为红色，左子节点的左子节点也为红色，进行右旋转。
3. 左右子节点都是红色，进行变色处理(3个节点都变色)。

由红黑树的put方法实现可以看出，前面与普通二叉查找树一样从根节点开始比较，小于它就递归调用
左子树根节点，大于它就递归调用右子树根节点，相等就是命中查找。这是一个从上到下的查找过程，
而2-3树新增节点是从下往上冒泡的过程，所以我们需要在递归调用的代码结束后进行旋转变色处理，
即递归方法的出栈过程是逆序过程，符合了从下往上冒泡的要求。

红黑树put方法实现代码:
```txt
public void put(K key, V val) {
  if (key == null) throw new NullPointerException("null key");
  if(val == null) {
    delete(key);  
    return;
  }
  root = put(root, key, val);
  root.color = BLACK;  // 在变换最后根节点需要手动变为黑色
}
private Node put(Node h, K key, V val) {
  if (h == null) return new Node(key, val, RED, 1); // new node color is red, and size = 1 

  // 向下查找
  int cmp  = key.compareTo(h.key);
  if     (cmp < 0)  put(h.left, key, val);
  else if(cmp > 0)  put(h.right, key, val);
  else              h.val = val;

  // 向上变幻
  // 旋转变色使红黑树保持其特性
  if (isRed(h.right) && !isRed(h.left)) h = rotateLeft(h);
  if (isRed(h.left) && isRed(h.left.left)) h = rotateRight(h);
  if (isRed(h.left) && isRed(h.right))  flipColors(h);
  h.size = size(h.left) + size(h.right) + 1;  // 别忘了加1

  return h;
}
private Node rotateLeft(Node h) {
  Node x = h.right;
  h.right = x.left;
  x.left = h;
  x.color = h.color;
  h.color = RED;
  x.size = h.size;
  h.size = size(h.left) + size(h.right) + 1;
  return x;
}
private Node rotateRight(Node h){...} // 相反即可
private void flipColors(Node h) {
  h.color = !h.color;  
  h.left.color = !h.color;
  h.right.color = !h.right.color;
}
private int size(Node x) {
  if(x == null) return 0; 
  return x.size;
}
```

红黑树的5大性质(根据这些性质可以排除某些删除节点的情形是不可能发生的，如一个黑节点只有黑
左子树或只有黑右子树，一个红节点有一个黑左子树或一个黑右子树的情况，它们都违反了性质5的高度)
1. 节点为红或黑
2. 根节点是黑色的
3. 每个叶节点(null节点)是黑色的
4. 每个红节点的2个子节点都是黑色的(不能有2条红链接链接到同一个节点)
5. 从任一个节点向下到每个叶子的路径包含的黑色节点数目相同，即黑色树高是相同的。


删除算法: 

先考虑删除最小键的问题:
2-3树中3-节点可以删除一个节点，没有影响，但2-节点删除一个节点后会形成一个空节点，
这时相当于在某条路径上减少了一个黑节点的高度，破坏了树的平衡性。这时我们可以将后者转化为
前面一种情况来解决。 

删除时检查是否为以下情况之一:
1. 如果当前节点的左子节点不是2-节点，结束。
2. 如果当前节点的左子节点是2-节点而左子节点的亲兄弟节点不是2-节点，从兄弟节点中移动(借)一个节点到
左子节点中，结束。
3. 如果当前节点的左子节点和右子节点都是2-节点，就将左子节点，父节点最小键和左子节点最近
的兄弟节点合并为一个4-节点替换当前节点，父节点减少一个键，结束。

从以上3种情况中任意一种结束都能得到一个包含最小键的3-或4-节点，直接删除该最小键即可。然后再
回头向上分解生成的临时4-节点(第3布产生的)。

以上是删除最小键，如果删除树中任意一个节点，同二叉树的处理类似，可以使用被删节点的后继节点
替代被删节点，然后新节点的右子树指向删除了后继节点后的新树(删除最小键)。删除后同样需要向上
分解临时的4-节点。

红黑树删除最小键具体代码实现:
```txt
public void deleteMin() {
  if(isEmpty()) throw new NoSuchElementException("BST underflow"); 
  // 左右子树都是黑的，将根节点变为红色，相当于根节点与左右子节点一起变为一个4-节点
  if(!isRed(root.left) && !isRed(root.right)) {
    root.color = RED;
  }
  root = deleteMin(root);
  if (!isEmpty()) root.color = BLACK; // 删完之后还需将根节点手动置为黑色, 与插入相同。
}
private Node deleteMin(Node h) {
  if (h.left == null) return null; // 无左子树，删除h节点，返回null即为用null代替节点h
  if (!isRed(h.left) && !isRed(h.left.left)) {  //此即为上述的第2种情况，需要借用节点
    h = moveRedLeft(h);
  }
//此时h.left本身已为红色(可再次调用moveRedLeft)，或它的子节点为红色(直接进入下一个节点的删除)
  h.left = deleteMin(h.left); 
// 删除之后，从下往上恢复红黑树，解除4-节点(2红键)
  return balance(h);
}
// 调用此方法时，h本身是红色的，h.left, h.left.left都是黑色的，即h的左子节点为2-节点的情况
// 调用结束时h的左子节点为红色，或它的子节点之一为红色，即h
private Node moveRedLeft(Node h) {

  flipColors(h);   // 对应上述的第3步  反转颜色 h变为黑色，左右子节点变为红色，4-节点
  if (isRed(h.right.left)) {  // 对应上述第2种情况， 兄弟节点有红键

     h.right = rotateRight(h.right);
     h = rotateLeft(h);
     flipColors(h);   

     // 这3步变幻可以使得h.left变为红色，达到了上述的左子节点变为3-节点的要求，
     // 从而可以对其再次调用deleteMin方法

     // 从这也可以进一步思考变幻的实际意义，旋转操作实际上并没有改变树的结构，红链接在左边
     // 或右边其实是3-节点的内部2个键哪个键为根节点的问题。只有变色才是将键在父子节点中
     // 传递的操作(冒泡)，或者说是2-变成3-，3-变长4-节点的操作。所以这里如果不进行判断处理
     // 的话会形成5-节点，这一点通过再次调用flipColors(h)避免，而如果没有进入该条件语句时
     // 即h的右子节点为2-节点，则只需要一步变色为4-节点即可，不用担心5-节点。
  }
  return h;
}
private void balance(Node h) {
  
  if (isRed(h.right) && !isRed(h.left)) h = rotateLeft(h);
  if (isRed(h.left) && isRed(h.left.left)) h = rotateRight(h);
  if (isRed(h.left) && isRed(h.right))  flipColors(h);

  h.size = size(h.left) + size(h.right) + 1;  // 别忘了加1
  return h;
}
```

红黑树删除任意键代码实现:
```txt
// 与deleteMin基本相同
public void delete(K key) {
  if(isEmpty()) throw new NoSuchElementException("BST underflow"); 
  if(!contains(key)) return;

  // 左右子树都是黑的，将根节点变为红色，相当于根节点与左右子节点一起变为一个4-节点
  if(!isRed(root.left) && !isRed(root.right)) {
    root.color = RED;
  }
  root = delete(root);
  if (!isEmpty()) root.color = BLACK; // 删完之后还需将根节点手动置为黑色, 与插入相同。
}
private Node delete(Node h, K key) {

  if (key.compareTo(h.key) < 0) {

    // 目标键比当前节点小的时候与deleteMin(node)相同处理
    if (!isRed(h.left) && !isRed(h.left.left)) {  
      h = moveRedLeft(h);
    h.left = delete(h.left, key);

  }else{

    if (isRed(h.left)) {
      h = rotateRight(h);
    }
    if (key.compareTo(h.key) == 0 && (h.right == null)) { 
      // 查询命中的是无右子节点的最大键，直接删除即可,delete方法返回null就是删除该节点
      return null;
    }
    if (!isRed(h.right) && !isRed(h.right.left)) {
      h = moveRedRight(h);     // 通过旋转变色得到红键
    }
    if (key.compareTo(h.key) == 0){ //命中查询，使用后继节点替换h,同时h.right中删去该后继节点
      Node x = min(h.right);
      h.key = x.key;
      h.val = x.val;
      h.right = deleteMin(h.right);
    }else{    // 目标键还在右子树中
      h.right = delete(h.right, key); 
    }
  } 
  return balance(h);   // 同样恢复红黑树性质
}
// assume that h is red and both h.right and h.right.left are black,
// using this method to make h.right or one of its children red.
private Node moveRedRight(Node h) {
  flipColors(h);
  if(isRed(h.left.left)) {
    h = rotateRight(h);  
    flipColors(h);
  }
  return h;
}
private Node min(Node x) {
  if (x.left == null) return x;
  else                return min(x.left);
}
```

以上就是红黑树的相关知识，下面来看看HashMap中红黑树的相关代码。
上面说过put(key,value)方法中会判断一个桶中是否有过多的Node节点，如果超过一定阈值，它会进行
树化。实际调用为putVal中的treeifyBin(table, hash)方法，treeifyBin方法中先判断hashMap容量是否
小于64,若小于64会扩容而不是树化，若大于它，则先使用replacementTreeNode(e, null)来构造一个
个TreeNode节点，再使用hd.treeify(table)方法来生成树。

在treeify方法中，以hd头节点开始遍历该链条，x代表该链条中的每一个节点，首先判断根节点是否为
空，为空时设置x为根节点并置为黑色，否则从树的根节点开始查询以插入x节点，其中p表示每个被比较
的节点，通过变量dir的正负区分键的大小，当指针变量p的左子节点(x比它小时)或右子节点(x比它大时)
为null时，说明查询命中，可以将x键插入，调用balanceInsertion(root,x)方法，再break跳出查询树
的循环，继续处理链条中的下一个节点。

treeify方法中已经将树的根节点置为黑色，BalanceInsertion中类似于上面的红黑树的balance方法。
其中大量有赋值语句，==比较和三目运算符混用的情况，虽然显得代码非常简洁，但是比较难理解，
需要自己画图帮助理解。balanceInsertion方法前面2步判断是针对x或xp为根节点的情况，简单处理
即可。后面分xp为xpp左子节点和右子节点2种情况讨论，它们是对称的，只看左子节点即可。

第一个if语句的情况即上面红黑树的左右子节点都为红色链接的情况，变色即可。然后下面依次进行的
左旋，右旋也对应上面的1,2种情况。理解代码实现中有2点需要注意:

1. 经过代码 `else if(!xp.red) || (xpp = xp.parent) == null)`判断之后，继续执行下面代码时
可以确认xp是红色的，并且xpp不为null.

2. 代码`root = rotateLeft(root, x = xp);`执行时会先执行表达式赋值语句，再进行方法调用。  
这时x,xp都指向同一个引用对象，rotateLeft方法中改变了该参数对象的属性(parent,left,right等),
所以x,xp变量是同时指向了变换前xp的左子节点的，即左旋后的引用情况为
`xpp (左) -> L(无变量，原来的x)(左) -> x与xp`,后面的一句为
`xpp = (xp = x.parent) == null ? null : xp.parent;`，这里个人觉得三目运算符判断没什么意义
(xp即为插入的x,不可能是null), 更多是利用其语法简洁性重置了xpp, xp, x的对象引用关系。

再看其左旋转的具体代码实现，它增加了对根节点root的处理，看起来没有上面红黑树的实现简洁清晰，
但画图可以发现，逻辑是一样的，如左旋转，实际上是4个相关的节点发生了改变:pp, p, r, rl,另外
2个节点pl,rr没有发生变化;同理右旋转改变的是pp, p, l, lr节点。要注意的是，左右旋转方法中还有
对根节点的置黑处理，而上面红黑树中是在put方法的最后才对根节点进行置黑处理的。

经过treeify中针对链表每一个节点查询比较键值后插入再balance后，最后还调用了moveRootToFront
(table, root)方法来确保树的根节点是链表的首节点。
该方法的关键为NodeTree即是红黑树结构，也是双向链表结构。moveRootToFront的主要操作为将root
节点从原有的链表位置删除，并与原有的first节点重新确定链表关系的过程。如以下初看难理解的代码
`((TreeNode<K,V>)rn).prev = rp;`即为root节点的后节点的前序节点指针指向root的前序节点，这
一步即等同于删除了root节点。后面同理是对pr,first，root节点的链表指针进行操作。

最后要看的是HashMap的删除remove(key)方法,它调用的是removeNode方法，首先是查询到该节点，如
果是树节点，则调用treeNode.getTreeNode(hash, key)方法，否则按链表来查找，同样的，找到以后
如果是树节点调用treeNode.removeTreeNode(this, table, movable)方法，否则通过修改对应的节点
指针来删除该链表中的节点。

因为TreeNode即是红黑树，也是双向链表，所以删除节点时要先删除链表节点，再删除红黑树节点并
做平衡处理。这里也是寻找待删除节点的后继节点与之交换并平衡的操作，具体操作不再仔细查看。

HashMap的主要子类有LinkedHashMap.
      LinkedHashMap:
```txt
public class LinkedHashMap<K,V> extends HashMap<K,V> implements Map<K,V> {...}
```
同LinkedHashSet在HashSet上的处理一致(或者说更本质)，LinkedHashMap在HashMap的基础上对键增加
了双向链表记录插入的顺序，这个链表使得LinkedHashMap的元素遍历顺序是固定的，相同键被重新
赋值不影响键的顺序， 因为节点位置没有改变。LinkedHashMap可用来记录参数map的顺序。也由于它
的有序性，遍历map的时间只与元素的总个数相关，与Map集合的容量无关。同样，LinkedHashMap是
线程不安全的，可以用`Collections.synchronizedMap(new LinkedHashMap())`方法得到线程安全
的map集合。

具体实现可以看到LinkedHashMap中定义了静态内部类Entry(继承自HashMap.Node类),通过这个额外的
容器来存储键插入的顺序，其中有before，after2个方向指针。LinkedHashMap还提供了一个实例域
accessOrder,可以在构造器中指定该布尔值为true或false(默认false).true代表访问的顺序，
false代表迭代顺序。LinkedHashMap的查询get(key)方法比HashMap的get(key)方法多出一步处理
就是判断该accessOrder值，如果是true,则执行afterNodeAccess(node)方法，它会将这个被访问的
节点放到Entry链表中的尾部。由于LinkedHashIterator从链表头部开始遍历，所以如果此时开始遍历
集合，最后访问的节点将最后被访问到。

可以发现LinkedHashMap没有定义put和remove方法，即它默认使用的是父类HashMap的方法，
虽然LinkedHashMap没有重新定义put,remove方法，但它通过重新定义newNode,newTreeNode方法，在
其中调用linkNodeLast(node)方法维护该双向链表。另外HashMap中的空方法afterNodeInsertion,
afterNodeRemoval在LinkedHashMap中都定义了对额外的双向链表进行处理。

*即LinkedHashMap元素的容器同HashMap一样，使用Node[]数组"拉链法"存储的,只不过额外定义了
双向链表来存储节点顺序。*

注: HashMap中定义的TreeNode内部类继承的是`LinkedHashMap.Entry<K,V>`类，所以TreeNode类本身
也是双向链表。

   2. TreeMap
```txt
public class TreeMap<K,V> extends AbstractMap<K,V> implements NavigableMap<K,V>, Cloneable,
  java.io.Serializable
```
同SortedSet, NavigableSet基本相同，SortedMap提供了submap，headMap,tailMap方法按照键的顺序
截取子map集合。NavigableMap基于顺序提供了更多的区间操作，如floorEntry, floorKey, 
ceilingEntry,ceilingKey等方法。

TreeMap即Map的红黑树实现。保证对于containsKey,get,put,remove操作都是对数级别。TreeMap的
红黑树算法来源于算法导论中的实现,即CLR.同样的，compare或compareTo方法需要与equals方法保持
一致。TreeMap不是线程安全的，可以通过`Collections.synchronizedSortedMap(new TreeMap());`
来得到线程安全的SortedMap集合。

具体实现可以看到TreeMap定义了自己的Entry类(继承自Map.Entry类)存储键值对，同时定义了左子节点
指针，右子节点指针，父节点指针。get(key)查询方法即通过Comparator或Comparable进行比较得到
需要的节点，put(key,value)方法同样是先查询到位置插入后再进行红黑树调整，值得注意的是put
方法中没有HashMap中的扩容操作，是一颗无限增长的树或链表。

将TreeMap的rotateLeft方法实现与上面的实现比较发现，CLR算法实现多使用了一个parent父指针，实际
上是可以省去它的，父指针增加了额外的复杂性。
具体实现不再赘述。

   3. WeakHashMap
```txt
public class WeakHashMap<K,V> extends AbstractMap<K,V> implements Map<K,V> {...}
```
使用弱键的哈希表Map接口实现类。当WeakHashMap中的某个键不再被正常使用时，这个键值对会自动
被删除。具体的说就是，一个已经存在的映射关系不能阻止垃圾回收机制回收这个键，当键被删除了，
这个键值对也就不存在了。WeakHashMap同样支持null键和null值，同样是线程不安全的，可使用
`Collections.synchronizedMap(new WeakHashMap(...))`得到线程安全的map集合。

WeakHashMap主要适用于equals方法使用==号实现的键对象，如String对象。对于那些可重复创建的键
对象来说，WeakHashMap的自动删除操作会出现问题。垃圾回收器就好像WeakHashMap背后默默运行的
一个线程一样，它会在任何时间进行删除操作,所以WeakHashMap中的方法如size(), isEmpty(), 
containsKey(), get(), put()调用的结果随时间可能会发生变化。每个键对象是用一个弱引用存储的，
只有当这个弱引用在Map集合内部和外部的引用都被垃圾回收器回收后这个键才会被删除。

WeakHashMap的值对象是用普通的强引用来存储的，所以应注意值对象不应该强引用(直接或间接)它
对应的键，这样会阻止键被回收。有时候会出现这样的情况，即键x映射值X,键y映射值Y,此时值X又
强引用键y，而值Y强引用键x,而映射本身算是强引用的，这样就形成了x,X和y,Y之间间接强引用的关系。
为避免这样的情况，对于不依赖WeakHashMap集合来存储引用的值对象来说，可以在插入前进行包装:
`m.put(key, new WeakReference(value));`,在查询调用get(key)方法时再进行拆箱即可。


以下为相关背景知识补充:

Reference分几种类型: 
1. 强引用(Strong Reference) 即普通的引用，如Object obj = new Object();当内存不足时，虚拟机
会抛出内存溢出异常，而不会回收强类型的引用。需要回收这种类型引用时，需要赋值obj = null.
它对应着Reference的子类FinalReference,JVM采用其子类Finalizer来管理每个强引用对象，要清理
对象时将其放入对应的引用队列中并调用对象的finalize()方法进行清理。

2. 软引用(Soft Reference) 当内存空间不足时，垃圾回收器就会回收软引用对象。所以它适合用于
内存敏感的高速缓存。实际应用如网页的后退按钮，内存充足时可以将网页浏览记录保存为软引用作为
缓存使用，但内存不够时它就会被垃圾回收器回收。

3. 弱引用(Weak Reference) 弱引用对象比软引用对象生命周期更短，当垃圾回收器扫描到只具有弱
引用的对象时，不管内存大小都会回收这个对象。但垃圾回收器优先级很低，所以通常不会很快就发现
这些对象。当内存不足时，垃圾回收器也会回收弱引用对象(即内存不足时垃圾回收器会回收一切可回收
对象)。

4. 虚引用(PhantomReference) 虚引用并不会决定对象的生命周期，它和没有任何引用一样，随时可能
被垃圾回收器回收。虚引用主要用来追踪对象回收的情况，它必须和引用队列ReferenceQueue一起使用，
当垃圾回收器回收一个对象时，如果它有虚引用，则在回收前会将它加入到相应的队列中。

软引用，弱引用同垃圾回收关系
java.lang.Reference是所有引用对象的基类,它定义了所有引用对象的通用操作，因为引用对象是与
垃圾回收器紧密合作实现的，所以不能直接继承Reference类。可以继承它的子类。

Reference实例对象可能处在4种状态中:active, pending, enqueued, inactive.

1. active: 新创建的实例是active状态，垃圾回收器监测到它的引用对象的可达性发生变化时，会将该
实例对象变为pending(如果创建的时候有注册相应的引用队列ReferenceQueue)并且将该实例加入到
pending-reference list中，或者直接为inactive(创建时未注册引用队列)。Active状态时queue为
创建时定义的queue或为null, next = null, discovered = GC维护的discovered引用列表中当前元素
的下一个元素。

2. Pending: 该实例是pending-reference list中的一个元素，等待Reference-handler线程对它进行
入队操作。queue为创建时定义的queue, next = this，discovered = pending-reference list中当前
元素的下一个元素，如果当前元素为最后一个，则discovered = null.

3. Enqueued: 该实例成为创建它时指定队列中的一个元素(即入队状态)，当该实例从队列中被删除时，
它会变为inactive状态。queue = ReferenceQueue.ENQUEUED; next指向队列中的下一个实例，如果当
前实例是队列中的最后一个元素，则next = this. discovered = null(tryHandlePending方法中有赋值)

4. Inactive: 一旦一个实例变为Inactive状态，它的状态就不会再改变了，相当于结束。
queue = ReferenceQueue.NULL; next = this.

所以垃圾回收器可以通过next == null来判断一个reference实例状态是否为active.
Reference类中的几个实例域分别为:

referent:  引用指向的对象
queue:  reference对象关联的队列，即引用队列。
next: 上面referenceQueue中当前元素的下一个元素。
discovered: pending-reference list中当前元素的下一个元素，jvm给它赋值。

ReferenceQueue: 
  当对象可达性发生变化时该引用对象被垃圾回收器放入的注册引用队列。
通过实现可以看出，ReferenceQueue中定义了一个Reference Head头节点，实际的队列结构是由
Reference对象本身的next属性构成的，只是入队，出队操作定义在ReferenceQueue中。可以看到，
Reference和它的容器ReferenceQueue是互相定义的，这一点显示了它们之间包含与注册的关系。

ReferenceQueue的入队方法enqueue(reference)只能被Reference类调用，可以通过
reference.enqueue()方法的实现明确这一点(但实际上垃圾回收器没有调用该方法，它是直接操作的)，
referenceQueue.enqueue(r)方法一开始判断r.queue是否为NULL或ENQUEUED状态，若是直接返回false.
其中NULL代表该引用对象创建时使用的是默认的NULL队列注册的，没有指定相应队列所以入队失败;
ENQUEUED代表该引用对象已入队，重复入队为失败操作。下面的逻辑可以看到新入队的节点为头节点，
r.next = (head == null) ? r : head;  r = head.实际出队方法reallyPoll()中判断r == rn，说明
r是队列中最后一个元素，将head = null.删除操作即将r.queue = null, r.next = r. poll()即加锁
调用reallyPoll()方法。remove()方法提供了一个超时时间，时间为0即lock.wait(0)表示永久阻塞
直到被唤醒。

WeakReference和ReferenceQueue配合使用代码如下，可以看到对象被回收后队列中仍然存有该对象的
引用:
```txt
public class TestReferenceQueue {
    public static void main(String[] args) throws Exception{

        Person person = new Person();
        ReferenceQueue<Person> queue = new ReferenceQueue<>();
        WeakReference<Person> weakReference = new WeakReference<>(person, queue);
        System.out.println(weakReference);
        System.out.println(weakReference.get());
        person = null;
        System.gc();
        Thread.sleep(500);
        Reference<? extends Person> ref = queue.remove();
        System.out.println(ref);
        System.out.println(ref.get());
    }
    private static class Person{
        @Override
        public String toString() {
            return "Person{}";
        }
    }
}
结果为:
java.lang.ref.WeakReference@1540e19d
Person{}
java.lang.ref.WeakReference@1540e19d
null
```

WeakHashMap弱引用实战代码:
```txt
public class WeakHashMapDemo {
    public static void main(String[] args){
         
        WeakHashMap<String, byte[]> whm = new WeakHashMap<String, byte[]>();
     // HashMap<String, byte[]> whm = new HashMap<String, byte[]>();
        String s1 = new String("s1");
        String s2 = new String("s2");
        String s3 = new String("s3");
         
        whm.put(s1, new byte[100]);
        whm.put(s2, new byte[100]);
        whm.put(s3, new byte[100]);
         
        s2 = null;
        s3 = null;
         
        /*此时可能还未执行gc,所以可能还可以通过仅有弱引用的key找到value*/
        System.out.println(whm.get("s1"));
        System.out.println(whm.get("s2"));
        System.out.println(whm.get("s3"));
         
        System.out.println("-------------------");
         
        /*执行gc,导致仅有弱引用的key对应的entry(包括value)全部被回收*/
        System.gc();
        System.out.println(whm.get("s1"));
        System.out.println(whm.get("s2"));
        System.out.println(whm.get("s3"));
    }
}
结果为WeakHashMap中s2,s3对应的值已变为null,HashMap仍存在。
```

从WeakHashMap的实现可以看出，它的存储容器同HashMap类似，是Entry[]数组，但是WeakHashMap
自定义的Entry类为
`private static class Entry<K,V> extends WeakReference<Object> implement Map.Entry<K,V>{}`,
从这可以看出，WeakHashMap的键属于弱引用类型。从代码中可以看到，get(key), size(), put()方法
都间接调用了expungeStaleEntries()方法，该方法对引用队列进行出队操作，利用队列中的引用来
删除WeakHashMap链表中已经失效的节点。
 
   4. IdentityHashMap
```txt
public class IdentityHashMap<K,V> extends AbstractMap<K,V> implements Map<K,V>, 
  java.io.Serializable, Cloneable{...}
```
该map使用引用的等价性而不是对象的对价性来比较键，即使用==符号而不是equals方法来区分不同的
键。从这一点上说，它违反了Map接口默认使用equals方法进行比较键的定义，所以它不适合作为常用
接口使用，只适用于需要使用引用等价性的场景，如序列化，深度拷贝，代理对象集合等。这个类实现
了Map接口的所有方法，同HashMap一样允许null键null值，不保证键的顺序。它有一个预计最大容量的
参数来决定初期桶的数量，同样，超出后自动扩容重新哈希化的代价很高，同时，过大的容量又会造成
迭代元素实践过长，所以需要定义一个合适的容量大小。IdentityHashMap也不是线程安全的，可以使用
Collections.synchronizedMap(...)得到线程安全的map集合。它的迭代器也是快速失败的，不保证
一定会抛出异常。

IdentityHashMap是哈希表的线性探测法实现，可以在《算法》第4版中看到该算法实现。
以下为书中的相关笔记。

散列表有2种实现: 拉链法(HashMap)和线性探测法(IdentityHashMap)，拉链法是让哈希值相同的键
放入同一个索引的桶中形成链表来解决碰撞问题，而线性探测法是利用数组中的空位来解决碰撞问题。
一般将检查一个数组位置上是否是需要查找的键的操作称为探测，与追加链表不同，当发生碰撞时，
它会探测下一个索引的元素是否为空，如果为空就将新键写入其中。查询时按索引递增进行查找，若
碰到空元素即代表相同哈希值的键(键簇)遍历结束，即查找元素不存在。同时也由于空元素代表结束，
所以删除一个元素时不能简单的将其置为null(这样会使得后面的元素无法被查询到，因为哈希值是
通过哈希函数计算得出所以是固定的), 这时可以将后面的元素重新哈希化插入到数组中。 
(一组连续的非空元素具有相同的哈希值，也叫做键簇。键簇越小查询效率越高)。

这种利用空元素来作为结束的机制决定了线性探测法的数组容量必须足够大，对于不同的哈希值都要
有一个空元素作为结束符。所以在插入元素前或删除元素后都需要判断元素个数和数组容量的比值大小，
适当进行扩容或缩容操作，使得数组的使用率保持一定的大小。

《算法》书中使用2个大数组来分别存储键和值，而从IdentityHashMap的实现中可以看到它只使用了
一个数组来存储键值对，由put(key, value)方法可以看出，一对键值对是存储到2个紧邻的元素位置中。
put方法中根据哈希值查询到对应的索引，然后向后递增查找(nextKeyIndex方法也是以2追加), 使用
==判断对象引用相同时，将tab[i+1]赋值为新的键值。内存循环结束条件为item == null, 即该键为
新键时，下面有判断`s + (s << 1) > len`条件，即`size > len / 3`, 意思为元素个数超过容量的
1/3时，它就会进行扩容操作(扩大一倍)，扩容完毕后重新进行插入逻辑判断。get(key)方法也是通过
==进行键的比较，并返回下一个索引位置的键值。同HashMap一样，IdentityHashMap允许null键null值，
所以get方法返回null值可能是该键不存在，也可能它的键对应就是null值，这一点可以通过调用
containskey(key)方法进行区分。remove()方法即将被删除元素后的键全部都重新哈希并插入，直到
遇到空元素为止。

   5. EnumMap
```txt
public class EnumMap<K extends Enum<K>, V> extends AbstractMap<K,V> implements
  java.io.Serializable, Cloneable{...}
```
同EnumSet类似，EnumMap的键都属于同一个枚举类。插入空键会报空指针异常 ，允许空值。EnumMap
也是线程不安全的，可以使用Collections.synchronizedMap(new EnumMap())得到线程安全的map集合。
因为枚举类型本身的有序性(ordinal()方法), 所以EnumMap只需要定义一个存储值的数组即可，数组
的索引为枚举的索引值，数组元素值为对应的键值。可以看到，这种方式get,put方法都是常量时间性能。

以上为本人根据jdk源码整理出的java集合类笔记，下面回归到JavaCore10一书的笔记。
#### 链表 
LinkedList的ListIterator迭代器add方法返回值为void类型，即它默认即是要改变链表结构的，它在
当前的光标位置处插入新元素，add方法只依赖迭代器的位置，所以可以连续调用add方法，而remove方法
依赖于迭代器的状态，不能连续调用，调用前必须移动一次光标位置。

关于迭代的并发修改问题，书中明确指出迭代器是建立了自己独立的计数器，在方法开始的时候即检查
自己改动的操作次数是否与集合的被改动次数一致，如果不一致，说明有除迭代器以外的操作改动了集合，
这时即可以抛出并发修改异常。

注: set方法不被认为是集合的结构性修改，不计入改动次数，Collections类的许多算法都使用了这个
功能。

java中散列表用链表数组实现，每个列表被称为桶(bucket), 将散列码与桶的总数(数组长度)取余即
得到查找键所在的桶索引，当出现散列冲突(哈希碰撞)时，即将查找键与桶中对象逐一进行比较。这个
过程在前面的HashMap实现中可以看出，这里用桶的概念再次说明。

散列函数由于不需要关心排序，所以查询和操作元素的速度是最快的，如果需要排序，应使用树集。

双端队列接口为Deque,实现类有LinkedList, ArrayDeque.

优先级队列PriorityQueue调用remove方法时，删除的是当前队列中最小的元素。在实际使用中，我们
经常需要取到优先级最高的元素，此时，我们可以将1(最小元素)设置为优先级最高，次高为2,依次
类推，数值越大优先级越低，从而达到应用的目的。

### 映射
map接口中有一个getOrDefault方法可以在对应键不存在时返回默认值(对应值确实为null时即返回null)
迭代一个map集合最方便的方法为Map接口的`forEach(BiConsumer<T,U>)`方法，如
```txt
map.forEach((k,v) -> System.out.println("key=" + k + ", value=" + v));
```

更新映射的值时如果键存在我们可以先获取原值再修改，如对不同的单词计数:
`map.put(key, map.get(key) + 1);`
但如果键不存在，get方法将会抛出空指针异常。这时我们可以使用以下方法：
1. 使用getOrDefault方法，如`map.put(key, map.getOrDefault(key, 0) + 1);`
2. 先调用putIfAbsent方法，先存入不存在的键值映射，如
```txt
map.putIfAbsent(key, 0);
map.put(key, map.get(key) + 1);
```
3. 使用Map接口的merge方法，如
`map.merge(key, 1, Integer::sum);`

查看源码实现，merge(key, value, BiFunction(V,V,V))方法实现为
```txt
V newValue = (oldValue == null) ? value : remappingFunction.apply(oldValue, value);
if (newValue == null) { 
  remove(key); 
}else{
  put(key, newValue); 
}
```
从实现看，正是我们需要实现的功能: 将函数应用到旧value和新value上，得到的结果作为新的映射值，
当新value本身为null或BiFunction返回null时会进行删除操作。Map接口还提供了其他如
compute(key, BiFunction(k,V,V))方法对键和值本身进行计算得到新值的方法等，用途比较小(从应用
上说，键和值进行关联得到新值使用场景很小)。

弱散列映射
WeakHashMap周期性的检查队列，如果其中有新添加的弱引用，说明该引用已经不再被使用了，那么
WeakHashMap即会删除该键值对(即expungeStaleEntries()方法)。

LinkedHashSet和LinkedHashMap用来记住插入元素的顺序。
链表映射需要使用访问顺序而不是插入顺序进行迭代时，可以在初始化链表时指定accessOrder参数为
true.这一点对实现高速缓存的"最近最少使用"原则非常重要。LinkedHashMap中定义了
removeEldestEntry(oldestEntry)方法，它在插入元素后使用，可以自定义子类重写该方法实现该功能，
代码如下:
```txt
// 该map存储的是访问次数最多的100条数据  get,put方法调用都进行计数
Map<K,V> cache = new LinkedHashMap<>(128, 0.75F, true) {
   protected boolean removeEldestEntry(Map.Entry<K,V> eldest) {
     return size() > 100;  
   } 
}();
```

EnumSet使用位序列实现，对应的值在set集合中时，对应的位即为1.
EnumMap使用值数组实现，数组索引对应枚举键。

IdentityHashMap使用System.identityHashCode计算散列值，使用==比较对象，在对象序列化时很有用。

### 视图与包装器
如HashMap的KeySet集合不是新建一个set集合，向其中填充元素再返回，而是返回一个实现了Set接口的
类对象，这种集合即称为视图。

1. 轻量级集合包装器
如Arrays.asList(T...)方法返回的不是ArrayList,而是一个视图，不支持改变list的大小。
同理有Collections.nCopies(n, obj)可以得到一个包含了n个相同的obj对象的集合，但它实际只存储
了一个obj对象引用。其他还有Collections.singleton(obj), singletonList(T), singletonMap(K,V)
方法。
2. 子范围
可以对取出的子范围进行操作，如删除等，它会反映到全集中。
对于有序集或映射，如SortedSet, SortedMap等也有相应的方法， NavigableSet, NavigableMap则有更
进一步的处理，对边界元素的控制。
3. 不可修改的视图
Collections类有几个方法可以得到集合的不可修改视图，如Collections.unmodifiableList等，得到
的视图可以调用List接口的方法，但所有更改器方法都会抛出UnsupportedOperationException.视图
只是包装了接口而不是实际对象，所以实际类中的非接口方法将不能调用。
4. 同步视图
Collections类的synchronizedMap等方法即使用了视图(内部类)来得到线程安全的map集合。
5. 受查视图
针对泛型检查不到的情况。如以下代码:
```txt
  ArrayList<Integer> ints = new ArrayList<>();
  ArrayList raw = ints;
  raw.add("str");
  System.out.println(ints.get(0).intValue());  //这一行报错，在使用时报错，不利于debug

  List safes = Collections.checkedList(ints, Integer.class);
  safes.add("sd");   // 这一行报错，checkedList在add方法时即进行类型检查
  System.out.println(ints.get(0).intValue());
```
注意: `ArrayList<Pair<String>>的受查视图无法检测出Pair<Date>类型。CheckedCollection的
typeCheck方法是使用isInstance()方法进行判断的，它对泛型类型是无效的。`
6. 可选操作
可选操作是类库设计者综合各方便需求，如易于学习，使用方便，泛型化，通用性与算法高效性综合
考虑的结果，并不值得应用到实际的编程中。

### 算法
集合接口为不同的数据结构提供了一种统一的算法实现。比如得到一个数组，或数组列表，或链表中
的最大元素，就不需要重复编写类似的代码，只需要定义一个通用接口类型如Collection类作为方法参数，
在此基础上实现算法逻辑(如统一利用迭代器进行迭代处理)，从而达到算法通用的目的。总的来说，
算法的实现都是建立在泛型集合的基础上的。

1. 排序与混排
Collections.sort(List)方法调用的是List接口的List.sort(Comparator)方法，它是将集合转换为
数组排序完成后再通过迭代一个个复制回集合中。Arrays.sort方法使用了归并排序算法，而不是
通用的快速排序，因为归并排序算法不会比较相同的元素，所以它是更稳定的算法。

在集合的基础上实现算法，需要集合本身是可以修改的，但不一定需要可以更改大小: 即可以使用set
方法，不一定需要支持add或remove方法。
```txt
排序相关的方法有:
1. Collections.sort(List)
2. Collections.shuffle(List)
3. List.sort(Comparator)
4. Comparator.reverseOrder() 接口静态方法
5. Comparator.reversed()     接口默认方法
```
2. 二分查找
```txt
Collections.binarySearch(collection, element)
Collections.binarySearch(collection, element, comparator)
```
这2个方法定义了二分查找的算法实现。二分查找是建立在支持随机访问的有序列表基础上的，即被
比较的集合应当实现RandomAccess接口，否则它将利用迭代器进行遍历比较，这样就失去了二分查找
的优势。方法的返回值若为正数，代表搜索命中的元素索引，未找到返回的是最后搜索结束的位置
(如i),可以将新元素插入-i-1位置处(具体是使用List.add(index, el)方法，在指定的索引处插入元素
el, 该位置原有元素及以后元素全部右移，二分查找方法返回值为-(low+1), 所以可以认为是应在low
位置处插入新元素)，从而保证列表的有序性。

3. 简单算法
```txt
Collections类:
1. T min(Collection)
2. T max(Collection)
3. T min(Collection, Comparator)
4. T max(Collection, Comparator)
5. void copy(List to, List from)
6. void fill(List, value)
7. boolean addAll(Collection, T... values)
8. boolean replaceAll(List, T oldValue, T newValue)
9. int indexOfSubList(List l, List s)   第一个子列表的索引，如s为s,t, l为a,s,t,则方法返回1
10. int lastIndexOfSubList(List l, List s) 最后一个子列表的索引 
11. void swap(List, int i, int j) 交换给定索引的2个元素
12. void reverse(List) 反转列表的顺序
13. void rotate(List l, int d) 将索引i的元素移动到位置(i + d) % l.size()处。从这个计算公式
可以看出d为正数时是向右移动(backward)，d为负数时向左移动(forward)。
文档注释中提到如果只需要移动一个元素从j移动到k位置(j<k),其余元素不变，可以使用sublist,代码为
Collections.rotate(list.subList(j, k + 1), -1);
14. int frequency(Collection, Object obj)  返回集合中与obj元素相同的元素个数 
15. boolean disjoint(Collection c1, Collection c2) 如果2个集合没有共同元素，返回true
// 
Collection接口:
1. boolean removeIf(Predicate<T>)  删除满足条件的元素
//
List接口:
1. void replaceAll(UnaryOperator<T>)  对集合中所有元素进行指定操作
示例如:
wordList.removeIf(word -> word.length() < 3);
wordList.replaceAll(String::toLowerCase);
```

4. 批操作
快速取出a, b集合的交集可以这样实现:
```txt
HashSet resultSet = new HashSet(a);
resultSet.retainAll(b);
```
同样，可以利用前面提到的视图技术方便的集合进行批处理，如删除HashMap中的部分映射:
```txt
Set toBeDeletedSet = ...;
hashmap.keySet().removeAll(toBeDeletedSet);
```

5. 集合与数组的转换
数组->集合: Arrays.asList(T... values)
集合->数组: 
```txt
String[] arr = new String[collectionSize];
collection.toArray(arr);
```

6. 编写自己的算法
应当尽可能使用接口而不是具体的实现类作为方法参数来实现操作。同样的，方法的返回值也应当
尽可能是接口，这样方便以后可以修改方法的实现。如原方法是将集合中每个元素处理后的新集合
返回给调用者，后面可以修改为集合的视图(自定义匿名内部类)返回，这样返回的集合是不可修改的，
某些情况下更加安全。代码如下:
```txt
public List<JMenuItem> getAllItems(JMenuItem item) {

   return new AbstractList<>(){
      public JMenuItem get(int i) {
        return menu.getItem(i); 
      }
      public int size() {
        return menu.getItemCount();  
      }
   }; 
}
```
Collections.unmodifiableXXX内部就是使用了视图技术实现的，所以实际编程中可以使用它: 除非
参数如上面的例子一样是一个特殊对象，而不是一个常见的集合对象。

### 遗留的集合
1. Hashtable类
不应当使用它，它与HashMap有相同的接口，一般正常使用是HashMap,需要并发时使用ConcurrentHashMap.
2. 枚举
遗留集合使用Enumeration接口对集合进行遍历，有hasMoreElement和nextElement方法，与迭代器
Iterator接口功能相同。应当使用Iterator接口。
注: C++中使用迭代器作为参数十分普遍，java中一般直接使用集合作为参数，需要时从集合中获取
迭代器即可。
3. 属性映射
Properties类(继承自HashTable):
   1. 键和值都是字符串
   2. 表可以保存到一个文件中，也可以从文件中加载
   3. 使用一个默认的辅助表
4. 栈
Stack类，它继承了Vector类，从而可以使得Stack类可以调用不属于栈操作的insert和remove方法。
5. 位集
BitSet类，用于存放一个位序列，表示一系列boolean值，BitSet使用字节存储每一位，所以比Boolean
对象的ArrayList更高效。bits.get(i)获得第i位的状态，bits.set(i)将第i位设置为true, 
bits.clear(i)将第i位设置为false.
BitSet实际应用例子有查找素数的方法，先将范围内索引的位都设置为true,然后将相应的倍数设置为
false,最后留下来为true的位即为素数。

## 图形程序设计，事件处理，Swing用户界面组件(略)
## 部署java应用程序
### JAR文件

   1.1 创建jar文件
使用jdk自带的jar命令创建jar文件，如:
`jar cvf jarFileName file1 file2 ...`
jar命令类似于tar命令。jar包中除了包含类文件，还可以包含图像，声音等其他类型文件。
注: 前面的包密封性中有提到相关命令。

   1.2 清单文件
每个jar文件都包含一个用于描述归档特征的清单文件(manifest), 文件名为MANIFEST.MF, 位于
META-INF目录下。清单中可以包含多个条目，分为多个节，节之间用空行分开，第一节称为主节，
作用于整个jar包。
`jar cvfm  XXX.jar .\manifest.txt .`

   1.3 可执行jar文件
可以通过以下2种方式指定程序执行入口:
1. `jar cvfe MyProgram.jar com.xxx.MainAppClass files`
2. 清单文件中指定主类: `Main-Class: com.xxx.MainAppClass`
清单文件最后一行必须以换行符结束。
指定后使用`java -jar XXX.jar`命令启动程序。

   1.4 资源
类加载器可以记住类的位置，在同一位置下查找相关的资源文件，如声音，图像，文本等。代码为
```txt
InputStream stream = ResourceTest.class.getResourceAsStream("about.txt");
Scanner in = new Scanner(stream, "UTF-8");
```
如果没有找到该资源 ，返回null，不会抛出异常或发生I/O错误。
资源的路径使用"/"进行分隔，不用关注具体操作系统目录的分隔符。

   1.5 密封
可以在清单文件主节中增加`Sealed: true`来默认全局密封，也可以增加一节，指定想要密封的包:
```txt
Name: com/XXX/XXX/
Sealed: true
```
再使用jar命令将改动后的清单文件打入到jar包中。

### 应用首选项的存储 
1. 属性映射
即前面提到的Properties类。可以使用properties.store(outputStream, commentString)方法将属性
映射值存储到某一个具体的文件中。使用properties.load(inputStream)方法从文件中加载属性值。

可以在查找某个属性值时提供默认值，还可以在初始化属性对象时即提供一个默认的属性对象集批量
提供默认值。

常用方法如下:
```txt
java.lang.System类
   1. Properties getProperties()  获取所有系统属性
   2. String getProperty(String key) 获取允许获取的指定属性值，否则抛出安全异常
java.util.Properties类
   1. Properties(Properties default)  用一组默认值创建一个空映射 
   2. String getProperty(String key) 获取指定属性值
   3. String getProperty(String key, String defaultValue) 指定默认值的获取属性值
   4. Object setProperty(String key, String value)  设置一个属性值
   5. void load(InputStream in)  从输入流中加载属性映射
   6. void store(outputStream, String header)  将映射保存到一个输出流，header为标题
```
2. 首选项API
使用Properties类存储配置信息存在2大问题:
  1. 有些操作系统没有主目录的概念，所以无法确定统一的配置文件存储位置。
  2. 关于配置文件命名没有规范(程序员自己在程序中指定)，所以用户安装多个应用程序时会产生命名
冲突。
java.util.prefs.Preferences类解决了这个问题。在windows系统中它使用注册表存储配置信息，Linux
系统中使用文件系统存储配置信息。Preferences存储结构是树状结构，每个树节点的路径类似于包名，
节点中是一个单独的键值对表。不同的用户可以有不同的树，另外还有一颗系统树(从前面这些树特性
来看，Preferences与windows的注册中心拥有一样的特性, 实际上Preferences是个抽象类，它的具体
实现类即WindowsPreferences, 就是基于Windows系统的注册表实现的)。

可以从用户树或系统树的根节点开始访问树，再根据根节点和节点路径得到具体的节点对象:
```txt
Preferences root = Preferences.userRoot();
// Preferences root = Preferences.systemRoot();
Preferences node = root.node("/com/xxx/myapp");
```
当节点路径为某个类的包名时，可以根据该类的对象获取该节点:
```txt
Preferences node = Preferences.userNodeForPackage(class);
// Preferences node = Preferences.systemNodeForPackage(class);
```
获取属性值必须指定一个默认值，因为可能该属性不存在，或程序与存储库断开链接等原因，具体方法
有get(String key, String defaultValue), getInt(key, int df), getDouble(key, double df), 
getByteArray(key, byte[] df)等，相应的设置属性值的方法为put(String key, String value), 
putDouble(key, val)等方法。node.keys()方法可以返回该节点的所有键。

另外当需要迁移属性配置时，可以使用Preferences类的导入导出功能，
方法为:
```txt
void exportSubtree(outputStream);  // 导出一颗子树 xml格式
void exportNode(OutputStream);  // 导出一个节点
void importPreferences(inputStream); // 导入数据
```
总之，Preferences类为修改Windows系统注册表配置项提供了一个便利的工具，是一个方便多应用协作
的系统级配置工具。

### 服务加载器
看完书，ServiceLoader类的源码和网上查找相关资料才发现这是一个非常重要的设计思想。
调用服务分2方，服务调用者和服务提供者，由服务提供者(或服务实现者)制定调用的规则时，这是
我们熟知的API(Application Programming Interface: 应用编程接口)。但有些情况下需要服务调用
者指定调用的规则，如eclipse, IntelliJ的插件体系，这种情况叫SPI(Service Provider Interface:
服务提供接口), 即调用者给实现者指定了需要实现的接口规则。

jdk通过ServiceLoader类实现了SPI思想，ServiceLoader类本身是一个泛型类，可以指定具体的接口类型，
它定义了SPI的具体操作步骤: 即SPI本身实现的机制，具体的接口还是要程序员自己定义。

如ServiceLoader类指定了服务提供者的jar包的META-INF/services目录下需要一个UTF-8编码的文本
文件，文件名为接口的全限定名，文件内容是该接口的实现类。通过ServiceLoader.load(service.class)
方法初始化ServiceLoader类，然后就可以调用ServiceLoader类的迭代器遍历文本文件中的实现类了，
在遍历时进行处理得到需要的实现类。

SPI的具体应用有DriverManager的驱动实现，通过mysql-connector-java.jar包的META-INF/services
目录下既可以发现这样一个配置文件, 文件名为java.sql.Driver，即同一个驱动接口类，其中定义了
mysql的驱动实现类(oracle的驱动实现jar包没有使用spi，所以它还是需要使用Class.forName方法
加载相应的驱动)。

eclipse或idea的插件体系是SPI思想的很好体现，作为服务调用方它们指定插件需要的文件和配置信息，
插件开发者按要求开发完集成到开发平台时，开发平台不用知道插件的具体实现，按"接口"进行统一加载
处理即可。

其他的SPI应用有spring的自动扫描注解，自定义作用域scope, 自定义标签等。
可以说只要是服务调用者制定了实现接口时，都属于SPI的应用。

### applet
java的applet都知道已经过时了，但可以作为技术发展历史了解一下:它是通过html页面上一个特殊
的applet标签来加载对应的jar包和class类, 同时需要指定applet的位置。applet标签可以给java类
传递参数，还可以处理图像和音频。
### Java Web Start

## 并发
线程和进程的区别:
不同进程有自己的一整套变量，而线程是共享数据。共享数据使得线程间通信比进程间通信更容易。
同时，创建、销毁一个线程开销比进程小。

1. 什么是线程

书中弹球的例子说明了多线程一个最常用的使用场景: 用户对程序处理的中断请求操作。
即点击关闭按钮需要能够中断弹球的循环移动处理。
推荐建立线程的方法:
1. 使用λ表达式实现Runnable接口。
2. 使用该Runnable接口初始化一个线程Thread thread = new Thread(runnable);
3. 启动线程thread.start()(调用run()方法只是执行一个方法，没有启动线程);

不推荐使用继承Thread类的方式启动线程，因为通过继承的方式比实现接口的方式耦合性更强。
弹球例子中每点击一次start按钮都会生成一个新球和新线程，而主线程就可以监听到关闭按钮的事件，
调用System.exit(0)方法从而实现中断操作。

2. 中断线程
当线程执行完run()方法并返回或者出现未捕获异常的时候，线程将终止。没有可以主动强制终止一个
线程的方法，只有一个interrupt()方法用来请求中断线程，它会设置一个中断标志位，我们可以通过
检查这个标志位来决定线程是否需要停止运行。

在阻塞的线程(调用了wait(), join()或sleep()方法的线程)中调用interrupt()方法会抛出中断异常
从而结束阻塞状态，并且它会清空中断状态。从这里可以看出，我们可以使用interrupt()方法提前结束
阻塞的线程。线程本身决定如何响应中断请求，我们可以结束该线程，也可以忽略该中断请求
(如前面说的不可中断线程)。

发生上述的interrupted异常时不应当不做任何处理，可以调用Thread.currentThread.interrupt()
方法将被清空的中断状态重新定义出来， 或者可以直接将该异常抛给调用者处理。
同时，如果线程run()方法处理逻辑中如果使用了sleep()或其他阻塞方法，由于它们在调用时如果被
中断会抛出异常，所以此时就不需要再去检查中断标志位了，直接捕捉该异常即可。

Thread.interrupted()方法将返回线程的中断状态，同时它会清除该中断状态，停止中断！(即中断
线程连续2次调用interrupted()方法，第一次返回true,第二次将返回false.)而thread.isInterrupted()
是一个实例方法，仅返回中断状态，不会改变中断状态。

下面是一个简单的通过中断来终止线程的例子:
```txt
public class InterruptTest {
    public static void main(String[] args) throws InterruptedException{

        Runnable r = () -> {

          while(!Thread.currentThread().isInterrupted()) {
              try {
                  System.out.println("sss");
                  Thread.sleep(10000);
              } catch (InterruptedException e) {
                  // 抛出异常的同时清除了中断状态，所以这里需要手动设置中断状态, 
                  // 以退出循环，结束run方法和thread线程
                  Thread.currentThread().interrupt();
              }
          }
        };

        Thread thread = new Thread(r);
        thread.start();

        Thread.sleep(2000);
        thread.interrupt();
    }
}
```

3. 线程状态
线程有6种状态，可以调用getState()方法确定线程的当前状态。

  1. New 新创建状态
使用new操作符新建一个线程时，此时线程还没有开始运行，在做一些线程的基础工作。

  2. Runnable 可运行状态
一旦调用start方法，线程即处于可运行状态。一个可运行状态的线程可能在运行中，也可能不在运行中，
这取决于系统时间分配。即运行中的线程也是可运行状态。

桌面和服务器操作系统都使用抢占式调度系统，即系统给每一个可运行线程一个时间片执行任务，时间片
用完时系统停止运行该线程，再根据线程优先级确定下一个运行的线程。但在手机等小型设备上是使用
协作式调度系统，只有当一个线程调用yield()方法，或者被阻塞，等待时，线程才会停止运行。

  3. Blocked，Waiting, Timed waiting 被阻塞和等待, 计时等待状态
这三种状态统称为非活动状态。有以下几种情况线程会进入非活动状态:
     1. 一个线程试图获取一个对象锁(不是Concurrent包中的锁)而该锁被其他线程持有时，该线程
进入阻塞状态，直到该锁被释放并且该线程得到该锁时才会变为非阻塞状态。
     2. 当一个线程等待另一个线程通知调度器某个条件时，该线程是等待状态。如Object.wait()，
Thread.join()方法，或是等待concurrent包中的Lock或Condition时。阻塞状态与等待状态是不同的。
     3. 某些方法有一个计时参数，如Thread.sleep(),Object.wait(), Thread.join()等方法，此时
线程进入计时等待状态。

当一个线程阻塞或等待时，另一个线程被调整为运行状态。而一个线程重新激活时(如获得锁或计时结束),
调度器检查线程优先级，如果该线程优先级更高，就将它替换当前运行中的某个线程。

  4. Terminated 终止状态
前面提到过，一个线程终止有2种情况:
     1. run()方法正常结束而终止线程。
     2. run()方法运行过程中出现了未捕获的异常而终止线程。

注: thread.stop()方法已经过时，不应当使用它终止线程。
thread.join()方法注释为`wait for this thread to die`, 即当前线程进入等待状态，等待join()
方法的调用线程终止。以下为join方法测试:
```txt
public class JoinTest {
    public static void main(String[] args) {

        Runnable r = () -> {
            try {
                Thread.sleep(3000);
                System.out.println("t end");
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        };
        Thread t = new Thread(r);
        t.start();

        try {
            t.join();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println("main end");
    }
}
输出为
t end
main end
注释掉join方法时输出为
main end 
t end
```

4. 线程属性

   1. 线程优先级
一个线程的优先级默认是继承了其父线程的优先级，可以调用setPriority()方法设置，优先级从1到10,
最低为1,最高为10，普通优先级为5。

线程的优先级是高度依赖于具体的操作系统的，java的优先级转换到具体的操作系统时该优先级可能
会发生变化，所以不应当依赖于优先级来进行编程，它只是提供了参考，但没有确定性。

Thread.yield()方法指示当前线程愿意让出自己的时间片，调度器可以选择一个优先级相同或更高的
线程运行。文档注释说该方法是线程向调度器发起的通知，调度器可以忽略它。yield方法很少有适当
的场景需要使用，它可以用于测试bug，或一些并发控制的包(如java.util.concurrent.locks)中。

   2. 守护线程
守护线程也叫后台线程，可以通过thread.setDaemon(true)将线程转换为守护线程。它的唯一用途就是
为其他线程提供服务，如进行计时操作等。当程序中只剩下守护线程时，程序就会结束。守护线程不
应当访问固有资源，如文件、数据库等，因为它们是不稳定的，访问失败时会导致守护线程中断，无法
提供应有的服务。

   3. 未捕获异常处理器
thread.run()方法不支持抛出受查异常，它只能因为未捕获异常终止。我们可以调用
setUncaughtExceptionHandler(UncaughtExceptionHandler eh)方法自定义一个未捕获异常处理器来
处理这个异常(只需要实现Thread.UncaughtExceptionHandler接口即可)，还可以使用
setDefaultUncaughtExceptionHandler(UncaughtExceptionHandler eh)来设置该线程的默认处理器。

文档注释中说，一个线程的未捕获异常处理器是先查找用户指定的处理器，如果为空，就寻找线程
所属的线程组的处理器，如果线程组(包括更高层级的父类线程组)都没有指定处理器时，最后才会调用
线程默认的处理器。所以如果想要自定义处理器，直接使用setUncaughtExceptionHandler(eh)方法即可，
如可以在自定义处理器中将异常日志写入到特定的日志文件中。

当用户没有指定处理器时，默认的处理器就是线程组对象threadGroup, 它实现了UncaughtExceptionHandler
接口。我们常见到的程序异常错误信息即为调用了线程组中的uncaughtException(Thread, Throwable)
方法打印出来的，其中定义了上面说的处理器寻找顺序。(其中异常如果是一个ThreadDeath对象，栈轨迹
是被禁用的，ThreadDeath是由stop方法产生的，而stop方法已经过时)

5. 同步
   1. 竞争条件
当多个线程同时对同一数据进行修改时，就会出现竞争条件(race condition).

书中转账的例子里，100个账户建立了100个线程，它们同时进行转账操作，转入对象是随机的，每次
转账后打印所有账户的总余额。经测试发现，该金额是在不断变化的，而不是固定不变的，这就是典型
的并发问题。

   2. 竞争条件详解
出现这个问题的原因在于修改余额语句如`accounts[to] += amount;`编译后的字节码指令是由多个指令
构成的，如装载，计算，存储等。在并发的情况下，执行这一串指令的线程会在任意一个中间节点处
被中断，从而导致数据错误。
   
   3. 锁对象
我们需要保证线程失去控制前完成业务逻辑处理，可以通过加锁来达到这一目的。使用synchronized
关键字或者ReentranLock类(Lock接口实现类)来进行加锁操作。

仔细分析上面的转账例子，100个线程并发的调用相同bank对象的transfer方法，同一时间对银行内的
账户进行操作导致该bank对象的数据出现了问题。我们给该银行对象加上一把锁ReentranLock,
不同线程对同一个bank实例进行操作时，首先进行reenLock.lock()获取锁操作，获取失败时该线程
进入阻塞状态，直到获取到锁为止。相当于当前操作线程失去控制时，其他线程无法操作相关数据，
这样就保证了同一个bank实例转账操作的线程安全性。

不同bank实例的锁不会相互影响。

此外，锁是可重入的，一个线程可以重复获得已经得到的锁，即对一个锁进行重复加锁操作。
锁内部会有一个被锁次数的计数值，lock()计数值加1, unlock()计数值减一，当该计数值大于0时，
说明该线程仍然持有该锁。对于同一个bank实例，它有自己的一个锁， 同时有多个需要线程安全的
操作方法，这时，使用该锁保护的代码可以调用另一个使用相同锁的方法。

一般是在try{}finally{}的finally语句块中进行释放锁操作，这样可以避免程序抛出异常时未释放锁
导致其他线程永远阻塞的情况。但是，如果真的抛出异常，代码中的对象状态是不完整的，实际使用中
应当注意这种情况，避免抛出异常。

   4. 条件对象
被锁保护的代码区域称为临界区，即一次只能允许一个线程操作的区域。当线程进入临界区时，有时候
会发现不满足执行某些操作的条件，但它又持有了该锁，无法让其他线程进行操作。如银行转账时余额
不足的情况。此时就是条件对象(condition variable)发挥作用的时候。

对于一个锁可以有一个或多个条件对象，Lock接口的newCondition()方法可以生成一个与对应锁关联的
条件对象(Condition与Lock一样是一个接口).如出现上述的余额不足情况时，调用condition.await()
方法，当前线程进入阻塞状态，并且释放锁，让其他线程对该账户进行转账操作。

与等待获得锁的线程不同，当调用条件对象await()方法的线程可以获取锁时不会解除阻塞状态，它需要
等待另一个线程调用同一个条件对象上的signalAll方法时才能被唤醒。当调用signalAll方法时，所有
因这一条件等待的线程将被重新激活，当它们获得锁时将会从被阻塞的地方地方继续执行，此时一般
需要再次检测测试条件，因为signalAll方法只是给出可能满足条件的可能性。所以await()方法一般
都是写在while循环中，循环进行条件测试。

如果所有的线程都调用了await()方法，没有线程调用signalAll()方法，那么就进入了死锁状态，程序
被挂起无法执行。在上面的转账例子中，应在转账操作完成后调用signalAll()方法，给所有余额不足的
线程检查最新余额是否满足条件的机会。

需要注意的是signalAll()方法并不会立即激活一个等待的线程，它只是解除了线程的阻塞状态，该线程
还需要通过竞争获得可运行权限。

signal()方法是随机解除等待集合中某一个线程的阻塞状态，它效率更高，但存在风险。因为如果
那个被唤醒的线程仍然不满足条件而再次阻塞，又没有其他线程调用signal或signalAll方法，程序就
进入了死锁状态。

总之，锁可以管理试图进入临界区的线程，锁的条件对象可以管理已经进入临界区但不满足条件无法
运行的线程。

   5. synchronized关键字 
大多数情况下，并不需要某个具体的锁对象控制程序，可以使用synchronized关键字。

这是因为每一个java对象都默认拥有一个内部锁。当某个对象的方法使用synchronized关键字修饰时，
相当于该方法使用了这个内部锁对方法的内容进行了加锁保护，一个线程想要执行该对象方法时，需要
首先得到这个对象的内部锁。

对象内部锁只有一个条件对象，即使用object.wait()方法在不满足条件时阻塞线程，使用notify()或
notifyAll()方法唤醒阻塞的线程可继续运行。它们等价于Condition的await(), signal(), signalAll()
方法。

类的静态方法也可以声明为synchronized同步方法, 此时一个线程调用该方法时获取到的是XXX.class
类对象的内部锁，这个时候其他线程既不能调用该方法，也不能调用该类其他同步的静态方法，因为整个
类对象都被锁住了。

使用对象内部锁的synchronized同步方法虽然非常简洁方便，但同时它也无法提供一些显式锁提供的功能,
如中断一个试图获取锁的线程，定义试图获取锁的超时时间，以及对象内部锁只有一个条件在某些情况
下不适用。

需要并发控制时的最佳实践为:
1. 首先在java.util.concurrent包中寻找需要的功能，使用已经实现了的类和机制来实现自己的需求。
2. 其次如果synchronized关键字可以满足需求，优先使用synchronized关键字。
3. 最后，如果需要用到Lock/Condition提供的特有功能时，才使用Lock/Condition.

   6. 同步阻塞
同步阻塞即为synchronized语法块，它是除了同步方法以外线程获得锁的另一种方法。
具体语法为`synchronized(obj) {...}`,其中obj可以是一个普通的Object对象(new Object())，它
需要的仅仅是每一个Object对象都有的内部锁而已。

使用一个对象的内部锁封装自己的同步代码的行为称为"客户端锁定", 但这种方法需要保证被封装的代码
中该对象调用的方法都使用内部锁进行同步处理，所以这种加锁操作风险很大，不推荐使用。

   7. 监视器概念
java对象内部锁来源于监视器的概念。监视器要求每个监视器类只能包含私有域，每个监视器类
对象有一个锁，使用这个锁对所有方法进行加锁，这个锁可以有任意多个条件。java采用它的概念设计
了对象内部锁，但没有完全遵从它的要求。

注: Object类的wait, notify, notifyAll方法在当前线程未拥有对象内部锁时调用这些方法就会抛出一个
名为IllegalMonitorStateException异常，从这里也可以看出这个概念。

   8. volatile域

volatile关键字提供了对于不同线程间通信的机制(java内存模型的happen-before原则也有关于
volatile的行为的定义)。一个读取volatile域的线程可以"看"到所有其他线程在写入该域前的内存内容，
比如其他域的值等(可见性)。

volatile单词本意是反复无常的，不稳定的。当一个线程发现操作的变量是volatile变量，知道该变量是
"可变"的，操作完后将结果写入内存，其他线程会直接从内存中(而不是缓存)取得最新操作结果(意为
该变量会发生变化，无法使用缓存中的值)。相比加锁和同步处理的"重量级"工具，volatile更轻量，
适合少数实例域的并发控制。

java内存模型是jvm对计算机实际物理内存的虚拟化处理，所以需要先了解实际物理内存机制。
由于CPU速度太快，读取内存太慢，所以中间使用多级缓存和寄存器进行内容暂存提高速度，其中速度
依次为寄存器register, 缓存cash, 内存RAM递减, 容量大小则是递增。(因为CPU在短时间内会再次访问
已经访问过的内容，所以使用缓存的机制可以提高存取速度)

1. 操作原子性
原子性就是要么不做，要么就全部做完。
如计算机执行a = a + 1时它会分成四个原子性操作:

   1. 从内存中读取a的值放入缓存
   2. CPU从缓存中取出a的值加1
   3. 将计算结果写回到缓存中
   4. 将计算结果写回到内存中

在具体执行这四个操作时，CPU可能会在执行完某一步骤以后被中断去执行别的操作，这就是并发操作
原子性问题的根本来源: 计算机内存的缓存机制。

2. 操作有序性
由于CPU与缓存通信速度快，所以当前后语句不存在依赖关系时，指令重排序不影响程序的语义时，
计算机就会进行指令重排序以提高程序运行效率。 

并发情况下指令重排序可能会造成程序错误，而由于指令重排引发的错误在实际中是很难被发现的。

3. 操作可见性
如a线程的操作如果是基于另外b线程的操作结果时，a线程不一定能看到b线程的操作结果，这就是操作
的可见性问题。归根到底还是线程之间的通信问题，a线程的操作结果需要及时通知到b线程。

所有并发的问题都是由这三个原因引起的，原子性，有序性，可见性，java并发也不例外。

volatile关键字保证了线程的可见性和一定的有序性，但并不能保证原子性。如DCL(double check lock)
单例模式的双重检查锁就使用了volatile关键字来保证一个线程构造完成的实例对象可以被其他线程
看见。

JMM的happen-before原则提供了程序运行的有序性，它规定了如果2个操作不能从happen-before原则中
推导得出运行顺序，那么就无法保证它们的操作顺序，可以被随意指令重排(包括编译器重排和处理器重排)。
在JMM中，一个操作的执行结果如果对另一个操作可见，那么它们之间一定存在happen-before关系。

1. 单线程中，前面的操作happen-before后面的操作。
这一规则只适用于后面的操作对前面的操作有依赖的情况，如果重排不影响结果，那么就可以指令重排。
在多线程中，指令重排会产生错误，所以它无法适用于多线程环境。

2. 同一个锁的解锁操作happen-before加锁的操作。
这一规则保证了锁可以被正确的释放和获取，保证了锁功能的正常使用。相当于定义了必须先解锁，
才能再加锁。

3. 对volatile变量的写操作happen-before对该变量的读操作。
该规则保证了volatile变量的可见性，通过这样的规定才能取到其他线程的操作结果。

4. 传递性：如果a happen-before b, b happen-before c, 则a happen-before c.

5. 线程相关的原则: 线程启动先于其他方法，线程interrupt方法调用先于线程收到该中断请求，
线程所有操作先于线程的终止检测(如a线程调用b.join(),b线程在join()方法返回前的操作
会在线程结束前操作完成，a线程可以观测到相关操作结果)，对象的初始化先于它的finalize()方法。

总之，如果操作a happen-before b, 那么操作a在内存上的操作对b是可见的，或者说a的操作会影响
到b操作.

   9. final变量
除了使用锁和volatile关键字，使用final修饰的域也是可以被安全并发访问的。final域的值不可变，
所有线程需要等到赋值结束后才能看到它的值。

   10. 原子性
volatile只能保证对实例域的赋值操作的原子性，稍微复杂一点的操作可以使用
java.util.concurrent.atomic包中的类，更进一步的原子性只能使用锁或同步来完成。

atom包中如AtomicInteger类有incrementAndGet方法，它包含的3个操作获取值，增加1,得到结果是一个
原子性操作，不会被中断。AtomicInteger还提供了compareAndSet(expectedValue, newValue)方法可以
将当前原子类的值与期望值进行比较，相等的时候才会更新为新值。

如以下代码寻找不同线程观察得到的最大值:
```txt
do{
  oldValue = largest.get();  
  newValue = Math.max(oldValue,  observed);
}while(!largest.compareAndSet(oldValue, newValue));
```
当a线程执行该段代码时，largest值与oldValue相等，compareAndSet方法更新成功，返回true,跳出
循环，程序结束。当b线程并发的执行时，由于compareAndSet方法的原子性，等a线程操作结束时，
b线程调用compareAndSet方法发现largest最新值(已被a改变)与oldValue值不等，所以largest值不会
更新，并且循环条件为true,继续执行循环体，再次进行比较，此时将b线程的观察值与a线程得到的最
大值进行比较，从而达到获取多个线程中最大观察值的目的。

compareAndSet方法提供了比较后赋值操作的原子性，而上面的代码提供了按需更新值操作的原子性，
它通过获取原子变量的值实现了线程间的通信。jdk8更进一步，将以上代码封装为一个新的方法
updateAndGet(IntUnaryOperator)，只需要传入如何更新值的λ表达式就可以得到这样一个原子性的
更新方法。其中IntUnaryOperator只接收一个参数，可以将上面例子使用表达式
`x -> Math.max(x, observed);`实现。

AtomicInteger还提供了一个类似的方法
accumulateAndGet(int x, IntBinaryOperator), 其中IntBinaryOperator可以接收2个参数，第一个参数
为当前原子整数的值，第二个参数为方法参数x。这时上面的例子可以直接调用方法
`largest.accumulateAndGet(observed, Math::max);`。

此外，getAndUpdate和getAndAccumulate方法可以返回原子类的原值。
类似的，其他原子类如AtomicIntegerArray, AtomicLong, AtomicLongArray, AtomicReference,
AtomicReferenceArray等也都提供了这些原子性的更新方法。 

但是如果有大量线程更新同一个原子值，调用以上更新方法时大部分线程需要进行大量的循环，性能
非常低。

















<hr />
<img src="http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20190512_1.jpg" class="full-image" />
