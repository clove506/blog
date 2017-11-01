---
title: Trigger System 设计草稿
date: 2017-3-29 19:39:00
categories: Trigger
tags:
  - Trigger
---

# 摘要

Trigger System 设计草稿

<!-- more -->

# 关于

Trigger System 是一个动作触发系统。主要逻辑为检查动作的触发条件是否被满足，至于动作的具体执行，交给 NoStoryKindom， aka. ActionSystem。

# 动作

原子动作由 [NSK 系统](http://wiki.office.test.youhujia.com/2017/04/05/book_and_exec_action/) 定义，本系统中的 Action 和 NSK 中的 Action 概念上不完全等同，NSK 中的原子动作如下：

1. 通过微信模板消息发送文章和评估工具
2. 发短信
3. 打 Tag
4. 信息录入自然人系统
5. 评估结果生成 Tag

本系统中，也会对应规定以上动作（甚至 Enum 的编号也一样），但是以上这些动作包含了隐含信息：所有动作脚本定义时，都定义了除动作执行对象外的所有信息，而执行对象就是被打上该 Tag 的对象，一般为患者。

如果对应的底层原子动作相同，但是隐含信息不同，需要声明新的动作，例如：

通过微信模板消息发送当天最热文章，需要在本系统中新建一个 Action，此脚本建立时，就无需指定文章 id，将动态获取。

## 数据结构

Action Script 表，记录了动作脚本，特定条件触发后，将按此脚本执行动作。

| key            | desc              | possible value           |
| -------------- | ----------------- | ------------------------ |
| id             | id                | 1                        |
| name           | 动作脚本的名称           | 随访计划                     |
| content        | content of action | {动作脚本的具体内容，见下方实例}        |
| missing_args   | 待填写的参数            | {WX_TEMPLATE_USER_ID: 1} |
| creator_id     | 创建人 id            |                          |
| creator_dpt_id | 创建人科室 id          |                          |
| creator_org_id | 创建人机构 id          |                          |

## 数据表实例

| id   | name          | action script content                    | missing_args                             | desc                                |
| ---- | ------------- | ---------------------------------------- | ---------------------------------------- | ----------------------------------- |
| 1    | ActionScriptA | { sequence : [{**type: 1**, tool:[{id: 12, name: "脑震荡评估"}], article: [{id: 41, name: "脑子恢复"}], fireAt: {type: 1(immediatly)}},        {**type: 2**, content: {"title": "hi, nice to meet u", "body": "nice day~"}, fireAt: {type: 2(delay for n days), delayedDays: 7}},                          {**type: 3**, content: {"title": "hi, nice to meet u", "body": "nice day too~"}, fireAt: {type: 2(delay for n days), delayedDays: 14}}]} | WX_TMPL_USER_ID, SMS_PERSON_ID,  SMS_PERSON_TYPE | 分别执行微信提醒、短信通知和 app push，执行间隔为0，7，14 |

其中，action script content 展开如下：

```json
{
    sequence : [
        {
            **type: 1**,
            args : {
              WX_TMPL_ARTICLE_IDS : "1,2,3",
              WX_TMPL_TOOL_IDS : "31"
            },
            fireAt: {
                type: 1(immediatly)
            }
        },
        {
            **type: 2**,
            args: {
                SMS_CONTENT : "hi, nice to meet u"
            },
            fireAt: {
                type: 2(delayforndays),
                delayedDays: 7
            }
        },
        {
            **type: 3**,
            args: {
                SMS_CONTENT : "hi, nice to meet u 2"
            },
            fireAt: {
                type: 2(delayforndays),
                delayedDays: 14
            }
        }
    ]
}
```

# 触发条件

定义好动作脚本后，再定义动作脚本的触发条件，例如：当用户被加入科研分组 A 之后，执行特定动作脚本。

## 数据结构

### Trigger Rule （脚本被触发的条件）

| key                 | desc                | possible value                           |
| ------------------- | ------------------- | ---------------------------------------- |
| action_script_id    | id of action script | 1                                        |
| trigger rule        | 触发条件                | {operandA : "TagA", "operandB" : "TagB", "operator" : "AND"}，支持 AND、OR 、NOT。 |
| rule_creator_id     | 该触发条件的创建人 id        |                                          |
| rule_creator_dpt_id | 创建人的科室 id           |                                          |
| rule_creator_org_id | 创建人的组织 id           |                                          |

其中，ActionScript 的创建人和 Trigger Rule的不一定相同，例如，将来优护家可能提供预制的 ActionScript，而科室可以自定义 Trigger Rule。

TriggerRule 字段形如下（可递归定义）：

```json
{
  "operandA" : '{
    "operandA" : "TagFoo",
    "operandB" : "TagBar",
    "operator" : "AND"
  }',
  "operandB" : "TagBla",
  "operator" : "OR"
}
```

### Tag to ActionScript （条件到脚本的索引）

| key                  | desc                  | possible value        |
| -------------------- | --------------------- | --------------------- |
| tag_id               | 触发条件的id，这儿就是 tag 的 id | 1（Tag with id: 1）     |
| action_script_id     | 触发的动作脚本 id            | 1（id of ActionScript） |
| action_script_dpt_id | 动作脚本的创建科室 id          | 309脊柱                 |

## 举例

- Tag A 触发 ActionScript1
- Tag B 触发 ActionScript1
- Tag C & D 触发 ActionScript1
- Tag A & B & C 触发 ActionScript2

存放到数据库如下：

Action Script（动作脚本数据库）

| id   | content                    | creator_id | creator_dpt_id | creator_org_id |
| ---- | -------------------------- | ---------- | -------------- | -------------- |
| 1    | {content of ActionScript1} | 王二小        | 八路             | 共党             |
| 2    | {content of ActionScript2} | 胡汉三        | 地主             | 反动分子           |

Trigger Rule（动作脚本的触发条件表）

| id   | action_script_id  | rule        | rule_creator_id | rule_creator_dpt_id | rule_creator_org_id |
| ---- | ----------------- | ----------- | --------------- | ------------------- | ------------------- |
| 1    | 1 (ActionScript1) | {A}         | 王二小             | 八路                  | 共党                  |
| 2    | 1 (ActionScript1) | {B}         | 王二小             | 八路                  | 共党                  |
| 3    | 1 (ActionScript1) | {C & D}     | 王二小             | 八路                  | 共党                  |
| 4    | 2 (ActionScript2) | {A & B & C} | 胡汉三             | 地主                  | 反动分子                |

Tag to Action（触发条件 到 动作 的索引表）

| id   | tag_id | action_script_id | action_script_dpt_id |
| ---- | ------ | ---------------- | -------------------- |
| 1    | A      | 1                | 八路                   |
| 2    | B      | 1                | 八路                   |
| 3    | C      | 1                | 八路                   |
| 4    | D      | 1                | 八路                   |
| 5    | A      | 2                | 地主                   |
| 6    | B      | 2                | 地主                   |
| 7    | C      | 2                | 地主                   |

以上，当 Trigger System 收到 User Jack（八路） 被打上 TagA 的消息后，会检索 Condition to Action 表，找出所有 TagA 关联的且在相应 dpt 下的 action script id，此处为 1。

之后，根据 Trigger Rule 表，找出对应 script 的触发条件：{A}、{B} 和 {C & D}。

检查 UserJack 身上的 Tag，看是否存在满足条件的情况，如果有，则触发对应的 ActionScript。

具体的，在 Tag System 中，先检查 User Jack 是否存在 TagA 或 TagB 或 （TagC & Tag D），如果是，执行 ActionScript1。

**支持 tag 取消**

# Notes

1. push all add&remove tag action to trigger system
2. msg queue between Tag & Trigger System

# Code

```
  com.youhujia.trigger
      TriggerConsumer.java
          |=> public void consumeMsgFromMsgQueue();
      TagMsgProcessor.java
          |=> public void process(TagMsg tagMsg);
          |=> private List<ActionScript> getAllPossibleActionScript(long dptId, long tagId);
          |=> private List<ActionScript> getAllInvokedActionScript(long userId, List<ActionScript> possibleScripts);
          |=> private void fireActionScript(List<ActionScript> actionScripts);

      ActionScriptController.java
          |=> public ActionScriptDTO create(ActionScriptOpt actionScriptOpt);
          |=> public ActionScriptDTO update(ActionScriptOpt actionScriptOpt);
          |=> public ActionScriptDTO getById(long id);

      RuleController.java
          |=> public RuleDTO addRule(RuleOpt ruleOpt);
          |=> public RuleDTO updateRule(RuleOpt ruleOpt);
          |=> public RuleDTO getById(long id);


  需要在 halo 中提供公用方法，供 Tag System 发送消息到 redis 中
  
  com.youhujia.halo.trigger
      sendTagMsg(TagMsg tagMsg)
```

# Model

```protobuf
//a TagMsg is actually a Tag2ObjDTO without Result
message TagMsg {
  optional int64  id = 1;
  optional int64  tagId = 2;
  optional int32  tagType = 3;
  optional int64  objId = 4;
  optional int32  objType = 5;
  optional int64  objDptId = 6;
  optional int64  objOrgId = 7;
  optional int64  creatorId = 8;
  optional int64  creatorType = 9;
  optional int64  creatorDptId = 10;
  optional int64  creatorOrgId = 11;
}

// ActionScript
message ActionScriptOpt{
  optional string title = 1;
  optional string content = 2;
  optional int64 creatorId = 3;
  optional int64 creatorDptId = 4;
  optional int64 creatorOrgId = 5;
}
message ActionScriptDTO{
  optional int64  id = 1;

  optional string title = 2;
  optional string content = 3;
  optional int64 creatorId = 4;
  optional int64 creatorDptId = 5;
  optional int64 creatorOrgId = 6;
}

// TriggerRule
message TriggerRuleOpt{
  optional int64  actionScriptId = 1;
  optional string rule = 2;
  optional int64  creatorId = 3;
  optional int64  creatorDptId = 4;
  optional int64  creatorOrgId = 5;
}
message TriggerRuleDTO{
  optional int64  id = 1;

  optional int64  actionScriptId = 2;
  optional string rule = 3;
  optional int64  creatorId = 4;
  optional int64  creatorDptId = 5;
  optional int64  creatorOrgId = 6;
}
```

# DB

```sql
-- action_script
CREATE TABLE `action_script` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL COMMENT 'name of this action script',
  `content` VARCHAR(2048) NOT NULL COMMENT 'content of this action script, in JSON format, e.g.{sequence: [{type: 1, tool:[{id: 12, name: \"脑震荡评估\"}], article: [{id: 41, name: \"脑子恢复\"}], fireAt: {type: 1(immediatly)}},        {type: 2, content: {\"title\": \"hi, nice to meet u\", \"body\": \"nice day~\"}, fireAt: {type: 2(delay for n days), delayedDays: 7}},                          {type: 3, content: {\"title\": \"hi, nice to meet u\", \"body\": \"nice day too~\"}, fireAt: {type: 2(delay for n days), delayedDays: 14}}]}',
  `missingArgs` VARCHAR(1024) NULL COMMENT '脚本运行缺少的参数',
  `creator_id` BIGINT UNSIGNED NULL COMMENT '脚本创建人 id',
  `creator_dpt_id` BIGINT UNSIGNED NOT NULL COMMENT '脚本创建人的科室 id， 如果是优护家创建，设置为零。',
  `creator_org_id` BIGINT UNSIGNED NOT NULL COMMENT '脚本创建人的组织 id，如果是优护家创建，设置为零。',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));

-- trigger rule
CREATE TABLE `trigger_rule` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `action_script_id` BIGINT UNSIGNED NOT NULL COMMENT '动作脚本的 id',
  `trigger_rule` VARCHAR(2048) NOT NULL COMMENT '动作的触发条件，JSON 格式：\n{\n  \"pre\": {\n    \"pre\": \"2\",\n    \"op\": \"∩\",\n    \"post\": \"5\"\n  },\n  \"op\": \"∪\",\n  \"post\": {\n    \"pre\": \"6\",\n    \"op\": \"∩\",\n    \"post\": \"1\"\n  }\n}',
  `rule_creator_id` BIGINT UNSIGNED NULL COMMENT '触发条件的创建人 id',
  `rule_creator_dpt_id` BIGINT UNSIGNED NOT NULL COMMENT '触发条件的创建人的科室 id, 如果是优护家创建，设置为零。',
  `rule_creator_org_id` BIGINT UNSIGNED NOT NULL COMMENT '触发条件的创建人的组织 id, 如果是优护家创建，设置为零。',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`))
COMMENT = '动作脚本的触发条件';

-- tag_2_action
CREATE TABLE `tag_2_action` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `tag_id` BIGINT UNSIGNED NOT NULL COMMENT 'id of tag',
  `action_script_id` BIGINT UNSIGNED NOT NULL COMMENT 'id of action_script',
  `action_script_dpt_id` BIGINT UNSIGNED NOT NULL COMMENT 'id of action_script_dpt',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`))
COMMENT = 'tag 到 action_script 的索引表，如果存在一行记录，表示此 tag 以某种形式关联给定的 action_script';
```

# Todo

Tag 动作的重复触发

1. 在 ActionScript 中规定是否可以重复触发
2. Tag 可否重复打在同一个 object 上
3. 死循环的处理

# Changelog

* 20170415 	

  * 明确了动作的执行放在 NSK 中
  * 明确了 TriggerRule 字段的样式
  * ActionScript 里，需要给出本script 缺少的参数

  ​