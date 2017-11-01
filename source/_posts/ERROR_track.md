---
title: 日常线上环境ERROR排错与修复
date: 2017-03-17
categories: 开发流程
tags:
- ERROR排查
---

## 摘要

日常线上环境ERROR排错与修复

<!--more-->

## Wiki维护人

赵蔺

## Sentry

我们采用[Sentry](https://sentry.io)作为一个实时错误报告工具。需要在项目中进行配置，添加&修改两个文件：

- 新建/src/main/resources/logback-spring.xml文件
- 修改entrypoint.sh文件

均可参考yolar项目（develop分支），并且需要将halo的版本设置为v1.5.4-SNAPSHOT或v1.5.5

优护家sentry：[链接](http://sentry.zhushou.dev.youhujia.com/) ,可以注册并找赵蔺添加一下分组。

## 阿里云日志服务

通过：登录[https://signin.aliyun.com/1548533141310711/login.htm](https://signin.aliyun.com/1548533141310711/login.htm)，如果没有账号，找Shawn或者赵蔺。

## 排查过程

1.错误总览
在错误出现后在sentry上会有显示
![sentry概览](http://om63jcaoh.bkt.clouddn.com/YHJ_sentry_overview.png)

左上角可以选择项目（dev,staging,production）,下面可以点击ERROR的详情，右边可以根据不同标签来筛选。

2.错误细节
![sentry ERROR细节](http://om63jcaoh.bkt.clouddn.com/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202017-03-17%20%E4%B8%8B%E5%8D%881.56.24.png)

带有stacktrace，exception，部分additional data中还带有traceid，可利用这个在日志服务中排错。

3.日志排查
根据错误trace id，可以在阿里云日志服务中进行排查。
![日志服务](http://om63jcaoh.bkt.clouddn.com/aliyun_log_service.png)
