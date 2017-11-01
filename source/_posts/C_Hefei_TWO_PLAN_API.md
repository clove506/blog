---
title: 【上门护理二期】合肥项目-C端二期API
date: 2017-2-10 13:00:00
categories: 上门护理二期
tags:
- 优护助手
---

## 摘要

 合肥项目-患者端API

<!--more-->

# C端二期API详细设计

## 服务详情接口                   
GET /api/users/organization/v1/{organizationId}/item/{itemId}/detail
### 接口描述
查询用户选择的当前服务的具体信息。
### 接口详情

``` json
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
            },
            {
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
- 接口在一期的基础上，添加服务详情介绍，即：serviceDetail，是一个HTML格式

## 用户下单前所需item、患者列表信息	
GET /api/shooter/v1/users/orders/place-order/items/{itemId}
### 接口描述
患者下单所需服务信息
### 接口详情

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


## 修改前，查询患者信息			
GET /api/shooter/v1/users/user-addresses/{userAddressId}
### 接口描述
下过单的患者信息
### 接口详情

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
-age：单位是毫秒。


## 用户与患者的关系
GET /api/shooter/v1/users/patient-relation
### 接口描述
用户与患者的关系
### 接口详情

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

## 提交修改的患者信息					
PATCH /api/shooter/v1/users/update/user-addresses/{userAddressId}
### 接口描述
用户根据病人的情况，修改病人的信息。
### 接口详情
INPUT

``` json
{
    "name": "张三",
    "sex": "女",
    "birthday": 1479712913000,
    "phone": 13723217890,
    "address": {
        "province": "宁夏回族自治区",
        "city": "银川市",
        "district": "西夏区",
        "addressDetail": "朔方路"
    },
    "relation": 6
}
```


OUTPUT

```json
{
    "result": {
        "success": true,
        "code": 0
    }
}
```

## 新增患者信息							        

POST /api/shooter/v1/users/user-addresses

### 接口描述
患者的基本信息，以及下单人与患者的关系。
### 接口详情

INPUT

``` json
{
    "name": "张三",
    "sex": "女",
    "birthday": 1479712913000,
    "phone": 13723217890,
    "address": {
        "province": "北京",
        "city": "北京市",
        "district": "海淀区",
        "addressDetail": "大河庄苑"
    },
    "relation": 7
}
```

OUTPUT

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

### 接口说明
- minPrepareTime的单位是分钟。

## 提交订单         				
POST /api/shooter/v1/users/orders/place-order
### 接口描述
用户完善个人基本信息，并提交。
### 接口详情

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

### 接口说明
userAddressId即patientId。

## 删除当前患者
DELETE /api/shooter/v1/users/delete/user-addresses/{userAddressId}
### 接口描述
用户删除当前患者信息
### 接口详情

```json
{
    "result": {
        "success": true,
        "code": 0
    }
}
```

## 项目排期

## 人日

工作内容 | 内容详情 | 人日 | 完成情况 | 完成时间
------- | -----  | ---- | ------- | -----------
服务详情接口 | 查 | 1人日 | √ | 2.18
用户下单前所需item、患者列表信息 | 查 | 1人日 | √ | 2.21 
修改前，查询患者信息	 | 查 | 1人日 | √ | 2.21
用户与患者的关系	 | 查 | 1人日 | √ |2.17
提交修改的患者信息  | 改 | 1人日 | √ |2.21
新增患者信息 | 增 | 1人日 | √ | 2.21
服务时间  | 查 | 1人日 | √ | 2.22
提交订单  | 增 | 1人日 | √ | 2.21
删除当前患者| 删 | 1人日 | √ | 2.21
测试 | 后端自测 | 1人日 | √ | 2.23上午
测试 | 前后端联调 | 1人日 | √ | 2.25上午





