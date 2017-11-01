---
title: 【优护助手-合肥】合肥项目两期-C端-项目详情设计
date: 2017-3-5 11:20:00
categories: 合肥
tags:
- 优护助手
---

## 摘要
 合肥项目两期-C端-项目详情设计
<!--more-->

## WIKI维护人
林慧芝
王梦超

## 业务
### 项目背景
在科技日益发达的今天，人们的身体健康不断受到重视，医院进行现代化管理就变得尤为重要。优护家从患者的角度出发，开发C端项目，满足用户足不出户、让护士上门护理疾病的需求。

### 项目交互
[合肥C端UI交互图](http://owncloud.youhujia.com/index.php/apps/files/?dir=/&fileid=103151)
### 开发逻辑
1.了解需求
2.设计类图
3.设计每个类的具体方法
### 运营
1.产品运营：去合肥的同学做产品推广、用户使用指导、用户反馈收集、帮助用户进行问题解决、给产品设计提意见和建议等工作。
2.品牌运营：宣传公司品牌、为公司产品吸引用户、通过线下线上渠道推广产品等。

### C端结构图解
![](/media/shooter-结构图解.png)

## 接口
### 分类和场景
接口分为两大类：商品、订单、患者

### 详情
[C端API](http://wiki.office.test.youhujia.com/2017/03/05/Hefei_C_two_stage_API/)
[C端异常处理](http://wiki.office.test.youhujia.com/2017/03/05/c_shooter-two_stage_documents/)

### requqest
- 首页：GET /yh-api/ns/home?dptNum=301-sn
- 服务列表：GET /api/shooter/v1/users/department/{departmentNum}/items
- 服务详情：GET /api/shooter/v1/users/department/{departmentNum}/items/{itemId}
- 用户协议和服务协议：GET /api/shooter/v1/users/orders/protocol/{protocolName}
- 渲染用户下单页面：GET /api/shooter/v1/users/orders/place-order/items/{itemId}
- 用户与患者关系：GET /api/shooter/v1/users/patient-relation
- 新增患者信息：POST /api/shooter/v1/users/user-addresses
- 渲染编辑患者信息页面：GET /api/shooter/v1/users/user-addresses/{userAddressId}
- 编辑患者信息：PATCH /api/shooter/v1/users/update/user-addresses
- 删除患者信息：DELETE /api/shooter/v1/users/delete/user-addresses/{userAddressId}
- 提交订单：POST /api/shooter/v1/users/orders/place-order
- 支付：/api/shooter/v1/users/orders/{orderId}/pay?channel{channel}
- 订单详情：GET /api/shooter/v1/users/orders/{orderId}
- 订单列表：GET /api/shooter/v1/users/orders?status={status}&index={index}&size={size} 
- 渲染退款申请页面：GET /api/shooter/v1/users/orders/{orderId}/request-refund/page-info
- 提交退款申请：POST /api/shooter/v1/users/orders/request-refund
- 提交用户评价：POST /api/shooter/v1/users/orders/review
- 取消订单：PATCH /api/shooter/v1/users/orders/{orderId}/cancel
- 取消退款：PATCH /api/shooter/v1/users/orders/{orderId}/refund/cancel
- 申诉：PATCH /api/shooter/v1/users/orders/{orderId}/complain

### 接口字段说明
#### 康复服务页面上方的图片与文字
```json
"organization":{
	"bannerURL":"图片",
	"desc":"图片上的文字"
}
```

#### 服务相关字段说明
``` json

"item": {
	"itemId": itemId,
	"title": "服务标题",
	"price": 服务标价,
	"decs": "服务描述",
	"serviceDetail": "展开服务描述中的服务详情",
	"pic": "服务图片",
	"period": 服务耗时,
	"action": [{
		"title": "服务内容标题",
		"desc": "服务内容描述",
		"order": "每个服务内容前面的序号",
		"actionId": "每个服务内容的Id",
		"actionType": " 区分每个服务",
		"progress": {
			"Msg": "服务内容完成情况",
			"color": "服务内容完成情况的颜色"
		},
		"content": [{
			"id": 服务内容子项id,
			"content": {
				"title": "自测与评估结果标题",
				"detail": "自测与评估结果内容"
			},
			"status": {
				"title": "服务内容子项标题。",
				"progress": {
					"buttonMsg": "服务内容子项完成情况",
					"color": "服务内容子项完成情况颜色"
				}
			}
		}]
	}]
}
```

#### 下单时的患者列表与患者信息相关字段
```json
"patientList": [{
	"userAddressId": 患者Id,
	"name": "姓名",
	"sex": "性别",
	"birthday": 出生年月日,
	"relation": "用户与患者关系",
	"phone": 电话,
	"default":值为true时放在患者列表第一个,
		"address": {
			"province": "省市",
			"city": "城市",
			"district": "地区",
			"addressDetail": "详细地址"
		}
}]
```

#### 下单前服务时间

```json
"servingTime": [{
	"date": "几号",
	"weekdays": "周几",
	"choose": 是否可选,
	"time": [{
		"choose": 是否可选,
		"title": "几点",
		"detailTime": 具体时间对应的时间戳
	}]
}]
```

#### 订单相关字段
```json
{
	"orderId":订单Id,
	"orderNo":"订单编号",
	"countdownTime": 支付倒计时(时间戳),
	"orderTime": 下单时间（时间戳）,
	"servingTime": 服务时间（时间戳）,
}
```

#### 订单状态

```json
"status": {
	"statusDisplayMsg": "订单状态",
	"statusDescMsg":"订单状态显示下方对应的说明",  
	"color": "订单状态的显示颜色"
	"content": {
		"title": "订单已被取消或订单已被关闭",
		"detail": "订单已被取消或订单已被关闭的可能原因有..."
	}

},
```

#### 订单中的下单患者信息
```json
"patient": {
	"name": "患者姓名",
	"age": 患者年龄,
	"sex": "患者性别",
	"avatarUrl": "患者患者头像",
	"phone": 患者电话,
	"address": "患者地址"
}
```

#### 订单详情中的护士
```json
"nurse": {
	"avatarUrl": "护士头像",
	"name": "护士姓名",
	"hospital": "护士所在医院",
	"title": "护士头衔",
	"score": 护士的星级
}
```

#### 订单详情中对应的按钮 
```json
"availableAction": [{
	"title": "按钮（除立即预约于提交订单按钮）",
	"action": "按钮唯一标识"
}]
```

#### 退款原因下拉列表
```json
{
	"orderId":订单id,
	"reason": [{
		"id": 原因id,
		"title": "原因文字"
	}]
}
```

#### 退款提交
``` json
{
	"orderId": 订单Id,
	"reason": 退款原因,
	"price": 退款金额,
	"explain": "退款说明"
}
```

#### 退款申请中在该状态下用户申请退款原因金额以及说明
```json
"refundDetail": {
	"reason": "退款原因",
	"price": 退款金额,
	"explain": "退款说明"
}
```
## 系统
### 设计
#### 代码结构
```
src/main/java/com/youhujia/shooter
├── ShooterApplication.java
├── domain
│   ├── common
│   │   ├── BaseController.java
│   │   └── ShootExceptionCodeEnum.java
│   ├── item
│   │   ├── ItemBO.java
│   │   ├── ItemController.java
│   │   └── query
│   │       ├── QueryItemBO.java
│   │       ├── QueryItemContext.java
│   │       └── QueryItemContextFactory.java
│   └── order
│       ├── OrderBO.java
│       ├── OrderController.java
│       ├── action
│       │   ├── UpdateBo.java
│       │   ├── UpdateContext.java
│       │   └── UpdateFactory.java
│       ├── add
│       │   ├── AddOrderBO.java
│       │   ├── AddOrderContext.java
│       │   └── AddOrderContextFactory.java
│       ├── delete
│       │   └── DeleteBO.java
│       ├── query
│       │   ├── OrderContext.java
│       │   ├── OrderContextFactory.java
│       │   ├── QueryOrderBO.java
│       │   ├── detail
│       │   │   ├── DetailContextFactory.java
│       │   │   ├── OrderDetailContext.java
│       │   │   └── OrderDetailDTOFactory.java
│       │   ├── list
│       │   │   ├── ListContextFactory.java
│       │   │   ├── OrderListContext.java
│       │   │   └── OrderListDTOFactory.java
│       │   └── object
│       │       ├── ActionStatusEnum.java
│       │       ├── ButtonActionEnum.java
│       │       ├── OrderListStatusEnum.java
│       │       ├── OrderReadEnum.java
│       │       ├── RefundReasonEnum.java
│       │       ├── ShooterStatusEnum.java
│       │       └── WeekdaysEnum.java
│       └── update
│           ├── UpdateUserAddressBO.java
│           ├── UpdateUserAddressContext.java
│           └── UpdateUserAddressFactory.java
└── objects
    └── Shooter.java
```

#### 类图
![类图](/media/shooter-类图.png)

#### 时序图
![服务列表](/media/shooter-服务列表.png)
![服务详情](/media/shooter-服务详情.png)
![渲染用户下单面](/media/shooter-用户下单所需信息.png)
![用户与患者关系](/media/shooter-用户与患者关系.png)
![新增患者信息](/media/shooter-新增患者信息.png)
![渲染编辑患者信息页面](/media/shooter-查询患者信息.png)
![编辑患者信息](/media/shooter-修改患者信息.png)
![删除患者信息](/media/shooter-删除UserAddress.png)
![提交订单](/media/shooter-提交订单.png)
![支付](/media/shooter-支付.png)
![订单详情](/media/shooter-订单详情.png)
![订单列表](/media/shooter-订单列表.png)
![渲染退款申请页面](/media/shooter-渲染退款申请页面.png)
![提交退款申请](/media/shooter-提交退款申请.png)
![用户提交评价](/media/shooter-提交评价.png)
![取消订单](/media/shooter-取消订单.png)
![取消退款](/media/shooter-取消退款.png)
![申诉](/media/shooter-申诉.png)
## 运维
### 部署
develop环境：
1. 提交最新的已经联调过的代码到自己的Fork下；
2. 在GitHub上，new pull request、create pull request把自己Fork下的最新，已联调通过的代码发送到develop分支；
staging环境：
3. 在GitHub上，new pull request、create pull request把develop分支刚提交的代码，发送到release分支；
production环境：
4. 在GitHub上，new pull request、create pull request把release分支刚提交的代码，发送到master分支。
bug修复部署：
1. 将本地修改好的代码提交到自己Fork下的分支上；
2. 在Youhujia下创建HotFix分支，在GitHub上，new pull request、create pull request把自己fork下分支刚提交的代码，发送到HotFix分支；
3. 在GitHub上，new pull request、create pull request把HotFix分支刚提交的代码，发送到master分支；
4. 在GitHub上，new pull request、create pull request把HotFix分支刚提交的代码，发送到develop分支；
5. 删除HotFix分支。


### 线上问题排查 
前端：
查看response返回值，查看request参数，
后端：
查看日志，排查问题。
## 测试
### 测试流程
![测试流程](/media/shooter-测试流程.jpg)
### 测试方法
功能测试、安装测试、易用性测试
### 测试阶段
编码阶段测试、验收阶段测试
### 测试信息
#### 测试环境
staging环境测试：回归测试，验收测试
dev环境测试：新功能测试
线上测试：体验测试
#### 测试文档
测试计划，测试用例，测试总结报告
#### 管理bug
管理云，提交bug
## 备注说明
#### 注解
1）@CAItem(serviceItem = {@CAServiceItem})
CAItem注解获取Item先关信息，serviceItem = {@CAServiceItem}获取Item中对应的ServiceItem信息，如果不设置，则获取不到
2）@CAOrder(patient = {@CAPatient},needAction = true, nurse = {@CANurse})
CAOrder注解获取Order相关信息, patient = {@CAPatient}获得Order中对应的Patient信息，如果不设置，则取不到Patient的信息，同理Action与Nurse也是一样的
3）根据CAPatient(needUserAddress = true)
CAPatient注解获取Patient的相关信息，needUserAddress = true获得Patient中对应的userAddress的信息，如果不舍值，则获取不到
#### Enum
- ActionStatusEnum：服务步骤的完成情况
- ButtonActionEnum：按钮（除立即预约与重新下单）
- OrderListStatusEnum：订单列表状态与其子状态
- OrderReadEnum：服务内容子项的完成情况
- RefundReason：退款原因
- ShooterStatusEnum：订单状态，及对应状态的说明信息
- WeekdaysEnum：服务时间具体显示周几








