---
title: 【扫码关注流程改进1.0】 详细设计&&项目管理
date: 2016-12-03 17:09:00
categories: 项目管理
tags:
- 关注流程
---


## 摘要
扫码关注流程改进 开发及进度文档
<!--more-->

##  后台设计

1. 给科室生成微信二维码
2. 针对二维码扫码关注，添加微信callback的处理
3. 后台添加一个返回科室二维码的列表

## 接口

**1. 生成二维码 管理后台使用**

POST /api/admin/nurses/msg/wx/qrcode

+ Request

  ```json
  {
    "departmentId" : 123
  }
  ```

+ Response

  ```json
  {
    "result" : {"success" : true},
    "qrcodeUrl" : "http://wx/qrcode.jpg"
  }
  ```

**2. 扫码关注的callback处理**

POST /api/nurses/msg/wx/callback

+ Request

**用户未关注时，进行关注后的事件推送**

```xml
<xml>
  <ToUserName><![CDATA[toUser]]></ToUserName>
  <FromUserName><![CDATA[FromUser]]></FromUserName>
  <CreateTime>123456789</CreateTime>
  <MsgType><![CDATA[event]]></MsgType>
  <Event><![CDATA[subscribe]]></Event>
  <EventKey><![CDATA[qrscene_123123]]></EventKey>
  <Ticket><![CDATA[TICKET]]></Ticket>
</xml>
```

**用户已关注时的事件推送**

```xml
<xml>
<ToUserName><![CDATA[toUser]]></ToUserName>
<FromUserName><![CDATA[FromUser]]></FromUserName>
<CreateTime>123456789</CreateTime>
<MsgType><![CDATA[event]]></MsgType>
<Event><![CDATA[SCAN]]></Event>
<EventKey><![CDATA[SCENE_VALUE]]></EventKey>
<Ticket><![CDATA[TICKET]]></Ticket>
</xml>
```

+ Response

  ```xml
  <xml>
  <ToUserName><![CDATA[toUser]]></ToUserName>
  <FromUserName><![CDATA[fromUser]]></FromUserName>
  <CreateTime>12345678</CreateTime>
  <MsgType><![CDATA[text]]></MsgType>
  <Content><![CDATA[欢迎关注，点击进入 xx 科室]]></Content>
  </xml>
  ```

**3. 科室二维码列表 管理后台使用**

GET /api/admin/nurses/msg/wx/qrcode-list

+ Response

  ```json
  {
    "result" : {"success" : true},
    "department" : [
      {
        "id" : 1,
        "name" : "309脊柱",
        "qrcodeUrl" : "http://qrcode/me.jpg"
      }
    ]
  }
  ```

  ​

## 排期

| 时间            | 完成                      | 负责人            |
| ------------- | ----------------------- | -------------- |
| 2016.12.2（周五） | 完成协和科室的二维码的生成 + 数据库读取接口 | 丁天奇 & 黄英       |
| 2016.12.3（周六） | 完成 callback             | 丁天奇 & 黄英       |
| 2016.12.5（周一） | 完成前端管理页面                | 劭杰             |
| 2016.12.5（周一） | 完成接口测试及联调               | 丁天奇 & 黄英 & 张正宇 |
| 2016.12.6（周二） | 上线                      | 学文             |

## 上线

![deploy](https://cloud.githubusercontent.com/assets/698482/20934513/5dfbc59e-bc16-11e6-9180-910cebc01418.jpg)

## Wiki维护人

刘明敏


