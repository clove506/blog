---
title: Tag System API
date: 2017-4-6 14:00:00
categories: Tag
tags:
  - Tag
---

# 摘要

Tag System API

<!-- more -->

# 参考
http://wiki.office.test.youhujia.com/2017/03/29/tag-is-everything/

# Tag相关
## 创建一个tag
**POST /api/hd-fragments/v1/tags**

Request:

```protobuf
//如果没有可以不传对应的字段
message TagOption{
  optional int64 id = 1;
  optional string name = 2;
  optional int32  type = 3;//1:自然人指标；2：疾病（隶属于自然人指标）；3：科研；4：科研分组；5：护士创建标记标签；6：UI view；7：护理路径
  optional int32  level = 4;//tag当前的层级
  //1~15描述了此tag的先祖路径
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

```


Response:

```protobuf

message TagDTO{
  optional Result result = 1;
  optional TagData data = 2;
}

message TagData{
  optional Tag tag = 1;
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

```

## 修改一个tag
**PATCH /api/hd-fragments/v1/tags/{tagId}**

Request:

```protobuf
//如果没有可以不传对应的字段
message TagOption{
  optional int64 id = 1;
  optional string name = 2;
  optional int32  type = 3;//1:自然人指标；2：疾病（隶属于自然人指标）；3：科研；4：科研分组；5：自定义
  optional int32  level = 4;//tag当前的层级
  //1~15描述了此tag的先祖路径
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

```


Response:

```protobuf

message TagDTO{
  optional Result result = 1;
  optional TagData data = 2;
}

message TagData{
  optional Tag tag = 1;
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

```

## 删除一个tag
**DELETE /api/hd-fragments/v1/tags/{tagId}**

Response:

```protobuf

message TagDTO{
  optional Result result = 1;
  //删除不会有这部分数据，会返回一个只有Result的TagDTO  
  optional TagData data = 2;
}

message TagData{
  optional Tag tag = 1;
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

```

## 根据tagId查询tag
**GET /api/hd-fragments/v1/tags/{tagId}**

Response:

```protobuf

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

```


## 查询一个tag下面的所有子孙节点
**GET /api/hd-fragments/v1/tags/{tagId}/children**

Response:

```protobuf

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

```

## 查询一个tagId下面一层的所有节点
**GET /api/hd-fragments/v1/tags/{tagId}/daughter**

Response:

```protobuf

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

```


## 条件查询tag（所有的参数都非必填项）
**GET /api/hd-fragments/v1/tags?tagIds={tagIds}&tagType={tagType}&creatorId={creatorId}&departmentId={departmentId}&orgId={orgId}**

### tagid可以为单独的一个——例如1；
### 也可以为使用，分隔开的多个tagid，如：1，2，3，4

Response:

```protobuf

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

```

## 疾病树静态资源自动建议(to cheeck)
**GET /api/hd-fragments/v1/tags/ac?prefix={prefix}&ancesterIds={ancesterIds}**

### prefix：tag name 包含的部分；ancestorIds：先祖节点群，如有多个，请用，隔开

Response:

```protobuf

message TagNodeDTO{
    optional Result result = 1;
    optional TagNodeData data = 2;
}

message TagNodeData{
    repeated TagNode nodes = 1;
}

message TagNode{
    optional int64  id = 1;
    optional string name = 2;
}

```


# Tag属性相关

## 创建一个tag property
**POST /api/hd-fragments/v1/tag-properties**

Request:

```protobuf
//如果没有可以不传对应的字段
message TagPropertyOption{
  optional int64 id = 1;
  optional int64 tagId = 2;
  optional string key = 3;
  optional string value = 4;
}

```


Response:

```protobuf

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

```

## 创建一组tag property
**POST /api/hd-fragments/v1/tag-properties/create-properties**

Request:

```protobuf
//如果没有可以不传对应的字段
message TagPropertyOption{
  optional int64 id = 1;
  optional int64 tagId = 2;
  optional string key = 3;
  optional string value = 4;
}

message TagPropertiesOption{
  repeated TagPropertyOption properties = 1;
}

```


Response:

```protobuf

message TagProperty{
  optional int64 id = 1;
  optional int64 tagId = 2;
  optional string key = 3;
  optional string value = 4;
}

message TagPropertiesData{
  repeated TagProperty properties = 1;
}

message TagPropertiesDTO{
  optional Result result = 1;
  optional TagPropertiesData data = 2;
}

```

## 修改一个tag property
**PATCH /api/hd-fragments/v1/tag-properties/{tagPropertyId}**

Request:

```protobuf
//如果没有可以不传对应的字段
message TagPropertyOption{
  optional int64 id = 1;
  optional int64 tagId = 2;
  optional string key = 3;
  optional string value = 4;
}

```


Response:

```protobuf

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

```

## 删除一个tag property
**DELETE /api/hd-fragments/v1/tag-properties/{tagPropertyId}**

Response:

```protobuf

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
//返回的会是只有result的DTO对象
  optional Result result = 1;
  optional TagPropertyData data = 2;
}

```

## 查询一个tag property
**GET /api/hd-fragments/v1/tag-properties/{tagPropertyId}**

Response:

```protobuf

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

```

## 根据tagId查询该tag下面所有tag property
**GET /api/hd-fragments/v1/tags/{tagId}/tag-properties**

Response:

```protobuf

message TagProperty{
  optional int64 id = 1;
  optional int64 tagId = 2;
  optional string key = 3;
  optional string value = 4;
}

message TagPropertiesData{
  repeated TagProperty properties = 1;
}

message TagPropertiesDTO{
  optional Result result = 1;
  optional TagPropertiesData data = 2;
}

```

# Tag2Object相关
### todo 确认mapping type 的全集，目前包括：user_faved_disease、user_tag、nurse_tag、dpt_disease、research_user、research_nurse
## 创建一个tag to object
**POST /api/hd-fragments/v1/tag-2-objects**

Request:

```protobuf
//如果没有可以不传对应的字段
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

```


Response:

```protobuf

message TagToObject{
  optional int64 id = 1;
  optional int64 tagId = 2;
  optional int32 tagType = 3;
  optional int64 objectId = 4;
  optional int32 objectType = 5;
  optional int32 mappingType = 6;
  optional int64 creatorDptId = 7;
  optional int64 creatorOrgId = 8;
  optional int64 createdAt = 9;
    optional int64 updatedAt = 10;
}

message TagToObjectData{
  optional TagToObject tag2Object = 1;
}

message TagToObjectDTO{
  optional Result result = 1;
  optional TagToObjectData data = 2;
}

```

## 修改一个tag to object
**PATCH /api/hd-fragments/v1/tag-2-objects/{tag2ObjectId}**

Request:

```protobuf
//如果没有可以不传对应的字段
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

```


Response:

```protobuf

message TagToObject{
  optional int64 id = 1;
  optional int64 tagId = 2;
  optional int32 tagType = 3;
  optional int64 objectId = 4;
  optional int32 objectType = 5;
  optional int32 mappingType = 6;
  optional int64 creatorDptId = 7;
  optional int64 creatorOrgId = 8;
  optional int64 createdAt = 9;
    optional int64 updatedAt = 10;
}

message TagToObjectData{
  optional TagToObject tag2Object = 1;
}

message TagToObjectDTO{
  optional Result result = 1;
  optional TagToObjectData data = 2;
}

```

## 删除一个tag to object
**DELETE /api/hd-fragments/v1/tag-2-objects/{tag2ObjectId}**

Response:

```protobuf

message TagToObject{
  optional int64 id = 1;
  optional int64 tagId = 2;
  optional int32 tagType = 3;
  optional int64 objectId = 4;
  optional int32 objectType = 5;
  optional int32 mappingType = 6;
  optional int64 creatorDptId = 7;
  optional int64 creatorOrgId = 8;
  optional int64 createdAt = 9;
    optional int64 updatedAt = 10;
}

message TagToObjectData{
  optional TagToObject tag2Object = 1;
}

message TagToObjectDTO{
//会返回一个只有result的DTO对象
  optional Result result = 1;
  optional TagToObjectData data = 2;
}

```

## 查找一个tag to object
**GET /api/hd-fragments/v1/tag-2-objects/{tag2ObjectId}**

Response:

```protobuf

message TagToObject{
  optional int64 id = 1;
  optional int64 tagId = 2;
  optional int32 tagType = 3;
  optional int64 objectId = 4;
  optional int32 objectType = 5;
  optional int32 mappingType = 6;
  optional int64 creatorDptId = 7;
  optional int64 creatorOrgId = 8;
  optional int64 createdAt = 9;
    optional int64 updatedAt = 10;
}

message TagToObjectData{
  optional TagToObject tag2Object = 1;
}

message TagToObjectDTO{
  optional Result result = 1;
  optional TagToObjectData data = 2;
}

```

## 条件查询tag to object（所有的参数都非必填项）
**GET /api/hd-fragments/v1/tag-2-objects?tagId={tagId}&tagType={tagType}&objectId={objectId}&objectType={objectType}&creatorDptIds={departmentIds}&mappingType={mappingType}**

### creatorDptId可以为单独的一个——例如1；
### 也可以为使用，分隔开的多个creatorDptId，如：1，2，3，4

Response:

```protobuf

message TagToObject{
  optional int64 id = 1;
  optional int64 tagId = 2;
  optional int32 tagType = 3;
  optional int64 objectId = 4;
  optional int32 objectType = 5;
  optional int32 mappingType = 6;
  optional int64 creatorDptId = 7;
  optional int64 creatorOrgId = 8;
  optional int64 createdAt = 9;
    optional int64 updatedAt = 10;
}

message TagToObjectsData{
  repeated TagToObject tag2Objects = 1;
}

message TagToObjectsDTO{
  optional Result result = 1;
  optional TagToObjectsData data = 2;
}

```
# 传说中的事务接口们

## 增删改tags以及她们的properties
### 注意结构，总节点的个数不能超过50
**POST /api/hd-fragments/v1/tags/transactional**

Request:

```protobuf
message TransactionalTagOption{
    optional TransactionalTagAddOption addOptions = 1;
    repeated TransactionalTagUpdateOption updateOptions = 2;
    repeated TagOption deleteOptions = 3;
}

message TransactionalTagAddOption{
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

    repeated TagPropertyOption propertyOptions = 26;

    repeated TransactionalTagAddOption daughterOptions = 27;
}

message TransactionalTagUpdateOption{
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

    repeated TagPropertyOption propertyOptions = 26;
}

```


Response:

```protobuf

message TransactionalTagAddDTO{
    optional TagDTO tag = 1;
    repeated TagPropertyDTO properties = 2;
    repeated TransactionalTagAddDTO daughters = 3;
}

message TransactionalTagUpdateDTO{
    optional TagDTO tag = 1;
    repeated TagPropertyDTO properties = 2;
}

message TransactionalTagDTO{
    optional Result result = 1;
    optional TransactionalTagAddDTO addDTO = 2;
    repeated TransactionalTagUpdateDTO updateDTOs = 3;
}

```

## 增删改一组properties
**POST /api/hd-fragments/v1/tag-properties/transactional**

Request:

```protobuf

message TransactionalTagPropertyOption{
    repeated TagPropertyOption addOptions = 1;
    repeated TagPropertyOption updateOptions = 2;
    repeated TagPropertyOption deleteOptions = 3;
}

```


Response:

```protobuf

message TransactionalTagPropertyDTO{
    optional Result result = 1;
    repeated TagPropertyDTO addDTOs = 2;
    repeated TagPropertyDTO updateDTOs = 3;
}

```

## 增删一堆tag to object
**POST /api/hd-fragments/v1/tag-2-object/transactional**

Request:

```protobuf

message TransactionalTagToObjectOption{
    repeated TagToObjectOption addOptions = 1;
    repeated TagToObjectOption deleteOptions = 2;
}

```


Response:

```protobuf

message TransactionalTagToObjectDTO{
    optional Result result = 1;
    repeated TagToObjectDTO addDTOs = 2;
}

```

# Only For Radius

## get tag and properties
**POST /api/hd-fragments/v1/tags/{tagId}/tag-and-properties**

Response:

```protobuf

message TagAndPropertyDTO{
    optional Result result = 1;
    optional Tag tag = 2;
    repeated TagProperty properties = 3;
}

```

## get stag and properties
**POST /api/hd-fragments/v1/tags/tags-and-properties?tagId={tagId}**

Response:

```protobuf

message TagAndProperty{
    optional Tag tag = 1;
    repeated TagProperty properties = 2;
}

message TagsAndPropertiesDTO{
    optional Result result = 1;
    repeated TagAndProperty tags = 2;
}


```


# 开发排期

内容|耗时/人日|actor|预计开始日期
---|---|---|---
前期准备：构建项目，数据库、生成实体类、protobuf对象生成、enum对象构建等|1|李圣阳|04.11
查询DAO|1|李圣阳|04.12
Service层逻辑|1|李圣阳|04.13
Controller部分以及Halo的同步|1.5|李圣阳|03.14
自测|0.5|李圣阳|04.15

# todo
- the name of tag system


# 项目进度

### 2017-04-11

**今日**

- 开发

**明天**

- 自测
- push push push

### 2017-04-12

**今日**

- 自测

**明天**

- 部署？
- push push push

### 2017-04-13

**今日**

- 测试 with Scientific Boundary

**明天**

- 部署？
- push push push

### 2017-04-14

**今日**

- 数据库唯一键 通过parentId的下一层是否有同名来判断(tag的部分)(ok)
- 三个batch接口 其中的tag的是那种递归的结构  并且要计数深度(ok) (第一个节点的路径必须是完整的，否则存储的时候回报错)
- 提供一个接口 返回tag的information 以及他的 property的Map表
- tag To Object add createdAt updatedAt 

**明天**

- 部署？
- push push push
- 幂等操作？

### 2017-04-15

**今日**

- 完成幂等操作
- 满足他人的需求 

**明天**

- 部署？
- push push push
- 幂等操作？





