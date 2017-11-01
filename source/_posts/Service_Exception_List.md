---
title: 【上门护理二期】Exception集合
date: 2017-2-14 21:10:00
categories: 上门护理二期
tags:
- Exception
- 合肥
- 订单
- 二期
---


## 摘要

 Shooter,Farmer,Halo,Owl Exception List

<!--more-->

## WIKI维护人

黄  英
张正宇

## Shooter_Exception_List

### 退款申请

参数校验：

1. 患者id为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "patientId null");
2. 退款原因为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "退款原因不能为空");//请选择退款原因
3. 退款说明字数限制：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "退款说明不能多于200字");
4. 退款金额为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "退款金额不能为空");//请填写退款金额
5. 退款金额大小不能小于等于0：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "退款金额不能小于等于0");//退款金额填写有误
6. 退款金额不能大于支付金额:throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "退款金额大于您的支付金额");//退款金额不能超过订单实际支付金额
7. 退款金额参数类型：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "退款金额必须为整数");//退款金额只能精确到分

### 提交订单

参数校验：

1. 患者Id为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "patientId null");
2. 用户名为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "用户名不能为空");//请填写患者姓名
3. 用户名长度<5：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "用户名长度不超过5");//患者姓名最大长度为5
4. 用户名只能填汉字、数字、和英文：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "不能有特殊字符");//患者姓名填写有误
5. 用户性别为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "性别不能为空");
6. 用户年龄为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "年龄不能为空");//请填写年龄
7. 年龄大小限制：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "年龄必须在1-150之间");
8. 手机号码为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "手机号不能为空");
9. 手机号码位数限制：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "手机号必须是11位");
10. 服务时间为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "服务时间不能为空");
11. 当前时间后，90分钟可选：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "当前时间后，90分钟后开始可选");	//请在当前时间90分钟后进行预约
12. 服务时间未来一周内可选，包括当日在内： throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "服务时间未来一周内可选，包括当日在内");
13.  每日可选开始时间06:00，可选结束时间21:00：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "每日可选开始时间06:00，可选结束时间21:00");
14. 服务地址为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "服务地址不能为空");

### 患者提交评价

参数校验：

1. 订单Id为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "orderId null");
2. 评价内容字数限制：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "评价能容不能多于200字");//评价内容不能多于200字
3. 评价参数为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "请您对该订单进行打分");
4. 评价分数大小限制：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "评价分数必须在20到100分之间");

### 患者下单所需信息

参数校验：

1. 患者id为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "no userId");
2. 服务id为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "no itemId");
3.  患者id与服务id的参数类型校验：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "userId or itemId format wrong");

### 查询订单详情

参数校验：

1. 订单Id为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "orderId is null");

合法性校验：

1. 当前订单是否是该患者的订单：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "操作非法：该订单不属于当前用户");
2. 订单对应的状态不是状态机中的状态：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "订单有待支付、待接单、待服务等状态，但是没有当前您输入的状态");

### 订单列表

参数校验：

1. 传参为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "queryMap is null");
2. 患者Id（userId）、页数（index）、每页显示的数据行数（size）都不能为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "patientId or size or index is null");
3. 患者Id（userId）、页数（index）、每页显示的数据行数（size）的参数类型：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "patientId or size or index format wrong");
4. 页数（index）>0：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "size more than 500");
5. 每页显示的数据行数（size）<500行： throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "index > 0");
6. 订单对应的状态不是状态机中的状态：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "订单有待支付、待接单、待服务等状态，但是没有当前您输入的状态");

### 退款申请页面信息

参数校验：

1. 订单Id为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "orderId  null");

### 支付：

参数校验：

1. orderId为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "orderId null");
2. queryMap为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "queryMap is null");
3. 没有选择支付渠道：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "planId or channel is null");
4. 当用户发起了支付但是又取消了支付，但是用户又点击了支付按钮，但是状态流转已经到支付中了，没法惊醒支付操作了：throw new YHJException(ShootExceptionCodeEnum.ORDER_PAYING, "订单正在支付中...");//功能已经实现，需要修改

### 取消订单

操作处理：

1. 订单处于支付中时点击取消订单按钮： throw new YHJException(ShootExceptionCodeEnum.ORDER_PAYING,"如订单未完成支付，将在特定时间后自动取消");//功能已实现
2. orderId为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "OrderId is Null");

### 取消退款：

参数校验：

1. orderId为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "OrderId is Null");

### 查看协议：

参数校验：

1. 协议名字为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "protocolName is null");
2. itemId不存在：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "itemId must exist");
3. 服务Id（itemId）对应的服务不存在：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "itemId refer item is not found");

### 查询医院所提供的服务列表：

参数校验：

1. organizationId为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "organizationId null");
2. 用户id对应的department不存在：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "Id refer department does not found");

### 服务详情：

参数校验：

1. organizationId为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "organizationId null");
2. itemId为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "itemId null");
3. 服务Id（itemId）对应的服务不存在：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "itemId is wrong");

### 备注：

凡是锁中涉及到永久锁的异常：throw new YHJException(YHJExceptionCodeEnum.LOCK_KEY_EXISTS, "订单正在处理中，请稍后重试");


## Farmer_Exception_List

### 服务设置管理页面接口 && 可服务项目接口

前端传过来的nurseId为空："nurseId NULL"
前端传过来的nurseId不是long类型： "nurseId format wrong!"

### 护士申请进入运营介入

前端传过来的updateOption为空：   "no option"
前端传过来的orderId为空：        "no OrderId"
前端传过来的nurseId为空：        "no nurseId"
数据库中改订单的负责护士与前端传过来的护士不一致："该护士无权限操作此订单"
当订单状态不在服务中状态中时："DBorder status not in Service so not update  to openDispute"//订单状态不在服务中状态,所以不能发起纠纷

### 护士是否同意退款

前段传过来的updateOption为空：   "no option"
前端传过来的orderId为空：        "no OrderId"
前端传过来的nurseId为空：        "no nurseId"
前端传过来的退款意见为空：        "isAgree Null"

### 取消订单

前段传过来的updateOption为空：   "no option"
前端传过来的orderId为空：        "no OrderId"
前端传过来的nurseId为空：        "no nurseId"
前段传过来的取消订单理由为空：     "cancelReason Null"
数据库中改订单的负责护士与前端传过来的护士不一致："该护士无权限操作此订单"
当订单状态不在服务中状态中时："DBorder status not in Service so not update  to openDispute"

### 可服务项目更新

前端传过来的nurseId为空：        "no nurseId"
前端传过来的服务项的Id为空：       "serviceId Null"
前端传过来的nurseId与注解中的nurseId不匹配时：    "该护士无权限操作此订单"
前端传进来的服务项Id不在护士可以服务的服务项里：     "本部门不允许该护士提供此服务!"

### 护士确定完成订单

前段传过来的updateOption为空：   "no option"
前端传过来的orderId为空：        "no OrderId"
前端传过来的nurseId为空：        "no nurseId"
数据库中改订单的负责护士与前端传过来的护士不一致："该护士无权限操作此订单"
如果订单的状态不在服务中：         "order status not inService"//订单不在服务中状态，不可完成订单
如果服务评估为空：                "订单评估没有完成，不可以完成订单"
订单操作没完成；                  "订单操作没有完成，不可以完成订单"

### 完成当前服务

前段传过来的updateOption为空：   "no option"
前端传过来的orderId为空：        "no OrderId"
前端传过来的nurseId为空：        "no nurseId"
前端传过来的服务项的Id为空：      "serviceId Null"
前端传过来的nurseId与注解中的nurseId不匹配时：    "该护士无权限操作此订单"
当订单状态不在服务中状态中时：     "status not have the right to update"
前端传过来的服务项该订单不存在：    "service error"

### 接受推送接口

前端传过来的orderId为空：        "no OrderId"
如果该护士没有可服务的服务项       "该护士没有可服务的服务项"

### 首页接口-返回待接单的List(/api/nurses/order/v1/workbench)

前端传回的queryMap为空的时候，显示异常：queryMap is null；
前端传回的size或index为空的时候，显示异常：size or index is null；
前端传回的size和index格式不正确的时候，显示异常：size or index format wrong；
前端传回的size大于500时，显示异常：size more than 500；
前端传回的size小于0时，显示异常：size less than 0；
前端传回的index小于0，显示异常：index > 0；

### 获得已接单和待接单的列表（/api/nurses/order/v1）

前端传回的status为空的时候，显示异常：STATUS null；

### 待接单

部分同首页接口
当状态机中拿到的订单的状态不属于待接单列表中应该显示的状态时，显示异常：AcceptOrderDTOFactory->buildAcceptOrderCenterDTO
,YHJExceptionCodeEnum.THIRD_SERVICE_EXCEPTION,"已接单列表存在未知状态订单","orderId",orderDTO.getOrderId(),"orderStatus",orderDTO.getStatus()

### 已接单

前端传回的queryMap为空的时候，显示异常：queryMap is null；

前端传回的nurseId为空或者size为空或者index为空的时候，显示异常：nurseId or size or index is null；
 
前端传回的nurseId或者size或者index的格式错误的时候，显示异常：nurseId or size or index format wrong；

前端传回的size大于500时，显示异常：size more than 500；

前端传回的size小于0时，显示异常：size less than 0；

前端传回的index小于0，显示异常：index > 0；

当状态机中拿到的订单的状态不属于已接单列表中应该显示的状态时，显示异常：AcceptOrderDTOFactory->buildAcceptOrderCenterDTO
,YHJExceptionCodeEnum.THIRD_SERVICE_EXCEPTION,"已接单列表存在未知状态订单","orderId",orderDTO.getOrderId(),"orderStatus",orderDTO.getStatus()；
### 根据OrderId获得新订单详情（/api/nurses/order/v1/{orderId}/detail）
检验详情页面是待接单状态还是已接单状态。如果为待接单状态没有nurseId;如果为已接单状态，有nurseId.再校验此时的nurseId是否为登录时的，如果不是，显示异常：you don't have the right!

当状态机中拿到的订单的状态不属于订单详情列表中应该显示的状态时，显示异常：OrderDetailDTOFactory->buildOrderDetailDTO
,YHJExceptionCodeEnum.THIRD_SERVICE_EXCEPTION,"订单详情存在未知状态订单
","orderId",orderDTO.getOrderId(),"orderStatus",orderDTO.getStatus()；

## halo 异常集合

### THIRD_SERVICE_EXCEPTION(系统内部错误，请稍后重试)

1. 请求其他项目时捕捉到其抛出的异常时：
displayMsg：系统内部错误，请稍后重试
info：unknown exception check log

2. 请求其他项目时没有返回结果时：
displayMsg：系统内部错误，请稍后重试
info：api result empty

3. 请求其他项目时返回结果的是否成功字段为false时：
displaMsg：系统内部错误，请稍后重试
info：api result not success + 其项目的对应的错误信息

### OPTION_FORMAT_ERROR（请求参数非法）

1. 查询护士信息时缺少nurseId时：
displayMsg：请求参数非法
info：no orderId in Query + 请求的url

2. 查询护士信息从URL中解析其nurseId失败时：
displayMsg：请求参数非法
info：nurseId in Query Parse Error + 请求的URL + nurseId

3. 查询订单信息时缺少orderId时：
displayMsg：请求参数非法
info：no orderId in Query +请求的URL 

4. 查询订单信息从URL中解析其orderId失败时：
displayMsg：请求参数非法
info：orderId in Query Parse Error + 请求的URL + nurseId

说明：其他项目中查询其信息时抛出的错误信息类似

### AOP_BUILD_FAIL（AOP对象构建失败）

1. 构建CMS模版由于传入模版内容有问题导致构建失败时：
displayMsg：AOP对象构建失败
info：Unknown TemplateContent + 具体传入的内容

2. 构建CMS模版由于传入模版种类有问题导致构建失败时：
displayMsg：AOP对象构建失败
info：Unknown TemplateType + 具体传入的模版

3. 通过请求内容构建halo失败时
displayMsg：AOP对象构建失败
info：AOP Build Fail check terminal for detail 

4. 构建动作时由于传入动作类型有问题导致解析失败时：
displayMsg：AOP对象构建失败
info：ActionType Content ParseException + 动作内容 + 动作

5. 构建动作时出现为止错误时：
displayMsg：AOP对象构建失败
info：Unknown Action ParseException + 动作内容 + 动作

6. 构建动作时传入了不在了枚举列表中的动作：
displayMsg：AOP对象构建失败
info：Unknown ActionType + 动作类型 + 动作内容

7. 构建serviceItem时缺少注解时导致构建失败时：
displayMsg：AOP对象构建失败
info：can not set needTemplate In @ServiceItem In @Item + 请求url



## owl 异常

### 错误码为20007(参数错误)的异常信息详细列表

校验订单Id，当传入订单id小于等于0时：
displayMsg：参数错误 
info：orderId must > 0

校验订单no（编号），传入订单no等于空时：
displayMsg：参数错误 
info：orderNo is necessary

创建订单传入itemId为空时：
displayMsg：参数错误 
info：itemId is not exist

创建订单传入serviceItemId为空时：
displayMsg：参数错误 
info：serviceItemId is not exist

创建订单时address（个人相关信息）为空时：
displayMsg：参数错误 
info：address is not exist

支付订单时传入的payOrderOption（支付相关信息）为空时：
displayMsg：参数错误 
info：payOrderOption is not exist

支付订单时传入的payOrderOption（支付相关信息）中的channel字段为空时：
displayMsg：参数错误 
info：payOrderOption-channel is not exist

支付订单时传入的payOrderOption（支付相关信息）中的openId字段为空时：
displayMsg：参数错误 
info：payOrderOption-extra-openId is not exist

处理失败退款订单时传入manualHandleFailedRefundOption（处理退款失败订单的相关信息）为空时：
displayMsg：参数错误 
info：manualHandleFailedRefundOption is not exist

处理失败退款订单时传入manualHandleFailedRefundOption（处理退款失败订单的相关信息）中的desc（描述）字段为空时：
displayMsg：参数错误 
info：manualHandleFailedRefundOption-desc is not exist

处理失败退款订单时传入manualHandleFailedRefundOption（处理退款失败订单的相关信息）中的refundAmount（退款金额）字段为空时：
displayMsg：参数错误 
info：manualHandleFailedRefundOption-refundAmount is not exist

护士接单时传入的OrderAcceptOption（接单人相关信息）为空时：
displayMsg：参数错误 
info：OrderAcceptOption is not exist

护士接单时传入的OrderAcceptOption（接单人相关信息）中的nurseId为空时：
displayMsg：参数错误 
info：OrderAcceptOption-nurseId is not exist

组合查询时传入下标（index）小于0时：
displayMsg：参数错误 
info：Index is required and must >= 0

组合查询时传入获取订单个数小于等于0时：
displayMsg：参数错误 
info：Size is required and must > 0

### 错误码为20011（JSON 解析错误）的异常详细列表

下单时下单相关信息对象解析失败时：
displayMsg：JSON 解析错误
info：address解析失败

创建订单时商品详情对象解析失败时：
displayMsg：JSON 解析错误
info：serviceItem解析失败

退款相关操作添加或修改退款日志相关信息对象失败时：
displayMsg：JSON 解析错误
info：refundRecord解析失败

### 其他错误信息

1. 传入的订单id或者订单no在数据库中不存在时:
显示：订单找不到或已被删除

2. 传入的订单当前的状态下不能执行该操作，操作不合法时：
显示：当前状态不允许该操作+当前订单的状态 动作action

3. 传入订单的状态不在系统默认的状态之中时：
显示：传入状态不合法

4. 传入退款记录的的Id不存在时：
显示：退款记录未找到

5. 在进行退款申请时，还存在未完成退款时：
显示：存在未完成退款

6. 在进行退款操作时（非退款申请操作）没有相对应的记录时：
显示：〇或多个未完成退款记录

7. 订单进入下一个状态不在待退款、退款申请中状态下进行添加退款日志时：
显示：订单当前状态不支持退款

8. 退款申请时发起的金额大于数据库剩余金额时：
显示：退款超出订单剩余金额

9. 处理退款异常和发起退款异常状态下的订单后，修改订单状态传入的本次手动处理的金额和本次退款申请的金额不相等时：
显示：手动处理的金额和申请退款的金额不等//待查 todo

10. 申请退款或者运营处理退款时金额小于等于0时：
显示：退款金额不能小于等于0


## 运营端

1. 底层服务不明错误：INTERNAL_ERROR(91000, "internal error", "服务器错误")

2. 查询订单不存在：ORDER_NOT_FOUND(91001, "order not found", "订单未找到")

3. 客服人员：ADMIN_NOT_FOUND(91002, "admin not found", "人员未找到")

4. 当前订单状态不能支持该操作：STATUS_ERROR(91003, "status error", "状态错误")

5. 调用退款接口失败：REFUND_FAILED(91004, "refund failed", "退款失败")

6. 退款数目格式不正确：REFUND_AMOUNT_ERROR(91005, "refund amount error", "退款数目错误")

7. 调用调用退款接口失败： REJECT_REFUND_FAILED(91006, "reject refund failed", "拒绝退款失败")

8. 退款操作不明错误（绕开前端填写错误的操作码）：REFUND_ACTION_ERROR(91007, "refund action error", "退款操作错误"), 返回消息失败：ACTION_FAILED(91008, "action failed", "操作失败")


