---
title: 科室影子公众号 详细设计
date: 2017-2-23 09:01:00
categories: wechat
tags:
- wechat
---

# 摘要

科室影子公众号 详细设计

<!-- more -->

# 科室影子公众号 详细设计

## 背景

现在我们的微信端用户有部分是从其他公众号导流而来，比如，很多用户通过合肥市一的公众号使用我们的微信端服务，这些用户很多只对我们的公众号做了登陆授权但并未关注我们，对这批用户，如果我们希望也能对他们推送消息，只能通过他已经关注的合肥市一的公众号来发送，由此产生了多公众号打通的需求。

## 概念

1. 影子公众号：除了我们的公众号，部分科室可以给出他们自有的公众号，这样对于一个用户，我们可以获取他在两个公众号的信息，我们的公众号用作登录，科室的公众号用作push。为了方便，将科室提供的公众号取名为影子公众号，所谓影子，即大部分场景下都不会使用到。
2. appid：公众号的唯一标识
3. secret：公众号的appsecret
4. shadowId：影子公众号的Id
5. state:微信认证后的redirectUrl中用来识别影子公众号的字段，与shadowId功能一样
6. code：code作为换取access_token的票据，每次用户授权带上的code将不一样，code只能使用一次，5分钟未被使用自动过期。
7. access_token：微信网页授权凭证
8. openId：用户唯一标识
9. transferUrl:用于获取code的中转页面
10. destinationURL：数据库中与影子公众号一一匹配的指定用户最终访问的页面


![显示名](/media/shadow_flow.png)


注：正常登录流程详见：http://wiki.office.test.youhujia.com/2017/02/21/The-Great-Migration/

## 接口

**访问页面/shadow-wx/check-existence?shadowId=XXX，调用接口:**

POST /api/era/v1/users/shadow-wx/exist



Response :

```json
{
  "result" : {"success" : true,"code" : 0},
  "redirectUrl" : "https://open.weixin.qq.com/connect/oauth2/authorize?appid=APPID&redirect_uri=REDIRECT_URI&response_type=code&scope=snsapi_base&state=STATE#wechat_redirect"	
}
```

**获取code后跳转到页面/shadow-wx/submit，调用接口:**

POST /api/era/v1/users/shadow-wx



Response:

```json
{
  "result" : {"success" : true,"code" : 0},
  "redirectUrl" : "destinationUrl"
}
```

ProtoBuf:

```protobuf
message ShadowInfoDTO {
    optional int64 id = 1;
    optional string destination_url = 2;
    optional string appid = 3;
    optional string secret = 4;
    optional string note = 5;
    optional int64 createdAt = 6;
    optional int64 updatedAt = 7;
    
    optional Result result = 8;
	}

message ShadowUserDTO {
	optional int64 id = 1;
	optional int64 userId = 2;
	optional string openId = 3;
	optional int64 shadowWxAccountId = 4;
	optional bool isSubscribed = 5;
	optional int64 createdAt = 6;
	optional int64 updatedAt = 7;
	
	optional Result result = 8;
	}
	
message RedirectResponseDTO{
	optional Result result = 1;
	optional string redirectUrl =2;
	}
```

## 数据库修改

**添加 科室影子公众号表**

```sql
CREATE TABLE `yolar`.`shadow_wx_account` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `destination_url` VARCHAR(1024) NOT NULL COMMENT '影子公众号最终跳转页面',
  `appid` VARCHAR(45) NOT NULL COMMENT '微信公众号 appID',
  `secret` VARCHAR(1024) NOT NULL COMMENT '微信公众号 secret',
  `note` VARCHAR(1024) NOT NULL COMMENT '影子公众号备注',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`))
ENGINE=InnoDB,
COMMENT = '影子公众号信息';
```

**添加 影子公众号下用户的微信信息**

```sql
CREATE TABLE `yolar`.`shadow_wx_profile` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL,
  `open_id` VARCHAR(128) NOT NULL,
  `shadow_wx_account_id` BIGINT NOT NULL,
  `is_subscribed` TINYINT UNSIGNED NOT NULL DEFAULT 0,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`))
ENGINE=InnoDB,
COMMENT = '影子公众号下的用户微信记录';
```


## 微信模版消息 发送策略更新(此功能计划下一期实现)

微信模版消息的策略需要更新，对用户发送模版消息时，需要查看该消息的产生科室，如果用户也关注了该科室提供的影子公众号账户，优先使用影子公众号进行发送。

流程如下：

1. 查看消息产生的科室是否提供了影子公众号
2. 如果未提供，则尝试用优护家的公众号做消息发送（（说尝试是因为用户也可能未关注优护家的公众号））
3. 如果提供了，则检查该用户是否已关注该影子公众号
   1. 如果关注了，则使用影子公众号进行推送
   2. 如果未关注，尝试使用优护家公众号进行推送

## Ref

http://wiki.office.test.youhujia.com/2017/02/20/multi-wx-official-account/

## 排期

内容|耗时/人日|日期|开发者
---|---|---|---
页面开发|0.5|03.09|董劭杰
开发/api/era/shadowInfo接口|1|03.08|丁天奇
开发/api/era/shadowCode接口|1|03.09|丁天奇
联调|2|03.11|丁天奇
测试|1|03.13|郑旭红
部署上线|0.5|03.14|田学文

## 日报
**2017-03-04**
今日工作：
•	完成了开发环境的配置
•	与前端对接了接口设计，确认了前端页面的需求
•	参与了赵蔺“优护家的CI&CD系统介绍与开发规范”会议

明日工作：
•	预计下周一KICKOFF，项目进入开发阶段

**2017-03-06**
今日工作：
•	与明敏，邵杰讨论了项目流程并确认了页面的详细设计
•	完善了接口，数据库以及protobuf的设计并更新文档
•	项目前期准备已完成，等待KickOff

明日工作：
•	完成项目kickoff会议，项目正式启动
•	项目进入开发阶段

项目进度：
•	进度正常

**2017-03-07**
今日工作：
•	举行项目KickOff 会议，项目顺利KickOff
•	帮助正宇生成北京口腔医院头颈肿瘤科的二维码

明日工作：
•	按计划完成开发进度，基本完成接口的设计

项目进度：
•	进度正常

**2017-03-08**
•	妇女节快乐，身体GG了清了一天假

项目进度：
•	由于健康原因，预计有延期一天风险

**2017-03-09**
今日工作：
•	初步完成接口设计，逻辑代码完成。
•	协助圣阳生成新公众号的素材ID

明日工作：
•	完善接口设计，开始与前端对接，准备联调

项目进度：
•	由于请假原因，目前存在延期风险

**2017-03-10**
今日工作：
•	代码优化完成并初步Review
•	部署到develop准备进行测试

明日工作：
•	开始前后端联调

项目进度：
•	测试环境拥堵，排号很辛苦

**2017-03-11**
今日工作：
•	参与了全体会议，对优护家这个大家庭的了解更加深刻
•	前后端第一次联调，发现了一些交流上的问题，及时解决

明日工作：
•	调BUG，并进行下一步联调

项目进度：
•	测试环境拥堵，发现了几个BUG，已经初步定位

**2017-03-13**
今日工作：
•	上周发现的BUG被成功KILL掉
•	明敏第一次Review代码，发现一些代码规范方面的问题，已解决
• 测试环境依然拥堵，定位了最后一个问题

明日工作：
•	预计明日完成自测，发展顺利的话明日可提测

项目进度：
•	测试环境拥堵，预计延期一天

**2017-03-14**
今日工作：
•	进一步定位了问题的原因，提交了部分代码到DEV环境，准备进行更全面的测试
•	与敏哥一起Review了大部分代码，确认无误后提到测试环境
• 多个项目进入了联调阶段，故决定避开高峰期，明天起早来测试

明日工作：
•	自测并解决问题，提测

项目进度：
•	测试环境拥堵，预计延期
 
**2017-03-15**
今日工作：
•  在拼命争取的测试时间内，发现了前端页面的问题，已与邵杰沟通解决
•  第一次跑通了功能代码，但是出现不明错误，由于测试环境拥堵，暂时无法定位
•  由于明天下午便要出发回学校信息采集，故明日依旧起早来公司干活

明日工作：
•	解决所有问题，提测

项目进度：
•	由于明日下午便要出发回学校采集信息，预计下周一返回公司，故项目进度将于明日暂停，待下周一重启

**2017-03-24**
回归之后又遇到合肥PC项目要火速上线，本项目于今日测试完成，部署上线

## 预上线文档
&emsp;&emsp;本期项目【多微信公众号打通】的目标，是用户通过含有shadowId的给定URL进入优护家服务时，我们将获取该用户在指定影子公众号下的openId并存储到影子公众号用户表下面。

**相关改动:**
**Web:**
 &emsp;&emsp;add Website "/shadow-wx/check-existence" and "/shadow-wx/submit"
 
**Era:**
 &emsp;&emsp;add API "/shadow-wx/exist" and "/shadow-wx" in UserController 
 &emsp;&emsp;add Service "checkExistByShadowId" and "saveAndRedirect" in UserService

**Yolar:**
 &emsp;&emsp; create tables "shadow_wx_account" and "shadow_wx_profile"
 &emsp;&emsp; add Model "ShadowWxProfile" and "ShadowWxAccount"
 &emsp;&emsp; add DAO "ShadowWxProfileDAO" and "ShadowWxAccountDAO"
 &emsp;&emsp; add Service "ShadowWxService"
 &emsp;&emsp; add Controller "ShadowWxController"
 &emsp;&emsp; add API "/api/yolar/v1/shadow/{shadowWxId}" and &emsp;&emsp;"/api/yolar/v1/shadow/{shadowWxId}/user/{userId}" and &emsp;&emsp;"/api/yolar/v1/shadow/{shadowWxId}/user/{userId}/{openId}"

**PullRequest:**
**Era:**   &emsp;&emsp;&emsp;https://github.com/Youhujia/era/pull/72
**Yolar:** &emsp;&emsp;https://github.com/Youhujia/yolar/pull/134
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;reviewer:DiveInto(明敏)

## 项目总结
&emsp;&emsp;这是来到公司之后第一次担任PM负责一个独立的项目，也是年后回到优护家接的第一个项目，由于是相隔一个多月回归，遇到了很多问题，例如项目流程，配置文件的改变，开发工具的更新，对之前工作流程的记忆变得模糊，导致上手较慢不太熟练等等问题，经过阿敏的悉心指导和战友们的倾情帮助，还是很快找到了工作状态，开发的过程中相对比较顺利，不过测试的过程比较坎坷，测试环境拥堵的问题短期内不太好解决，项目上线的优先级也不太好评判，所以在为着急上线的项目让路的同时，自己的项目也就无法避免的拖期了。这种项目穿插上线的情况导致了我在提交代码的时候将其他项目的废代码提交了上去，而其他项目上线的时候也上线了部分我还没有测试的代码，这就产生了近期发现的几个BUG，在大家的努力下也算是解决了，不过这种情况以后还是需要尽量避免的。总之本次项目在开发的过程中还算是较为顺利，也尝试着遇到问题先自己研究解决，对自己的能力有了不小的提升，也通过这个项目找回了自己的状态，感谢大家的支持和陪伴，路还很远，愿我们能一直相伴，看花落花开，云舒云卷。


