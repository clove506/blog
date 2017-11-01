---
title: Push 时机
date: 2017-06-01 17:18:00
categories: notes
---

# 摘要

推送时机整理

<!-- more -->

|      | 场景         | 触发                        | 通道       | 对象   |                    | 备注   |
| ---- | ---------- | ------------------------- | -------- | ---- | ------------------ | ---- |
| 随访   | web端创建     | 创建时                       | 微信模板消息   | 患者   | RedCoast to NSK    | Y    |
|      | web端创建     | 创建时                       | 短信       | 患者   | RedCoast to Singer | Y    |
|      | web端创建     | 随访选定的 dischargeAt 时间（有问题） | App Push | 护士   | RedCoast to NSK    | Y    |
| 评估   | APP发起评估任务  | 评估开始前一小时                  | App Push | 执行护士 | Galaxy to NSK      | ？    |
|      | web端创建评估任务 | 任务开始前一小时                  | Push     | 护士   | Evans to NSK       | Y    |
| 订单   | todo       |                           |          |      |                    |      |