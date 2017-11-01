---
title: 【上门护理二期】微信公众号支付二期支持
date: 2017-02-10 13:20:00
categories: 上门护理二期
tags:
- 上门护理
- 合肥
- 支付
- 二期
---

# 摘要

微信支付时，对微信“取消”和“失败”的状态返回进行获取，返回待支付状态

<!--more-->

# WIKI 维护人

黄丹

# PM

黄丹

# 支付库支撑
ping++ sdk 已可支持 `cancel`, `fail` 回调状态：https://github.com/PingPlusPlus/pingpp-js

```
pingpp.createPayment(charge, function(result, err){
  if (result == "success") {
    // 只有微信公众账号 wx_pub 支付成功的结果会在这里返回，其他的支付结果都会跳转到 extra 中对应的 URL。
  } else if (result == "fail") {
    // charge 不正确或者微信公众账号支付失败时会在此处返回
  } else if (result == "cancel") {
    // 微信公众账号支付取消支付
  }
});
```

# 实现方案 - `A` 注：已改用方案`B`
## 状态流转更新
  - 起始：用户点击 支付按钮 后，弹出微信支付界面，此时状态因为 `支付待确认`
  - 流转：用户点击微信支付取消，或者微信支付操作失败，此时ping++ sdk 将回调 `cancel` 或 `fail`，触发接口
  - 结束：状态应变更为 `待支付`

## 前端更新
  - 更新到最新ping++ js sdk
  - 添加 cancel 和 fail 的处理

## ToC shooter API更新
  - 增加接口，处理 前端收到的 cancel 和 fail 状态

## owl 更新
  - 支持以上增加的状态流转

## 测试方案
  - 回归
  - 新状态测试

# 实现方案 - `B`
## owl 更新
  - 修改从 `支付待确认` 状态 到 `关闭` 状态 的流转触发 `用户取消`
  - 方法：当用户取消时，owl主动请求查询一次charge状态，如果是 `paid` 则不能流转到 `关闭状态`，如果是 `unpaid` 或 `expired` 则可以取消订单

## 其他模块
  - 无

## 测试方案
  - 测试场景：支付对话框弹出后，点击取消支付按钮
  - 重点回归 下单，支付，取消

## 开发排期
module | owner | schedule
-- | -- | --
owl | 黄英 | 0.5
联调 | | 0.5
