---
title: Java3_Core10Note
categories: Java
tags:
  - Java
  - C++

abbrlink: 65ea4e77
updated: 2021-03-25 15:18:02
date: 2019-09-17 16:26:16
---
Java, Char with UTF-16, C++, 数组，  
<!-- more -->

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
单例模式的双重检查锁就使用了volatile关键字来屏蔽指令重排。

DCL代码:
```txt
public class Singleton{

  private Singleton(){}  

  private static Singleton instance;

  public static Singleton getInstance() {

     if (instance == null) {
       synchronized(Singleton.class) {
          if(instance == null) {
             instance = new Singleton();  
          } 
       } 
     }
     return instance;
  }
}
```
第一个判空条件避免了对象已经初始化后不必要的加锁性能消耗，第2个判空条件保证第一个获取到锁
的线程初始化完成对象并释放锁后，那些通过了第一个判空条件被阻塞的线程进入临界区后再次进行
判断时会发现instance已经有值了，所以不会再次初始化对象。

但是由于`instance = new Singleton();`语句本身并不是原子性操作。它分为3步:
1. 分配内存区域
2. 在内存中构造对象
3. 将对象引用指向该内存区域
其中，指令重排会打乱2,3的顺序，即先给引用赋值，再进行对象构造。这样当线程a返回这样一个
未构造好的对象时，线程b在判断第一个条件时发现`instance != null`,从而b线程就拿到这个"半成品"
的单例对象，进而在后续使用中报错。

解决方法:
1. 禁止指令重排, 即通过使用volatile关键字实现。不过volatile也有性能消耗。
2. 利用类加载时自带的初始化锁。

每一个java类或接口都有一个初始化锁与之对应，在初始化类的时候线程会获取到这个初始化锁进行
初始化操作，并且其他线程会至少获取一次该锁来确保该类完成了初始化操作。也就是说，类初始化
过程只能由一个线程完成，其他线程都被阻塞。将上面的初始化对象过程加入到类初始化的过程中，
即使发生指令重排，其他线程也无法拿到该对象(或者说其他线程看不见这个初始化的过程)，
从而避免了问题产生。具体代码如下:
```txt
public class Singleton{

  private Singleton(){}  

  public static Singleton getInstance() {
      return SingletonHolder.instance;
  }

  private static class SingletonHolder{
     public static Singleton instance = new Singleton();  
  }
}
```
类只有被调用的时候才会初始化，所以这个方案也是懒加载的。
注: 枚举本身是线程安全的，所以可以直接使用枚举获得一个单例。


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
需要注意的是atomic包中的类内部使用了volatile关键字修饰其具体代表的值，可以这些原子类是同时
满足了原子性(cas)和可见性的(volatile)的。

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
非常低。如果我们不需要中间的处理结果，只需要多个线程最后的总结果，可以使用atomic包中的
LongAdder或DoubleAdder类，其中add(long)方法对每一个线程会添加一个加数，可以通过sum()方法
得到截至到目前的多线程的累加和。increment()方法即为自增1.
如果存在大量竞争的情况，就应当考虑使用LongAdder或DoubleAdder, 而不是AtomicLong与AtomicDouble.

LongAccumulator类可以对任意形式的累加进行操作，初始化该对象时传入具体累加的函数表达式。
需要注意的是，该累加操作应当满足交换律和结合律，因为线程被累加的顺序是无法确定的。

注: 可以发现AtomicInteger.compareAndSet(oldValue, newValue)的实现是调用了一个Unsafe类的
本地方法compareAndSwapInt(object, offset, expectedValue, newValue).这样通过本地方法
(JNI: java native interface)使用C语言就可以利用操作系统硬件本身支持的并发特性。

而上面的循环样板代码即为Java中的CAS(compare and swap)原理，使得读取-修改-写入整个操作变为
原子操作。而整个JUC(java util concurrent)包都是建立在CAS原理上的。

synchronized关键字通过阻塞其他线程的方式属于悲观锁，而CAS则属于乐观锁，先执行操作，当发生
冲突的时候再终止操作，即非阻塞的方式，这样的方式要比同步锁性能更高。

单核CPU实现CAS很方便，多核CPU较复杂: 需要使用总线锁或者缓存锁来实现。
CAS有3个缺点: 
1. 只能有一个共享变量。
这是由其实现方式决定的。可以将多个共享变量整合到一个变量中解决这个问题。
2. 循环时间长
可以通过限制CAS自旋次数解决这个问题。
3. ABA问题
如果在获取值和进行比较过程中，该值经历了`A->B->A`的变化过程，由于开始和结束值是一样的，
所以比较时会认为值没有变化并更新，这样就造成了错误更新。可以通过给对象值打上版本号，记录
变化的过程来解决这个问题，AtomicStampedReference类的compareAndSet()方法即是使用这种机制。

注: 
1. CAS自旋锁
以上线程使用循环来试图获得锁而不是阻塞线程的方式称为乐观锁或自旋锁。又称为CAS自旋锁。在
递归调用中如果程序试图获取相同的锁，这时线程会一直在等待自己释放该锁，从而造成死锁的情况。
所以递归程序不应当在持有自旋锁时调用自己，也不能在递归调用时试图获取相同的锁。

可以使用以下代码自定义一个简单的CAS自旋锁:
```txt
package cn.taoBlog;

import java.util.concurrent.atomic.AtomicReference;

/**
 * SpinLock
 *
 * @author wutaotao
 * @version 2019/8/20 14:57
 */
public class SpinLock{
    private AtomicReference<Thread> threadOwner = new AtomicReference<Thread>();

    public void lock() {
        Thread current = Thread.currentThread();
        while (!threadOwner.compareAndSet(null, current)) {
            System.out.println(current + " is selfSpinning!");
        }
    }
    public void unlock() {
        System.out.println(Thread.currentThread() + " release lock!");
        Thread current = Thread.currentThread();
        threadOwner.compareAndSet(current, null);
    }

    public static void main(String[] args) throws InterruptedException{

        System.out.println("main thread start");
        SpinLock casLock = new SpinLock();
        Runnable a = () -> {
            System.out.println(Thread.currentThread() + " start");
            casLock.lock();
            // got lock and go on
            System.out.println(Thread.currentThread() + " got lock!");
            try {
                Thread.sleep(1);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }finally {
                casLock.unlock();
            }
            System.out.println(Thread.currentThread() + " over");
        };
        Thread aThread = new Thread(a);
        Thread bThread = new Thread(a);
        aThread.start();
        bThread.start();
        aThread.join();
        bThread.join();

        System.out.println("main thread over");
    }
}
输出为:
main thread start
Thread[Thread-0,5,main] start
Thread[Thread-0,5,main] got lock!
Thread[Thread-1,5,main] start
Thread[Thread-1,5,main] is selfSpinning!
...
Thread[Thread-1,5,main] is selfSpinning!
Thread[Thread-0,5,main] release lock!
Thread[Thread-0,5,main] over
Thread[Thread-1,5,main] got lock!
Thread[Thread-1,5,main] release lock!
Thread[Thread-1,5,main] over
main thread over
```
可以看到Thread-1一直在自旋等待线程Thread-0释放锁。

但是这个cas自旋锁存在2个问题:
   1. 这个是锁是不可重入的，即已经获得锁的线程无法再次获得该锁(重入锁属于锁的应用层面，
一个对象实例中不同的方法使用同一个锁进行同步处理时即会面对该问题)。这个问题可以使用前面提到过
的计数器实现。加锁时计数值加1, 释放锁时计数值减一，当计数值为0时即真正释放该锁。

   2. 这个锁是不公平锁，等待时间最长的线程并不能优先获得锁。这个问题类似于cas的ABA问题解决
方案一样，给每一个线程一个递增的排队号码，每当一个线程试图获取锁时，就给它一个排队号。锁
有一个服务号，每当该锁被释放时，服务号加一。这样，当线程的排队号与服务号相等时，该线程就
获得该锁，因为排队号递增，所以保证了公平性。
```txt
package com.test;

import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicReference;

/**
 * TicketLock
 *
 * @author wutaotao
 * @version 2019/8/21 22:17
 */
public class TicketLock {

    private AtomicInteger serviceNum = new AtomicInteger();
    private AtomicInteger ticketNum = new AtomicInteger();

    public int lock() {
        Thread current = Thread.currentThread();
        int currentTicketNum = ticketNum.getAndIncrement();
        while (!(currentTicketNum == serviceNum.get())) {
            System.out.println(current + " is selfSpinning!");
        }
        return currentTicketNum;
    }
    public void unlock(int ticketnum) {
        System.out.println(Thread.currentThread() + " release lock!");
        Thread current = Thread.currentThread();
        serviceNum.compareAndSet(ticketnum, ticketnum + 1);
    }

    public static void main(String[] args) throws InterruptedException{

        System.out.println("main thread start");
        TicketLock ticketLock = new TicketLock();
        Runnable a = () -> {
            System.out.println(Thread.currentThread() + " start");
            int tickNum = ticketLock.lock();
            // got lock and go on
            System.out.println(Thread.currentThread() + " got lock!");
            try {
                Thread.sleep(1);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }finally {
                ticketLock.unlock(tickNum);
            }
            System.out.println(Thread.currentThread() + " over");
        };
        Thread aThread = new Thread(a);
        Thread bThread = new Thread(a);
        aThread.start();
        bThread.start();
        aThread.join();
        bThread.join();

        System.out.println("main thread over");
    }
}
```
以上代码中lock()方法返回获得锁的线程分配到的排队号，而解锁时需要校验服务号与排队号是否相等，
所以解锁就需要前面获得锁的线程的排队号进行解锁——正如main方法中所作的一样。但是这样明显
将锁的一部分"职责"内容交由应用处理，而且该排队号如果在中间发生变化，就无法正确解锁，造成
其他线程永远阻塞的状态。(tickNum变量在其他线程调用lock()方法时是不断累加的，无法解锁用)

所以我们需要一个变量来保存每个线程获得的排队号，解锁时直接取该变量即可，这就是ThreadLocal
类的用途！它内部使用一个内部类ThreadLocalMap集合来保存每个线程保存的变量值，键是弱引用。
```txt
package cn.taoBlog;

import java.util.concurrent.atomic.AtomicInteger;

/**
 * TicketLock
 *
 * @author wutaotao
 * @version 2019/8/22 14:27
 */
public class TicketLock {

    private AtomicInteger serviceNum = new AtomicInteger();
    private AtomicInteger ticketNum = new AtomicInteger();
    private ThreadLocal<Integer> ticketHolder = new ThreadLocal<>();

    public void lock() {
        int ticknum = ticketNum.getAndIncrement();
        ticketHolder.set(ticknum);
        while(ticknum != serviceNum.get()) {
            System.out.println(Thread.currentThread() + " is spining");
        }
    }
    public void unlock() {
        System.out.println(Thread.currentThread() + "release lock");
        Integer ticket = ticketHolder.get();
        serviceNum.compareAndSet(ticket, ticket + 1);
    }
    public static void main(String[] args) throws InterruptedException{

        System.out.println("main thread start");
        TicketLock lock = new TicketLock();
        Runnable a = () -> {
            System.out.println(Thread.currentThread() + " start");
            lock.lock();
            // got lock and go on
            System.out.println(Thread.currentThread() + " got lock!");
            try {
                Thread.sleep(1);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }finally {
                lock.unlock();
            }
            System.out.println(Thread.currentThread() + " over");
        };
        Thread aThread = new Thread(a);
        Thread bThread = new Thread(a);
        aThread.start();
        bThread.start();
        aThread.join();
        bThread.join();

        System.out.println("main thread over");
    }
}
```

注: Atom包中的FieldUpdater类:
针对某个类中的字段，如它是int, long或普通的引用类型，如果也想对它实现类似于AtomicInteger,
AtomicLong, AtomicReference一样的原子性操作，就可以使用AtomicIntegerFieldUpdater, 
AtomicLongFieldUpdater, AtomicReferenceFieldUpdater类来实现相同的功能。它的原理是利用
反射得到指定字段的内存地址，即offset值，再调用Unsafe包中的相应方法(如compareAndSet)直接对
相应的内存操作来达到原子性操作的目的，从这几个类的实现也可以看出Unsafe包的强大之处。
实际使用:
   1. 初始化得到更新器，如
`AtomicReferenceFieldUpdater<ClassType> updater = AtomicReferenceFieldUpdater
   .newUpdater(ClassType.class, FieldType.class, String fieldName);`
   2. 使用更新器调用相应的原子性方法，如
`updater.compareAndSet(obj, expectedValue, newValue);`

实际使用中，比如有一个大的链表，其中的节点需要原子性的get-set, 如果节点类型都定义为
原子类型，会消耗很多内存，这时候可以定义一个静态更新器来实现原子操作，而节点仍未普通类型。

不同层次的自旋锁代码:
```txt
package cn.taoBlog;

import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * TAS
 *
 * @author wutaotao
 * @version 2019/8/26 10:05
 */
public class TAS {
    AtomicBoolean state = new AtomicBoolean(false);
    void lock() {
        while(state.getAndSet(true)) {}
    }
    void unlock() {
        // this step invalidate other memories' cache
        state.set(false);
    }
}
class TTAS {
    AtomicBoolean state = new AtomicBoolean(false);
    void lock() {
        long delay = 1000;
        while (true) {
           while (state.get()) {}
           // lock is free now, many threads contend to get it
           if (!state.getAndSet(true)) {
               return;
           }
           // if get lock failed, delayed to try getting it again, reduce contention
            try {
                Thread.sleep( (long)(Math.random() * 10 + 1) * delay);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            if (delay < 10000) {
                delay = delay * 2;
            }
        }
    }
}
// similar to ticket lock, but it use array instead of lock's serviceNum
class AndersonQueueLock{
   // one thread one bit cause cache invalidation unnecessary, we can use [false, null, null, false...]
    // to make each thread use only one cache line.
   private volatile  boolean[] flags = {false, false, false, false};
   AtomicInteger next = new AtomicInteger(0);
   ThreadLocal<Integer> threadTicket;

   public void lock() {
       int curTicket = next.getAndIncrement();
       threadTicket.set(curTicket);
       while(!flags[curTicket % flags.length]) {}
       // after got lock, make current slot false to reuse it, because of the % upward,
       flags[curTicket % flags.length] = false;
   }
   public void unlock() {
       // next thread free to go
       flags[threadTicket.get() + 1 % flags.length] = true;
   }
}
// CLH Queue Lock
class ClHLock {

    private static class QNode{
        // 默认是未获得锁状态
        private volatile boolean locked = false;
    }
    // 节点链表中的尾节点始终指向最后一个试图获得锁的节点
    AtomicReference<QNode> tail = new AtomicReference<>(new QNode());
    // 每个线程生成自己的节点，作为获得锁的标志
    ThreadLocal<QNode> myNode = ThreadLocal.withInitial(() -> new QNode());
    // 每个线程保存自己的前序节点，在线程本地变量上自旋
    ThreadLocal<QNode> myPred = new ThreadLocal<>();

    public void lock() {
        QNode qNode = myNode.get();
        // 试图获得锁时即设置为加锁状态
        qNode.locked = true;
        // 获取tail的前序节点(旧值)
        QNode pre = tail.getAndSet(qNode);
        // 拷贝前序节点到本地
        myPred.set(pre);
        // 前一个线程未释放锁时，本线程自旋
        while (pre.locked){}
    }
    public void unlock() {
       QNode qNode = myNode.get();
       // 释放锁
       qNode.locked = false;
       // recycle predecessor's node
       // 得到锁的前序节点实际上是整个链表的头节点(first node) 
       // 通过将当前节点设置为前序节点，相当于删除了旧的前序节点
       myNode.set(myPred.get());
    }
}
```
CLH在常用的SMP(symmetric multi-processor)处理器架构上运行良好，多个处理器共享一个内存, 每个
CPU访问的内存是相同的的(但访问相同的内存地址会造成CPU资源的浪费)。而NUMA
(non-uniform memory architecture)处理器架构则是每个CPU都有自己的内存，对自己的内存访问速度远高于
其他CPU的内存，所以对不同内存地址的访问速度是不一致的。

CLH在本地内存上自旋非常快，在远程内存上自旋就很慢。所以CLH锁不适用于NUMA系统架构。
这时可以使用MCSLock.

2. 缓存一致性

缓存本身的一致性指的是其基本定律(任意时刻，任意级别缓存中的缓存段的内容，等同于它对应
内存中的内容)和回写定律(当所有的脏段被回写后，任意级别缓存中的缓存段的内容，等同于它对应
内存中的内容)。但是在多核处理器计算机中，每个处理器都有自己的缓存组，不同处理器对相同内存
的操作就需要通知到其他处理器的缓存组，实现不同缓存组之间的一致性。

一般是通过"窥探"(snooping)协议定义缓存组之间通信, 即所有内存传输都发生在一条共享的总线上。
具体一般使用MESI(Modified, Exclusive, Shared, Invalid)协议来保证不同缓存组之间的一致性，遵守
该协议的处理器系统可以说是完全一致的。上面四个单词代表缓存段的不同状态:

  1. Modified代表已修改，属于脏段。
  2. Exclusive代表独占状态。
  3. Shared代表内存的拷贝，只读不可写的状态。
  4. Invalid代表缓存段失效状态，

当缓存需要写入内存时，需要发送获得独占权的请求到总线上，通知其他缓存，让它们对应的缓存变为
失效状态。当有其他处理器需要写入该内存时，当前处理器需要从已修改或独占状态变为共享状态，
同时将修改内容写入到内存中。

多核处理器实现写入数据操作的原子性时，可以使用总线加锁或缓存加锁两种方法，总线加锁使得其他
处理器无法访问内存，开销较大所以不推荐。缓存加锁就是利用了缓存的一致性原理，处理器修改自己
对应于该内存地址的缓存组内容，其他处理器无法同时修改来达到原子性操作的目的。

3. "What every programmer should know about memory" note

注: ROM(read-only memory)是只读内存，只能读取，不能修改或删除储存的资料，资料不会因电源
关闭而消失。而RAM(random-access memory)可以用任何顺序访问资料，停电后资料即消失，如内存就是
RAM.

  1. 略
  2. Commodity Hardware Today
一般商用计算机的主板上分2部分，北桥和南桥。CPU通过FSB(front side bus)总线进行相互通信。
北桥中包含着内存控制器，而控制器类型决定了RAM的类型。而南桥管理着如网卡，USB等外围设备的
接口，所以北桥需要访问南桥以访问这些设备。

这个架构中，CPU之间的通信请求，所有访问RAM的请求，CPU访问外围设备的请求都需要经过北桥的处理。
该架构设计的性能瓶颈:

访问RAM: 早期的时候，南北桥上所有的通信都需要经过CPU,这降低了系统性能，所以出现了
DMA(direct memory access)设备来解决它，它们可以在北桥上直接访问RAM, 不过这样也与
CPU的处理信号形成了竞争关系。
北桥到RAM的总线: 早期的系统北桥只有一条总线链接到所有的RAM芯片上，现在则扩展了更多的总线
(或称为channel)提高带宽来解决它。在有限的带宽下，合理分配内存的访问权限对于性能的提高非常
重要。除了并发访问内存会影响性能外，访问内存的模式本身对于性能影响也很大。

还可以让北桥部分自己不包含内存控制器，北桥链接多个外部的内存控制器，每个控制器有自己的RAM,
这样内存总线就有多条，而不是只有一条，从而也提高了总带宽。通过访问不同的内存库减少了并发
访问的耗时。

还可以将内存控制器整合进CPU当中，将每个内存RAM直接与各个CPU相连，这就是NUMA系统架构， 每个
处理器通过整合内存控制器都有本地内存可以使用。NUMA系统架构中所有的处理器除了本地内存外
仍然需要访问其他的内存，所以有了访问速度不一致的问题，即NUMA的non-uniform。处理器访问远程内存
的时间消耗称为NUMA因子。有的机器将CPU分成多个节点，节点内部的NUMA因子很小，节点间因子值很大。

2.1 RAM类型
静态RAM速度块，但价格高，动态RAM速度慢，但是便宜。DRAM只由一个晶体管和电容组成，结构简单，
但存在很多问题，如每次读取数据后需要时间充电(这也称为刷新，因为读操作会导致电容器"漏电")，需要放大器
放大信号并判断状态(0或1)等。

2.2 DRAM的访问
地址线的数量对DRAM的处理性能影响很大，一般是复用地址来提高性能。 
一般主要的DRAM是SDRAM(synchronous DRAM)，它的后代是DDR(Double Data Rate SDRAM).
DDR模块的时间耗时主要由以下几部分组成: CL(CAS latency), `t_RCD`(RAS TO CAS Latency), 
`t_RP`(RAS precharge), `t_RAS`(active to precharge delay), command rate.
刷新的时间间隔是由内存控制器控制，DRAM模块用队列存储每个请求的计数值以延迟执行。

SDR(Single Data Rate SDRAM)能以内存总线的传输速度相同的速度输出内存中的内容。
DDR1相比SDR而言,DDR1可以在同一个周期内传输双倍的数据，它并没有改变时钟频率, 在信号的上升和
下降沿都可以传输数据。DDR1让2个DRAM cell取相同的列值，读取时并发的访问它们。

DDR2则在DDR1的基础上将频率翻了一倍。它是通过让IO buffer以更快的速度运行，可以在每个时钟周期
中传输4位而不是DDR1的2位(SDR是1位)。DDR3中外部总线运行的更快，它传输的是8位的I/O buffer。

DDR模块越来越高的总线频率导致创建并发的数据总线越来越难以实现(前面通过并发访问实现了传输
加倍的数据)，而且菊花链式链接的DDR模块之间传递信号会发生扭曲，所以DDR2规定每个总线只能有
2个DDR模块，DDR3则规定每个总线只能有一个模块。这样一条总线(一个DDR模块)有240个针脚，一个
北桥最多容纳2条总线(针脚限制)。这也意味着一个主板只能容纳4个DDR2或DDR3模块。

FB-DRAM(Fully Buffered)采用串行buffer总线来解决这个问题，FB-DRAM只有69个针脚。一条总线可以
容纳8个FB-DRAM模块，北桥可以容纳6条总线。

总之，CPU速度比RAM快很多，DRAM模块支持很高的数据传输速度。访问不连续的内存区域需要重新充电
和新的RAS信号，硬件和软件可以通过提前读取数据来利用这段延迟时间，这样也减少了后面的读写操作
竞争。

2.3 其他主内存使用者
除了CPU，还有其他如网卡，或大容量存储控制器也需要访问主内存(即DMA).这样它们与CPU在总线上
产生了竞争。可以通过技术手段和程序接口减少竞争，提高性能。

3. CPU caches
由于程序代码的空间和时间的局部性，所以使得CPU使用SRAM作为高速缓存的设计是具有实际意义的。
空间的局部性体现为代码中出现循环时相同的代码被不断的重复执行，时间的局部性体现为循环中
内存位置很远的方法调用在时间上被快速多次调用。

3.1 CPU caches in the big picture
经验证明将数据缓存和指令缓存分开存储具有很多好处。
内核和多线程的区别:
内核是独立的，每个内核都拥有几乎相同的单独的硬件资源, 它们在没有竞争时是完全独立工作的；
而多线程是共享资源进行操作。

距离CPU的远近关系分为1级缓存，2级缓存，3级缓存等。在多处理器，多核，多线程的计算机中，
每个处理器之间不共享任何缓存，单个处理器内部的多核之间共享高级别缓存，每个内核都有自己
单独的1级缓存。

3.2 cache operation at high level
缓存不可能存储主内存中的所有内容，所以它存储的内容有一个标签tag来标记内容在内存中的位置，
由于缓存基于空间局部性原理，并且标签本身也占有一定空间，所以逐个存储单个单词是没有效率
(需要新的CAS或RAS信号)并且违背原理的，所以缓存内容是按行读写的，即缓存段(cash line)。
根据访问缓存的级别不同，读写数据的性能也有非常大的差距(只用到L1,L2级别缓存和需要访问主内存的
程序差别)，所以提高程序对于缓存的利用率对于性能的提升有时是非常巨大的。

3.3 CPU cache implementation details
  3.3.1 Associativity
如果每个缓存行可以存储任意内存地址的内容，这样设计的缓存称为fully associative cache, 但是
寻址时CPU要搜索的条目(entry)就太多了，每个缓存行都需要一个比较器比较请求地址和每个缓存段的
地址，无论是提高比较器的速度或者复用比较器都无法有效提高性能。所以我们可以设计减少比较器，
即让一个缓存段只能存储一个对应的内存地址中的值，但由于空间和时间的局部性，某些缓存会被经常
用到，而某些缓存则一直是空置状态。这样即浪费了资源，也使得热点资源造成竞争。

所以合理的方案是使用Set-associative cache.将需要请求的内存地址分散到每一个tag和data中，每次
请求读写时地址经过转换后，每个tag或data都有机会作为存储目标内容的小单元。这种设计使得缓存
总容量增加时，只需要增加tag和data的列数，而不需要增加行数(对应着缓存本身的associativity, 
同时每一行对应一个比较器), 从而使得缓存的增加不再受限于比较器的数量。

在缓存行大小，缓存总容量固定的情况下，缓存associativity值越高，缓存未命中(cash miss)的次数
就越少。从数据图标中可以看出，从直连(no associativity)到associativity=2的性能提升是最大的，
有时甚至和缓存总容量翻倍的效果是一样的！不过当associativity再增加时，性能提升效果就一般了。
  3.3.2 Measurements of cache effects
略
  3.3.3 write behavior 
如前面说过的直写和回写模式。
  3.3.4 multi-processor support
MESI协议，保证多核处理器间的缓存一致性。
多线程访问
  3.3.5 other details 
virtual memory address and physical memory address

3.4 Instruction Cache
不只是执行指令时用到的数据被缓存，指令本身也会被缓存(这里指的是编译器编译后生成的代码指令)。
  3.4.1 self modifying code
should avoid this.

3.5 Cache Miss Factors
  3.5.1 Cache and memory bandwidth 
  3.5.2 Critical Word Load
缓存行一般有64或128字节，从主内存传输到缓存的效率是一次传输64位，这意味着加载一行缓存段需要
8或16次传输，为了程序继续执行，内存控制器可以将"关键字"优先上传，这样程序可以在缓存还未处于
连续状态前就开始执行, i.e., Critical word first & early restart.
  3.5.3 Cache Placement
  3.5.4 FSB Influence

4. Virtual Memory
  4.1 Simplest Address Translation 


## springboot scheduled cron expression
秒 分 时 日 月 周 (年)
0-59 0-59 0-23 1-31 1-12 1-7 1970-2099
每天凌晨执行一次:  
`0 0 0 */1 * ?`
或
`0 0 0 * * ?`

每周日凌晨执行一次:  
`0 0 0 ? * SUN`

每月1号凌晨执行一次:  
`0 0 0 1 */1 ?`
或
`0 0 0 1 * ?`

```txt
"0 0 12 * * ?" 每天中午12点触发 
"0 15 10 ? * *" 每天上午10:15触发 
"0 15 10 * * ?" 每天上午10:15触发 
"0 15 10 * * ? *" 每天上午10:15触发 
"0 15 10 * * ? 2005" 2005年的每天上午10:15触发 
"0 * 14 * * ?" 在每天下午2点到下午2:59期间的每1分钟触发 
"0 0/5 14 * * ?" 在每天下午2点到下午2:55期间的每5分钟触发 
"0 0/5 14,18 * * ?" 在每天下午2点到2:55期间和下午6点到6:55期间的每5分钟触发 
"0 0-5 14 * * ?" 在每天下午2点到下午2:05期间的每1分钟触发 
"0 10,44 14 ? 3 WED" 每年三月的星期三的下午2:10和2:44触发 
"0 15 10 ? * MON-FRI" 周一至周五的上午10:15触发 
"0 15 10 15 * ?" 每月15日上午10:15触发 
"0 15 10 L * ?" 每月最后一日的上午10:15触发 
"0 15 10 ? * 6L" 每月的最后一个星期五上午10:15触发 
"0 15 10 ? * 6L 2002-2005" 2002年至2005年的每月的最后一个星期五上午10:15触发
"0 15 10 ? * 6#3" 每月的第三个星期五上午10:15触发 
每隔5秒执行一次：*/5 * * * * ?
每隔1分钟执行一次：0 */1 * * * ?
每天23点执行一次：0 0 23 * * ?
每天凌晨1点执行一次：0 0 1 * * ?
每月1号凌晨1点执行一次：0 0 1 1 * ?
每月最后一天23点执行一次：0 0 23 L * ?
每周星期天凌晨1点实行一次：0 0 1 ? * L
```
注: application.yml文件中可以使用${propertyName}相互引用,如
```txt
url: http://xxx.xx.xx.xx:8000
jsp: ${url}/test/index.html
```

## move forward to jdk 11
jdk9  modules    minimize runtime size
 var
jdk 10
   List,Set,Map.copyOf
   Collectors.toUnmodifiableList/Map/Set  for stream
jdk 11
   Http Client   同步异步都有
      HttpClient
      HttpRequest
      HttpResponse
      WebSocket

lambda expression support var   used for adding annotation in lambda expression

launch single java source code file  
  no need to compile to class file first, it will execute the main function

using code above the class Name with Shebang  #!
   #!$JAVA_HOME/bin/java --source 11
make the source file executable and ./Factorial 4 will get the result! just like python and js...  
   to be tested with importing other classes.

nullInputStream
nullOutputStream
nullReader()
nullWriter()
  equals to linux /dev/null  throw away the output of a stream

Optional isEmpty()


String methods:
isBlank()
Stream lines()    return the lines of multi-line streams
String repeat(int)
String strip()
String stripLeading()
String stripTrailing()
    similar function with trim(), strip difines whitespaces differently with trim() methods

Predicate not(Predicate)
    lines.stream().filter(s -> !s.isBlank())
       change to
    lines.stream().filter(Predicate.not(String::isBlank))

lambda leftovers   _ for unused parameters

raw string literals   jdk12
```txt
   `` i a /sd/sd`isdfds`df ``
```

switch support type test
    String s;
    switch(obj) {
       case Integer i: s = String.format("%d", i); break;
       case Double d: s = String.format("%f", d); break;
       case String s: s = String.format("%s", i); break;
       default:  d = obj.toString(); 
    }
switch expression   switch语句有返回值
   int num = switch(day) {
      case mon, fri,sun -> 6;
      case tue -> 7;
      case thu, sat -> 8;
      case wed -> 9;
      default -> throw new IllegalStateException("wrong date value with " + day);
   }



@Deprecated 
  since: the beginning time of deprecating,  
  forRemoval=true:  the next version it will probably gone

java9  
 fast initializtion:   unmodifiable
   Map<String, String> map = Map.of("key", "value");
 modifiable  in constructor
   Map<String, String> map = new HashMap<>();
   {
     map.put("key", "value");
   }
  
jdk 5
  type witness
  EasyMock class
    T anyObj();
  Test class
   void foo(List<String> list)
   void foo(Set<String> set)
foo(EasyMock.anyObj()) compilation error

foo((List<String>)EasyMock.anyObj())     gets compilation warning about unsafe cast
type witness
foo(EasyMock.<List<String>>anyObj())   tell the compiler the T type

jdk 6  faster
jdk 7  
 syntax suger
 invokeDynamic,  forkJoin, 
   switch on string    suger, using hash to compare, low level implementation is complicated
  diamond operator
    List<String> list = new Arraylist<>();
  number underscores  
     int i = 1_000_000

  multiple catches  
     try{...}catch(IOException | SQLException e) {
       log.error("my error", e)
     }

  auto closeable   try with resource
    try(InputStream in = new FileInputStream("aa.txt")) {...}
    autoClose will execute the close method in the right places and suppress the 
      close method function, output the business exception

   java.nio.file
       List<String> lines = Files.readAllLines(Paths.get("path", "to", "a.txt"));
      file watcher, symbolic links, file locks, copy...

jdk 8  2014
     
    lambda....
    java.util.Base64
      String text = "Base64 in java8";
      Strng encoded = Base64.getEncoder().encodeToString(text.getBytes(StandardCharsets.UTF_8));
      String decoded = Base64.getDecoder().decode(encoded, StandardCharsets.UTF_8);
  
    time api       
       immutable
       A time is time , date is date, not mixed like java.util.Date
      
      LocalDate, LocalTime, LocalDateTime   -> local, no time zone

     OffsetDateTime, OffsetTime   -> Time with an offset from greenwich 
     ZonedDateTime  ->  LocalDateTime with a time zone
      
      Duration, Period  -> Time span
      Instant  -> Timestamp
      Formatting -> Easy and thread-safe formatting

      example:
        LocalDateTime now = LocalDateTime.now();
        String otherDay = now.withDayOfMonth(1).atZone(ZoneId.of("Europe/Paris")).plus(Duration.ofDays(5))
        .format(DateTimeFormatter.ISO_ZONEID_DATE_TIME);

   lambda
      function with no name
      classic:     list.forEach(e -> System.out.println(e));
      typed:     list.forEach((String e) -> System.out.println(e));   // specify the parameter type
      closure:     
         String greeting = "hello";  // no need to write final, implicitly referred
         list.forEach(e -> System.out.println(greeting + e));   // greeting is final in lambda

   interface default methods    
       default implementation for most implementors
   interface static methods
       replace the need for factory helper

   // the magic here is new Object(){...} anonymous class create a new type(not Object) 
   // for the next stream forEach tuple.
    Map<Long, Person> map = Map.of(
       1L, new Person(12, "wtt"),
       2L, new Person(13, "cll")
    );
    map.entrySet().stream().map(entry -> new Object() {
         long id = entry.getKey();
         String name= entry.getValue().getName();
      }).forEach(tuple -> {
          System.out.println(tuple.id + ":" + tuple.name);
        });
    // here we get the long type indexId and  String type name

    var list = map.entrySet().stream().map(entry -> new Object() {
         long id = entry.getKey();
         String name= entry.getValue().getName();
      }).collect(Collectors.toList());
      System.out.println(list.get(0).name)
      // we can use var type to write the unknown type of new Object 

   method reference
     it is the simplification of lambda expression, 
    my own example:
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
   difference between lambda and method reference
String s = null;
IntSupplier r = () -> s.length();   // run good,  lambda will not execute when created
IntSupplier r = s::length;   // error! method reference need the instance existed and not null


jdk 9
 httpClient  
 immutable collections
  xml and nio debugging  with unified JVM logging

   try with resource no need to put the declaration in try block any more, like
      ByteArrayOutputStream in = new ByteArrayOutputStream();
      try(in) {...}

    jdk7   
    old reflection need to check and set the accessible, very slow
       MethodHandle class, powerful tool for reflection
       Field field = Test.class.getDeclaredField("title");
       MethodHandle setter = MethodHandles.lookup().unreflectSetter(field);
       setter.invokeExact(this, "Sir");

  jdk9  add findVarHanle()
     MethodHandles.lookup().findVarHandle()

  modules
        module path can be directories and main function can be class name not main function name
    java  --module-path  app/target/classes:lib/target/classes -m pros.app/pro.App
     maven-jar-plugin   auto module name change module name 
     module-info.java    exports  and requires, opens for reflection

  java 10  2018.3
     var 
      var var = 1;
      var var = foo();  // this is bad, because it's ambiguous
      ConcurrentHashMap<String, String> map = new ConcurrentHashMap<>();
       simplifies to 
      var map = new ConcurrentHashMap<String, String>();
      // map now is a ConcurrentHashMap type, not a Map type-interface
     //  using  var with lambda parameters can make it be able to be annotated

  java 11 2018.9 
     a single file program
     java.sh  #!$Java_home/bin/java --source 11

    http://www.lamgdafaq.org
    http://files.zeroturnaround.com/pdf/RebelLabs-Java-9-modules-cheat-sheet.pdf
    http://openjdk.java.net/projects/amber/LVTIstyle.html
    https://javaspecialists.teachable.com/courses

    Modern Java in Action
   Mastering Lambdas/Generics
   Java 9 Modularity

   http://blog.tremblay.pro

EasyMock for Java
  write junit tests easily 

good luck2

## hibernate4 Could not obtain transaction-synchronized Session for current thread
this bug appears when I try to config dual datasource to spring+hibernate project, 
now is 21:36, all the web page search result said I need to add @transactional 
annotation, but there is another project which I did not add it but it also works good, too.
After all, I add spring @Transactional annotation to commonDaoImpl, and add 
`<tx:annotation-driven transaction-manager="transactionManagerComm" />` to make the 
transactional annotation work, so it works ok now. The error is clear, but the spring
and hibernate config terrifies me, after all these years, it almost becomes a ghost, 
that means, all the technical debt will remain to be paid back if you are still using it,
hahahaha.

 2021-03-25 15:13:44 added: 
 today I found the above error's real problem, and it shows the cause why the same
 configuration works in one project and not working in another one, as I found out later, 
 I copy the aop pointCut execution expression is wrong, and add transactional annotation 
 bypass the wrongness, so finally just use default transaction is fine, no need to use
 transactional in purpose.


<hr />
<img src="http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20190917_1.jpg" class="full-image" />

