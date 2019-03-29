---
title: SpringCloud学习笔记
categories: SpringCloud
tags:
  - SpringBoot
  - SpringCloud
image: http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/201901301.jpg
updated: 2019-03-29 14:23:59
abbrlink: 7bee19a4
date: 2019-01-30 17:17:17
---
spring boot, SpringCloud, Actuator, Eureka, ribbon, Feign, hystrix, zuul, 
sleuth, spring cloud config, jdk, spring boot与spring cloud版本问题
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

<hr />
<img src="http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/201901301.jpg" class="full-image" />

