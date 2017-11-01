---
title: 虚拟科室管理后台需求整理
date: 2017-3-25
categories: C++
tags:
- 产品设计
- 虚拟科室管理后台
---

## 摘要

虚拟科室后台管理:创建虚拟科室，为虚拟科室和疾病树创建关联关系
<!--more-->

## 需求

虚拟科室: 非具体的科室，具体的科室是附在某个organization（机构）下的，而虚拟科室是不需要附在机构下的。

虚拟科室下可以配置相应的疾病，疾病下有相应的文章，宣教和评估工具。当患者在C端页面关注了某中疾病后，该患者可以看到和疾病相关的文章，宣教和评估工具，从而形成形成患者-机构-疾病-内容的对应关系。虚拟科室管理后台主要业务大致有:

* 科室管理

    * 新建科室（通用科室或普通科室）
    * 将这些科室与疾病树关联起来（打tag的过程）

* 文章管理
    
    * 新建文章
    * 为文章打tag，即为文章和疾病树建立关系

* 工具管理
    
    * 新建评估工具
    * 为评估工具打tag，即为评估工具和疾病树建立关系

## 场景分析

### 创建一个科室的流程（可以是虚拟科室、普通科室）

* 选择科室类型
* 填写科室名称
* 为科室创建疾病

    * 在已有的疾病树选择tag，将tag和科室关联起来
    * 创建新的疾病，但不能和疾病树中的疾病有冲突
    
        * 为新疾病创建tag
        * 将新tag和科室关联起来

* 选择宣教文章

    * 根据选中的标签，自动匹配文章
    * 手动选择
    * 手动创建新文章
    
        * 将新文章和tag关联起来

* 选择评估工具

    * 根据所选标签，自动匹配评估工具
    * 手动选择
    * 手动创建
    
        * 将新评估工具和tag关联起来

* 个性化的设置

    * 设置Logo
    * 生成二维码

![](/media/virtual_department.png)


## 虚拟科室设计方案

### 设计

复用原有的Organization（机构）表，在organization表中添加一个名为type的字段，用来区分通用科室和普通机构。所有的科室都挂在organization下，通过organization的type可以知道该机构下的科室是普通科室还是虚拟科室。

### 实现方案

患者、科室、疾病、宣教、文章、评估之间的关系都是通过tag实现，当给科室打上疾病tag的同时，对应的宣教、文章和评估都为科室形成映射关系。当某个患者进入到科室，关注科室下的某个疾病，也没给该患者打上疾病tag，然后患者就可以阅读关于疾病的宣教、使用评估工具，对自己的身体情况做一些测试，掌握自己的健康情况。

![](/media/tag-dept-user-relation.png)

在当前tag系统内置的tag不满足需求的情况下，比如，新建了一个科室，并关联了一个疾病tag,当时自动生成的文章、宣教、评估工具等满足不了需求。可以手动的新建tag。新建的tag进入tag系统。

### protobuf数据

==初步预想，等待设计==

```json

message Result {

    optional string msg = 1 ;
    optional boolean success = 2 ;
    optional displayMsg = 3 ;
    optional int64 code = 4 ;

}

message Organization {

    optional int64 id = 1;
    optional string name = 2;
    optional int64 status = 3;
    optional string address = 5;
    optional string lat = 6;
    optional string lon = 7;
    optional int64 createdAt = 8;
    optional int64 updatedAt = 9;
    optional int32 type = 10 ;

}

message Department {

    optional int64 id = 1;
    optional int64 organizationId = 2;
    optional string name = 3;
    optional string number = 4;
    optional string authCode = 5;
    optional int64 status = 6;
    optional int64 createdAt = 7;
    optional int64 updatedAt = 8;
    optional bool isGuest = 9;
    optional int64 hostId = 10;

}

message DepartmentDTO {

    optional int64 id = 1;
    optional Organization organization = 2;
    optional string name = 3;
    optional string number = 4;
    optional string authCode = 5;
    optional int64 status = 6;
    optional int64 createdAt = 7;
    optional int64 updatedAt = 8;
    optional bool isGuest = 9;
    optional int64 hostId = 10;
    optional Result result = 11 ;

}

message DepartmentAddOption {

    optional int64 organizationId = 1;
    optional string name = 2;
    optional string number = 3;
    
}

message Disease{

    optional int64 id =1;
    optional string name =2;
    optional string desc =3;
    optional boolean hasParentNode = 4;
    optional boolean isPatentNode = 5;
    optional int64 parentId = 6;
    optional int64 departmentId = 7;

}

message DiseaseDTO{

    optional int64 id =1;
    optional string name =2;
    optional string desc =3;
    optional boolean hasParentNode = 4;
    optional boolean isPatentNode = 5;
    optional int64 parentId = 6;
    optional Department department = 7;
    optional Result result = 8;

}

message DiseaseListDTO{

    repeated Disease disease = 1 ;
    optional Result result = 2 ;
    
}

message DiseaseListOption{
    repeated int64 id =1;
}

message Article {

    optional int64 id = 1;
    optional string name = 2;
    optional string brief = 3;
    optional string content = 4;
    optional string bannerUrl = 5;
    optional string dataType = 6;
    optional int64 articleTypeId = 7;
    optional int32 status = 8;

}

message ArticleDTO{

    optional Article article = 1;
    optional Result result = 2;
    
}

message ArticleListDTO {

    optional Result result = 1;
    repeated Article article = 2;

}

message ArticleAddOption {

    optional string name = 1;
    optional string brief = 2;
    optional string content = 3;
    optional string bannerUrl = 4;
    optional string dataType = 5;
    optional int64 articleTypeId = 6;

}

message ArticleUpdateOption {

    optional int64 id = 1;
    optional string name = 2;
    optional string brief = 3;
    optional string content = 4;
    optional string bannerUrl = 5;
    optional string dataType = 6;
    optional int64 articleTypeId = 7;
    optional int32 status = 8;
    
}

message Tool{

    optional int64 id = 1;
    optional string name = 2;
    optional string brief = 3;
    optional string icon = 4;
    optional string iconColor = 5;

}

message ToolDTO{

    optional int64 id = 1;
    optional string name = 2;
    optional string brief = 3;
    optional string icon = 4;
    optional string iconColor = 5;
    optional Result result = 6;
    
}

message ToolListDTO {

    optional Result result = 1;
    repeated Tool tool = 2;
    optional Result result = 3;

}

message ToolAddOption {

    optional string name = 1;
    optional string brief = 2;
    optional string icon = 3;
    optional string iconColor = 4;
    optional int64 departmentId = 5;

}

message ToolUpdateOption {

    optional int64 id = 1;
    optional string name = 2;
    optional string brief = 3;
    optional string icon = 4;
    optional string iconColor = 5;
    optional int64 departmentId = 6;

}


message departmentArticle {

    optional int64 id = 1;
    optional int64 departmentId = 2;
    optional int64 articleId = 3;

}

message departmentTool {

    optional int64 id = 1;
    optional int64 departmentId = 2;
    optional int64 toolId = 3;

}

message ArticleCategory{
    
    optional int64 id = 1;
    optional string name = 2;
    optional string icon_id = 3;
    optional string icon_color = 4;
    optional int64 createAt = 5;
    optional int64 updateAt = 6;
    
}

```

API定义

* 创建虚拟科室

>     POST /api/vrigo/v1/department
    
* 为虚拟科室和tag建立关联

>     POST /api/vrigo/v1/tags/department/{departmentId}
    
* 获取tag列表

>     GET /api/vrigo/v1/tags

* 根据tagId获取文章

>     GET /api/vrigo/v1/articles/{tagId}

* 创建新文章

>     POST /api/vrigo/v1/article

* 为文章和tag建立关联

>     POST /api/vrigo/v1/tags/article/{articelId}

* 根据articleId获取article
    
>     GET /api/vrigo/v1/article/{articleId}

* 根据tagId获取评估工具

>     GET /api/vrigo/v1/tools/{tagId}

* 创建新的评估工具

>     POST /api/vrigo/v1/tool
    
* 为评估工具和tag建立关联

>     POST /api/vrigo/v1/tags/tool/{toolId}

* 根据toolId获取tool

>     GET /api/vrigo/v1/tool/{toolId}
    
## 接口详细设计

### 创建科室

POST /api/vrigo/v1/department

### Request

```json
{
    "name":"优护家虚拟科室",
    "organization":1,
    "number":"66666"
}

```
    
### Response

```json

{

    "id":1,
    "name":"优护家虚拟科室",
    "number":"6666",
    "status":0,
    "createdAt":1491042333,
    "updatedAt": 1491042333,
    "isGuest":true,
    "hostId":1,
    "organization":{
        "id":1,
        "name":"xxx"
    }
    "result"{
        "code":0,
        "displayMsg":"xxxx"
    }

}

```

### 关联科室和tag

POST /api/vrigo/v1/tags/department/{departmentId}

### Request

POST /api/vrigo/v1/tags/department/1

```json

{
    [
       {
        "id":1
       },
       {
        "id":2
       } 
    ]
}

```

### Response

```json

{
    "result":{
        "code":0,
        "displayMessage":"xxxx"
    }
}

```

### 获取tag列表

GET /api/vrigo/v1/tags

### Request

GET /api/vrigo/v1/tags

### Response
```json

{
    [
        {
        
           "id":1,
            "name":"疾病树名称",
            "desc":"XXXXXX"
            "department":{
                "id":1,
                "name":"优护家虚拟科室"
                "organization":{
                    "id":1,
                    "name":"优护家医院"
                }
            }
        },
        {
            "id":2，
            "name":"疾病树名称",
            "desc":"XXXXXX"
            "department":{
                "id":1,
                "name":"优护家虚拟科室"
                "organization":{
                    "id":1,
                    "name":"优护家医院"
                }
            }
        
        },
        {
            "id":3,
            "name":"疾病树名称",
            "desc":"XXXXXX"
            "department":{
                "id":1,
                "name":"优护家虚拟科室"
                "organization":{
                    "id":1,
                    "name":"优护家医院"
                }
            }
        
        }
    
    ]
}

```

### 根据tagId获取文章列表
 
GET /api/vrigo/v1/articles/{tagId}

### Request

GET /api/vrigo/v1/articles/1

### Response

```json

{

    [
        {    
            "id":1,
            "name":"文章名称",
            "brief":"文章简介",
            "content":"文章内容",
            "iconUrl":"文章图标链接",    
            "dataType":"xxx",
            "videoUrl":"xxxx"
        },
        {
            "id":2,
            "name":"文章名称",
            "brief":"文章简介",
            "content":"文章内容",
            "iconUrl":"文章图标链接",    
            "dataType":"xxx",
            "videoUrl":"xxxx"
        },
        {
            "id":3,
            "name":"文章名称",
            "brief":"文章简介",
            "content":"文章内容",
            "iconUrl":"文章图标链接",    
            "dataType":"xxx",
            "videoUrl":"xxxx"
        }
    ]

}

```

### 创建新文章

POST /api/vrigo/v1/article

### Request

POST /api/vrigo/v1/article

```json

{
    "name":"文章名称",
    "brief":"文章简介",
    "content":"文章内容",
    "iconUrl":"文章图标链接",
    "author":"文章作者"
}

```
### Response

```json
{
    "id":1,
    "name":"文章名称",
    "brief":"文章简介",
    "icon": = 4;
    optional string iconColor = 5;
    optional Result result = 6;
    optional string dataType = 7;
    optional string videoUrl = 8;
}

```


### 对现有接口的影响

虚拟科室所属的所在机构不在C端页面显示，所以在C端显示所有机构的接口中需要将虚拟科室的机构名过滤出来，只显示科室名称而不显示其机构名。
经调研，发现在yolarClient中有一个获取所有organization的接口，所以可能需要改造这个接口，将该接口查出的organization进行过滤。


