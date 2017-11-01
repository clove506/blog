---
title: 优护家 CI 系统
date: 2017-01-10 14:00
categories: 系统架构
tags:
- CI
---

[TOC]

# 摘要

优护家 CI 系统

<!--more-->

# Wiki维护人

赵蔺


# 概述
通过搭建jenkins CI配合阿里云容器服务搭建CI系统，方便开发和运维工作。
参考文章：https://yq.aliyun.com/articles/53971
# Jenkins
Jenkins是基于Java开发的一种开源持续集成工具，balabalabala(想了解的查一下)。
Jenkins目前搭建在gw01服务器上，通过http://jenkins.zhushou.dev.youhujia.com/ 访问，http://jenkins.zhushou.dev.youhujia.com/blue 是比较现代的UI界面。
添加新dev项目请copy from template-dev项目。
# 容器服务
此次服务搭建在阿里云容器服务上。使用的是dev-zhushou集群。
## 应用
大部分服务基本都会单独启动一个应用。（config和eureka在base中，康复宝有两个应用）
应用采用zhushou-general-dev编排模版创建。
## 镜像
编排模版中docker镜像地址为http://registry.cn-beijing.aliyuncs.com/zhushou-dev/{srv_name}。
config server现通过git直接获取配置。
# 服务修改
为了配合CI和容器服务，对代码要进行修改。此次修改均在youhujia的github库上的docker分支上。

## config-repo
所有项目的config文件加入一个docker_develop环境的配置文件，可在docker分支中添加。

## Dockerfile
根目录下加入Dockerfile，方便Jenkins构建镜像并上传。具体写法通过参考其他项目修改buildDocker生成的Dockerfile。

## maven库
现halo的jar包现通过maven库获取。build.gradle文件中repositories里加入
> maven { url "http://maven.zhushou.dev.youhujia.com/nexus/content/repositories/thirdparty/" }

## config
bootstrap.properties文件中的config label现改为docker，后续会修改为develop。建议加入以下配置项。
> spring.cloud.config.retry.max-attempts=10

## gradle.build
由于通过自建maven源获取halo，需要添加dependencies，目前的基本没有问题，之后相关问题根据项目自行添加。

# 开发流程

## halo开发与部署
halo开发测试通过后合并到Youhujia的develop分支，会触发jenkins上halo-dev的部署。jenkins上会自动上传jar包到我们自己搭的maven库。其他项目再引用即可。
替换maven库为
> maven { url "http://maven.zhushou.dev.youhujia.com/nexus/content/repositories/yhj-develop/"}

**注意：这个在正式上线前一定要改回来。**

其他项目在引用时，将gradle中的dependencies改为：
> compile group: "com.youhujia.halo", name: "youhujia-halo", version: "v1.5.0-SNAPSHOT""

**注意删除本地的halo**

这里的version是根据git上的tag自动打上的。
