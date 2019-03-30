---
title: Shell笔记
categories: Shell
tags:
  - Shell
image: 'http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20190330_1.jpg'
updated: 2019-03-30 12:03:23
date: 2019-03-30 11:40:15
abbrlink:
---
Shell
<!-- more -->
## 使用shell脚本来重启sprintboot应用
通过查资料和以前的一些印象终于搞出个能用的......
```txt
#!/bin/bash

export SPRING_PROFILE=prod
export APP_NAME=pra-plat
export VERSION=1.0.0-SNAPSHOT
export SERVER_PORT=8080

## setting log home
export JAR_HOME=/home/ap/cloudapp
export LOG_HOME=/home/ap/cloudapp/logs
export LOG_NAME=${APP_NAME}


# =两边不能有空格,命令输出结果用$()来赋给变量,注意awk的写法
pid=$(ps -ef | grep java | grep ${APP_NAME}| awk '{print $2}')
# 注意如何判断变量为空
if [ ${pid} ]
then # then需要另起一行，与if在同一行时需要在then前加分号
    echo "stop ${APP_NAME}_${SERVER_PORT} service"
    echo "kill process ${pid}"
    kill -9 ${pid}
fi

echo "start ${APP_NAME}_${SERVER_PORT} service"
JAVA_OPTS="-Dspring.profiles.active=${SPRING_PROFILE}"
# 直接jar包报cannot access jar file错误
nohup java -jar ${JAVA_OPTS} ${JAR_HOME}/${APP_NAME}-${VERSION}.jar >${LOG_HOME}/${LOG_NAME}.out 2>&1 &

echo "tail -f ${LOG_HOME}/${LOG_NAME}.out"
```

##
##
<hr />
<img src="http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20190330_1.jpg" class="full-image" />
