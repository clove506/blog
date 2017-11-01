---
title: 优护家项目 PRD & 开发日志 模板
date: 2017-02-27 11:50:00
categories:  PRD & 开发日志 模板
tags:
- PRD
- 模板
---

# 摘要

项目概述，这部分努力做到让项目无关的人阅读完「摘要」后，能基本理解该项目。

摘要应该包含：

1. 项目的背景，即需求产生的背景
2. 怎么实现需求、处理需求带来的问题
3. 项目预期

以上可以理解为：我是谁？我中哪里来？我要去哪里？

<!--more-->

# 文档更新
每次更新文档后，应该维护更新记录。如下：

时间|内容|维护人
---|---|---
2017-2-16|创建文档|田学文
2017-2-22|更新数据库设计部分|袁鑫


# 设计使用场景

枚举所有需求场景，从使用者角度枚举所有功能。如下：

某个开发好的 App 需要对运营者 User 分角色 Role 多级授权。

**预配置**
1. User 注册
2. 创建 Group 和 Role，属性有 name, remark
3. 分配 User 至 Group (optional)
4. 将 User 或 Group 加入 Role
5. 完成预配置

**App中权限校验**
1. System 系统对用户权限校验时，向 Billion 请求当前 user 是否满足特定的 Role？
2. 接口返回 true | false
3. 执行业务逻辑

# 功能点描述

# 模型设计

这里详细描述模型的设计，包括：

1. 总的模型设计框架
2. 每个功能点的设计
3. 关键概念的图表展示（如果需要）

# 数据库设计

这里要直接贴出数据库的初始化 SQL，如：

**user**
```SQL
CREATE TABLE IF NOT EXISTS `user` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(512) NULL COMMENT '姓名',
  `token` VARCHAR(512) NULL COMMENT 'token',
  `phone` VARCHAR(255) NULL COMMENT '电话',
  `remark` VARCHAR(512) NULL COMMENT '备注',
  `type` TINYINT NOT NULL DEFAULT 0 COMMENT '人员类型, 如运营、管理员',
  `status` TINYINT NOT NULL DEFAULT 0 COMMENT '状态, 见 User 状态枚举',
  `password` VARCHAR(255) NULL COMMENT '加密后的密码',
  `avatar_url` varchar(512) DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_phone_uiq` (`phone`)
）ENGINE = InnoDB DEFAULT CHARSET=utf8;
```


# Talk is Cheap, Show Me the Code
这里贴 演示代码，如果需要。

# 接口文档

提供给其他服务，如客户端、网页，使用的 API 接口文档。如下：

** App 创建**

POST /api/mentalseal/v1/app

* Request
  ```json
  {
    "appName": "优护助手注册审核",
    "appPath": "order-management-system",
    "appDescription": "运营管理系统详细描述"
  }
  ```

* Response
  ```json
  {
    "appId": 1,
    "appName": "优护助手注册审核",
    "appSecret": "JFaBmcoJgspap1esX6pYY9Z6",
    "appPath": "order-management-system",
    "appDescription": "运营管理系统详细描述",
    "result": {
      "success": true,
      "code": 0
    }
  }
  ```

# 开发排期
具体的项目排期，精确到每个人每天做什么，如下：

内容|耗时/人日|开发者
---|---|---
app develop|1|袁鑫
role develop|1|袁鑫
user develop|2|袁鑫
login develop|1|袁鑫
self testing|1|袁鑫
joint debugging|1|袁鑫


# 开发日志

这里每天更新该项目的开发日志，即每日进度，如下：

### 2017-02-25

**今日**

- 优护助手注册审核 & 人员管理（科秘，管理员等），增删改查，设置权 &
    * 着手开始，还未形成文档

- 优护助手启动页设置
    * 交互小幅度调整，需要重新设计

- 护士上门护理客服系统
    * 迁移方案 尚未开始

- 通用设置：添加子系统，设置子系统名称，管理子系统人员及其权限。
    * 项目细节需要调整，准备 kick off

- 内容管理系统（媒体库）（随访，自测，评估）
    * 尚未开始

**明日**

- 优护助手注册审核 & 人员管理（科秘，管理员等），增删改查，设置权 &
    * 产出 PRD 文档

- 优护助手启动页设置
    *  Kick Off
