---
title: 护士上门辅助下单支付支持
date: 2017-03-01 14:00:00
categories: 上门护理
tags:
- 上门护理
- 辅助下单
- 支付
- 二期
---

# 摘要

护士上门辅助下单，需要通过客户端（ios, android）进行付款操作。本文档描述支付系统相关的功能设计

<!--more-->

# WIKI 维护人

黄丹

# 背景

客户端选择支付方式（微信，或 支付宝），点击支付需要调起支付，从而完成交易。在该操作过程中，涉及到的支付渠道（微信app支付，支付宝app支付）与已有系统（现在支持 微信公众号 支付）并不相同。而不同渠道可能需要不同的支付参数。

# 支付库支撑
- `ping++ ios sdk` : https://github.com/PingPlusPlus/pingpp-ios
- `ping++ android sdk` : https://github.com/PingPlusPlus/pingpp-android
- `支付流程说明` : https://www.pingxx.com/docs/overview/flow/charge
- `支付系统设计` : http://wiki.office.test.youhujia.com/2016/12/11/payment_overview/

# 支付渠道属性

参见：https://www.pingxx.com/api#支付渠道-extra-参数说明

`微信支付`
![](/media/payment_channel_wx.jpg)

`支付宝支付`
![](/media/payment_channel_alipay.jpg)

`退款相关` 退款时需要注意 退款资金来源 参数的处理
![](/media/refund_funding_source.jpg)

`注意` 按照以上文档定义，并不要求客户端传入任何特有的 extra 参数

# 实现方案

## 状态流转更新
  - 不需要任何状态更新

## 客户端更新
  - ios, android 需要引入ping++ ios/android sdk
  - 具体 call flow 详见上文提到的设计文档
  - 需要向 youhujia 后端传入渠道名称参数 `wx` 或 `alipay`

## Midas 支付系统更新
  - 增加渠道参数 `wx`, `alipay`
  - 原先的 `wx_pub` 会传入extra参数，新的 `wx`, `alipay` 并不需要
  - 按照以上，midas应该已经支持，需确认按照渠道来出来extra参数的逻辑
  - 退款部分，需要确认funding_source的逻辑，详见本文前部分

## Farmer API 更新
  - 注意 `wx` 或 `alipay` 并不需要传入 `open_id`

## owl 更新
  - 无需增加接口
  - 确认可以接收渠道名称参数 `wx` 或 `alipay`，并且不影响原先的 `wx_pub`
  - 类似ToC API，注意确认渠道参数的处理

## 测试总体方案
  - ios, android 测试 支付、退款 流程
  - 原有H5端的支付、退款需要回归

## 开发排期

`注意` 应先快速构建一个demo确认ping++支付流程

module | owner | schedule
-- | -- | --
客户端与后端联合demo | 于俊超 | 1.0
Midas支付流程 |黄英 | 1.0
Midas退款流程 | 黄英| 1.0
Farmer API端 | 黄英| 1.0
Owl端 | 黄英 |1.0
端到端联调 | 黄英| 1.0


