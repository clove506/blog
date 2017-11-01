---
title: 【优护助手1.2.1】项目管理
date: 2016-12-06 11:44:13
categories: 项目管理
tags:
- Feature
---


## Arrangement

- 由于App Store 圣诞节放假， 所以研发进度暂定倒推。
- 12月17日是Release期限
- 12月14日开始打包上传各渠道
- 12月12日Code Complete开始测试

登陆原生化的主要工作为：

- AppIcon及启动页
- 首次登陆的介绍页
- 登录页
- 登陆详情页
 - 医院列表页
 - 科室列表页
- 登陆认证页
- 登陆之后的WebView页面
- 登出之后的数据清理

@田学文
这个功能后台已经支持，不需要额外开发。但是有权限漏洞，需要做额外的权限验证。
具体如下：
era 项目中，
public Boolean updateNurseInfo(Long nurseId, Era.NurseInfoOption body) 
方法中对 nurse 的状态，也就是在更新字段之前对 NurseState 做判断。

@董邵杰 
Item每个为0.5days
以下为已修复的Bug
- 修复了一个可能会导致B端消息不能接收的bug
- 修复“日程提醒”改为“工作提醒”

@于俊超 
Items主要为登录流程原生化，由于时间限制，
主界面使用WebView加载本地Html的方式实现
由于未知的问题的解决方案实施所需时间尚不可控
- 本地访问线上资源的跨域问题
- 原生框架与Html页面的交互问题
- 使用Hbuilder SDK的UI适配的问题
所以准备的备用方案为直接依照原来H5的App方式来上线。



