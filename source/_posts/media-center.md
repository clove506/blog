---
title: 媒体中心-知识库-改造方案
date: 2017-02-07 13:00
categories: 系统架构
tags:
- 媒体中心
- 知识库
---

## 摘要

媒体中心 知识库 改造库

<!--more-->

## Wiki维护人

田学文 刘明敏 黄丹 赵蔺 陈晨


# 媒体中心 知识库

## 原则

- 内容和展现分开
- 支持多种场景投放
- 业务无关

## 方案

### 排期

检索系统  15人日开发 + 5人日

录入系统  30人日 + 10人日

更新策略  10人日 + 5人日

### 子系统组成

录入系统 + 检索系统

### 查询模型

TAG

#### 录入系统

增删改

#### 投放系统

检索方式
- Id
- Type
- Scenario
- Tag
- CreatorId&CreatorType

方案

ElasticSearch

Go 手撸

#### TAG模型

Type：Disease
Type：management
Type：treatment

Type：？
Name：？

#### TAG检索模型

打了一个TAG123 

最终检索TAG：TAG1 TAG12 TAG123

## FAQ
### 什么是CMS
content manager system

content：
文章 -> 宣教 新闻通稿
问答类工具 -> 自测 评估  
模板-> 随访模板 某种科室模板 某种商品服务模板 

注意这里没有业务逻辑

### Content有哪些元信息


- CreatorInfo
- Title
- Subtitle
- Description
- Summary
- Content（Style & Text & Scenario）
- KeyWord
- Media（Audio Video Image）
- Category
- Group

**分类**

Group Category 层级信息

## 万家科室项目

新科室进入快速使用，无需申请，配置。

优化整个B/C端使用流程，增加GEO支撑等

### 方案1

全新创建科室，科室样式同现在优护助手C端进入后的样子。

#### 新建科室

期望输入：输入名字 + 选择模板

期望输出：

问题:

- 历史遗漏的入口问题。优护助手和康复宝都可以新建科室，导致脏数据，之前临时修复。
- 验真？脏数据问题


### 方案2

科室的类别来分，创建通用的科室，但是功能需要阉割。


### 方案3

爬所有的医院列表，配合通用的科室来提供功能，如果没有增加反馈渠道，我们批量处理。


### FAQ

#### 当机构增多，如何快速进入。
增加GEO信息。C端需要调研。B/C端交互需要设计。

#### 如何提供用户入口
提供生成二维码的功能，方案B端使用人员提供给C端用户。


### 工作量毛估

产品/交互/运营 详细设计方案 + 沟通调整 3-5天

技术详细方案设计  2-3 天

开发 + 测试 + 上线  10人日

总体控制在三周到一个月，开发控制在两周内，预期投入1.5人开发。

### TODO

- B/C端进入流程梳理
- GIS调研
- 爬取相关调研

