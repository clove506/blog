---
title: 【合肥项目】日志搜集 上线说明
date: 2017-01-10 17:00:00
categories: 合肥
tags:
- 日志搜集
- 上线
- deployment
---

## 摘要

支付系统 上线说明
<!--more-->

## WIKI维护人
黄丹

## 部署方法
  - cd /data
  - mkdir sls
  - cd sls
  - mkdir applogs
  - mkdir accesslogs
  - sudo wget http://logtail-release-bj.vpc100-oss-cn-beijing.aliyuncs.com/linux64/logtail.sh
  - sudo chmod 755 logtail.sh
  - sudo sh logtail.sh install cn_beijing_vpc  

## Aliyun配置
详见 [链接](http://wiki.office.test.youhujia.com/2016/12/15/youhujia-data-1/)
