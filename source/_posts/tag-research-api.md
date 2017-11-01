---
title: 科研云 API
date: 2017-4-8 16:00:00
categories: Tag
tags:
  - Tag
---

# 摘要

科研云 API

<!-- more -->

# 参考
- http://wiki.office.test.youhujia.com/2017/03/29/tag-is-everything/
- http://wiki.office.test.youhujia.com/2017/04/07/web-api/
- http://wiki.office.test.youhujia.com/2017/04/06/tag-is-everything-api/

# Owner

李圣阳

# Protobuf Message

```protobuf
message Patient{
  optional int64 id = 1;
    optional int64 personId = 2;
    optional string nickName = 3;
    optional int64 status = 4;
    optional int64 createdAt = 5;
    optional int64 updatedAt = 6;
    optional string phone = 7;
    optional string avatarUrl = 8;
    optional string token = 9;
    optional int64 birthday = 10;
    optional int64 gender = 11;
    optional string openid = 13;
    optional string accessToken = 14;
    optional int64 departmentId = 15;
    optional string departmentName = 16;
    optional int64 organizationId = 17;
    optional string organizationName = 18;
    optional string departmentNo = 19;
    repeated UserAddress userAddress = 20;
    optional string flag = 21;
    optional string idCard = 22;
    optional bool hasWechat = 23;
}

message Nurse{
  optional int64 id = 1;
    optional int64 personId = 2;
    optional int64 organizationId = 3;
    optional int64 departmentId = 4;
    optional string name = 5;
    optional string idCard = 8;
    optional int64 personType = 9;
    optional int64 status = 10;
    optional string certs = 11;
    optional string photos = 12;
    optional string title = 13;
    optional int64 createdAt = 14;
    optional int64 updatedAt = 15;
    optional bool active = 16;
    optional string phone = 17;
    optional string avatarUrl = 18;
    optional string token = 19;
    optional int64 birthday = 20;
    optional int64 gender = 21;
}

message Address {
    optional string province = 1;
    optional string city = 2;
    optional string district = 3;
    optional string addressDetail = 4;
}

message UserAddress {
    optional int64 userAddressId = 1;
    optional string name = 2;
    optional int64 gender = 3;
    optional int64 birthday = 4;
    optional int64 relation = 5;
    optional Address address = 6;
    optional string phone = 7;
    optional string idCard = 8;
    optional bool default = 9;
    optional int64 userId = 10;
}


message ResearchGroupOption{
  optional int64 id = 1;
  optional string name = 2;
  optional int32 maxPatientNumber = 3;
  repeated int64 patientIds = 4;
  repeated int64 nurseIds = 5;
}

message ResearchGroup{
  optional int64 id = 1;
  optional string name = 2;
  optional int32 maxPatientNumber = 3;
  repeated Patient patients = 4;
  repeated Nurse nurses = 5;
}

message ResearchGroupData{
  optional ResearchGroup group = 1;
}

message ResearchGroupDTO{
  optional Result result = 1;
  optional ResearchGroupData data = 2;
}

message ResearchGroupsData{
  repeated ResearchGroup groups = 1;
}

message ResearchGroupsDTO{
  optional Result result = 1;
  optional ResearchGroupsData data = 2;
}

message ResearchOption{
  optional int64 id = 1;
  optional string title = 2;
  optional string abbreviation = 3;
  optional int64 startTime = 4;
  optional int64 endTime = 5;
  optional int64 ownerNurseId = 6;
  repeated ResearchGroupOption groups = 7;
}

message Research{
  optional int64 id = 1;
  optional string title = 2;
  optional string abbreviation = 3;
  optional int64 startTime = 4;
  optional int64 endTime = 5;
  optional Nurse ownerNurse = 6;
  repeated ResearchGroup groups = 7;
}

message ResearchData{
  optional Research research = 1;
}

message ResearchDTO{
  optional Result result = 1;
  optional ResearchData data = 2;
}

message ResearchListData{
  repeated Research research = 1;
}

message ResearchListDTO{
  optional Result result = 1;
  optional ResearchListData data = 2;
}

```

# Code

```
  com.youhujia.research
    domain
      Research
        ResearchController
          |=> public ResearchDTO createResearch(ResearchOption option);
          |=> public ResearchDTO updateResearch(ResearchOption option);
          |=> public ResearchDTO deleteResearch(long id);
          |=> public ResearchListDTO getResearchList();
          |=> public ResearchDTO getById(Long id);
          
        ResearchService
          |=> public ResearchDTO createResearch(ResearchOption option);
          |=> public ResearchDTO updateResearch(ResearchOption option);
          |=> public ResearchDTO deleteResearch(long id);
          |=> public ResearchListDTO getResearchList();
          |=> public ResearchDTO getById(Long id);
          
    ResearchGroup
        ResearchGroupController
          |=> public ResearchGroupDTO createResearchGroup(ResearchGroupOption option);
          |=> public ResearchGroupDTO updateResearchGroup(ResearchGroupOption option);
          |=> public ResearchGroupDTO deleteResearchGroup(long id);
          |=> public ResearchGroupsDTO getResearchListByResearchId(long researchId);
          |=> public ResearchGroupDTO getById(Long id);
          
        ResearchService
          |=> public ResearchGroupDTO createResearchGroup(ResearchGroupOption option);
          |=> public ResearchGroupDTO updateResearchGroup(ResearchGroupOption option);
          |=> public ResearchGroupDTO deleteResearchGroup(long id);
          |=> public ResearchGroupsDTO getResearchListByResearchId(long researchId);
          |=> public ResearchGroupDTO getById(Long id);

```


# 科研项目
## 创建一个科研项目
**POST /api/scientific-boundary/v1/researches**

Request:

```protobuf
//如果没有可以不传对应的字段
message ResearchGroupOption{
  optional int64 id = 1;
  optional string name = 2;
  optional int32 maxPatientNumber = 3;
  repeated int64 patientIds = 4;
  repeated int64 nurseIds = 5;
}

message ResearchOption{
  optional int64 id = 1;
  optional string title = 2;
  optional string abbreviation = 3;
  optional int64 startTime = 4;
  optional int64 endTime = 5;
  optional int64 ownerNurseId = 6;
  repeated ResearchGroupOption groups = 7;
}

```


Response:

```protobuf

message ResearchGroup{
  optional int64 id = 1;
  optional string name = 2;
  optional int32 maxPatientNumber = 3;
  repeated Patient patients = 4;
  repeated Nurse nurses = 5;
}

message Patient{
  optional int64 id = 1;
    optional int64 personId = 2;
    optional string nickName = 3;
    optional int64 status = 4;
    optional int64 createdAt = 5;
    optional int64 updatedAt = 6;
    optional string phone = 7;
    optional string avatarUrl = 8;
    optional string token = 9;
    optional int64 birthday = 10;
    optional int64 gender = 11;
    optional string openid = 13;
    optional string accessToken = 14;
    optional int64 departmentId = 15;
    optional string departmentName = 16;
    optional int64 organizationId = 17;
    optional string organizationName = 18;
    optional string departmentNo = 19;
    repeated UserAddress userAddress = 20;
    optional string flag = 21;
    optional string idCard = 22;
    optional bool hasWechat = 23;
}

message Nurse{
  optional int64 id = 1;
    optional int64 personId = 2;
    optional int64 organizationId = 3;
    optional int64 departmentId = 4;
    optional string name = 5;
    optional string idCard = 8;
    optional int64 personType = 9;
    optional int64 status = 10;
    optional string certs = 11;
    optional string photos = 12;
    optional string title = 13;
    optional int64 createdAt = 14;
    optional int64 updatedAt = 15;
    optional bool active = 16;
    optional string phone = 17;
    optional string avatarUrl = 18;
    optional string token = 19;
    optional int64 birthday = 20;
    optional int64 gender = 21;
}

message Research{
  optional int64 id = 1;
  optional string title = 2;
  optional string abbreviation = 3;
  optional int64 startTime = 4;
  optional int64 endTime = 5;
  optional Nurse ownerNurse = 6;
  repeated ResearchGroup groups = 7;
}

message ResearchData{
  optional Research research = 1;
}

message ResearchDTO{
  optional Result result = 1;
  optional ResearchData data = 2;
}

```

## 修改一个科研项目
**PATCH /api/scientific-boundary/v1/researches/{researchId}**

Request:

```protobuf
//如果没有可以不传对应的字段
message ResearchGroupOption{
  optional int64 id = 1;
  optional string name = 2;
  optional int32 maxPatientNumber = 3;
  repeated int64 patientIds = 4;
  repeated int64 nurseIds = 5;
}

message ResearchOption{
  optional int64 id = 1;
  optional string title = 2;
  optional string abbreviation = 3;
  optional int64 startTime = 4;
  optional int64 endTime = 5;
  optional int64 ownerNurseId = 6;
  repeated ResearchGroupOption groups = 7;
}

```


Response:

```protobuf
message Research{
  optional int64 id = 1;
  optional string title = 2;
  optional string abbreviation = 3;
  optional int64 startTime = 4;
  optional int64 endTime = 5;
  optional Nurse ownerNurse = 6;
  repeated ResearchGroup groups = 7;
}

message ResearchData{
  optional Research research = 1;
}

message ResearchDTO{
  optional Result result = 1;
  optional ResearchData data = 2;
}
```

## 删除一个科研项目
**DELETE /api/scientific-boundary/v1/researches/{researchId}**

Response:

```protobuf
message SimpleResonse{
  optional REsult result = 1;
}
```

## 查找一个科研项目
**GET /api/scientific-boundary/v1/researches/{researchId}**

Response:

```protobuf
message Research{
  optional int64 id = 1;
  optional string title = 2;
  optional string abbreviation = 3;
  optional int64 startTime = 4;
  optional int64 endTime = 5;
  optional Nurse ownerNurse = 6;
  repeated ResearchGroup groups = 7;
}

message ResearchData{
  optional Research research = 1;
}

message ResearchDTO{
  optional Result result = 1;
  optional ResearchData data = 2;
}
```

## 查找科室下所有的科研项目
**GET /api/scientific-boundary/v1/researches?departmentId={departmentId}**

Response:

```protobuf
message Research{
  optional int64 id = 1;
  optional string title = 2;
  optional string abbreviation = 3;
  optional int64 startTime = 4;
  optional int64 endTime = 5;
  optional Nurse ownerNurse = 6;
  repeated ResearchGroup groups = 7;
}

message ResearchListData{
  repeated Research research = 1;
}

message ResearchListDTO{
  optional Result result = 1;
  optional ResearchListData data = 2;
}
```

# 科研分组
## 新建一个科研分组
**POST /api/scientific-boundary/v1/research-groups/{researchId}**


Request:

```protobuf
//如果没有可以不传对应的字段
message ResearchGroupOption{
  optional int64 id = 1;
  optional string name = 2;
  optional int32 maxPatientNumber = 3;
  repeated int64 patientIds = 4;
  repeated int64 nurseIds = 5;
}
```


Response:

```protobuf
message ResearchGroup{
  optional int64 id = 1;
  optional string name = 2;
  optional int32 maxPatientNumber = 3;
  repeated Patient patients = 4;
  repeated Nurse nurses = 5;
}

message ResearchGroupData{
  optional ResearchGroup group = 1;
}

message ResearchGroupDTO{
  optional Result result = 1;
  optional ResearchGroupData data = 2;
}
```

## 修改一个科研分组
**PATCH /api/scientific-boundary/v1/research-groups/{groupId}**


Request:

```protobuf
//如果没有可以不传对应的字段
message ResearchGroupOption{
  optional int64 id = 1;
  optional string name = 2;
  optional int32 maxPatientNumber = 3;
  repeated int64 patientIds = 4;
  repeated int64 nurseIds = 5;
}
```

Response:

```protobuf
message ResearchGroup{
  optional int64 id = 1;
  optional string name = 2;
  optional int32 maxPatientNumber = 3;
  repeated Patient patients = 4;
  repeated Nurse nurses = 5;
}

message ResearchGroupData{
  optional ResearchGroup group = 1;
}

message ResearchGroupDTO{
  optional Result result = 1;
  optional ResearchGroupData data = 2;
}
```

## 删除一个科研分组
**DELETE /api/scientific-boundary/v1/research-groups/{groupId}**


Response:

```protobuf
message ResearchGroup{
  optional int64 id = 1;
  optional string name = 2;
  optional int32 maxPatientNumber = 3;
  repeated Patient patients = 4;
  repeated Nurse nurses = 5;
}

message ResearchGroupData{
  optional ResearchGroup group = 1;
}

message ResearchGroupDTO{
  optional Result result = 1;
  optional ResearchGroupData data = 2;
}
```

## 根据GroupId查找一个科研分组
**GET /api/scientific-boundary/v1/research-groups/{groupId}**


Response:

```protobuf
message ResearchGroup{
  optional int64 id = 1;
  optional string name = 2;
  optional int32 maxPatientNumber = 3;
  repeated Patient patients = 4;
  repeated Nurse nurses = 5;
}

message ResearchGroupData{
  optional ResearchGroup group = 1;
}

message ResearchGroupDTO{
  optional Result result = 1;
  optional ResearchGroupData data = 2;
}
```

## 根据科研的id查找其名下所有科研分组
**GET /api/scientific-boundary/v1/research-groups?researchId={researchId}**

Response:

```protobuf
message ResearchGroup{
  optional int64 id = 1;
  optional string name = 2;
  optional int32 maxPatientNumber = 3;
  repeated Patient patients = 4;
  repeated Nurse nurses = 5;
}

message ResearchGroupsData{
  repeated ResearchGroup group = 1;
}

message ResearchGroupsDTO{
  optional Result result = 1;
  optional ResearchGroupsData data = 2;
}
```

# 开发排期

| 内容                               | 耗时/人日 | actor | 预计开始日期 |
| -------------------------------- | ----- | ----- | ------ |
| 前期准备：构建项目，protobuf对象生成、enum对象构建等 | 1     | 李圣阳   | 04.17  |
| Service层逻辑                       | 2     | 李圣阳   | 04.18  |
| Controller部分以及Halo的同步            | 1.5   | 李圣阳   | 03.20  |
| 自测                               | 0.5   | 李圣阳   | 04.21  |

# The name of 科研云

Scientific boundary， aka: The SB Project

# 项目进度

### 2017-04-12

**今日**

- 开发

**明天**

- 开发，自测
- push push push

### 2017-04-13

**今日**

- 自测

**明天**

- 部署？
- push push push

### 2017-04-14

**今日**

- 修改research 的相关的操作 吧所有的for循环的操作都改成事务操作

**明天**

- 部署？
- push push push

### 2017-04-15

**今日**

- 等待部署

**明天**

- 部署？
- push push push

