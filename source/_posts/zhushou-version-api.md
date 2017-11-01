---
title: 【优护助手1.2】APP版本控制接口
date: 2016-12-03 18:34:00
categories: 项目管理
tags:
- 强制升级
---

## 摘要

APP是否强制升级接口，随1.2发布。

<!--more-->

## WIKI维护人
黄英
陈晨

# API
Version是用来提示用户当前软件最新版本和支持的最低版本

GET /api/nurses/calendars/app/version

* Response


``` json
{
    "result" : {"success" : "true"},
    "Android" : {
         "latestVersion" : "1.2.0",
         "lowestSupportVersion" : "1.0.0",
         "downloadURL" : "www.androiddownload.com",
    },
    "iOS" : {
         "latestVersion" : "1.2.0",
         "lowestSupportVersion" : "1.0.0",
         "downloadURL" : "www.iosdownload.com",
    }
}
```


## 返回值书写位置：

返回值直接写在了Youhujia/config-repo/galaxy-development.yml 配置文件中。
书写如下：
appVersion:
  android:
    latestVersion: 1.2.0
    lowestSupportVersion: 1.2.0
    URL: http://www.androiddownload.com
  ios:
    latestVersion: 1.2.0
    lowestSupportVersion: 1.2.0
    URL: http://www.iosdownload.com


如果需要更改，联系后台开发即可。

