---
title: DockerNote
categories: Container
tags:
  - Container
  - Docker
  - K8s
abbrlink: b53499ee
updated: 2020-05-16 16:08:59
date: 2020-04-30 07:48:09
---
Docker and Kubernetes note
<!-- more -->

## App note
下面是开发时需要用到的环境配置, 从最底层
os:
input method: sougou/fcitx
xmonad/amethyst
autohotKey karabiner/cmder/Context schroo/listary/
fish shell
...

init:
vim  .vimrc
git   username, email
jdk   path
maven  settings
idea   ideaSettings or ideaConfig dir

container(docker):
mysql/oracle
redis
rocketMQ
tomcat

## Mariadb
按照docker hub上的文档说明启动容器，需要加上端口映射 -p 3306:3306
```txt
docker run --name mydb -v /Users/wutaotao/stuff/mysqlData:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=xxx -p 3306:3306 -d mariadb
```

## oracle
docker hub和github上的image都可以使用，按对应文档启动容器即可。
```txt
docker hub
docker run -d -it --name oracle -v /Users/wutaotao/stuff/oracleData:/ORCL -p 1521:1521 -p 5500:5500 store/oracle/database-enterprise:12.2.0.1

quay.io/maksymbilenko/oracle-12c github
docker run -d -p 1521:1521 -v /Users/wutaotao/stuff/oracleData/:/u01/app/oracle quay.io/maksymbilenko/oracle-12c
```

## mongodb
```txt
docker pull mongo
docker run --name mongo -p 27017:27017 -v /Users/wutaotao/stuff/mongodb:/data/db -d mongo --auth

mongo university atlas learning cluster
docker exec -it mongo mongo "mongodb+srv://cluster0-jxeqq.mongodb.net/test" 
--username m001-student -password m001-mongodb-basics

```


## 常用命令
docker image ls
docker container ls -a 
// -d daemon  -it iteractive terminal -name containerName -v datasource dir  -p port
docker run -d -it -name -v -p iamgeName

docker logs -f containerName 
docker ps
// check container ip and ports info
docker inspect containerName
docker stop containerName
docker rm containerName
docker rmi imageId


<hr />
<img src="http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20200505_1.jpg" class="full-image" />
