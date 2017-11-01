---
title: 自然人模型管理后台设计
date: 2017-03-25 23:00:00
categories: C++
tags:
- 优护助手
---


# 摘要

自然人模型后台管理系统详细设计

<!--more-->

## WIKI维护人

黄英

## 概述

什么是自然人，百度上给出的解释是：自然人（natural person） 是在自然状态下出生的人。是不是感觉说了和没说没区别。那我们这个这次项目所需要设计的自然人模型又是什么呢？首先说一下我们这个自然人是针对优护家的患者，而自然人模型则是自然人的我们所需的病人所有信息数据的集合，是基于数据战略沉淀的一套用来多角度描述患者的数据模型。设计用户的内容也不只是简单的姓名、性别等这些基本信息，而是包括病人的身体健康情况、疾病历史、出入院信息以及科研信息等这些由患者身体将康以及所衍生出来的信息。


## 自然人模型

自然人模型个人理解即为自然人信息数据模型，而自然人的数据模型可以将其看成一个信息树，一个患者可以看成是一棵树，而他的信息可以看成是树叶，一片树叶是一个人的某个特定的信息，每个人的信息具体数值可能都有不同，但是叶子的信息指的是什么这是一定的。例如，这片叶子代表的是身高，那么每个人的这片叶子都是身高，但是身高是多少，则根据每个人的具体值而定。而这个每一片叶子代表什么也需要我们去定义，具体如何定义的参见如下

结构定义如下图

![](/media/自然人结构图.png)

而这些标准都是需要存入数据中，具体存入结构如何，参见下面**数据库设计df_metadata表**

## 数据库设计

由上面的描述我们知道了自然人的数据的节点的定义需要落地到数据库中，这些定义数据则是为元数据，那么存储数据的表则叫元数据表

### 元数据表：df_metadata

| 字段 | 类型 | 备注 |
| --- | --- | --- |
| id |long | 唯一标志 |
| code | string | 优护家唯一编码 |
| name | string | 元数据名称 |
| description | string | 元数据描述 |
| data_type | long | 数据项数据类型:枚举值，具体代表含义 1. string 2. int 3. float 4. bool 5. unary 6. date |
| expiration | long | 数据项数据失效时间，是一个相对时间，相对于df_data_item.generated_at
（数据真实产生时间），单位，毫秒 |
| standard_display_format | string | 数据项数据标准显示格式  |
| standard_unit | string | 数据项数据标准单位（如kg、g等） |
| standard_mapping |string | 元数据和其他国际标准对应的编码 json 格式 例如： {"icd-10":"A03-1"} | 
| created_at | date | 创建时间 |
| updated_at | date | 修改时间 |

### 建表语句

```
CREATE TABLE `df_metadata`(
  `id` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '元数据主键',
  `code` VARCHAR(255) NOT NULL unique COMMENT '优护家元数据唯一编码',
  `name` VARCHAR(512) COMMENT '元数据名称',
  `description` TEXT COMMENT '元数据描述',
  `data_type` BIGINT(20) COMMENT '数据项数据类型',
  `expiration` BIGINT(20) COMMENT '数据项数据失效时间，是一个相对时间，相对于df_data_item.generated_at
（数据真实产生时间），单位，毫秒',
  `standard_display_format` VARCHAR(255) COMMENT '数据项数据标准显示格式',
  `standard_unit` VARCHAR(255) COMMENT '数据项数据标准单位（如kg、g等）',
  `standard_mapping` VARCHAR(512) COMMENT '元数据和其他国际标准对应的编码 json 格式 例如： {"icd-10":"A03-1"}',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `df_code_index` (`code`),
  KEY `df_name_index` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```

### 元数据数据落地：

1. 优护家元数据唯一code编码确定：
一级：YHJ、
二级：YHJ.AA——YHJ.ZZ、
三级：YHJ.AA.001——YHJ.ZZ.999、
四级：YHJ.AA.001.001——YHJ.ZZ.999.999、
.....
十级：YHJ.AA.001.001.001.001.001.001.001.001——YHJ.ZZ.999.999.999.999.999.999.999.999
    
2. 需要整理自然人的所有数据，以及入库。

数据库数据示例：

![](/media/元数据数据库实例数据.png)



### 自然人数据项： df_data_item


自然人的数据：由自然人的唯一标志符和数据项的集合组成，唯一标志符即下面的user_id，一个user_id会对应多条数据项


| 字段 | 类型 | 描述 |
| --- | --- | --- |
| id | long | 该条数据的唯一标志  |
| user_id | long | 自然人的id  |
| df_metadata_code | string | 元数据编码 |
| value | string | 具体的值，应该是经过序列化的 |
| is_valid |bit | 默认为1，为有效 |
| provider | long | 数据收集方 |
| collecting_method | long | 数据收集方法 |
| collector | long | 数据收集器 |
| generated_at | timeStamp | 数据真实产生的时间 |
| collected_at | timeStamp | 收集器收集数据时间 |
| created_at | timeStamp | 入库时间 |
| updated_at | timeStamp | 修改时间 |

#### 建表语句


```
CREATE TABLE `df_data_item`(
  `id` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '数据项主键',
  `user_id` BIGINT(20) UNSIGNED NOT NULL COMMENT '数据项主键',
  `df_metadata_code` VARCHAR(255) NOT NULL COMMENT '元数据编码',
  `value` TEXT COMMENT '具体的值，可能是经过序列化的',
  `is_valid` BIT DEFAULT 1 COMMENT '默认为1，有效',
  `provider` BIGINT(20) NOT NULL COMMENT '数据收集方',
  `collecting_method` BIGINT(20)  NOT NULL COMMENT '数据收集方法',
  `collector` BIGINT(20) NOT NULL COMMENT '数据收集器',
  `generated_at` TIMESTAMP  DEFAULT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '数据真实产生时间',
  `collected_at` TIMESTAMP DEFAULT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '收集器时间',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `df_data_item_df_metadata_code_index` (`df_metadata_code`),
  KEY `df_data_item_provider_index` (`provider`),
  KEY `df_data_item_collecting_method_index` (`collecting_method`),
  KEY `df_data_item_collector_index` (`collector`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

```


#### 字段补充说明：

**provider:**

数据的提供方，现在已知的枚举如下，

```
public enum ProviderEnum {
    OTHER(1,"其他"),
    YHJ(2,"优护家"),
    WN(3,"卫宁");
 }
```

**collecting_method:**

数据的收集方法

```
public enum CollectingMethodEnum {
    OTHER(1, "其他"),
    SYSTEM(2, "系统录入"),
    EVALUATION(3,"评估"),
    SELF_ASSESSMENT(4,"自测"),
}
```
**collector:**

数据的收集器

```
public enum CollectorEnum {
    OTHER(1,"其他"),
    YHJ_C_TERMINAL(2,"优护C端"),
    YHJ_APP(3,"优护助手"),
    ML_BRACELET(4,"小米手环"),
    BLOOD_PRESSURE_MONITOR(5,"血压计");
    
    }
```




### 接口设计

作为service层，主要是提供CRUD操作，由于元数据基本是直接写入数据库中，而且一旦确定，基本变动久很小，所以只有提供查询接口。而针对于数据项来说，一旦数据落入库中，现定的是就不会更改删除，所以也只提供增加查询接口。


#### 创建单个数据项

> POST /api/human/v1/data-items/create-data-item

**request:**


```
{
"userId": 1,
"dfMetadataCode": "YHJAA.001.001",
"dfDataItemValue": "路过",
"provider": 1,
"collecting_method": 1,
"collector": 1,
"generatedAt": "1491041660000",
"collectedAt": "1491041660000" 
}
```

**response:**

```
{
"result":{
    "code": 0,
    "success": true
    }
"dataItemId": 1,
"userId": 10086,
"metadataCode": "YHJAA.001.001",
"value": "路过",
"provider": 1,
"collecting_method": 1,
"collector": 1,
"generatedAt": "1491041660000",
"collectedAt": "1491041660000" 
}
```

#### 创建多个数据项

> POST /api/human/v1/data-items/create-data-items

**request:**

```
{
    "CreateDataItemOptionList": [
        {
            "userId": 1,
            "dfMetadataCode": "YHJAA.001.001",
            "dfDataItemValue": "路过",
            "provider": 1,
            "collecting_method": 1,
            "collector": 1,
            "generatedAt": "1491041660000",
            "collectedAt": "1491041660000"
        }
    ]
}

```

**response:**

```
{
    "result": {
        "code": 0,
        "success": true
    },
    "dataItemDTO": [
        {
            "dataItemId": 1,
            "userId": 10086,
            "metadataCode": "YHJAA.001.001",
            "value": "路过",
            "provider": 1,
            "collecting_method": 1,
            "collector": 1,
            "generatedAt": "1491041660000",
            "collectedAt": "1491041660000"
        }
    ]
}
```

#### 创建单个自然人数据项集聚合接口

> POST /api/human/v1/data-items/create-user-data-items

每一次数据的沉淀，都会存入多个数据项的值，例如有姓名、性别、年龄等一些项，将姓名姓名、性别、年龄等在df_metadata表中的对应的code值填充入参的dfMetadataCode字段，姓名、性别、年龄等对应的值填充到dfDataItemValue字段

**request:**

```
{
    "metadataCodeValuePair": [
        {
            "dfMetadataCode": "YHJAA.001.001",
            "dfDataItemValue": "路过"
        }
    ],
    "userId": 1,
    "provider": 1,
    "collecting_method": 1,
    "collector": 1,
    "generatedAt": "1491041660000",
    "collectedAt": "1491041660000"
}

```

**response:**

```
{
    "result": {
        "code": 0,
        "success": true
    },
    "dataItemDTO": [
        {
            "dataItemId": 1,
            "userId": 10086,
            "metadataCode": "YHJAA.001.001",
            "value": "路过",
            "provider": 1,
            "collecting_method": 1,
            "collector": 1,
            "generatedAt": "1491041660000",
            "collectedAt": "1491041660000"
        }
    ]
}
```

#### 通过id查询

> GET /api/human/v1/data-items/{id}

**response：**

```
{
    "result": {
        "code": 0,
        "success": true
    },
    "dataItemDTO": {
        "dataItemId": 1,
        "userId": 10086,
        "metadataCode": "YHJAA.001.001",
        "value": "路过",
        "provider": 1,
        "collecting_method": 1,
        "collector": 1,
        "generatedAt": "1491041660000",
        "collectedAt": "1491041660000"
    }
}
```

#### 组合查询

> GET /api/human/v1/data-items/query

**request：**

备注：query查询参数支持：metadataIds、metadataCodes、user_id、provider、collecting_method、collector,参数任意组合。
    metadataIds：即为将一系列的dfMetadata表的id通过逗号拼装为一个新的string
    

``` 
public enum DataItemQueryEnum {
    metadataID("metadataId", "选添项，元数据的id，多个imetadataIdd可以通过逗号隔开例如 1,2,3"),
    USER_ID("userId", "选添项,用户的id"),
    PROVIDER("provider", "选添项，数据的提供方,参见com.youhujia.halo.nightwatch.provider"),
    COLLECTING_METHOD("collectingMethod", "选添项，数据的收集方法参见com.youhujia.halo.nightwatch.collectingMethod"),
    COLLECTOR("collector", "选添项，数据的收集器，参见com.youhujia.halo.nightwatch.collectorEnum");
}
```

**response：**

```
{
    "result": {
        "code": 0,
        "success": true
    },
    "dataItemDTO": [
        {
            "dataItemId": 1,
            "userId": 10086,
            "metadataCode": "YHJAA.001.001",
            "value": "路过",
            "provider": 1,
            "collecting_method": 1,
            "collector": 1,
            "generatedAt": "1491041660000",
            "collectedAt": "1491041660000"
        }
    ]
}
```

#### 通过ids获取元数据

> GET /api/human/v1/metadata/{id}

**request:**

可以是单个id，也可以是多个id通过逗号隔开，

**response：**

```
{
    "result": {
        "code": 0,
        "success": true
    },
    "metadataDTO": [
        {
            "metadataId": 1,
            "code": "YHJAA.001.001",
            "name": "姓名",
            "description": "个体在公安管理部门正式登记注册的姓氏和名称",
            "dataType": 1,
            "expiration": "180000",
            "standardDisplayFormat": ""
        }
    ]
}
```

#### 通过codes 获取元数据

> GET /api/human/v1/metadata/{codes}

**request:**

可以是单个code，也可以是多个code通过逗号隔开，

**response：**

```
{
    "result": {
        "code": 0,
        "success": true
    },
    "metadataDTO": [
        {
            "metadataId": 1,
            "code": "YHJAA.001.001",
            "name": "姓名",
            "description": "个体在公安管理部门正式登记注册的姓氏和名称",
            "dataType": 1,
            "expiration": "180000",
            "standardDisplayFormat": ""
        }
    ]
}
```

#### 通过元数据name获取元数据

> GET /api/human/v1/metadata/name/{name}

**response：**

```
{
    "result": {
        "code": 0,
        "success": true
    },
    "metadataId": 1,
    "code": "YHJAA.001.001",
    "name": "姓名",
    "description": "个体在公安管理部门正式登记注册的姓氏和名称",
    "dataType": 1,
    "expiration": "180000",
    "standardDisplayFormat": ""
}
```

### 结构代码

```
    com.youhujia.human
        domain
            dataItem
                DataItemController
                    |=> public DataItemDTO createDataItem(CreateDataItemOption body);
                    |=> public DataItemDTOList createDataItemList(CreateDataItemOptionList body);
                    |=> public DataItemDTOList createUserDataItems(CreateUserDataItemOption body);
                    |=> public DataItemDTO getDataItemById(Long id);
                    |=> public DataItemList query(Map<String, String> queryMap);
                DataItemBO
                    public DataItemDTO createDataItem(CreateDataItemOption body);
                    public DataItemDTOList createDataItemList(CreateDataItemOptionList body);
                    public DataItemDTOList createUserDataItems(CreateUserDataItemOption body);
                    public DataItemDTO getDataItemById(Long id);
                    public DataItemList query(Map<String, String> queryMap);
                DataItem
                DataItemDao
                create
                    CreateBO
                    CreateContext
                    CreateContextFactory
                query
                    QueryBO
                    QueryContext
                    QueryContextFactory
            metadata
                MetadataController
                    |=> public metadataDTO getMetadataById(Long id);
                    |=> public metadataDTO getMetadataByCode(string code);
                    |=> public metadataDTO getMetadataByName(string name);
                Metadata
                MetadataBO
                    public metadataDTO getMetadataById(Long id);
                    public metadataDTO getMetadataByCode(string code);
                    public metadataDTO getMetadataByName(string name);
                MetadataDao
                query
                    QueryBO
                    QueryContext
                    QueryContextFactory
                                        
```

#### proto


```
message DataItemDTO {
    optional Result result = 1;

    optional int64 dataItemId = 2;
    optional int64 userId = 3;
    optional string metadataCode = 4;
    optional string value = 5;
    optional int64 provider = 6;
    optional int64 collecting_method = 7;
    optional int64 collector = 8;
    optional int64 generatedAt = 9;
    optional int64 collectedAt = 10;
}

message DataItemDTOList {
    optional Result result = 1;
    repeated DataItemDTO dataItem = 2;
}

message CreateDataItemOption {
    optional int64 userId = 1;
    optional string dfMetadataCode = 2;
    optional string dfDataItemValue = 3;
    optional int64 provider = 4;
    optional int64 collecting_method = 5;
    optional int64 collector = 6;
    optional int64 generatedAt = 7;
    optional int64 collectedAt = 8;
}

message CreateDataItemOptionList {
    repeated CreateDataItemOption createDataItem = 1;
}

message CreateUserDataItemOption {
    repeated MetadataCodeValuePair pair = 1;
    optional int64 userId = 2;
    optional int64 provider = 3;
    optional int64 collecting_method = 4;
    optional int64 collector = 5;
    optional int64 generatedAt = 6;
    optional int64 collectedAt = 7;
}

message MetadataCodeValuePair {
    optional string dfMetadataCode = 1;
    optional string dfDataItemValue = 2;
}

message MetadataDTO {
    optional Result result = 1;
    optional int64 metadataId = 2;
    optional string code = 3;
    optional string name = 4;
    optional string description = 5;
    optional int64 dataType = 6;
    optional string expiration = 7;
    optional string standardDisplayFormat = 8;
}

message MetadataDTOList{
    optional Result result = 1;
    repeated MetadataDTO metadataDTO = 2;
}
```


