---
title: 动作执行系统
date: 2017-4-5 16:00:00
categories: foundation
tags:
  - foundation
---

# 摘要

动作执行系统

<!-- more -->

# 背景

需要把系统支持的基本动作抽离出来，供其他业务组合使用。

# 基本动作

1. 通过微信模板消息发送文章和评估工具
2. 发短信
3. 打 Tag
4. 信息录入自然人系统
5. 根据评估结果，给患者生成 Tag
6. ~~对护士发 app push，参数：(nurseId，content)~~
7. ~~对护士添加**日程**，参数：（?）~~

![Atom Actions we need to support](http://ww4.sinaimg.cn/large/006tKfTcgy1fe9fgbqtyij31kw16ou0x.jpg)

# 名词定义

上下文信息： 执行动作组合的参数信息，形式为 string 类型的 k-v map。

# 调用方式

当业务方需要调用组合动作时，通过消息的形式，发送上下文信息（以 key-value形式）和希望调用的动作类型到本系统即可。

# 系统实现

![todo](http://ww2.sinaimg.cn/large/006tKfTcgy1fe9iqkxwjgj31kw0spu0x.jpg)

```java
class ActionContext{
  Map<String, String> args;
  Long actionType;
}

abstract class AbsAction{
  public void invoke(Map<String, String> args);
}

//impl class of AbsAction
class WxTemplateAction extends AbsAction{
  public enum Args{
    WX_TMPL_USER_ID,
    WX_TMPL_ARTICLE_IDS,
    WX_TMPL_TOOL_IDS,
    FIRE_AT 
  }
}
class SMSAction extends AbsAction{
  public enum Args{
    SMS_PERSON_ID,
    SMS_PERSON_TYPE,
    SMS_CONTENT,
    FIRE_AT
  }
}
class TaggingAction extends AbsAction{
  public enum Args{
    TAGGING_OBJ_ID,
    TAGGING_OBJ_TYPE,
    TAGGING_TAG_ID,
    FIRE_AT
  }
}
class LoggingHumanInfoAction extends AbsAction{
  public enum Args{
    HUMANINFO_IN_JSON,,
    FIRE_AT
  }
}
class EvaluationResultAction extends AbsAction{
  public enum Args{
    EVAL_TOOL_ID,
    EVAL_RESULT_ID,
    FIRE_AT
  }
}

//! Entry of Application
class ActionMsgConsumer{
  public void consumeMsgFromRedis(){
    Iterator<String> msgIter = getMsgFromRedis();

    while(msgIter.hasNext()){
      msgProcessor.process(msg);
    }
  }
}

class ActionMsgProcessor{
  public void process(String msg){
    ActionContext actionCtx = ActionFactory.buildContextFromMsg(msg);

    AbsAction action = ActionFactory.getActionByType(actionCtx.getActionType);
    action.invoke(actionCtx.args);
  }
}

class ActionFactory{
    public ActionContext buildContextFromMsg(String msg);
    public AbsAction getActionByType(long actionType);
}
```

# 举例

自评业务需要在完成自己的业务之外，调用本系统，完成以下动作：

1. 根据评估结果，给患者生成 Tag。
2. 给对应的执行护士发送短信提醒，告知自评已被完成。

## 1. 业务方在执行完业务后，发送消息给本系统

```java
//业务逻辑
EvalResult evalResult = EvalService.finish(evalToolId, userInputs);

//Eval
Map<String, String> evalArgs = new HashMap<>();
evalArgs.put(EvaluationResultAction.Args.EVAL_TOOL_ID, evalToolId);
evalArgs.put(EvaluationResultAction.Args.EVAL_RESULT_ID, evalResult.id);
sendActionMsg(evalArgs, ActionTypeEnum.EVAL);

//smsArgs
Map<String, String> smsArgs = new HashMap<>();
smsArgs.put(SMSAction.Args.PERSON_ID, personId);
smsArgs.put(SMSAction.Args.PERSON_TYPE, RoleEnum.USER);
smsArgs.put(SMSAction.Args.CONTENT, evalResult.summary);
sendActionMsg(smsArgs, ActionTypeEnum.SMS);
```

## 2. 消息处理

本系统接收消息，进行处理，流程如下：

1. 对于接收到的消息，检查触发时间字段，并按定义的时间投递到延时队列。
2. 系统不断从队列中消费消息。
   1. 消费到第一条消息，对应的 Action 实例为：EvaluationResultAction，实例化之。
   2. 从 ActionContext.args 中找到参数 EVAL_TOOL_ID & EVAL_RESULT_ID，依此执行，检查是否需要打 Tag。
   3. 消费到第二条消息，为 SMSAction，同上，实例化该 Action，之后按 args 进行执行。


# 类设计

## Nsk（No Story Kingdom）
```
com.youhujia.nsk.domain
├── action
│   ├── ActionContext.java
│   ├── ActionFactory.java
│   ├── ActionProcessor.java
│   └── actionType
│       ├── Action.java
│       ├── EvaluationResultAction.java
│       ├── LoggingHumanInfoAction.java
│       ├── SMSAction.java
│       ├── TaggingAction.java
│       └── WxTemplateAction.java
└── mq
    ├── MQClient.java
    ├── MQComsumer.java
    ├── MQConfig.java
    └── MQPublisher.java
```

## halo

ActionTypeEnum: action类型枚举

ActionArgTypeEnum: action参数类型枚举

NskClient:

NskClientWrap:

Nsk:

# 开发排期

| 内容            | 耗时   | 开发   |      |
| ------------- | ---- | ---- | ---- |
| Action        | 1    | 赵蔺   |      |
| ActionGroup   | 1    | 赵蔺   |      |
| Action invoke | 1    | 赵蔺   |      |
| buf time      | 2    | 赵蔺   |      |

# 开发进度

### 2017-04-11

Aliyun MQ 使用调研完毕，明天可以开始开发Action和ActionGroup

### 2017-04-12

Action 和 ActionGroup开发

### 2017-04-13

自测

### 2017-04-15

配合 Trigger System，设计做了修改，主要：

1. 不再有 ActionGroup 的概念，本系统只做原子动作的执行
2. 支持了延时触发