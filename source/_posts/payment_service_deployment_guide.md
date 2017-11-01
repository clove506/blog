---
title: 【合肥项目】支付系统 上线说明
date: 2017-01-10 16:00:00
categories: 合肥
tags:
- 支付系统
- 上线
- deployment
---

## 摘要

支付系统 上线说明
<!--more-->

## WIKI维护人
黄丹

## 部署方法
  - cd /opt/zhushou
  - git clone -o origin git@github.com:youhujia/midas.git
  - cd midas
  - ./bin/start.production
  - 或者: CONFIG_URL=http://10.0.0.6:5001/ IP=10.0.0.6 PORT=6011 MPORT=6012 ENV=production gradle go
  - docker ps 确认运行状况

## Ping++配置
  - webhook: http://api.zhushou.youhujia.com/api/midas/v1/webhook/pingpp
