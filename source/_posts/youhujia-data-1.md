---
title: 【合肥】优护家数据中心一期-数据记录/收集/标准化中间层 (代码层面记录/标准化数据设计)
date: 2016-12-15 22:00:00
categories: 合肥
tags:
- 项目管理
---

## 摘要

数据中心一期
<!--more-->

## WIKI维护人
黄丹
陈晨

## 背景

整体方案初稿： [链接](http://wiki.office.test.youhujia.com/2016/12/10/data_platform_overview/)

## 详细设计

1. 全局数据如何关联  
  - 采用spring sleuth自动注入traceid spanid
2. 收集什么数据  
  - tomcat access logs
  - application logs，可做后续场景数据分析
  - docker logs
3. 收集数据怎么标准化存储
4. 应用服务器如何快速接入
  - spring sleuth无需修改代码，已在halo中加入依赖，只要引用最新halo即可自动注入全局traceid
  - 日志输出需要少量配置
     - 修改build.gradle文件，创建container内部log目录  
     ```
        runCommand "mkdir /logs"
        runCommand "mkdir /logs/applogs"
        runCommand "mkdir /logs/accesslogs"
     ```
     - 修改docker run命令，映射内部Log目录到host主机目录  
     ```
     "-v", "/data/sls/applogs:/logs/applogs",
     "-v", "/data/sls/accesslogs:/logs/accesslogs",     
     ```
     - 修改对应config yml文件，加入格式定义及log开关
     ```
     logging.file: "/logs/applogs/${spring.application.name}.log"
     logging.pattern.file: "%d{yyyy-MM-dd HH:mm:ss}|%d{yyyy-MM-dd HH:mm:ss.SSS}|%p|${spring.application.name}|%X{X-B3-TraceId:-}|%X{X-B3-SpanId:-}|%X{X-Span-Export:-}|${PID:-}|%t|%logger|%m%n"
     server.tomcat.accesslog.enabled: true
     server.tomcat.accesslog.prefix: "${spring.application.name}"
     server.tomcat.accesslog.directory: "/logs/accesslogs"     
     ```

5. 日志的保留机制
  - log shipper, 投递到OSS做长时保存，并可以在EMR做后续处理
  - log shipper，投递到ODPS做日志分析


### 数据收集方案

  - 统一采用 slf4j 作为logger facade
  - spring sleuth 统一注入 traceid 及 spanid 到 MDC
  - 按照目前的server方案，需要部署aliyun logtail到host机器
  - ECS主机需要建立/data/sls/applogs, /data/sls/accesslogs目录
  - logtail可直接读取docker logs
  - 映射docker container内部log文件到host机目录，然后用logtail收集
  - 需要在aliyun日志平台配置logtail及数据解析定义

### 收集什么数据

- CallLogger 访问日志
- ErrorLogger 错误日志
- BehaviorLogger 行为日志
- OperatorLogger 操作日志
- FinanceLogger 财务日志

### 标准化存储

统一的日志记录格式
统一的收集处理方式
统一的解析方式


### 应用服务器接入方案
配合基础服务Halo提供通用信息快速统一存储，变化信息提供Util。


## 时间点

工作内容 |  内容详情 | 人日 | 分配
------------ |-------- | ------------- | ----
数据收集方案调研  | 逻辑实现 |  1人日 | 黄丹
应用服务器接入方案 | 逻辑实现 | 1人日 | 黄丹
应用服务器推广 | 逻辑实现 | 1人日 | @ALL
标准化存储 | 逻辑实现 | 3人日 | 黄丹

## 首期各个微服务数据搜集器接入状态
服务名 | docker配置 | config-repo yml
-- | -- | --
midas | OK | OK
owl | OK | OK
dna | OK | OK
shooter | OK | OK
farmer | OK | OK
dagon | OK | OK
yolar | OK | OK
singer | OK | OK
difoil | OK | OK
momentum | OK | OK
redcoast | OK | OK
gateway | OK | OK
era | OK | OK
dimension | OK | OK
galaxy | OK | OK
gateway | OK | OK
huformation | OK | OK
metadata | OK | OK
sophon | OK | OK
wall-breaker | OK | OK
swordkeeper | OK | OK
kangfubao.kfb | OK | OK
kangfubao.cms | OK | OK

## 部署方法
  - 部署logtail (ECS VPC网络)：
  ```
  wget http://logtail-release-bj.vpc100-oss-cn-beijing.aliyuncs.com/linux64/logtail.sh
  chmod 755 logtail.sh
  sh logtail.sh install cn_beijing_vpc  
  ```
  - aliyun logstore 配置
    - 创建 日志工程，例如yhj-logs-staging
    - 创建 logstore: access-raw-logs, docker-raw-logs, app-raw-logs
    - docker-raw-logs, 文本, /var/lib/docker/containers/
    - access-raw-logs, 文本, /data/sls/accesslogs, 完整正则模式
      - regex: (\S+)\s(\S+)\s(\S+)\s\[(\S+)\s([^]]+)]\s"(\w+)\s(\S+)\s([^"]+)"\s(\d+)\s(\d+).*
      - fields: remotehost, rfcid, uid, time, timezone, method, url, version, httpcode, bytes
      - time: %d/%b/%Y:%H:%M:%S
      - topic: 文件路径
    - app-raw-logs, 文本, /data/sls/applogs, 竖线分隔符模式
      - fields: logtime, time, level, app, traceid, spanid, exportable, pid, thread, logger, msg
      - time field: logtime, %Y-%m-%d %H:%M:%S
      - topic: 文件路径
    - 全部配置开启 全文索引
    - 全部开启OSS投递
