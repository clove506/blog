---
title: 【合肥项目】Dagon-Item
date: 2017-1-9 22:00:00
categories: 合肥
tags:
- Dagon
---

## 摘要

 dagon项目staging上线方案

<!--more-->
## WIKI维护人
卢江
## 数据初始化
1.在 staging 数据库服务器上创建一个新的数据库，名为dagon-staging
## staging环境上线流程

1. 执行 **netstat -an | grep 7001**、**netstat -an | grep 7002** 检查7001、7002端口是否被占用，若有进程占用该端口，kill该线程，若无进程占用端口，进行步骤2；
2. 在home工作区间下运行 **mkdir /opt/zhoushou/** 创建 /opt/zhoushou/ 目录（若该目录存在，可跳至3），创建完毕之后跳至步骤3；
3. 在 /opt/zhoushou/运行 **git clone git@github.com:Youhujia/config-repo.git**，再运行 **git log**，查看当前代码是否是最新，若不是最新，运行 **git pull** 更新到最新代码，操作完成之后，跳至步骤4；
4. 在 /opt/zhoushou/ 运行 **git clone git@github.com:Youhujia/dagon.git**，运行 **cd dagon**切换到 /opt/zhoushou/dagon目录下，运行 **git checkout release** 切换到release分支，运行 **git log**，查看当前代码是否是最新，若不是最新，运行 **git pull** 更新到最新代码，操作完成之后，跳至步骤5；
5. 在/opt/zhoushou/dagon目录下执行 **gradle build** 命令，编译通过之后，跳至步骤6；
6. 在/opt/zhoushou/dagon目录下执行 **./bin/start.staging** 命令，跳至步骤7；
7. 执行**docker ps**查看当前docker容器正在运行的进程，若存在dagon进程，跳至步骤8；
8. 执行**docker logs -f xxxxxx**，xxxxxx为dagon容器ID，查看dagon项目是否启动成功，若成功启动，则上线成功结束！

