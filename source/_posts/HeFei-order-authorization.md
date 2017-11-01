---
title: 【合肥项目】用户中心三期-提供科室权限/护士接单权限/护士服务权限/用户体系迁移
date: 2016-12-14 16:40:05
categories: 合肥
tags:
- 合肥
---

## 背景


## Wiki 维护人
ListenYoung

## 内容
### 定义科室是否提供服务：
加入新的tagType: DepartmentProvideService，类型为此类的tag的name和departmentId属性均为对应department的id，使用时，通过提供的get方法是否可以寻找到tag对象来确认department是否可以提供服务；同时提供了此类tag的增、删（tagId, departmentId）、查(tagId, departmentId),以及isSupportedService接口。
详见halo工程下YolarClient：

/api/departments/{departmentId}/provide-service
创建一个tag，标识此科室提供服务

/api/departments/{departmentId}/provide-service/{id}
通过tagId删除此tag（科室取消提供服务）

/api/departments/{departmentId}/provide-service
通过departmentId删除此tag（科室取消提供服务）

/api/departments/{departmentId}/provide-service/{id}
通过tagId获取该tag

/api/departments/{departmentId}/provide-service
通过departmentId获取此tag

/api/departments/{departmentId}/provide-service/isSupportedService
通过departmentId来得知该科室是否对外提供服务


### 护士是否能被派单：
加入新的tagType为：

Notification（接收通知），用来标识护士可以被派单

通过查询是否存在type 为Notification的tag来标识该护士是否接收提醒

上述操作均可以通过之前的接口进行实现，护士是否能被派单并没有新增对外接口

### 护士提供服务：
加入新的tagType分别为：
NurseService（护士提供服务），其name对应为服务的itemId；

通过遍历该department下type 为 NurseService 的所有tag 可以获知该科室可以提供的所有的服务（getTagsByDepartmentIdAndTagType）；

护士能提供的服务通过关联表nurse_tag来保存，通过增加1条记录表示该护士可以提供这项服务；删除一条记录表示护士不再提供这项服务。

科室是否对外提供某项服务通过添加或删除tag来完成，添加/删除的逻辑和之前的一样，走之前的老接口

## 时间排期
内容 | 详情 | 人日 | 完成情况
--- | --- | --- | ----
Era Nurse 服务模型 | 1. department tag 定义科室是否提供服务|1|ok
|2. nurse tag 实现护士是否能提供服务|1|ok
|3. nurse tag 实现护士是否被派单 |1|ok


