---
title: Web API
date: 2017-4-15 14:11:00
categories: web
tags:
- web
---

# 摘要

Web API

<!-- more -->

# 上线脚本

涉及系统（包括有更新项目的）：

1. halo
2. Evans
3. Galaxy
4. ScienceBoundary
5. Huformation

配置需要更新：

1. Evans，添加 mentalseal 信息
2. Gateway, add config for SB

准备数据：

1. MentalSeal 无可用后台，手工在数据库添加数据

# 类设计

#### ManagerController

| 方法名                  | 参数                 | 返回值                 | 详情              |
| -------------------- | ------------------ | ------------------- | --------------- |
| getHomePage          | nurseId            | DptHomePageInfoDTO  | 获取首页信息          |
| updateHomePage       | DptHomePageInfoOpt | SimpleResponseDTO   | 更新首页科室信息        |
| getNurseList         | nurseId            | NurseListDTO        | 获取护士列表          |
| updateNurse          | Nurse              | SimpleResponseDTO   | 更新护士信息          |
| addNurse             | NurseOpt           | SimpleResponseDTO   | 添加护士            |
| getNurseDetail       | nurseId            | Nurse               | 获取护士详情          |
| getEvaluations       |                    | Evaluations         | 工单管理（评估+随访）     |
| getPatientList       | tagIds&&status     | PatientListDTO      | 获取患者列表          |
| getPatientDetail     | patientId          | PatientDTO          | 获取患者详情          |
| createPatient        | PatientOpt         | SimpleResponseDTO   | 新建患者            |
| updatePatient        | patientId          | SimpleResponseDTO   | 更新患者信息          |
| deletePatient        | patientId          | SimpleResponseDTO   | 删除患者            |
| archivePatient       | ArchiveOpt         | SimpleResponseDTO   | 批量归档患者          |
| createPush           | PushTask           | SimpleResponseDTO   | 创建推送内容          |
| getTags              |                    | TagListDTO          | 获取标签列表          |
| getTagCategory       |                    | TagCategoryListDTO  | 获取标签组的List      |
| getTagCategoryDetail | id                 | TagCategoryDTO      | 获取标签组的详情        |
| createCategory       | TagCategoryOpt     | SimpleResponseDTO   | 创建标签组           |
| updateCategory       | TagCategoryOpt     | SimpleResponseDTO   | 更新某一个标签组        |
| createTag            | TagOpt             | SimpleResponseDTO   | 新建Tag           |
| updateTag            | TagOpt             | SimpleResponseDTO   | 更新Tag           |
| deleteTag            | tagId              | SimpleResponseDTO   | 删除Tag           |
| getCareRountine      |                    | CareRoutineDTO      | 获取护理路径          |
| createCareRountine   | CareRoutineOpt     | SimpleResponseDTO   | 创建护理路径          |
| getFollowManager     |                    | CareTemplateListDTO | 随访（随访+护理路径）     |
| getArticles          |                    | ArticlesDTO         | 获取文章列表(官方/自建)   |
| getArticleDetail     | id                 | Article             | 获取文章详情(官方/自建)   |
| createArticle        | Article            | CommonResponseDTO   | 新建文章            |
| updateArticle        | Article            | CommonResponseDTO   | 更新文章(官方/自建)     |
| getTools             |                    | EvaluationListDTO   | 获取工具（eval/self） |


# 首页

**GET /api/evans/v1/homepage/departmentId/{departmentId}**

```protobuf
message DptHomePageInfoDTO{
  optional Result restult = 1;
  optional DptHomePageInfoData data = 2;
}

message DptHomePageInfoData{
  optional DptHomePageInfo dptHomePageInfo = 1; 
}

message DptHomePageInfo{
  optional string name = 1;     //机构名称
  optional string orgName = 2;    //所属医院
  optional string subjectBelongsTo = 3;   //所属学科
  optional string dptImgUrl = 4;   //形象照片
  optional string logoUrl = 5;     //机构的二维码
}
```

**PATCH /api/evans/v1/homepage/departmentId/{departmentId}**

response:

message DptHomePageInfoDTO{

 //参照获取部门详情接口
}



# 文章列表

文章分为两类：自建文章和优护家的官方文章。

### 获取文章列表

**官方；GET /api/evans/v1/articles/official**
**自建：GET /api/evans/v1/articles/local**

response:

```protobuf
message ArticleListDTO{
  optional Result result = 1;
  optional ArticleListData data = 2; 
}

message  ArticleListData{
  repeated Article article = 1;
}

message Article{
  optional int64 id=1;
  optional string name=2;
  optional string brief=3;
  optional string author=4;
  optional string status=5;
  optional string content=6;
  optional string url=7;
  optional int64 typeId=8;
  optional Category category = 9;
}

message Category {
  optional int64 id = 1;
  optional string name = 2;
}
```

优护家的宣教分类：科室类别-》前端的疾病节点（两级：内科-》心内）-》百科节点-》宣教

科室自己的宣教一级分类，默认分组：default。

### MARK添加接口：根据科室返回优护家的前端疾病节点，点击获取文章 list

todo 待确认技术细节，如何保存所谓的：前端疾病节点，该节点和文章的关系。

### 获取文章详情

**官方：GET /api/evans/v1/articles/official/{id}**

**自建：GET /api/evans/v1/articles/local/{id}**
response:

```protobuf
message ArticleDTO{
  optional Result result = 1;
  optional ArticleData data = 2;  
}

message ArticleData{
  optional Article article = 1;
}

message  Article{
  optional int64 id=1;
  optional string name=2;
  optional string brief=3;
  optional string author=4;
  optional string status=5;
  optional string content=6;
  optional string bannerUrl=7;
  optional int64 articleTypeId=8;//参考 article_type 表
  optional int64 categoryId = 9;
}
```

### 更新文章

**官方：PATCH /api/evans/v1/articles/official/{id}**
**自建：PATCH /api/evans/v1/articles/local/{id}**

Request:

```protobuf
message ArticleOpt{
  optional string name=2;
  optional string brief=3;
  //optional string author=4;
  //optional string status=5;
  optional string content=6;
  optional string bannerUrl=7;
  //optional int64 articleTypeId=8;
  optional int64 categoryId = 9;
}
```

### 新建文章（只能新建本科室的）

**POST /api/evans/v1/articles/local/**
request：

```protobuf
message ArticleOpt{
  optional string name=1;
  optional string brief=2;
  optional string content=3;
  optional string bannerUrl=4;
  optional int64 categoryId = 5;
}
```

response:

```protobuf
message ArticleDTO{
   //参照文章详情返回值
}
```

# 工具列表

只有查看，不需修改和创建

### 获取工具列表

**获取随访列表（Galaxy）：GET api/nurses/calendars/events/followup/v2**
**获取评估列表（Evans）：GET /api/evans/v1/task/evaluations**

response：

```protobuf
message EvaluationListDTO{
  optional Result result = 1;
  optional EvaluationData data = 2;
}
message EvaluationData{
  repeated Evaluation evaluation = 1;
}
message Evaluation{
  optional int64 id = 1;
  optional string name = 2;
  optional int64 departmentId = 3;
  optional int64  type = 4;//eval or selftest
  optional int64 iconId = 5;
  optional string iconColor = 6;
  repeated Question question = 7;

  message Question{
    optional int64 id = 1;
    optional int64 type = 3;
    optional string content = 2;
    optional bool required = 4;
    repeated QuestionOption questionOption = 5;
    repeated SingleChoiceMatrix singleChoiceMatrix=6;
  }
  message QuestionBundleAnalysis{
    optional int64 id = 1;
    optional string condition = 2;
    optional string analysis = 3;
  }
  message QuestionOption{
    optional int64 id = 1;
    optional string content = 2;
  }
  message SingleChoiceMatrix{
     optional int64 rank = 1;
     optional string content = 2;
     repeated string choice = 3;

  }
}
```

# 服务配置

复用已有，商品支撑系统

# MARK护士管理

## 获取人员列表(evans)

**GET /api/evans/v1/nurses**

```protobuf
message NurseListDTO{
  optional Result result = 1;
  optional NurseData data = 2;
}
message NurseData{
  repeated Nurse nurse = 1;
}
message Nurse{
  optional int64 id = 1;
  optional string name = 2;
  optional int64 status = 3;   
  optional string title = 4;
  optional int64 gender = 5;
  optional int64 birthday = 6;  //出生的时间戳，要转换成自己的年龄
  optional string phone = 7;
  optional string idCardNo = 8;

}
```

## 更新护士信息(evans)

**PUT /api/evans/v1/nurses/{nurseId}**

request：

```protobuf
message NurseOpt{
  optional string name = 1;
  optional int64 status = 2;  //可以修改认证信息
  optional string title = 3;
  optional int64 gender = 4;
  optional int64 birthday = 5;
  optional string phone = 6;
  optional string idCardNo = 7;
}
```
response:

```protobuf
message NurseDTO{
  optional Result result = 1;
  optional NurseWithWorkLogData data = 2;
}
message NurseWithWorkLogData{
  optional NurseWithWorkLog nurseWithWorkLog = 1;
}
message NurseWithWorkLog{
  optional int64 id = 1;
  optional string name = 2;
  optional int64 status = 3;
  optional string title = 4;
  optional int64 gender = 5;
  optional int64 birthday = 6;
  optional string phone = 7;
  optional string idCardNo = 8;
  repeated WorkLog worklog = 9;
}
message WorkLog{
    optional int64 id = 1;
    optional int64 type = 2;
    optional string title = 3;
    optional string content = 4;
    optional int64 timestamp = 5;
    optional int64 status = 6;

  }
```

## 创建护士(evans)

**POST /api/evans/v1/nurses**

```protobuf
message NurseOpt{
  
  //参考更新的request
  //创建的时候不需要传认证信息

}
```
response:

```protobuf
message NurseDTO{
 //参照更新护士的response
}
```

## 护士详情，包括工作记录(evans)

**GET /api/evans/v1/nurses/{nurseId}**
response:

```protobuf
message NurseDTO{
  optional int64 result = 1;
  optional NurseData data = 2;
}

message NurseData{
  optional Nurse nurse = 1;
}

message Nurse{
  optional int64 id = 1;
  optional string name = 2;
  optional int64 status = 3;  
  optional string title = 4;
  optional int64 gender = 5;
  optional int64 birthday = 6;
  optional string phone = 7;
  optional string idCardNo = 8;
  
  repeated WorkLog worklog = 9;
  
  messsage WorkLog{
    optional int64 id = 1;
    optional int64 type = 1;
    optional string title = 2;
    optional string content = 2;
    optional int64 timestamp = 3;
    optional int64 status = 4;
  }
}
```

# 护士认证

PATCH /api/evans/v1/nurses/{nurseId}

- Request

  ```json
  message NurseAuth{
      optional bool auth = 1;
  }
  ```

- Response

  ```json
  message SimpleResponse{
    ...
  }
  ```

# MARK 评估详情

需要确定 Web 的设计

API: http://wiki.office.test.youhujia.com/2017/04/14/zhushou-2.0-api#获取评估任务详情

```json
message ProEvalEventDTO {
    optional Result result = 1;
    optional int64 eventId = 2;
    optional int64 nurseId = 3;
    optional int64 patientId = 4;
    optional int64 status = 5;
    optional EvaluateSection evalSection = 6;
}

message EvaluateSection {
    message Evaluate {
        optional int64 id = 1;
        optional string title = 2;
        optional string summary = 3;
        optional int64 resultId = 4;
    }

    optional string title = 1;
    optional string desc = 2;
    repeated Evaluate evaluate = 3;
    optional int64 order = 4;
}
```

# 公告、随访、排班包装 Galaxy 的接口

# 公告

## 添加公告(galaxy)

### //对老接口进行复用，更改了url

**POST /api/nurses/calendars/events/announcement/v2**
[老接口具体接口](https://github.com/Youhujia/galaxy/blob/master/src/main/java/com/youhujia/galaxy/domain/calendar/CalendarController.java#L56)

#### 描述
用户添加自己需要的公告
#### 接口详情

```protobuf
message AnnouncementEventAddOption {
  optional string title= 1;
  optional int64 startTime = 2;
  optional int64 day = 3;
  optional string content = 4;
  optional int64 nurseId = 5;
}
```

```protobuf
message AnnouncementEventAddDTO {
 optional Result result = 1;
}
```

## 删除公告（Galaxy）
### 直接复用老接口

**DELETE  /api/nurses/calendars/events/announcement/1/{id}**
[具体接口](https://github.com/Youhujia/galaxy/blob/master/src/main/java/com/youhujia/galaxy/domain/calendar/CalendarController.java#L77)

## 更新公告

### 复用老接口，更新了url

**PATCH /api/nurses/calendars/events/announcement/v2/{id}**
[具体接口](https://github.com/Youhujia/galaxy/blob/master/src/main/java/com/youhujia/galaxy/domain/calendar/CalendarController.java#L94)

#### 接口详情

Request:

```protobuf 
message AnnouncementEventUpdateOption {
  optional int64 eventId = 1;
  optional string title = 2;
  optional string content = 3;
  optional int64 startTime = 4;
  optional int64 day = 5;
  optional bool read = 6;
  optional int64 nurseId = 7;
}
```

Response:

```protobuf
message AnnouncementEventUpdateDTO {
  optional Result result = 1;
}
```

## 获取单个公告（Galaxy）
### 封装了返回值，更改了URL

**GET /api/nurses/calendars/events/announcement/v2/{id}**
[老接口](https://github.com/Youhujia/galaxy/blob/master/src/main/java/com/youhujia/galaxy/domain/calendar/CalendarController.java#L112) 接口        response更新

#### 接口详情

```protobuf
message AnnouncementDTO{
  optional Result result = 1;
  optional AnnouncementData data = 2;
}

message AnnouncementData{
  optional AnnouncementEventDTO announcement = 1;
}

message AnnouncementEventDTO{
  message ReadPerson{
    optional string name = 1;
    optional string avatarUrl = 2;
    optional int64 nurseId = 3;
  }
  message Nurse{
    optional string name = 1;
    optional int64 nurseId = 2;
  }

  optional Result result = 1;
  optional int64 eventId = 2;
  optional string title = 3;
  optional Nurse author = 4;
  optional int64 startTime = 5;
  optional int64 endTime = 6;
  optional string content = 7;
  repeated ReadPerson readPerson = 8;
  optional bool read = 9;
  optional int32 departmentNurseNum = 10;
}
```

# 随访


## 获取单个随访信息（Galaxy）
### 返回的是长度为1的List,封装了返回体，更改了URL

**GET /api/nurses/calendars/events/followup/v2/{id}**
复用 Galaxy 的 [getCalendarFollowUpEvent接口](https://github.com/Youhujia/galaxy/blob/master/src/main/java/com/youhujia/galaxy/domain/calendar/CalendarController.java#L132)

#### 接口详情

response:

```protobuf
message FollowUpOfEventDTO{
   optional Result result = 1;
   optional FollowUpEventData data = 2;
}
message  FollowUpEventData{
     optional FollowUpEventDTO followUp = 1;
}
message FollowUpEventDTO {
    message Target {
        message Tag {
            optional int64 tagId = 1;
            optional string tagName = 2;
        }
        optional int64 personId = 1;
        optional string avatar = 2;
        optional string name = 3;
        repeated Tag tag = 4;
    }
    message Event {
        optional int64 id = 1;
        optional string title = 2;
        optional int64 startTime = 3;
        optional int64 endTime = 4;
        optional int64 alertTime = 5;
        repeated string executorName = 6;
        optional string purpose = 7;
        optional int64 status = 8;
        message Brief {
            optional int64 actionId = 1;
            optional string content = 2;
        }
        optional Brief brief = 9;
        message WeChat {
            optional int64 actionId = 1;
            optional int64 status = 2;
            message WeChatContent {
                message Article {
                    optional int64 id = 1;
                    optional string title = 2;
                    optional bool read = 3;
                }
                message Tool {
                    optional int64 id = 1;
                    optional string title = 2;
                    optional string summary = 3;
                }
                repeated Article article = 3;
                repeated Tool tool = 4;
                optional WeChatMsg msg = 5;
            }
            optional WeChatContent content = 3;
        }
        optional WeChat wechat = 10;
    }
    optional Result result = 1;
    optional Target target = 2;
    optional string title = 3;
    repeated Event event = 4;
}

```

## 创建随访（RedCoast）
### 更新了URL

**POST /api/nurses/calendars/events/followup/v2**   
[createFollowUp](https://github.com/Youhujia/redcoast/blob/master/src/main/java/com/youhujia/redcoast/domain/followup/FollowUpController.java#L34) 接口

Request:

```protobuf

message FollowUpAddOption {
    optional int64 nurseId = 1; //creatorId
    optional int64 dischargeAt = 2;
    repeated int64 targetId = 3;
    repeated int64 executorId = 4;
    repeated int64 observerId = 5;
    optional int64 alertTemplateId = 6;
    optional int64 followUptemplateId = 7;
}
```

Response:

```protobuf
message FollowUpAddDTO{
   optional Result result = 1;
}
```

## 更新随访信息(Galaxy)
### 更改了URL

**PATCH /api/nurses/calendars/events/followup/{id}**

[updateCalendarFollowUpEvent](https://github.com/Youhujia/galaxy/blob/master/src/main/java/com/youhujia/galaxy/domain/calendar/CalendarController.java#L172) 接口

#### 接口详情

Request:

```json 
message FollowUpEventUpdateOption {
  optional int64 eventId = 1;
  optional string purpose = 2;
  optional Brief brief = 3;
  optional WeChat wechat = 4;
  optional int64 status = 5;
  optional int64 nurseId = 6;

  message Brief {
    optional int64 actionId = 1;
    optional string content = 2;
  }

  message WeChat {
    optional int64 actionId = 1;
    optional int64 status = 2;
    repeated Tool tool = 3;
    repeated Article article = 4;

    message Tool {
      optional int64 id = 1;
      optional string summary = 2;
    }
    message Article {
      optional int64 id = 1;
      optional bool read = 2;
    }
  }
}
```

Response:

```protobuf
message FollowUpEventUpdateDTO{
    optional Result result = 1;
}
```

# 排班

## 科室排班表（huformation）
### 更改了url，response更新

**GET /api/nurses/rosters/departments/{departmentId}/by-person/v2**

复用 huformation 的 [getSchedulesArrangedByPerson](https://github.com/Youhujia/huformation/blob/master/src/main/java/com/youhujia/huformation/controller/RosterScheduleController.java#L133) 接口     
#### 接口详情

Response:

```json 
message RosterSchedulesByPersonDTO{
  optional Result result = 1;
  optional RosterSchedulesByPersonData data = 2;
}
message RosterSchedulesByPersonData{
  optional RosterScheduleByPerson rosterScheduleByPerson = 1;
}
message RosterScheduleByPerson{
  repeated Roster rosters = 1;
  repeated ScheduleByPerson scheduleByPerson = 2;

  message Roster {
      optional string name = 1;
      optional int64 rosterId = 2;
      optional string colorClass = 3;
  }

  message ScheduleByPerson {
      optional string name = 1;
      optional int64 personId = 2;
      repeated Schedule data = 3;
  }

  message Schedule {
      repeated int64 rosterIds = 1;
      repeated int64 rosterScheduleIds = 2;
      optional bool isToday = 3;
      optional int64 date = 4;
      optional string displaDate = 5;
  }
}
```

## 创建排班（huformation）
### 更新了url,response更新

**POST /api/nurses/rosters/schedules/batch-append/v2**

[batchScheduleRoster](https://github.com/Youhujia/huformation/blob/master/src/main/java/com/youhujia/huformation/controller/RosterScheduleController.java#L59) 

Request:

```protobuf
message BatchRosterScheduleOption {
    repeated int64 rosterId = 1;
    repeated int64 executorId = 2;
    repeated int64 watcherId = 3;
    optional int64 date = 4;

    optional int32 notifyId = 5;
}
```

Response:

```protobuf
message RosterSchedulesDTO{
   optional Result result = 1;
   optional RosterSchedulesData date=2;
}
message RosterSchedulesData{
    repeated RosterSchedule rosterSchedule = 1;
}
message RosterSchedule {
    optional Result result = 1;

    optional int64 id = 2;
    optional int64 rosterId = 3;
    optional string rosterName = 4;
    optional string rosterColorClass = 5;
    optional int64 executorId = 6;
    optional string executorName = 7;

    optional string rosterStartTime = 8;

    optional string rosterEndTime = 9;

    optional int64 date = 10;
    optional string notifyTime = 11;
}

```

## 移除排班（huformation）
### 复用老接口

**DELETE /api/nurses/rosters/schedules/{rosterScheduleIds}**

[直接复用](https://github.com/Youhujia/huformation/blob/master/src/main/java/com/youhujia/huformation/controller/RosterScheduleController.java#L75)

# 班次

## 创建班次（huformation）
###  更改了URL ,response封装

**POST /api/nurses/rosters/v2**

[create](https://github.com/Youhujia/huformation/blob/master/src/main/java/com/youhujia/huformation/controller/RosterController.java#L27)

Request:

```protobuf
message RosterOption{
  optional int64 creatorId = 1;
  optional string title = 2;
  //16:00
  optional string startTime = 3;
  //16:30
  optional string endTime = 4;

  optional int32 gaps = 5;
  optional string colorClass = 6;
  optional string description = 7;
}
```

Response:

```protobuf
/********* Rosters ***********/
//new
message RosterDTO{
  optional Result result = 1;
  optional RosterData data = 2;
}
//new
message RosterData{
  optional Roster roster = 2;
}

//old
message Roster{
  optional Result result = 1;

  optional int64 id = 2;
  optional int64 creatorId = 3;
  optional string title = 4;
  optional string startTime = 5;
  optional string endTime = 6;
  optional int32 gaps = 7;
  optional string colorClass = 8;
  optional string description = 9;
}
```

## 更新班次（huformation）
###  更改了URL ,response封装

**PATCH /api/nurses/rosters/{rosterId}/v2**

[update](https://github.com/Youhujia/huformation/blob/master/src/main/java/com/youhujia/huformation/controller/RosterController.java#L42) ，更新了 URL

Request:

```protobuf
message RosterOption{
  optional int64 creatorId = 1;
  optional string title = 2;
  //16:00
  optional string startTime = 3;
  //16:30
  optional string endTime = 4;

  optional int32 gaps = 5;
  optional string colorClass = 6;
  optional string description = 7;
}
```

Response:

```protobuf

message RosterDTO{
  optional Result result = 1;
  optional RosterData data = 2;
}
message RosterData{
  optional Roster roster = 2;
}
message Roster{
  optional Result result = 1;
  optional int64 id = 2;
  optional int64 creatorId = 3;
  optional string title = 4;
  optional string startTime = 5;
  optional string endTime = 6;
  optional int32 gaps = 7;
  optional string colorClass = 8;
  optional string description = 9;
}


```

## 列表班次
### 更改了URL ,response封装

**GET /api/nurses/rosters/v2**

复用 huformation 的 [getRosters](https://github.com/Youhujia/huformation/blob/master/src/main/java/com/youhujia/huformation/controller/RosterController.java#L59) 接口    
```protobuf
//new
message RosterListDTO{
  optional Result result = 1;
  optional RosterListData data = 2;
}

//new
message RosterListData{
  repeated Roster roster = 2;
}
```

# 工单管理

返回两个接口

## 1. 工单列表

### 评估列表（evans）

**GET /api/evans/v1/task/evaluations**

```json
message WorkOrderOfEvaluationDTO{
  optional Result result = 1;
  optional EvaluationData data = 2;
}

message WorkOrderOfEvaluationData{
  repeated WorkOrder WorkOrder = 1;  
}

message WorkOrder{
  optional int64 id = 1;            
  optional int32 type = 2;
  optional string name = 3;
  optional string executorName = 4;
  optional string patientName = 5;
  optional int64 planedTime = 6;
  optional int64 execuateTime = 7;
  optional int32 status = 8;
  optional int64 nurseId =9;
}
```
###  随访列表(gaxaly)

 **GET /api/nurses/calendars/events/followup/v2**

```json
message WorkOrderOfFollowDTO{
  optional Result result = 1;
  optional WorkOrderOfFollowData data = 2;
}

message WorkOrderOfFollowData{
  repeated WorkOrder WorkOrder = 1;  
}

message WorkOrder{
  optional int64 id = 1;        
  optional int32 type = 2;
  optional string name = 3;
  optional string executorName = 4;
  optional string patientName = 5;
  optional int64 planedTime = 6;
  optional int64 execuateTime = 7;
  optional int32 status = 8;
  optional int64 nurseId =9;

}
```

# 创建评估（Evans）

**POST /api/evans/v1/task/evaluations**

request:

```protobuf
message EvaluationTaskOpt{
  optional string title = 1;
  optional int64 evaluationId = 2;
  repeated int64 nurseId = 3;
  repeated int64 patientId = 4;
  optional int64 executeTime = 5;
}
```
response:

```
message SimpleResponseDTO{

}
```

# 患者列表（包括患者详情）

**GET /api/evans/v1/patients?archiveStatus=1&tags={tagIds}**

archiveStatus:

1: 已归档

0：未归档

暂时没有tags

## 描述

展示该科室下所有的患者信息。

可以不支持 tag 搜索，返回全量即可，前端会自己做筛选。

## 接口详情

Response:

```protobuf
message PatientListDTO{
  optional Result result = 1;
  optional PatientListData data = 2;
}
message PatientListData{
  repeated Patient patient = 1;
}
message Patient{
      optional int64 id = 1;
      optional string name = 2;
      optional int64 gender = 3;
      optional int64 birthday = 4;
      optional string phoneNumber = 5;
      optional string idCard = 6;
      optional int64 createTime=7;
      repeated Tag tag= 8;
}
message Tag{
  optional int64 id = 1;
  optional int32 type = 2;
  optional string name = 3;
  optional TagCategory tagCategory = 4;
}
message TagCategory{
  optional int64 id = 1;
  optional string name = 2;
  repeated Tag tag=3;
}

```

# 患者管理-患者的详情

**GET/api/evans/v1/patients/{patientId}**

## 描述

[设计](http://owncloud.youhujia.com/index.php/s/TpvxcT4uhCZzerM)

## 接口详情

Response:

```protobuf
message PatientDTO{
  optional Result result = 1;
  optional PatientWithHealthRecordData data = 2;
}

message PatientWithHealthRecordData{
  optional PatientWithHealthRecord patientWithHealthRecord = 1;
}
message PatientWithHealthRecord{
  optional int64 id = 1;
  optional string name = 2;
  optional int64 gender = 3;
  optional int64 birthday = 4;
  optional string phoneNumber = 5;
  optional string idCard = 6;
  optional Address address = 7;
  repeated Tag tag= 8;
  repeated HealthRecord healthRecord = 9;
}
message HealthRecord {
    optional int64 id = 1;
    optional int64 type = 2;
    optional string title = 3;
    optional string content = 4;
    optional int64 status = 5;
}
message Address{
  optional string province= 1;
  optional string city = 2;
  optional string district = 3;
  optional string addressDetail = 4;
  optional int64 addressId=5;
}
```

# 患者管理-新建患者   

**POST /api/evans/v1/patients**

## 描述

新建本科室下的患者

## 接口详情

Request:

```protobuf
message PatientOpt{
   optional string name = 1;
   optional int64 gender = 2;// 1：男 2：女
   optional int64 birthday = 3;
   optional string idCard = 4;
   optional string phoneNumber = 5;
   optional Address address=6;
   repeated Tag tag = 7;
}
```
Response:

```protobuf
message PatientDTO{
  //同上
}
```
# 患者管理-修改患者信息

**PATCH /api/evans/v1/patients/{patientId}**

## 描述

修改患者信息,地址改的也是默认地址。

## 接口详情

request:

```protobuf
message PatientOpt{
   optional string name = 1;
   optional int64 gender = 2;// 1：男 2：女
   optional int64 birthday = 3;
   optional string idCard = 4;
   optional string phoneNumber = 5;
   optional Address address=6;
   repeated Tag tag = 7;
}
```
Response:

```protobuf
message PatientDTO{
  //同上
}
```

MARK，其中，标签分为两块，一个为科室自建标签+优护家推荐标签，全列出；另一个为 search 框，百科标签。

# 患者管理-删除患者信息

**DELETE /api/evans/v1/patients/{patientId}**

response:
```protobuf
message SimpleResponseDTO{
//同上

}
```

# 患者管理-批量管理-批量加标签

**POST /api/evans/v1/patients/add-tags**

```protobuf
message AddTagOpt{
  repeated int64 patientIds = 1;
  repeated Tag tag = 2;
}

```

# 患者管理-批量管理-批量归档

**POST /api/evans/v1/patients/archive**

## 描述

选中的护士进行批量归档

## 接口详情

Request:

```protobuf
message ArchiveOpt{
  repeated int64 patientId = 1;
}
```

Response:

```protobuf
message SimpleResponseDTO{
  optional Result result = 1;
}
```

# 创建推送内容

POST /api/evans/v1/push-tasks

```message
message PushTask{
  repeated int64 articleIds = 1;
  repeated int64 toolIds = 2;
  repeated int64 patientIds = 3;
}
```

# MARK 创建 随访、评估、自测、推送宣教都改为批量，patientIds


# 标签
## 获取标签

**GET /api/evans/v1/tags**

## 描述

返回 Tag 列表，包括：目前只有自建的
1. 科室自建Tag： Tag表里，TagType是MarkTag，DptId = current department 的所有tag。
2. 优护家提供的高频自然人 Tag。
3. 通过搜索获取 疾病树标签。见接口：*通过搜索获取自然人Tag*

## 接口详情

response:

```protobuf
message TagListDTO{
  optional Result result = 1;
  optional TagListData data = 1;
}

message TagListData{
  repeated Tag tag = 1;
}

message Tag{
  optional int64 id = 1;
  optional int32 type = 2;
  optional string name = 3;
  optional TagCategory tagCategory = 4;
}
message TagCategory{
  optional int64 id = 1;
  optional string name = 2;  //返回tag所在分组，
  repeated Tag tag=3;
}
```

# 通过搜索获取自然人 目前没有此接口

**GET /api/evans/v1/tags/disease?query={queryWords}**

## 描述

优护家的自然 tag 量级在两万左右，无法直接列出，只能通过搜索获取。圣阳的 TrieTree。

## 接口详情

Response:

```protobuf
message TagListDTO{
  //同上
} 
```

## 新建标签

**POST /api/evans/v1/tags**

## 描述

新建 Tag，TagType 固定为MarkTag。

## 接口详情

request：

```protobuf
message TagOpt{
  optional int64  categoryId = 1;
  optional string categoryName = 2;
  optional string tagName=3;
}
```

## 更新标签

**PATCH /api/evans/v1/tags/{tagId}**

## 描述

更新 Tag 的 name

## 接口详情

request：

```protobuf
message TagOpt{
  optional int64  categoryId = 1;
  optional string categoryName = 2;
  optional string tagName=3;
}
```

# 标签管理-删除标签

**DELETE /api/evans/v1/tags/{tagId}**

# 标签组的 List

**GET /api/evans/v1/tag-categories**

```protobuf
message TagCategoryListDTO {
  optional Result result = 1;
  optional TagCategoryListData data = 2;
}
message TagCategoryListData {
  repeated TagCategory tagCategory = 1;
}

message TagCategory{
  optional int64 id = 1;
  optional string name = 2;
  repeated Tag tag=3;
}
```
# 标签组的 Get

**GET /api/evans/v1/tag-categories/{id}**

```protobuf
message TagCategoryDetailDTO{
     optional Result result = 1;
     optional TagCategoryData data = 2;
}
message TagCategoryData {
  optional TagCategory tagCategory = 1;
}
message TagCategory{
  optional string id = 1;
  optional string name = 2;
}
message TagCategory{
  optional int64 id = 1;
  optional string name = 2;
  repeated Tag tag=3;         //用不到
}
```

# 标签组的 Create

**POST /api/evans/v1/tag-categories**
request:
```protobuf
message TagCategoryOpt {
  optional string name= 1;
}
```
response:
```protobuf
message TagCategoryDetailDTO{
   //同上
}
```

# 标签组的 Update

**PATCH /api/evans/v1/tag-categories/{id}**

```protobuf
message TagCategoryOpt {
  optional string name = 1;
}
```
response:
```protobuf
message TagCategoryDetailDTO{
   //同上
}
```
# 随访管理（关怀模板:随访模板 & 护理路径)

**GET /api/evans/v1/care-templates**

## 描述

拆为两个接口

页面中，**类型**为 **系统预设**？

随访无系统预设，（护理路径有系统预设、**待确认**）

# 随访模板的列表

**GET /api/nurses/followup/pages/templates/v2**

复用 RedCoast 的 [getFollowUpTemplateIndex](https://github.com/Youhujia/redcoast/blob/master/src/main/java/com/youhujia/redcoast/domain/template/FollowUpTemplateController.java#L42) 接口，需更新 Response

Response:

```protobuf
message TemplateIndexV2DTO{
    optional Result result = 1;
    optional FollowUpData data = 2;
}
message FollowUpData {
  repeated FollowUpDTO  followUpDTO=1;
}

message FollowUpDTO {
    optional int64 templateId = 1;
    optional string title = 2;
    repeated TemplateEventDetail event = 3;
}

message TemplateEventDetail {
    optional int64 days = 1;
    optional string purpose = 2;
    repeated TemplateArticle article = 3;
    repeated TemplateTool tool = 4;
}

message TemplateArticle {
    optional int64 id = 1;
    optional string title = 2;
}

message TemplateTool {
    optional int64 id = 1;
    optional string title = 2;
}

```

# 创建随访模板

**POST /api/nurses/followup/pages/templates/v2**

直接复用 RedCoast 的 [createFollowUpTemplate](https://github.com/Youhujia/redcoast/blob/master/src/main/java/com/youhujia/redcoast/domain/template/FollowUpTemplateController.java#L19) 接口，无需修改

Request:

```json
message FollowUpTemplateAddOption {
    optional int64 nurseId = 1;
    optional string title = 2;
    repeated TemplateEventAdd event = 3;
  
    message TemplateEventAdd {
      optional int64 days = 1;
      optional string purpose = 2;
      repeated int64 article = 3;
      repeated int64 tool = 4;
    }
}
```

Response:

```json
message message TemplateDTO {
    optional Result result = 1;
}
```



# 随访管理-修改随访模板 

**PATCH /api/nurses/followup/pages/templates/v2/{templateId}**

直接复用 RedCoast 的 [updateFollowUpTemplate](https://github.com/Youhujia/redcoast/blob/master/src/main/java/com/youhujia/redcoast/domain/template/FollowUpTemplateController.java#L31) 接口，无需修改。

## 描述

修改已有的随访模板

## 接口详情

Request：

```protobuf
//https://github.com/Youhujia/redcoast/blob/master/src/main/resources/followup.proto#L32
message FollowUpTemplateUpdateOption {
    optional int64 nurseId = 1;
    optional string title = 2;
    repeated TemplateEventAdd event = 3;
    optional int64 templateId = 4;
}

message TemplateEventAdd {
    optional int64 days = 1;
    optional string purpose = 2;
    repeated int64 article = 3;
    repeated int64 tool = 4;
}
```
Response:

```protobuf
message TemplateDTO {
    optional Result result = 1;
}
```



# 随访管理-删除随访模板 

**不做**

# 随访模板的详情

**GET /api/nurses/followup/pages/templates/v2/{id}**
[接口详情](https://github.com/Youhujia/redcoast/blob/master/src/main/java/com/youhujia/redcoast/domain/template/FollowUpTemplateController.java#L54)  response更新

## 接口详情

Request:
```protobuf
message TemplateIndexDTO {
    optional Result result = 1;
    repeated FollowUpData data = 2;  
}

message FollowUpData{
  optional FollowUpDTO followUp = 1;
}

message FollowUpDTO {
    optional int64 templateId = 1;
    optional string title = 2;
    repeated TemplateEventDetail event = 3;
}

message TemplateEventDetail {
    optional int64 days = 1;
    optional string purpose = 2;
    repeated TemplateArticle article = 3;
    repeated TemplateTool tool = 4;
}

message TemplateArticle {
    optional int64 id = 1;
    optional string title = 2;
}

message TemplateTool {
    optional int64 id = 1;
    optional string title = 2;
}

```

# 随访管理-创建护理路径 

**POST /api/evans/v1/care-routines**

## 描述

创建新的护理路径模板

## 接口详情


Request:
```protobuf
message CareRoutineOpt{
   repeated Tag tag = 1;
   optional int64 name = 2;
   optional string actionType = 3;   //动作类型
   optional int64  actionItemId = 4;    
   optional int64 day = 5;           //执行时间
}
```

Response:

```json
message CareRoutineDTO {
  optional Result result = 1;
  optional CareRoutineData data = 2;
}

message CareRoutineData{
  repeated CareRoutine careRoutine = 1;
}

message CareRoutine{
  optional string id = 1;
  optional string name = 2;
  repeated Tag tag = 3;
  
  optional int64 actionType = 4;//9：宣教 10：自测
  optional int64 actionItemId = 5;
  optional int64 actionItemName = 6;
  optional int64 executeDay = 7;
}

message Tag {
  optional int64 id = 1;
  optional int32 type = 2;
  optional string name = 3;  
}
```

# 随访管理-编辑护理路径

**PATCH /api/evans/v1/care-routines/{routineId}**

```json
message CareRoutineOpt{
   repeated Tag tag = 1;
   optional int64 name = 2;
   optional string actionType = 3;   //动作类型
   optional int64  actionItemId = 4;    
   optional int64 day = 5;           //执行时间
}
```

# 随访管理-获取护理路径 

**GET /api/evans/v1/care-routines/{routineId}**

## 描述

护理路径 = 标签 + 动作（固定）

## 接口详情

Response:

```protobuf
message CareRoutineDTO {
  optional Result result = 1;
  optional CareRoutineData data = 2;
}
```

# 随访管理-删除护理路径

**DELETE /api/evans/v1/care-routines/{routineId}**

# 科研

接口由圣阳提供，参考：http://wiki.office.test.youhujia.com/2017/04/08/tag-research-api/

# 项目名称

Mike`**Evans**, the core of Earth-Trisolaris Organization

# 项目结构

- com.youhujia.evans
   - domain
       - manager
           - home
               - HomeBO
               - HomeContext
               - HomeContextFactory
           - articles
               - articleBO
               - articleContext
               - articleContextFactory
           - tools
               - toolsBO
               - toolsContext
               - toolsContextFactory
           - nurse
               - nurseBO
               - nurseContext
               - nurseContextFactory
           - annocement(复用)
           - roster(复用)
           - evaluations
               - evaluationBO
               - evaluationContext
               - evaluationContextFactory
       - patients
           - patient
               - add
                   - addContext
                   - addContextFactory
                   - addBO
               - query
                   - queryBO
                   - queryContext
                   - queryContextFactory
               - delete
               - update
           - tag
               - add
               - query
               - delete
               - update
           - followUp
               - add
               - query
               - delete
               - update
       - researchs
           - research
               - add
               - query
               - delete
   - ManagerBO
      - ManagerController
   - EvansApplication

   # Kickoff





