---
title: 【上门护理二期】合肥项目-owl项目API
date: 2017-2-11 12:20:00
categories: 上门护理二期
tags:
- Order
---

## 摘要

目前创建订单只能是用户进行创建，但是我们的用户都是中老年和需要护理人员，他们进行下单操作可能会不方便，因此需要添加辅助下单功能：

* 护士辅助下单功能

<!--more-->

## 文档更新

时间|内容|维护人
----|----|---
2017-2-27|创建文档|黄英
2017-2-28|更新文档|黄英

# 了解须知

如果在查看此文档时，有一些设计背景知识不是太清楚，请仔细阅读这一块。

### 订单相关字段说明

了解订单相关字段，例如service_item、address字段所代表的具体含义，请点击下面链接，了解详情
[订单数据库表说明请参见](https://github.com/Youhujia/docs/blob/master/backend/product_order/OrderDatabase.md)

### 商品设计模型

了解商品的具体设计模型，以及更过关于商品设计的知识，请点击下面链接，了解详情
[商品模型](http://wiki.office.test.youhujia.com/2017/02/10/nursing-item-publish-flow/)

### 订单状态机

说明：状态机作为订单项目中最核心的部分，主要负责订单状态的流转。在状态机的限制下，在特定的状态下，只能发起特定的动作。例如，在待支付状态下只能发起支付、支付超时、取消订单动作，而不能发起护士主动接单的动作。这便是状态机的主要功能。状态机具体的状态和动作请点击以下链接，了解详情

[订单状态机详情请参见](https://github.com/Youhujia/docs/blob/master/backend/product_order/OwlAPI.md)

# 详细设计

* 更新状态机，添加新的状态
* 为新添加的动作，添加新的接口
* 将原来数据库中order表中预留的property字段，添加辅助下单人的信息


## 订单数据模型

* 单个订单数据模型

``` json
{
  "result": {
    "success": true,
    "code": 0
  },
  "orderId": 11474,
  "status": 0,
  "desc": "鼻饲是将导管经鼻腔插入胃内，从管内输注食物、水分和药物，以维持病人的营养治疗的技术。（包含插胃管和首次鼻饲）家属自备物品：一次性无菌鼻胃管：（一套：胃管+无菌手套+鼻贴+盘带+无菌注射器+棉签），适量开水（38～40℃），鼻饲饮料（38～40℃）。[温馨提示家属选择正规医院或者药店购买，注意检查物品有效期等]护士自备物品：手套、鞋套、听诊器、口罩、手消毒液。",
  "originPrice": 12000,
  "price": 1,
  "userId": 0,
  "departmentId": 1,
  "amount": 1,
  "operation": {
    "action": [
      {
        "operator": {
          "type": "system",
          "id": 3,
          "name": "shooter"
        },
        "action": 38,
        "time": 1486793722265,
        "previousState": 1,
        "nextState": 0
      }
    ]
  },
  "property": {
    "propertyInfo": [
        {
            "PropertyType": 1,
            "content": "{\"id\": 6,\"AgentPersonType\": 1,\"title\": \"护士\",\"name\": \"小南\"}"
        }
    ]
},
  "planId": 1709,
  "serviceItem": {
    "id": 14,
    "item": {
      "itemId": 4,
      "name": "鼻饲",
      "desc": "鼻饲是将导管经鼻腔插入胃内，从管内输注食物、水分和药物，以维持病人的营养治疗的技术。（包含插胃管和首次鼻饲）家属自备物品：一次性无菌鼻胃管：（一套：胃管+无菌手套+鼻贴+盘带+无菌注射+棉签），适量开水（38～40℃），鼻饲饮料（38～40℃）。[温馨提示家属选择正规医院或者药店购买，注意检查物品有效期等]护士自备物品：手套、鞋套、听诊器、口罩、手消毒液",
      "price": 1,
      "departmentId": 1,
      "categoryId": 9,
      "createdAt": 1483596770000,
      "updatedAt": 1483970126000,
      "status": 5,
      "picture": {
        "pictureItem": [
          {
            "pictureInfo": "http://yhjstatic-dev.oss-cn-shanghai.aliyuncs.com/avatar/e6b51b90-0951-b9d8-a432-b07655fbf079.jpg"
          }
        ]
      }
    },
    "desc": "鼻饲是将导管经鼻腔插入胃内，从管内输注食物、水分和药物，以维持病人的营养治疗的技术。（包含插胃管和首次鼻饲）家属自备物品：一次性无菌鼻胃管：（一套：胃管+无菌手套+鼻贴+盘带+无菌注射器+棉签），适量开水（38～40℃），鼻饲饮料（38～40℃）。[温馨提示家属选择正规医院或者药店购买，注意检查物品有效期等]护士自备物品：手套、鞋套、听诊器、口罩、手消毒液。",
    "price": 1,
    "originPrice": 12000,
    "name": "鼻饲-自备物料-1次",
    "duration": 4500,
    "picture": {
      "pictureItem": [
        {
          "pictureInfo": "http://yhjstatic-dev.oss-cn-shanghai.aliyuncs.com/avatar/e6b51b90-0951-b9d8-a432-b07655fbf079.jpg"
        }
      ]
    },
    "standardTemplateId": 8785,
    "standardTemplateType": 3,
    "serviceItemProp": [
      {
        "id": 6,
        "name": "物料",
        "valueId": 11,
        "valueName": "自备物料"
      },
      {
        "id": 7,
        "name": "套餐",
        "valueId": 13,
        "valueName": "1次"
      }
    ]
  },
  "address": {
    "userId": 100018,
    "name": "user name",
    "age": 20,
    "gender": 1,
    "phone": "18614041815",
    "address": "北京市海淀区海淀街道",
    "servingTime": 1484179200000,
    "note": "记得来的时候多拿点纱布"
  },
  "createdAt": 1484812464000,
  "updatedAt": 1486793718000,
  "no": "9517011900173810",
  "userDepartmentId": 0
}
```


## 服务人员创建订单

POST /api/owl/v1/orders/agent-create-order?nurseId={nurseId}&serviceItemId={serviceItemId}

### 接口描述

由服务人员进行下单，从而在数据库中创建一个新的订单，url中的nurseId为下单护士的id，与property中的id相同。创建订单参数最后的一个nurseId为服务护士的id。
request:

### 接口详情

``` json
{
	"itemId": 4,
	"serviceItemId": 14,
	"address": {
		"userId": 2140,
		"name": "user name",
		"age": 20,
		"gender": 1,
		"phone": "18614041815",
		"address": "北京市海淀区海淀街道",
		"servingTime": 1484179200000,
		"note": "记得来的时候多拿点纱布"
	},
	"property": {
		"id": 1,
		"AgentPersonType": 1,
		"name": "小南",
		"title": "护士"
	},
	"userId": 2140,
	"userDepartmentId": 7,
	"nurseId": 7
}
```

response：
[单个订单数据模型](#单个订单数据模型)


## 服务人员发起支付

POST /api/owl/v1/orders/{orderId}/nurse-pay-order?nurseId={nurseId}

### 接口描述

服务人员发起支付，接收到请求后，请求支付系统发起支付，发起支付成功则状态跳转到代下单支付状态待确认状态

### 接口详情

request：


``` json
{	
	"channel": "wx-pub",
	"extra":{
		"open_id":"xxxxxxx"
	}
}
```

response：
[单个订单数据模型](#单个订单数据模型)

## 代下单待支付状态超时

GET /api/owl/v1/orders/{orderId}/agent-unpaid-timeout

### 接口描述
代下单代支付状态下，达到一定时间后，触发超时操作，订单状态跳转到关闭状态


### 接口详情

response：
[单个订单数据模型](#单个订单数据模型)

## 代下单支付状态待确认超时

GET /api/owl/v1/orders/{orderId}/agent-paying-timeout

### 接口描述

代下单支付状态待确认状态下，达到一定时间后，触发超时操作，订单状态跳转到关闭状态

### 接口详情

response：
[单个订单数据模型](#单个订单数据模型)


## 测试

### 接口

* 服务人员代下单接口
* 代下单等待支付状态下，用户发起支付
* 代下单等待支付状态下，服务人员发起支付
* 代下单等待支付状态下，用户取消订单
* 代下单等待支付状态下，服务人员取消订单
* 代下单等待支付状态下，超时
* 代下单支付状态待确认状态下，用户发起支付
* 代下单支付状态待确认状态下，服务人员发起支付
* 代下单支付状态待确认状态下，支付成功
* 代下单支付状态待确认状态下，超时
* 代下单支付状态待确认状态下，用户取消订单
* 代下单支付状态待确认状态下，服务人员取消订单

### 测试预期结果

#### 服务人员代下单接口

接口请求成功，数据库订单创建成功，主要查看订单中的property字段，nurseId字段数据添加成功且正确

#### 代下单等待支付状态下，服务人员／用户发起支付接口
接口请求成功，订单状态跳转到代下单支付状态待确认，数据库中payment字段填充成功

#### 其他接口
接口请求成功，订单状态跳转正确,操作日志添加正确

## 开发排期
内容|耗时／人日
---|---
halo中关于owl的接口设计开发，owl项目中对服务人员辅助下单、服务人员支付、超时等接口的具体实现|2
自我测试，测试本次开发的接口，以及本次开发所涉及到之前开发的其他接口|1




