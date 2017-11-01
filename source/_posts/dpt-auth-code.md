---
title: 科室的 AuthCode 的设计
date: 2017-01-05 21:47:13
categories: design
tags:
- design
- tag
---

# 摘要

关于科室的 AuthCode 的设计

<!--more-->

# 定义

之前 KFB 中，部分科室要求用户扫码后，还需要填写预设的验证码才能进入科室，现在 KFB 迁移，相关逻辑需要移到新系统中，决定用 Tag 来实现该功能。

## Design

通过 `AuthCodePass` tag 来实现。Tag 相关见：http://wiki.office.test.youhujia.com/2017/01/05/tag/

## API

### 1. 验证 AuthCode

Era 提供接口

**POST /api/era/v1/users/auth-code**

+ Request

  ```json
  {"authcode" : "asdfdsf"}
  ```

+ Response

  ```json
  {"result" : {"success" : true}}
  ```

### 2. 未验证用户进入需验证码的科室

Gateway 做权限的校验

**GET or POST /un-authed-user/try/any/address/needs/auth_code**

+ Old Response [kfb resp](https://github.com/Youhujia/docs/blob/master/backend/kfb/KFB-API-Backup.md#访问受限科室页-yh-apinsrandom-resource-need-passcode)

  + Header 401
  + Resp:
    ```json
    {
      "is_passcode_right": false, 
      "un-authed": true, 
      "un-authed-resource": "passcode"
    }
    ```

+ New Response

  ```json
  {
    "result" : 
      {
        "success" : false,
        "code" : 401,
        "msg" : "dpt needs auth code",
        "msgfordisplay" : "需要科室验证码"
      }
  }
  ```

  ​