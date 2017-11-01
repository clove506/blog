---
title: 【优护助手】启动页项目PRD及其开发日志
date: 2017-02-21 17:20:00
categories: 运营
tags:
- 优护助手
- 运营系统
- PRD
- 启动页面
---

## 摘要
目前优护助手的启动页比较单一，为了使之多样化、可配置、预发布，此项目应运而生。为提供功能
- 配置静态页、引导页、广告页的启动页面
- 设定启动页面的样式（静态页、引导页、广告页三选一）

其中，App 启动页的具体逻辑流程如下：

<!--more-->

![](/media/AppLauncherDiagram.svg)

### 文档更新
时间|内容|维护人
---|---|---
2017-2-21|创建文档|田学文
2017-2-23|更新文档|袁鑫
2017-3-1|更新配置中心部分|田学文


### 设计使用场景
**App 客户端配置**

1. 向服务器请求 App 配置中心
2. 比较各项配置版本和本地配置版本是否一致
3. 对于配置版本不一致的部分，请求该配置对应接口，重新获取数据，重置版本

**启动页面配置**
1. 确定启动页面样式, 如：
    - 静态 logo & slogan(DEFAULT)
    ![](/media/defalutStartPage.png)
    - 多张图片引导
    ![](/media/activeStartPage.png)
    - 广告页面
    ![](/media/adStartPage.png)
2. 选定启动页面


**App 启动**
1. App 第一次启动后，加载本地启动页配置
2. 请求服务器获取启动页配置
2. 时间满足配置「生效时间」 后，修改下一次启动配置
3. App 第二次启动加载当前配置

**创建流程**
![](/media/launcher.png)

### 交互设计
![](/media/单页.jpg)
![](/media/多图.jpg)
![](/media/链接.jpg)
![](/media/启动页列表.jpg)

### 设计模型

#### 类模型
**Launch**

```
com.youhujia.galaxy.launcher
    |- LauncherController
        |=> public getStartPageInfo()
        |=> public saveStartPage()
        |=> public updateStartPageDefault()
        |=> public updateStartPageActive()
    |- LauncherBO
    |- StyleEnum
        |=> SINGLE_IMG(1)
        |=> AD(2)
        |=> MULT_IMG(3)

```
#### 配置中心 数据库设计

不需要数据库，直接存储在 CMS 中的 temlate 中，将上述 JSON 直接存储在 template 中的 `content` 字段中。如下：

```json
{
    "data": {
      "appLauncherVersion": "1487831349",
      "appVersionManagerVersion": "1487831349",
    },
    "result": {
        "success": true,
        "code": 0
    }
}
```

其中：

- `appLauncherVersion` 是 App 启动页配置的版本
- `appVersionManagerVersion` 是 App 版本配置接口的版本

当客户端请求配置中心拿到所有的配置项版本后， 比对每一项的版本和本地配置的版本，不一致时，去相应的接口请求最新的配置版本。

当具体的配置，比如**App Launcher**配置改动后，主动去「配置中心」修改对应版本。

#### App Launcher 数据库设计

不需要数据库，直接存储在 CMS 中的 temlate 中，将上述 JSON 直接存储在 template 中的 `content` 字段中。如下：

**version: 为更新时间戳，做版本标识，用于客服端版本识别**
**style: 为当前设定的启动页样式（见类模型的StyleEnum）**
**launcherId: 为标识每一个launcher，比如设置默认启动项，在default中存的就是launcherId**
**card: 单个启动页模板，可以组成多种启动页样式**

```
enum Style {
    SINGEL = 0;
    MULTI = 1;
    AD = 2;
}
```

```json
{
  "id": 24,
  "type": 10,
  "content": {
      "launcher":[
          {
            "launcherId": 1,
            "name": "春节",
            "card": [
              {
                "image": "http://youhujia.com/image.jpeg",
                "iosLink": "schema://app/path/to/page",
                "androidLink": "schema://app/path/to/page"
              }
            ],
            "style": 1,
            "active": true,
            "startTime":1487831349000,
            "endTime":1487831388000
          }
        ],
        "defaultLauncherId":1
  }
}
```


对配置的修改则通过修改 CMS 模板来完成。
#### 客户端接口数据展示
**获取launcher列表**
**GET /api/galaxy/v1/version**

* response
```json
{
    "data": {
      "appLauncherVersion": 1487831349,
      "appVersionManagerVersion": 1487831349,
    },
    "result": {
        "success": true,
        "code": 0
    }
}
```

#### 前端接口数据展示
**获取launcher列表**
**GET /api/galaxy/v1/launcher/zhushou/info**

* response
```json
{
    "data": {
        "launcher":[
          {
            "launcherId": 1,
            "name": "春节",
            "card": [
              {
                "image": "http://youhujia.com/image.jpeg",
                "iosLink": "schema://app/path/to/page",
                "androidLink": "schema://app/path/to/page"
              }
            ],
            "style": 1,
            "active": true,
            "startTime":1487831349000,
            "endTime":1487831388000
          }
        ],
        "defaultLauncherId":1
    },
    "result": {
        "success": true,
        "code": 0
    }
}
```

**添加新launcher**
**POST /api/galaxy/v1/launcher/zhushou**

* request
```json
{
    "style": 1,
    "name": "春节",
    "card": [
      {
        "image": "http://youhujia.com/image.jpeg",
        "iosLink": "schema://app/path/to/page",
        "androidLink": "schema://app/path/to/page"
      }
    ],
    "startTime":1487831349000,
    "endTime":1487831388000
}
```

* response
``` json
{
    "data": {
      "launcher":{
        "launcherId": 1,
        "style": 1,
        "name": "春节",
        "card": [
          {
            "image": "http://youhujia.com/image.jpeg",
            "iosLink": "schema://app/path/to/page",
            "androidLink": "schema://app/path/to/page"
          }
        ],
        "active": false,
        "startTime":1487831349000,
        "endTime":1487831388000
      }
    },
    "result": {
        "success": true,
        "code": 0
    }
}
```
**获取launcher**
**GET /api/galaxy/v1/launcher/zhushou/{id}**

* response
``` json
{
    "data": {
      "launcher":{
        "launcherId": 1,
        "style": 1,
        "name": "春节",
        "card": [
          {
            "image": "http://youhujia.com/image.jpeg",
            "iosLink": "schema://app/path/to/page",
            "androidLink": "schema://app/path/to/page"
          }
        ],
        "active": false,
        "startTime":1487831349000,
        "endTime":1487831388000
      }
    },
    "result": {
        "success": true,
        "code": 0
    }
}
```

**修改launcher**
**PUT /api/galaxy/v1/launcher/zhushou/{id}**

* request
```json
{
    "style": 1,
    "name": "春节",
    "card": [
      {
        "image": "http://youhujia.com/image.jpeg",
        "iosLink": "schema://app/path/to/page",
        "androidLink": "schema://app/path/to/page"
      }
    ],
    "startTime":1487831349000,
    "endTime":1487831388000
}
```

* response
``` json
{
    "data": {
      "launcher":{
        "launcherId": 1,
        "style": 1,
        "name": "春节",
        "card": [
          {
            "image": "http://youhujia.com/image.jpeg",
            "iosLink": "schema://app/path/to/page",
            "androidLink": "schema://app/path/to/page"
          }
        ],
        "active": false,
        "startTime":1487831349000,
        "endTime":1487831388000
      }
    },
    "result": {
        "success": true,
        "code": 0
    }
}
```

**设置默认launcher**
**PATCH /api/galaxy/v1/launcher/zhushou/default/{id}**

* request
```json
{
    "defaultLauncherId":1
}
```

* response
``` json
{
  "data": {
      "launcher":[
        {
          "launcherId": 1,
          "name": "春节",
          "card": [
            {
              "image": "http://youhujia.com/image.jpeg",
              "iosLink": "schema://app/path/to/page",
              "androidLink": "schema://app/path/to/page"
            }
          ],
          "style": 1,
          "active": true,
          "startTime":1487831349000,
          "endTime":1487831388000
        }
      ],
      "defaultLauncherId":1
  },
    "result": {
        "success": true,
        "code": 0
    }
}
```

**启动launcher**
**PATCH /api/galaxy/v1/launcher/zhushou/{id}**

* request
```json
{
    "active":true
}
```

* response
``` json
{
    "data": {
      "launcher":{
          "launcherId": 1,
          "style": 1,
          "name": "春节",
          "card": [
            {
              "image": "http://youhujia.com/image.jpeg",
              "iosLink": "schema://app/path/to/page",
              "androidLink": "schema://app/path/to/page"
            }
          ],
          "active": false,
          "startTime":1487831349000,
          "endTime":1487831388000
      }
    },
    "result": {
        "success": true,
        "code": 0
    }
}
```

**删除launcher**
**DELETE /api/galaxy/v1/launcher/zhushou/{id}**


* response
``` json
{
  "data": {
      "launcher":[
        {
          "launcherId": 1,
          "name": "春节",
          "card": [
            {
              "image": "http://youhujia.com/image.jpeg",
              "iosLink": "schema://app/path/to/page",
              "androidLink": "schema://app/path/to/page"
            }
          ],
          "style": 1,
          "active": true,
          "startTime":1487831349000,
          "endTime":1487831388000
        }
      ],
      "defaultLauncherId":1
  },
  "result": {
      "success": true,
      "code": 0
  }
}
```
### FAQ
#### APP首次启动时的新手引导页，是否会和其他引导页冲突
答：本次开发的启动页配置，是在APP启动后获取启动页信息，为下次启动做配置。所以首次启动时，还未加载新启动页信息，只会用新手引导页。

### 开发排期
内容|耗时|开发|进度
---|---|---|---
权限配置 开发 | 0.5|袁鑫|0%
客户端配置接口 开发 | 0.5|袁鑫|0%
原有的Version接口重构 | 0.5|袁鑫|0%
launcher启动页 开发 | 1|袁鑫|0%
前端开发 |1|李少华|0%
前端测试 |1|李少华|0%
后端自测 | 1|袁鑫|0%
客户端&后端联调 | 1|袁鑫&李少华|0%
testing | 0.5|郑旭红|0%
Staging & Production | 0.5|郑旭红|0%

### 开发日志
TBD
