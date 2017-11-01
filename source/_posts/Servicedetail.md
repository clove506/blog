---
title: 【优护服务】优护服务-详情
date: 2017-3-10 17:30:00
categories: 优护服务
tags:
- 优护助手
---
#摘要
 优护服务详情与排期

 <!--more-->
## wiki维护人
林慧芝
## UI
负责人:郭苗
## 前端
负责人:李旭
排期:

工作内容 | 人日 | 完成情况 
------- | ------- | ------- 
手机端| 1人日 | √
PC端| 1人日 | √ 
联调| 0.5人日 | √

## 后端
负责人:林慧芝
排期:

工作内容 | 人日 | 完成情况 
------- | ------- | ------- 
详情设计 | 0.5人日 |   √
代码开发| 0.5人日 | √   
自测| 0.5人日 | √
联调| 0.5人日 | √
## 测试与产品验收
负责人：张跃超
排期：

工作内容 | 人日 | 完成情况 
------- | ------- | ------- 
测试 | 1人日 | √
验收 | 1人日 | √

## 运营
负责人:秦永昌

## 优护服务API
### 提交预约信息
POST /api/swordkeeper/v1/advertisementReserve/reserve
#### 接口描述
用户预约服务
#### 接口详情
Input
```json
{
	"advertisementReserve":{
		"name":"张三",
		"tel":13623332392
	}
}
```
OutPut
```json
{
	"result": {
		"success": true,
		"code": 0
	}
}
```
#### API字段说明
广告预约的订单
- name: 通过广告预约服务人的称呼
- tel: 通过广告预约服务人的电话
### 优护服务类图
![](/media/serviceDetail类图.png)
### 优护服务代码结构
```
src/main/java/com/youhujia/swordkeeper/advertisementReserve
├── AddReserve
│   ├── AddReserveBO.java
│   ├── AddReserveContext.java
│   └── AddReserveFactory.java
├── ReserveBO.java
└── ReserveController.java

```
### 时序图
![](/media/serviceDetail时序图.png)





