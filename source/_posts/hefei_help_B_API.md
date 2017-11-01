---
title: 护士上门辅助下单功能项目B端API
date: 2017-3-13 11:00:00
categories: 上门护理
tags:
- 上门护理
---
## 摘要

辅助下单B端API
<!--more-->

## Wiki维护人

陈晨
杨淑婷

## 页面维度


### 名词解释
用户：是登录APP的人，用手机号进行区别。
患者：是指具体的科室里的用户。
用户地址：是登陆APP的人中，创建订单后被设置的服务人的信息
服务商品：当前科室下，能够提供的服务，每一项服务称为一个服务单元。
服务单元：是在订单中已经确定的服务商品。


### 新建一个下单用户

POST /api/nurses/order/v1/createUser?nurseId={nurseId}
### 辅助下单用户详情接口

GET /api/nurses/order/v1/getUserDetail?userId={userId}&userDepartmentId={userDepartmentId}

### 选择并修改原有用户的信息  

PATCH /api/nurses/order/v1/updateUser?userId={userId}&userDepartmentId={userDepartmentId}

### 获取当前科室下的所有服务商品

GET /api/nurses/order/v1/getAllService?nurseId={nurseId}
 
### 获取当前科室下的所选服务商品的服务护士

GET /api/nurses/order/v1/getAllServiceNurse?itemId={itemId}&nurseId={nurseId}

### 获取当前科室下的所选服务商品的服务时间

GET /api/nurses/order/v1/getServiceTime?itemId={itemId}
### 创建辅助订单

POST /api/nurses/order/v1/createAssistOrder?itemId={itemId}&nurseId={nurseId}&userId={userId}&userDepartmentId={userDepartmentId}


## 已有接口

### 获取辅助下单当前科室的所有患者

/api/nurses/{nurseId}/patients


 
## API接口

### 新建一个下单用户

POST /api/nurses/order/v1/createUser?nurseId={nurseId}

##### 描述

在创建订单页面，如果下单用户不在患者列表中，进行新建用户操作。
 
##### 接口详情

request:  Farmer.UserAddOption

``` Json

{
      "name": "高金新",
      "gender":0,                      //性别 0,表示女，1表示男
      "idCard":"410822199412235528",     //身份证号
      "phone":"13581708860",             //手机号
      "birthday": "11488280311",         //出生日期（时间戳）
      "address": {                     //地址
                "province": "河北",         //省
                "city": "合肥市",            //城市
                "district": "庐阳区",        //区域
                "addressDetail": "安景苑7号楼2单元108"//具体地址 
            }
      
}

```

response:  Farmer.UserAddDTO

``` Json
{
    "result": {
        "success": true,
        "code": 0
    },
    "userInfo":{              //用户
         "userId":123,    //用户ID
         "name":"张跃超"   //用户姓名
           },
    }

```

##### 接口说明

* 在创建用户时，后端要默认给用户一个头像


### 辅助下单用户详情接口

GET /api/nurses/order/v1/getUserDetail?userId={userId}&userDepartmentId={userDepartmentId}

##### 描述
查看用户的详细信息

##### 接口详情

response:    Farmer.UserInfoDTO

``` Json
{
    "result": {
        "success": true,
        "code": 0
    },
    "userInfo":{
         "userId":256,
         "name": "高金新",
         "gender":0,
         "birthDay":"12324244",
         "idCard":"410822199412235528",
         "phone":"13581708860",
         "address": {
                "province": "河北",
                "city": "合肥市",
                "district": "庐阳区",
                "addressDetail": "安景苑7号楼2单元108"
            }
      }
}


```


### 选择并修改原有用户的信息
  
PATCH /api/nurses/order/v1/updateUser?userId={userId}&userDepartmentId={userDepartmentId}

##### 描述

选择已存在于患者列表中的用户，完善用户信息。

##### 接口详情

request:Farmer.UpdateOption

``` Json
{ 
	 "userId": 100168,
    "name": "猪猪侠1",
    "gender": 0,
    "birthday": "785433600000",
    "phone": "13581788880",
    "idCard": "410822199411225528",
    "address": {
        "province": "河南生",
        "city": "郑州市",
        "district": "科学大道",
        "addressDetail": "107号"
    }
 }


```

response:Farmer.ChangeResultDTO

``` Json
{
    "result": {
        "success": true,
        "code": 0
    }
}

```

### 获取当前科室下的所有服务商品

GET /api/nurses/order/v1/getAllService?nurseId={nurseId}

##### 描述
展示出该科室下所有的服务商品

##### 接口详情

response:Farmer.OrderServiceDTO

``` Json

{
  "item": [
    {
      "ItemId": 7,
      "name": "造口护理【自备物品】",
      "pic": "http://yhjstatic-dev.oss-cn-shanghai.aliyuncs.com/avatar/74b17a26-a1f9-1765-4c27-6773c965e42b.jpg",
      "price": 1,
      "desc": "通过人造开口，帮助患者排除粪便或者尿液，造口袋是用于储存人体排泄物的容器物，如尿液、粪便，适用于肛肠、尿道、双腔造口人士。家属自备物品：造口剪刀、造口粉、防漏膏、皮肤保护膜、一次性手套、旧报纸或马甲袋、纸巾或棉签、干纱布、造口测量尺、纸胶、温盐水或者温开水、吸水纸。[温馨提示家属选择正规医院或者药店购买，注意检查物品有效期等]护士备物品：手套、鞋套、口罩、手消毒液"
    },
  {
      "ItemId": 1,
      "name": "女患者导尿【自备物品】",
      "pic": "http://pic1.win4000.com/wallpaper/c/53cdd20a3a327.jpg",
      "price": 1,
      "desc": "导尿护理-老小子的拿手戏"
    }
  ],
  "result": {
    "success": true,
    "code": 0
  }
}

```

### 获取当前科室下的所选服务商品的所有服务护士

GET /api/nurses/order/v1/getAllServiceNurse?itemId={itemId}&nurseId={nurseId}

##### 描述
获取当前科室下的所选服务商品的所有服务护士

##### 接口详情

response:Farmer.ServiceNurseDTO

``` Json
{

 "result": {
    "success": true,
    "code": 0
  }
  "nurse": [        //护士
    {
      "nurseId": 1,      //护士ID
      "name": "新名字",       //护士姓名
      "avatar": "http://yhjstatic-dev.oss-cn-shanghai.aliyuncs.com/avatar/fdd78903-8123-00e3-6aa0-7102f778ae69.jpg?x-oss-process=image/resize,h_500"
    },              //护士头像  
    {
      "nurseId": 444,
      "name": "旭红",
      "avatar": "http://yhjstatic.oss-cn-shanghai.aliyuncs.com/avatar/bd143049-fb2e-4eef-80b3-9a7f24f07b1b.png"
    }
  ],
 }

```
### 获取当前科室下的所选服务的所有服务时间
GET /api/nurses/order/v1/getServiceTime?itemId={itemId}

##### 描述

获取当前科室下的所选服务的所有服务时间

##### 接口详情

response:Farmer.ServiceTimeDTO

``` Json

{
    "result": {
        "success": true,
        "code": 0
    },
    "servingTime": [                //服务单元服务时间
                 { 
                    "date": "15号",         // 日期
                    "weekdays":"周一",       //星期
                    "time": [                //时间
                        {
                            "title": "10:00",   //具体时间点
                             "detailTime": 1479712913000   //具体时间点的时间戳
                        },
                        {
                            "title": "10:00",
                            "detailTime": 1479712913000
                        }
                    ]
        }
    ]
}


```

 

### 创建辅助订单  

POST /api/nurses/order/v1/createAssistOrder?itemId={itemId}&nurseId={nurseId}&userId={userId}&userDepartmentId={userDepartmentId}
 

##### 描述

患者信息，服务信息，护士信息已完整，开始进行支付

##### 接口详情

request:Farmer.CreateOrderOption

``` Json
  { 
            "patientId": 123,            //患者ID
            "serviceItemId": 123,         //服务单元的ID
            "servingTime": 1479712913000,  //服务时间    
            "nurseId":123,                 //护士id
            "itemId": 123,                 //服务商品ID
            "servingNurseId":12           //服务护士ID
    }

```

response:Farmer.OrderAddDTO

``` Json

  {
    "result": {
        "success": true,
        "code": 0
    }
}

```















