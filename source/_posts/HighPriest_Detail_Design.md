---
title: HighPriest项目（一期）详细设计
date: 2017-02-20 14:00
categories: 系统架构
tags:
- CI
---


## 摘要
鉴于前次项目连夜上线的惨痛经历，HighPriest项目目的是建立一套持续测试集成，持续部署的系统。

![项目逻辑拓扑图](/media/jenkins_top.png)

### 本期目标
- 在阿里云容器服务上搭建开发，预发，生产环境
- Jenkins服务进行后端代码PR测试、Push的测试与部署
- git flow规范的全面普及

### 待完成任务
- 代码检查
- 可视化开发页面
- 通知
- 前端&App项目部署

### 存在问题
- gradle SNAPSHOT 的同步问题。
- Nexus&Jenkins磁盘占用。
- 大家的开发规范。
- Sleuth

## CI&CD
采用Jenkins做CI，用脚本部署到容器服务做CD。

### jenkins
每一个服务需要有4个jenkins pipeline:
- project-dev:
	建立pipeline， copy from template-dev，从develop拉取代码，做build基本检查，构建image到aliyun镜像站，重新部署对应应用，
- project-staging:
	建立pipeline， copy from template-staging，增加当前tag的最后一位，添加为新的tag，push tag。构建镜像到aliyun镜像站，重新部署应用。
- project-pro:
	建立pipeline，copy from template-pro，更新线上项目。
- project-pr:
	建立pipeline， copy from template-staging。做代码检查，审核Pull Request。

### 镜像命名方案
dev：名字为每次提交hash前10位，并提交最新版本为latest到镜像库。
staging&pro：名字为git tag version，并提交最新版本到镜像库。

## 迁移方案

## 开发方案
### halo
通过gradle build，参数。
- develop: 部署到maven的SNAPSHOT库。
- staging，production: 上传maven的Release库。

### 其他项目
- 用aliyun账户关停dev集群的服务，在本地通过参数建立服务。
- 端口号暂时写死。
### 开发流程

## 上线方案
staging和production采用一个compose来创建应用。
### staging
- 上线方式：rolling update。
- gateway: 蓝绿发布
### production
- 首次：构建一套新环境，修改SLB流量。
## 回滚方案
- develop环境：jenkins重新构建
- staging&production：Jenkins重新提交

## 多容器部署
@袁鑫
改造，测试完毕。等待上线。

## 代码检查
### checkstyle
### findbugs

## 阿里云运维改造

### 综述
- gw01:作为网关，用SNAT作为所有内部服务向外访问的出口。
- ssh01:作为跳板机，登录youhujia各种服务器，各人员权限通过user list定义。
![运维改造](/media/aliyun_top.png)

## 线上事故预案
### 容器集群宕机
SLB改流量到staging环境，staging环境修改配置重新部署。

## 通知
### E-Mail
### DingDing
### Others

## 开发人员页面设计

Shaman项目 ![wiki](http://wiki.office.test.youhujia.com/2017/02/28/Shaman_Detail_Design/)
