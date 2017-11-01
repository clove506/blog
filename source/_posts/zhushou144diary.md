---
title: 【优护助手1.4.4】日志
date: 2016-12-06 11:44:13
categories: 优护助手原生APP
tags:
- Feature
---

# 优护助手1.4.4开发日志

## 2017.02.06

### Android:
- Business:
    - 随访主界面 @qiuyu
- Service:
    - 完成三个随访接口封装 @weiyu
### iOS:
- Business:
    - 
- Service:
    - 接口Refactoring，为以后做缓存以及Log做准备 @junchao

## 2017.02.07

### Android:
- Business:
    - 301的需求 @weiyu
    - 随访的页面（剩下新建随访模版）@qiuyu
- Service:
    - 完成随访接口 @weiyu
### iOS:
- Business:
    - 301的需求 @jingkai
    - 完成随访模块三个界面 @jingkai
- Service:
    - 完成Protobuf通用的RequestUtil @junchao

## 2017.02.08

### Android:
- Business:
    - 完成了所有的随访界面 @qiuyu 
- Service:
    - 完成随访界面对接 @weiyu
    - 日程提醒接口 @weiyu
### iOS:
- Business:
    - 随访界面静态（剩下三级界面） @jingkai
- Service:
    - 完成所有随访接口 @junchao

## 2017.02.09

### Android:
- Business:
    - 日程提醒页面 @qiuyu
- Service:
    - 缓存调研 @weiyu
### iOS:
- Business:
    - 随访数据对接 @jingkai
    - 工具页UI线程优化 @jingkai
- Service:
    - 完成所有公告接口 @junchao
    - 缓存调研 @junchao

## 2017.02.10

### Android:
- Business:
    - 正在做日程提醒页面 @qiuyu
- Service:
    - 
### iOS:
- Business:
    - 完成一个随访界面（还剩编辑随访界面） @jingkai
- Service:
    - 
### BugFix
    - 修复ios头像圆角
    - 修复android几个UI Bug
    - 测通聊天，排除聊天问题

## 2017.02.11

### Android:

- Business:
    - 日程提醒基本完成 90%
- Service:
    - 完成了所有日程提醒的接口

- UI Bug修复
- 完成日程提醒

### iOS:

- Business:
    - 对接合肥
    - 修复一些排班Bug
- Service:
    - 修复一堆 bug

- 完成随访公告原生化
- 排班Bug至少完成至还剩一个

- 修复头像上传
- 个人页进一步完善

### BugFix
    - fix 排版提醒

## 2017.02.12

## 2017.02.13

### Android
- 完成所有日程提醒 @qiuyu
- 修复个推icon @weiyu
- loading页改为半透明 
- 修复部分UI bug
### iOS
- 完成随访模板数据对接 @jingkai
- 完成个人设置页 @junchao
- 完成首页聊天头像与Android同样 @junchao
- 聊天界面文章工具样式更新 @junchao


## 2017.02.14

### Android
- 完成功能性P0的Bug修复
- UI Bug修复P0的问题

### iOS
- 完成大部分UI Bug的修复
- 完成公告所有工作
- 完成随访模块所有工作
- 同时详情页标签完成50%

## 2017.02.15
## 2017.02.16
## 2017.02.17
## 2017.02.18
## 2017.02.19

- 修bug

## 2017.02.20

### Android:

- Business:
    - 完成管理模版中随访模版和班次管理
- Service:
    - 完成Request内存缓存

### iOS:

- Business:
    - 完成日程提醒页面逻辑
    - 完成日程提醒点击路径
- Service:
    - 完成了HTTP本地缓存模块并应用于患者列表

## 2017.02.21

### Android:

- Business:
    - 原生化了管理列表界面
- Service:
    - 完成缓存策略功能模块

### iOS:

- Business:
    - 日程提醒完成进度：剩余两个界面
    - 完成所有页面右滑返回
    - 完成聊天界面输入框弹出的界面修复
- Service:
    - 

## 2017.02.22
### Android:
- 修复了页面之间切换可能出现的闪屏问题 @weiyu @qiuyu
- 与后端联调随访模块中出现单个随访中的bug问题 @weiyu @qiuyu
### iOS:
- 完成了日程提醒页面(进度为还剩一个查看随访页面） @jingkai
- 修复了获取用户数据不完整可能导致的腾讯云SDK和神策SDK崩溃闪退的问题 @junchao

## 2017.02.23

### Android:
- 完成下拉刷新模块 @qiuyu
- 完成新定义的缓存策略 @weiyu
### iOS:
- 完成日程提醒已读接口 @jingkai
- 完成下拉刷新集成 @junchao

## 2017.02.24

### Android:
- 完成缓存下拉刷新的自定义样式 @qiuyu 
- 缓存与业务层对接 @qiuyu @weiyu
### iOS:
- 日程提醒的查看随访页面 @jingkai
- 管理页面原生化 @jingkai
- 完成缓存下拉刷新的自定义样式 @junchao
- 完成日程提醒与科室公告页的缓存逻辑与下拉刷新 @junchao

## 2017.02.25

### Android:
- 修复所有ScrollView中可能会滑动不流畅的问题 @qiuyu
- 完成首页断网提示 @weiyu
- 完成同事列表和文章工具列表的缓存以及下拉刷新 @weiyu
### iOS:
- 完成所有日程提醒原生化 @jingkai
- 完成首页断网提示 @junchao
- 完成同事列表和文章工具列表的缓存以及下拉刷新 @junchao

## 2017.02.26
## 2017.02.27

### Android:
- 完成合肥工作台界面并对接服务控制台H5页面 @qiuyu
- 完成订单管理页大部分接口确认 @weiyu

### iOS:
- 完成合肥工作台页面 @jingkai
- 完成新的DataProvider及合肥一期原生的三个GET接口 @junchao


## 2017.02.28

### Android:
- 完成订单列表UI @qiuyu
- 完成订单列表接口确认 @weiyu

### iOS:
- 完成订单列表UI @jingkai
- 修复了AFNetworking的JSON解析问题 @junchao
- 调研Ping++集成 @junchao

## 2017.03.01

### Android:
- 完成辅助下单部分UI @qiuyu
- 完成接单接口的功能对接 @qiuyu @weiyu
- 完成时间控件 @weiyu
- Ping++调研 @weiyu

### iOS:
- 对接订单列表数据 @jingkai
- 服务设置管理H5对接 @jingkai
- 完成Ping++调研 @junchao
- 完成现有合肥接口信息确认 @junchao

## 2017.03.02
## 2017.03.03
## 2017.03.04
## 2017.03.05
## 2017.03.06
## 2017.03.07
## 2017.03.08
## 2017.03.09

---

### Android:
### iOS:



