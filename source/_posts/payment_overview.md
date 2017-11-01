---
title: 【合肥项目】支付系统设计概述
date: 2016-12-11 00:00:00
categories: 合肥
tags:
- 支付系统
---

# Payment Service 概述 `好吧, 我叫 Midas`

## 业务背景

* 在线支付是我们的业务需求，需要通过线上完成交易闭环

## 做什么
* 付款
* 退款
* 查询付款／退款
* 提供回调接口，接收ping++回调事件

## 不做什么
* 注意，该服务不应直接包含与业务逻辑挂钩的内容。比如，记录订单支付历史。

## 基本选型
采用pingplusplus (www.pingxx.com) 第三方整合支付平台  
Ping++优势  
* pingpp 对各个支付渠道皆有支持
* pingpp client/server sdk 封装较为完整，对各语言支持比较完善，相关文档及示例较完整。使用时无需太多关注渠道细节，实现及未来扩展渠道成本较小
* pingpp 平台本身价格策略符合需求

***
## 主要流程说明
### 支付流程
![](/media/payment_service_charge_flow.png)
* 步骤（1）客户端使用pingpp sdk
* 步骤（4）返回的支付Object格式
* 注意（A）到（B）为同步过程
* 在（B）时，将步骤（4）取得的charge_obj输入pingpp sdk，sdk将调用支付平台完成支付
* 步骤（6）完成后，不保证立即在youhujia服务端中订单状态立即更新为已支付
* 步骤（7），pingpp服务器回调webhook，返回event事件

### 退款流程
![](/media/payment_service_refund_flow.png)
* 步骤（1），可以由客户端或者服务器发起退款
* 在（A）处，需要先请求取回Charge对象
* 注意在步骤（3）之后，需判定取回的Charge状态是否正常
* 步骤（6）为异步回调

### 主动拉取支付和退款状态
由于ping++异步回调有不确定性，不应完全依赖于它的回调状态更新机制，因此需要一个主动拉取状态的功能
* 支付（Charge）的拉取，应该被 定时器服务 调用
* 退款（Refund）的拉取，应该被 定时器服务 调用

### Webhook 回调
用来接收ping++异步发送的状态更新
* 首期需接收支付、退款的状态回调
* 后期可考虑处理其他事件类型
* 注意，需进行ping++ callback request签名验证，确保回调信息可靠
***
## Mocking策略
* 目的，保证其他依赖于此服务的模块在开发前期不被block
* 仅包含对外API可以被call通
* 不模拟时序与逻辑

## Failing处理
* ping++服务异常
    - 将导致订单无法完成
    - ping++工单反馈
    - https://www.pingxx.com/contact
    - 目前ping++账号套餐不能得到1v1人工服务，若要1v1需升级。
* midas服务异常
    - 全部支付相关流程将受阻
    - 可通过log来确认问题来源
    - 作为对策，预先准备好已经过测试的docker image，若异常则回滚发布
* ping++工具：pingpp dashboard提供了工具，可通过相应id找到对应的支付项目

## Logging
* service log
* 交易流记录

## Operation
对各操作，及异常，皆进行log记录，方便问题调研

## Test plan
* 本地测试，可测试场景有限，可模拟webhook回调
* 联合测试，ping++ test mode
* 必须进行ping++ live mode测试，进行真实付款，确认支付渠道流程正常

## 排期

Task|Cost(Person.Day)|Status|Memo
--|--|--|--
工程搭建|1|O|
支付流程/退款流程|1|O|
拉取支付/退款信息|1|O|
Webhook|1|O|
Order集成／调试|1|O|


## 微信端注意事项
* 需要注意支付授权目录的设置 https://help.pingxx.com/article/123339/

## 其他
* 后期对支付宝的支持（需要考虑前后端支持，支付宝特殊退款流程，渠道开通，账务等问题）

## owl, midas 联合测试（Pingpp Test Mode）
场景|期待结果|实际结果|备注
模拟用户发起支付->owl.payorder->midas.initCharge->确认/取消模拟支付|应有charge json保存至owl order记录，状态为 支付中|
确认模拟支付后->pingpp发起charge.succeeded->midas.webhook->owl.payOrderSuccess||

确认模拟支付后->模拟未收到webhook->owl发起查询|| //todo

取消模拟支付后->用户再次支付->用户模拟确认支付||
取消模拟支付后->模拟超时

模拟发起退款->owl.userrefund->midas.initrefund
模拟发起退款后->pingpp发起refund.succeeded->midas.webhook->owl.refundSuccess||
模拟发起退款后->模拟未收到pingpp回调->owl.checkRefunding||

## 部署方法
  - cd 到 代码目录下（一般是/opt/zhushou）
  - git clone -o root git@github.com:youhujia/midas.git
  - cd midas
  - CONFIG_URL=http://<本环境中config服务器IP地址:端口号>/ IP=<本环境中IP地址> PORT=6011 MPORT=6012 ENV=development gradle go
  - docker ps 确认运行状况

## 前置依赖
  - 无
