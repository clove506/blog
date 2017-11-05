---
title: 商品支撑子系统 CurvatureDriver详细设计
date: 2017-03-7 22:30:30
categories: API设计
---

### 摘要

本文是商品支撑子系统的Application接口设计，包含商品管理系统、运营审核系统、商品标准化服务管理系统接口设计。

### 文档更新

|时间|内容|维护人|
|---|---|---|
|2017-3-7|创建文档|李江明 卢江|

### 设计模型

#### 数据模型

|Table | Column Name | Description | Type|
|---|---|---|---|
|**Item**|id|服务商品ID|BIGINT|
||name|服务商品名称|VARCHAR|
||desc|服务商品描述|TEXT|
||detailHTML|服务商品详细信息|TEXT|
||price|服务价格|BIGINT|
||available_service_time|可用时间|TEXT|
||picture|服务商品图片|TEXT|
||state|服务商品状态|TINYINT|
||department_id|提供服务科室ID|BIGINT|
||category_id|分类ID|BIGINT|
||organization_id|分类ID|BIGINT|
||operation_log|操作记录|TEXT|
||abnormal_log|异常记录|TEXT|
||created_at|创建时间|TIMESTAMP|
||updated_at|更新时间|TIMESTAMP|
|**ServiceItem**|id|服务单元ID|BIGINT|
||item_id|服务商品ID|BIGINT|
||name|服务单元名称|VARCHAR|
||desc|服务单元描述|TEXT|
||price|服务单元价格|BIGINT|
||origin_price|服务单元原始价格|BIGINT|
||picture|服务单元图片|TEXT|
||standard_template_id|标准化服务模板Id|BIGINT|
||standard_template_type|标准化服务模板类型|BIGINT|
||state|是否生效|BIGINT|
||duration|服务耗时|BIGINT|
||comment|备注|TEXT|
||created_at|创建时间|TIMESTAMP|
||updated_at|更新时间|TIMESTAMP|
|**ItemProp**|id|属性ID|BIGINT|
||item_id|商品ID|BIGINT|
||prop_name|属性名称|VARCHAR|
||created_at|创建时间|TIMESTAMP|
||updated_at|更新时间|TIMESTAMP|
|**ItemPropValue**|id|属性值ID|BIGINT|
||item_prop_id|属性ID|BIGINT|
||value|属性值|VARCHAR|
||created_at|创建时间|TIMESTAMP|
||updated_at|更新时间|TIMESTAMP|
|**ServiceItemPropValue**|id|item属性表ID|BIGINT|
||service_item_id|商品ID|BIGINT|
||item_prop_id|属性ID|BIGINT|
||item_prop_value_id|属性值|BIGINT|
||created_at|创建时间|TIMESTAMP|
||updated_at|更新时间|TIMESTAMP|
| **Category**|id|分类ID|BIGINT|
||l1_id|第一级分类ID|BIGINT|
||l1_name|第一级分类名称|VARCHAR|
||l2_id|第二级分类ID|BIGINT|
||l2_name|第二级分类名称|VARCHAR|
||l3_id|第三级分类ID|BIGINT|
||l3_name|第三级分类名称|VARCHAR|
||l4_id|第四级分类ID|BIGINT|
||l4_name|第四级分类名称|VARCHAR|
||l5_id|第五级分类ID|BIGINT|
||l5_name|第五级分类名称|VARCHAR|
||created_at|创建时间|TIMESTAMP|
||updated_at|更新时间|TIMESTAMP|

#### ProtoBuf数据模型


```
    //-------------------------Message For Item Start----------------------------------//

message ItemAddOption {
    optional string name = 1;
    optional string desc = 2;
    optional string detailHTML = 3;
    optional AvailableTime availableTime = 4;
    repeated string picture = 5;
    optional int64 departmentId = 6;
    optional int64 organizationId = 7;
    optional int64 categoryId = 8;
    optional int64 duration = 9;
    optional int64 standardTemplateId = 10;
    repeated ItemProp itemProp = 11;
    repeated AvailableNurse availableNurse = 12;
}

message ItemUpdateOption {
    optional string name = 1;
    optional string desc = 2;
    optional string detailHTML = 3;
    optional AvailableTime availableTime = 4;
    repeated string picture = 5;
    optional int64 categoryId = 6;
    optional int64 duration = 7;
    optional int64 standardTemplateId = 8;
    repeated ItemProp itemProp = 9;
    optional string abnormalLog = 10;
    optional OperationLog operationLog = 11;
    repeated ServiceItem serviceItem = 12;
    repeated AvailableNurse availableNurse = 13;
    optional int64 state = 14;
    optional int64 departmentId = 15;
    optional int64 id = 16;
}

message Item {
    optional int64 id = 1;
    optional string name = 2;
    optional string desc = 3;
    optional string detailHTML = 4;
    repeated string picture = 5;
    optional int64 state = 6;
    optional int64 duration = 7;
    optional Category category = 8;
    optional int64 updatedAt = 9;
    optional int64 standardTemplateId = 10;
    repeated ItemProp itemProp = 11;
    optional string abnormalLog = 12;
    optional OperationLog operationLog = 13;
    repeated ServiceItem serviceItem = 14;
    optional Department department = 15;
    optional AvailableTime availableTime = 16;
    repeated AvailableNurse availableNurse = 17 ;
}

message OperationLog {
    optional string operator = 1;
    optional string action = 2;
    optional int64 time = 3;
    optional string extraInfo = 4;
}

message ItemProp {
    optional int64 id = 1;
    optional string name = 2;
    repeated ItemPropValue itemPropValue = 3;
}

message ItemPropValue {
    optional int64 id = 1;
    optional string name = 2;
}

message ItemDTO {
    optional Item item = 1;
}

message ItemListDTO {
    repeated Item item = 1;
}

message ItemWrapDTO {
    optional ItemDTO data = 1;
    optional Result result = 2;
}

message ItemListWrapDTO {
    optional ItemListDTO data = 1;
    optional Result result = 2;
}

//-------------------------Message For Item End-------------------------------------------//

//-------------------------Message For ServiceItem Start----------------------------------//

message ServiceItemUpdateOption {
    optional string desc = 1;
    optional int64 price = 2;
    optional int64 originPrice = 3;
    optional string name = 4;
    optional string picture = 5;
    optional int64 status = 6;
    optional int64 createAt = 7;
    optional int64 updateAt = 8;
}

message ServiceItem {
    optional int64 id = 1;
    optional string desc = 2;
    optional int64 price = 3;
    optional int64 originPrice = 4;
    optional string name = 5;
    optional string picture = 6;
    optional string status = 7;
    optional int64 createAt = 8;
    optional int64 updateAt = 9;
    optional int64 itemId = 10;
}

message ServiceItemDTO {
    optional ServiceItem serviceItem = 1;
}

message ServiceItemListDTO {
    repeated ServiceItem serviceItem = 1;
}

message ServiceItemWrapDTO {
    optional ServiceItemDTO data = 1;
    optional Result result = 2;
}

message ServiceItemListWrapDTO {
    optional ServiceItemList data = 1;
    optional Result result = 2;
}

//-------------------------Message For ServiceItem End--------------------------------------//

//-------------------------Message For ServiceConfig Start----------------------------------//

message ServiceConfigAddOption {
    repeated AvailableNurse availableNurse = 1;
    optional AvailableTime availableTime = 2;
    optional int64 itemId = 3;
}

message ServiceConfigUpdateOption {
    repeated AvailableNurse availableNurse = 1;
    optional AvailableTime availableTime = 2;
    optional int64 itemId = 3;
}

message ServiceConfig {
    repeated AvailableNurse availableNurse = 1;
    optional AvailableTime availableTime = 2;
}

message StandardServiceWarpDTO {
    optional StandardService data = 1 ;
    optional Result result = 2 ; 
}

message StandardServiceList {
    repeated StandardService standardService = 1;
}

message StandardService {
    repeated ArticleSection articleSection = 1;
    repeated ToolSection toolSection = 2;
    repeated EvaluateSection evaluateSection = 3;
    repeated StepAction stepAction = 4;
    optional int64 categoryId = 5;
    optional int64 id = 6;
}

message ArticleSection {
    optional string title = 1 ;
    optional string desc = 2;
    optional int64 order = 3;
    repeated Article article = 4 ;
}

message Article {
    optional int64 id = 1 ;
    optional string title = 2 ;
    optional string read = 3 ;
}

message ToolSection {
    optional string title = 1 ;
    optional string desc = 2 ;
    optional int64 order = 3 ;
    repeated Tool tool = 4 ;
}

message Tool {
    optional int64 id = 1 ;
    optional string title = 2 ；
    optional string summary = 3 ;
}

message EvaluateSection {
    optional string title = 1 ;
    optional string desc = 2 ;
    optional int64 order = 3 ;
    repeated Evaluate evaluate = 4 ;
}

message Evaluate {
    optional int64 id = 1 ;
    optional string title = 2 ；
    optional string summary = 3 ;
}

message StepAction {
    optional string title = 1 ;
    optional string desc = 2 ;
    optional int64 order = 3 ;
    repeated Step step = 4;
}

message Step {
    optional string title = 1;
    optional string desc = 2;
    optional string content = 3;
    optional int64 type = 4;
    optional bool done = 5;
}

message AvailableNurse {
    optional int64 id = 1;
    optional string name = 2;
}

message NurseDTO {
    optional AvailableNurse availableNurse = 1 ;
}

message NurseListWarpDTO {
    repeated NurseDTO data = 1 ;
    optional Result result = 2 ；
}

message AvailableTime {
    optional AvailableServiceDay availableDay = 1;
    repeated int32 availableHour = 2;
    optional int64 minPrepareTime = 3;
}

message AvailableDay {
    optional int64 startDay = 1;
    optional int64 endDay = 2;
}


message ServiceConfigDTO {
    optional ServiceConfig serviceConfig = 1;
}

message ServiceConfigDTOWrap {
    optional ServiceConfig data = 1;
    optional Result result = 2;
}

//-------------------------Message For ServiceConfig End----------------------------------//

//-------------------------Message For Category Start----------------------------------//

message Category {
    optional int64 id = 1;
    optional int64 categoryId = 2;
    optional int64 levelOneId = 3;
    optional string levelOneName = 4;
    optional int64 levelTwoId = 5;
    optional string levelTwoName = 6;
    optional int64 levelThreeId = 7;
    optional string levelThreeName = 8;
    optional int64 levelFourId = 9;
    optional string levelFourName = 10;
    optional int64 levelFiveId = 11;
    optional string levelFiveName = 12;
}

message CategoryListDTO {
    repeated Category category = 1;
}


message CategoryListWrapDTO {
    optional CategoryListDTO data = 1;
    optional Result result = 2;
}

//-------------------------Message For Category End----------------------------------//

//-------------------------Message For Department List----------------------------------//

message Department {
    optional int64 id = 1;
    optional string name = 2;
    optional Organization organization = 3;
}

message Organization {
    optional int64 id = 1;
    optional string name = 2;
}

message DepartmentListDTO {
    repeated Department department = 1;
}

message DepartmentListWrapDTO {
    optional DepartmentListDTO data = 1;
    optional Result result = 2;
}

//-------------------------Message For Department End----------------------------------//

```

### 场景分析

#### 商品管理系统

当服务提供商登录成功之后，系统显示商品列表页面，在操作列中有上线、下线、删除、配置服务信息、查看按钮。交互图如图所示：

![image](https://img.wkcontent.com/assets/migration/商品管理-商品列表.png)


交互流程图如下：
![image](https://img.wkcontent.com/assets/migration/Item-Index.jpeg)


当用户点击删除、上线、下线按钮时，页面不发生跳转，请求成功之后，所选的Item状态发生变化。点击配置服务信息跳至配置服务信息页面。

##### 新建商品

当服务提供商点击新建时，跳至新建商品页，操作时序图如下图所示：
![image](https://img.wkcontent.com/assets/migration/add-Item-sequence.png)



#### 运营审核系统

当运营审核登录成功后， 系统默认显示商品列表，列表为空，在选择搜索条件之后，点击搜索，获取列表，搜索条件分两种：
    
*     商品ID

    运营可以输入商品ID，点击搜索，后端返回数据。

*     服务提供商名称和状态
    
    商品列表默认加载时，后端返回所有能提供服务的服务提供商集合，用来填充服务提供商下拉列表，前端支持在该列表中根据服务提供商名称查询服务提供商。状态下拉列表中有审核成功，已发，待审核，异常，审核失败和全部6个状态，该下拉列表中的数据前端定死。选完服务提供商和状态之后，点击搜索，后端返回数据。注意：服务提供商下拉列表必须选中一个，（状态默认是全部）点击搜索才能进行搜索。

以上两个条件必须二选一，再加上前端传入的每页显示条数pageSize和当前页currentPage两个参数用来获取商品列表。交互图如图所示：

![image](https://img.wkcontent.com/assets/migration/audit-index.png)

![image](https://img.wkcontent.com/assets/migration/audit-search.png)

交互流程图如下：
![image](https://img.wkcontent.com/assets/migration/audit-flow.png)

##### 进入审核

当运营人员点击进入审核时，跳至审核商品页，操作时序图如下图所示：
![image](https://img.wkcontent.com/assets/migration/item-Audit-Sequence.png)


### 类图设计

商品管理和运营审核实现类有ItemBO、ServiceItemBO、ServiceConfig三个类图。

- ItemBO
![image](https://img.wkcontent.com/assets/migration/WarpDriver-ItemBO-Class.png)
- ServiceItemBO
![image](https://img.wkcontent.com/assets/migration/WarpDriver-ServiceItem-Class.png)    
- ServiceConfig
![image](https://img.wkcontent.com/assets/migration/wrapdrv-ServiceInfo-Class.png)

### API详情

#### 商品支持系统API详细设计

#### 服务提供商请求的URL（nurse身份登录）

##### 根据条件组合查询item列表的接口设计
GET /api/curvatureDrive/v1/nurse/items?departmentId={departmentId}&itemId={itemId}&state={state}&length={length}&start={start}&draw={draw}

###### 接口描述
服务提供商在商品列表页，输入查询条件，获取商品列表。输入的查询条件是可选项，但是三者必须填写一个

###### Request

GET /api/curvatureDrive/v1/admin/items?length=5&start=1&departmentId=1&draw=12

###### Response

``` json
{
  "data": {
    "item": [
      {
        "id": 139,
        "name": "专业鼻饲",
        "state": 1,
        "updatedAt": 1490159141000,
        "department": {
          "id": 1,
          "name": "脊柱外科",
          "organization": {
            "id": 1,
            "name": "309医院"
          }
        }
      },
      {
        "id": 146,
        "name": "专业造口护理",
        "state": 1,
        "updatedAt": 1490069225000,
        "department": {
          "id": 1,
          "name": "脊柱外科",
          "organization": {
            "id": 1,
            "name": "309医院"
          }
        }
      },
      {
        "id": 122,
        "name": "专业鼻饲",
        "state": 1,
        "updatedAt": 1490005553000,
        "department": {
          "id": 1,
          "name": "脊柱外科",
          "organization": {
            "id": 1,
            "name": "309医院"
          }
        }
      },
      {
        "id": 120,
        "name": "导尿-我们是专业的",
        "state": 1,
        "updatedAt": 1490002046000,
        "department": {
          "id": 1,
          "name": "脊柱外科",
          "organization": {
            "id": 1,
            "name": "309医院"
          }
        }
      },
      {
        "id": 97,
        "name": "商品支撑鼻饲update",
        "state": 2,
        "updatedAt": 1489982786000,
        "abnormalLog": "哎哟，异常了哦",
        "operationLog": {
          "operator": "ljm",
          "action": "审核不通过",
          "time": 1489828622,
          "extraInfo": "描述与商品性质不符,不通过"
        },
        "department": {
          "id": 1,
          "name": "脊柱外科",
          "organization": {
            "id": 1,
            "name": "309医院"
          }
        }
      }
    ]
  },
  "result": {
    "success": true,
    "code": 0
  },
  "draw": 12,
  "recordsFiltered": 22,
  "recordsTotal": 0
}

```
###### 实现设计
上游传入输入的查询条件,调用下游的/api/dagon/v2/items接口，返回页面的item包含页面元素所需的信息

##### 新增item的接口设计
POST /api/curvatureDrive/v1/nurse/item

###### 接口描述
新建一个item，并根据item的prop和propValue创建其serviceItem

###### Request

``` json
{
  "name": "优护家专业导尿",
  "desc": "优护家导尿，我们是专业的",
  "detailHTML": "<h2>优护家这是一个测试，导尿</h2>",
  "departmentId": 1,
  "categoryId": 17,
  "picture": [
    "http://pic1.win4000.com/wallpaper/c/53cdd20a3a327.jpg"
  ],
  "duration": 4500,
  "standardTemplateId":8785,
  "itemProp": [
  	{
    "name": "颜色",
    "itemPropValue": [
      {
        "name": "红色"
      },
      {
    	"name":"黄色"	
      }
    ]
  },
  {
  	"name":"长度",
  	"itemPropValue": [
      {
        "name": "30cm"
      },
      {
      	"name":"50cm"
      }
      ]
  }
  ]
}

```

###### Response

``` json
{
  "data": {
    "item": {
      "id": 4,
      "name": "鼻饲【自备物品】",
      "desc": "鼻饲是将导管经鼻腔插入胃内，从管内输注食物、水分和药物，以维持病人的营养治疗的技术。（包含插胃管和首次鼻饲）家属自备物品：一次性无菌鼻胃管：（一套：胃管+无菌手套+鼻贴+盘带+无菌注射+棉签），适量开水（38～40℃），鼻饲饮料（38～40℃）。[温馨提示家属选择正规医院或者药店购买，注意检查物品有效期等]护士自备物品：手套、鞋套、听诊器、口罩、手消毒液",
      "detailHTML": "<h3 style=\"white-space: normal; background-color: #f6f6f6;\">上门服务介绍内容</h3>\n<p>导尿，是经由尿道插入导尿管到膀胱，引流出尿液。提供导尿服务（包含尿管更换）、拔除尿管服务以及其他尿管渗漏、尿袋更换等服务。</p>\n<h3 class=\"font-color-global-base padding-height-xs\">家属自备物品:</h3>\n<p>超滑抗菌尿管：（一套：尿管+无菌手套+无菌注射器+盘带）[温馨提示家属选择正规医院或者药店购买，注意检查物品有效期等]</p>\n<h3 class=\"font-color-global-base padding-height-xs\">护士备物品：</h3>\n<p>手套、鞋套、口罩、手消毒液</p>",
      "picture": [
        "http://yhjstatic-dev.oss-cn-shanghai.aliyuncs.com/avatar/e6b51b90-0951-b9d8-a432-b07655fbf079.jpg"
      ],
      "state": 6,
      "duration": 4500,
      "category": {
        "id": 9,
        "levelOneId": 1,
        "levelOneName": "居家服务",
        "levelTwoId": 2,
        "levelTwoName": "护理服务",
        "levelThreeId": 3,
        "levelThreeName": "基础护理",
        "levelFourId": 4,
        "levelFourName": "胃管护理"
      },
      "updatedAt": 1491097629000,
      "standardService": {
        "articleSection": [
          {
            "title": "推荐健康宣教知识",
            "desc": "下单后，系统自动向患者推送健康宣教文章",
            "order": 1,
            "article": [
              {
                "id": 519,
                "title": "后端的第一条宣教",
                "read": false
              },
              {
                "id": 1295,
                "title": "后端的第二条宣教",
                "read": false
              }
            ]
          }
        ],
        "toolSection": [
          {
            "title": "服务器评估",
            "desc": "服务前，对患者状态进行综合评估",
            "order": 1,
            "tool": [
              {
                "id": 124,
                "title": "后端的第一条自测",
                "summary": ""
              },
              {
                "id": 124,
                "title": "后端的第二条自测（和第一条一样，不是BUG）",
                "summary": ""
              }
            ]
          }
        ],
        "evaluateSection": [
          {
            "title": "Nurse评估",
            "desc": "服务前，对患者状态进行综合评估",
            "order": 1,
            "evaluate": [
              {
                "id": 275,
                "title": "生活能力",
                "summary": ""
              },
              {
                "id": 273,
                "title": "压促昂？",
                "summary": ""
              }
            ]
          }
        ],
        "stepAction": [
          {
            "title": "尿管护理操作",
            "desc": "服务前，对患者状态进行综合评估",
            "order": 1,
            "step": [
              {
                "title": "第一步",
                "desc": "第一步详情",
                "done": false
              },
              {
                "title": " 第二步",
                "desc": "第二步详情",
                "done": false
              }
            ]
          }
        ],
        "categoryId": 5,
        "id": 8785
      },
      "itemProp": [
        {
          "id": 6,
          "name": "物料",
          "itemPropValue": [
            {
              "id": 11,
              "name": "自备物料"
            },
            {
              "id": 12,
              "name": "代购物料"
            }
          ]
        },
        {
          "id": 7,
          "name": "套餐",
          "itemPropValue": [
            {
              "id": 13,
              "name": "1次"
            }
          ]
        }
      ],
      "abnormalLog": "",
      "serviceItem": [
        {
          "id": 14,
          "desc": "鼻饲是将导管经鼻腔插入胃内，从管内输注食物、水分和药物，以维持病人的营养治疗的技术。（包含插胃管和首次鼻饲）家属自备物品：一次性无菌鼻胃管：（一套：胃管+无菌手套+鼻贴+盘带+无菌注射器+棉签），适量开水（38～40℃），鼻饲饮料（38～40℃）。[温馨提示家属选择正规医院或者药店购买，注意检查物品有效期等]护士自备物品：手套、鞋套、听诊器、口罩、手消毒液。",
          "price": 2,
          "originPrice": 12000,
          "name": "鼻饲-自备物料-1次",
          "picture": "http://yhjstatic-dev.oss-cn-shanghai.aliyuncs.com/avatar/e6b51b90-0951-b9d8-a432-b07655fbf079.jpg"
        },
        {
          "id": 15,
          "desc": "鼻饲是将导管经鼻腔插入胃内，从管内输注食物、水分和药物，以维持病人的营养治疗的技术。（包含插胃管和首次鼻饲）代购物品：一次性无菌鼻胃管：（一套：胃管+无菌手套+鼻贴+盘带+无菌注射器+棉签共计110元）[温馨提示护士代购按照正规医院或者药店购买，注意检查物品有效期等]家属备物品：夹子、别针、适量开水（38～40℃），鼻饲饮料（38～40℃）。护士自备物品：手套、鞋套、听诊器、口罩、手消毒液",
          "price": 2,
          "originPrice": 12000,
          "name": "鼻饲-代购物料-1次",
          "picture": "http://yhjstatic-dev.oss-cn-shanghai.aliyuncs.com/avatar/e6b51b90-0951-b9d8-a432-b07655fbf079.jpg"
        }
      ],
      "department": {
        "id": 1,
        "name": "脊柱外科",
        "organization": {
          "id": 1,
          "name": "309医院"
        }
      }
    }
  },
  "result": {
    "success": true,
    "code": 0
  }
}

```
###### 实现设计
上游传入item基本信息，将item信息进行拆分，调用dagon中对应的接口，保存数据。


##### 获取单个item信息的接口设计
GET /api/warpDriver/v1/nurse/item/{itemId}

###### 接口描述
根据itemId获取item详细信息

###### Request
GET /api/warpDriver/v1/nurse/item/163

###### Response

```json

{
  "data": {
    "item": {
      "id": 4,
      "name": "鼻饲【自备物品】",
      "desc": "鼻饲是将导管经鼻腔插入胃内，从管内输注食物、水分和药物，以维持病人的营养治疗的技术。（包含插胃管和首次鼻饲）家属自备物品：一次性无菌鼻胃管：（一套：胃管+无菌手套+鼻贴+盘带+无菌注射+棉签），适量开水（38～40℃），鼻饲饮料（38～40℃）。[温馨提示家属选择正规医院或者药店购买，注意检查物品有效期等]护士自备物品：手套、鞋套、听诊器、口罩、手消毒液",
      "detailHTML": "<h3 style=\"white-space: normal; background-color: #f6f6f6;\">上门服务介绍内容</h3>\n<p>导尿，是经由尿道插入导尿管到膀胱，引流出尿液。提供导尿服务（包含尿管更换）、拔除尿管服务以及其他尿管渗漏、尿袋更换等服务。</p>\n<h3 class=\"font-color-global-base padding-height-xs\">家属自备物品:</h3>\n<p>超滑抗菌尿管：（一套：尿管+无菌手套+无菌注射器+盘带）[温馨提示家属选择正规医院或者药店购买，注意检查物品有效期等]</p>\n<h3 class=\"font-color-global-base padding-height-xs\">护士备物品：</h3>\n<p>手套、鞋套、口罩、手消毒液</p>",
      "picture": [
        "http://yhjstatic-dev.oss-cn-shanghai.aliyuncs.com/avatar/e6b51b90-0951-b9d8-a432-b07655fbf079.jpg"
      ],
      "state": 6,
      "duration": 4500,
      "category": {
        "id": 9,
        "levelOneId": 1,
        "levelOneName": "居家服务",
        "levelTwoId": 2,
        "levelTwoName": "护理服务",
        "levelThreeId": 3,
        "levelThreeName": "基础护理",
        "levelFourId": 4,
        "levelFourName": "胃管护理"
      },
      "updatedAt": 1491097629000,
      "standardService": {
        "articleSection": [
          {
            "title": "推荐健康宣教知识",
            "desc": "下单后，系统自动向患者推送健康宣教文章",
            "order": 1,
            "article": [
              {
                "id": 519,
                "title": "后端的第一条宣教",
                "read": false
              },
              {
                "id": 1295,
                "title": "后端的第二条宣教",
                "read": false
              }
            ]
          }
        ],
        "toolSection": [
          {
            "title": "服务器评估",
            "desc": "服务前，对患者状态进行综合评估",
            "order": 1,
            "tool": [
              {
                "id": 124,
                "title": "后端的第一条自测",
                "summary": ""
              },
              {
                "id": 124,
                "title": "后端的第二条自测（和第一条一样，不是BUG）",
                "summary": ""
              }
            ]
          }
        ],
        "evaluateSection": [
          {
            "title": "Nurse评估",
            "desc": "服务前，对患者状态进行综合评估",
            "order": 1,
            "evaluate": [
              {
                "id": 275,
                "title": "生活能力",
                "summary": ""
              },
              {
                "id": 273,
                "title": "压促昂？",
                "summary": ""
              }
            ]
          }
        ],
        "stepAction": [
          {
            "title": "尿管护理操作",
            "desc": "服务前，对患者状态进行综合评估",
            "order": 1,
            "step": [
              {
                "title": "第一步",
                "desc": "第一步详情",
                "done": false
              },
              {
                "title": " 第二步",
                "desc": "第二步详情",
                "done": false
              }
            ]
          }
        ],
        "categoryId": 5,
        "id": 8785
      },
      "itemProp": [
        {
          "id": 6,
          "name": "物料",
          "itemPropValue": [
            {
              "id": 11,
              "name": "自备物料"
            },
            {
              "id": 12,
              "name": "代购物料"
            }
          ]
        },
        {
          "id": 7,
          "name": "套餐",
          "itemPropValue": [
            {
              "id": 13,
              "name": "1次"
            }
          ]
        }
      ],
      "abnormalLog": "看着不爽",
      "serviceItem": [
        {
          "id": 14,
          "desc": "鼻饲是将导管经鼻腔插入胃内，从管内输注食物、水分和药物，以维持病人的营养治疗的技术。（包含插胃管和首次鼻饲）家属自备物品：一次性无菌鼻胃管：（一套：胃管+无菌手套+鼻贴+盘带+无菌注射器+棉签），适量开水（38～40℃），鼻饲饮料（38～40℃）。[温馨提示家属选择正规医院或者药店购买，注意检查物品有效期等]护士自备物品：手套、鞋套、听诊器、口罩、手消毒液。",
          "price": 2,
          "originPrice": 12000,
          "name": "鼻饲-自备物料-1次",
          "picture": "http://yhjstatic-dev.oss-cn-shanghai.aliyuncs.com/avatar/e6b51b90-0951-b9d8-a432-b07655fbf079.jpg"
        },
        {
          "id": 15,
          "desc": "鼻饲是将导管经鼻腔插入胃内，从管内输注食物、水分和药物，以维持病人的营养治疗的技术。（包含插胃管和首次鼻饲）代购物品：一次性无菌鼻胃管：（一套：胃管+无菌手套+鼻贴+盘带+无菌注射器+棉签共计110元）[温馨提示护士代购按照正规医院或者药店购买，注意检查物品有效期等]家属备物品：夹子、别针、适量开水（38～40℃），鼻饲饮料（38～40℃）。护士自备物品：手套、鞋套、听诊器、口罩、手消毒液",
          "price": 2,
          "originPrice": 12000,
          "name": "鼻饲-代购物料-1次",
          "picture": "http://yhjstatic-dev.oss-cn-shanghai.aliyuncs.com/avatar/e6b51b90-0951-b9d8-a432-b07655fbf079.jpg"
        }
      ],
      "department": {
        "id": 1,
        "name": "脊柱外科",
        "organization": {
          "id": 1,
          "name": "309医院"
        }
      },
      "availableTime": {
        "availableDay": {
          "startDay": 1,
          "endDay": 7
        },
        "availableHour": [
          9
        ],
        "minPrepareTime": 30
      },
      "availableNurse": [
        {
          "id": 20,
          "name": "董劭杰"
        },
        {
          "id": 6,
          "name": "李少华"
        },
        {
          "id": 131,
          "name": "袁鑫"
        },
        {
          "id": 59,
          "name": "程冲"
        },
        {
          "id": 111,
          "name": "徐"
        },
        {
          "id": 444,
          "name": "旭红"
        },
        {
          "id": 90,
          "name": "五名"
        }
      ]
    }
  },
  "result": {
    "success": true,
    "code": 0
  }
}

```

###### 实现设计
上游给出itemId，调用下游的/api/dagon/v2/item/{itemId}接口，下游根据itemId从数据库中获取itemId信息。

##### 更新item信息的接口设计
PATCH /api/curvatureDrive/v1/nurse/item/{itemId}

###### 接口描述
根据itemId更新item信息

###### Request
PATCH /api/curvatureDrive/v1/nurse/item/148

```json

更新item信息页面
{
	"id":163,
    "name": "优护家专业导尿",
    "desc": "优护家专业导尿，我们是专业的",
    "detailHTML": "<h2>优护家这是一个测试，导尿</h2>",
    "picture": [
       "http://pic1.win4000.com/wallpaper/c/53cdd20a3a327.jpg"
    ],
    "state": 1,
    "categoryId": 5,
    "standardTemplateId": 8785,
    "duration":3600,
      "itemProp": [
        {
          "id": 194,
          "name": "物料",
          "itemPropValue": [
            {
              "id": 418,
              "name": "自备物料"
            },
            {
              "id": 419,
              "name": "代购物料"
            }
          ]
        },
        {
          "id":197,
          "name": "套餐
          ",
          "itemPropValue": [
            {
              "id":425,
              "name": "3天"
            },
            {
              "id":426,
              "name": "5天"
            }
          ]
        }
      ]
}

更新serviceItem信息页面
{
	"id":163,
	"state":1,
	"serviceItem":[
		{
			"id":592,
			"price":11,
			"originPrice":110,
			"status":1,
			"desc":"大降价，大促销",
			"picture":"http://yhjstatic-dev.oss-cn-RRRRRRRRshanghai.aliyuncs.com/avatar/e6b51b90-0951-b9d8-a432-b07655fbf079.jpg"
		}
	]
}

配置服务信息页面
{
    "id":163,
    "state":2,
    "availableNurse": [
        {
         "id":458	
        }
    ],
    "availableTime": {
        "availableDay": {
            "startDay": 0,
            "endDay": 6
        },
        "availableHour": [
            8,
            9,
            10,
            11,
            14,
            15,
            16,
            17,
            18,
            19
        ]
    }
}

只更新Item状态
{
    "id":148,
    "state":1
}

```
###### Response

```json
商品信息更改

{
  "data": {
    "item": {
      "id": 4,
      "name": "鼻饲【自备物品】",
      "desc": "鼻饲是将导管经鼻腔插入胃内，从管内输注食物、水分和药物，以维持病人的营养治疗的技术。（包含插胃管和首次鼻饲）家属自备物品：一次性无菌鼻胃管：（一套：胃管+无菌手套+鼻贴+盘带+无菌注射+棉签），适量开水（38～40℃），鼻饲饮料（38～40℃）。[温馨提示家属选择正规医院或者药店购买，注意检查物品有效期等]护士自备物品：手套、鞋套、听诊器、口罩、手消毒液",
      "detailHTML": "<h3 style=\"white-space: normal; background-color: #f6f6f6;\">上门服务介绍内容</h3>\n<p>导尿，是经由尿道插入导尿管到膀胱，引流出尿液。提供导尿服务（包含尿管更换）、拔除尿管服务以及其他尿管渗漏、尿袋更换等服务。</p>\n<h3 class=\"font-color-global-base padding-height-xs\">家属自备物品:</h3>\n<p>超滑抗菌尿管：（一套：尿管+无菌手套+无菌注射器+盘带）[温馨提示家属选择正规医院或者药店购买，注意检查物品有效期等]</p>\n<h3 class=\"font-color-global-base padding-height-xs\">护士备物品：</h3>\n<p>手套、鞋套、口罩、手消毒液</p>",
      "picture": [
        "http://yhjstatic-dev.oss-cn-shanghai.aliyuncs.com/avatar/e6b51b90-0951-b9d8-a432-b07655fbf079.jpg"
      ],
      "state": 6,
      "duration": 4500,
      "category": {
        "id": 9,
        "levelOneId": 1,
        "levelOneName": "居家服务",
        "levelTwoId": 2,
        "levelTwoName": "护理服务",
        "levelThreeId": 3,
        "levelThreeName": "基础护理",
        "levelFourId": 4,
        "levelFourName": "胃管护理"
      },
      "updatedAt": 1491097629000,
      "standardService": {
        "articleSection": [
          {
            "title": "推荐健康宣教知识",
            "desc": "下单后，系统自动向患者推送健康宣教文章",
            "order": 1,
            "article": [
              {
                "id": 519,
                "title": "后端的第一条宣教",
                "read": false
              },
              {
                "id": 1295,
                "title": "后端的第二条宣教",
                "read": false
              }
            ]
          }
        ],
        "toolSection": [
          {
            "title": "服务器评估",
            "desc": "服务前，对患者状态进行综合评估",
            "order": 1,
            "tool": [
              {
                "id": 124,
                "title": "后端的第一条自测",
                "summary": ""
              },
              {
                "id": 124,
                "title": "后端的第二条自测（和第一条一样，不是BUG）",
                "summary": ""
              }
            ]
          }
        ],
        "evaluateSection": [
          {
            "title": "Nurse评估",
            "desc": "服务前，对患者状态进行综合评估",
            "order": 1,
            "evaluate": [
              {
                "id": 275,
                "title": "生活能力",
                "summary": ""
              },
              {
                "id": 273,
                "title": "压促昂？",
                "summary": ""
              }
            ]
          }
        ],
        "stepAction": [
          {
            "title": "尿管护理操作",
            "desc": "服务前，对患者状态进行综合评估",
            "order": 1,
            "step": [
              {
                "title": "第一步",
                "desc": "第一步详情",
                "done": false
              },
              {
                "title": " 第二步",
                "desc": "第二步详情",
                "done": false
              }
            ]
          }
        ],
        "categoryId": 5,
        "id": 8785
      },
      "itemProp": [
        {
          "id": 6,
          "name": "物料",
          "itemPropValue": [
            {
              "id": 11,
              "name": "自备物料"
            },
            {
              "id": 12,
              "name": "代购物料"
            }
          ]
        },
        {
          "id": 7,
          "name": "套餐",
          "itemPropValue": [
            {
              "id": 13,
              "name": "1次"
            }
          ]
        }
      ],
      "abnormalLog": "看着不爽",
      "serviceItem": [
        {
          "id": 14,
          "desc": "鼻饲是将导管经鼻腔插入胃内，从管内输注食物、水分和药物，以维持病人的营养治疗的技术。（包含插胃管和首次鼻饲）家属自备物品：一次性无菌鼻胃管：（一套：胃管+无菌手套+鼻贴+盘带+无菌注射器+棉签），适量开水（38～40℃），鼻饲饮料（38～40℃）。[温馨提示家属选择正规医院或者药店购买，注意检查物品有效期等]护士自备物品：手套、鞋套、听诊器、口罩、手消毒液。",
          "price": 2,
          "originPrice": 12000,
          "name": "鼻饲-自备物料-1次",
          "picture": "http://yhjstatic-dev.oss-cn-shanghai.aliyuncs.com/avatar/e6b51b90-0951-b9d8-a432-b07655fbf079.jpg"
        },
        {
          "id": 15,
          "desc": "鼻饲是将导管经鼻腔插入胃内，从管内输注食物、水分和药物，以维持病人的营养治疗的技术。（包含插胃管和首次鼻饲）代购物品：一次性无菌鼻胃管：（一套：胃管+无菌手套+鼻贴+盘带+无菌注射器+棉签共计110元）[温馨提示护士代购按照正规医院或者药店购买，注意检查物品有效期等]家属备物品：夹子、别针、适量开水（38～40℃），鼻饲饮料（38～40℃）。护士自备物品：手套、鞋套、听诊器、口罩、手消毒液",
          "price": 2,
          "originPrice": 12000,
          "name": "鼻饲-代购物料-1次",
          "picture": "http://yhjstatic-dev.oss-cn-shanghai.aliyuncs.com/avatar/e6b51b90-0951-b9d8-a432-b07655fbf079.jpg"
        }
      ],
      "department": {
        "id": 1,
        "name": "脊柱外科",
        "organization": {
          "id": 1,
          "name": "309医院"
        }
      },
      "availableTime": {
        "availableDay": {
          "startDay": 1,
          "endDay": 7
        },
        "availableHour": [
          9
        ],
        "minPrepareTime": 30
      },
      "availableNurse": [
        {
          "id": 20,
          "name": "董劭杰"
        },
        {
          "id": 6,
          "name": "李少华"
        },
        {
          "id": 131,
          "name": "袁鑫"
        },
        {
          "id": 59,
          "name": "程冲"
        },
        {
          "id": 111,
          "name": "徐"
        },
        {
          "id": 444,
          "name": "旭红"
        },
        {
          "id": 90,
          "name": "五名"
        }
      ]
    }
  },
  "result": {
    "success": true,
    "code": 0
  }
}

只改状态
{
  "result": {
    "success": true,
    "code": 0
  },
  "data": {
    "item": [
      {
        "id": 163,
        "name": "string",
        "updateAt": 1490252416000,
        "state":5,
        "operationLog": {
          "operator": "string",
          "action": "string",
          "time": 1490252416000,
          "extraInfo": "string"
        },
        "abnormalLog": "string",
        "department": {
          "id": 1490252416000,
          "name": "string",
          "organization": {
            "id": 0,
            "name": "string"
          }
        }
      }
    ]
  }
}

```
###### 实现设计
上游提供itemId和需要更新的信息，下游根据itemId获取itemId，如果item存在，校验传入的数据合法性，如果合法，更新item信息。将更新后的item信息返回到上游。

##### 获取可服务护士的接口设计
GET /api/curvatureDrive/v1/nurse/nurses/{departmentId}

###### 接口描述
获取可提供item服务的护士列表

###### Request
GET /api/curvatureDrive/v1/nurse/nurses/1

###### Response

```json
{
  "data": {
    "availableNurse": [
      {
        "id": 1,
        "name": "新名字"
      },
      {
        "id": 5,
        "name": "新名字"
      },
      {
        "id": 6,
        "name": "李少华"
      },
      {
        "id": 7,
        "name": "新名字"
      },
      {
        "id": 9,
        "name": "大傻子"
      },
      {
        "id": 11,
        "name": "郭德纲"
      },
      {
        "id": 12,
        "name": "冠希陈"
      },
      {
        "id": 13,
        "name": "佳鸿"
      },
      {
        "id": 15,
        "name": "贾宝玉"
      },
      {
        "id": 17,
        "name": "王大锤"
      },
      {
        "id": 19,
        "name": "易俊辰"
      },
      {
        "id": 20,
        "name": "董劭杰"
      },
      {
        "id": 28,
        "name": "张铁林"
      },
      {
        "id": 38,
        "name": "yihuan"
      },
      {
        "id": 40,
        "name": "科室小秘书"
      },
      {
        "id": 45,
        "name": "跳梁小丑"
      },
      {
        "id": 49,
        "name": "miaomiao-test"
      },
      {
        "id": 50,
        "name": "陈晨"
      },
      {
        "id": 51,
        "name": "赵帅"
      }
    ]
  },
  "result": {
    "success": true,
    "code": 0
  }
}

```

##### 获取所有类目的接口设计
GET /api/curvatureDrive/v1/nurse/category

###### 接口描述
进入添加商品页面时将category列表加载出来

###### Request
GET /api/curvatureDrive/v1/nurse/category

###### Response

``` json
{
  "data": {
    "category": [
      {
        "id": 3,
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
      },
      {
        "id": 4,
        "levelOneId": 1,
        "levelOneName": "居家服务",
        "levelTwoId": 2,
        "levelTwoName": "居家日间服务",
        "levelThreeId": 3,
        "levelThreeName": "晨间护理"
      },
      {
        "id": 5,
        "levelOneId": 1,
        "levelOneName": "居家服务",
        "levelTwoId": 2,
        "levelTwoName": "居家日间服务",
        "levelThreeId": 3,
        "levelThreeName": "日间护理"
      },
      {
        "id": 6,
        "levelOneId": 1,
        "levelOneName": "居家服务",
        "levelTwoId": 2,
        "levelTwoName": "居家日间服务",
        "levelThreeId": 3,
        "levelThreeName": "晚间护理"
      },
      {
        "id": 7,
        "levelOneId": 1,
        "levelOneName": "居家服务",
        "levelTwoId": 2,
        "levelTwoName": "居家陪护"
      },
      {
        "id": 8,
        "levelOneId": 1,
        "levelOneName": "居家服务",
        "levelTwoId": 2,
        "levelTwoName": "居家康复服务"
      },
      {
        "id": 9,
        "levelOneId": 1,
        "levelOneName": "居家服务",
        "levelTwoId": 2,
        "levelTwoName": "护理服务",
        "levelThreeId": 3,
        "levelThreeName": "基础护理",
        "levelFourId": 4,
        "levelFourName": "胃管护理"
      },
      {
        "id": 10,
        "levelOneId": 1,
        "levelOneName": "居家服务",
        "levelTwoId": 2,
        "levelTwoName": "护理服务",
        "levelThreeId": 3,
        "levelThreeName": "基础护理",
        "levelFourId": 4,
        "levelFourName": "尿管护理"
      },
      {
        "id": 11,
        "levelOneId": 1,
        "levelOneName": "居家服务",
        "levelTwoId": 2,
        "levelTwoName": "护理服务",
        "levelThreeId": 3,
        "levelThreeName": "专科护理",
        "levelFourId": 4,
        "levelFourName": "内科护理"
      },
      {
        "id": 17,
        "levelOneId": 1,
        "levelOneName": "居家服务",
        "levelTwoId": 2,
        "levelTwoName": "护理服务",
        "levelThreeId": 3,
        "levelThreeName": "专科护理",
        "levelFourId": 4,
        "levelFourName": "外科护理",
        "levelFiveId": 5,
        "levelFiveName": "造口护理"
      },
      {
        "id": 18,
        "levelOneId": 1,
        "levelOneName": "居家服务",
        "levelTwoId": 2,
        "levelTwoName": "护理服务",
        "levelThreeId": 3,
        "levelThreeName": "专科护理",
        "levelFourId": 4,
        "levelFourName": "外科护理",
        "levelFiveId": 5,
        "levelFiveName": "伤口护理"
      },
      {
        "id": 19,
        "levelOneId": 1,
        "levelOneName": "居家服务",
        "levelTwoId": 2,
        "levelTwoName": "护理服务",
        "levelThreeId": 3,
        "levelThreeName": "专科护理",
        "levelFourId": 4,
        "levelFourName": "妇科护理"
      },
      {
        "id": 20,
        "levelOneId": 1,
        "levelOneName": "居家服务",
        "levelTwoId": 2,
        "levelTwoName": "护理服务",
        "levelThreeId": 3,
        "levelThreeName": "专科护理",
        "levelFourId": 4,
        "levelFourName": "产科护理"
      },
      {
        "id": 21,
        "levelOneId": 1,
        "levelOneName": "居家服务",
        "levelTwoId": 2,
        "levelTwoName": "护理服务",
        "levelThreeId": 3,
        "levelThreeName": "专科护理",
        "levelFourId": 4,
        "levelFourName": "新生儿护理",
        "levelFiveId": 5,
        "levelFiveName": "新生儿基础护理"
      },
      {
        "id": 22,
        "levelOneId": 1,
        "levelOneName": "居家服务",
        "levelTwoId": 2,
        "levelTwoName": "护理服务",
        "levelThreeId": 3,
        "levelThreeName": "专科护理",
        "levelFourId": 4,
        "levelFourName": "新生儿护理",
        "levelFiveId": 5,
        "levelFiveName": "新生儿基础便秘"
      },
      {
        "id": 23,
        "levelOneId": 1,
        "levelOneName": "居家服务",
        "levelTwoId": 2,
        "levelTwoName": "护理服务",
        "levelThreeId": 3,
        "levelThreeName": "专科护理",
        "levelFourId": 4,
        "levelFourName": "新生儿科护理",
        "levelFiveId": 5,
        "levelFiveName": "新生儿黄疸"
      },
      {
        "id": 24,
        "levelOneId": 1,
        "levelOneName": "居家服务",
        "levelTwoId": 2,
        "levelTwoName": "护理服务",
        "levelThreeId": 3,
        "levelThreeName": "专科护理",
        "levelFourId": 4,
        "levelFourName": "新生儿科护理",
        "levelFiveId": 5,
        "levelFiveName": "新生儿喂药"
      }
    ]
  },
  "result": {
    "success": true,
    "code": 0
  }
}
```

###### 实现设计
上游调用下游的获取category列表的接口，将category列表返回给上游。

##### 获取标准化服务列表的接口设计
/api/curvatureDrive/v1/nurse/department/{departmentId}/standardized-service-templates/{categoryId}

###### 接口描述
服务提供商获取标准化服务列表

###### Request
GET /api/curvatureDrive/v1/nurse/department/1/standardized-service-templates/5

###### Response

```json
{
  "data": {
    "standardService": [
      {
        "articleSection": [
          {
            "title": "推荐健康宣教知识",
            "desc": "下单后，系统自动向患者推送健康宣教文章",
            "order": 1,
            "article": [
              {
                "id": 519,
                "title": "后端的第一条宣教",
                "read": false
              },
              {
                "id": 1295,
                "title": "后端的第二条宣教",
                "read": false
              }
            ]
          }
        ],
        "toolSection": [
          {
            "title": "服务器评估",
            "desc": "服务前，对患者状态进行综合评估",
            "order": 1,
            "tool": [
              {
                "id": 124,
                "title": "后端的第一条自测",
                "summary": ""
              },
              {
                "id": 124,
                "title": "后端的第二条自测（和第一条一样，不是BUG）",
                "summary": ""
              }
            ]
          }
        ],
        "evaluateSection": [
          {
            "title": "Nurse评估",
            "desc": "服务前，对患者状态进行综合评估",
            "order": 1,
            "evaluate": [
              {
                "id": 275,
                "title": "生活能力",
                "summary": ""
              },
              {
                "id": 273,
                "title": "压促昂？",
                "summary": ""
              }
            ]
          }
        ],
        "stepAction": [
          {
            "title": "尿管护理操作",
            "desc": "服务前，对患者状态进行综合评估",
            "order": 1,
            "step": [
              {
                "title": "第一步",
                "desc": "第一步详情",
                "done": false
              },
              {
                "title": " 第二步",
                "desc": "第二步详情",
                "done": false
              }
            ]
          }
        ],
        "categoryId": 5,
        "id": 8785
      }
    ]
  },
  "result": {
    "success": true,
    "code": 0
  }
}

```

###### 实现设计
根据templateType和departmentId获取一组standardServiceTemplate,取出它们的content内容，过滤，如果content内容的categoryId匹配到传入的categoryId，则返回结果

#### 商品审核人员请求的URL（admin身份登录）

##### 根据条件组合查询item列表的接口设计
GET /api/curvatureDrive/v1/admin/items?departmentId={departmentId}&itemId={itemId}&state={state}&length={length}&start={start}&draw={draw}

###### 接口描述
商品审核人员在商品列表页，输入查询条件，获取商品列表。输入的查询条件是可选项，但是三者必须填写一个

###### Request 
GET /api/curvatureDrive/v1/admin/items?length=5&start=1&departmentId=1&draw=12
###### Response

``` json

{
  "data": {
    "item": [
      {
        "id": 139,
        "name": "专业鼻饲",
        "state": 1,
        "updatedAt": 1490159141000,
        "department": {
          "id": 1,
          "name": "脊柱外科",
          "organization": {
            "id": 1,
            "name": "309医院"
          }
        }
      },
      {
        "id": 146,
        "name": "专业造口护理",
        "state": 1,
        "updatedAt": 1490069225000,
        "department": {
          "id": 1,
          "name": "脊柱外科",
          "organization": {
            "id": 1,
            "name": "309医院"
          }
        }
      },
      {
        "id": 122,
        "name": "专业鼻饲",
        "state": 1,
        "updatedAt": 1490005553000,
        "department": {
          "id": 1,
          "name": "脊柱外科",
          "organization": {
            "id": 1,
            "name": "309医院"
          }
        }
      },
      {
        "id": 120,
        "name": "导尿-我们是专业的",
        "state": 1,
        "updatedAt": 1490002046000,
        "department": {
          "id": 1,
          "name": "脊柱外科",
          "organization": {
            "id": 1,
            "name": "309医院"
          }
        }
      },
      {
        "id": 97,
        "name": "商品支撑鼻饲update",
        "state": 2,
        "updatedAt": 1489982786000,
        "abnormalLog": "哎哟，异常了哦",
        "operationLog": {
          "operator": "ljm",
          "action": "审核不通过",
          "time": 1489828622,
          "extraInfo": "描述与商品性质不符,不通过"
        },
        "department": {
          "id": 1,
          "name": "脊柱外科",
          "organization": {
            "id": 1,
            "name": "309医院"
          }
        }
      }
    ]
  },
  "result": {
    "success": true,
    "code": 0
  },
  "draw": 12,
  "recordsFiltered": 22,
  "recordsTotal": 0
}

```
###### 实现设计
上游传入输入的查询条件,调用下游的/api/dagon/v2/items接口，返回页面的item包含页面元素所需的信息

##### 更新item信息的接口设计
PATCH /api/curvatureDrive/v1/admin/item/{itemId}

###### 接口描述
根据itemId更新item信息

###### Request
PATCH /api/curvatureDrive/v1/admin/item/1

```json
    {
        "id":163,
        "state":5,
        "abnormalLog": "置为异常的理由",
        "operationLog":{
            "operator": "操作人",
            "action": "执行的动作",
            "time": "时间",
            "extraInfo": "操作信息"
    }        
}

```

==当将item置为异常时，需要传入abnormalLog；当item审核失败时，需要传入operationLog；当只改变item状态时，只需传入itemId和执行该动作后的item状态。==
###### Response

```json

{
  "result": {
    "success": true,
    "code": 0
  },
  "data": {
    "item": [
      {
        "id": 0,
        "name": "string",
        "updateAt": 0,
        "state":5,
        "operationLog": {
          "operator": "string",
          "action": "string",
          "time": 0,
          "extraInfo": "string"
        },
        "abnormalLog": "string",
        "department": {
          "id": 0,
          "name": "string",
          "organization": {
            "id": 0,
            "name": "string"
          }
        }
      }
    ]
  }
}


```
###### 实现设计
上游提供itemId和需要更新的信息，下游根据itemId获取itemId，如果item存在，校验传入的数据合法性，如果合法，更新item信息。将更新后的item信息返回到上游。

##### 获取单个item信息的接口设计
GET /api/warpDriver/v1/admin/item/{itemId}

###### 接口描述
根据itemId获取item详细信息

###### Request
GET /api/warpDriver/v1/admin/item/97

###### Response

```json

{
  "data": {
    "item": {
      "id": 4,
      "name": "鼻饲【自备物品】",
      "desc": "鼻饲是将导管经鼻腔插入胃内，从管内输注食物、水分和药物，以维持病人的营养治疗的技术。（包含插胃管和首次鼻饲）家属自备物品：一次性无菌鼻胃管：（一套：胃管+无菌手套+鼻贴+盘带+无菌注射+棉签），适量开水（38～40℃），鼻饲饮料（38～40℃）。[温馨提示家属选择正规医院或者药店购买，注意检查物品有效期等]护士自备物品：手套、鞋套、听诊器、口罩、手消毒液",
      "detailHTML": "<h3 style=\"white-space: normal; background-color: #f6f6f6;\">上门服务介绍内容</h3>\n<p>导尿，是经由尿道插入导尿管到膀胱，引流出尿液。提供导尿服务（包含尿管更换）、拔除尿管服务以及其他尿管渗漏、尿袋更换等服务。</p>\n<h3 class=\"font-color-global-base padding-height-xs\">家属自备物品:</h3>\n<p>超滑抗菌尿管：（一套：尿管+无菌手套+无菌注射器+盘带）[温馨提示家属选择正规医院或者药店购买，注意检查物品有效期等]</p>\n<h3 class=\"font-color-global-base padding-height-xs\">护士备物品：</h3>\n<p>手套、鞋套、口罩、手消毒液</p>",
      "picture": [
        "http://yhjstatic-dev.oss-cn-shanghai.aliyuncs.com/avatar/e6b51b90-0951-b9d8-a432-b07655fbf079.jpg"
      ],
      "state": 6,
      "duration": 4500,
      "category": {
        "id": 9,
        "levelOneId": 1,
        "levelOneName": "居家服务",
        "levelTwoId": 2,
        "levelTwoName": "护理服务",
        "levelThreeId": 3,
        "levelThreeName": "基础护理",
        "levelFourId": 4,
        "levelFourName": "胃管护理"
      },
      "updatedAt": 1491097629000,
      "standardService": {
        "articleSection": [
          {
            "title": "推荐健康宣教知识",
            "desc": "下单后，系统自动向患者推送健康宣教文章",
            "order": 1,
            "article": [
              {
                "id": 519,
                "title": "后端的第一条宣教",
                "read": false
              },
              {
                "id": 1295,
                "title": "后端的第二条宣教",
                "read": false
              }
            ]
          }
        ],
        "toolSection": [
          {
            "title": "服务器评估",
            "desc": "服务前，对患者状态进行综合评估",
            "order": 1,
            "tool": [
              {
                "id": 124,
                "title": "后端的第一条自测",
                "summary": ""
              },
              {
                "id": 124,
                "title": "后端的第二条自测（和第一条一样，不是BUG）",
                "summary": ""
              }
            ]
          }
        ],
        "evaluateSection": [
          {
            "title": "Nurse评估",
            "desc": "服务前，对患者状态进行综合评估",
            "order": 1,
            "evaluate": [
              {
                "id": 275,
                "title": "生活能力",
                "summary": ""
              },
              {
                "id": 273,
                "title": "压促昂？",
                "summary": ""
              }
            ]
          }
        ],
        "stepAction": [
          {
            "title": "尿管护理操作",
            "desc": "服务前，对患者状态进行综合评估",
            "order": 1,
            "step": [
              {
                "title": "第一步",
                "desc": "第一步详情",
                "done": false
              },
              {
                "title": " 第二步",
                "desc": "第二步详情",
                "done": false
              }
            ]
          }
        ],
        "categoryId": 5,
        "id": 8785
      },
      "itemProp": [
        {
          "id": 6,
          "name": "物料",
          "itemPropValue": [
            {
              "id": 11,
              "name": "自备物料"
            },
            {
              "id": 12,
              "name": "代购物料"
            }
          ]
        },
        {
          "id": 7,
          "name": "套餐",
          "itemPropValue": [
            {
              "id": 13,
              "name": "1次"
            }
          ]
        }
      ],
      "abnormalLog": "看着不爽",
      "serviceItem": [
        {
          "id": 14,
          "desc": "鼻饲是将导管经鼻腔插入胃内，从管内输注食物、水分和药物，以维持病人的营养治疗的技术。（包含插胃管和首次鼻饲）家属自备物品：一次性无菌鼻胃管：（一套：胃管+无菌手套+鼻贴+盘带+无菌注射器+棉签），适量开水（38～40℃），鼻饲饮料（38～40℃）。[温馨提示家属选择正规医院或者药店购买，注意检查物品有效期等]护士自备物品：手套、鞋套、听诊器、口罩、手消毒液。",
          "price": 2,
          "originPrice": 12000,
          "name": "鼻饲-自备物料-1次",
          "picture": "http://yhjstatic-dev.oss-cn-shanghai.aliyuncs.com/avatar/e6b51b90-0951-b9d8-a432-b07655fbf079.jpg"
        },
        {
          "id": 15,
          "desc": "鼻饲是将导管经鼻腔插入胃内，从管内输注食物、水分和药物，以维持病人的营养治疗的技术。（包含插胃管和首次鼻饲）代购物品：一次性无菌鼻胃管：（一套：胃管+无菌手套+鼻贴+盘带+无菌注射器+棉签共计110元）[温馨提示护士代购按照正规医院或者药店购买，注意检查物品有效期等]家属备物品：夹子、别针、适量开水（38～40℃），鼻饲饮料（38～40℃）。护士自备物品：手套、鞋套、听诊器、口罩、手消毒液",
          "price": 2,
          "originPrice": 12000,
          "name": "鼻饲-代购物料-1次",
          "picture": "http://yhjstatic-dev.oss-cn-shanghai.aliyuncs.com/avatar/e6b51b90-0951-b9d8-a432-b07655fbf079.jpg"
        }
      ],
      "department": {
        "id": 1,
        "name": "脊柱外科",
        "organization": {
          "id": 1,
          "name": "309医院"
        }
      },
      "availableTime": {
        "availableDay": {
          "startDay": 1,
          "endDay": 7
        },
        "availableHour": [
          9
        ],
        "minPrepareTime": 30
      },
      "availableNurse": [
        {
          "id": 20,
          "name": "董劭杰"
        },
        {
          "id": 6,
          "name": "李少华"
        },
        {
          "id": 131,
          "name": "袁鑫"
        },
        {
          "id": 59,
          "name": "程冲"
        },
        {
          "id": 111,
          "name": "徐"
        },
        {
          "id": 444,
          "name": "旭红"
        },
        {
          "id": 90,
          "name": "五名"
        }
      ]
    }
  },
  "result": {
    "success": true,
    "code": 0
  }
}

```

###### 实现设计
上游给出itemId，调用下游的/api/dagon/v2/item/{itemId}接口，下游根据itemId从数据库中获取itemId信息。

##### 获取提供商品服务的服务机构接口设计
GET /api/curvatureDrive/v1/admin/item/departments

###### 接口描述
进入商品审核的主页，加载所有提供商品服务的服务机构

###### Request
GET /api/curvatureDrive/v1/admin/item/departments

###### Response
```json
{
  "data": {
    "department": [
      {
        "id": 211,
        "name": "test-c-dpt",
        "organization": {
          "id": 3,
          "name": "优护家"
        }
      },
      {
        "id": 2,
        "name": "优护家-test",
        "organization": {
          "id": 3,
          "name": "优护家"
        }
      },
      {
        "id": 1,
        "name": "脊柱外科",
        "organization": {
          "id": 1,
          "name": "309医院"
        }
      }
    ]
  },
  "result": {
    "success": true,
    "code": 0
  }
}

```

###### 实现设计
根据tagType=5（可提供服务的护士）查询tag表，获取到一组departmentId，在根据这组departmentId查询department表，获取到提供服务的部门

### 项目排期

| 内容 | 耗时/人日 | 开始日期 | 实现者 |
| --- | --- | --- | --- |
| 商品管理系统页面开发 | 4 | 03.20 | 李少华 |
| 运营审核系统页面开发 | 4 | 03.20 | 李旭 |
| 后端底层系统Dagon开发 | 3 | 03.11 | 李江明 | 
| 后端底层系统Dagon测试 | 1 |	03.11 | 李江明 |
| 后端底层系统Dagon开发 | 1.5 | 03.11 | 卢江 |
| 后端底层系统Dagon测试 | 0.5 | 03.11 | 卢江 |
| 后端应用系统CurvatureDriver开发 | 4 | 03.15 | 李江明 |
| 后端应用系统CurvatureDriver测试 | 2 | 03.15 | 李江明 |
| 前后端联调 | 0.5 | 03.24 | 李旭、李少华、李江明 |
| develop环境测试| 1.5 | 03.27 | 郑旭红 |
| Staging环境部署CurvatureDriver、Dagon | 0.5 | 03.28 | 学文Or赵蔺 |
| Staging环境测试 | 2.5 | 03.28 | 郑旭红 |
| 验收 | 0.5 | 04.01 | 张正宇&张跃超 |



