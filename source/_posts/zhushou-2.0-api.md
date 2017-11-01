---
title: 优护助手 API
date: 2017-4-14 14:16:00
categories: zhushou
tags:
  - zhushou
---

# 摘要

优护助手 API，项目复用 Galaxy

产品设计：http://wiki.office.test.youhujia.com/2017/03/22/2017-03-22/

<!-- more -->

# 类图

![](http://ww1.sinaimg.cn/large/006tNbRwgy1feplwonl05j30zv0qr0x0.jpg)

[原链](http://ww3.sinaimg.cn/large/006tKfTcgy1fegincdgp4j30zg0qm42q.jpg)

## 本次用到的protoc

https://github.com/Youhujia/docs/wiki/Protobuf-for-Zhushou-2.0-API

# 登录（新接口）

新的护士流程需要分三步走：
1. 发送手机验证码
2. 提交手机号和验证码进行登录，会返回 角色 ID 和 TOKEN
3. 通过第2步中获取到的 ID 和 TOKEN 请求 getNurseById 获取护士详情

具体接口分别如下：

## 登录 API

### 1. 发送手机验证码

> POST /api/yolar/v3/captcha/phone

* Request `SendPhoneCaptchaOption`

  ```protobuf
  message SendPhoneCaptchaOption {
    optional string phone = 1;
  }
  ```

* Response protobuf `COMMON.SimpleResponse`

### 2. 提交手机号和验证码进行登录

> POST /api/yolar/v3/login/phone-captcha

* Request protobuf

  ```protobuf
  enum LoginRole {
    ADMIN = 0;
    USER = 1;
    NURSE = 2;
  }

  message PhoneCaptchaLoginOption {
    optional string phone = 1;
    optional string captcha = 2;
    optional LoginRole loginRole = 3;
  }
  ```

* Response protobuf

  ```protobuf
  message SimpleLoginDTO {
    optional Data data = 1;
    message Data {
        optional string token = 1;
        optional int64 id = 2;
        optional LoginRole loginRole = 3;
        optional string redirectUrl = 4;
    }
    optional Result result = 2;
  }
  ```

# 退出

**POST /api/yolar/v3/logout**

+ Request

  ```
  message SimpleLogOutOption {
      optional int64 id = 1;
      optional LoginRole loginRole = 2;
  }
  ```

+ Response

  ```
  message SimpleResponse
  ```

# 护士列表

GET /api/galaxy/v1/nurses/{nurseId}/colleagues

+ Response

  ```
  message NurseListDTO {
      optional Result result = 1;
      repeated Nurse nurse = 2;
  }
  ```

# 获取护士详情

> GET /api/galaxy/v1/nurses/{nurseId}/info

* Response protobuf `NurseInfoDTO`

  ```protobuf
  message NurseDTO {
      optional Result result = 1;
      optional Nurse nurse = 2;
  }
  ```

# 更新护士详情

PATCH /api/galaxy/v1/nurses/{nurseId}/info

+ Request

  ```protobuf
  message NurseInfoOption {
      optional NurseBasic basic = 1;
      optional NurseOccupation occupation = 2;
  }

  message NurseBasic {
      optional int64 id = 1;
      optional string name = 2;
      optional string avatarUrl = 3;
      optional string phone = 4;
      optional string authorizedName = 5;
      optional int64 authorizedStatus = 6;
      optional int64 organizationId = 7;
      optional string organizationName = 8;
      optional int64 departmentId = 9;
      optional string departmentName = 10;
      optional string professionalTitle = 11;
      optional string qrImgUrl = 12;
      optional string identifier = 13;
      optional int64 createdAt = 14;
      optional int64 updatedAt = 15;
      optional bool active = 16;
  }
  message NurseOccupation {
      optional string IDNumber = 1;
      optional string certs = 2;
      optional string photocopy = 3;
  }
  ```

+ Response

  ```protobuf
  message SimpleResponse
  ```

  # 创建护士信息到访客科室

  PATCH /api/galaxy/v1/nurses/{nurseId}/create-info-in-guest-department

  + Request

    ```protobuf
    message NurseInfoOption {
        optional NurseBasic basic = 1;
        optional NurseOccupation occupation = 2;
    }

    message NurseBasic {
        optional int64 id = 1;
        optional string name = 2;
        optional string avatarUrl = 3;
        optional string phone = 4;
        optional string authorizedName = 5;
        optional int64 authorizedStatus = 6;
        optional int64 organizationId = 7;
        optional string organizationName = 8;
        optional int64 departmentId = 9;
        optional string departmentName = 10;
        optional string professionalTitle = 11;
        optional string qrImgUrl = 12;
        optional string identifier = 13;
        optional int64 createdAt = 14;
        optional int64 updatedAt = 15;
        optional bool active = 16;
    }
    message NurseOccupation {
        optional string IDNumber = 1;
        optional string certs = 2;
        optional string photocopy = 3;
    }
    ```

  + Response

    ```protobuf
    message NurseDTO
    ```


# 通过 SMS 邀请

POST /api/galaxy/v1/nurses//{nurseId}/invite-via-sms

+ Request

  ```protobuf
  message InviteViaSMSOption {
      optional string phone = 1;
      optional string msg = 2;
  }
  ```

+ Response

  ```protobuf
  message SimpleResponse
  ```

# 护士所在的所有科室

GET /api/galaxy/v1/nurses//{nurseId}/get-all-departments

+ Response

  ```protobuf
  message DepartmentListDTO {
      optional Result result = 1;
      repeated Department department = 2;
  }

  message Department {
      optional int64 departmentId = 1;
      optional string name = 2;
      optional int64 organizationId = 3;
      optional string organizationName = 4;
      optional string number = 5;
      optional string authCode = 6;
      optional int64 status = 7;
      optional int64 createdAt = 8;
      optional int64 updatedAt = 9;
      optional bool isGuest = 10;
      optional int64 hostId = 11;
      optional string wxQrcode = 12;
      optional string imgUrl = 13;
      optional string mayContact = 14;
      optional string classificationType = 15;
  }
  ```

# 切换科室

POST /api/galaxy/v1/nurses/{nurseId}/change-department

+ request

  ```
  message ChangeDepartmentOption {
      optional int64 nurseId = 1;
      optional int64 fromDepartmentId = 2;
      optional int64 toDepartmentId = 3;
  }
  ```

+ Response

  ```
  message NurseDTO
  ```

# 患者 Tag

## 去掉 Tag

**POST /api/galaxy/v1/users/{userId}/tags/delete**

- Request

```protobuf
message DeleteUserTagOpt {
    repeated Tag tag = 1;
    optional int64 userId = 2;
}
```

- Response:

```protobuf
message DeleteTagDTO{
    optional Result result = 1;
}
```

## 更新 Tag

PATCH /api/galaxy/v1/users/{userId}/tags

- Request

```protobuf
message UpdateTagsOnUserOpt {
    repeated Tag tag = 1;
    optional int64 userId = 2;
}
```

- Response

```protobuf
message UserDTO
```











# 日程(复用老接口)

### 获取全部日常提醒页信息（不包括公告）

**GET /api/nurses/calendars/messagePage**
[具体接口](https://github.com/Youhujia/galaxy/blob/master/src/main/java/com/youhujia/galaxy/domain/calendar/CalendarController.java#L39)

```protobuf
message MessageCenterDTO {
  optional Result result = 1;
  repeated MessageCenterEventDTO today = 2;  //今日日程
  repeated MessageCenterEventDTO future = 3;  //近期的日程

  optional bool new = 6;
}

message MessageCenterEventDTO {
  optional int64 eventId = 1;
  optional int64 type = 2;//1：随访，2：排班，5：评估

  optional string title = 3;
  optional int64 status = 4;
  optional int64 startTime = 5;
  optional int64 endTime = 6;
  optional string content = 7;
}
```

#### 注：日程列表多了一种type -> 评估

# 公告(复用老接口)

## 添加公告

**POST /api/nurses/calendars/events/announcement/v1**  

[具体接口](https://github.com/Youhujia/galaxy/blob/master/src/main/java/com/youhujia/galaxy/domain/calendar/CalendarController.java#L56)

Request:

```protobuf
message AnnouncementEventAddOption {
  optional string title= 1;
  optional int64 startTime = 2;
  optional int64 day = 3;
  optional string content = 4;
  optional int64 nurseId = 5;
}
```

Response:

```protobuf
message AnnouncementEventAddDTO {
 optional Result result = 1;
}

```

## 更新公告

**PATCH /api/nurses/calendars/events/announcement/v1/{id}**

[具体接口](https://github.com/Youhujia/galaxy/blob/master/src/main/java/com/youhujia/galaxy/domain/calendar/CalendarController.java#L94)

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

## 获得单个公告

**GET /api/nurses/calendars/events/announcement/v1/{id}**

[具体接口](https://github.com/Youhujia/galaxy/blob/master/src/main/java/com/youhujia/galaxy/domain/calendar/CalendarController.java#L112)

```protobuf
message AnnouncementEventDTO{
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

  message ReadPerson{
    optional string name = 1;
    optional string avatarUrl = 2;
    optional int64 nurseId = 3;
  }
  message Nurse{
    optional string name = 1;
    optional int64 nurseId = 2;
  }
}
```

## 获得所有公告

**GET /api/nurses/calendars/events/announcements/v1**

```protobuf
message AnnouncementQueryDTO {
  optional Result result = 1;
  repeated Announcement announcement = 2;
}

message Announcement {
  message ReadPerson{
    optional string name = 1;
    optional string avatarUrl = 2;
    optional int64 nurseId = 3;
  }
  message Author{
    optional string name = 1;
    optional int64 nurseId = 2;
  }
  optional int64 id = 1;
  optional Author name = 2;
  optional string title = 3;
  optional string content = 4;
  optional int64 startTime = 5;
  optional int64 endTime = 6;
  repeated ReadPerson readPerson = 7;
  optional int64 updateAt = 8;
  optional int64 departmentNurseNum = 9;
  optional bool isExpireAnnouncement = 10;
}
```

# 排班

## 获得单个排班信息

**GET /api/nurses/calendars/events/roster/{id}**

[具体接口](https://github.com/Youhujia/galaxy/blob/master/src/main/java/com/youhujia/galaxy/domain/calendar/CalendarController.java#L152)

```protobuf
message RosterEventDTO {
 optional Result result = 1;
 optional int64 eventId = 2;
 optional int64 rosterId = 3;
 optional string title = 4;
 optional int64 startTime = 5;
 optional int64 endTime = 6;
 optional int64 alertTime = 7;
}
```

# 随访(复用老接口)

## 获得单个随访信息

**GET /api/nurses/calendars/events/followup/{id}**

[具体接口](https://github.com/Youhujia/galaxy/blob/master/src/main/java/com/youhujia/galaxy/domain/calendar/CalendarController.java#L132)

```protobuf
message FollowUpEventDTO {
  optional Result result = 1;
  optional Target target = 2;
  optional string title = 3;
  repeated Event event = 4;

  message Target {
    optional int64 personId = 1;
    optional string avatar = 2;
    optional string name = 3;
    repeated Tag tag = 4;

    message Tag {
      optional int64 tagId = 1;
      optional string tagName = 2;
    }
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
    optional Brief brief = 9;
    optional WeChat wechat = 10;
    optional ProEvalAction proEvalAction = 11;

    message Brief {
      optional int64 actionId = 1;
      optional string content = 2;
    }
    message WeChat {
      optional int64 actionId = 1;
      optional int64 status = 2;
      optional WeChatContent content = 3;

      message WeChatContent {
        repeated Article article = 3;
        repeated Tool tool = 4;
        optional WeChatMsg msg = 5;

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
      }
    }
  }
}

message WeChatMsg {
  optional string url = 1;
  optional WXTemplateMsg wxTemplateMsg = 2;

  message WXTemplateMsg {
    optional int64 templateId = 1;
    optional Content content = 2;
    optional int64 from = 3;
    optional int64 to = 4;

    message Content {
      optional string welcome = 1;
      optional string title = 2;
      optional string purpose = 3;
      optional string content = 4;
      optional string date = 5;
      optional string detailDesc = 6;
    }
  }
}

message ProEvalAction {
    optional int64 actionId = 1;
    optional int64 status = 2;

    optional EvaluateSection contentSectionOfEval = 3;
}

//copied from sophon.proto in halo
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

## 更新随访信息

**PATCH /api/nurses/calendars/events/followup/{id}**

[具体接口](https://github.com/Youhujia/galaxy/blob/master/src/main/java/com/youhujia/galaxy/domain/calendar/CalendarController.java#L172)

```protobuf
message FollowUpEventUpdateOption {
  optional int64 eventId = 1;
  optional string purpose = 2;
  optional Brief brief = 3;
  optional WeChat wechat = 4;
  optional int64 status = 5;
  optional int64 nurseId = 6;

  optional ProEvalAction proEvalAction = 7;

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
message FollowUpEventUpdateDTO {
    optional Result result = 1;
}
```

# 获取评估任务详情

**GET /api/nurses/calendars/events/pro-eval/{eval-event-id}**

+ Response

```java
message ProEvalEventDTO {
    optional Result result = 1;

    optional int64 eventId = 2;
    optional int64 nurseId = 3;
    optional int64 patientId = 4;
    optional int64 status = 5;
    optional EvaluateSection evalSection = 6;
}
```

# 通知中心 和 服务信息Mark

通过 push 下发相关信息，客户端自己收纳。

push 的消息格式:

```json
"content":{
"payloads":[{
  "type" : 1, // type of msg, 4: service, 1: followup, 5: evaluation
  "id" : 123, // id of given item
  "detail" : {
    //service
    "serviceName" : "鼻饲-代购物品-1次",
    "patientInfo" : "{'name':'李丽仪','gender':1,'age':40,'id':666}",
    "content" : "您有一个订单即将开始",

    //followup & evalution
    "title" : "李丽仪的第二次随访",
    "ts" : 1234323423123,
    "content" : "您有一个随访即将开始"
  }
}]
}
```

# 工作台(这次这个接口不被使用)

通知中心：随访、评估、~~日程提醒~~、护理路径通知（宣教、自测）

**GET /api/zhushou/v1/workbench**

```protobuf
message WorkBenchOptionDTO{
  message WorkBenchOptionItem{
    optional string iconUrl = 1;	//icon
    optional string title = 2;
    optional int32 type = 3;        //1： 评估，2：自测
    optional string url = 4;
  }

  optional Result result = 1;
  repeated WorkBenchOptionItem workBenchOptionList = 2;
}
```

# QR Code

**GET /api/galaxy/v1/my-qrcode?nurseId={nurseId}**

```protobuf
message QrCodeDTO{
  optional Result result = 1;
  optional string imgUrl = 2;  // 二维码url
}
```

# 添加患者

**POST /api/galaxy/v1/patients**

Request:

```protobuf
message PatientOpt{
  optional string name = 1;
  optional int64 gender = 2;// 0：女，1：男
  optional int64 birthday = 3;
  optional string idCard = 4;
  optional string phoneNumber = 5;
  optional int64 nurseId = 6; // 创建者id
}
```

Response:

```protobuf
message CommonResponseDTO{
  optional Result result = 1;
}
```

# 发起评估

**POST /api/galaxy/v1/evaluations/init**

Request:

```protobuf
message InitEvaluation{
    optional int64 patientId = 1;
    optional int64 evaluationTableId = 2;
    //optional int64 itemId = 3;
    optional int64 nurseId = 4;
    optional int64 servingTime = 5;
}
```

Response:

**用上面的返回值CommonResponseDTO**

# 评估量表库a

**GET /api/galaxy/v1/evaluations**

按（组-》评估）的结构返回

Response:

```protobuf
message EvaluateGroupListDTO{
  message EvaluateItem{
    optional string title = 1;
    optional int64 itemId = 2;
  }
  message EvaluateGroup{
    repeated EvaluateItem evaluateGroup = 1;
    optional string title = 2;
  }

  optional Result result = 1;
  repeated EvaluateGroup evaluateList = 2;
}
```

# 自测量表库

**GET /api/galaxy/v1/self-tests**

返回数据结构同上，只是具体数据不同，上面接口返回评估，本接口返回自测

# 获取评估可选时间

**GET /api/galaxy/v1/evaluation-times**

```protobuf
message ServiceTimeDTO{
  repeated ServiceTime serviceTime=1;
  optional Result result = 2;

  message Time{
    optional int64  detailTime = 1;
    optional string title = 2;
  }

  message ServiceTime{
    optional string  date = 1;
    optional string weekdays = 2;
    repeated Time time = 3;
  }
}
```

# 评估表详情M

**GET /api/galaxy/v1/evaluations/{evalutionId}**

*本期客户端直接使用 web 页面展示评估相关内容，所以这个接口实际使用者为 web 端。*

返回评估的所有信息，客户端自己处理不同页面下的不同展现形式，例如：查看评估量表的概要、试做评估等等。

**todo: structure of evaluation level ?**

```protobuf
message EvaluationDTO{
  optional Result result = 1;

  optional int64 id = 2;
  optional string name = 3;
  optional int64 departmentId = 4;
  optional int32 type = 5; //1: 评估 2：自测
  optional int64 iconId = 6;
  optional string iconColor = 7;
  repeated QuestionBundle questionBundle = 8;

  message QuestionBundle{
    optional string name = 1;
    repeated Question question = 2;
    repeated QuestionBundleAnalysis analysis = 3;// question_bundle_analysis
  }

  message Question{
    optional int64 id = 1;
    optional int32 type = 3;//enum todo 单选、多选、填空
    optional string content = 2;
    optional bool required = 4;

    repeated QuestionOption questionOption = 5;
  }

  message QuestionBundleAnalysis{
    optional int64 id = 1;
    optional string condition = 2; //判断条件
    optional string analysis = 3; //分析结论
  }

  message QuestionOption{
    optional int64 id = 1;
    optional string content = 2;
  }
}
```

# 提交评估M

**POST /api/galaxy/v1/evaluations/{evaluationId}**

todo: 单独发起评估 和 执行已有评估的区别

Request:

```protobuf
message SubmitEvaluation{
    optional int64 userId = 1;
    optional int64 evaluationId = 2;
    optional string content = 3; //  [{“question_bundle_id”: 1, “submit”: [{question_id”: 1, “question_option_id”: }] }] 单选 [option_id], 多选 [option_id, option_id], 填空题 ['Foo', 'Bar', 'Baz']
    optional string comment = 4
    ;
}
```

Response:

```protobuf
message EvaluationResultDTO{
  //见下
}
```

# 查看评估结果

**GET /api/galaxy/v1/evaluations/{evaluationId}/{evaluationSubmitId}**

```protobuf
message EvaluationResultDTO{
    //todo diff seq of 1 & 2, may cause error of protobuf merge
    optional Result result = 1;

    optional int64 recordId = 2;
    optional int64 submitorId = 3;
    optional int64 submitorType = 4;
    optional int64 departmentId = 5;
    optional string departmentName = 6;
    optional int64 organizationId = 7;
    optional string organizationName = 8;
    optional int64 evaluationId = 9;
    optional string evaluationName = 10;
    optional string conclusion = 11;
    repeated QuestionAnswer answer = 12;
    optional string iconColor = 13;
    optional string icon = 14;
    optional int64 updatedAt = 15;

    message QuestionAnswer {
        optional string questionType = 1;//http://wiki.office.test.youhujia.com/2017/04/17/enum#QuestionTypeEnum-Civil
        optional string questionContent = 2;
        optional string questionDesc = 3;
        repeated string questionDescPicUrl = 4;
        repeated SingleChoice singleChoice = 5;
        repeated MultiChoice multiChoice = 6;
        repeated Completion completion = 7;
        repeated SingleChoiceMatrix singleChoiceMatrix = 8;
        optional int64 order = 9;

        message SingleChoice {
            optional string choice = 1;
        }

        message MultiChoice {
            optional string choice = 1;
        }

        message Completion {
            optional string content = 1;
            optional string format = 2;
        }

        message SingleChoiceMatrix {
            message OptionContent {
                optional int64 rank = 1;
                optional string content = 2;
                repeated string choice = 3;
            }
            optional OptionContent optionContent = 1;
        }
    }
}
```

# 健康宣教列表M @shawn, ArticleGroup 的结构存储在？

**GET /api/galaxy/v1/articles**

```protobuf
message ArticleGroupListDTO{
  message ArticleGroup{
    optional string title = 1;
    repeated ArticleInfo articleInfo = 2;
  }

  message ArticleInfo{
    optional string title = 1;
    optional int64 articleId = 2;
  }

  optional Result result = 1;
  repeated ArticleGroup articleGroup = 2;
}
```

# 健康宣教详情

**GET /api/galaxy/articles/{aritcleId}**

```protobuf
message ArticleDTO{
    optional Result result = 12;

    optional int64 id = 1;
    optional string name = 2;
    optional string brief = 3;
    optional string author = 4;
    optional int64 status = 5;
    optional string content = 6;
    optional string bannerUrl = 7;
    optional int64 articleTypeId = 8;//todo
    optional int64 licenseId = 9;
    optional int64 createdAt = 10;
    optional int64 updatedAt = 11;
}
```

# 患者列表

**GET /api/galaxy/v1/users**

```protobuf
//originally used by Era, moved here
message UsersClassfiedByTitleDTO {
    optional Result result = 1;
    repeated NameGroup user = 2;

    message NameGroup {
        optional string title = 1;
        repeated UserInfoWithTags member = 2;
    }

    message UserInfoWithTags {
        optional User user = 1;
        repeated Tag tag = 2;
    }
}

//https://github.com/Youhujia/halo/blob/develop/src/main/resources/yolar.proto#L121
message User {
    optional int64 userId = 1;
    optional string nickname = 2;
    optional string realname = 3;
    optional string avatarUrl = 4;
    optional int64 gender = 5;
    optional int64 birthday = 6;
    optional string idCard = 7;
    optional string phone = 8;
    optional int64 status = 9;
    optional string token = 10;
    optional string flag = 11;

    repeated UserAddress userAddress = 12;

    optional string openid = 13;
    optional string accessToken = 14;
    optional string unionid = 15;

    optional int64 createdAt = 16;
    optional int64 updatedAt = 17;
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
message Address {
    optional string province = 1;
    optional string city = 2;
    optional string district = 3;
    optional string addressDetail = 4;
}

//https://github.com/Youhujia/halo/blob/develop/src/main/resources/hdfragments.proto#L40
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
    optional int32  creatorType = 21;
    optional int64  dptId = 22;
    optional int64  orgId = 23;
    optional bool   isLeaf = 24;
    optional int64  createdAt = 25;
    optional int64  updatedAt = 26;
}
```

# 患者详情页

**GET /api/galaxy/v1/users/{userId}**

```protobuf
message UserDTO{
  optional Result result = 1;

  optional int64 id = 2;
  optional string name = 3;
  repeated Tag tag = 4;
  optional string url = 5;

  message Tag{
    optional int64 id = 1;
    optional int32 type = 2;//1: 自然人指标, 5: 护士创建标记标签, etc
    optional string name = 3;
  }
}
```

# 患者标签详情
**GET /api/galaxy/v1/users/{userId}/tag-category**

```protobuf
message TagCategory{
  optional Result result = 1;
  repeated Category category = 2;

  message Category{
    optional int64 id = 1;
    optional int64 type = 2;
    optional string name = 3;
    repeated Tag tag = 4;
  }
  message Tag{
    optional int64 id = 1;
    optional int64 type = 2;//1: 自然人指标, 5: 护士创建标记标签, etc
    optional string name = 3;
    optional bool isSelected = 4;
  }
}
```

# 康复护理记录(患者的)

**GET /api/galaxy/v1/care-records?patientId={patientId}**

[设计](http://owncloud.youhujia.com/index.php/s/DB62syhOYFXsaMa)

**NOTE: 需要更新 Sophon 的 Plan Table，添加字段：targetId & targetType，用来查找执行对象是患者的 Plan**

```protobuf
//M 康复护理记录
message NursingRecordDTO {
    message NursingRecordItem {
        optional int64 id = 1;//task id
        optional int64 type = 2; // 1：随访 5:评估
        optional int64 timestamp = 3;
        optional string iconUrl = 4;
        optional string title = 5;
        repeated NursingRecordDetailItem itemList = 6;
    }

    message NursingRecordDetailItem {
        optional long id = 1;//id of given type, rst id of self & pro eval
        optional long type = 2; //2: SelfEval in FOLLOWUP_WECHAT; 7: GENERAL_EVALUATE
        optional string title = 3;
        optional string content = 4; //{"evalId": 111}
    }

    optional Result result = 1;
    repeated NursingRecordItem nursingRecordList = 2;
}
```

# 我的工作记录Mark

**GET /api/galaxy/v1/work-records**

[设计](http://owncloud.youhujia.com/index.php/s/1edcSaMVegmFC2s)

```protobuf
message WorkRecord{
  optional Result result = 1;
  repeated Record record = 2;

  message Record{
    optional int64 id = 1;
    optional int32 type = 2;// 1：随访 5:评估 6：自测
    optional string content = 3;
    optional int32 status = 4;
    optional int64 timestamp = 5;
  }
}
```


# 提交反馈

**POST /api/galaxy/v1/feedback**

```protobuf
message FeedbackSubmit{
  optional string content = 1;
  optional string contact = 2;
  optional string appVersion = 3; // auto get by app, version of our app
  optional string device = 4; // auto get by app, xiaomi, huawei, etc
  optional string os = 5; // auto get by app, android or iOS
}
```

Response:

```protobuf
message SimpleResponse{
  optional Result result = 1;
}
```

# 项目排期

| 工作内容           | 内容详情 | 人日   |
| -------------- | ---- | ---- |
|                |      |      |
| 获得护士的微信二维码     | 查    | 0.1  |
|                |      |      |
|                |      |      |
| **获得所有的评估量表**  | 查    | 0.75 |
| 根据Id获得某一个评估量表  | 查    | 0.25 |
| 获得评估量表的时间的List | 查    | 0.1  |
|                |      |      |
| **发起评估**       | 增    | 0.25 |
| 提交评估结果         | 增    | 0.25 |
| 查看评估结果         | 查    | 0.5  |
|                |      |      |
| 文章列表           | 查    | 1    |
| 文章详情           | 查    | 0.25 |
| 发送宣教           | 增    | 0.25 |
|                |      |      |
| **手动创建患者**     | 增    | 0.5  |
| 查看某一个患者的详细信息   | 查    | 0.25 |
| 查看患者的tag详情     | 查    | 0.25 |
| 查看患者的康复护理记录    | 查    | 1    |
|                |      |      |
| 提交反馈           | 增    | 0.25 |
|                |      |      |
| 护士的工作记录        | 查    | 0.5  |
|                |      |      |
| 测试             |      | 3    |

# Kickoff会议记录

1. ~~MsgCenter rm duplicate fields~~
2. ~~日程里添加评估（total 3种）~~
3. ~~日程里无服务订单（暂定没有）~~
4. 定义好各种 type status 的值
5. 需要添加排班的交互
6. 随访（老接口）中添加 评估+自评 的字段
7. ~~通知中心 & 服务信息 restore wiki content~~
8. 评估自测的H5渲染，需要前端出人：shaojie
9. ~~1-2-13评估结果页 页面有错误，应该为评估，而非自测~~
10. ~~发送宣教接口，删除，通过IM发送~~
11. 患者详情页 缺头像
12. 患者详情页不需要接口，列表页有全部信息。列表页需要更新，Tag逻辑
13. 患者标签详情页，现在列出的待选标签是科室自建 + 优护家自建
14. 患者标签详情页，打标签。对前端是旧接口，但是后端需要更新标签相关的逻辑
15. ~~康复护理记录，暂不分页，默认半年~~
16. 我的工作记录（需确认有无订单）
