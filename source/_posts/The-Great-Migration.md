---
title: 优护家公众号迁移 详细设计
date: 2017-2-21 15:30:00
categories: wechat
tags:
- wechat
---

# 摘要

优护家公众号迁移 详细设计

<!-- more -->

# 优护家公众号迁移 详细设计

## 背景

之前的 优护创智 公众号因为经营范围不妥，需要更换到新公众号：优护家。

## 设计目标
优护家公众号迁移后，老用户的数据不受影响。

## 流程
1. 用户在新公众号授权登陆后，在返回的接口里新添字端，告知前端还需 redirect 到微信授权页面，获取该用户在旧公众号下的 OldOpenID
2. 查看 OldOpenID 是否对应已有用户
3. 如果无，按正常流程执行
4. 如果存在旧用户，将该用户迁移到对应旧用户下，并更新 OpenID
5. 对该用户标记 Flag，下次登录时，无需上述额外 redirect

## 接口

### 登录

**POST /api/era/v1/users/signin/XXXXXNew-Open-IDXXXXXXX**

其中去往微信的url中携带的callbackUrl为固定的前端地址，确定为：/ns/take-deprecated-wx-account-token

+ Response

  ```json
  {
    "result" : {"success" : true,
                "code":0
                },
    "token" : "auth-token-xxxxxxx",
    "redirect" : "https://open.weixin.qq.com/connect/oauth2/authorize?xxxxxx"
  }
  ```

### 尝试迁移旧用户

**POST /api/era/v1/users/migrate-old-wx/XXXXXOld-Open-IDXXXXXXX**

+ Response

  ```json
  {
    "result" : {"success" : true,
                "code":0},
    "token" : "auth-token-xxxMay-Changexxxx"
  }
  ```

## 数据库修改

在 Person 表中添加一个 flag 字端，该字段以 json 的方式存储该 Person 是否已做过迁移处理(之后也可用来存储其他类似信息)，以避免重复操作。

```sql
'db migartion

alter table person add flag varchar(2014)
```

## 代码

登录时检查用户是否已经做过迁移处理

```java
Person p = getPersonByOpenID(openId);

boolean hasMigrated = checkIfHasMigrated(p.flag);

if(!hasMigrated){
  return resp with redirect to old wx-account to get oldOpenId
}
```

获取旧 OpenID 后，做旧数据迁移

```java
String OldOpenId;
String newOpenId;

WxProfile oldProfile = findWxProfileByOpenId(oldOpenId);
if(exist(oldProfile)){
  deleteWxProfileByOpenId(newOpenId);
  
  oldProfile.setOpenID(newOpenId);
  save(oldProfile);
  
  return oldProfile.person.authToken;
}else{
  return findWxProfileByOpenId(newOpenId).person.authToken
}
```

## 备忘

需要修改配置的相关项目：

1. 支付
2. 微信模版消息
3. 之前根据生成的公众号二维码，需删除后重新生成
4. …more

## 补充
用户登录时序图![mig_login](/media/mig_login.png)

数据迁移流程图![mig](/media/mig.png)

## 排期

| Date       | Content     | Man-Day |
| ---------- | ----------- | ------- |
| 2017-02-21 | 设计          | 1       |
| 2017-02-22 | 开发          | 1.5     |
| 2017-03-01 | 自测 | 1    |
| 2017-03-02 | 提测 | 0.5     |
| 2017-03-03 | 部署          | 1       |

## 项目日报


2017-03-03：
本日完成：完成优护家公众号迁移自测。
明日计划：统计更换公众号APPId对其他项目的影响，同时与正宇和UI同学确认访问老公众号引导用户到新公众号的形式（图片二维码或者是其他）。

2017-03-04：
本日完成：更换公众号影响CMS,era,gateway,kfb,singer,midas项目，已与相关人员沟通，确认迁移风险。迁移dev环境回归测试完成，老用户信息以及支付功能不受影响。老公众号引导到新公众号方案确定为二维码+图片（有强运营需求再配文字）。
明日计划：修改线上环境配置，部署。

2017-03-06：
本日完成：因为预发环境测试冲突，今天staging环境部署未完成，继续在dev环境测试，同时出迁移上线流程
明日计划：为了使用户进入迁移逻辑，需要reset 所有的token（包括护士），明天重点测试；修改线上环境配置，部署。

2017-03-07：
身体gg，请假

2017-03-08：
本日完成：token reset风险排除；dev环境测试结束，项目部署staging环境进行测试
明日计划：修改线上环境配置，部署。

2017-03-08：
本日完成：修改线上环境配置，部署，正式上线。

## 优护家公众号数据迁移上线流程：
1. 修改era,yolar,gateway中相关配置文件以,还原develop、release开发环境
2. era,yolar,halo,gateway项目release分支代码并进master分支
3. 修改config_repo 中master分支中era,cms,kfb,gateway,singer,difoil,dna,yolar,prod环境和docker_prod环境的配置
4. 重启服务，部署上线


