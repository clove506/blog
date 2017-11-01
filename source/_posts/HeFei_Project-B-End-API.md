---
title: 【优护助手-合肥】合肥项目-B端API
date: 2017-2-24 14:16:13
categories: 合肥
tags:
- 优护助手
---
## 摘要
合肥项目-护士端API

<!--more-->


## 页面维度
### 首页接口
GET /api/nurses/order/v1/workbench

### 订单列表接口
 GET /api/nurses/order/v1/?index=0&size=9&status=waitServing
 GET /api/nurses/order/v1/?index=0&size=9&status=accepted
 
### 订单详情
GET /api/nurses/order/v1/{orderId}/detail

### 服务设置管理页面接口 && 可服务项目接口 
GET /api/nurses/order/v1/{nurseId}/serviceManager?nurseId={nurseId} 
### 申请进入纠纷 
PATCH /api/nurses/order/v1/refund/{orderId}?orderId={orderId}&nurseId={nurseId}

### 征求服务人员退款意见 
PATCH api/nurses/order/v1/{orderId}/nurseOpinion?orderId={orderId}&nurseId={nurseId}


### 服务人员主动取消订单  
PATCH api/nurses/order/v1/{orderId}/nurseCancel?orderId={orderId}&nurseId={nurseId}

### 可服务项目的更新
PATCH api/nurses/order/v1/{itemId}/updateService?nurseId={nurseId}


### 详情页-护士确定完成订单ok
PATCH /api/nurses/order/v1/{orderId}/nurseComplete？orderId={orderId}&nurseId={nurseId}

### 详情页-护士确定完成订单的当前服务  
PATCH api/nurses/order/v1/{orderId}/completeService?nurseId={nurseId}&orderId={orderId}

### 接受推送接口
PATCH api/nurses/order/v1/{nurseId}/pushService?nurseId={nurseId}

### 接单 
PATCH /api/nurses/order/v1/{orderId}/accept?orderId={orderId}&nurseId={nurseId}

 
## API 接口

### 首页接口
GET /api/nurses/order/v1/workbench

##### 描述
查询是否有新订单，有新订单，显示新订单个数。

##### 接口详情

Output:

``` Json

{
    "result": {
        "success": true,
        "code": 0
    },
    "bannerURL": "http://xxx.com/me.jpg",                     //首页接口的图片
    "nurseId": 111,                                           //护士Id
    "order": [
        {
            "orderId": 998,
            "nurseId": 1,
            "orderNo": "21",
            "servingTime": 1479712913000,
            "orderTime": 1479712913000,                     //下单时间（B端并未使用）
            "item": {
                "itemId": 887,
                "name": "上门尿管护理",
                "price": 12000,
                "period": 7200,
                "pic": "http: //img1.imgtn.bdimg.com/it/u=3505488306691858093&fm=21&gp=0.jpg"
            },
            "patient": {
                "patientId": 123,
                "name": "张富贵",
                "gender": "男",
                "phone": "18612345678",
                "age": 53,
                "address": "合肥市庐阳区安景苑7号楼2单元108"
            },
            "statusAction": {
                "statusType": 0,
                "statusDisplayMsg": "待接单",
                "statusColor": "red"
            }
        }
    ],
    "openService": true                                  //判断权限，是否为合肥医院的
}
```
### 订单列表接口
 GET /api/nurses/order/v1/?index=0&size=9&status=waitServing
 GET /api/nurses/order/v1/?index=0&size=9&status=accepted      

##### 描述
显示待接单或已接单的List

##### 接口详情  
在待接单的状态下，显示所有待接单的信息。
在已接单的状态下，显示自己已接单的订单信息。

#### 待接单
 output: 
 
 
``` Json

 {
    "result": {
        "success": true,
        "code": 0
    },
    "order": [
        {
            "orderId": 998,                       //订单的Id
            "orderNo": "21",                      //订单编号
            "orderTime": 1479712913000,            //下单时间（B端并未使用）
            "servingTime": 1479712913000,           //服务时间
            "item": {                               //item
                "itemId": 887,                       //itemId
                "name": "上门尿管护理",                //item姓名
                "price": 12000,                      //item价格
                "period": 7200,                       //耗时
                "pic": "http: //img1.imgtn.bdimg.com/it/    u=3505488306691858093&fm=21&gp=0.jpg"                   //宝贝的图片
            },
            "statusAction": {                           //状态
                "statusType": 0,                         //状态的类型
                "statusDisplayMsg": "待接单",              //具体状态
                "statusColor": "red"                   //状态的颜色
            },
            "patient": {                                  //患者
                "patientId": 123,                         //患者Id
                "phone": "18612345678",                    //患者的电话
                "name": "张富贵",                            //患者姓名
                "gender": "男",                              //患者性别
                "age": 53,                                   //患者年龄
                "address": "合肥市庐阳区安景苑7号楼2单元108"      //患者地址
            },
            "availableAction": [                             //按钮                        
                {
                    "title": "接单",                          //按钮上显示的字
                    "action": "accept"                        //描述
                }
            ]
        }
    ]
}
```

#### 已接单

 Output:  
   
   
```json

{
    "result": {
        "success": true,
        "code": 0
    },
    "order": [
        {
            "orderId": 998,
            "nurseId":11,
            "item": {
                "itemId": 887,
                "name": "上门尿管护理",
                "price": 12000,
                "period": 7200,
                "pic": "http: //img1.imgtn.bdimg.com/it/u=3505488306691858093&fm=21&gp=0.jpg"
            },
            "statusAction": {
                "statusType": 2,
                "statusDisplayMsg": "服务中",
                "statusDescMsg": "用户申请退款",
                "statusColor": "green"
            },
            "patient": {
                "patientId": 123,
                "name": "张富贵",
                "gender": "男",
                "phone": "18612345678",
                "age": 53,
                "address": "合肥市庐阳区安景苑7号楼2单元108"
            },
            "orderNo":"21",
            "orderTime": 1479712913000,
            "servingTime": 1479712913000
        }
    ]
}

```
 
    
标注：   
* period：表示服务耗时，以秒为单位
* orderTime：下单时间
* servingTime：服务开始时间


### 订单详情
GET /api/nurses/order/v1/{orderId}/detail/

##### 描述
点击订单内容展示区或者内容服务中，进入订单详情页。
详情页包括：待接单，待服务，服务中,服务结束，用户申请退款。
服务中状态包括：1.用户申请退款被拒绝，进入纠纷，2.服务人员服务中申请进入纠纷。

#### 接口详情

#### 待接单(服务内容不能点开)

Output:

```json

{
    "result": {
        "success": true,
        "code": 0
    },
    "order": {
        "orderId": 998,
        "nurseId": 1,
        "orderNo": "21",
        "servingTime": 1479712913000,
        "orderTime": 1479712913000,
        "status": {
            "statusType": 6,
            "statusDisplayMsg": "待接单",
            "color": "red"
        },
        "item": {
            "itemId": 887,
            "name": "上门尿管护理",
            "price": 12000,
            "period": 7200,
            "pic": "http: //img1.imgtn.bdimg.com/it/u=3505488306691858093&fm=21&gp=0.jpg",
            "desc": "根据患者病情状态，进行导尿管道的常规护理操作，要求避免管道感染等并发症"
        },
        "patient": {
            "patientId": 45273,
            "name": "张富贵",
            "gender": "男",
            "age": 53,
            "phone": "18612345678",
            "address": "合肥市庐阳区安景苑7号楼2单元108"
        },
        "action": [                                // 服务内容
            {
                "actionId": 4,                     //服务的Id
                "type": 5,                         //服务类型
                "title": "推送健康宣教知识",          //服务标题
                "desc": "下单后，系统自动为您推送"      //服务描述
            },
            {
                "actionId": 5,
                "type": 6,
                "title": "服务前评估",
                "desc": "服务前，对患者状态进行综合评估"
            },
            {
                "actionId": 6,
                "type": 7,
                "title": "尿管护理操作",
                "desc": "对尿管进行护理操作，时长约100分钟"
            }
        ],
        "availableAction": [
            {
                "title": "接单",
                "action": "accept"
            }
        ]
    }
}

```

#### 待服务

Output:

``` json

{
    "result": {
        "success": true,
        "code": 0
    },
    "order": {
        "orderId": 998,
        "orderNo": "21",
        "orderTime": 1479712913000,
        "servingTime": 1479712913000,
        "nurseId": 111,
        "status": {
            "statusType": 7,
            "statusDisplayMsg": "待服务",
            "color": "green"
        },
        "item": {
            "itemId": 887,
            "name": "上门尿管护理",
            "price": 12000,
            "period": 7200,
            "pic": "http: //img1.imgtn.bdimg.com/it/u=3505488306691858093&fm=21&gp=0.jpg",
            "desc": "根据患者病情状态，进行导尿管道的常规护理操作，要求避免管道感染等并发症"
        },
        "patient": {
            "patientId": 45273,
            "name": "张富贵",
            "gender": "男",
            "age": 53,
            "phone": "18612345678",
            "address": "合肥市庐阳区安景苑7号楼2单元108"
        },
        "action": [
            {
                "actionId": 1,                    //服务Id
                "actionType": 5,                   //服务类型
                "order": 1,                         //用来排序
                "title": "推送健康宣教知识",            //服务标题
                "desc": "下单后，系统自动为您推送",       //服务描述
                "progress": {                         //完成进度
                    "Msg": "1/3",                     //具体进程描述
                    "color": "red"                     //描述的颜色
                },
                "content": [                           //内容    
                    {                      
                        "id": 2,                        //内容的Id
                        "status": {                      //内容的具体状态
                            "title": "睡眠指南",          //内容的标题
                            "progress": {                //内容的进度
                                "statusMsg": "已读",      //显示该条信息是已度还是未读
                                "color": "green"        //已读和未读的颜色
                            }
                        }
                    }
                ]
            },
            {
                "actionId": 2,
                "actionType": 5,
                "order": 1,
                "title": "服务前自测",
                "desc": "服务前，患者进行自我评测",
                "progress": {
                    "Msg": "1/3",
                    "color": "red"
                },
                "content": [
                    {
                        "id": 1,
                        "contentResult": {
                            "title": "自测结果。。。",
                            "detail": "患者大部分日常。。。"
                        },
                        "status": {
                            "title": "基本能力自测",
                            "progress": {
                                "statusMsg": "已自测",
                                "color": "green"
                            }
                        }
                    }
                ]
            },
            {
                "actionId": 2,
                "actionType": 5,
                "order": 5,
                "title": "尿管护理预备操作",
                "desc": "尿管护理预备操作，大约30分钟",
                "progress": {
                    "Msg": "已完成",
                    "color": "red"
                },
                "content": [
                    {
                        "button": {
                            "Msg": "此操做已完成"
                        }
                    }
                ]
            }
        ]
    }
}

```

#### 服务中（用户申请退款被拒绝进入纠纷）

Output:

```json
{
    "result": {
        "success": true,
        "code": 0
    },
    "order": {
        "orderId": 998,
        "orderNo": "21",
        "orderTime": 1479712913000,
        "servingTime": 1479712913000,
        "nurseId": 111,
        "status": {
            "statusType": 8,
            "statusDisplayMsg": "服务中",
            "statusDescMsg": "用户已申请运营介入",
            "color": "green"
        },
        "item": {
            "itemId": 887,
            "name": "上门尿管护理",
            "price": 12000,
            "period": 7200,
            "pic": "http: //img1.imgtn.bdimg.com/it/u=3505488306691858093&fm=21&gp=0.jpg",
            "desc": "根据患者病情状态，进行导尿管道的常规护理操作，要求避免管道感染等并发症"
        },
        "patient": {
            "patientId": 45273,
            "name": "张富贵",
            "gender": "男",
            "age": 53,
            "phone": "18612345678",
            "address": "合肥市庐阳区安景苑7号楼2单元108"
        },
        "action": [
            {
                "actionId": 1,
                "actionType": 5,
                "order": 1,
                "title": "推送健康宣教知识",
                "desc": "下单后，系统自动为您推送",
                "progress": {
                    "Msg": "1/3",
                    "color": "red"
                },
                "content": [
                    {
                        "id": 2,
                        "status": {
                            "title": "睡眠指南",
                            "progress": {
                                "statusMsg": "已读",
                                "color": "green"
                            }
                        }
                    }
                ]
            },
            {
                "actionId": 2,
                "actionType": 5,
                "order": 1,
                "title": "服务前自测",
                "desc": "服务前，患者进行自我评测",
                "progress": {
                    "Msg": "1/3",
                    "color": "red"
                },
                "content": [
                    {
                        "id": 1,
                        "contentResult": {
                            "title": "自测结果。。。",
                            "detail": "患者大部分日常。。。"
                        },
                        "status": {
                            "title": "基本能力自测",
                            "progress": {
                                "statusMsg": "已自测",
                                "color": "green"
                            }
                        }
                    }
                ]
            },
            {
                "actionId": 2,
                "actionType": 5,
                "order": 5,
                "title": "尿管护理预备操作",
                "desc": "尿管护理预备操作，大约30分钟",
                "progress": {
                    "Msg": "已完成",
                    "color": "red"
                },
                "content": [
                    {
                        "button": {
                            "Msg": "此操做已完成"
                        }
                    }
                ]
            },
            {
                "applyRefund": {
                    "Title": "用户申请退款",
                    "cause": "不需要此单服务",
                    "money": 120,
                    "desc": "服务后出现问题，导致不需要此单"
                },
                "availableAction": [
                    {
                        "title": "退款",
                        "action": "agreeRefund"
                    }
                ]
            }
        ]
    }
}

```
 
#### 服务中（服务人员服务中申请进入纠纷）

Output:

```json
{
    "result": {
        "success": true,
        "code": 0
    },
    "order": {
        "orderId": 998,
        "orderNo": "21",
        "orderTime": 1479712913000,
        "servingTime": 1479712913000,
        "nurseId": 111,
        "status": {
            "statusType": 8,
            "statusDisplayMsg": "服务中",
            "statusDescMsg": "您已经申请运营介入",
            "color": "green"
        },
        "item": {
            "itemId": 887,
            "name": "上门尿管护理",
            "price": 12000,
            "period": 7200,
            "pic": "http: //img1.imgtn.bdimg.com/it/u=3505488306691858093&fm=21&gp=0.jpg",
            "desc": "根据患者病情状态，进行导尿管道的常规护理操作，要求避免管道感染等并发症"
        },
        "patient": {
            "patientId": 45273,
            "name": "张富贵",
            "gender": "男",
            "age": 53,
            "phone": "18612345678",
            "address": "合肥市庐阳区安景苑7号楼2单元108"
        },
        "action": [
            {
                "actionId": 1,
                "actionType": 5,
                "order": 1,
                "title": "推送健康宣教知识",
                "desc": "下单后，系统自动为您推送",
                "progress": {
                    "Msg": "1/3",
                    "color": "red"
                },
                "content": [
                    {
                        "id": 2,
                        "status": {
                            "title": "睡眠指南",
                            "progress": {
                                "statusMsg": "已读",
                                "color": "green"
                            }
                        }
                    }
                ]
            },
            {
                "actionId": 2,
                "actionType": 5,
                "order": 1,
                "title": "服务前自测",
                "desc": "服务前，患者进行自我评测",
                "progress": {
                    "Msg": "1/3",
                    "color": "red"
                },
                "content": [
                    {
                        "id": 1,
                        "contentResult": {
                            "title": "自测结果。。。",
                            "detail": "患者大部分日常。。。"
                        },
                        "status": {
                            "title": "基本能力自测",
                            "progress": {
                                "statusMsg": "已自测",
                                "color": "green"
                            }
                        }
                    }
                ]
            },
            {
                "actionId": 2,
                "actionType": 5,
                "order": 5,
                "title": "尿管护理预备操作",
                "desc": "尿管护理预备操作，大约30分钟",
                "progress": {
                    "Msg": "已完成",
                    "color": "red"
                },
                "content": [
                    {
                        "button": {
                            "Msg": "此操做已完成"
                        }
                    }
                ]
            }
        ]
    }
}

```

#### 服务（完成订单  两个页面）

Output:

```json

{
    "result": {
        "success": true,
        "code": 0
    },
    "order": {
        "orderId": 998,
        "orderNo": "21",
        "orderTime": 1479712913000,
        "servingTime": 1479712913000,
        "nurseId": 111,
        "status": {
            "statusType": 8,
            "statusDisplayMsg": "服务中",
            "statusDescMsg": "您已经申请运营介入",
            "color": "green"
        },
        "item": {
            "itemId": 887,
            "name": "上门尿管护理",
            "price": 12000,
            "period": 7200,
            "pic": "http: //img1.imgtn.bdimg.com/it/u=3505488306691858093&fm=21&gp=0.jpg",
            "desc": "根据患者病情状态，进行导尿管道的常规护理操作，要求避免管道感染等并发症"
        },
        "patient": {
            "patientId": 45273,
            "name": "张富贵",
            "gender": "男",
            "age": 53,
            "phone": "18612345678",
            "address": "合肥市庐阳区安景苑7号楼2单元108"
        },
        "action": [
            {
                "actionId": 1,
                "actionType": 5,
                "order": 1,
                "title": "推送健康宣教知识",
                "desc": "下单后，系统自动为您推送",
                "progress": {
                    "Msg": "1/3",
                    "color": "red"
                },
                "content": [
                    {
                        "id": 2,
                        "status": {
                            "title": "睡眠指南",
                            "progress": {
                                "statusMsg": "已读",
                                "color": "green"
                            }
                        }
                    }
                ]
            },
            {
                "actionId": 2,
                "actionType": 5,
                "order": 1,
                "title": "服务前自测",
                "desc": "服务前，患者进行自我评测",
                "progress": {
                    "Msg": "1/3",
                    "color": "red"
                },
                "content": [
                    {
                        "id": 1,
                        "contentResult": {
                            "title": "自测结果。。。",
                            "detail": "患者大部分日常。。。"
                        },
                        "status": {
                            "title": "基本能力自测",
                            "progress": {
                                "statusMsg": "已自测",
                                "color": "green"
                            }
                        }
                    }
                ]
            },
            {
                "actionId": 2,
                "actionType": 5,
                "order": 5,
                "title": "尿管护理预备操作",
                "desc": "尿管护理预备操作，大约30分钟",
                "progress": {
                    "Msg": "已完成",
                    "color": "red"
                },
                "content": [
                    {
                        "button": {
                            "Msg": "此操做已完成"
                        }
                    }
                ]
            }
        ],
        "availableAction": [
            {
                "title": "完成订单",
                "action": "completeOrder"
            },
            {
                "title": "申请运营介入",
                "action": "needHelp"
            },
            {
                "title": "取消订单",
                "action": "cancel"
            }
        ]
    }
}

```

####  服务结束
      
Output： 
     
``` Json 
      
{
    "result": {
        "success": true,
        "code": 0
    },
    "order": {
        "orderId": 998,
        "orderNo": "21",
        "orderTime": 1479712913000,
        "servingTime": 1479712913000,
        "nurseId": 111,
        "status": {
            "statusType": 8,
            "statusDisplayMsg": "已完成",
            "color": "green"
        },
        "item": {
            "itemId": 887,
            "name": "上门尿管护理",
            "price": 12000,
            "period": 7200,
            "pic": "http: //img1.imgtn.bdimg.com/it/u=3505488306691858093&fm=21&gp=0.jpg",
            "desc": "根据患者病情状态，进行导尿管道的常规护理操作，要求避免管道感染等并发症"
        },
        "patient": {
            "patientId": 45273,
            "name": "张富贵",
            "gender": "男",
            "age": 53,
            "phone": "18612345678",
            "address": "合肥市庐阳区安景苑7号楼2单元108"
        },
        "action": [
            {
                "actionId": 1,
                "actionType": 5,
                "order": 1,
                "title": "推送健康宣教知识",
                "desc": "下单后，系统自动为您推送",
                "progress": {
                    "Msg": "1/3",
                    "color": "red"
                },
                "content": [
                    {
                        "id": 2,
                        "status": {
                            "title": "睡眠指南",
                            "progress": {
                                "statusMsg": "已读",
                                "color": "green"
                            }
                        }
                    }
                ]
            },
            {
                "actionId": 2,
                "actionType": 5,
                "order": 1,
                "title": "服务前自测",
                "desc": "服务前，患者进行自我评测",
                "progress": {
                    "Msg": "1/3",
                    "color": "red"
                },
                "content": [
                    {
                        "id": 1,
                        "contentResult": {
                            "title": "自测结果。。。",
                            "detail": "患者大部分日常。。。"
                        },
                        "status": {
                            "title": "基本能力自测",
                            "progress": {
                                "statusMsg": "已自测",
                                "color": "green"
                            }
                        }
                    }
                ]
            },
            {
                "actionId": 2,
                "actionType": 5,
                "order": 5,
                "title": "尿管护理预备操作",
                "desc": "尿管护理预备操作，大约30分钟",
                "progress": {
                    "Msg": "已完成",
                    "color": "red"
                },
                "content": [
                    {
                        "button": {
                            "Msg": "此操做已完成"
                        }
                    }
                ]
            }
        ],
        "review": [                                         //评价
            {
                "patient": {                               //评价患者
                    "patientId": 45273,                    //评价者的Id
                    "name": "张富贵",                        //评价者的姓名
                    "avatarUrl": "http: //img1.imgtn.bdimg.com/it/u=3505488306691858093&fm=21&gp=0.jpg"                        //评价者的头像
                },
                "reviewTime": 1232435354,                    //评价时间
                "score": 80,                                  //评价星级
                "reviewContent": "杨老师非常认真，而且手法纯熟，护理玩之后管路清洁许多，希望下次还是杨老师来."                                             //评价内容
            }
        ]
    }
}

```
  
#### 服务中（正常状态）

Output:

``` Json

{
    "result": {
        "success": true,
        "code": 0
    },
    "order": {
        "orderId": 998,
        "orderNo":"21",
        "orderTime": 1479712913000,
        "nurseId":111,
        "status": {
            "statusType": 9,
            "statusDisplayMsg": "服务中",
            "color": "#33FF33"
        },
        "item": {
            "itemId": 887,
            "name": "上门尿管护理",
            "price": 12000,
            "period": 7200,
            "pic": "http: //img1.imgtn.bdimg.com/it/u=3505488306691858093&fm=21&gp=0.jpg",
            "desc": "根据患者病情状态，进行导尿管道的常规护理操作，要求避免管道感染等并发症"
        },
        "patient": {
            "patientId": 45273,
            "name": "张富贵",
            "gender": "男",
            "age": 53,
            "phone": "18612345678",
            "address": "合肥市庐阳区安景苑7号楼2单元108"
        },
         "action": [
        {
            "actionId": 1,
            "actionType": 5,
            "order": 1,
            "title": "推送健康宣教知识",
            "desc": "下单后，系统自动为您推送",
            "progress": {
                "Msg": "1/3",
                "color": "red"
            },
            "content": [
                {
                    "id": 2,
                    "status": {
                        "title": "睡眠指南",
                        "progress": {
                            "statusMsg": "已读",
                            "color": "green"
                        }
                    }
                }
            ]
        },
        {
            "actionId": 2,
            "actionType": 5,
            "order": 1,
            "title": "服务前自测",
            "desc": "服务前，患者进行自我评测",
            "progress": {
                "Msg": "1/3",
                "color": "red"
            },
            "content": [
                {
                    "id": 1,
                    "contentResult": {
                        "title": "自测结果。。。",
                        "detail": "患者大部分日常。。。"
                    },
                    "status": {
                        "title": "基本能力自测",
                        "progress": {
                            "statusMsg": "已自测",
                            "color": "green"
                        }
                    }
                }
            ]
        },
        {
            "actionId": 2,
            "actionType": 5,
            "order": 5,
            "title": "尿管护理预备操作",
            "desc": "尿管护理预备操作，大约30分钟",
            "progress": {
                "Msg": "已完成",
                "color": "red"
            },
            "content": [
                {
                    "button": {
                        "Msg": "此操做已完成"
                    }
                }
            ]
        }
    ]       
            "availableAction": [
                {
                    "title": "完成订单",
                    "action": "completeOrder"
                }
            ]
        }
    }
 
```

#### 服务中(用户申请退款)
    
Output：

```json
 
  {
    "result": {
        "success": true,
        "code": 0
    },
    "order": {
        "orderId": 998,
        "orderNo":"21",
        "orderTime": 1479712913000,
        "servingTime": 1479712913000,
        "nurseId": 111,
        "status": {
            "statusType": 8,
            "statusDisplayMsg": "服务中",
            "color": "green"
        },
        "item": {
            "itemId": 887,
            "name": "上门尿管护理",
            "price": 12000,
            "period": 7200,
            "pic": "http: //img1.imgtn.bdimg.com/it/u=3505488306691858093&fm=21&gp=0.jpg",
            "desc": "根据患者病情状态，进行导尿管道的常规护理操作，要求避免管道感染等并发症"
        },
        "patient": {
            "patientId": 45273,
            "name": "张富贵",
            "gender": "男",
            "age": 53,
            "phone": "18612345678",
            "address": "合肥市庐阳区安景苑7号楼2单元108"
        },
          "action": [
        {
            "actionId": 1,
            "actionType": 5,
            "order": 1,
            "title": "推送健康宣教知识",
            "desc": "下单后，系统自动为您推送",
            "progress": {
                "Msg": "1/3",
                "color": "red"
            },
            "content": [
                {
                    "id": 2,
                    "status": {
                        "title": "睡眠指南",
                        "progress": {
                            "statusMsg": "已读",
                            "color": "green"
                        }
                    }
                }
            ]
        },
        {
            "actionId": 2,
            "actionType": 5,
            "order": 1,
            "title": "服务前自测",
            "desc": "服务前，患者进行自我评测",
            "progress": {
                "Msg": "1/3",
                "color": "red"
            },
            "content": [
                {
                    "id": 1,
                    "contentResult": {
                        "title": "自测结果。。。",
                        "detail": "患者大部分日常。。。"
                    },
                    "status": {
                        "title": "基本能力自测",
                        "progress": {
                            "statusMsg": "已自测",
                            "color": "green"
                        }
                    }
                }
            ]
        },
        {
            "actionId": 2,
            "actionType": 5,
            "order": 5,
            "title": "尿管护理预备操作",
            "desc": "尿管护理预备操作，大约30分钟",
            "progress": {
                "Msg": "已完成",
                "color": "red"
            },
            "content": [
                {
                    "button": {
                        "Msg": "此操做已完成"
                    }
                }
            ]
        }
    ],
            "applyRefund": {                     //用户申请退款
            "Title": "用户申请退款",                //标题
            "cause": "不需要此单服务",               //原因
            "money": 120,                           //退款金额
            "mainCause": "服务后出现问题，导致不需要此单"         //退款描述
        },
        "availableAction": [
            {
                "title": "同意退款",
                "action": "agreeRefund"
            }
        ]
    },
    "availableAction": [
        {
            "title": "申请运营介入",
            "action": "needHelp"
        },
        {
            "title": "取消订单",
            "action": "cancel"
        }
    ]
}

```

#### 订单详情，用户申请退款

PATCH api/nurses/order/v1/{orderId}/nurseOpinion?nurseId={nurseId}&orderId={orderId}


Input:

``` json

{
    "orderId": 3,
    "nurseId":3,
    "IsAgree":"退款意见"
}

```

Output:

``` json

{
    "result": {
        "success": true,
        "code": 0
    },
    "order": {
        "orderId": 998,
        "orderNo": "21",
        "nurseId": 111,
        "item": {
            "itemId": 887,
            "name": "上门尿管护理",
            "price": 12000,
            "period": 7200,
            "pic": "http: //img1.imgtn.bdimg.com/it/u=3505488306691858093&fm=21&gp=0.jpg",
            "desc": "根据患者病情状态，进行导尿管道的常规护理操作，要求避免管道感染等并发症"
        },
        "status": {
            "statusType": 8,
            "statusDisplayMsg": "服务中",
            "statusDescMsg": "用户申请退款",
            "color": "green"
        },
        "orderTime": 1479712913000,
        "patient": {
            "patientId": 45273,
            "name": "张富贵",
            "gender": "男",
            "age": 53,
            "phone": "18612345678",
            "address": "合肥市庐阳区安景苑7号楼2单元108"
        },
        "applyRefund": {
            "Title": "用户申请退款",
            "cause": "不需要此单服务",
            "money": 120,
            "desc": "服务后出现问题，导致不需要此单"
        },
        "availableAction": [
            {
                "title": "退款",
                "action": "refund"
            }
        ]
    }
}
```

### 服务设置管理页面接口 && 可服务项目接口 
GET /api/nurses/order/v1/{nurseId}/serviceManager?nurseId={nurseId} 

#### 描述

在服务设置管理页面，显示收益，可服务项目，综合评价

#### 接口详情
Output:

``` json

{
    "result": {
        "success": true,
        "code": 0
    },
    "agreePushStatus": 1,
    "orderIncome": 1200,
    "nurseId":1,
    "availableService": {
        "item":[ 
        {
                "itemId": 887,
                "name": "上门尿管护理",
                "status": 0,
                "price": 120,
                "pic": "http: //img1.imgtn.bdimg.com/it/u=3505488306691858093&fm=21&gp=0.jpg",
                "desc": "根据患者病情状态，进行导尿管道的常规护理操作，要求避免管道感染等并发症"
            }
        ]
    },
    "aveScore":80,
    "review": [
        {   
            "patient": {
                "patientId": 45273,
                "name": "张富贵",
                "avatarUrl": "http: //img1.imgtn.bdimg.com/it/u=3505488306691858093&fm=21&gp=0.jpg"
            }
            "reviewTime": 1232435354,
            "score": 80,
            "reviewContent": "杨老师非常认真，而且手法纯熟，护理玩之后管路清洁许多，希望下次还是杨老师来."
        }
    ]
}

```
### 申请进入纠纷  
PATCH /api/nurses/order/v1/refund/{orderId}?orderId={orderId}&nurseId={nurseId}

#### 描述
护士点击订单详情中的申请运营介入，主动进入运营介入状态

#### 接口详情

Input:

``` json

{
    "orderId": 3,
    "nurseId":3,
    "content":"无法退款"
}

```
Output:

```  json
{
    "result": {
        "success": true,
        "code": 0
    }
}

```

### 护士是否同意退款
PATCH api/nurses/order/v1/{orderId}/nurseOpinion?orderId={orderId}&nurseId={nurseId}

#### 描述
订单详情页中订单状态为：服务中（用户申请退款）,请求护士是否同意退款

#### 接口详情

Input:

``` json

{
    "orderId": 3,
    "nurseId":5,
    "isAgree": true,
    "content":"退款原因"
}

```

Output:
 
``` json

{
    "result": {
        "success": true,
        "code": 0
    }
}

```

### 护士主动取消订单  
PATCH api/nurses/order/v1/{orderId}/nurseCancel?orderId={orderId}&nurseId={nurseId}

#### 描述
在详情页，护士点击取消订单按钮。

#### 接口详情

Input:

``` json

{
    "orderId": 3,
    "nurseId";3,
    "cancelReason": "太忙了，去不了"
}

```

Output:

``` json

{
    "result": {
        "success": true,
        "code": 0
    }
}

```

### 可服务项目的更新  
PATCH api/nurses/order/v1/{itemId}/updateService?nurseId={nurseId}


#### 描述
可服务项目更新

#### 接口详情

Input:

```json

{
    "nurseId":2,
    "serviceId": 3
}

```

Output:

``` json

{
    "result": {
        "success": true,
        "code": 0
    }
}

```
### 详情页-护士确定完成订单 
   
PATCH /api/nurses/order/v1/{orderId}/nurseComplete？orderId={orderId}&nurseId={nurseId}
#### 描述
在详情页，护士点击底部的完成订单按钮确认订单完成。

#### 接口详情

Input:

```json
{
    "orderId": 3,
    "nurseId":3
}

```

Output:

```json
{
    "result": {
        "success": true,
        "code": 0
    }
}

```

### 详情页-护士确定完成订单的当前服务 
PATCH api/nurses/order/v1/{orderId}/completeService?nurseId={nurseId}&orderId={orderId}

#### 描述
在详情页，护士点击服务内容3的完成该操作按钮确认当前服务项完成。

#### 接口详情

Input:

```json

{
    "orderId": 3,
    "serviceId":4,
    "nurseId":11
}

```

Output:

```json

{
    "result": {
        "success": true,
        "code": 0
    }
}

```

### 接受推送接口 
PATCH api/nurses/order/v1/{nurseId}/pushService?nurseId={nurseId}

#### 描述
是否接受推送更新

#### 接口详情

Input:

```json
{
    "nurseId": 3
}

```

Output:

```json
{
    "result": {
        "success": true,
        "code": 0
    }
}

```

### 接单 
PATCH /api/nurses/order/v1/{orderId}/accept?orderId={orderId}&nurseId={nurseId}

Input:

```json
{
    "nurseId": 3,
    "orderId": 2
 }

```

Output:

```json
{
    "result": {
        "success": true,
        "code": 0
    }
}

```
	











