---
title: 【优护助手-合肥】合肥C端-Exception-Conclusion
date: 2017-3-5 11:20:00
categories: 合肥
tags:
- 优护助手
---

## 摘要
合肥项目-C端-Exception-Conclusion
<!--more-->

## order
### 退款申请
参数校验：
1. 用户id为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "patientId null");
2. 退款原因为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "请选择退款原因");
3. 退款说明字数限制：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "退款说明不能多于200字");
4. 退款金额为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "请填写退款金额");
5. 退款金额大小不能小于等于0：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "退款金额填写有误");
6. 退款金额不能大于支付金额:throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "退款金额不能超过订单实际支付金额");
7. 退款金额参数类型：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "退款金额只能精确到分");

### 提交订单
参数校验：
1. 用户Id为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "userId null");
2. 患者Id为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "请选择用户");
3. 服务时间为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "请选择预约时间");
4. 服务时间为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "请选择预约时间");
5. 当前时间后，30分钟的预约时间可选：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "请在当前时间30分钟后进行预约");
6. 备注字数限制：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "备注字数为0~200");
7.服务时间未来一周内可选，包括当日在内： throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "服务时间未来一周内可选，包括当日在内");

### 用户提交评价
参数校验：
1. 订单Id为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "orderId null");
2. 评价内容字数限制：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "评价内容不能多于200字");
3. 评价参数为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "请您对该订单进行打分");
4. 评价分数大小限制：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "评价分数必须在20到100分之间");

### 用户下单所需信息
参数校验：
1. 用户id为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "no userId");
2. 服务id为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "no itemId");
3. 用户id与服务id的参数类型校验：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "userId or itemId format wrong");

### 查询订单详情
参数校验：
1. 订单Id为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "orderId is null");

合法性校验：
1. 当前订单是否是该用户的订单：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "操作非法：该订单不属于当前用户");
2. 订单对应的状态不是状态机中的状态：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "订单有待支付、待接单、待服务等状态，但是没有当前您输入的状态");

### 订单列表
参数校验：
1. 传参为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "queryMap is null");
2. 用户Id（userId）、页数（index）、每页显示的数据行数（size）都不能为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "patientId or size or index is null");
3. 用户Id（userId）、页数（index）、每页显示的数据行数（size）的参数类型：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "patientId or size or index format wrong");
4.页数（index）>0：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "size more than 500");
5.每页显示的数据行数（size）<500行： throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "index > 0");
6. 订单对应的状态不是状态机中的状态：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "订单有待支付、待接单、待服务等状态，但是没有当前您输入的状态");

### 退款申请页面信息
参数校验：
1. 订单Id为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "orderId  null");

### 支付：
参数校验：
1. orderId为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "orderId null");
2. queryMap为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "queryMap is null");
3. 没有选择支付渠道：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "planId or channel is null");
4. 当用户发起了支付但是又取消了支付，但是用户又点击了支付按钮，但是状态流转已经到支付中了，没法惊醒支付操作了：throw new YHJException(ShootExceptionCodeEnum.ORDER_PAYING, "订单正在支付中...");

### 取消订单
操作处理：
1. 订单处于支付中是点击取消订单按钮： throw new YHJException(ShootExceptionCodeEnum.ORDER_PAYING,"如订单未完成支付，将在特定时间后自动取消");
2. orderId为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "OrderId is Null");

### 取消退款：
参数校验：
1. orderId为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "OrderId is Null");

### 查看协议：
参数校验：
1. 协议名字为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "protocolName is null");
2. itemId不存在：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "itemId must exist");
3. 服务Id（itemId）对应的服务不存在：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "itemId refer item is not found");

## item
### 查询医院所提供的服务列表：
参数校验：
1. organizationId为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "organizationId null");
2. 用户id对应的department不存在：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "Id refer department does not found");

### 服务详情：
参数校验：
1.organizationId为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "organizationId null");
2.itemId为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "itemid null");
3.服务Id（itemId）对应的服务不存在：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "itemId is wrong");

## userAddress
### 查询患者信息
参数校验：
1. userId为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "userId is null");
2. useraddressId为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "userAddressId id null");
3. userId与UserAddressId参数类型校验：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "userId or userAddressId format wrong");

权限校验：
1. userAddressId对应的userAddress不存在：throw new YHJException(ShootExceptionCodeEnum.OBJECT_IS_NOT_FOUND, "该患者不存在");
2. 根据userAddressId查询的userAddress中对应的userId与传参中的userId不相等：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "抱歉，您没有该操作权限");

### 新增患者
参数校验：
1. userId为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "userId null");
2. 姓名为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "请填写患者姓名");
3. 姓名长度限制：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "患者姓名最大长度为5");
4. 姓名亦可以为数字，字母和汉字：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "患者姓名填写有误");
5. 性别为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "性别不能为空");
6. 性别只能填男女：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "请正确填写性别");
7. 出生日期：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "出生日期不能为空");
8. 出生日期限制，对应于年龄为0~150岁：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "患者出生日期必须在"+year+"年"+month+"月"+day+"日和当前时间之间");
9. 手机号为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "手机号不能为空");
10. 手机号位数：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "请正确填写11位手机号");
11. 手机号格式：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR,"请填写正确的手机号码！");
12. 服务地址为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "请填写服务地址");
13. 服务地址省市为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "请填写患者所在省市");
14. 服务地址城市为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "请填写患者所在城市");
15. 服务地址所在区为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "请填写患者所在地区");
16. 服务地址的详细地址为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "请填写患者所在地区的详细地址");
17. 用户与患者关系为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "请选择与患者关系");
18. 出生日期格式校验：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "请填正确填写出生日期");

### 更新患者信息
参数校验：与新增患者信息一样
权限校验：
1. userAddressId对应的userAddress不存在：throw new YHJException(ShootExceptionCodeEnum.OBJECT_IS_NOT_FOUND, "该患者不存在");
2. 根据userAddressId查询的userAddress中对应的userId与传参中的userId不相等：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "抱歉，您没有该操作权限");

### 删除患者信息
参数校验：
1. userId为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "no userId");
2. userAddressId为空：throw new YHJException(YHJExceptionCodeEnum.OPTION_FORMAT_ERROR, "no userAddressId");

权限校验：与跟新患者信息一样

## 备注：
凡是锁中涉及到永久锁的异常：throw new YHJException(YHJExceptionCodeEnum.LOCK_KEY_EXISTS, "订单正在处理中，请稍后重试");


