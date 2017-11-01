---
title: 上线流程
date: 2017-05-19 13:00
categories: 上线流程
tags:
- 运维
---


## 摘要

上线流程

<!--more-->

## 后端

代码由develop->release->master提交，即可完成各环境docker image的构建。

develop、staging的部署均是自动的，production部署需要手动点击。

涉及halo改动的，要先将halo提到master，再将其他项目release上build.gradle文件中的release编译参数的halo版本更新。
再并入master。


## 前端

代码由develop->release->master提交，即可完成各环境docker image的构建。

develop、staging的部署均是自动的，production部署需要手动点击。
