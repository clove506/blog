---
title: 开发环境配置
date: 2016-11-29 16:51:13
categories: 新人培训
tags:
- 环境
---

## 摘要
- 登录到开发机。
- 数据库相关。

<!--more-->

## 登陆到开发机器
1. 生成 ssh 公私钥，将公钥发给学文，让他帮忙添加到开发服务器

2. 添加如下内容到 ~/.ssh/config 文件中:

   ```
   Host gw01
     Hostname 123.56.216.175
     User deploy
   ```

3. `ssh gw01` 即可登陆

## 通过跳板机，查看开发数据库

1. 使用 Sequel Pro 

2. 添加配置信息：

   ```
   Mysql Host : rm-2zeu89iqt7t878474.mysql.rds.aliyuncs.com
   usename : yhj_admin
   password : Yhj66666

   ssh host : 123.56.216.175
   ssh user : deploy
   ```

   ​


