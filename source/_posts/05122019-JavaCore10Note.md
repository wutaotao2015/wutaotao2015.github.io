---
title: JavaCore10Note
categories: Java
tags:
  - Java
  - Char with UTF-16
  - C++
image: 'http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20190512_1.jpg'
updated: 2019-06-02 22:23:44
date: 2019-05-12 20:10:28
abbrlink:
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
(经测试情况2,父类实现了泛型的Comparable接口，子类就不能实现自己的泛型了，编译器报错，因为
泛型是可擦除的。这样在对子类数组进行排序后，虽然实现了排序，但其中的元素都自动
向上转型为父类类型了...不过比较不同的子对象以进行排序，这样也不算太大副作用)

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
 private int ss(int x, int y) {
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
java内部类对象有一个指向外部类对象的隐式指针，可以访问其全部状态。static内部类没有该指针。

```txt
public class TimerTest{
    public static void main(String[] args) {

        TimerClock timerClock = new TimerClock(1000, false);
        timerClock.start();

        // 当内部类为public时，可以在外界使用outerObject.new InnerClass(xxx)创建内部类对象
        // 使用OuterClass.InnerClass来引用内部类对象
        // 内部类为private时，无法在外界创建对象
        // TimerClock.TimePrinter timePrinter = timerClock.new TimePrinter();

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
            if (TimerClock.this.beep) Toolkit.getDefaultToolkit().beep();
        }
    }

}

```
编译器会自动修改内部类的构造器，将外部类对象的引用传递进去，因此在实例化内部类时，它自动
就获得了外部类对象的引用。

因为静态变量和方法属于类的范围，它们会在具体的对象初始化前被加载，而非静态内部类的初始化
依托于外部类对象，所以非静态内部类中不能定义静态变量和方法，因为加载它们时需要的内部类
还未生成。


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
  static boolean access$000(com.test.TimerClock);
}
```







### 代理

## 异常，断言和日志

<hr />
<img src="http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20190512_1.jpg" class="full-image" />
