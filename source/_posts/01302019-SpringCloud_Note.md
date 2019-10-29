---
title: SpringCloud学习笔记
categories: SpringCloud
tags:
  - SpringBoot
  - SpringCloud
  - Linux
  - Tomcat

updated: 2019-05-07 11:31:48
abbrlink: 7bee19a4
date: 2019-01-30 17:17:17
---
spring boot, SpringCloud, Actuator, Eureka, ribbon, Feign, hystrix, zuul, 
sleuth, spring cloud config, jdk, spring boot与spring cloud版本问题, linux,
tomcat
<!-- more -->
### springBoot简介

#### 起步依赖

springboot 按不同的功能模块将需要的jar包整合为一个起始包,如web应用，jpa，微服务等不同模块
所需要的jar包统一封装起来,不用手工管理具体的jar包。

springboot的版本号决定了starter依赖包的版本号，而starter依赖包的版本号决定了其聚合的依赖
包的版本号，其内部版本都是经过测试的，没有冲突问题的。

#### 自动配置

springboot使用条件化bean的方法判断classpath中是否有相应的jar包，若有，它会在项目运行时
自动生成对应的实例bean.

如项目classpth中用了h2,自动配置会自动创建一个H2数据库bean；
classpath中有springMVC(由webStarter依赖而来),它会自动配置dispatcherServlet并启用springMVC;
classpath中有tomcat(webStarter依赖而来),它会自动启动一个tomcat容器。

如果想要自定义配置，可以显式自己的spring配置，或通过环境变量，属性文件等进行调整。

#### Actuator监控工具
提供了各个端点对应用情况进行监控。
由于安全问题，springboot 2.0版本将所有端点都移动到/actuator后，且只暴露了info和health
2个端口，其余端口需要在项目配置文件中进行配置才可以访问。
```txt
management:
  endpoints:
    web:
      exposure:
        include: "*"
```

#### 命令行工具
略

注： 最简单的springboot项目hello world需要配置controller,使用@RestController(内含
@ResponseBody)来输出Hello World.

### springCloud微服务

#### 总体架构

<img src="http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/201902181.png" class="full-image" />

#### 服务注册中心Eureka

服务发现架构:

<img src="http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/201902182.png" class="full-image" />

Eureka架构:
Region and availability zone:

<img src="http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/201902183.png" class="full-image" />

<img src="http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/201902184.png" class="full-image" />

1. Eureka Client是一个java客户端，用于简化与Eureka Server交互。

2. 微服务启动后，会周期性（默认30秒）向Eureka Server发送心跳续约自己的租期。

3. 如果Eureka Server一定时间没有收到某个微服务实例的心跳，会注销该实例，默认90秒，
但如果短时间内大量实例丢失，Eureka Server会进入自我保护模式，不会注销任何实例。

4. Eureka Server同时也是client,不同server间通过复制方式同步服务注册表中的数据。

5. Eureka client会缓存服务注册表中的信息。它可以降低Eureka server的压力，
同时Eureka server挂掉了它也可以利用缓存完成调用。

##### Eureka高可用 

实战：
1. 建立Eureka服务器
   1. 依赖<artifactId>spring-cloud-starter-netflix-eureka-server</artifactId>
   2. 配置文件Eureka
   3. @EnableEurekaServer
2. 提供者注册到Eureka
   1. 依赖<artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
   2. 配置文件：项目名作为Eureka实例名及注册到的Eureka实例
   3. @EnableEurekaClient或@EnableDiscoveryClient

#### 负载均衡ribbon

ribbon与eureka联合使用

<img src="http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/201902185.png" class="full-image" />

##### 可以脱离Eureka使用ribbon实现负载均衡

##### 可以自定义负载均衡规则

实战：

1. 依赖spring-cloud-starter-netflix-ribbon,该依赖已经包含在
spring-cloud-starter-netflix-eureka-client中，所以无需重复引入。
2. @loadBalanced
3. 请求地址改为`http://servicename/`, ribbon 与 eureka配合使用时，
会将虚拟主机名映射成服务地址。

#### 请求客户端Feign

声明式，模板化的http客户端

实战:

1. 依赖spring-cloud-starter-openfeign
2. 创建Feign接口，添加@FeignClient注解
3. 将Feign接口注入到controller中进行调用
4. 修改启动类，添加@EnableFeignClients注解

##### Feign内部实现了客户端负载均衡

##### 可以使用Feign自带的注解

##### 可以自己手动定义一个Feign

##### Feign对继承的支持

##### Feign对请求响应信息压缩的支持

##### Feign日志（Feign的日志打印只会对Debug级别做出响应）

1. 定义日志配置类
2. 修改Feign接口，指定配置类
3. 配置文件中指定Feign接口日志级别为debug。

##### Feign多参数请求

1. 多参数get请求
2. 多参数post请求

#### 容错处理-断路器hystrix

雪崩效应:

<img src="http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/201902186.png" class="full-image" />

断路器原理:

<img src="http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/201902187.png" class="full-image" />

实战：
1. 依赖spring-cloud-starter-netflix-hystrix
2. 启动类上添加@EnableCircuitBreaker或@EnableHystrix。
3. controller方法上添加@HystrixCommand(fallbackMethod = "XXXFallBack")

##### springCloud默认为Feign整合了Hystrix
只要hystrix在项目的classpath中，Feign默认会用断路器包裹所有方法
##### hystrix监控
##### hystrix监控使用Hystrix Dashboard可视化监控数据
##### 使用Turbine聚合Hystrix监控数据

#### 网关处理zuul

请求过滤，身份认证，请求与响应信息的格式化等处理信息，还可以进行微服务聚合操作
（通过RxJava响应式编程实现）。

实战：
1. 依赖spring-cloud-starter-netflix-zuul
2. 启动类上添加@EnableZuulProxy， 它声明了一个Zuul代理，使用ribbon定位微服务，
同时整合了hystrix。
3. 编写配置文件注册到eureka。

#### 配置服务器spring cloud config

多个微服务的配置进行统一管理，实际上就是通过将配置统一放到git仓库中，安照一定规则进行使用。

#### 微服务跟踪spring cloud sleuth

记录微服务运行情况的日志工具。

#### 部署

springboot想要部署到生产服务器中需要打成war包，并生成需要的servlet启动类。

1. 配置SpringBootServletInitializer类的子类。
2. 修改maven打包方式为war。
3. 执行maven package命令。
4. 同一个tomcat部署多个不同端口的项目

#### 版本问题

在实际应用过程中，springboot, jdk, springcloud的版本问题造成了很多困扰，这里总结一下:

1. springboot 2.0以后要求是jdk 1.8, jdk 1.7只能适用于springboot2.0以前的版本，不然内部自动
引用的jar包会产生版本问题。
2. springcloud Finchley版本需要和springboot 2.0版本合作,更早的boot版本也会出现问题。

#### springboot集成mybatis, 数据库使用mysql
此项目在微服务microservice-provider-user项目基础上修改。
1. pom.xml中添加mybatis,mysql依赖
```txt
    <!-- Spring Boot Mybatis 依赖 -->
    <dependency>
        <groupId>org.mybatis.spring.boot</groupId>
        <artifactId>mybatis-spring-boot-starter</artifactId>
        <version>${mybatis-spring-boot}</version>
    </dependency>

    <!-- MySQL 连接驱动依赖 -->
    <dependency>
        <groupId>mysql</groupId>
        <artifactId>mysql-connector-java</artifactId>
        <version>${mysql-connector}</version>
    </dependency>
```
2. 在配置文件application.yml中添加数据库和mybatis配置
```txt
spring:
  application:
    name: microservice-provider-user
  datasource:                           # 指定数据源
    url: jdbc:mysql://localhost:3306/springbootdb?useUnicode=true&characterEncoding=utf8&useSSL=false&serverTimezone=UTC
    username: root
    password: root
    driver-class-name: com.mysql.cj.jdbc.Driver
mybatis:
  typeAliasesPackage: com.itmuch.cloud.study.entity    # 实体类
  mapperLocations: classpath:mapper/*.xml             # mapper配置文件
```
3. 编写UserDao,UserService,UserServiceImpl(@Service),UserMapper.xml
4. 最后发现UserServiceImpl注入UserDao报错，在UserApplication类上加上注解
> @MapperScan("com.itmuch.cloud.study.dao")

Done!

#### 工作中发现的问题

1. Feign发送请求时，由于bean属性的首字母是大写的，如UserName, feign打印日志发现发送的
json属性为userName,后来经过搜索，发现可以在setter方法上用@JsonProperty注解，但这需要加
很多个，更方便的是在bean类上加注解,(看注解源码知道这叫PascalCaseStrategy)
> @JsonNaming(PropertyNamingStrategy.UpperCamelCaseStrategy.class)

注：有个全大写的属性字段如MULLINE,只使用@JsonNaming注解时发现发送的json属性是Mulline,
看UpperCamelCaseStrategy的源码知道在该策略执行前该字段已经被转化为全部小写，因为只有这
一个全大写字段，其他字段扔使用PascalStrategy,所以在SetMULLINE方法上使用@JsonProperty
注解即可。
另：在字段上使用@JsonProperty注解发现会产生2个相同的json属性，一个小写，一个大写

2. tbd

#### springcloud config server

1. 新建配置文件git仓库，master分支下新建2个文件
```txt
pra-request.yml
pra-request-prd.yml
```
新建分支dev,修改2个文件，push到仓库中

2. server app 配置
   1. 添加spring-cloud-config-server依赖
   2. 启动类上注解@EnableConfigServer
   3. 修改application.yml
```txt
server.port: 8888
spring:
  application:
      name: pra-config-server
  cloud:
      config:
          server:
              git:
                  uri: http://128.160.184.165/wutaotao/configrepo.git
                  clone-on-start: true
                  force-pull: true      # 强制更新
                  basedir: D:\\code\\pra-config-server-dir  
                    #克隆的仓库由临时目录config-repo-XXX改为指定目录
              health:
                repositories:
                  a:
                    label: dev
                    name: pra-request
                    profiles: prod
logging:
  level:
      org.springframework.cloud: debug
      org.springframework.boot: debug
# 为了显示health端点详细信息，需要进行额外配置
management.security.enabled: false  # 1.5.1版本后只需要写这一句就可以
# boot 2.0.0版本以后需要这样写
management:
  endpoint:
    health:
      show-details: "ALWAYS"
  endpoints:
    web:
      exposure:
        include: *
```
   4. 启动应用，访问端点，如
```txt
# 默认master分支
http://localhost:8888/pra-request/default
http://localhost:8888/pra-request/prod
http://localhost:8888/pra-request-default.yml
http://localhost:8888/pra-request-prod.yml

# 指定dev分支
# http://localhost:8888/dev/pra-request/default  （不支持）
http://localhost:8888/dev/pra-request-default.yml
http://localhost:8888/dev/pra-request-prod.yml
```
修改某个文件后再次通过config-server访问可以发现修改能够查询成功，说明进行请求时，config-
server会自动拉取代码仓库的最新配置。

3. client app
   1. 添加spring-cloud-starter-config，spring-boot-starter-actuator依赖。
   3. 删除application.yml，将其中属性分流到bootstrap.yml和配置仓库中去。
   2. 新增bootstrap.yml（该文档比application.yml先加载，但它优先级比application.yml低，
   经测试同名属性以application.yml中为准）
```txt
spring:
  application:
    name: pra-request
  cloud:
    config:
      uri: http://localhost:8888/
      profile: default
      label: master
```

4. 注册到Eureka上。
   1. config-server注册到Eureka上，config-server也是一个普通的spring-boot应用，根据环境
   不同，可以写application.yml和application-prod.yml。
   添加starter-eureka依赖，添加@DiscoveryClient注解，yml中添加eureka地址即可。
   2. pra-request注册到Eureka上，经测试发现从配置中心取回的属性数据会覆盖客户端自己在
   application.yml中配置的属性，如端口号等。文档里写可以通过在config-server里设置属性
```txt
spring.cloud.config.allowOverride: true
```
来授权允许客户端覆盖配置中心的配置。
所以，在客户端-这里为pra-request里完全可以删除application.yml文件，完全以配置仓库里的为
准，bootstrap.yml中保留可以注册到eureka中心并能定位到需要的yml配置文件的属性，如下:
```txt
spring:
  application:
      name: pra-request     # 需要来定位配置文件{application}
  cloud:
      config:
          profile: default   # 需要来定位配置文件{profile}
          label: master     # 需要来定位配置文件{label}
          discovery:
              enabled: true
              service-id: pra-config-server
          fail-fast: true     # 配置中心连不上时迅速报错，实测报错由19秒提高到3秒

eureka:                               # 本身注册到eureka并寻找注册中心
  client:
      serviceUrl:
          defaultZone: http://localhost:9090/eureka/
  instance:
      prefer-ip-address: true
```
此时，仓库中的配置文件暂时有端口号，profile值，数据库链接，日志级别等。

#### springcloud sleuth
span:
  cs: client-sent 客户端发送    span 开始
  sr: server-received 服务器接受
  ss: server-sent 服务器发送
  cr: client-received  客户端接受  span结束
即从客户端出发，开始发送请求到接收到响应的整个过程是一个span.

从官方文档上来看，span有物理span和逻辑span的区别，
物理span即将网络延迟和服务器处理分成2个span,而上面span的定义就是逻辑的span，整个请求和
响应的过程就是一个逻辑span.

集成zipkin:
server:（因为这是日志收集的服务器，不是微服务的一部分，所以不应该注册到Eureka上，可以配合
springcloud stream和rabbit mq来使用消息中间件）
1. 新建项目zipkin-server,添加依赖
zipkin-server, zipkin-autoconfig-ui

2. 启动类上使用@EnableZipkinServer注解
3. application.yml中添加server.port: 9411

client:
1. spring-cloud-sleuth-starter的基础上添加依赖spring-cloud-sleuth-zipkin
2. application.yml添加
```txt
spring:
  zipkin:
    base-url: http://localhost:9411
  sleuth:
    sampler:
      percentage: 1.0   # 采样为100%
```
这里客户端对于zipkin server的地址是写死的，可以使用rabbitMQ来避免写死，这里省略。

#### web
[项目源码](https://git.dev.tencent.com/wutaotao/springboot-web-jsp.git)
开发工具： idea
环境： springboot jsp
服务器: war包部署到tomcat中

1. 下载tomcat9 windows64位binary包，解压即可。
2. 新建springboot项目，选择web启动依赖即可。
3. pom.xml
```txt
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">

    <groupId>com</groupId>
    <artifactId>microservice-web</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <modelVersion>4.0.0</modelVersion>
    <packaging>war</packaging>
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>1.5.9.RELEASE</version>
    </parent>
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <!-- 解析jstl标签 -->
        <dependency>
            <groupId>javax.servlet</groupId>
            <artifactId>jstl</artifactId>
        </dependency>
    </dependencies>
</project>
```
4. 在src/main下新建webapp文件夹存放jsp文件，这里我统一放在webapp/page/test下
5. 新建webcontroller作简单处理和跳转到相应jsp中，实体类book,启动类WebApplication,
它需要继承SpringBootServletInitializer类，重写config方法，将`return builder`改为
`return builder.source(WebApplication.class)`即可。
6. 新建application.yml文件，定义jsp视图的前缀和后缀，springmvc渲染视图需要。
```txt
spring:
  mvc:
    view:
      prefix: /page/test/
      sufix: .jsp
```
7. 到这里一个简单的springboot整合jsp就完成了，下面要在idea中配置tomcat。
参考[idea tutorial with jrebel](https://github.com/judasn/IntelliJ-IDEA-Tutorial/blob/master/jrebel-setup.md)
   1. 在toolbar中选择edit configuration
   2. application server中选择tomcat解压后的安装路径
   3. 填写after launch后自动打开的url地址
   4. 在deployment中选择artifact: war exploded, 下面的application context置为空（访问路径
   不带项目名），删掉下面build artifact前的build
   注：这个artifact可以在project structure中看到

   5. 返回server,`on update action`和新出现的`on frame deactivation`中都选择update classes
   and resources`
   6. jre默认1.8，http port 8080
   7. apply后以debug启动项目，发现改变jsp后不用重新编译，重启，保存即可生效，改变方法内代码
   重新编译后也能生效！但改变方法参数重新编译后提示`hot swap failed`,说明它还不支持，改用
   jrebel debug启动，发现改变参数重新编译成功！这里并没有生成rebel.xml文件。
   8. 至此，springboot整合jsp的开发环境就搭建成功了！下面打个war包在linux环境下安装tomcat
   启动项目看看。

#### linux安装tomcat并启动服务供外界访问
to be continued

#### springboot整合spring security

<hr />
<img src="http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/201901301.jpg" class="full-image" />

