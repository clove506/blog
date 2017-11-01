
---
title: 护士上门辅助下单功能项目API跳转详情
date: 2017-3-1 11:00:00
categories: 上门护理
tags:
- 上门护理
---

## 摘要

辅助下单B端API详情
<!--more-->


## B端API详细页面跳转

| 页面 | 交互点 | API | 跳转页面 |
| --- | --- | --- | --- |
| 创建服务订单 | 选择患者 | /api/nurses/{nurseId}/patients | 选择患者 |
| 创建服务订单 | 选择服务 |  /api/nurses/order/v1/getAllService?nurseId={nurseId} | 创建服务订单 |
| 选择患者 | 点击空白 |  /api/nurses/order/v1/{userId}/getUserDetail | 创建服务订单 |
| 添加并选择患者 | 完成并选择患者 |   /api/nurses/order/v1/createUser| 创建服务订单 |
 | 添加并选择患者  | 完成并选择患者  |  /api/nurses/order/v1/{userId}/chooseUser| 创建服务订单 |
  | 创建服务订单 | 提交订单 |  /api/nurses/order/v1/createAssistOrder?nurseId={nurseId} | 支付/工作台 |


