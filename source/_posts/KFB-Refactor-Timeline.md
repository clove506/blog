---
title: 【合肥项目】KFB排期
date: 2016-12-14 00:00:00
categories: 合肥
tags:
- KFB
---

## 背景

KFB改造相关排期

<!--more-->

## WIKI维护人
mmliu

# 相关系统

## 用户系统的剥离

之前用户的微信登陆是在KFB中实现的，现在需要移动到Gateway中，添加微信登陆的逻辑。在给后端的请求中，添加`userId`， Owner: TBD， **BLOCKED**

## 静态资源的提供

之前部分静态资源是在KFB中提供的，比如 Angular App 初始化的 js 文件，这部分需要全部挪出，劭杰提供（1D）

## 用户的信息写入

用户微信登陆成功后，需要写入Yolar，有一些需要注意的细节：

1. 现在的user对应person，person之前要求必须有Phone，微信登陆的用户是没有电话的，这个需要修改。
2. 用户和nurse对应同一个person，peron中记录了auth token信息，如果每次登陆都reset token，会造成同一个号码的人，用户登陆后，护士端会自动登出。为了防止这种情况，可能需要用户登陆时，特殊处理，不reset token
3. 之前没有绑定号码的用户绑定手机后，需要迁移person记录（已有？）

Owner: TBD

## 科室，医院的建立

走原来的God，Admin端，实际数据操作，调用Yolar(接口已有？)

Org & Dpt id 和原 KFB 系统中的对应关系？

在优护助手端创建的科室和组织，在CMS端，不一定有对应数据（即不一定存在可供用户访问的前端）。需要提供前端，对还不存在CMS端的科室，新建记录。

在KFB中创建的科室&组织，在优护助手端，都将存在对应数据（实际的操作是先在KFB端创建科室信息，之后同步到Yolar中）。

综上：

* Yolar中的OrgId和KFB中的HospitalId（主键），需要保证一致
* Yolar中的DptId和KFB中的DptId（主键），也需要一致

现在在KFB后台，只露出有dptInfo的科室（即在KFB生成了的科室）与医院信息。

todo:

* 数据迁移方案（kfb <-> Yolar），将目前KFB中的所有科室医院，都导入到Yolar中（之前用户注册才触发）

## 前端请求中，添加dptNum

迁移后，调取user当前所处科室不再方便，之前接口普遍没有当前科室信息，现在前端需要加上（已完成，但需检查是否所有需要的接口都包含改信息）

## Gateway 添加科室校验逻辑

AuthCode

## 前端同学的修改

1. 数据接口地址改动，www.youhujia.com -> http://api.xxxxxxxxxxx.youhujia.com/ (api.user.youhujia.com?)
2. 提供 www.youhujia.com 下面的资源文件（html js css ）
3. （后台 需要修改 Nginx配置，接收 ）

# KFB重构

基本是体力活儿，排期见：

https://www.icloud.com/numbers/0m9InpsGOndvZFObUd0f9CjYg#timeline_of_refactor_kfb

不包含上述内容，单 **KFB重构**，需要人日：23

## 可能有坑的地方

1. HF旧的订单系统的WechatPay, 微信支付 支持三个授权目录，现在已经使用了三个，第一个应该可以去掉。。。 http://peihu.youhujia.com/charge/，留给新的支付地址
2. Admin & God 几乎全部的接口 及 部分老的User端代码，返回的不是数据接口，而是HTML页面。貌似没有什么问题。。。

## 详细排期
![](/media/14817451102463.jpg)


其中的GodAPI & Html Template 由丁天奇开发  SOA API 由 李圣阳 开发

最大单点是KFB自身的改造 11天 计划28日完成



# Time
## 2017.1.4 (周三)

* cms 服务相关接口完成

### todo

* AuthCode

## 2017.1.3 (周二)

* mmliu gateway 做了进一步的调试，其中 kfb的合肥服务页面需要shaojie配合迁移，shaojie可以7号开始。

###  TODO

  其中服务列表页面通过hack正常了（绕过gateway，直接访问kfb），如果shaojie时间不够，可以先修改合肥服务，携带Authorization Header（如果能再加上检测没有AuthCode，就去微信登陆就更好了。。。）

###  2016.12.29 (周四 x-th day)

* mmliu gateway 完成大半，设计做了调整，认证过程挪到了 Era 中，~~todo 拿到 token 后 routing 到 cms 似乎有问题~~ exception in zuulFilter, no log makes debug really difficult.
* shengyang, 重新设计了 后台系，todo 重排时间线,

## 2016.12.28 (周三 x-th day)

* mmliu gateway 基本 实验&实现了功能，re-organize code 70%
* shengyang, op backend redesign, impl tags & Standarlized Service template

### todo
* mmliu finish gateway

## 2016.12.27 (周二 x-th day)

* mmliu gateway 前两天调研了 spring securiy 改造的方案，结论是不用。。。今天按原有代码做了初步实验，基本没有坑，完成30%
* shengyang, dpt service tag & nurse service tag, hefei operation backend

## 2016.12.23 (周五 8th day)

### 完成

* 天奇回归战场，完成学习的收尾工作并喝了粥

### 进度

正常

### TODO
## 2016.12.21 (周三 6th day)

### 完成

* mmliu不在的第一天，想他
* 天奇，清理了God端的代码，学习
* ListenYoung，merge天奇的代码，进行了人生第一次的pull request review，打包部署测试服务器，和天奇一起进行功能测试和回归测试

### 进度

正常

### TODO

* 排查剩余的工作，清理漏掉的代码


## 2016.12.20 (周二 5th day)

### 完成

* 圣阳，优化SOA里神策相关接口的逻辑，加入protobuf对象，完成标准化服务接口API
* 天奇，清理了God端的代码，基本完成
* mmliu, 清理了SOA端的代码，几乎没有需要修改的

### 进度

正常

### TODO

* 排查剩余的工作，清理漏掉的代码，部署测试服务器进行测试

## 2016.12.19 (周一 4th day)

### 完成

* 圣阳，warm up, 清理SOA里，之前遗留的shitty code
* 天奇，清理了God端的代码，基本完成，剩余一个接口：create dpt
* mmliu, 清理了SOA端的代码，几乎没有需要修改的

### 进度

正常

### TODO

* 排查剩余的工作，清理漏掉的代码

## 2016.12.17 (周六 3nd day)

###  完成

* 天奇 对God端做了初步修改，包括：医院+科室的列表页和更新页


* mmliu 清理了Manager 下的Controller，大部分都不需要修改，但需更细致的检查

### 进度

正常

### TODO

* Finish God Page
* Finish SOA APIs

## 2016.12.16 KFB 改造 (Kickoff 2nd day)

### 完成

* mmliu 大致清理了user目录下的13个Controller，但是需要和前端配合进一步的联调
* 天奇 完成SpringBoot tutorial 简单热身任务，完成了 manager 端一个 Action 的改造

### 进度

 正常

## 2016.12.15 KFB 改造 (Kickoff 1st day)

### 完成

* mmliu ApiHefeiController 中7个接口的改造
* 天奇 SpringBoot tutorial 项目热身，明天正式开始改造工作

### 进度

 正常

