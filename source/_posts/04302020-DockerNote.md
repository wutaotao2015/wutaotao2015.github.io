---
title: DockerNote
categories: Container
tags:
  - Container
  - Docker
  - K8s
abbrlink: b53499ee
updated: 2020-05-10 10:02:59
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

## oracle
docker hub和github上的image都可以使用，按对应文档启动容器即可。

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
