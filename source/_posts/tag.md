---
title: Tag 设计
date: 2017-01-05 21:47:13
categories: design
tags:
- design
- tag
---

# 摘要

关于 Tag 的设计

<!--more-->

# Other System Using the Magic Tag

todo

# 科室 Auth_Code

之前 KFB 中，部分科室要求用户扫码后，还需要填写预设的验证码才能进入科室，现在 KFB 迁移，相关逻辑需要移到新系统中，决定用 Tag 来实现该功能。

## Design

给设置了 AuthCode 的科室建立一个 `AuthCodePass` tag，User 关联上这个 Tag 后，就表示该 User 通过了检查。

## Detail

AuthCode Tag in DB：

| name                        | type | org_id         | dpt_i          |
| --------------------------- | ---- | -------------- | -------------- |
| AuthCodePass (Fixed String) | 8    | org it belongs | dpt it belongs |





