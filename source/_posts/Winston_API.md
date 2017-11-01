---
title: 【合肥项目】运营中心-API
date: 2016-12-28 15:30:00
categories: 合肥
tags:
- Winston
---

## 摘要

 合肥项目-运营中心API

<!--more-->


# 运营中心API详细设计
## 登录接口设计
POST /api/era/v1/admin/swordkeeper/login
### 接口描述
运营人员通过预设的手机号和短信验证码进行登录操作
### Request

``` json
{
    "phone":"1333333333",
    "captcha":"2309"
}
```
### Response

``` json
{
    "result":{
        "success":true,
        "code":0
        },
    "token":"ljdhalf2134rdfjsuf",
    "adminId" : 1
}
```
### 实现设计
复用之前的登录逻辑，在winston项目中新建两张表，分别保存短信验证码-账号对应关系以及预设的账号信息，登录时，通过短信验证码校验，如果验证码正确并且账号为系统预设，就为该账号生成token同时存入账号信息表中（若之前有token则覆盖），之后每次进行请求，前端同学将token存入httpsHeader，以便gateway校验（复用之前前端的逻辑就可以）。
失败信息返回时，需要传回displayMsg。

## 短信验证码接口设计
POST  /api/era/v1/admin/swordkeeper/sms/{phoneNumber}
### 接口描述
运营人员通过预设的手机号来请求短信验证码
### Response

``` json
{
    "result":{
        "success":true,
        "code":0
    }
}
```

### 实现设计
复用之前的登录逻辑，通过smsAPI来发送短信，发送的验证码数字由本地随机方法生成并入库，方便登录时做校验。同时，如果是非预设号码，不发送短信并返回相应的错误信息。


## 查询订单列表
GET /api/swordkeeper/v1/orders?draw=20&start=2&length=20&conditions={no=EC_22222&nurseName=lixinghua&patientName=wangsan&state=3}&order[0][column]=2&order[0][dir]=1
### 接口描述
根据组合的复数查询条件来返回对应订单的列表
### Request 参数说明
- draw为前端请求的防多次点击的校验参数，原样返回即可
- start为分页请求相关参数，表示返回列表的第一个元素
- length为分页所需订单数量
- conditions中相关查询条件为:nurseName(护士姓名)、patientName(患者姓名)、no(订单编号)、orderState(订单状态)。
- order[0][column]为排序参照字段，目前约定的字段有：订单时间（1）、订单状态（2）、服务名称（3）
- isDesc是是否倒序

### Response
```json
{
	"result":{
	"success":true,
	"code":0,
	},

	"draw":20,
	"recordsFiltered":34,
	"recordsTotal":20,

	"order":[
		{
		"orderId":1,
		"no":"3C_9997723BED",
		"itemName":"上门排尿",
		"orgName":"合肥一院",
		"createAt":"2016.12.23",
		"userName":"申帅",
		"nurseName":"赵林",
		"state":"服务中",
		"dealState":"已处理"
		}
	]
}
```

### 实现设计
复数筛选条件的列表查询，其实可以细化为两种查询：一种是通过订单编号准确定位到一个订单（订单编号唯一）；另一种则比较复杂，由于护士和患者的姓名存在重名可能，并且不是小概率事件，所以需要先根据护士和患者的姓名拿到对应姓名下的护士id list 和 患者id list， 根据这两个集合的叉乘检索到所有的数据，将他们组合为一个list，再根据查询条件排序返回。

## 订单详情
GET /api/swordkeeper/v1/orders/{orderId}/detail?orderId={orderId}
### 接口描述
根据传入的orderId来查询对应订单的详情

### Response
```json
{
    "result": {
        "success": true,
        "code": 0
    },
    "odrerInfo": {
        "basicInfo": {
            "orderId": 1,
            "no": "CE_22223334",
            "originPrice": 18000,
            "price": 15000,
            "amount": 16000,
            "itemName": "上门排尿",
            "createAt": "2016.11.21",
            "serviceAt": "2016.11.23",
            "address": "北京市海淀区大河庄苑南门门口",
            "orderState": 4
        },
        "userInfo": {
            "id": 23,
            "nickName": "申帅",
            "gender": 1,
            "age": 29,
            "phone": 13333333333,
            "address": "北京市海淀区大河庄苑地下车库5号车位"
        },
        "nurseInfo": {
            "id": 34,
            "name": "赵林",
            "org": "YHJ-有害菌第一医院",
            "job": "特殊服务人员",
            "phone": "14444444444",
            "score": 82
        },
        "itemInfo": {
            "id": 45,
            "itemName": "上门排尿",
            "serviceDuring": 7200,
            "desc": "上·门·排·尿 , 大·吉·大·利"
        }
    },
    "dealOrder": {
        "dealState": "已处理",
        "availableButton": "置为退款成功",
        "refundMax":13000,
        "refundCreator":"nurse",
        "nurse":[
		      {
		      "nurseId":1,
		      "gender":1,
		      "orgName":"合肥一院",
		      "job":"搞基护士",
		      "nurseName":"赵林",
		      "phoneNumber":"13333333333",
		      "score":82
		      }
	]
    },
    "logInfo": {
        "logs": [
            {
                "time": "2016.12.24 08:40:21",
                "role": "运营人员",
                "level": "终极无敌超级金牌运营",
                "account": "mmliu",
                "action": "拒绝额外服务",
                "extraInfo": {
                    "comment": "汝乃天骄，何不上九霄？"
                },
                "displayMsg": {
                  "运营人员mmliu拒绝额外服务，原因：“拒绝py”"
                }
            }
        ],
        "finishInfo": {
          "action": {
                "articleSection": [
                    {
                        "title": "推荐健康宣教知识",
                        "desc": "下单后，系统自动向患者推送健康宣教文章",
                        "order": 1,
                        "articleSection": [
                        {
                            "title": "推荐健康宣教知识",
                            "desc": "下单后，系统自动向患者推送健康宣教文章",
                            "order": 1,
                            "articleContents": [
                              {
                                  "id": 519,
                                  "title": "后端的第一条宣教",
                                  "progress": {
                                      "msg": "已读",
                                      "color": "green"
                                  }
                              },
                              {
                                  "id": 1295,
                                  "title": "后端的第二条宣教",
                                  "progress": {
                                      "msg": "未读",
                                      "color": "red"
                                  }
                              }
                            ]
                  }
              ],
                "toolSection": [
                    {
                        "title": "服务器评估",
                        "desc": "服务前，对患者状态进行综合评估",
                        "order": 3,
                        "toolContents": [
                            {
                                "id": 124,
                                "title": "后端的第一条自测",
                                "summary": "自测正文",
                                "progress": {
                                    "msg": "已自测",
                                    "color": "green"
                                }
                            },
                            {
                                "id": 124,
                                "title": "后端的第二条自测（和第一条一样，不是BUG）",
                                "summary": "",
                                "progress": {
                                    "msg": "未自测",
                                    "color": "red"
                                }
                            }
                        ]
                    }
                ],
                "evaluateSection": [
                    {
                        "title": "服务器评估",
                        "desc": "服务前，对患者状态进行综合评估",
                        "order": 2,
                        "evaluateContents": [
                            {
                                "id": 124,
                                "title": "后端的第一条评测",
                                "summary": "评测正文",
                                "progress": {
                                    "msg": "已评测",
                                    "color": "green"
                                }
                            },
                            {
                                "id": 124,
                                "title": "后端的第二条评测（和第一条一样，不是BUG）",
                                "summary": "",
                                "progress": {
                                    "msg": "未评测",
                                    "color": "red"
                                }
                            }
                        ]
                    }
                ],
                "stepSection": [
                    {
                        "title": "尿管护理预备操作",
                        "desc": "服务前，对患者状态进行综合评估",
                        "order": 4,
                        "progress": {
                            "msg": "已完成",
                            "color": "red"
                        }
                    },
                    {
                        "title": "尿管护理操作",
                        "desc": "服务前，对患者状态进行综合评估",
                        "order": 5,
                        "progress": {
                            "msg": "未完成",
                            "color": "red"
                        }
                    }
                ]
            }
          ]
        }
      }
    }
}
```
### 已解决的问题
- 服务时间保存在什么地方:order-->address-->servingTime
- 派单部分的检索护士是否需要winston提供接口:需要，已经添加接口
- 日志的字段信息确认：参照develop下相关对象
- 服务步骤完成情况在哪里取得：需要的时候找@林慧芝

### 实现设计
根据orderId使用CAOrder注解标注service中的方法取得COrder对象，同时根据json需求自己拼装protobuf对象来传递数据；同时，根据订单状态来判断是否出现已处理/未处理按钮以及三个置为XXX的按钮；根据logs来判断可以显示已处理/未处理的订单当前到底是已处理还是未处理。

## 推送接口设计
POST /api/swordkeeper/v1/orders/push
### 接口描述
运营人员对高优先级派单的订单进行人工推送
### Request

``` json
{
    "nurseIds":[2,3,4],
    "orderIds":[5,6,7]
}
```
### Response

``` json
{
    "result":{
        "success":true,
        "code":0
    }
}
```

### 参数说明
当前业务场景下是将一个订单推送给多个护士，考虑到日后业务场景扩展，可能出现一个护士推送给多个订单、甚至是多个护士多个订单推送的情况，故此接口设计为传入护士id list 以及 订单 id list，方便日后扩展。

### 实现设计
拿到护士id和订单id后，调用owl下相关方法进行派单即可，同时应在该订单的log中生成一条派单日志。

## 处理服务超时状态接口设计
POST /api/swordkeeper/v1/orders/{orderId}/deal-timeout?orderId={orderId}
### 接口描述
运营人员对订单处于超时状态的按钮的订单进行手动处理操作并加入日志
### Request

``` json
{
    "desc":"描述"
}
```
### Response

``` json
{
    "result":{
        "success":true,
        "code":0
    }
}
```

### 实现设计
对当前订单加入一条操作日志来标识该超时的订单已经得到了客服人员的处理。

## 添加操作日志接口设计
POST /api/swordkeeper/v1/orders/{orderId}/log?orderId={orderId}
### 接口描述
运营人员对订单添加一条操作日志(action为comment的log)
### Request

``` json
{
    "desc":"描述"
}
```
### Response

``` json
{
    "result":{
        "success":true,
        "code":0
    }
}
```

### 实现设计
根据订单id向调用方法（待shawn实现）向订单的logList添加一条日志。

## 退款接口设计
POST /api/swordkeeper/v1/orders/{orderId}/refund?orderId={orderId}
### 接口描述
运营人员对申请退款的订单进行处理
### Request

``` json
{
    "desc":"客户无理取闹",
    "status":0,
    "price":1200
}
```
### Response

``` json
{
    "result":{
        "success":true,
        "code":0
    }
}
```

### 参数说明
- status:0为拒绝，1为同意
- price为退款金额

### 实现设计
拿到订单id和退款状态后，根据不同的状态抉择调用不同的owl中的接口进行操作，同时在该订单的log中生成一条退款操作日志。

## 处理异常接口设计
POST /api/swordkeeper/v1/orders/{orderId}/handle-exception?orderId={orderId}
### 接口描述
运营人员对异常订单状态下的订单进行人为操作

### Request

``` json
{
    "desc":"描述"
}
```


### Response

``` json
{
    "result":{
        "success":true,
        "code":0
    }
}
```
### 实现设计
拿到订单id后，根据订单所处在的不同的状态进行调用owl中不同的订单状态变更的方法，同时生成一条运营人员人为操作订单状态的操作日志（待学文实现）。

## 状态数字对应关系
状态 | 数字
--- | ---
待支付 | 0
支付状态待确认 | 1
待接单 | 2
高优先待结单 | 3
派单待确认 | 4
待服务 | 5
服务中 | 6
服务超时 | 7
服务异常 | 8
未评价 | 9
退款申请中 | 10
待退款 | 11
退款中 | 12
退款成功 | 13
退款失败 | 14
发起退款失败 | 15
结算中 | 16
订单结束 | 17
订单关闭 | 18
服务纠纷 | 19
结束后纠纷 | 20  

## 待处理问题
- winston更名（我觉着还不错，打倒三体从我做起；推翻三体暴政，世界属于人类)(SwordHolder & Damocles By:zhaolin)
- owl中订单列表查询接口默认排序是什么
- Yolar中通过nickName查询用户以及通过name查询nurse的查询接口限制最多返回1000条结果
- 操作日志中账户字段应为唯一标识

## 详细排期
内容 | 详情 | 人日 | 完成情况 | 负责人
--- | --- | --- | ----	| ----
设计文档 | 完成详细设计文档 | 1 | OK |李圣阳
订单列表和订单详情接口 | 完成两个接口的业务逻辑 | 2 | OK |李圣阳
登录 | 完成完整登录的逻辑操作以及相关的接口实现 | 2 | X | 李江明
推送 | 完成推送接口的实现和相关逻辑的实现 | 1 | X | 赵蔺
处理服务超时与添加操作日志 | 完成处理服务超时接口以及添加操作日志接口和相关逻辑的实现 | 1 | X |赵蔺
退款 | 完成退款操作的相关接口和逻辑的实现 | 1 | X | 赵蔺
变更订单状态 | 完成变更订单状态接口和相关逻辑的实现 | 1 | X | 赵蔺      



# Time

## 2016.12.30 Day 2
### 完成

* 订单列表接口完成
* 订单详情接口完成

### 进度

 正常

## 2016.12.29 winston 创建 (Kickoff 1st day)

### 完成

* winston 项目搭建
* 详细设计文档上线

### 进度

 正常
