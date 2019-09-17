---
title: Java2_Core10Note
categories: Java
tags:
  - Java
  - C++
image: 'http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20190330_1.jpg'
updated: 2019-09-17 16:30:55
date: 2019-09-17 14:45:48
abbrlink:
---
description
<!-- more -->

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


<hr />
<img src="http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20190330_1.jpg" class="full-image" />
