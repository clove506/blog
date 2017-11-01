---
title: 远端调试
date: 2016-12-27 12:09:13
categories: 新人培训
tags:
- 新人
---

## 摘要
Java项目远端调试详情

<!--more-->

## 准备
* 进入Intellij IDEA的Run/Debug 配置<br>
![](/media/QQ20161227-1.png)

* 在Intellij IDEA添加远端调试，复制配置参数。
![](/media/QQ20161227-0.png)

## 启动项目
#### 普通启动
以前是这样直接启动

```
CONFIG_URL=http://10.0.0.1:5001/ IP=10.0.0.1 PORT=6011 MPORT=6012 ENV=development gradle bootRun
```

现在用以下命令启动即可

```
CONFIG_URL=http://10.0.0.1:5001/ IP=10.0.0.1 PORT=6011 MPORT=6012 ENV=development java XXX -Djava.security.egd=file:/dev/./urandom  -jar xx.jar
```

**注意：<br>
1. XXX处是在上图6中需要复制的配置参数<br>
2. xx.jar 是自己项目打包的jar包，一般都在build/libs/中。**

例如：

```
CONFIG_URL=http://10.0.0.1:5001/ IP=10.0.0.1 PORT=6011 MPORT=6012 ENV=development java -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005 -Djava.security.egd=file:/dev/./urandom  -jar build/libs/dna-0.0.1.jar
```

#### docker启动
只需要把需要复制的配置参数加入到entrypoint.sh里。改变后如下：

```
#!/bin/bash

set -e

# set hosts
cat >> /etc/hosts <<- EOM
10.0.0.1 gw01.yhj gw01
10.0.0.6 center01.yhj center01
EOM

if [ -z $MEM_MIN ]; then
	export MEM_MIN=1024M
fi
if [ -z $MEM_MAX ]; then
	export MEM_MAX=1024M
fi

if [ "$1" = "java" ]; then
	java \
    -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005 \
    -Djava.security.egd=file:/dev/./urandom \
    -Xms$MEM_MIN -Xmx$MEM_MAX \
    -jar /*.jar
fi
exec "$@"
```

再用bin/start.development脚步启动就可以了。

## 本地调试

**注意：本地代码需要和远端一致**

本地选择Remote项，启动debug，连接成功可以在控制台看到，如下输出：

```
Connected to the target VM, address: '10.0.0.1:5005', transport: 'socket'
```
