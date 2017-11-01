---
title: 各种 Enum
date: 2017-04-17 13:52:00
categories: enum
tags:
  - enum
---

# 摘要

各个系统的 Enum

<!-- more -->

## OrderState

https://github.com/Youhujia/halo/blob/master/src/main/java/com/youhujia/halo/owl/OrderState.java

```json
    UNPAID(0L, "unpaid", "待支付"),
    PAYING(1L, "paying", "支付中"),
    PRE_ACCEPT(2L, "pre-accept", "待接单"),
    PRE_ACCEPT_IN_HIGH_PRIORITY(3L, "pre-accept-in-high-priority", "高优先待接单"),
    ASSIGNED_TO_CONFIRM(4L, "assigned-to-confirm", "派单待确认"),
    PRE_SERVICE(5L, "pre-service", "待服务"),
    IN_SERVICE(6L, "in-service", "服务中"),
    IN_SERVICE_TIMEOUT(7L, "in-service-timeout", "服务超时"),
    IN_SERVICE_EXCEPTION(8L, "in-service-exception", "服务异常"),
    UNREVIEWED(9L, "unreviewd", "服务完成状态（待评价）"),
    REQUEST_REFUND(10L, "request-refund", "退款申请中"),
    PRE_REFUND(11L, "pre-refund", "待退款"),
    REFUNDING(12L, "refunding", "退款中"),
    REFUND_SUCCESS(13L, "refund-success", "退款成功"),
    REFUND_FAILED(14L, "refund-failed", "退款异常"),
    INIT_REFUND_FAILED(15L, "init-refund-failed", "发起退款异常"),
    SETTLEMENT(16L, "settlement", "结算状态"),
    FINISHED(17L, "finished", "订单结束"),
    CLOSED(18L, "closed", "关闭状态"),
    DISPUTE(19L, "dispute", "服务纠纷状态"),
    DISPUTE_AFTER_FINISHED(20L, "dispute-after-finished", "订单结束后纠纷"),
    AGENT_UNPAID(21L,"agent-unpaid","代下单等待支付"),
    AGENT_PAYING(22L,"agent-paying","代下单支付状态待确认");
```

## ItemStatus

https://github.com/Youhujia/halo/blob/master/src/main/java/com/youhujia/halo/dagon/ItemStateEnum.java

```json
    DRAFTING(1, "草稿"),
    DRAFTED(2, "编辑完成"),
    AUDITING(3, "审核中"),
    AUDIT_FAILED(4, "审核失败"),
    PRE_ONLINE(5, "待上线"),
    ONLINE(6, "上线"),
    ABNORMAL(7, "异常"),
    DELETED(8, "已删除");
```

## Nurse Status

https://github.com/Youhujia/halo/blob/develop/src/main/java/com/youhujia/halo/yolar/NurseState.java#L6

```java
    NotAuthorize(0L, "未认证"),
    Authorizing(1L, "认证中"),
    Fail(2L, "认证失败"),
    Authorized(3L, "已认证"),
    Master(4L, "护士管理员"),
    Assistant(5L, "科秘");
```



## TagType - HALO

https://github.com/Youhujia/halo/blob/master/src/main/java/com/youhujia/halo/authorization/user/object/TagType.java#L8

```java
    Nurse(0L, "护士"),
    User(1L, "用户"),
    //Follow(2L, "关注"),
    //Blacklist(3L, "黑名单"),
    DepartmentProvideService(4L, "提供服务"),
    NurseCanProvideService(5L, "护士可以提供的服务类型"),
    NurseWouldProvideService(6L, "护士愿意提供的服务类型"),
    Notification(7L, "接收通知"),
    //DepartmentAuthCodePass(8L, "用户通过了科室校验码的检查");
```

## SophonPlanTypeEnum

https://github.com/Youhujia/halo/blob/master/src/main/java/com/youhujia/halo/sophon/SophonPlanTypeEnum.java

```java
    FOLLOWUP(1, "随访"),
    ROSTER(2, "排班"),
    ANNOUNCEMENT(3,"科室公告"),
    SERVICE(4,"上门服务"),
    Evaluation(5,"评估"),
    SelfTest(6,"自测");
```

## TaskStatusEnum

https://github.com/Youhujia/sophon/blob/master/src/main/java/com/youhujia/sophon/domain/task/TaskStatusEnum.java

```java
    NOT_DONE(1,"执行未确认"),
    DONE(2,"执行确认"),
    GIVE_UP(3,"放弃执行");
```

## ActionStatusEnum

https://github.com/Youhujia/halo/blob/develop/src/main/java/com/youhujia/halo/sophon/ActionStatusEnum.java

```java
    NOT_DONE(1, "未执行"),
    DONE(2, "执行完成"),
    FAIL_WAIT_TRY_AGAGIN(3, "执行失败待重试"),
    FAIL(4, "执行失败"),
    GIVE_UP(5, "放弃执行");
```

## ActionTypeEnum - SOPHON

https://github.com/Youhujia/sophon/blob/master/src/main/java/com/youhujia/sophon/domain/action/ActionTypeEnum.java

```java
    FOLLOWUP_BRIEF(1, "随访记录"),
    FOLLOWUP_WECHAT(2, "随访微信推送"),
    ANNOUNCEMENT_CONTENT(3,"公告内容"),
    ANNOUNCEMENT_READ(4,"科室已读"),
    GENERAL_ARTICLE(5,"通用文章"),
    GENERAL_TOOL(6,"通用自测"),
    GENERAL_EVALUATE(7,"通用评估"),
    GENERAL_STEP(8,"通用动作");
```

## TaskQueryEnum - HALO

https://github.com/Youhujia/halo/blob/master/src/main/java/com/youhujia/halo/sophon/TaskQueryEnum.java#L5

```java
    PLAN_ID("planId"),
    PLAN_TYPE("plantype"),
    CREATOR_ID("creatorId"),
    CREATOR_TYPE("creatorType"),
    CREATOR_DEPARTMENT_ID("creatorDepartmentId"),
    EXECUTOR_ID("executorId"),
    EXECUTOR_TYPE("executorType"),
    EXECUTOR_DEPARTMENT_ID("executorDepartmentId"),
    TITLE("title"),
    ACTION_ID("actionId"),
    ALERT_TIME_START("alertTimeStart"),
    ALERT_TIME_END("alertTimeEnd"),
    START_TIME_START("startTimeStart"),
    START_TIME_END("startTimeEnd"),
    END_TIME_START("endTimeStart"),
    END_TIME_END("endTimeEnd"),
    STATUS("status");

    RECEIVER_ID("receiverId"),
    RECEIVER_TYPE("receiverType");
```

## SophonRoleEnum

https://github.com/Youhujia/halo/blob/master/src/main/java/com/youhujia/halo/sophon/SophonRoleEnum.java

```java
    Nurse(1, "护士"),
    Patient(2, "患者"),
    Admin(3, "运营"),
    Partner(4, "合作伙伴");
```

## TagTypeEnum - Halo - HDFragments

https://github.com/Youhujia/halo/blob/develop/src/main/java/com/youhujia/halo/hdfragments/HDFragmentsTagTypeEnum.java

```java
    HUMAN(1, "human-point", "自然人指标"),
    VIRTUAL_DISEASE(2, "virtual_disease", "虚拟疾病"),
    RESEARCH(3, "research", "科研"),
    RESEARCH_GROUP(4, "research-group", "科研分组"),
    NURSE_CREATE(5, "nurse_create_to_mark", "护士创建标记标签"),
    UI_VIEW(6, "ui-view", "UI View"),
    CARE_ROUTINE(7, "care-routine", "护理路径"),
    DEPARTMENT(8, "department", "科室"),
    ARTICLE_GROUP(9, "article_group", "文章组"),
    DEPARTMENT_CAN_PROVIDE_SERVICE(10, "department_can_provide_service", "科室可以提供服务"),
    NURSE_CAN_PROVIDE_SERVICE(11, "nurse_can_provide_service", "护士可以提供的服务"),
    NURSE_WOULD_PROVIDE_SERVICE(12, "nurse_would_provide_service", "护士愿意提供的服务"),
    NURSE_ORDER_NOTIFICATION(13, "nurse_order_notification", "护士是否接收其愿意提供服务的订单的推送"),
    ARTICLE_UI_GROUP(14, "article_ui_group", "前端展示用的文章组"),
    UI_CONFIG(15, "ui_config", "具体的一个UI配置"),
    DEPARTMENT_ITEM(16,"department item","科室创建的商品"),
    EVALUATION_GROUP(17,"evaluation group","评估组"),
    SELF_EVALUATION_GROUP(18,"self Evaluation group","自测组");
```

## ObjectTypeEnum - HDFragments

https://github.com/Youhujia/halo/blob/develop/src/main/java/com/youhujia/halo/hdfragments/HDFragmentsObjectTypeEnum.java

```json
    ARTICLE(1, "article", "文章"),
    EVALUATION(2, "evaluation", "评估"),
    NURSE(3, "nurse", "护士"),
    PATIENT(4, "patient", "患者"),
    DEPARTMENT(5, "department", "科室"),
    EVALUATION_BUNDLE(6, "evaluation_bundle", "量表"),
    SELF_EVALUATION(7,"self_evaluation","自测");
```

## MappingTypeEnum - HDFragments

https://github.com/Youhujia/halo/blob/develop/src/main/java/com/youhujia/halo/hdfragments/HDFragmentsMappingTypeEnum.java

```java
    DEFAULT(0, "default", "默认类型--无类型"),
    USER_FAVED_DISEASE(1, "user-faved-disease", "用户关注"),
    USER_MARKED_BY_NURSE(2, "user-marked-by-nurse", "护士标记"),
    SELF_EVALUATION(3, "self_evaluation", "自测"),
    PROFESSION_EVALUATION(4, "profession_evaluation", "评估");
```

## QuestionTypeEnum - Civil

```java
    SINGLE_CHOICE(0L, "single_choice", "单选"),
    MULTI_CHOICE(1L, "multi_choice", "多选"),
    COMPLETION(2L, "completion", "填空"),
    SINGLE_CHOICE_MATRIX(3L, "single_choice_matrix", "单选矩阵");
```
