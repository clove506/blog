---
title: 【合肥项目】C端-Shooter-Online-Plan
date: 2017-1-10 17:30:00
categories: 合肥
tags:
- 优护助手
---
##摘要

合肥项目-患者端相关

## WIKI维护人

林慧芝 & 王梦超

## Shooter系统API详细设计
[C端API详情设计](http://wiki.office.test.youhujia.com/2016/12/13/Hefei_C_End_API/)

## Shooter进度
[C端进度](http://wiki.office.test.youhujia.com/2016/12/19/HeFei-C-Plan-/)

## 上线方案
### staging环境

1.依赖：config-repo、halo
2.[config-repo线上配置文件](https://github.com/Youhujia/config-repo/blob/master/shooter-staging.yml)
3.调用的服务：owl、dagon、cms、yolar、sophon
4.使用的注解所在位置：authorization
### 正式环境

1.依赖：config-repo、halo
2.[config-repo线上配置文件](https://github.com/Youhujia/config-repo/blob/master/shooter-production.yml)

#### 正式操作步骤
1.确保shooter依赖的halo必须ok。
2.登录center 01 服务器。
3.在根目录创建：mkdir   -p /opt/zhushou/  目录（如果opt/zhushou/目录已经存在，就直接进行下一步操作）。
4.切换到/opt/zhushou/目录下。
5.搭建配置文件，git log查看是否为最新的文件，若不是就git pull拉取最新的配置文件。
6.搭建线上的shooter项目：git@github.com:Youhujia/shooter.git（git log 查看确是否为最新的项目，若不是就git pull拉取最新的代码）。
7.cd到shooter目录下，切换到release分支（git log查看是否为最新的代码，若不是就git pull拉取最新的代码）。
8.在shooter目录下，执行 ./bin/start.production。 
9.启动项目。
10.启动完毕，查看是否启动成功。

