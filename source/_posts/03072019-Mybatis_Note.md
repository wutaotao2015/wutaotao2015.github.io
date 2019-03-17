---
title: Mybatis学习笔记
categories: Mybatis
tags:
  - Mybatis
  - Log4J
  - Log4J2
  - SLF4J
image: 'http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20190307_1.jpg'
abbrlink: 7fd48667
updated: 2019-03-17 23:09:55
date: 2019-03-07 15:59:42
---
Mybatis note, Log4J, Log4J2, SLF4J,  
<!-- more -->
## 基本mybatis配置
1. pom.xml
指明需要的依赖包，mybatis和mysql-connector
```txt
<dependency>
    <groupId>org.mybatis</groupId>
    <artifactId>mybatis</artifactId>
    <version>3.3.0</version>
</dependency>
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>5.1.38</version>
</dependency>
```
2. mybatis-config.xml
mybatis的配置，如实体类所在包的别名，JDBC配置，Mapper.xml文件路径。
```txt
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration
  PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
  "http://mybatis.org/dtd/mybatis-3-config.dtd">

<configuration>

  <!--指定mybatis日志输出工具为log4J,因为Mybatis默认会按以下顺序查找不同的日志实现工具，
  slf4j -> apache common logging -> log4j2 -> log4j -> JDK logging
  所以在配置中进行指定可以保证日志的正常记录-->
  <settings>
    <setting name="logImpl" value="LOG4J"/>
  </settings>

  <typeAliases>
    <package name="com.model"/>  <!--这里的别名是用于mapper.xml中如resultType可以不写全名-->
  </typeAliases>

  <environments default="development"> <!--JDBC配置-->
    <environment id="development">
      <transactionManager type="JDBC"/>
      <dataSource type="POOLED">
        <property name="driver" value="com.mysql.jdbc.Driver"/>
        <property name="url" value="jdbc:mysql://localhost:3306/mybatis"/>
        <property name="username" value="root"/>
        <property name="password" value="123456"/>
      </dataSource>
    </environment>
  </environments>

  <mappers>
    <mapper resource="mapper/mybatisMapper.xml"/>  <!--指定sql语句和映射文件的路径-->
  </mappers>

</configuration>
```
3. 实体类和Mapper.xml文件
```txt
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
  PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
  "http://mybatis.org/dtd/mybatis-3-mapper.dtd">

<!--当前Mapper.xml的命名空间,它与sql语句的id联合起来可以被sqlSession定位识别调用,
这与对象的全限定名调用非常相似，也就为mybatis的注解实现提供了基础-->
<mapper namespace="mapper.mybatisMapper">  

  <select id="selectAll" resultType="Country">
    select * from Country
  </select>

</mapper>
```

4. 编写单元测试运行mybatis
mybatis核心是sqlSessionFactory,SqlSession类，可以在测试类中使用它们来手工进行数据查询操作，
```txt
    SqlSessionFactory sqlSessionFactory;
    try {
        Reader reader = Resources.getResourceAsReader("mybatis-config.xml");
        sqlSessionFactory = new SqlSessionFactoryBuilder().build(reader);
        reader.close();
    } catch (IOException e) {
        e.printStackTrace();
    }
    
    SqlSession sqlSession = sqlSessionFactory.openSession();
    try {
        List<Country> countryList = sqlSession.selectList("selectAll");
        for (Country country : countryList) {
            System.out.println(country);
        }
    } finally {
        sqlSession.close();
    }
```
注：作用域和生命周期

|对象|作用域|实例个数推荐|说明|
|-|-|-|-|
|sqlSessionFactoryBuilder|方法作用域|一个就够|用来创建一个或多个sqlSessionFactory,用完即删|
|sqlSessionFactory|应用作用域|单例模式|一旦创建应当在应用运行期间一直存在|
|sqlSession|请求或方法作用域|单线程|线程不安全，如请求时生成，返回响应后关闭它|
|Mapper接口实例|方法作用域|单线程|由sqlSession创建，但调用完相应数据操作接口后即可关闭|

5. SLF4J
SLF4J是一个日志处理抽象层，不提供具体的日志实现，它可以与具体的日志工具进行整合，如Log4J,
Log4J2, LogBack, JDK日志等。适用于工具库中使用，如MQ，redis等,当这些工具被整合进具体的项目
中时，可以使用slf4j与不同具体实现的整合包进行**静态绑定**日志,从而避免了多套日志系统的麻烦。

工具类中只需要使用slf4j-api即可(发布时只发布这个包，工具开发中可以自行整合)
```txt
<dependency>
    <groupId>org.slf4j</groupId>
    <artifactId>slf4j-api</artifactId>
    <version>1.7.25</version>
</dependency>
```
slf4j整合其他日志实现依赖为：
   1. log4j:
    ```txt
    <dependency>
        <groupId>org.slf4j</groupId>
        <artifactId>slf4j-log4j12</artifactId>
        <version>1.7.25</version>
    </dependency>
    <dependency>
        <groupId>log4j</groupId>
        <artifactId>log4j</artifactId>
        <version>1.2.17</version>
    </dependency>
    ```
   2. logback
   ```txt
    <dependency>
        <groupId>ch.qos.logback</groupId>
        <artifactId>logback-classic</artifactId>
        <version>${logback.version}</version>
    </dependency>
   ```
由于slf4j没有自己的实现，如果想要在老项目更新slf4j的日志实现，如从commons logging转换到
logback，需要进行jar包处理。
这种情况可以使用jcl-over-slf4j.jar桥接器来进行日志的重定向。日志流转过程如下：
> java common logging -> jcl-over-slf.jar -> slf4j -> slf4j-log4j12-version.jar -> 
> log4j.jar -> 输出日志

值得注意的是这种重定向有死循环的危险，如本来就是log4j的实现，又添加了桥接器log4j-over-slf4j,
那么就是log4j->slf4j->log4j,造成死循环，此时要么去掉桥接器，要么改变slf4j的实现方式，如
logback.
> slf4j提供的适配库和桥接库
适配库：
slf4j-log4j12：使用log4j-1.2作为日志输出服务
slf4j-jdk14：使用java.util.logging作为日志输出服务
slf4j-jcl：使用JCL作为日志输出服务
slf4j-simple：日志输出至System.err
slf4j-nop：不输出日志
log4j-slf4j-impl：使用log4j2作为日志输出服务
// logback天然与slf4j适配，不需要额外引入适配库（毕竟是一个作者写的）
桥接库：
log4j-over-slf4j：将使用log4j api输出的日志桥接至slf4j
jcl-over-slf4j：将使用JCL api输出的日志桥接至slf4j
jul-to-slf4j：将使用java.util.logging输出的日志桥接至slf4j
log4j-to-slf4j：将使用log4j2输出的日志桥接至slf4j

java中使用slf4j记录日志，slf4j有自己独特的占位符参数，可以减少string连接的消耗，而且它不
需要像log4j那样用`logger.isDebugEnabled()`来判断日志开启的级别再来输出日志，slf4j会自动
判断当前日志级别确定是否生成该条日志。
> import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
private static final Logger LOGGER = LoggerFactory.getLogger(XXX.class);
LOGGER.info("{}", object);

6. Log4J 基本使用

   1. 依赖
   使用slf4j用以上依赖配置即可，不使用slf4j时仅需要引入
```txt
<dependency>
    <groupId>log4j</groupId>
    <artifactId>log4j</artifactId>
    <version>1.2.17</version>
</dependency>
```

  2. 在src/main/resources下新建配置文件log4j.properties：

      1. 配置根logger
      指定日志级别和日志输出到什么地方去。
      > log4j.rootLogger=ERROR, stdout  #输出ERROR级别，输出到配置的stdout中

      level建议设置的有ERROR,WARN,INFO,DEBUG
      appenderName可以同时指定多个不同的值

      2. 配置日志输出地Appender
      > log4j.appender.stdout=org.apache.log4j.ConsoleAppender
    log4j.appender.stdout.layout=org.apache.log4j.PatternLayout
    log4j.appender.stdout.layout.ConversionPattern=%5p [%t] - %m%n

      第一行为appender的全限定名, 一般有如下几种：
      > org.apache.log4j.ConsoleAppender    # 控制台 
      > org.apache.log4j.FileAppender      # 文件
      > org.apache.log4j.DailyRollingFileAppender # 每天产生一个日志文件
      > org.apache.log4j.RollingFileAppender # 日志文件到达一定大小就记录到一个新的日志文件中
      > org.apache.log4j.WriteAppender   # 日志信息以流格式发送到任意地方

      第二行为appender的布局，有以下几种：
      > org.apache.log4j.HTMLLayout    # 以HTML格式布局,生成html标签，适合输出到html文件中观看 
      > org.apache.log4j.PatternLayout    # 灵活布局 
      > org.apache.log4j.SimpleLayout    # 日志级别和日志信息 %l %m%n
      > org.apache.log4j.TTCCLayout    # 线程，级别，所在方法，信息  %t %l %M %m%n

      第三行为appender的日志格式化控制，常用的有
      > %m 或%msg  message 代码中指定输出的日志信息，如logger.info("log message printed.")
      > %p priority 日志信息级别
      > %t 或tn threadname 产生该日志的线程名
      > %T 或tid threadId 该日志线程ID
      > %d date 产生日志的时间点 可以在后面指定格式，如%d{yyyy MM dd HH:mm:ss,SSS}
      > %l location 产生日志的位置 如Test.main(Test.java:10) 该项性能损耗很大，应避免开启
      > %c class 所在类的全名
      > %r relative time  产生日志时间点距离应用启动经过的时间毫秒数
      > %n 换行符 windows:rn  unix:n
      > %M method 所在方法
      > %xEx exception 异常信息

  3. 在java中使用
    >  import org.apache.log4j.Logger;
    private static final Logger LOGGER = Logger.getLogger(XXX.class);
    LOGGER.info(object);

7. Log4J2 
apache官方宣布Log4J已经停止支持，现在需要转向新的Log4J2日志框架。同时宣称它提供了logback
的一些改进，并解决了logback的一些问题。
   1. 依赖
    ```txt
    <!--slf4j与log4j2整合-->
    <dependency>
        <groupId>org.apache.logging.log4j</groupId>
        <artifactId>log4j-slf4j-impl</artifactId>
        <version>2.11.2</version>
    </dependency>

    <!--log4j2 jar-->
    <dependency>
        <groupId>org.apache.logging.log4j</groupId>
        <artifactId>log4j-api</artifactId>
        <version>2.11.2</version>
    </dependency>
    <dependency>
        <groupId>org.apache.logging.log4j</groupId>
        <artifactId>log4j-core</artifactId>
        <version>2.11.2</version>
    </dependency>
    ```
    2. src/main/resources中新建配置文件log4j2.xml文件
    ```txt
<?xml version="1.0" encoding="UTF-8"?>
<!--status 为log4j2自身信息日志的级别-->
<configuration status="error">
    <!-- 先定义所有的appender -->
    <appenders>
        <!-- 这个输出控制台的配置 -->
        <Console name="Console" target="SYSTEM_OUT">
            <!-- 控制台只输出level及以上级别的信息（onMatch），其他的直接拒绝(onMismatch)-->
            <ThresholdFilter level="trace" onMatch="ACCEPT" onMismatch="DENY"/>
            <!-- 这个都知道是输出日志的格式 -->
            <PatternLayout pattern="%d{HH:mm:ss.SSS} %-5level %class{36} %L %M - %msg%xEx%n"/>
        </Console>

        <!-- 文件会打印出所有信息，这个log每次运行程序会自动清空，由append属性决定，
        这个也挺有用的，适合临时测试用 -->
        <!-- append为TRUE表示消息增加到指定文件中，false表示消息覆盖指定的文件内容，
        默认值是true -->
        <File name="log" fileName="log/test.log" append="false">
            <PatternLayout pattern="%d{HH:mm:ss.SSS} %-5level %class{36} %L %M - %msg%xEx%n"/>
        </File>

        <!-- 添加过滤器ThresholdFilter,可以有选择的输出某个级别以上的类别  onMatch="ACCEPT"
        onMismatch="DENY"意思是匹配就接受,否则直接拒绝  -->
        <File name="ERROR" fileName="logs/error.log">
            <ThresholdFilter level="error" onMatch="ACCEPT" onMismatch="DENY"/>
            <PatternLayout
             pattern="%d{yyyy.MM.dd 'at' HH:mm:ss z} %-5level %class{36} %L %M - %msg%xEx%n"/>
        </File>

        <!-- 这个会打印出所有的信息，每次大小超过size，
        则这size大小的日志会自动存入按年份-月份建立的文件夹下面并进行压缩，作为存档 -->
        <RollingFile name="RollingFile" fileName="logs/web.log"
                     filePattern="logs/$${date:yyyy-MM}/web-%d{MM-dd-yyyy}-%i.log.gz">
            <PatternLayout
             pattern="%d{yyyy-MM-dd 'at' HH:mm:ss z} %-5level %class{36} %L %M - %msg%xEx%n"/>
            <SizeBasedTriggeringPolicy size="2MB"/>
        </RollingFile>
    </appenders>

    <!-- 然后定义logger，只有定义了logger并引入的appender，appender才会生效 -->
    <loggers>
        <!-- 建立一个默认的root的logger -->
        <root level="trace">
            <appender-ref ref="Console"/>
            <appender-ref ref="RollingFile"/>
            <appender-ref ref="ERROR"/>
            <appender-ref ref="log"/>
        </root>

    </loggers>
</configuration>
    ```
    3. java中使用
    > import org.slf4j.Logger;
    import org.slf4j.LoggerFactory;
    private static final Logger LOGGER = LoggerFactory.getLogger(XXX.class);
    LOGGER.info("{}", object);
  注： log4j2性能提高了很多，配置更清晰化，slf4j + log4j2方案目前可以使用。
8. LogBack
 -- to be continued



## 
<hr />
<img src="http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20190307_1.jpg" class="full-image" />
