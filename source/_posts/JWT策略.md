---
title: JWT多端登录策略
---
## 背景

* 目前，当以护士（以护士举例）身份登录web管理系统后，又以同一个护士账号登录APP，Web端会将强制退出该护士账号，也就是说，目前优护家Web管理系统和APP不支持同一个账号（护士）同时在线。

* 通过调研，计划利用JWT（Java Web Token）来升级目前优护家Token登录策略。

需要更新的逻辑：登录相关（Nurse&User&Admin），主要涉及以下项目：

* Gateway
* Yolar

## 流程

以护士身份为例：

![接口请求流程](https://img.wkcontent.com/assets/2017-07-17/48d9789f-94fd-4913-bee2-ec1ba9af39a3.png)


##  Token校验

![Token校验](https://img.wkcontent.com/assets/2017-07-17/f45d7e7b-88c8-4f56-92f9-648fdc2ac57d.png)

## 用户

* 护士
* 患者
* 管理员（admin）

## Gateway

主要涉及外部传入的Token Jwt解析和对比。

* 反序列化Token成json
* 调用yolar接口，获取保存在DB中的Token-json，进行对比，验证外部Token是否合法

## Yolar

主要涉及token JWT序列化，以及将Token-json信息存库。

* 生产token-json信息，存库
* JWT序列化json信息作为token，返回APP或Web
 

## 底层设计

### yolar

* admin、nurse、user三表中的token字段改存json串，需要将三表的token字段进行扩容，见附录MySQL，json串内容为：

    ```json
    "tokenInfo": {
          "pd": 20286,
          "pt": 0,
          "wt": "s1TMmpuc7mcV7lKcbHt9ldKfE3siKUk1VG7m6fNhMX7mJKiTYqx3eQyHHpDwr8ohxXZwJq7h9xUxqaIJj0yhmneM2Yr2M1ShwAmjQz7fD6wqImQyK7lviNLjj77tbdA2",
          "we":23232343433,
          "at": "s1TMmpuc7mcV7lKcbHt9ldKfE3siKUk1VG7m6fNhMX7mJKiTYqx3eQyHHpDwr8ohxXZwJq7h9xUxqaIJj0yhmneM2Yr2M1ShwAmjQz7fD6wqImQyK7lviNLjj77tbdA2",
          "ae":23232343334
        }
    ```

以下是「pType」的枚举类：

```Java
public enum PersonTypeEnum {
    NURSE(0L, "护士"),
    USER(1L, "患者"),
    ADMIN(2L, "管理员");
}
```

### 涉及接口

* 根据手机号和密码登录
>POST  /api/yolar/v3/login/phone-password
> Yolar.SimpleLoginDTO

* 根据手机号和验证码登录
>POST  /api/yolar/v3/login/phone-captcha
> Yolar.SimpleLoginDTO

* 根据手机验证码重置密码
>POST  /api/yolar/v3/login/reset-password
> Yolar.SimpleResponse

* 根据手机号和密码登录
>POST  /api/yolar/v3/login/phone-password
> Yolar.SimpleLoginDTO

* 注销
>POST  /api/yolar/v3/logout
> Yolar.SimpleResponse

## 数据迁移

编写Python脚本，进行数据迁移（针对admin、nurse、user三个表的token字段来进行编写脚本）

## 排期
<pre class="mermaid">
gantt
　　　dateFormat　YYYY-MM-DD
　　　title 重点项目甘特图
　　　
　　　section 多端登录及TokenJWT生成策略　　　　　
　　　PRD，设计，Kickoff :active, des1, 2017-07-17, 2017-07-17
　　　Yolar开发 : des2, after des1, 2017-07-18
　　　GateWay开发 : des3, after des2, 2017-07-19
　　　数据迁移 : des4, after des3, 2017-07-20
           测试&上线 : des5, after des4, 1d
　　　
</pre>

## 附录

### 1. Protobuf 定义

```protobuf
message TokenInfo {
    message TokenMetaData {
        optional int64 pId = 1;
        optional int64 pType = 2;
        optional string webToken = 3;
        optional int64 webTokenExpire = 4;
        optional string appToken = 5;
        optional int64 appTokenExpire = 6;
    }
    optional TokenMetaData tokenInfo = 1;
}

message SimpleLoginDTO {
    optional Data data = 1;
    message Data {
        optional string token = 1;
        optional int64 id = 2;
        optional LoginRole loginRole = 3;
        optional string redirectUrl = 4;
        optional TokenInfo tokenInfo = 5;
    }
    optional Result result = 2;
}

message Nurse {
    optional int64 nurseId = 1;
    optional int64 organizationId = 2;
    optional int64 departmentId = 3;
    optional string name = 4;
    optional int64 gender = 5;
    optional int64 birthday = 6;
    optional string phone = 7;
    optional string avatarUrl = 8;
    optional string token = 9;
    optional string idCard = 10;
    optional int64 personType = 11;
    optional int64 status = 12;
    optional string certs = 13;
    optional string photos = 14;
    optional string title = 15;
    optional int64 createdAt = 16;
    optional int64 updatedAt = 17;
    optional bool active = 18;
}

message NurseDTO {
    optional Result result = 1;
    optional Nurse nurse = 2;
}

```

### 2. MySQL

```MySQL
alter table admin modify column token TEXT DEFAULT NULL COMMENT '登录 TOKEN';
alter table nurse modify column token TEXT DEFAULT NULL COMMENT '登录 TOKEN';
alter table user modify column token TEXT DEFAULT NULL COMMENT '登录 TOKEN';
```
### 3. 引用参考
- [1], [JWT官网](https://jwt.io/)
- [2], [什么是 JWT -- JSON WEB TOKEN](http://www.jianshu.com/p/576dbf44b2ae)

## 项目总结

### 项目复盘

- 7月15日Token JWT化生成策略项目落地，正式KickOff，在此之前，林慧芝和卢江对JWT进行了调研，进行设计
- 7月17日林慧芝和卢江进入开发，涉及项目包括有Yolar、Gateway、Mentalseal、Shooter、Galaxy、Halo。
- 7月21日项目部署至staging环境，提测。
- 7月22日，在和学文Review代码后，发现问题，学文建议重构Gateway涉及的Token登录逻辑，修改底层Yolar服务，增加check-token接口。
- 7月24日卢江开始重构yolar和gateway。
- 7月25日dev环境回归测试。
- 7月26日staging环境回归测试。
- 7月27日修复staging环境回归测试发现的问题。
- 7月28日上线。

### 时间统计

| 内容                       | 开始时间  | 结束时间        | 天数   |
| ------------------------ | ----- | ----------- | ---- |
| 需求、设计、开发文档撰写             | 0715 | 0715       | 1天  |
| 开发+自测                    | 0717 | 0721       | 3天  |
| dev + staging 环境测试 | 0722 | 0722 | 1天  |
| 二期重构Yolar和Gateway               | 0724  | 0724       | 1天   |
| dev环境测试                      | 0725 |     0725        | 1天   |
| staging环境测试 + 修复bug                     | 0726 |     0727        | 2天   |
| 上线                      | 0728 |     0728        | 1天   |


###  总结

1. PRD 设计时间太短，对接前端Web系统的Mentalseal逻辑有问题，没提前搞清前端Token逻辑
   - 历史原因，前端请求后端接口携带的Token是登录成功之后获取角色信息中的Token。
3. 开发阶段速度比较正常，但有不足：代码的逻辑没能及时 review，避免走弯路，比如Yolar中途增加接口，Gateway改调新接口。



