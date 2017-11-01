---
title: 【优护助手1.4.1】日志
date: 2016-12-06 11:44:13
categories: 优护助手原生APP
tags:
- Feature
---

# 优护助手1.4.1开发日志

## 2016.12.15
### Android:
- UI:
	- 完成Tabbar框架
- Service:
	- 完成患者列表接口
	- 完成同事列表接口
### iOS:
- UI:
	- 完成Tabbar框架
- Service:
	- 完成了Patient和Tag以及相关List与Result的Model
	
## 2016.12.16
### Android:
- Service
	- 完成登出接口
	- 完成单聊群聊接口
### iOS:
- UI
	- 完成静态患者列表
- Service
	- 完成患者列表接口
	- 完成同事列表接口
	- 完成Protobuf预编译调研

## 2016.12.17
### Android:
- UI:
	- 
- Service:
	- 腾讯云登录登出
	- 原生登录集成
	- 患者列表
	- 同事列表

### iOS:
- UI:
	- 完成工具页面
	- 完成访客页面逻辑
- Service:
	- 完成集成腾讯云SDK
	- 完成测试工具页

## 2016.12.18 xxx
## 2016.12.19
### Android:
- Business:
	- 患者列表+数据对接
- Service:
	- 调研腾讯云每次启动登录
### iOS:
- Business:
	- 完成患者列表数据对接
	- 完成静态同事列表
- Service:
	- 完成Protobuf SDK集成
	- 解决TIMSDK包体积过大上传Github的问题
## 2016.12.20
### Android:
- Business:
	- 
- Service:
	- 
### iOS:
- Business:
	- 完成同事列表数据对接
	- 树状显示暂时定为P2需求
- Service:
	- 完成Protobuf的数据，AFNetworking传输Protobuf的调研
## 2016.12.21
### Android:
- Business:
    - 同事列表
    - 选择沟通对象
    - 登出页面
- Service:
    - 聊天消息界面（拿消息需要时间） 
### iOS:
- Business:
    - 登陆页面全部连通
- Service:
    - 完成Protobuf接收数据的调研
    - Calendar的首页列表的接口
    - 护士认证接口
## 2016.12.22
### Android:
- Business:
    - 排班表选择班次 @qiuyu
    - 创建班次页面 @qiuyu
    - 首页聊天信息头像 @weiyu
    - 聊天页头像 @weiyu
- Service:
    - 创建排班和修改排版的接口 @weiyu
### iOS:
- Business:
    - 排版页大列表日历View封装（ongoing） @jingkai
    - 选择日期列表 @jingkai
    - 病人列表没数据的时候优化 @jingkai
- Service:
    - 完成腾讯云登陆登出 @junchao
    - 完成腾讯云新建聊天调研 @junchao
    - 完成新建单对单聊天以及新建群聊的接口 @junchao

## 2016.12.23

### Android:
- Business:
    - 工具页面所有的二级页面 @qiuyu
    - 完成新建班次页面 @qiuyu
- Service:
    - 排班的所有JSON接口封装完毕 @weiyu
### iOS:
- Business:
    - 工具页二级界面：管理、新建公告 @jingkai
    - 首页日程界面，排班界面，右上角菜单bug修复 @jingkai
    - Profile页设置及登出界面完成 @jingkai
    - 完成了聊天界面的toolbar @junchao
- Service:
    - 

## 2016.12.24

### Android:
- Business:
    - 完成排班已完成界面的接口对接 @qiuyu
- Service:
    - 调研腾讯云群聊过程中 @weiyu
### iOS:
- Business:
    - 大致完成排班表的静态主UI @jingkai
    - 完成新建排班，创建排班 @jingkai
    - 完成同事列表的二级菜单 @jingkai
    - 完成聊天ListCell UI框架 @junchao
- Service:
    - 调研单聊过程中 @ junchao

## 2016.12.25 xxx

## 2016.12.26

### Android:
- Business:
    - 排班表的日历栏封装
- Service:
    - 群聊的展示与测试调研
### iOS:
- Business:
    - 排班表的日历拦封装
- Service:
    - 首页聊天列表，聊天页的数据

## 2016.12.27

### Android:
- Business:
    - 排班表日历栏封装完毕 @qiuyu
- Service:
    - 群聊的发送与消息展示 @weiyu
### iOS:
- Business:
    - 修复同事列表问题 @jingkai
    - 重写创建排班 @jingkai
    - 排班表还剩下自适应高度 @jingkai
    - 主页的信息列完成 @junchao
    - 聊天页的列表框架完成 @junchao
- Service:
    - 

## 2016.12.28

### Android:
- Business:
    - 完成排班表静态页面 @qiuyu
- Service:
    - 排班表所有的接口联调完成 @weiyu
    - 聊天那历史消息 @weiyu
### iOS:
- Business:
    - 排班静态页（需要集成）@jingkai
    - 发起沟通页面 @jingkai
    - 聊天接受新消息 @junchao
- Service:
    - 封了所有排班接口 @junchao
    - 封了所有开始沟通接口 @junchao

## 2016.12.29

### Android:
- Business:
    - 排班数据对接完成 @qiuyu
    - 批量排班正在做 @qiuyu
- Service:
    - 聊天封装JSON
    - 首页聊天记录本地化正在做
### iOS:
- Business:
    - 批量排班数据对接完成 @jingkai
    - UI调整中 @jingkai
- Service:
    - 聊天封装JSON
    - nurseProfile本地cache

## 2016.12.30

### Android:
- Business:
    - 完成批量排班页面 （排班大功能基本完成）@qiuyu
- Service:
    - 腾讯云断线重连完成 @weiyu
    - 聊天历史消息加载基本完成 @weiyu
### iOS:
- Business:
    - 完成了查看排班表的功能 @jingkai
- Service:
    - 完成了开始病人和同事聊天 @junchao
    - 文章列表接口和UI基本完成 @junchao

## 2016.12.31 xxx
## 2017.01.01 xxx
## 2017.01.02 xxx
## 2017.01.03 

### Android:
- Business:
    - 推送文章工具页面 @qiuyu
    - 调整UI细节 @qiuyu
    - 聊天气泡的细节 @weiyu
- Service:
    - 解析与发送文章 @weiyu
### iOS:
- Business:
    - 排班表UI基本完成 @jingkai
    - 聊天动态文本高度 @junchao
    - 气泡UI细节 @junchao
- Service:
    - 

## 2017.01.04

### Android:
- Business:
    - 新建公告页面 @qiuyu
    - 个人Profile页（50%）@qiuyu
- Service:
    - 聊天界面头像变圆 @weiyu
    - 调研个推的Push Notification @weiyu
### iOS:
- Business:
    - 排班界面创建编辑班次（还剩下提交数据对接）@jingkai
    - 患者列表为空显示单图 @jingkai
- Service:
    - 聊天信息的工具文章的JSON解析 @junchao
    - 批量发送文章 @junchao
    - 对方的聊天内容显示姓名和动态宽高 @junchao

## 2017.01.05

### Android:
- Business:
    - 个人资料页 ing... @qiuyu
- Service:
    - 获取用户信息接口 @weiyu
    - 更新用户信息接口 相关更新 @weiyu
### iOS:
- Business:
    - 批量排班的接口对接 @jingkai
    - 发起沟通页面完成 @junchao
    - 聊天页面适配群聊 @junchao
- Service:
    - 批量排版接口封装 @junchao

## 2017.01.06

### Android:
- Business:
    - 完成个人资料页 @qiuyu
    - 搭建标签页面   @qiuyu
    -给activity添加loadig @weiyu
- Service:
    - 解决URL无法上传的bug @weiyu
### iOS:
- Business:
    - 批量排班和查看排班  @jingkai
- Service:
    - 重写了批量排班表中添加排班接口 @jingkai

## 2017.01.07

### Android:
- Business:
    - 设置标签页，及相关自定义控件  @qiuyu
- Service:
    - 完成标签相关的所有接口  @weiyu
### iOS:
- Business:
    - 调整UI @jingkai
    — 调研HBuilder @jingkai
- Service:
    -

## 2017.01.08 xxx
## 2017.01.09

### Android:
- Business:
    - 完成进入聊天前标签页 @qiuyu
    - 调研WebiView @qiuyu
    - 完成Getui集成（有小问题遗留） @weiyu
- Service:
    - 完成标签页接口 @weiyu
### iOS:
- Business:
    - 完成排班现存所有工作 @jingkai
    - 调研WebView @jingkai
    - 完成Profile页数据对接 @junchao
    - 完成Getui集成 @junchao
- Service:
    - 

## 2017.01.10

### Android:
- Business:
    - 调研WebView，已经能加载，但是传参数有问题 @qiuyu
- Service:
    - 集成个推，有block问题：配置有问题需要解决 @weiyu
### iOS:
- Business:
    - 调研WebView，目前显示不出来 @jingkai
- Service:
    - 集成了神策数据，还需要埋点设置 @junchao 

## 2017.01.11
## 2017.01.12
## 2017.01.13
## 2017.01.14
## 2017.01.15
## 2017.01.16
## 2017.01.17
## 2017.01.18
## 2017.01.19
---

### Android:
- Business:
	- 
- Service:
	- 
### iOS:
- Business:
	- 
- Service:
	- 

