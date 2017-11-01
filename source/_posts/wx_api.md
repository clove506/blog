---
title: Wx API
date: 2017-05-18 22:50:00
categories: wx
tags:
- wx
---

# 摘要

WX API

<!-- more -->

## 类设计

### UserController

| 方法名                  | 参数                 | 返回值                 | 详情              |
| -------------------- | ------------------ | ------------------- | --------------- |
| postWxJsConfigDTO    | wxJsConfigOption   | WxJsConfigDTO       | 获取wx的jssdk中wx.config所需参数 |
| getWxJsConfigDTO     | url                | WxJsConfigDTO       | 获取wx的jssdk中wx.config所需参数 |

## 获取wx的jssdk中wx.config所需参数

> **参照[微信JS-SDK说明文档](https://mp.weixin.qq.com/wiki)**

提供了Get和Post两个api方式

- **GET  /api/shooter/v1/users/wx-config?url={url}**
- **POST /api/shooter/v1/users/wx-config**

> Post Request:

```protobuf
message WxJsConfigOption {
    optional string url = 1;
}
```

其中，get和post的url的意思参照微信文档为：url（当前网页的URL，不包含#及其后面部分）

> Get/Post Response

```protobuf
message WxJsConfigDTO {
    message Config {
        optional string nonceStr = 1;
        optional string timestamp = 2;
        optional string url = 3;
        optional string signature = 4;
        optional string appId = 5;
    }
    message Data {
        optional Config config = 1;
    }
    optional Result result = 1;
    optional Data data = 2;
}
```

> response example

```json
{
  "result": {
    "success": true,
    "code": 0
  },
  "data": {
    "config": {
      "nonceStr": "19529304-4f14-42f9-95db-c805409dcdca",
      "timestamp": "1495101189",
      "url": "http://www.baidu.com",
      "signature": "552046b36c9d7e265e1bb44a8c10d7b4041d71f3",
      "appId": "wx66a47b413c596031"
    }
  }
}
```

