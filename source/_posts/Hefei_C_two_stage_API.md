---
title: 【优护助手-合肥】合肥项目两期-C端-shooter-API
date: 2017-3-5 11:20:00
categories: 合肥
tags:
- 优护助手
---

# 摘要
合肥项目-C端API详情设计

<!--more-->
# 首页
## 1. 首页接口
request：GET /yh-api/ns/home?dptNum=301-sn
### 接口描述
康复宝提供。 
调用可提供服务列表的接口。


# item
## 2. 用户协议和服务协议接口
request：GET /api/shooter/v1/users/orders/protocol/{protocolName}
### 接口描述
查询用户选择的当前服务的具体信息。
### 接口详情
Request ：/api/shooter/v1/users/orders/protocol/userProtocol
Output：
``` json
{
    "result": {
        "success": true,
        "code": 0
    },
    "content":"谁用谁知道~~"

}
```

Request ：/api/shooter/v1/users/orders/protocol/serviceProtocol?itemId=1
Output：
``` json
{
    "result": {
        "success": true,
        "code": 0
    },
    "content":"就是这个味~~"
    
}
```

### 实现设计
临时方案：利用一个String.format实现显示不同服务的服务协议。比如：
Map<itemId,String> map;
String content = String.format("'%s'",map.get(itemId)));
    
### 后期方案
 在item表中增加服务协议字段，用来保存服务协议。在调用Dagon接口查询服务详情时，返回服务协议内容。
### 接口说明
在提交订单页面，当用户点击用户协议时，跳到用户协议页面；点击服务协议时，跳到当前订单服务的服务协议页面。
   
## 3. 查询医院所提供的服务
request：GET /api/shooter/v1/users/department/{departmentNum}/items
### 接口描述
查询当前医院所有提供的外出服务列表。
### 接口详情
output：
``` json
{
	"result":{
		"success":true,
		"code":1
	},
	"organization":{
		"bannerURL":"http://xxx.com/me.jpg",
		"desc":"庐阳区。。。。医疗服务中心"
	}
	"item":
	[{
		"itemId":123,
		"pic":"http://xxx.com/me.jpg",
		"title":"上门尿管护理",
		"desc":"进行导尿管。。。",
		"price":12000
	},{
		"itemId":124,
		"pic":"http://xxx.com/me.jpg",
		"title":"上门造口护理",
		"desc":"进行导尿管。。。",
		"price":12200
	},{
		"itemId":125,
		"pic":"http://xxx.com/me.jpg",
		"title":"家庭医生。。。",
		"desc":"介绍家庭。。。",
		"price":22000
	}]
	
}
```

### 接口说明
- price的单位是分。例如12元的服务，表示为1200。
- 注释：此接口对应”服务列表“页面


## 4. 服务详情接口
request：GET /api/shooter/v1/users/department/{departmentNum}/items/{itemId}
### 接口描述
查询用户选择的当前服务的具体信息。
### 接口详情
output：
```json
{
    "result": {
        "success": true,
        "code": 0
    },
    "item": {
        "itemId": 123,
        "pic": "http://xxx.com/me.jpg",
        "title": "上门尿管护理",
        "price": 1200,
        "desc": "根据患者的病情状态。。。。",
        "serviceDetail": "<p><strong>导尿，是经由尿道插入导尿管到膀胱</strong></p>",
        "period": 120,
        "action": [
            {
                "title": "推送健康宣教知识",
                "desc": "下单后。。。",
                "order": 1
            },
            {
                "title": "服务前自测",
                "desc": "服务前对患者。。。",
                "order": 2
            },
            {
                "title": "服务前评估",
                "desc": "尿管护理预备操作。。。",
                "order": 3
            },{
                "title": "服务前评估",
                "desc": "服务前对患者。。。",
                "order": 4
            },
            {
                "title": "尿管护理操作",
                "desc": "对尿管进行护理操作。。。",
                "order": 5
            },
            {
                "title": "尿管护理预备操作",
                "desc": "对尿管护理预备操作。。。",
                "order": 6
            }
        ]
    }
}
```


### 接口说明
- period的单位是分钟。
- 注释：此接口对应”服务详情“页面

# userAddress
## 5. 用户与患者的关系
request：GET /api/shooter/v1/users/patient-relation
### 接口描述
用户与患者的关系
### 接口详情
output：
```json
{
    "result": {
        "success": true,
        "code": 0
    },
    "relationList": [
        {
            "id": 1,
            "relation": "自己"
        },
        {
            "id": 2,
            "relation": "爸爸"
        },
        {
            "id": 3,
            "relation": "妈妈"
        },
        {
            "id": 4,
            "relation": "孩子"
        },
        {
            "id": 5,
            "relation": "朋友"
        },
        {
            "id": 6,
            "relation": "亲戚"
        },
        {
            "id": 7,
            "relation": "其他"
        }
    ]
}
```

## 6. 新增患者信息	        
request：POST /api/shooter/v1/users/user-addresses

### 接口描述
患者的基本信息，以及下单人与患者的关系。
### 接口详情
input：
``` json
{
    "item": {
        "itemId": 1
    },
    "userId":1,
    "name": "张三",
    "sex": "女",
    "birthday": 1479712913000,
    "phone": 13723217890,
    "address": {
        "province": "宁夏回族自治区",
        "city": "中卫市",
        "district": "沙坡头区",
        "addressDetail": "常乐镇枣林村5队22"
    },
    "relation": "亲戚"
}
```

output：
```json
{
  "result": {
    "success": true,
    "code": 0
  },
  "patient": {
    "name": "陈jiu婆",
    "sex": "男",
    "relation": "其他",
    "phone": "13723217893",
    "birthday":1479712913000,
    "address": {
      "province": "山西省",
      "city": "吕梁",
      "district": "离市区",
      "addressDetail": "学院路一号"
    },
    "userAddressId": 230
  }
}
```

## 7. 修改前，查询患者信息			
request：GET /api/shooter/v1/users/user-addresses/{userAddressId}
### 接口描述
用于渲染修改患者信息页面
### 接口详情
output：
``` json
{
    "result": {
        "success": true,
        "code": 0
    },
    "patient": {
        "name": "张三",
        "sex": "女",
        "birthday": 1479712913000,
        "phone": 13723217890,
        "address": {
            "province": "宁夏回族自治区",
            "city": "中卫市",
            "district": "沙坡头区",
            "addressDetail": "常乐镇枣林村5队22"
        },
        "relation": "亲戚"
    }
}
```

### 接口说明
注释：age单位是毫秒。

## 8. 提交修改的患者信息
PATCH /api/shooter/v1/users/update/user-addresses
### 接口描述
用户根据病人的情况，修改病人的信息，并进行提交
### 接口详情
input：
``` json
{
    "name": "张三",
    "sex": "女",
    "birthday": 1479712913000,
    "phone": 13723217890,
    "address": {
        "province": "宁夏回族自治区",
        "city": "中卫市",
        "district": "沙坡头区",
        "addressDetail": "常乐镇枣林村5队22"
    },
    "relation": "亲戚"
}
```

output：
```json
{
    "result": {
        "success": true,
        "code": 0
    }
}
```

## 9. 删除当前患者
request：DELETE /api/shooter/v1/users/delete/user-addresses/{userAddressId}
### 接口描述
用户删除当前患者信息
### 接口详情
output：
```json
{
    "result": {
        "success": true,
        "code": 0
    }
}
```

# order
## 10. 患者下单前所需信息接口
request：GET /api/shooter/v1/users/orders/place-order/items/{itemId}
### 接口描述
下单页面所需要的用户个人信息
### 接口详情 
output：    
``` json
{
    "result": {
        "success": true,
        "code": 0
    },
    "item": {
        "itemId": 1,
        "title": "上门。。。",
        "pic": "http://xxx.com/me.jpg",
        "price": 1200,
        "desc": "根据患者病情。。。"
    },
    "patientList": [
        {
            "userAddressId": 1,
            "name": "于家成",
            "sex": "男",
            "birthday": 1479712913000,
            "relation": "朋友",
            "phone": 12323124950,
            "default": true,
            "address": {
                "province": "宁夏回族自治区",
                "city": "中卫市",
                "district": "沙坡头区",
                "addressDetail": "常乐镇枣林村5队22"
            }
        },
        {
            "userAddressId": 2,
            "name": "姜潮",
            "sex": "男",
            "birthday": 1479712913000,
            "relation": "亲戚",
            "phone": 12323124950,
            "default": true,
            "address": {
                "province": "宁夏回族自治区",
                "city": "中卫市",
                "district": "沙坡头区",
                "addressDetail": "常乐镇枣林村5队22"
            }
        }
    ],
    "servingTime": [
        {
            "date": "15号",
            "weekdays": "周三",
            "choose": true,
            "time": [
                {
                    "choose": true,
                    "title": "10:00",
                    "detailTime": 1479712913000
                },
                {
                    "choose": true,
                    "title": "10:00",
                    "detailTime": 1479712913000
                },
                {
                    "choose": true,
                    "title": "10:00",
                    "detailTime": 1479712913000
                }
            ]
        },
        {
            "date": "16号",
            "weekdays": "周四",
            "choose": true,
            "time": [
                {
                    "choose": true,
                    "title": "10:00",
                    "detailTime": 1479712913000
                },
                {
                    "choose": true,
                    "title": "10:00",
                    "detailTime": 1479712913000
                },
                {
                    "choose": true,
                    "title": "10:00",
                    "detailTime": 1479712913000
                }
            ]
        },
        {
            "date": "17号",
            "weekdays": "周五",
            "choose": true,
            "time": [
                {
                    "choose": true,
                    "title": "10:00",
                    "detailTime": 1479712913000
                },
                {
                    "choose": true,
                    "title": "10:00",
                    "detailTime": 1479712913000
                },
                {
                    "choose": true,
                    "title": "10:00",
                    "detailTime": 1479712913000
                }
            ]
        },
        {
            "date": "18号",
            "weekdays": "周六",
            "choose": true,
            "time": [
                {
                    "choose": true,
                    "title": "10:00",
                    "detailTime": 1479712913000
                },
                {
                    "choose": true,
                    "title": "10:00",
                    "detailTime": 1479712913000
                },
                {
                    "choose": true,
                    "title": "10:00",
                    "detailTime": 1479712913000
                }
            ]
        },
        {
            "date": "19号",
            "weekdays": "周日",
            "choose": true,
            "time": [
                {
                    "choose": true,
                    "title": "10:00",
                    "detailTime": 1479712913000
                },
                {
                    "choose": true,
                    "title": "10:00",
                    "detailTime": 1479712913000
                },
                {
                    "choose": true,
                    "title": "10:00",
                    "detailTime": 1479712913000
                }
            ]
        },
        {
            "date": "20号",
            "weekdays": "周一",
            "choose": true,
            "time": [
                {
                    "choose": true,
                    "title": "10:00",
                    "detailTime": 1479712913000
                },
                {
                    "choose": true,
                    "title": "10:00",
                    "detailTime": 1479712913000
                },
                {
                    "choose": true,
                    "title": "10:00",
                    "detailTime": 1479712913000
                }
            ]
        },
        {
            "date": "21号",
            "weekdays": "周二",
            "choose": true,
            "time": [
                {
                    "choose": true,
                    "title": "10:00",
                    "detailTime": 1479712913000
                },
                {
                    "choose": true,
                    "title": "10:00",
                    "detailTime": 1479712913000
                },
                {
                    "choose": true,
                    "title": "10:00",
                    "detailTime": 1479712913000
                }
            ]
        }
    ]
}

```

### 接口说明
- 注释：此接口对应”服务详情-下单“页面

## 11. 提交订单 
request：POST /api/shooter/v1/users/orders/place-order
### 接口描述
用户填写个人基本信息，并提交，提交的信息可以和登录的账号不同。
### 接口详情 
input：    
``` json
{
    "item": {
        "itemId": 1
    },
    "userAddressId": 12,
    "servingTime": 1479712913000,
    "notes": "服务的流程是怎样的？"
}

```

output：
``` json
{
    "result": {
        "success": true,
        "code": 0
    },
    "orderId": 22
}
```

### 接口说明
注释：userAddressId即新增患者对应的Id。

## 12. 查询订单详情
request：GET /api/shooter/v1/users/orders/{orderId}
### 接口描述
多个详情页面共用的接口，详情见接口说明。
### 接口详情 

#### 待支付
output：
``` json
{
    "result": {
        "success": true,
        "code": 0
    },
    "orderId": 1,
    "orderNo":"1234",
    "countdownTime": 900000,
    "orderTime": 1479712913000,
    "servingTime": 1479712913000,
    "item": {
        "itemId": 1,
        "title": "上门。。。",
        "price": 1200,
        "decs": "根据患者。。。",
        "pic": "http://xxx.com/me.jpg",
        "period": 120
    },
    "patient": {
        "name": "张三",
        "age": 63,
        "sex": "男",
        "phone": 15676867890,
        "address": "海淀区。。。"
    },
    "status": {
        "statusDisplayMsg": "待支付",
        "red": "red"
    },
    "availableAction": [
        {
            "title": "取消订单",
            "action": "cancelOrder"
        },
        {
            "title": "确认支付",
            "action": "payConfirm"
        }
    ]
}
```

#### 待接单
output：
``` json
{
    "result": {
        "success": true,
        "code": 0
    },
    "orderId": 1,
    "orderNo":"1234",
    "servingTime": 1479712913000,
    "item": {
        "itemId": 1,
        "title": "上门。。。",
        "price": 1200,     
        "decs": "根据患者。。。",  
        "pic": "http://xxx.com/me.jpg",
        "period": 120,
        "action": [
            {
                "title": "推送健康宣教知识",
                "desc": "下单后。。。",
                "order": 1,
                "actionId": 123,
                "actionType": 5
            },
            {
                "title": "服务前自测",
                "desc": "服务前对患者。。。",
                "order": 2,
                "actionId": 124,
                "actionType": 6
            },
            {
                "title": "服务前评估",
                "desc": "评估是否上门。。。",
                "order": 3,
                "actionId": 125,
                "actionType": 7
            },
            {
                "title": "服务前评估",
                "desc": "服务前对患者。。。",
                "order": 4,
                "actionId": 126,
                "actionType": 7
            },
            {
                "title": "尿管护理操作",
                "desc": "对尿管进行护理操作。。。",
                "order": 5,
                "actionId": 127,
                "actionType":8 
            },
            {
                "title": "尿管护理预备操作",
                "desc": "对尿管护理预备操作。。。",
                "order": 6,
                "actionId": 128,
                "actionType": 8
            }
        ]
    },
    "patient": {
        "name": "张三",
        "age": 63,
        "sex": "男",
        "avatarUrl": "http://xxx.com/me.jpg",
        "phone": 15676867890,
        "address": "海淀区。。。"
    },
    "status": {
        "statusDisplayMsg": "待接单",
        "color": "red"
    },
    "availableAction": [
        {
            "title": "取消订单",
            "action": "cancelOrder"
        }
    ]
}
```

#### 服务中
output：
``` json
{
    "result": {
        "success": true,
        "code": 0
    },
    "orderId": 1,
    "orderNo":"1234",
    "servingTime": 1479712913000,
```

#### 已取消
output：
``` json
{
    "result": {
        "success": true,
        "code": 0
    },
    "orderId": 1,
    "orderNo":"1234",
    "servingTime": 1479712913000,
    "item": {
        "itemId": 1,
        "title": "上门。。。",
        "price": 1200,
        "decs": "根据患者。。。",
        "pic": "http://xxx.com/me.jpg",
        "period": 120
    },
    "patient": {
        "name": "张三",
        "age": 63,
        "sex": "男",
        "avatarUrl": "http://xxx.com/me.jpg",
        "phone": 15676867890,
        "address": "海淀区。。。"
    },
    "status": {
        "statusDisplayMsg": "已取消",
        "color": "lightest",
        "content": {
            "title": "订单已被取消",
            "detail": "可能的原因有..."
        }
    },
    "availableAction": [
        {
            "title": "重新下单",
            "action": "orderAgain"
        }
    ]
}
```

#### 已关闭
output：
``` json
{
    "result": {
        "success": true,
        "code": 0
    },
    "orderId": 1,
    "orderNo":"1234",
    "servingTime": 1479712913000,
    "item": {
        "itemId": 1,
        "title": "上门。。。",
        "price": 1200,
        "decs": "根据患者。。。",
        "pic": "http://xxx.com/me.jpg",
        "period": 120
    },
    "patient": {
        "name": "张三",
        "age": 63,
        "sex": "男",
        "avatarUrl": "http://xxx.com/me.jpg",
        "phone": 15676867890,
        "address": "海淀区。。。"
    },
    "status": {
        "statusDisplayMsg": "已关闭",
        "statusDescMsg": "退款金额155元",
        "color": "lightest",
        "content": {
            "title": "订单已被取消",
            "detail": "可能的原因有..."
        }
    },
    "availableAction": [
        {
            "title": "重新下单",
            "action": "orderAgain"
        }
    ]
}
```


#### 退款中
output：
``` json
{
    "result": {
        "success": true,
        "code": 0
    },
    "orderId": 1,
    "orderNo":"1234",
    "servingTime": 1479712913000,
    "item": {
        "itemId": 1,
        "title": "上门。。。",
        "price": 1200,
        "decs": "根据患者。。。",
        "pic": "http://xxx.com/me.jpg",
        "period": 120,
        "action": [
            {
                "title": "推送健康宣教知识",
                "desc": "下单后。。。",
                "order": 1,
                "actionId": 123,
                "actionType": 5,
                "progress": {
                    "Msg": "1/3",
                    "color": "red"
                },
                "content": [
                    {
                        "id": 1,
                        "status": {
                            "title": "推送健康。。。",
                            "progress":{
	                            "buttonMsg": "已查看",
	                            "color": "red"
	                          }
                        }
                    },
                    {
                        "id": 2,
                        "status": {
                            "title": "推送健康。。。",
                            "progress":{
	                            "buttonMsg": "未查看",
	                            "color": "red"
	                           }
                        }
                    }
                ]
                
                
            },
            {
                "title": "服务前评估",
                "desc": "服务前对患者。。。",
                "order": 2,
                "actionId": 124,
                "actionType": 6,
                "progress": {
                    "Msg": "1/3",
                    "color": "red"
                },
                "content": [
                    {
                        "id": 1,
                        "content":{
                        		"title":"重度功能障碍。。。",
                        		"detail":"患者大部分日常生活。。。"
                        }
                        "status": {
                            "title": "推送健康。。。",
                            "progress":{
	                            "buttonMsg": "已完成",
	                            "color": "green"
	                          }
                        }
                    },
                    {
                        "id": 2,
                        "content":{
                        		"title":"重度功能障碍。。。",
                        		"detail":"患者大部分日常生活。。。"
                        }
                        "status": {
                            "title": "推送健康。。。",
                            "progress":{
	                            "buttonMsg": "未完成",
	                            "color": "red"
	                          }
                        }
                    }
                ]
            },
            {
                "title": "尿管护理操作",
                "desc": "对尿管进行护理操作。。。",
                "order": 3,
                "actionId": 125,
                "actionType": 7,
                "progress": {
                    "color": "green",
                		"buttonMsg": "已完成"
                }
            }
        ]
    },
    "patient": {
        "name": "张三",
        "age": 63,
        "sex": "男",
        "avatarUrl": "http://xxx.com/me.jpg",
        "phone": 15676867890,
        "address": "海淀区。。。"
    },
    "nurse": {
        "avatarUrl": "http://xxx.com/me.jpg",
        "name": "Lucy",
        "hospital": "合肥市第一人民医院",
        "title": "护师",
        "score": 60
    },
    "status": {
        "statusDisplayMsg": "退款中",
        "statusDescMsg": "退款金额155元",
        "color": "green"
    },
    "refundDetail": {
        "reason": "不需要此服务",
        "price": 12000,
        "explain": "服务后出现问题。。。"
    }
}
```


#### 退款申请中
output：
``` json
{
    "result": {
        "success": true,
        "code": 0
    },
    "orderId": 1,
    "orderNo":"1234",
    "servingTime": 1479712913000,
    "item": {
        "itemId": 1,
        "title": "上门。。。",
        "price": 1200,
        "decs": "根据患者。。。",
        "pic": "http://xxx.com/me.jpg",
        "period": 120,
        "action": [
            {
                "title": "推送健康宣教知识",
                "desc": "下单后。。。",
                "order": 1,
                "actionId": 121,
                "actionType": 5,
                "progress": {
                    "Msg": "1/3",
                    "color": "red"
                },
                "content": [               
                    {
                        "id": 1,
                        "status": {
                            "title": "推送健康。。。",
                            "progress":{
	                            "buttonMsg": "已读",
	                            "color": "green"
	                          }
                        }
                    },
                    {
                        "id": 2,
                        "status": {
                            "title": "推送健康。。。",
                            "progress":{
	                            "buttonMsg": "未读",
	                            "color": "red"
	                          }
                        }
                    }
                ]
            },
            {
                "title": "服务前自测",
                "desc": "服务前，患者进行自我测试。。。",
                "order": 2,
                "actionId": 122,
                "actionType": 6,
                "progress": {
                    "Msg": "1/2",
                },
                "content": [            
                    {
                        "id": 1,
                        "content":{
                        		"title":"自测结果。。。",
                        		"detail":"患者大部分日常生活。。。"
                        }
                        "status": {
                            "title": "基本能力自测。。。",
                            "progress":{
	                            "buttonMsg": "已自测",
	                            "color": "green"
	                          }
                        }
                    },
                    {
                        "id": 2,
                       "content":{
                        		"title":"自测。。。",
                        		"detail":"患者大部分日常生活。。。"
                        }
                        "status": {
                            "title": "基本能力自测。。。",
                            "progress":{
	                            "buttonMsg": "未自测",
	                            "color": "red"
	                          }
                        }
                    }
                ]
            },
            {
                "title": "服务前评估",
                "desc": "评估是否上门服务。。。",
                "order": 3,
                "actionId": 123,
                "actionType": 7,
                "progress": {
                    "Msg": "1/3",
                    "color": "red"
                },
                "content": [            
                    {
                        "id": 1,
                        "content":{
                        		"title":"评估结果。。。",
                        		"detail":"患者大部分日常生活。。。"
                        }
                        "status": {
                            "title": "电话评估。。。",
                            "progress":{
	                            "buttonMsg": "已评估",
	                            "color": "green"
	                          }
                        }
                    },
                ]
            },
            {
                "title": "服务评估",
                "desc": "服务前对患者。。。",
                "order": 4,
                "actionId": 124,
                "actionType": 7,
                "progress": {
                    "Msg": "1/3",
                    "color": "red"
                },
                "content": [            
                    {
                        "id": 1,
                        "content":{
                        		"title":"评估结果。。。",
                        		"detail":"患者大部分日常生活。。。"
                        }
                        "status": {
                            "title": "基本能力评估。。。",
                            "progress":{
	                            "buttonMsg": "已评估",
	                            "color": "green"
	                          }
                        }
                    },
                    {
                        "id": 2,
                       "content":{
                        		"title":"评估结果。。。",
                        		"detail":"患者大部分日常生活。。。"
                        }
                        "status": {
                            "title": "基本能力评估。。。",
                            "progress":{
	                            "buttonMsg": "未评估",
	                            "color": "red"
	                          }
                        }
                    }
                ]
            },
            {
                "title": "尿管护理预备操作",
                "desc": "对尿管进行护理操作。。。",
                "order":5,
                "actionId": 125,
                "actionType": 8,
                "progress":{
	                "color": "green",
	                "buttonMsg": "已完成"
	              }
            },
            {
                "title": "尿管护理操作",
                "desc": "对尿管进行护理操作。。。",
                "order": 6,
                "actionId": 126,
                "actionType": 8,
                "progress":{
	                "color": "green",
	                "buttonMsg": "未完成"
	              }
            }
        ]
    },
    "patient": {
        "name": "张三",
        "age": 63,
        "sex": "男",
        "avatarUrl": "http://xxx.com/me.jpg",
        "phone": 15676867890,
        "address": "海淀区。。。"
    },
    "nurse": {
        "avatarUrl": "http://xxx.com/me.jpg",
        "name": "Lucy",
        "hospital": "合肥市第一人民医院",
        "title": "护师",
        "score": 60
    },
    "status": {
        "statusDisplayMsg": "退款申请中",
        "statusDescMsg": "待护士确认/待运营人员确认",
        "color": "green"
    },
    "refundDetail": {
        "reason": "不需要此服务",
        "price": 12000,
        "explain": "服务后出现问题。。。"
    },
    "availableAction": [
        {
            "title": "取消退款",
            "action": "cancelRefund"
        }
    ]
}
```

#### 待评价
output：
``` json
{
    "result": {
        "success": true,
        "code": 0
    },
    "orderId": 1,
    "orderNo":"1234",
    "servingTime": 1479712913000,
    "item": {
        "itemId": 1,
        "title": "上门。。。",
        "price": 1200,
        "decs": "根据患者。。。",
        "pic": "http://xxx.com/me.jpg",
        "period": 120,
        "action": [
           {
                "title": "推送健康宣教知识",
                "desc": "下单后。。。",
                "order": 1,
                "actionId": 121,
                "actionType": 5,
                "progress": {
                    "Msg": "1/3",
                    "color": "#red"
                },
                "content": [               
                    {
                        "id": 1,
                        "status": {
                            "title": "推送健康。。。",
                            "progress":{
	                            "buttonMsg": "已读",
	                            "color": "green"
	                          }
                        }
                    },
                    {
                        "id": 2,
                        "status": {
                            "title": "推送健康。。。",
                            "progress":{
	                            "buttonMsg": "未读",
	                            "color": "red"
	                          }
                        }
                    }
                ]
            },
            {
                "title": "服务前自测",
                "desc": "服务前，患者进行自我测试。。。",
                "order": 2,
                "actionId": 122,
                "actionType": 6,
                "progress": {
                    "Msg": "1/2",
                },
                "content": [            
                    {
                        "id": 1,
                        "content":{
                        		"title":"自测结果。。。",
                        		"detail":"患者大部分日常生活。。。"
                        }
                        "status": {
                            "title": "基本能力自测。。。",
                            "progress":{
	                            "buttonMsg": "已自测",
	                            "color": "green"
	                          }
                        }
                    },
                    {
                        "id": 2,
                       "content":{
                        		"title":"自测。。。",
                        		"detail":"患者大部分日常生活。。。"
                        }
                        "status": {
                            "title": "基本能力自测。。。",
                            "progress":{
	                            "buttonMsg": "未自测",
	                            "color": "red"
	                          }
                        }
                    }
                ]
            },
            {
                "title": "服务前评估",
                "desc": "评估是否上门服务。。。",
                "order": 3,
                "actionId": 123,
                "actionType": 7,
                "progress": {
                    "Msg": "1/3",
                    "color": "red"
                },
                "content": [            
                    {
                        "id": 1,
                        "content":{
                        		"title":"评估结果。。。",
                        		"detail":"患者大部分日常生活。。。"
                        }
                        "status": {
                            "title": "电话评估。。。",
                            "progress":{
	                            "buttonMsg": "已评估",
	                            "color": "green"
	                          }
                        }
                    },
                ]
            },
            {
                "title": "服务评估",
                "desc": "服务前对患者。。。",
                "order": 4,
                "actionId": 124,
                "actionType": 7,
                "progress": {
                    "Msg": "1/3",
                    "color": "red"
                },
                "content": [            
                    {
                        "id": 1,
                        "content":{
                        		"title":"评估结果。。。",
                        		"detail":"患者大部分日常生活。。。"
                        }
                        "status": {
                            "title": "基本能力评估。。。",
                            "progress":{
	                            "buttonMsg": "已评估",
	                            "color": "green"
	                          }
                        }
                    },
                    {
                        "id": 2,
                       "content":{
                        		"title":"评估结果。。。",
                        		"detail":"患者大部分日常生活。。。"
                        }
                        "status": {
                            "title": "基本能力评估。。。",
                            "progress":{
	                            "buttonMsg": "未评估",
	                            "color": "red"
	                          }
                        }
                    }
                ]
            },
            {
                "title": "尿管护理预备操作",
                "desc": "对尿管进行护理操作。。。",
                "order":5,
                "actionId": 125,
                "actionType": 8,
                "progress":{
	                "color": "green",
	                "buttonMsg": "已完成"
	              }
            },
            {
                "title": "尿管护理操作",
                "desc": "对尿管进行护理操作。。。",
                "order": 6,
                "actionId": 126,
                "actionType": 8,
                "progress":{
	                "color": "green",
	                "buttonMsg": "未完成"
	              }
            }
        ]
    },
    "patient": {
        "name": "张三",
        "age": 63,
        "sex": "男",
        "avatarUrl": "http://xxx.com/me.jpg",
        "phone": 15676867890,
        "address": "海淀区。。。"
    },
    "nurse": {
        "avatarUrl": "http://xxx.com/me.jpg",
        "name": "Lucy",
        "hospital": "合肥市第一人民医院",
        "title": "护师",
        "score": 60
    },
    "status": {
        "statusDisplayMsg": "待评价",
        "color": "red"
    },
    "availableAction": [
        {
            "title": "退款",
            "action": "refund"
        },
        {
        		"title":"评价",
        		"action":"evaluate"
        }
    ]
}
```

#### 已完成
output：
``` json
{
    "result": {
        "success": true,
        "code": 0
    },
    "orderId": 1,
    "orderNo":"1234",
    "servingTime": 1479712913000,
    "item": {
        "itemId": 1,
        "title": "上门。。。",
        "price": 1200,
        "decs": "根据患者。。。",
        "pic": "http://xxx.com/me.jpg",
        "period": 120,
        "action": [
         {
                "title": "推送健康宣教知识",
                "desc": "下单后。。。",
                "order": 1,
                "actionId": 121,
                "actionType": 5,
                "progress": {
                    "Msg": "1/3",
                    "color": "#red"
                },
                "content": [               
                    {
                        "id": 1,
                        "status": {
                            "title": "推送健康。。。",
                            "progress":{
	                            "buttonMsg": "已读",
	                            "color": "green"
	                          }
                        }
                    },
                    {
                        "id": 2,
                        "status": {
                            "title": "推送健康。。。",
                            "progress":{
	                            "buttonMsg": "未读",
	                            "color": "red"
	                          }
                        }
                    }
                ]
            },
            {
                "title": "服务前自测",
                "desc": "服务前，患者进行自我测试。。。",
                "order": 2,
                "actionId": 122,
                "actionType": 6,
                "progress": {
                    "Msg": "1/2",
                },
                "content": [            
                    {
                        "id": 1,
                        "content":{
                        		"title":"自测结果。。。",
                        		"detail":"患者大部分日常生活。。。"
                        }
                        "status": {
                            "title": "基本能力自测。。。",
                            "progress":{
	                            "buttonMsg": "已自测",
	                            "color": "green"
	                          }
                        }
                    },
                    {
                        "id": 2,
                       "content":{
                        		"title":"自测。。。",
                        		"detail":"患者大部分日常生活。。。"
                        }
                        "status": {
                            "title": "基本能力自测。。。",
                            "progress":{
	                            "buttonMsg": "未自测",
	                            "color": "red"
	                          }
                        }
                    }
                ]
            },
            {
                "title": "服务前评估",
                "desc": "评估是否上门服务。。。",
                "order": 3,
                "actionId": 123,
                "actionType": 7,
                "progress": {
                    "Msg": "1/3",
                    "color": "red"
                },
                "content": [            
                    {
                        "id": 1,
                        "content":{
                        		"title":"评估结果。。。",
                        		"detail":"患者大部分日常生活。。。"
                        }
                        "status": {
                            "title": "电话评估。。。",
                            "progress":{
	                            "buttonMsg": "已评估",
	                            "color": "green"
	                          }
                        }
                    },
                ]
            },
            {
                "title": "服务评估",
                "desc": "服务前对患者。。。",
                "order": 4,
                "actionId": 124,
                "actionType": 7,
                "progress": {
                    "Msg": "1/3",
                    "color": "red"
                },
                "content": [            
                    {
                        "id": 1,
                        "content":{
                        		"title":"评估结果。。。",
                        		"detail":"患者大部分日常生活。。。"
                        }
                        "status": {
                            "title": "基本能力评估。。。",
                            "progress":{
	                            "buttonMsg": "已评估",
	                            "color": "green"
	                          }
                        }
                    },
                    {
                        "id": 2,
                       "content":{
                        		"title":"评估结果。。。",
                        		"detail":"患者大部分日常生活。。。"
                        }
                        "status": {
                            "title": "基本能力评估。。。",
                            "progress":{
	                            "buttonMsg": "未评估",
	                            "color": "red"
	                          }
                        }
                    }
                ]
            },
            {
                "title": "尿管护理预备操作",
                "desc": "对尿管进行护理操作。。。",
                "order":5,
                "actionId": 125,
                "actionType": 8,
                "progress":{
	                "color": "green",
	                "buttonMsg": "已完成"
	              }
            },
            {
                "title": "尿管护理操作",
                "desc": "对尿管进行护理操作。。。",
                "order": 6,
                "actionId": 126,
                "actionType": 8,
                "progress":{
	                "color": "green",
	                "buttonMsg": "未完成"
	              }
            }
    		]
    },
    "patient": {
        "name": "张三",
        "age": 63,
        "sex": "男",
        "avatarUrl": "http://xxx.com/me.jpg",
        "phone": 15676867890,
        "address": "海淀区。。。"
    },
    "nurse": {
        "avatarUrl": "http://xxx.com/me.jpg",
        "name": "Lucy",
        "hospital": "合肥市第一人民医院",
        "title": "护师",
        "score": 60
    },
    "status": {
        "statusDisplayMsg": "已完成",
        "color": "green"
    },
    "availableAction": [
        {
            "title": "申诉",
            "action": "complain"
        }
    ]
}
```

### 接口说明
- period的单位是分钟。
- countdownTime的单位是毫秒。
- 注释：此接口对应”待支付、待接单、退款中、服务中、待评论、已完成、退款申请中“页面。
- statusDisplayMsg:退款申请中、退款中、服务中、待评价、待接单、待支付、已取消、已关闭。
- statusDescMsg:待护士确认/待运营人员确认、退款金额￥115元。
- availableAction:重新下单、确认支付、申诉、取消订单、退款、取消退款、评价。

## 13. 订单列表页
request：GET /api/shooter/v1/users/orders?status={status}&index={index}&size={size} 
### 接口描述
用户点击”订单“按钮，查看所有订单列表。
### 接口详情

#### 进行中
request：GET /api/shooter/v1/users/orders?status=serving&index=1&size=9    
 output：
```json
{
    "result": {
        "success": true,
        "code": 0
    },
    "orderStatus": "serving",
    "order": [
        {
            "orderId": 1,
            "orderNo":"1234",                         
            "item": {
                "pic": "http://xxx.com/me.jpg",
                "title": "上门尿管护理",
                "price": 1200,
                "period":120
            },
            "patient": {
                "name": "张三",
                "age": 13,
                "phone":12312312312,
                "sex": "男",
                "servingTime": 1479712913000,
                "address": "海淀区"
            },
            "status": {
                "statusDisplayMsg": "待支付",
                "color": "red"
            }
        },
        {
            "orderId": 2,
            "orderNo":"1234",
            "item": {
                "pic": "http://xxx.com/me.jpg",
                "title": "上门尿管护理",
                "price": 12000
            },
            "patient": {
                "name": "张三",
                "age": 13,
                "sex": "男",
                "phone":12312312312,
                "servingTime": 1479712913000,
                "address": "海淀区"
            },
            "status": {
                "statusDisplayMsg": "待接单",
                "color": "red"
            }
        }
    ]
}
```
 
#### 退款中
request：GET /api/shooter/v1/users/orders?status=refunding&index=1&size=9
output：
```json
{
    "result": {
        "success": true,
        "code": 0
    },
    "orderStatus": "refunding",
    "order": [
        {
            "orderId": 1,
            "orderNo":"1234",
            "item": {
                "pic": "http://xxx.com/me.jpg",
                "title": "上门尿管护理",
                "price": 1200,
                "period":120
            },
            "patient": {
                "name": "张三",
                "age": 13,
                "sex": "男",                
                "phone":12312312312,
                "servingTime": 1479712913000,
                "address": "海淀区"
            },
            "status": {
                "statusDisplayMsg": "退款中",
                "color": "green"
            }
        },
        {
            "orderId": 2,
            "orderNo":"1234",
            "item": {
                "pic": "http://xxx.com/me.jpg",
                "title": "上门尿管护理",
                "price": 12000
            },
            "patient": {
                "name": "张三",
                "age": 13,
                "sex": "男",                
                "phone":12312312312,
                "servingTime": 1479712913000,
                "address": "海淀区"
            },
            "status": {
                "statusDisplayMsg": "退款申请中",
                "color": "red"
            }
        }
    ]
}
```

#### 已完成
request：GET /api/shooter/v1/users/orders?status=finish&index=1&size=9
output：
``` json
{
    "result": {
        "success": true,
        "code": 0
    },
    "orderStatus": "finish",
    "order": [
        {
            "orderId": 1,
            "orderNo":"1234",
            "item": {
                "pic": "http://xxx.com/me.jpg",
                "title": "上门尿管护理",
                "price": 1200,
                "period":120
            },
            "patient": {
                "name": "张三",
                "age": 13,
                "sex": "男",                
                "phone":12312312312,
                "servingTime": 1479712913000,
                "address": "海淀区"
            },
            "status": {
                "statusDisplayMsg": "已完成",
                "color": "green"
            }
        },
        {
            "orderId": 2,
            "orderNo":"1234",
            "item": {
                "pic": "http://xxx.com/me.jpg",
                "title": "上门尿管护理",
                "price": 12000
            },
            "patient": {
                "name": "张三",
                "age": 13,
                "sex": "男",                
                "phone":12312312312,
                "servingTime": 1479712913000,
                "address": "海淀区"
            },
            "status": {
                "statusDisplayMsg": "已取消",
                "color": "lightest"
            }
        }
    ]
}
```
 
#### 全部订单
request：GET /api/shooter/v1/users/orders?status=allList&index=1&size=9
output：

``` json
{
    "result": {
        "success": true,
        "code": 0
    },
    "orderStatus": "allList",
    "order": [
        {
            "orderId": 1,
            "orderNo":"1234",
            "item": {
                "pic": "http://xxx.com/me.jpg",
                "title": "上门尿管护理",
                "price": 1200,
                "period":120
            },
            "patient": {
                "name": "张三",
                "age": 13,
                "sex": "男",                
                "phone":12312312312,
                "servingTime": 1479712913000,
                "address": "海淀区"
            },
            "status": {
                "statusDisplayMsg": "已关闭",
                "color": "lightest"
            }
        },
        {
            "orderId": 2,
            "item": {
                "pic": "http://xxx.com/me.jpg",
                "title": "上门尿管护理",
                "price": 12000
            },
            "patient": {
                "name": "张三",
                "age": 13,
                "sex": "男",                
                "phone":12312312312,
                "servingTime": 1479712913000,
                "address": "海淀区"
            },
            "status": {
                "statusDisplayMsg": "退款中",
                "color": "green"
            }
        },
        {
            "orderId": 3,
            "orderNo":"1234",
            "item": {
                "pic": "http://xxx.com/me.jpg",
                "title": "上门尿管护理",
                "price": 1200
            },
            "patient": {
                "name": "张三",
                "age": 13,
                "sex": "男",                
                "phone":12312312312,
                "servingTime": 1479712913000,
                "address": "海淀区"
            },
            "status": {
                "statusDisplayMsg": "已完成",
                "color": "green"
            }
        }
    ]
}
```

### 接口说明：
注释：该接口的请求URL中需要index，size和status三个传参。

## 14. 退款申请页面信息接口
request：GET /api/shooter/v1/users/orders/{orderId}/request-refund/page-info
### 接口描述
用户进行退款申请时，选择的退款原因。
### 接口详情
output：
``` json
{
    "result": {
        "success": true,
        "code": 0
    },
    "orderId":1,
    "reason": [
        {
            "id": 1,
            "title": "不需要此单服务"
        },
        {
            "id": 2,
            "title": "下错单了"
        },
        {
            "id": 3,
            "title": "服务人员未上门"
        },
        {
            "id": 4,
            "title": "服务人员态度差"
        },
        {
            "id": 5,
            "title": "服务质量不好"
        },
        {
            "id": 6,
            "title": "服务后出现问题"
        },
        {
            "id": 7,
            "title": "其他"
        }
    ],
    "price": 12000
}
```

### 接口说明
- 注释：此接口对应”退款原因下拉列表”

## 15. 退款申请
request：POST /api/shooter/v1/users/orders/request-refund

### 接口描述
用户对服务不满意，需要退款时，填写相应的信息，提交后进入退款申请中状态。
### 接口详情
input：
``` json
{
    "orderId": 1,
    "reason": 1,
    "price": 12000,
    "explain": "服务态度不好"
}
```

### 接口说明
- 注释：此接口对应”退款“按钮


## 16. 患者提交评价接口
request：POST /api/shooter/v1/users/orders/review
### 接口描述
服务完成后，用户对本次服务的护士进行评价，有：评价的具体内容。
### 接口详情
input：
``` json
{
    "orderId": 3,
    "evaluateContent": "医生人好，医术高",
    "score": 60
}
```

### 接口说明
- 注释：此接口对应”评价“页面
- "score"即几颗星评价，最高五颗星，最低一颗星，100表示五颗星，以此类推。

## 17. 取消退款                        
request：PATCH /api/shooter/v1/users/orders/{orderId}/refund/cancel
### 接口描述
用户申请退款后，又不想退款继续申请服务，所进行的操作。
### 接口详情
output:
```json
{
    "result": {
        "success": true,
        "code": 0
    }
}
```

### 接口说明
- 注释：此接口对应”取消退款“按钮

## 18. 取消订单
request：PATCH /api/shooter/v1/users/orders/{orderId}/cancel
### 接口描述
订单未被接单时，用户取消订单。
### 接口详情 
output：
``` json
{
    "result": {
        "success": true,
        "code": 0
    }
} 
```

### 接口说明
- 注释：此接口对应”取消订单“按钮

## 19. 申诉按钮                        
request：PATCH /api/shooter/v1/users/orders/{orderId}/complain
### 接口描述
服务结束后，用户对该服务不满意，进行申诉。
### 接口详情
output：
``` json
{
    "result": {
        "success": true,
        "code": 0
    }
}
```

### 接口说明
- 注释：此接口对应”申诉“按钮


## 20. 支付
request：PATCH /api/shooter/v1/users/orders/{orderId}/pay?channel{channel}
### 接口描述
用户下单支付的时候，需要调用的接口。
### 接口详情
output：
``` json
{
    "result": {
        "success": true,
        "code": 0
    },
    "chargeJson": "{\n  \"id\": \"ch_rXjfLKbD8mf5G88yPG04eL0O\",\n  \"object\": \"charge\",\n  \"created\": 1483543593,\n  \"livemode\": false,\n  \"paid\": false,\n  \"refunded\": false,\n  \"app\": \"app_ir1unT8S4GK40Cuv\",\n  \"channel\": \"wx_pub\",\n  \"order_no\": \"9517010427203280\",\n  \"client_ip\": \"127.0.0.1\",\n  \"amount\": 110,\n  \"amount_settle\": 110,\n  \"currency\": \"cny\",\n  \"subject\": \"晨妈专注五十年~专业尿管护理\",\n  \"body\": \"晨妈专注五十年~专业尿管护理\",\n  \"time_paid\": null,\n  \"time_expire\": 1483550793,\n  \"time_settle\": null,\n  \"transaction_no\": null,\n  \"refunds\": {\n    \"object\": \"list\",\n    \"url\": \"/v1/charges/ch_rXjfLKbD8mf5G88yPG04eL0O/refunds\",\n    \"has_more\": false,\n    \"data\": []\n  },\n  \"amount_refunded\": 0,\n  \"failure_code\": null,\n  \"failure_msg\": null,\n  \"metadata\": {},\n  \"credential\": {\n    \"object\": \"credential\",\n    \"wx_pub\": {\n      \"appId\": \"wxlsyda9vnvvlsrjjd\",\n      \"timeStamp\": \"1483543593\",\n      \"nonceStr\": \"81fdf61636bf398cb1aeef6982a33c29\",\n      \"package\": \"prepay_id=1101000000170104tyhujt4mbvl8zly5\",\n      \"signType\": \"MD5\",\n      \"paySign\": \"9E3DAA8A5493D63CD6E0879488EA355F\"\n    }\n  },\n  \"extra\": {\n    \"open_id\": \"o7eVow8LQYupdX_JoaVffYeAQKrs\"\n  },\n  \"description\": null\n}"
}
```

## 按钮表单

### 退款按钮
 显示的文字：退款按钮
 对应的Enum字符串：refund
 用到的页面：订单详情
 对应的状态：服务中、待评价
 
### 取消退款按钮
显示的文字：退款按钮
对应的Enum字符串：cancelRefund
用到的页面：订单详情
对应的状态：退款申请中

### 申诉按钮
显示的文字：退款按钮
对应的Enum字符串：complain
用到的页面：订单详情
对应的状态：已完成

### 取消订单按钮
 显示的文字：退款按钮
 对应的Enum字符串：cancelOrder
 用到的页面：订单详情、提交订单
 对应的状态：待支付、待接单

###  重新下单按钮
 显示的文字：重新下单按钮
 对应的Enum字符串：orderAgain
 用到的页面：订单详情 
 对应的状态：已关闭、已取消

###  确认支付按钮
 显示的文字：确认支付按钮
 对应的Enum字符串：payConfirm
 用到的页面：提交订单
 对应的状态：待支付   

###  评价按钮
 显示的文字：评价按钮
 对应的Enum字符串：evaluate
 用到的页面：订单详情
 对应的状态：待评价











