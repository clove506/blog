---
title: Tag System 设计草稿
date: 2017-3-29 19:39:00
categories: Tag
tags:
- tag
---

# 摘要

Tag System 设计草稿

<!-- more -->

# 关于

Tag是一个层级结构，希望用 Tag 来满足如下需求

1. 支持自然人模型（层级结构、特定疾病 Tag 下，需要挂对应评估问题组）
2. Tag 需要支持科研、护理路径
3. 和 TriggerEngine 的配合，可以触发动作
4. 支持和文章、工具的关联
5. 权限控制（文章、工具的共享）

# Author

mmliu

# Tag 

## 数据结构
| 字段                          | 释义                                       |
| :-------------------------- | ---------------------------------------- |
| id                          | id                                       |
| name                        | tag 名称                                   |
| type                        | tag 类型，例如：自然人指标、科研、科研分组等等                |
| level                       | 在 tag 树中，本tag所处的层级                       |
| **level1~level15 (prefix)** | 该节点的祖先节点，注：不包括自己                         |
| creator/dpt/org id          | Tag 创建人信息，包括创建人 id、科室和组织id               |
| is_leaf                     | 是否为叶子节点，考虑到我们的疾病树是自己确定好的，所以某个 tag 是否为 leaf，应该由创建方指定，而不是 tag system 根据结构去自己判定。 |
| created_at                  | 创建时间                                     |
| updated_at                  | 更新时间                                     |

很重要的，TagType 穷举如下：

* 自然人指标
* 疾病（隶属于自然人指标）
* 科研
* 科研分组

## 数据实例

**以 科研分组 Tag 为例**，展示了如何通过 Tag，表示名为101的科研下的科研组：Control Group A

| id   | name                         | type              | level | level1              | creator(dpt & org) id | is_leaf | created_at | updated_at |
| ---- | ---------------------------- | ----------------- | ----- | ------------------- | --------------------- | ------- | ---------- | ---------- |
| 2    | 101 Research Control Group A | 2(Research Group) | 2     | 1(101 Research Tag) | 1, 1, 1               | true    | 2017-03-28 | 2017-03-28 |

# Tag Property

可以给 tag 配置属性

## 数据结构

| 字段     | 释义       |
| ------ | -------- |
| id     | id       |
| tag_id | tag 的 id |
| key    | 键        |
| value  | 值        |

##  数据实例

可以给 tag 配置 Property，例如科研分组的名称、执行人等信息，都可以通过 tag 的属性来完成。

| id   | tag_id             | key                          | value                                    |
| ---- | ------------------ | ---------------------------- | ---------------------------------------- |
| 1    | 2（Control Group A） | filter（科研分组 tag 可以使用该属性筛选用户） | {"gender" : 1，"age" : {"get" : 50, "lt" : 80}, "tag" : [1, 3, 5] } |
| 3    | 2（Control Group A） | executor_nurse               | 1 (该分组执行护士)                              |
| 4    | 2（Control Group A） | name                         | 糖尿病 II 型-对照组 A                           |
| 5    | 2（Control Group A） | short_name                   | A                                        |
| 6    | 2（Control Group A） | max_size                     | 98（对照组的目标人数）                             |

#  Tag 支持的操作

1. 查询 tag 本身，根据 tag name 和 tag type
2. 查询给定 tag 下，所有的叶子节点
3. 删除 tag。只支持叶子 tag 的删除，tag 删除后，将取消与该 tag 的关联
4. 添加 tag。特别的，需要考虑给叶子节点添加子节点的情况（支持？）

**考虑，是否只能使用叶子 tag？**

# 添加和 Tag 的关联

Table: TagToObject

| 字段                 | 释义                                       |
| ------------------ | ---------------------------------------- |
| id                 | id                                       |
| tag_id             | tag id                                   |
| tag_type           | tag 类型                                   |
| **object_id**      | 对象 id                                    |
| object_type        | 对象的类型：article、tool、person etc            |
| ~~object_dpt_id~~  | ~~对象所属的科室（如果有的话）~~                       |
| ~~object_org_id~~  | ~~对象所属的组织（如果有的话）~~                       |
| ~~**creator_id**~~ | ~~关联人~~                                  |
| ~~creator_type~~   | ~~关联人类型~~                                |
| **mapping_type**   | 该关联的类型，包括：user_faved_disease、user_tag、nurse_tag、dpt_disease、etc |
| creator_dpt_id     | 此关联所属科室                                  |
| creator_org_id     | 此关联所属组织                                  |

支持的 object_type : 文章、工具、人。

除了 Tag 之外，我们还记录了此关联所属的科室和组织，用于需要按科室或组织查看时，做筛选之用。例如，我们想要查看 309科室中，所有被打上了糖尿病I型标签的患者们，则需要通过：309科室的 dptID、糖尿病I型的tag_id 以及患者的 object_type，来获取所需结果。

同时，注意我们还添加了 mapping_type 字段，来记录该 mapping 的类型，例如一个用户（object）被加上了糖尿病标签（tag），仅凭此我们无法判断这是用户主动关注了疾病，还是被大夫打上了疾病标签。所以需要添加 mapping_type 字段，来区分场景。

# Tag 和动作的关联

Tag 是静态的，通过 Trigger System 可以配置指定 tag 可以触发特定动作。

Trigger System 由触发条件和动作执行构成。 详见 [Trigger System 设计草稿](http://wiki.office.test.youhujia.com/2017/03/29/pull-the-trigger/)

# Tag 和 自然人模型 的关联

自然人模型通过 Tag 来构成，例如：

![自然人模型](https://ww4.sinaimg.cn/large/006tKfTcly1fe3kckvuyfj30dy2ax0wh.jpg)

其中的**姓名**指标，可以用 Tag 表示如下：

| id   | name | type            | level | level1 | level 2 | creator(dpt & org) id | is_leaf | created_at | updated_at |
| ---- | ---- | --------------- | ----- | ------ | ------- | --------------------- | ------- | ---------- | ---------- |
| 3    | 评估   | 3（HumanMetrics） | 1     | null   | null    | 1，1，1                 | false   | 2017-03-28 | 2017-03-28 |
| 4    | 一般资料 | 3（HumanMetrics） | 2     | 3（评估）  | null    | 1，1，1                 | false   | 2017-03-29 | 2017-03-29 |
| 5    | 姓名   | 3（HumanMetrics） | 3     | 3      | 4       | 1，1，1                 | true    | 2017-03-29 | 2017-03-29 |

以上，表示了 【评估 -》一般资料 -》姓名】的层级关系。

叶子 Tag 节点：**姓名**上，可以通过 Tag Property，配置 yhj_human_metric_code 等等：

| id   | tag_id | key                   | value  |
| ---- | ------ | --------------------- | ------ |
| 11   | 5      | yhj_human_metric_code | YHJ001 |

也可以给该 tag 节点关联 评估问题、文章：

| id   | tag_id | tag_type        | object_id | object_type | obj_dpt/org id | creator_id | creator_type | creator_dpt/org id |
| ---- | ------ | --------------- | --------- | ----------- | -------------- | ---------- | ------------ | ------------------ |
| 1    | 5      | 1(HumanMetrics) | 101       | 1 (tool)    | 1/1            | null       | null         | null               |
| 2    | 5      | 1(HumanMetrics) | 102       | 1 (tool)    | 1/1            | null       | null         | null               |
| 3    | 5      | 1(HumanMetrics) | 780001    | 2 (article) | 1/1            | null       | null         | null               |

以上表示了，**姓名** Tag 被关联了两个评估工具、一篇文章。

## 文章 & 工具
以上，通过 Table: Tag2Object，可以将文章和工具关联上 Tag。

1. 给文章添加 tag
2. 查找文章的 tag
3. 通过 tag 查找关联的文章

*todo* 选择新文章的共享权限（独享、授权共享、全网共享）

# Tag 和 科研模型 的关联

我们的科研主要为两层结构：科研及其分组信息，分组下面还可以包含分组，这种结构可以用我们的 Tag 来表示。

 以下表示了一个科研及其下面的分组： 控制组 A

| id   | name                         | type                  | level | level1              | creator(dpt & org) id | is_leaf | created_at | updated_at |
| ---- | ---------------------------- | --------------------- | ----- | ------------------- | --------------------- | ------- | ---------- | ---------- |
| 1    | 101 Research                 | 1(Research Tag)       | 1     | null                | 1,1,1                 | false   | 2017-03-28 | 2017-03-28 |
| 2    | 101 Research Control Group A | 2(Research Group Tag) | 2     | 1(101 Research Tag) | 1, 1, 1               | true    | 2017-03-28 | 2017-03-28 |

科研及其组下的相关信息通过 Tag Properties 配置：

| id   | tag_id  | key                          | value                                    |
| ---- | ------- | ---------------------------- | ---------------------------------------- |
| 11   | 1（科研）   | name                         | xx 医院关于 yy 的特定研究                         |
| 1    | 2（科研分组） | filter（科研分组 tag 可以使用该属性筛选用户） | {"gender" : 1，"age" : {"get" : 50, "lt" : 80}, "tag" : [1, 3, 5] } |
| 3    | 2       | executor_nurse               | 1 (该分组执行护士)                              |
| 4    | 2       | name                         | 糖尿病 II 型-对照组 A                           |
| 5    | 2       | short_name                   | A                                        |
| 6    | 2       | max_size                     | 98（对照组的目标人数）                             |

除了上述静态信息外，很重要的，在科研中，我们需要对患者执行操作，例如：对 **101 Research Control Group A **中的患者执行一整套的护理操作：第一天发送文章推送，第七天做回访调查，第十四天发送评估工具，etc。

这套操作是通过另外一个系统：Trigger System 完成的。

首先，我们配置好动作：

- 当前，推送文章：糖尿病足护理指南。
- 七天后，发送 回访调查。
- 第十四天之后，发送评估工具。

之后，在 Trigger System 中配置以上动作的触发条件：用户被加入 **101 Research Control Group A** 中（即打上 Group A 的 tag 之后）。

这样，当用户被加入科研组 **101 Research Control Group A** 后，除了执行打 Tag 的操作，还将告知 Trigger System。在收到该消息后，Trigger System 将检查是否有以该 Tag 为触发条件的 ActionList。如果有，则触发该动作List。

按照上面的示例，会将上述三个动作分别按时间注册到延时消息队列中，分别在当前、七天后、十四天后对动作进行执行。

# Tag 和 护理路径 的关联

对于特定病患，我们需要沉淀特定的护理路径：一套设定好的动作流程。

例如，在患者被标记为糖尿病 I 型后，执行一系列的预设动作：定时发文章，定时发评估。其中，执行的动作可能产生分支：不同的评估结果，引发不同的后续动作。例如糖尿病 I 型这个 Tag，科室可以配置动作，如发送评估，而评估的结果可以设置后续：轻症则后续发送宣教，重症则需三天后发起回访，并在一周后发起再次评估。

护理路径的最小单元：【 Tag -》 动作】，这些都可以通过上述的 Trigger System 完成。

# Ref Link

- [Trigger System](http://wiki.office.test.youhujia.com/2017/03/29/pull-the-trigger/)
- [自然人数据抽取](http://wiki.office.test.youhujia.com/2017/03/25/natural_person_design/)
- [Tag System API](http://wiki.office.test.youhujia.com/2017/04/06/tag-is-everything-api/)
- Tag 具体到各个业务系统的实现(todo)


# API
### 详见：http://wiki.office.test.youhujia.com/2017/04/06/tag-is-everything-api/
## Tag

**POST /api/tag/v1/tag**

```json
//创建 科研 node
{
  "name"  : "101青光眼研究",
  "type"  : 2,
  "level" : 1,

  "creatorId" : 20,
  "creatorType" : 1,
  "creatorDptId" : 309,
  "creatorOrgId" : 1
}

//创建 科研对照组 node
{
  "name"  : "101青光眼研究,对照组 A",
  "type"  : 3,
  "level" : 2,
  "level1" : 1,

  "creatorId" : 20,
  "creatorType" : 1,
  "creatorDptId" : 309,
  "creatorOrgId" : 1
}

//创建疾病树上的 node
{
  "name"  : "疾病树-糖尿病 I 型",
  "type"  : 2, //疾病树
  "level" : 3,

  "parentId" : 2,//指定父节点即可

  "creatorId" : 20,
  "creatorType" : 2 //admin
}
```

**PATCH /api/tag/v1/tag**

```json
{
  "id" : 1,
  "name"  : "202青光眼研究",
}
```

**DELETE /api/tag/v1/tag/1**

Response:

```json
{
  "result" : {
    "success" : true,
    "code" : 1
  }
}

{
  "result" : {
    "success" : false,
    "code" : 0,
    "msg" : "can only delete leaf tag"
  }
}
```

**GET /api/tag/v1/tag/1/leaves**

Response:

```json
  {
    "result" : {}
    "tag" : {
      {}, {}
    }
  }
```

**GET /api/tag/v1/tag?tagId={}&tagType={}&creatorId={}&departmentId={}&orgId={}**

Response:

```json
  {
    "result" : {}
    "tag" : {
      {}, {}
    }
  }
```

**GET /api/tag/v1/tag/{tagId}/tag-properties**

Response:

```json
{
  "tagId" : 123,
  "tagProperties" : [
    {
      "key" : "HumanMetricCode",
      "value" : "YHJ.AA.100.456"
    }
  ]
}
```

**GET /api/tag/v1/{tagId}/tag2object?objectType={}**

获取指定 tag 下，关联的 object 信息，支持指定 objectType。

Response:

```json
{
  "tagId" : 1,
  "tag2object" : [
    {
      "objectId" : 1,
      "objectType" : 1
    },{ 
    }
  ]
}
```

##  TagProperty

**GET /api/tag/v1/tag-property/{id}**

```json
{
  "id" : 1,
  "tagId" : 1,
  "key" : "HumanMetricCode",
  "value" : "YHJ.AA.100.123"
}
```

**POST /api/tag/v1/tag-property**

```json
{
  "tagId" : 2,
  "key" : "HumanMetricCode",
  "value" : "YHJ.AA.100.456"
}
```

**PATCH /api/tag/v1/tag-property**

```json
{
  "tagId" : 2,
  "key" : "HumanMetricCode",
  "value" : "YHJ.AA.100.246"
}
```

**DELETE /api/tag/v1/tag-property/{id}**

Response:

```json
{
  "result" : {"success" : true}
}
```

## Tag2Object

**POST /api/tag/v1/tag-2-object**

```json
{
  "tagId" : 1,
  "objectId" : 101,
  "objectType" : 1, //article
  "creatorId" : 1,
  "creatorType" : 1, //nurse
  "creatorDptId" : 309, 
  "creatorOrgId" : 1
}
```

**DELETE /api/tag/v1/tag-2-object/{id-of-tag2object}**

```json
{
  "result" : {"success" : true}
}
```

# Code

```
  com.youhujia.tag
    domain
      tag
        TagController
          |=> public TagDTO createTag(TagOpt tagOpt);
          |=> public TagDTO updateTag(TagOpt tagOpt);
          |=> public SimpleResponse deleteTag(long tagId);
          |=> public List<TagDTO> getLeavesOfTag(long tagId);
          |=> public List<TagDTO> query(Map<String, String> queryMap);
        TagBO
          public TagDTO createTag(TagOpt tagOpt);
          public TagDTO updateTag(TagOpt tagOpt);
          public SimpleResponse deleteTag(TagOpt tagOpt);
          public List<TagDTO> getLeavesTag(long tagId);
          public List<TagDTO> query(Map<String, String> queryMap);
        TagDAO
        create
          CreateBO
          CreateContext
          CreateContextFactory
        query
          QueryBO
          QueryContext
          QueryContextFactory
        update
          UpdateBO
          UpdateContext
          UpdateContextFactory

      tag2obj
        Tag2ObjController
          |=> public Tag2ObjDTO create(Tag2ObjOpt tag2objOpt)
          |=> public Tag2ObjDTO delete(long id)
          |=> public Tag2ObjListDTO query(Map<String, String> map)
        Tag2ObjBO
        Tag2ObjDAO
        create
        delete
        query

      tagProperty
        TagPropertyController
          |=> public TagPropertyDTO addProperty(long tagId, String key, String value);
          |=> public TagPropertiesDTO getPropertiesOfTag(long tagId);
        TagPropertyBO
        TagPropertyDAO
        create
        get


    Notes:
      TagController.query() 中，queryMap 支持的查询参数：
        tagId
        tagType
        creatorId
        departmentId
        orgId

      Tag2ObjController.query() 中，支持的参数：
        tagId
        objectType
        creatorDptId
        mappingType
```

# Protobuf Msg

```protobuf

message TagOption{
  optional int64  id = 1;
  optional string name = 2;
  optional int32  type = 3;
  optional int32  level = 4;
  optional int64  level1 = 5;
  optional int64  level2 = 6;
  optional int64  level3 = 7;
  optional int64  level4 = 8;
  optional int64  level5 = 9;
  optional int64  level6 = 10;
  optional int64  level7 = 11;
  optional int64  level8 = 12;
  optional int64  level9 = 13;
  optional int64  level10 = 14;
  optional int64  level11 = 15;
  optional int64  level12 = 16;
  optional int64  level13 = 17;
  optional int64  level14 = 18;
  optional int64  level15 = 19;
  optional int64  creatorId = 20;
  optional int64  dptId = 21;
  optional int64  orgId = 22;
  optional bool   isLeaf = 23;
  optional int64  createdAt = 24;
  optional int64  updatedAt = 25;
}

message TagDTO{
  optional Result result = 1;
  optional TagData data = 2;
}

message TagData{
  optional Tag tag = 1;
}

message TagListDTO{
  optional Result result = 1;
  optional TagListData data = 2;
}

message TagListData{
  repeated Tag tags = 1;
}

message Tag{
  optional int64  id = 1;
  optional string name = 2;
  optional int32  type = 3;
  optional int32  level = 4;
  optional int64  level1 = 5;
  optional int64  level2 = 6;
  optional int64  level3 = 7;
  optional int64  level4 = 8;
  optional int64  level5 = 9;
  optional int64  level6 = 10;
  optional int64  level7 = 11;
  optional int64  level8 = 12;
  optional int64  level9 = 13;
  optional int64  level10 = 14;
  optional int64  level11 = 15;
  optional int64  level12 = 16;
  optional int64  level13 = 17;
  optional int64  level14 = 18;
  optional int64  level15 = 19;
  optional int64  creatorId = 20;
  optional int64  dptId = 21;
  optional int64  orgId = 22;
  optional bool   isLeaf = 23;
  optional int64  createdAt = 24;
  optional int64  updatedAt = 25;
}


message TagPropertyOption{
  optional int64 id = 1;
  optional int64 tagId = 2;
  optional string key = 3;
  optional string value = 4;
}

message TagPropertiesOption{
  repeated TagPropertyOption properties = 1;
}

message TagProperty{
  optional int64 id = 1;
  optional int64 tagId = 2;
  optional string key = 3;
  optional string value = 4;
}

message TagPropertyData{
  optional TagProperty property = 1;
}

message TagPropertyDTO{
  optional Result result = 1;
  optional TagPropertyData data = 2;
}

message TagPropertiesData{
  repeated TagProperty properties = 1;
}

message TagPropertiesDTO{
  optional Result result = 1;
  optional TagPropertiesData data = 2;
}


message TagToObjectOption{
  optional int64 id = 1;
  optional int64 tagId = 2;
  optional int32 tagType = 3;
  optional int64 objectId = 4;
  optional int32 objectType = 5;
  optional int32 mappingType = 6;
  optional int64 creatorDptId = 7;
  optional int64 creatorOrgId = 8;
}

message TagToObject{
  optional int64 id = 1;
  optional int64 tagId = 2;
  optional int32 tagType = 3;
  optional int64 objectId = 4;
  optional int32 objectType = 5;
  optional int32 mappingType = 6;
  optional int64 creatorDptId = 7;
  optional int64 creatorOrgId = 8;
}

message TagToObjectData{
  optional TagToObject tag2Object = 1;
}

message TagToObjectDTO{
  optional Result result = 1;
  optional TagToObjectData data = 2;
}

message TagToObjectsData{
  repeated TagToObject tag2Objects = 1;
}

message TagToObjectsDTO{
  optional Result result = 1;
  optional TagToObjectsData data = 2;
}
```

# Table

```sql

-- tag
CREATE TABLE `tag` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL COMMENT 'name of tag\n',
  `type` INT NOT NULL COMMENT 'type of tag, 1: human-metrics, 2: disease, 3: research, 4: research group, etc.',
  `level` INT NOT NULL COMMENT 'level of this tag node',
  `level1` BIGINT NULL COMMENT 'id of ancestor node at level 1 (if exist)',
  `level2` BIGINT NULL COMMENT 'id of ancestor node at level 2 (if exist)',
  `level3` BIGINT NULL COMMENT 'id of ancestor node at level 3 (if exist)',
  `level4` BIGINT NULL,
  `level5` BIGINT NULL,
  `level6` BIGINT NULL,
  `level7` BIGINT NULL,
  `level8` BIGINT NULL,
  `level9` BIGINT NULL,
  `level10` BIGINT NULL,
  `level11` BIGINT NULL,
  `level12` BIGINT NULL,
  `level13` BIGINT NULL,
  `level14` BIGINT NULL,
  `level15` BIGINT NULL COMMENT 'id of ancestor node at level 15 (if exist)',
  `creator_id` BIGINT NOT NULL COMMENT 'id of this tag’s creator',
  `creator_dpt_id` BIGINT NULL COMMENT 'department id of this tag’s creator(for YHJ, it’s null)',
  `creator_org_id` BIGINT NULL COMMENT 'orgnization id of this tag’s creator(for YHJ, it’s null)',
  `is_leaf` TINYINT NOT NULL COMMENT 'whether this node is a leaf',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));

-- tag_property
CREATE TABLE `tag_property` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `tag_id` BIGINT NOT NULL COMMENT 'id of tag',
  `key` VARCHAR(128) NOT NULL COMMENT 'key of given tag',
  `value` VARCHAR(2048) NOT NULL COMMENT 'value of key',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));

-- tag_2_object
CREATE TABLE `tag_2_object` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `tag_id` BIGINT UNSIGNED NOT NULL COMMENT 'id of tag',
  `tag_type` INT NOT NULL COMMENT 'type of tag, check Table: Tag for all types.',
  `object_id` BIGINT NOT NULL COMMENT 'id of object that associated to this tag',
  `object_type` INT NOT NULL COMMENT 'type of this object',
  `mapping_type` INT NOT NULL COMMENT 'type of this mapping',
  `creator_dpt_id` BIGINT NULL COMMENT 'dpt of this object (null if not belong to any dpt)',
  `creator_org_id` BIGINT NULL COMMENT 'org of this object (null if not belong to any org)',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));
```

# todo

- Tag 有些是全局的，有些是科室私有的，需要区分

