---
title: 【优护助手1.4.5】计划
date: 2016-12-06 11:44:13
categories: 优护助手原生APP
tags:
- Feature
---

# 优护助手1.4.5

UI:

- 1d 
- 合肥首页 @Android qiuyu @iOS jingkai
- 调研集成Ping++ @Android weiyu @iOS junchao

- 订单列表页
	- 1d
	- UI页面 @Android qiuyu @iOS jingkai
	- 订单列表接口 @Android weiyu @iOS junchao
	- 1d
	- 交互逻辑 @Android qiuyu @iOS jingkai
	- 接单接口 @Android weiyu @iOS junchao
	- 1d
	- 以上与H5页面对接 @Android qiuyu @iOS jingkai
	- 单个患者带地址信息API @Android weiyu @iOS junchao
	- /api/nurses/{nurseId}/patients

- 创建服务订单
	- 1d
	- UI页面 @Android qiuyu @iOS jingkai
	- 选择所有服务API @Android weiyu @iOS junchao
	- /api/nurses/order/v1/getAllService?nurseId={nurseId}
	- 1d
	- 页面逻辑 @Android qiuyu @iOS jingkai
	- Ping支付接口以及SDK支付模块 @Android weiyu @iOS junchao
	
- 选择患者
	- 1d
	- UI页面 @Android qiuyu @iOS jingkai
	- 选择患者API @Android weiyu @iOS junchao
	- /api/nurses/order/v1/{userId}/getUserDetail
	- 1d
	- 对接数据@Android qiuyu @iOS jingkai
	- 添加并选择患者API @Android weiyu @iOS junchao
	- /api/nurses/order/v1/createUser
	- /api/nurses/order/v1/{userId}/chooseUser

- 1d 
- 编辑患者信息页面 @Android qiuyu @iOS jingkai
- 提交订单接口 @Android weiyu @iOS junchao
- /api/nurses/order/v1/createAssistOrder?nurseId={nurseId}

- 1d 
- 选择服务页面 @Android qiuyu @iOS jingkai
- Ping++支付Demo @Android weiyu @iOS junchao
- 0.5d 
- 选择日期页面 @Android qiuyu @iOS jingkai
- 对接支付模块 @Android weiyu @iOS junchao
- 0.5d 
- 选择支付页面 @Android qiuyu @iOS jingkai
- 自测支付模块 @Android weiyu @iOS junchao


