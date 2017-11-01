---
title: 【优护助手-合肥】合肥项目-B端上线方案
date: 2017-1-11 02:10:00
categories: 合肥
tags:
- 优护助手
---
## 摘要
合肥项目-护士端上线方案
<!--more-->
###WIKI维护人
程冲&杨淑婷
###护士端（B端）API详细设计
http://wiki.office.test.youhujia.com/2016/12/13/HeFei_Project-B-End-API/
###上线方案：
####staging环境：
 1.依赖：config-repo,halo(上线必须支持)
 2.config_repo线上配置文件：https://github.com/Youhujia/config-repo/blob/master/farmer-staging.yml 
 3.调用的服务：owl，dagon，yolar
 4.使用注解：authorizaiton
 
####正式环境
1.依赖：config-repo,halo(上线必须支持)
2.config_repo线上配置文件：https://github.com/Youhujia/config-repo/blob/master/farmer-production.yml
 
####staging环境上线步骤
1. 执行netstat-an|grep7001,netstat-an|grep7002检查7001，7002端口是否被占用，若有进程占用该端口，kill该线程，若无进程占用端口，进行步骤2;
2. 在home工作区间下运行mkdir /opt/hefei/创建opt/hefei/目录（若该目录存在，可直接跳到3步）;
3. 在/opt/hefei/目录下运行git clone git@github.com:Youhujia/farmer.git,然后再运行git log，查看当前代码是否为最新，若不是最新，执行git pull拉下来最新的；运行cd farmer切换到/opt/hefei/farmer目录下，运行git checkout release切换到release分支，运行git log,查看当前代码是否最新，若不是，执行git pull,拉下来最新的；跳至步骤4;
4. 在/opt/hefei/目录下运行git clone git@github.com:Youhujia/config-repo.git,然后再运行git log，查看当前代码是否为最新，若不是最新，执行git pull拉下来最新的,跳至步骤5;
5. 在/opt/hefei/ 运行git@github.com:Youhujia/halo.git，查看当前代码是否为最新，若不是最新，执行git pull拉下来最新的,跳至步骤7;
6. 在/opt/hefei/farmer目录下执行gradle build命令，编辑通过后，跳至步骤7;
7. 在/opt/hefei/farmer目录下执行./binstart.staging命令，跳至步骤8；
8. 执行docker ps查看当前docker容器正在运行的进程，若存在farmer进程，跳至步骤9;
9. 执行docker logs -f xxxxxx,xxxxx为farmer的容器ID，查看farmer是否启动，若启动，上线成功。

#### 护士端项目进度回顾
http://wiki.office.test.youhujia.com/2017/01/08/B-duan-jindu/



