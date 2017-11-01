---
title: 【合肥项目】Item-API
date: 2017-1-6 12:00:00
categories: 合肥
tags:
- Item
---

## 摘要

 合肥项目-商品服务API

<!--more-->
## WIKI维护人
卢江
陈晨
田学文

# 商品服务API详细设计
## 创建商品接口设计
POST /api/dagon/v1/item
### 接口描述
商品系统管理员创建抽象商品操作
### Request

``` json
{
	"name":"鼻饲",
	"desc":"鼻饲是将导管经鼻腔插入胃内，从管内输注食物、水分和药物，以维持病人的营养治疗的技术。（包含插胃管和首次鼻饲）家属自备物品：一次性无菌鼻胃管：（一套：胃管+无菌手套+鼻贴+盘带+无菌注射+棉签），适量开水（38～40℃），鼻饲饮料（38～40℃）。[温馨提示家属选择正规医院或者药店购买，注意检查物品有效期等]护士自备物品：手套、鞋套、听诊器、口罩、手消毒液", 
	"departmentId":1,
	"categoryId":9,
	"picture":[
		{
			"pictureItem":{
				"pictureInfo":"http://pic1.win4000.com/wallpaper/c/53cdd20a3a327.jpg"
			}
		}
	]
}
```
### Response

``` json
{
    "result": {
        "success": true,
        "code": 0
      },
      "item": {
            "itemId": 1,
            "name": "鼻饲",
            "desc": "鼻饲是将导管经鼻腔插入胃内，从管内输注食物、水分和药物，以维持病人的营养治疗的技术。（包含插胃管和首次鼻饲）家属自备物品：一次性无菌鼻胃管：（一套：胃管+无菌手套+鼻贴+盘带+无菌注射+棉签），适量开水（38～40℃），鼻饲饮料（38～40℃）。[温馨提示家属选择正规医院或者药店购买，注意检查物品有效期等]护士自备物品：手套、鞋套、听诊器、口罩、手消毒液",
            "price": 0,
            "departmentId": 1,
            "categoryId": 8,
            "status": 1,
            "picture": {
              "pictureItem": [
                {
                  "pictureInfo": "http://pic1.win4000.com/wallpaper/c/53cdd20a3a327.jpg"
                }
              ]
            }
        }
}
```
### 实现设计
校验上游传入的商品添加信息，包括name，desc，departmentId，categoryId，picture，数据合法则保存到数据库。

## 查询单个商品接口设计
GET /api/dagon/v1/item/{itemId}
### 接口描述
商品系统管理员查询单个商品
### Response

``` json
{
    "result": {
        "success": true,
        "code": 0
      },
      "item": {
            "itemId": 1,
            "name": "鼻饲",
            "desc": "鼻饲是将导管经鼻腔插入胃内，从管内输注食物、水分和药物，以维持病人的营养治疗的技术。（包含插胃管和首次鼻饲）家属自备物品：一次性无菌鼻胃管：（一套：胃管+无菌手套+鼻贴+盘带+无菌注射+棉签），适量开水（38～40℃），鼻饲饮料（38～40℃）。[温馨提示家属选择正规医院或者药店购买，注意检查物品有效期等]护士自备物品：手套、鞋套、听诊器、口罩、手消毒液",
            "price": 0,
            "departmentId": 1,
            "categoryId": 8,
            "status": 1,
            "picture": {
              "pictureItem": [
                {
                  "pictureInfo": "http://pic1.win4000.com/wallpaper/c/53cdd20a3a327.jpg"
                }
              ]
            }
        }
}
```

## 修改单个商品接口设计
PATCH /api/dagon/v1/item/{itemId}
### 接口描述
对单个商品进行修改
### Request

``` json
{
	"name":"鼻饲",
	"desc":"鼻饲是将导管经鼻腔插入胃内，从管内输注食物、水分和药物，以维持病人的营养治疗的技术。（包含插胃管和首次鼻饲）家属自备物品：一次性无菌鼻胃管：（一套：胃管+无菌手套+鼻贴+盘带+无菌注射+棉签），适量开水（38～40℃），鼻饲饮料（38～40℃）。[温馨提示家属选择正规医院或者药店购买，注意检查物品有效期等]护士自备物品：手套、鞋套、听诊器、口罩、手消毒液", 
	"departmentId":1,
	"categoryId":9,
	"picture":[
		{
			"pictureItem":{
				"pictureInfo":"http://pic1.win4000.com/wallpaper/c/53cdd20a3a327.jpg"
			}
		}
	]
}
```
### Response
```json
{
    "result": {
        "success": true,
        "code": 0
      },
      "item": {
            "itemId": 1,
            "name": "鼻饲",
            "desc": "鼻饲是将导管经鼻腔插入胃内，从管内输注食物、水分和药物，以维持病人的营养治疗的技术。（包含插胃管和首次鼻饲）家属自备物品：一次性无菌鼻胃管：（一套：胃管+无菌手套+鼻贴+盘带+无菌注射+棉签），适量开水（38～40℃），鼻饲饮料（38～40℃）。[温馨提示家属选择正规医院或者药店购买，注意检查物品有效期等]护士自备物品：手套、鞋套、听诊器、口罩、手消毒液",
            "price": 0,
            "departmentId": 1,
            "categoryId": 8,
            "status": 1,
            "picture": {
              "pictureItem": [
                {
                  "pictureInfo": "http://pic1.win4000.com/wallpaper/c/53cdd20a3a327.jpg"
                }
              ]
            }
        }
}
```

### 实现设计
根据传入的商品Id查询该商品，校验上游传入的商品修改数据，数据合法之后对商品修改保存。

## 上线商品接口设计
PATCH /api/dagon/v1/item/online/{itemId}
### 接口描述
商品管理员对某个商品进行上线操作

### Response
```json
{
    "result": {
        "success": true,
        "code": 0
    }
}
```
## 下线商品接口设计
PATCH /api/dagon/v1/item/offline/{itemId}
### 接口描述
商品管理员对某个商品进行下线操作

### Response
```json
{
    "result": {
        "success": true,
        "code": 0
    }
}
```

## 添加单个商品的属性接口设计
POST /api/dagon/v1/item/{itemId}/item-props-and-value
### 接口描述
商品系统管理员对某个商品添加商品属性
### Request

``` json
{
	"itemId":7,
	"itemPropName":"套餐"
}
```
### Response

``` json
{
     "result": {
         "success": true,
         "code": 0
     },
     "itemProp": {
         "id": 5,
         "itemId": 7,
         "name": "套餐"
     }
}
```
### 实现设计
根据传入的商品Id查询该商品，校验传入的商品属性信息，信息合法则写入数据库

## 查询单个商品的属性列表接口设计
GET /api/dagon/v1/item-props/{itemId}
### 接口描述
商品系统管理员查询某个商品的所有属性
### Response

``` json
{
  "result": {
    "success": true,
    "code": 0
  },
  "itemProp": [
    {
      "id": 10,
      "itemId": 6,
      "name": "物料",
      "itemPropValue": [
        {
          "id": 19,
          "name": "自备物料"
        }
      ]
    },
    {
      "id": 12,
      "itemId": 6,
      "name": "套餐",
      "itemPropValue": [
        {
          "id": 20,
          "name": "1次"
        }
      ]
    }
  ]
}
```
### 实现设计
根据传入的商品Id查询该商品，校验传入的商品属性信息，信息合法则写入数据库

## 修改单个抽象商品对应的属性接口设计
PATCH /api/dagon/v1/item-props/{itemPropId}
### 接口描述
商品管理员修改单个抽象商品对应的属性

### Request
```json
{
    "itemId":12,
    "itemPropName":"级别"
}
```
### Response
```json
{
  "result": {
    "success": true,
    "code": 0
  },{
	   "itemId":12,
	   "itemPropName":"级别"
    }
}
```
###实现设计
根据传入的属性Id查询数据库，修改属性名称之后保存到数据库

## 删除单个商品的属性接口设计
DELETE /api/dagon/v1/item-props/{itemPropId}
### 接口描述
商品管理员删除单个商品的某个属性
### Response
```json
{
  "result": {
    "success": true,
    "code": 0
  }
}
```
## 增加单个商品属性所对应的属性值接口设计
POST /api/dagon/v1/item-props/{itemPropId}/values
### 接口描述
商品管理员删除单个商品的某个属性
### Request
```json
{
  "itemPropId":8,
  "itemPropValue": [
    	{
          "name": "普通"
        },
        {
          "name": "高级"
        }
  	]
}
```

### Response
```json
{
  "result": {
    "success": true,
    "code": 0
  },
  "itemProp": {
      "id": 5,
      "itemId": 12,
      "name": "级别",
      "itemPropValue": [
        {
          "id": 60,
          "name": "普通"
        },
        {
          "id": 61,
          "name": "高级"
        }
      ]
    }
}
```
### 实现设计
根据传入的属性Id，查询数据库，校验传入的属性Id是否存在，若属性Id存在，校验传入的属性值信息，若属性值信息合法，则查询具体商品属性值表，若该表为空，则根据传入的每个属性值生成一个具体商品，若具体商品属性值表不为空，则需要将具体商品属性值表的所有属性值信息查询出来，叉乘最新的属性值，生成新的具体商品记录，而具有原来属性值的具体商品更改名称。


## 修改单个商品属性所对应的属性值接口设计
PATCH /api/dagon/v1/item-props/{itemPropId}/values
### 接口描述
商品系统管理员某个商品的某个属性所对应的属性值进行修改
### Request
``` json
{
  "itemPropId":5,
  "itemPropValue": [
    	{
       "id":99,
       "name": "10天"
     }
  	]
}
```
### Response

``` json
{
  "result": {
    "success": true,
    "code": 0
  },
  "itemProp": [
    {
      "id": 10,
      "itemId": 6,
      "name": "周期",
      "itemPropValue": [
        {
          "id": 22,
          "name": "5天"
        },
        {
          "id": 99,
          "name": "10天"
        }
      ]
    }
  ]
}
```
### 实现设计
根据传入的属性Id，查询数据库，校验传入的属性Id是否存在，若属性Id存在，校验传入的属性值信息，若属性值Id存在，则更新属性值Id指向的属性值，同时，修改具有该属性值的具体商品名称。

## 删除单个商品属性所对应的属性值接口设计
DELETE /api/dagon/v1/item-props/{itemPropId}/values/{itemPropValueId}
### 接口描述
删除某个商品的某个属性下的属性值

### Response

``` json
{
  "result": {
    "success": true,
    "code": 0
  }
}
```
### 实现设计
根据传入的属性Id，查询数据库，校验传入的属性Id是否存在，若属性Id存在，校验传入的属性值信息，若属性值Id存在，查询该属性下的属性值个数。若属性值个数只有一个，则修改具体商品名称，删除属性值表中该属性值，删除具体商品属性值表中关联该属性值的所有记录，否则删除具体商品表中关联该属性值的所有记录，删除属性值表中该属性值，删除具体商品属性值表中关联该属性值的所有记录。


## 查询单个具体商品的详情接口设计
GET /api/dagon/v1/service-items/{serviceItemId}
### 接口描述
商品系统管理员查询单个具体商品的详情

### Response

``` json
{
    {
      "result": {
        "success": true,
        "code": 0
      },
      "serviceItem": {
        "id": 11,
        "item": {
          "itemId": 1,
          "name": "晨妈尿管护理",
          "desc": "上门尿管护理，私人订制",
          "price": 11500,
          "departmentId": 1,
          "categoryId": 10,
          "createdAt": 1483426590000,
          "updatedAt": 1483608832000,
          "status": 4,
          "picture": {
            "pictureItem": [
              {
                "pictureInfo": "http://pic1.win4000.com/wallpaper/c/53cdd20a3a327.jpg"
              }
            ]
          }
        },
        "desc": "晨妈专注五十年~专业尿管护理",
        "price": 11000,
        "originPrice": 12000,
        "name": "晨妈尿管护理-男",
        "duration": 7200,
        "picture": {
          "pictureItem": [
            {
              "pictureInfo": "http://pic1.win4000.com/wallpaper/c/53cdd20a3a327.jpg"
            }
          ]
        },
        "standardTemplateId": 8787,
        "standardTemplateType": 3,
        "serviceItemProp": [
          {
            "id": 5,
            "name": "性别",
            "valueId": 9,
            "valueName": "男"
          }
        ]
      }
    }
}
```
### 实现设计
根据传入的具体商品Id查询具体商品表。

## 查询某个商品的具体商品列表接口设计
GET /api/dagon/v1/item/{itemId}/service-items
### 接口描述
商品管理员查询某个商品的具体商品列表接口设计
### Response
```json
{
  "result": {
    "success": true,
    "code": 0
  },
  "serviceItem": [
    {
      "id": 14,
      "item": {
        "itemId": 4,
        "name": "鼻饲",
        "desc": "鼻饲是将导管经鼻腔插入胃内，从管内输注食物、水分和药物，以维持病人的营养治疗的技术。（包含插胃管和首次鼻饲）家属自备物品：一次性无菌鼻胃管：（一套：胃管+无菌手套+鼻贴+盘带+无菌注射+棉签），适量开水（38～40℃），鼻饲饮料（38～40℃）。[温馨提示家属选择正规医院或者药店购买，注意检查物品有效期等]护士自备物品：手套、鞋套、听诊器、口罩、手消毒液",
        "price": 18000,
        "departmentId": 1,
        "categoryId": 9,
        "createdAt": 1483596770000,
        "updatedAt": 1483692589000,
        "status": 4,
        "picture": {
          "pictureItem": [
            {
              "pictureInfo": "http://yhjstatic-dev.oss-cn-shanghai.aliyuncs.com/avatar/e6b51b90-0951-b9d8-a432-b07655fbf079.jpg"
            }
          ]
        }
      },
      "desc": "鼻饲是将导管经鼻腔插入胃内，从管内输注食物、水分和药物，以维持病人的营养治疗的技术。（包含插胃管和首次鼻饲）家属自备物品：一次性无菌鼻胃管：（一套：胃管+无菌手套+鼻贴+盘带+无菌注射器+棉签），适量开水（38～40℃），鼻饲饮料（38～40℃）。[温馨提示家属选择正规医院或者药店购买，注意检查物品有效期等]护士自备物品：手套、鞋套、听诊器、口罩、手消毒液。",
      "price": 18000,
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
      "standardTemplateId": 8787,
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
    {
      "id": 15,
      "item": {
        "itemId": 4,
        "name": "鼻饲",
        "desc": "鼻饲是将导管经鼻腔插入胃内，从管内输注食物、水分和药物，以维持病人的营养治疗的技术。（包含插胃管和首次鼻饲）家属自备物品：一次性无菌鼻胃管：（一套：胃管+无菌手套+鼻贴+盘带+无菌注射+棉签），适量开水（38～40℃），鼻饲饮料（38～40℃）。[温馨提示家属选择正规医院或者药店购买，注意检查物品有效期等]护士自备物品：手套、鞋套、听诊器、口罩、手消毒液",
        "price": 18000,
        "departmentId": 1,
        "categoryId": 9,
        "createdAt": 1483596770000,
        "updatedAt": 1483692589000,
        "status": 4,
        "picture": {
          "pictureItem": [
            {
              "pictureInfo": "http://yhjstatic-dev.oss-cn-shanghai.aliyuncs.com/avatar/e6b51b90-0951-b9d8-a432-b07655fbf079.jpg"
            }
          ]
        }
      },
      "desc": "鼻饲是将导管经鼻腔插入胃内，从管内输注食物、水分和药物，以维持病人的营养治疗的技术。（包含插胃管和首次鼻饲）代购物品：一次性无菌鼻胃管：（一套：胃管+无菌手套+鼻贴+盘带+无菌注射器+棉签共计110元）[温馨提示护士代购按照正规医院或者药店购买，注意检查物品有效期等]家属备物品：夹子、别针、适量开水（38～40℃），鼻饲饮料（38～40℃）。护士自备物品：手套、鞋套、听诊器、口罩、手消毒液",
      "price": 30000,
      "originPrice": 12000,
      "name": "鼻饲-代购物料-1次",
      "duration": 4500,
      "picture": {
        "pictureItem": [
          {
            "pictureInfo": "http://yhjstatic-dev.oss-cn-shanghai.aliyuncs.com/avatar/e6b51b90-0951-b9d8-a432-b07655fbf079.jpg"
          }
        ]
      },
      "standardTemplateId": 8787,
      "standardTemplateType": 3,
      "serviceItemProp": [
        {
          "id": 6,
          "name": "物料",
          "valueId": 12,
          "valueName": "代购物料"
        },
        {
          "id": 7,
          "name": "套餐",
          "valueId": 13,
          "valueName": "1次"
        }
      ]
    }
  ]
}
```
### 实现设计
根据商品Id查询具体商品表。

## 修改具体商品信息接口设计
PATCH /api/dagon/v1/service-items/{serviceItemId}
### 接口描述
商品管理员对某个具体商品进行修改
### Request
```json
{
	"serviceItemId":25,
	"itemId":1,
	"desc": "晨妈专注五十年~专业尿管护理",
	"price":110,
	"durationion":7200,
	"standarddTemplateId": 1,
	"standardTemplateType": 1,
	"picture":{
        "pictureItem": [
          {
            "pictureInfo": "http://pic1.win4000.com/wallpaper/c/53cdd20a3a327.jpg"
          }
        ]
      }
}
```
### Response
```json
{
    "result": {
        "success": true,
        "code": 0
    },
    "serviceItem":{
      "id": 25,
      "item": {
        "itemId": 1,
        "name": "晨妈尿管护理",
        "desc": "上门尿管护理，私人订制",
        "price": 11500,
        "departmentId": 1,
        "categoryId": 10,
        "createdAt": 1483426590000,
        "updatedAt": 1483608832000,
        "status": 4,
        "picture": {
          "pictureItem": [
            {
              "pictureInfo": "http://pic1.win4000.com/wallpaper/c/53cdd20a3a327.jpg"
            }
          ]
        }
      },
      "desc": "晨妈专注五十年~专业尿管护理",
      "price": 11000,
      "originPrice": 12000,
      "name": "晨妈尿管护理-男",
      "duration": 7200,
      "picture": {
        "pictureItem": [
          {
            "pictureInfo": "http://pic1.win4000.com/wallpaper/c/53cdd20a3a327.jpg"
          }
        ]
      },
      "standardTemplateId": 8787,
      "standardTemplateType": 3,
      "serviceItemProp": [
        {
          "id": 5,
          "name": "性别",
          "valueId": 9,
          "valueName": "男"
        }
      ]
    }
}
```
### 实现设计
根据传入的具体商品Id查询该商品，校验上游传入的修改数据，数据合法之后进行修改保存。

## 添加类目接口设计
POST /api/dagon/v1/categories
### 接口描述
商品系统管理员添加类目
### Request
```json
{
	"levelOneId":1,
	"levelOneName": "居家服务",
	"levelTwoId":2,
	"levelTwoName":"居家日间服务",
	"levelThreeId":3,
	"levelThreeName":"晨间护理"
}
```
### Response
```json
{
    "result": {
        "success": true,
        "code": 0
    },
    "category":{
        	"levelOneId":1,
        	"levelOneName": "居家服务",
        	"levelTwoId":2,
        	"levelTwoName":"居家日间服务",
        	"levelThreeId":3,
        	"levelThreeName":"晨间护理"
    }
}
```
### 实现设计
校验提交数据，判断在父节点存在的情况下，子节点是否才出现。若数据合法，则保持数据到数据库。

## 查询类目接口设计
GET /api/dagon/v1/categories/{categoryId}
### 接口描述
商品系统管理员查询单个类目下的所有类目
### Response

``` json
{
  "result": {
    "success": true,
    "code": 0
  },
  "category": {
    "levelOneId": 1,
    "levelOneName": "护理",
    "levelTwoId": 2,
    "levelTwoName": "功能性护理",
    "levelThreeId": 3,
    "levelThreeName": "康护护理",
    "levelFourId": 4,
    "levelFourName": "上门护理",
    "levelFiveId": 5,
    "levelFiveName": "尿管护理"
  }
}
```

### 实现设计
根据传入的类目Id查询类目表。


