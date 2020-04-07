---
title: Mybatis学习笔记
categories: Mybatis
tags:
  - Mybatis
  - Log4J
  - Log4J2
  - SLF4J

abbrlink: 7fd48667
updated: 2020-04-07 11:13:36
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
   2020-04-06 11:44:42 添加:
Springboot默认集成了logBack, 即spring-boot-starter-logging包中集成了logBack的实现。
在application.yml中配置logging.file=xxx.log或logging.path=/var/log/xx.log即可生成日志文件，
但涉及到文件大小或日期控制，或不同环境不同的log配置时，就需要用到自定义的配置文件如
logback.xml或logback-spring.xml(推荐).
(可以通过如logging.config=classpath: logging-config.xml指定配置文件的名称，但这样做意义不大)

   1. 依赖
   
   ```txt
    <dependency>
        <groupId>ch.qos.logback</groupId>
        <artifactId>logback-classic</artifactId>
        <version>1.2.3</version>
    </dependency>
   ```
   2. resources下新建配置文件logback-spring.xml(只有这样才能使用springProfile标签)
```txt
<?xml version="1.0" encoding="UTF-8"?>
<configuration scan="true" scanPeriod="60 seconds" debug="false">
<!--    <contextName>logback</contextName>-->
    <property name="log.path" value="/home/tao/Documents/note/"/>

    <!--日志格式控制 -->
    <!-- %-50loggger{50} 中 -50 是格式化类名左对齐,右边空白, 这样类名和消息隔开,
         利于查看. 
         50是最小长度, 如果写法为%20.30, 则控制了最大长度30, 它会截取字符串,
         这会将类名截取掉.
    我们用logger{50} 是控制类名缩写, 它软性控制了最大长度, 因为不会截取类名, 所以类名过长
    时会超出限制, 所以这个最大值不能过小, 这里设置为50即可.
     p: priority
     t: thread
    -->
    <property name="pattern" value="[APP][%d{yyyy-MM-dd HH:mm:ss SSS}][%-5p][%t][%-50logger{50}]%m%n"/>
    <!--输出到控制台-->
    <appender name="console" class="ch.qos.logback.core.ConsoleAppender">
      <encoder>
        <pattern>${pattern}</pattern>
        <charset>utf-8</charset>
      </encoder>
    </appender>

    <springProfile name="dev">

      <root level="debug">
        <appender-ref ref="console"/>
      </root>

    </springProfile>

    <springProfile name="test,prod">

      <!--输出到文件-->
<!--      <appender name="file" class="ch.qos.logback.core.rolling.RollingFileAppender">-->
<!--        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">-->
<!--          <fileNamePattern>${log.path}/logback.%d{yyyy-MM-dd}.log</fileNamePattern>-->
<!--        </rollingPolicy>-->
<!--        <encoder>-->
<!--          <pattern>%d{HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n</pattern>-->
<!--        </encoder>-->
<!--      </appender>-->

      <appender name="rolling" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <rollingPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedRollingPolicy">
          <!-- rollover daily -->
          <fileNamePattern>${log.path}/%d{yyyy-MM-dd}.%i.txt</fileNamePattern>
          <!-- each file should be at most 100MB, keep 60 days worth of history, but at most 20GB -->
          <maxFileSize>100MB</maxFileSize>
          <!-- 14 days-->
          <maxHistory>14</maxHistory>
          <totalSizeCap>10GB</totalSizeCap>
        </rollingPolicy>
        <encoder>
          <pattern>${pattern}</pattern>
          <charset>utf-8</charset>
        </encoder>
      </appender>

      <root level="info">
        <appender-ref ref="console"/>
        <appender-ref ref="rolling"/>
      </root>
    </springProfile>

  </configuration>
```
注: 经测试，当文件大小设置过小时，如5kb，文件大小切分不均匀，增大到20kb时文件大小就在
20kb时，文件大小就切分的比较好，大概在20-30kb间，最后一个文件大小是50kb, 由此可以看出
切分文件是异步过程。这里设置为100MB，后续观察实际使用情况。

another example: 
```txt
<?xml version="1.0" encoding="UTF-8"?>
<!--scan:
            当此属性设置为true时，配置文件如果发生改变，将会被重新加载，默认值为true。
scanPeriod:
            设置监测配置文件是否有修改的时间间隔，如果没有给出时间单位，默认单位是毫秒。当scan为true时，此属性生效。
            默认的时间间隔为1分钟。
debug:
            当此属性设置为true时，将打印出logback内部日志信息，实时查看logback运行状态。默认值为false。

configuration 子节点为 appender、logger、root
-->
<configuration scan="true" scanPeriod="60 seconds" debug="false">
    <!--用于区分不同应用程序的记录-->
    <contextName>edu-cloud</contextName>
    <!--日志文件所在目录，如果是tomcat，如下写法日志文件会在则为${TOMCAT_HOME}/bin/logs/目录下-->
    <property name="LOG_HOME" value="logs"/>

    <!--控制台-->
    <appender name="stdout" class="ch.qos.logback.core.ConsoleAppender">
        <encoder>
            <!--格式化输出：%d表示日期，%thread表示线程名，%-5level：级别从左显示5个字符宽度 %logger输出日志的
            logger名 %msg：日志消息，%n是换行符 -->
            <pattern>[%d{yyyy-MM-dd HH:mm:ss.SSS}] [%thread] %-5level %logger{36} : %msg%n</pattern>
            <!--解决乱码问题-->
            <charset>UTF-8</charset>
        </encoder>
    </appender>

    <!--滚动文件-->
    <appender name="infoFile" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <!-- ThresholdFilter:临界值过滤器，过滤掉 TRACE 和 DEBUG 级别的日志 -->
        <filter class="ch.qos.logback.classic.filter.ThresholdFilter">
            <level>INFO</level>
        </filter>
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <fileNamePattern>${LOG_HOME}/log.%d{yyyy-MM-dd}.log</fileNamePattern>
            <maxHistory>30</maxHistory><!--保存最近30天的日志-->
        </rollingPolicy>
        <encoder>
            <charset>UTF-8</charset>
            <pattern>[%d{yyyy-MM-dd HH:mm:ss.SSS}] [%thread] %-5level %logger{36} : %msg%n</pattern>
        </encoder>
    </appender>

    <!--滚动文件-->
    <appender name="errorFile" class="ch.qos.logback.core.rolling.RollingFileAppender">
             <!-- ThresholdFilter:临界值过滤器，过滤掉 TRACE 和 DEBUG 级别的日志 -->
        <filter class="ch.qos.logback.classic.filter.ThresholdFilter">
            <level>error</level>
        </filter>
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <fileNamePattern>${LOG_HOME}/error.%d{yyyy-MM-dd}.log</fileNamePattern>
            <maxHistory>30</maxHistory><!--保存最近30天的日志-->
        </rollingPolicy>
        <encoder>
            <charset>UTF-8</charset>
            <pattern>[%d{yyyy-MM-dd HH:mm:ss.SSS}] [%thread] %-5level %logger{36} : %msg%n</pattern>
        </encoder>
    </appender>

    <!--将日志输出到logstack-->
    <!--<appender name="logstash" class="net.logstash.logback.appender.LogstashTcpSocketAppender">
        <destination>47.93.173.81:7002</destination>
        <encoder class="net.logstash.logback.encoder.LogstashEncoder">
            <charset>UTF-8</charset>
        </encoder>
        <keepAliveDuration>5 minutes</keepAliveDuration>
    </appender>-->

    <!--这里如果是info，spring、mybatis等框架则不会输出：TRACE < DEBUG < INFO <  WARN < ERROR-->
    <!--root是所有logger的祖先，均继承root，如果某一个自定义的logger没有指定level，就会寻找
    父logger看有没有指定级别，直到找到root。-->
    <root level="debug">
        <appender-ref ref="stdout"/>
        <appender-ref ref="infoFile"/>
        <appender-ref ref="errorFile"/>
        <appender-ref ref="logstash"/>
    </root>

    <!--为某个包单独配置logger

    比如定时任务，写代码的包名为：com.seentao.task
    步骤如下：
    1、定义一个appender，取名为task（随意，只要下面logger引用就行了）
    appender的配置按照需要即可


    2、定义一个logger:
    <logger name="com.seentao.task" level="DEBUG" additivity="false">
      <appender-ref ref="task" />
    </logger>
    注意：additivity必须设置为false，这样只会交给task这个appender，否则其他appender也会打印com.seentao.task
    里的log信息。

    3、这样，在com.seentao.task的logger就会是上面定义的logger了。
    private static Logger logger = LoggerFactory.getLogger(Class1.class);
    -->

</configuration>
   ```
   3. java中使用
   同slf4j
   
## mybatis mapper.xml
1. select查询

   1. mapper.xml与mapper接口配合使用时，mapper.xml中的namespace必须为相应接口的全限定名，mybatis
通过这个关系才能找到对应mapper的实现xml(也正因为这样mapper接口才不需要实现类)
   2. 另外之前在mybatis-config.xml中是用`<mapper resource=XXX>`标签指定了具体的mapper.xml位置来实现映射，使用接口后可以使用`<package name=XXX>`来指定接口类所在的包。
   3. mapper.xml中的id与mapper接口方法名也要一一对应。
   4. mapper.xml中resultMap标签中的id和result标签中有javaType和jdbcType2个容易混淆的属性：
   > javaType: 如果resultMap映射到的是一个javabean,id和result所指字段的java类型不用指明，
   > 如果resultMap映射的是一个hashmap,需要用javaType来指明键的java类型。
   > jdbcType: 指定列对应的数据库类型，是JDBC的需要，仅对insert,update,delete可能为空的列
   > 进行处理。
   > 以上2个属性的区别还有待以后实战补充整理。

   5. 查询结果可以用resultMap和resultType这两种方式来映射返回结果，其中resultType需要在
   sql中指定别名实现与java属性的映射关系，可以设置mybatis属性mapUnderscoreToCamelCase=
   true来统一实现下划线转驼峰命名，设置好以后就不需要给sql字段添加别名了。不过这样需要
   字段命名都很规范才可以。

   6. 使用sqlsession.selectList来测试时mapper.xml所在包的位置也需要和mapper接口
   所在包的路径一致，这是因为在mybatis-config中配置的是mapper接口的包路径，
   mybatis按路径如com.mapper.UserMapper转化为com/mapper/UserMapper.xml，
   mybatis找到该路径即进行解析该xml。
   在其他项目中使用得到mapper.xml的包路径和mapper包路径不同，namespace相同项目也能跑
   起来，具体原因后面看了原理再来探究。

   7. mysql的BLOB类型java类中为byte[],需要在resultMap的result标签中指定jdbcType=BLOB,
   java.util.Date类型可以指定jdbcType=TIMESTAMP或其他org.apache.ibatis.type.DATE,TIME.

   8. 可以用sqlSession.getMapper(UserMapper.class)来获取得到mapper接口进行测试。

2. 
## 
<hr />
<img src="http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20190307_1.jpg" class="full-image" />
