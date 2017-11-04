
---
title: C端科室展示内容编辑后台 技术文档
---

# 摘要

C端科室展示内容编辑后台 技术文档

<!-- more -->

# C端科室展示内容编辑后台 详细设计

## 背景

prd 见：[「C端科室展示内容编辑后台PRD」https://wayknew.com/articles/343]

主要涉及以下项目：

- Evans
- HdFragments
- Civilization
- Dagon
- Solar

## Evans已有接口

**机构列表，登录之后进入机构和科室名称搜索页面调用接口:**

GET /api/evans/v1/admin/all-organizations

Response :

```protobuf
message OrganizationListDTO {
    message Organization {
        optional int64 organizationId = 1;
        optional string organizationName = 2;
    }
    message Data {
        repeated Organization organization = 1;
    }
    optional  Data data = 1;
    optional Result result = 2;
}
```

**科室列表，选择机构名称之后返回机构下所有科室:**

GET /api/evans/v1/admin/departments?organizationId=1

Response :

```protobuf

message DepartmentListDTO {
    message DepartmentOption {
        optional int64 departmentId = 1;
        optional string departmentName = 2;
        optional int64 organizationId = 3;
        optional string organizationName = 4;
    }
    message Data {
        repeated Department department = 1;
    }
    optional Result result = 1;
    optional  Data data = 2;
}
```

## Evans新增部分

### protobuf定义

```protobuf
message ComponentOption {
    optional int64 departmentId = 1;
    repeated Component component = 2;
}

message ComponentDTO {
    message Data {
        optional int64 departmentId = 1;
        repeated Component component = 2;
    }
    optional Result result = 1;
    optional  Data data = 2;
}

message Component {
    optional string type = 1;
    optional ArticleGroup articleGroup = 2;
    optional SelfEvaluation selfEvaluation = 3;
    optional ServiceItem serviceItem = 4;
    optional ArticleList articleList = 5;
}

message ArticleGroup {
    optional string title = 1;
    optional int64 componentId = 2;
    optional int64 creatorId = 3;
    optional int64 departmentId = 4;
    repeated Group group = 5;
    optional int64 categoryId = 6;
    optional int64 rank = 7;
}

message Group {
    optional int64 id = 1;
    optional string name = 2;
    optional string icon = 3;
    optional string iconColor = 4;
    repeated Article article = 5;
}

message SelfEvaluation {
    optional string title = 1;
    optional int64 componentId = 2;
    optional int64 creatorId = 3;
    optional int64 departmentId = 4;
    repeated SelfEvaluationData selfEvaluationData = 5;
    optional int64 categoryId = 6;
    optional int64 rank = 7;
}

message SelfEvaluationData {
    optional int64 id = 1;
    optional string name = 2;
}

message ServiceItem {
    optional string title = 1;
    optional int64 componentId = 2;
    optional int64 creatorId = 3;
    optional int64 departmentId = 4;
    repeated ServiceItemData serviceItemData = 5;
    optional int64 categoryId = 6;
    optional int64 rank = 7;
}

message ServiceItemListDTO {
   message Data {
      repeated ServiceItemData serviceItemData = 1;
   }
   optional Result result = 1;
   optional Data data = 2;
}

message ServiceItemData {
    optional int64 id = 1;
    optional string name = 2;
}

message ArticleList {
    optional string title = 1;
    optional int64 componentId = 2;
    optional int64 creatorId = 3;
    optional int64 departmentId = 4;
    repeated Article article = 5;
    optional int64 categoryId = 6;
    optional int64 rank = 7;
}

message GetEvaluationListDTO {
    message Data {
        repeated EvaluationBaseInfo evaluation = 1;
    }
    optional Result result = 1;
    optional Data data = 2;
}

message EvaluationBaseInfo {
    optional int64 evaluationId = 1;
    optional string evaluationName = 2;
    optional string iconColor = 3;
    optional string icon = 4;
    optional string organizationName = 5;
    optional string departmentName = 6;
    optional int64 updateAt = 7;
    optional string groupName = 8;
    optional string author = 9;
    optional int64 status = 10;
}

```

### 新增接口详情：
除admin登录之后，选择科室之后搜索接口，evas本次主要提供根据科室Id查询所有UI配置信息接口（GET）、增加UI配置信息接口（POST）、修改UI配置信息接口（PATCH），以下是接口详情：

**获取科室下所有UI配置:**

GET /api/evans/v1/admin/department/component/{departmentId}

```java

Evans.ComponentDTO getCompentByDptId(@PathVariable Long departmentId)

```

**向科室增加一个栏目**

POST /api/evans/v1/admin/department/component

```java

Common.Result addComponent(@ResponseBody Evans.ComponentOption option)

```

**向科室修改或删除一个栏目**

PATCH /api/evans/v1/admin/department/component

```java

Common.Result updateComponent(@ResponseBody Evans.ComponentOption option)

```

**获取科室下所有自测**
 
GET /api/evans/v1/admin/evaluations?departmentId={departmentId}&type={type}

```java
Evans.GetEvaluationListDTO GetEvaluationListDTOByDptId(@ParamMap map)
```

**获取科室下所有服务**

GET /api/evans/v1/admin/department/component/services/{departmentId}

```java

Evans.ServiceItemListDTO getServiceItemListByDptId(@PathVariable("departmentId") Long departmentId)

```# 摘要

C端科室展示内容编辑后台 技术文档

<!-- more -->

# C端科室展示内容编辑后台 详细设计

## 背景

prd 见：[「C端科室展示内容编辑后台PRD」https://wayknew.com/articles/343]

主要涉及以下项目：

- Evans
- HdFragments
- Civilization
- Dagon
- Solar

## Evans已有接口

**机构列表，登录之后进入机构和科室名称搜索页面调用接口:**

GET /api/evans/v1/admin/all-organizations

Response :

```protobuf
message OrganizationListDTO {
    message Organization {
        optional int64 organizationId = 1;
        optional string organizationName = 2;
    }
    message Data {
        repeated Organization organization = 1;
    }
    optional  Data data = 1;
    optional Result result = 2;
}
```

**科室列表，选择机构名称之后返回机构下所有科室:**

GET /api/evans/v1/admin/departments?organizationId=1

Response :

```protobuf

message DepartmentListDTO {
    message DepartmentOption {
        optional int64 departmentId = 1;
        optional string departmentName = 2;
        optional int64 organizationId = 3;
        optional string organizationName = 4;
    }
    message Data {
        repeated Department department = 1;
    }
    optional Result result = 1;
    optional  Data data = 2;
}
```

## Evans新增部分

### protobuf定义

```protobuf
message ComponentOption {
    optional int64 departmentId = 1;
    repeated Component component = 2;
}

message ComponentDTO {
    message Data {
        optional int64 departmentId = 1;
        repeated Component component = 2;
    }
    optional Result result = 1;
    optional  Data data = 2;
}

message Component {
    optional string type = 1;
    optional ArticleGroup articleGroup = 2;
    optional SelfEvaluation selfEvaluation = 3;
    optional ServiceItem serviceItem = 4;
    optional ArticleList articleList = 5;
}

message ArticleGroup {
    optional string title = 1;
    optional int64 componentId = 2;
    optional int64 creatorId = 3;
    optional int64 departmentId = 4;
    repeated Group group = 5;
    optional int64 categoryId = 6;
    optional int64 rank = 7;
}

message Group {
    optional int64 id = 1;
    optional string name = 2;
    optional string icon = 3;
    optional string iconColor = 4;
    repeated Article article = 5;
}

message SelfEvaluation {
    optional string title = 1;
    optional int64 componentId = 2;
    optional int64 creatorId = 3;
    optional int64 departmentId = 4;
    repeated SelfEvaluationData selfEvaluationData = 5;
    optional int64 categoryId = 6;
    optional int64 rank = 7;
}

message SelfEvaluationData {
    optional int64 id = 1;
    optional string name = 2;
}

message ServiceItem {
    optional string title = 1;
    optional int64 componentId = 2;
    optional int64 creatorId = 3;
    optional int64 departmentId = 4;
    repeated ServiceItemData serviceItemData = 5;
    optional int64 categoryId = 6;
    optional int64 rank = 7;
}

message ServiceItemListDTO {
   message Data {
      repeated ServiceItemData serviceItemData = 1;
   }
   optional Result result = 1;
   optional Data data = 2;
}

message ServiceItemData {
    optional int64 id = 1;
    optional string name = 2;
}

message ArticleList {
    optional string title = 1;
    optional int64 componentId = 2;
    optional int64 creatorId = 3;
    optional int64 departmentId = 4;
    repeated Article article = 5;
    optional int64 categoryId = 6;
    optional int64 rank = 7;
}

message GetEvaluationListDTO {
    message Data {
        repeated EvaluationBaseInfo evaluation = 1;
    }
    optional Result result = 1;
    optional Data data = 2;
}

message EvaluationBaseInfo {
    optional int64 evaluationId = 1;
    optional string evaluationName = 2;
    optional string iconColor = 3;
    optional string icon = 4;
    optional string organizationName = 5;
    optional string departmentName = 6;
    optional int64 updateAt = 7;
    optional string groupName = 8;
    optional string author = 9;
    optional int64 status = 10;
}

```

### 新增接口详情：
除admin登录之后，选择科室之后搜索接口，evas本次主要提供根据科室Id查询所有UI配置信息接口（GET）、增加UI配置信息接口（POST）、修改UI配置信息接口（PATCH），以下是接口详情：

**获取科室下所有UI配置:**

GET /api/evans/v1/admin/department/component/{departmentId}

```java

Evans.ComponentDTO getCompentByDptId(@PathVariable Long departmentId)

```

**向科室增加一个栏目**

POST /api/evans/v1/admin/department/component

```java

Common.Result addComponent(@ResponseBody Evans.ComponentOption option)

```

**向科室修改或删除一个栏目**

PATCH /api/evans/v1/admin/department/component

```java

Common.Result updateComponent(@ResponseBody Evans.ComponentOption option)

```

**获取科室下所有自测**
 
GET /api/evans/v1/admin/evaluations?departmentId={departmentId}&type={type}

```java
Evans.GetEvaluationListDTO GetEvaluationListDTOByDptId(@ParamMap map)
```

**获取科室下所有服务**

GET /api/evans/v1/admin/department/component/services/{departmentId}

```java

Evans.ServiceItemListDTO getServiceItemListByDptId(@PathVariable("departmentId") Long departmentId)

```

