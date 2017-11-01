---
title: 授权管理中心 MentalSeal 项目 PRD & 开发日志
date: 2017-02-15 21:20:00
categories: 运营
tags:
- 运营系统
- PRD
---

### 摘要

随着运营系统变多，登录、权限管理变得困难。目前迫切需要

- 统一的权限管理
- 统一的用户管理

因此，将运营类系统分为两类：

- 授权管理中心，也就是 MentaSeal，负责权限的管理
- 各类运营管理系统，本文档表述为 App, 完成具体运营业务的逻辑实现，如：优护助手护士审核系统、订单运营系统

现有的 Yolar 项目已经解决了部分「统一的用户管理」的问题，只需要再加入 `用户统一注册和登录` 即可。

MentalSeal 项目(授权管理中心<sup>1</sup>)因运而生，除了「统一的权限管理」外，还提供了：

- 与其他项目的运营管理系统对接，方便做权限校验
- 一个全新的、重新设计的 WEB 界面

在 MentalSeal 完成权限配置后，App 可以按照 RoleEnum 中的 `id` 完成对角色的定义，决定授予哪些权限。

<!--more-->

### 文档更新
时间|内容|维护人
---|---|---
2017-2-16|创建文档|田学文
2017-2-22|更新文档|袁鑫
2017-2-23|更新接口|田学文
2017-3-2|review 后修改|田学文
2017-3-6|kick off|袁鑫

### 设计使用场景

比如「优护助手人员审核」项目需要针对运营人员作权限控制，实现不同角色的运营人员操作权限不同。

**预配置**
1. Admin 注册
2. 创建 App 属性有 name, path, description
3. 创建 Role 属性有 name, remark
4. 给Admin分配权限
5. 完成预配置
![](/media/mentalseal.png)

**App中权限校验**
1. App 对用户权限校验时，向 MentalSeal 请求当前 admin 的权限信息？
2. App 自行判定该用户权限
3. 执行业务逻辑

### 设计模型
**Admin(yolar 中 admin)**
用户，描述用户基本信息。

- id 用户ID
- name 用户名称
- phone 用户手机
- password 密码

**Role**
角色，描述用户的角色身份信息，比如「运营专员」、「运营主管」等

- id 角色 ID
- appId 应用 ID
- name 角色名称
- description 角色详细描述，包括详细的权限描述
- remark 角色备注

备注：Role 中的每个记录都对应 RoleEnum 中的一个成员。

**AdminRole Mapping**
- admin
- role

**App**
系统，二方管理系统，需要使用 MentalSeal 中的用户、角色、权限信息的系统。描述某个用户是否有权限接入系统的管理页面。

- id
- name 二方管理系统名称
- description
- path
- app_secret


**统一登录**
![](/media/yolarloginclass.png)

### Talk is Cheap, Show Me the Code
演示代码

**用户登录后显示运营入口**
```java
Admin = Admin.getByPhone
List<App> appList = appBO.findByAdminId(Admin.getId)
```

**权限校验**
```java
message AdminDTO {
  optional int64 id;
  optional string name;
  optional string phone;
  optional Role role;

  message Role {
    optional int64 id;
    optional string name;
    optional string description;
  }
}

MentalSeal.AdminDTO
currentAdmin = MentalSealClient.getAdminByAdminIdAndAppId(AdminId,appId,appSecret)

if (currentAdmin.hasRole(ADMIN_ROLE)) {
    // do something
} else {
    throw new YHJException(FooSystemException.NoPermitException);
}
```



### 数据库设计
**admin2 (yolar.admin)**
与 SwordKeeper 中涉及到的Admin表冲突，yolar中的原有 Admin 的迁移分为四步：

1. 先临时把表名定位Admin2，开发统一登录逻辑
2. 重构 SwordKeeper 使其使用 MentalSeal 的权限管理
3. 删除 Admin 表相关的逻辑
4. 将 Admin2 表 改为 Admin

```SQL
CREATE TABLE IF NOT EXISTS `Admin2` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(512) NULL COMMENT '姓名',
  `token` VARCHAR(512) NULL COMMENT 'token',
  `phone` VARCHAR(255) NULL COMMENT '电话',
  `remark` VARCHAR(512) NULL COMMENT '备注',
  `type` TINYINT NOT NULL DEFAULT 0 COMMENT '人员类型, 如运营、管理员',
  `status` TINYINT NOT NULL DEFAULT 0 COMMENT '状态, 见 Admin 状态枚举',
  `password` VARCHAR(255) NULL COMMENT '加密后的密码',
  `salt` VARCHAR(255) NULL COMMENT '加密参数',
  `avatar_url` varchar(512) DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Admin_phone_uiq` (`phone`)
）ENGINE = InnoDB DEFAULT CHARSET=utf8;
```

**admin_role**
```SQL
CREATE TABLE IF NOT EXISTS `admin_role` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `admin_id` BIGINT UNSIGNED NOT NULL,
  `role_id` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `admin_role_unique_idx` (`admin_id`,`role_id`),
  KEY `admin_role_role_id_fk_idx` (`role_id`),
  CONSTRAINT `admin_role_role_id_fk` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB DEFAULT CHARSET=utf8;
```

**role**
```SQL
CREATE TABLE IF NOT EXISTS `role` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(512) NULL COMMENT '角色名称',
  `description` VARCHAR(512) NULL COMMENT '权限详细描述',
  `app_id` BIGINT UNSIGNED NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `role_app_id_fk_idx` (`app_id`),
  CONSTRAINT `role_app_id_fk` FOREIGN KEY (`app_id`) REFERENCES `app` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB DEFAULT CHARSET=utf8;
```

**app**
```SQL
CREATE TABLE IF NOT EXISTS `app` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `secret` VARCHAR(512) NULL COMMENT 'app secret',
  `name` VARCHAR(512) NULL COMMENT '应用系统名称',
  `description` VARCHAR(512) NULL COMMENT '应用详细描述',
  `path` VARCHAR(512) NULL COMMENT '子页面跳转路径',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE = InnoDB DEFAULT CHARSET=utf8;
```

### 类模型

```
com.youhujia.mentalseal
    |- MentalSealController
        |=> public MentalSeal.RoleList getAdminByAdminIdAndAppId()
    |- MentalSealBO
        |=> public MentalSeal.RoleList getAdminByAdminIdAndAppId()
        |=> private List<Role> getRoleListByAdminIdAndAppId()
    |- role
        |- AdminRoleBO
        |- RoleBO
        |- Role
        |- RoleContext
        |- RoleDAO
        |- RoleController
            |=> addRoleToApp
            |=> getRolesByAppId(getAppByAppId)
            |=> addRoleToAdmin(updateAdmin)
            |=> updateRolesToAdmin(updateAdmin)
    |- app
        |- AppBO
        |- App
        |- AppContext
        |- AppDAO
        |- AppController
            |=> createApp
            |=> updateApp
            |=> getAppByAppId
            |=> getAllApp

com.youhujia.yolar
    |- admin
        |- AdminBO
            |=> createAdmin
            |=> getAdminById
            |=> updateAdminById
            |=> getAdminByPhone
            |=> resetToken

        |- Admin
        |- AdminDAO
        |- AdminController
            |=> Admin2DTO createAdmin(Admin2AddOption option)
            |=> Admin2DTO getAdminById(Long adminId)
            |=> Admin2DTO updateAdminById(Long adminId, Admin2UpdateOption option)
            |=> Admin2DTO getAdminByPhone()
            |=> Admin2DTO resetToken()

com.youhujia.era
    |- phone
        |- captcha
            |- CaptchaBO
            |- CaptchaController
                |=> sendPhoneCaptcha
    |- login
        |- LoginBO
            |=> adminLoginByPhoneAndPassword
            |=> adminLoginByPhoneAndCaptcha
            |=> resetPasswordByPhoneCaptcha
        |- LoginContext
        |- LoginController
            |=> adminLoginByPhoneAndPassword
            |=> adminLoginByPhoneAndCaptcha
            |=> resetPasswordByPhoneCaptcha            
    |- signup
        |- SignupBO
            |=> adminSignupByPhoneAndPassword
            |=> adminSignupByPhoneAndCaptcha

```
### Yolar 相关接口

```protobuf
message Admin2AddOption {
  optional string name = 1;
  optional string phone = 2;
  optional string remark = 3;
  optional string avatarUrl = 4;
}

message Admin2UpdateOption {
  optional int64 adminId = 1;
  optional string name = 2;
  optional string remark = 3;
  optional string avatarUrl = 4;
  optional string token = 5;
  optional int64 type = 6;
  optional int64 status = 7;
  optional string password = 8;
}

message Admin2DTO {
  optional int64 adminId = 1;
  optional string name = 2;
  optional string phone = 3;
  optional string token = 4;
  optional string remark = 5;
  optional int64 type = 6;
  optional int64 status = 7;
  optional string password = 8;
  optional string salt = 9;
  optional string avatarUrl = 10;
  optional int64 createdAt = 11;
  optional int64 updatedAt = 12;
}
```



### 前端页面接口

**1. App 相关**
#### 1.1 App 列表

GET /api/mentalseal/v1/app

* response
```json
  {
    "result": {
        "success": true,
        "code": 0
    },
    "data":{
        "app":[
          {
            "appId": 1,
            "appName": "优护助手注册审核",
            "appSecret": "JFaBmcoJgspap1esX6pYY9Z6",
            "appPath": "order-management-system",
            "appDescription": "运营管理系统详细描述",
            "role": [
              {
                "roleId": 1,
                "roleName": "管理员",
                "roleDescription": "拥有所以权限"
              }
            ]
          }
        ]
    }

  }
```

#### 1.2 App 创建
POST /api/mentalseal/v1/app

* request
  ```json
  {
    "appName": "优护助手注册审核",
    "appPath": "order-management-system",
    "appDescription": "运营管理系统详细描述"
  }
  ```

* response
  ```json
  {
    "data": {
        "app":{
          "appId": 1,
          "appName": "优护助手注册审核",
          "appSecret": "JFaBmcoJgspap1esX6pYY9Z6",
          "appPath": "order-management-system",
          "appDescription": "运营管理系统详细描述"
        }
    },
    "result": {
      "success": true,
      "code": 0
    }
  }
  ```

#### 1.3 获取单个 App
GET /api/mentalseal/v1/app/{id}

* response
  ```json
    {
      "data":{
        "app":{
          "appId": 1,
          "appName": "优护助手注册审核",
          "appSecret": "JFaBmcoJgspap1esX6pYY9Z6",
          "appPath": "order-management-system",
          "appDescription": "运营管理系统详细描述",
          "role": [
            {
              "roleId": 1,
              "roleName": "管理员",
              "roleDescription": "拥有所以权限"
            }
          ]
        }
      },
      "result": {
          "success": true,
          "code": 0
      }
    }
  ```

#### 1.4 App 更新
PUT /api/mentalseal/v1/app/{id}

* request
  ```json
  {
    "appId": 1,
    "appName": "优护助手注册审核",
    "appDescription": "运营管理系统详细描述"
  }
  ```

* response
  ```json
  {
    "data":{
      "app":{
        "appId": 1,
        "appName": "优护助手注册审核",
        "appSecret": "JFaBmcoJgspap1esX6pYY9Z6",
        "appPath": "order-management-system",
        "appDescription": "运营管理系统详细描述",
        "role": [
          {
            "roleId": 1,
            "roleName": "管理员",
            "roleDescription": "拥有所以权限"
          }
        ]
      }
    },
    "result": {
        "success": true,
        "code": 0
    }
  }
  ```

#### 1.5 App 添加角色
POST /api/mentalseal/v1/app/{id}/role

* request
  ```json
  {
    "roleName": "管理员",
    "roleDescription": "拥有所以权限"
  }
  ```

* response
  ```json
  {
    "data": {
      "roleId": 1,
      "roleName": "管理员",
      "roleDescription": "拥有所以权限"
    },
    "result": {
      "success": true,
      "code": 0
    }
  }
  ```


**2. 运营人员相关**
#### 运营人员列表，包括搜索
GET /api/mentalseal/v1/admin?phone=18614041815&appId=1

> 参数 phone 和 appId 可选

```JSON
{
  "data":{
    "draw":1
    "recordsTotal":241,
    "recordsFiltered":5,
    "admin": [
      {
        "adminId": 1,
        "name": "刘李",
        "phone": "18614041815",
        "status": 0, // 0 禁用 1 激活
        "remark": "xxxxx",
        "avatarUrl": "http://xxx",
        "updatedAt": 1487839654,
        "createdAt": 1487839654
      }
    ]
  },
  "result": {
    "success": true,
    "code": 0
  }
}
```

#### 2.3 新建运营人员

POST /api/mentalseal/v1/admin

* Request
  ```JSON
  {
    "name": "刘莉",
    "phone": "18614041815"，
    "remark": "xxxxxxxxx"
  }
  ```

* Response

  ```JSON
  {
    "data":{
      "admin":{
        "adminId": 1,
        "name": "刘李",
        "phone": "18614041815",
        "status": 1, // 0 禁用 1 激活
        "remark": "xxxxxxxxx",
        "avatarUrl": "http://xxx",
        "updatedAt": 1487839654,
        "createdAt": 1487839654
      }
    },
    "result": {
      "success": true,
      "code": 0
    }
  }
  ```


#### 2.4 获取运营人员信息, 包括 App 权限信息

GET /api/mentalseal/v1/admin/{id}

```JSON
{
  "data":{
    "admin":{
      "adminId": 1,
      "name": "刘李",
      "phone": "18614041815",
      "status": 1, // 0 禁用 1 激活
      "remark": "xxxxxxxxx",
      "avatarUrl": "http://xxx",
      "updatedAt": 1487839654,
      "createdAt": 1487839654,
      "app":[
        {
          "appId": 1,
          "appName": "优护助手注册审核",
          "appSecret": "JFaBmcoJgspap1esX6pYY9Z6",
          "appPath": "order-management-system",
          "appDescription": "运营管理系统详细描述",
          "role": [
            {
              "roleId": 1,
              "roleName": "管理员",
              "roleDescription": "拥有所以权限"
            }
          ]
        }
      ]
    }
  },
  "result": {
    "success": true,
    "code": 0
  }
}
```

#### 2.5.0 更新运营人员（基本信息、App 角色）

PUT /api/mentalseal/v1/admin/{id}

```JSON
{
  "name": "刘李",
  "remark": "xxxxxxxxx",
  "avatarUrl": "http://xxx",
  "app":[
    {
      "appId":1,
      "role":[
        {
          "roleId":1
        }
      ]
    }
  ]
}
```

* Response

```JSON
{
  "data":{
    "admin":{
      "adminId": 1,
      "name": "刘李",
      "phone": "18614041815",
      "status": 1, // 0 禁用 1 激活
      "remark": "xxxxxxxxx",
      "avatarUrl": "http://xxx",
      "updatedAt": 1487839654,
      "createdAt": 1487839654,
      "app":[
        {
          "appId": 1,
          "appName": "优护助手注册审核",
          "appSecret": "JFaBmcoJgspap1esX6pYY9Z6",
          "appPath": "order-management-system",
          "appDescription": "运营管理系统详细描述",
          "role": [
            {
              "roleId": 1,
              "roleName": "管理员",
              "roleDescription": "拥有所以权限"
            }
          ]
        }
      ]
    }
  },
  "result": {
    "success": true,
    "code": 0
  }
}
```

#### 2.5.1 更新运营人员（状态）

PATCH /api/mentalseal/v1/admin/{id}/

```JSON
{
  "status": 1
}
```

* Response

```JSON
{
  "data":{
    "admin":{
      "adminId": 1,
      "name": "刘李",
      "phone": "18614041815",
      "status": 1, // 0 禁用 1 激活
      "remark": "xxxxxxxxx",
      "avatarUrl": "http://xxx",
      "updatedAt": 1487839654,
      "createdAt": 1487839654,
      "app":[
        {
          "appId": 1,
          "appName": "优护助手注册审核",
          "appSecret": "JFaBmcoJgspap1esX6pYY9Z6",
          "appPath": "order-management-system",
          "appDescription": "运营管理系统详细描述",
          "role": [
            {
              "roleId": 1,
              "roleName": "管理员",
              "roleDescription": "拥有所以权限"
            }
          ]
        }
      ]
    }
  },
  "result": {
    "success": true,
    "code": 0
  }
}
```


#### 2.6 登录

登录时， `password` 字段的值为密文

POST /api/mentalseal/v1/login/password

```json
{
  "phone": "18614041815",
  "password": "asdanbdskjahj2h3kjh1ufbsdl/",
}
```

* Response

```JSON
{
  "data":{
    "admin":{
      "adminId": 1,
      "name": "刘李",
      "phone": "18614041815",
      "status": 1, // 0 禁用 1 激活
      "remark": "xxxxxxxxx",
      "avatarUrl": "http://xxx",
      "token": "dasdasdasdasd",
      "updatedAt": 1487839654,
      "createdAt": 1487839654,
      "app":[
        {
          "appId": 1,
          "appName": "优护助手注册审核",
          "appSecret": "JFaBmcoJgspap1esX6pYY9Z6",
          "appPath": "order-management-system",
          "appDescription": "运营管理系统详细描述",
          "role": [
            {
              "roleId": 1,
              "roleName": "管理员",
              "roleDescription": "拥有所以权限"
            }
          ]
        }
      ]
    }
  },
  "result": {
    "success": true,
    "code": 0
  }
}
```

#### 2.7 发送验证码

POST /api/era/v1/phone/captcha

```JSON
{
  "phone": "18614041815"
}
```

* Response
```JSON
{
  "result": {
    "success": true,
    "code": 0
  }
}
```

#### 2.8 重置密码
**loginRole:Admin 0 USER 1 NURSE 2 登录角色**

POST /api/era/v1/login/reset-password

```JSON
{
  "phone": "18614041815",
  "captcha": "1234",
  "password": "密码密文",
  "loginRole": 0
}
```

* Response

```JSON
{
  "result": {
    "success": true,
    "code": 0
  }
}
```



### 开发排期
内容|耗时|开发|进度
---|---|---|---
yolar 统一登录 接口开发 | 1|袁鑫|100%
era 统一登录 接口开发 | 1 |袁鑫|100%
mentalseal app CRUD 操作|1|袁鑫|100%
mentalseal role CRUD 操作|1|袁鑫|100%
Admin 权限 查询 接口 | 0.5|袁鑫|90%
后端接口 统一测试|1|袁鑫|90%
前端页面开发|2|前端同学|0%
前端接口开发|3|前端同学|0%
前后端联调|1|袁鑫&前端同学|0%
testing|2|郑旭红|0%
Staging & Production | 1|郑旭红|0%

### 开发日志

#### 2017-3-7
**今日进度**
- 完成yolar统一登录 接口开发
- mentalseal app & role CRUD 操作完成50%

**明日安排**
- 完成mentalseal app & role CRUD 操作
- 配合前端做接口Mock测试

#### 2017-3-8

**今日进度**
- 测试护士辅助下单功能的dimension和dna
- 完成mentalseal app & role CRUD 操作
- 完成mentalseal admin的操作

**明日安排**
- mentalseal自测(除登录)
- era的登录开发
- 配合前端做接口Mock测试

#### 2017-3-9

**今日进度**
- mentalseal自测
- era的登录开发
- gataway中mentalseal的配置开发及测试

**明日安排**
- mentalseal admin 权限查询接口
- 配合前端做接口Mock测试

#### 2017-3-10

**今日进度**
- 修复PUSH系统BUG
- era的登录完善
- 配合前端做接口Mock测试

**明日安排**
- mentalseal admin 权限查询接口
- 自测

#### 2017-3-11

**今日进度**
- mentalseal admin 权限查询接口
- 自测

**明日安排**
- 前后端联调

#### 2017-3-13

**今日进度**
- 前后端联调50%

**明日安排**
- 前后端联调
- develop环境测试

#### 2017-3-14
总体延期一天，因多项目开发，测试人员排期较满，可能会延期
**今日进度**
- 前后端联调75%
- 代码重构

**明日安排**
- 前后端联调
- develop环境测试
