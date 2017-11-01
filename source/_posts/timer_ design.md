---
title: 【合肥项目】Timer子系统设计
date: 2016-12-10 15:16:15
categories: 合肥
tags:
- Feature
---


## 摘要

对合肥项目---Timer子系统的设计详情

<!--more-->

## WIKI维护人
袁鑫<br/>
陈晨

## 背景

### 什么是Timer?
Timer就是定时器，功能是在指定的时间触发指定事件,和在指定的时间间隔内反复触发指定事件。<br/>
*例如：在5分钟后输出"你好"；每2分钟输出“你好”。*

### 为什么用Timer？
因为这次项目中，在对订单的处理中，有很多在指定时间后触发的状态转换，所以需要一个定时器去处理这些业务。如果不使用对这些指定时间后的操作，肯定难以处理。

## 主要业务
主要负责间接扫描数据库的Order，当有Order处于需要时间调度时（持续处于以下红色状态并超过指定时间时），就对此Order状态进行相应转换。

![](/media/QQ20161209-0.png)

## 正常实现流程
设定每分钟对数据库进行一次扫库，当有order处于以上状态时，并且其更新时间和现在时间之差大于等于约定时间时，并对这些order根据相应的状态，则调用Order系统的接口进行相应状态转换。
![](/media/QQ20161210-1.png)


## 实现技术
#### 调研技术
调研技术有JDK的Timer类、ScheduledExecutorService类、Spring内置的@Scheduled注解和Quartz框架。

1. 对于Timer,所有的TimerTask只有一个线程TimerThread来执行，因此同一时刻只有一个TimerTask在执行；Timer线程并不捕获异常，所以任何一个TimerTask的执行异常都会导致Timer终止所有任务。
2. 对于ScheduledExecutorService，能弥补上述问题，但是对于特定的复杂时间处理困难。
3. 对于Spring内置的@Scheduled注解，功能单一，也能应付复杂时间处理。
4. Quartz框架，能实现上述技术，使用复杂度较高。

##### 使用Spring内置的@Scheduled注解
整体框架用SpringCloud，用Spring的@Scheduled更贴切、方便，也能应付相应的业务需求。

## 实现类图

![](/media/QQ20161210-2.png)


## 测试方案
对Timer所依赖的OrderSystem,可以先模拟出数据Order的数据。<br/>
测试持续时间大于等于指定时间之差，能否进行对应状态转换，并记录着成功的日志；<br/>
```
[INFO]{'orderId':998,'statusStart':'待支付','statusEnd':'关闭','operateTime':2016-12-10 17:12:46.224}
[INFO]{'orderId':998,'statusStart':'待支付','statusEnd':'关闭','successTime':2016-12-10 17:12:47.085}
```
测试持续时间小于指定时间之差时，不操作；<br/>
模拟OrderSystem的数据例如：
```json
{
"orders":[
	{
		"orderId":998,
		"status":3,
		"updatedAt":1479712913000
	}
 ]
}
```


## 运维
加入日志记录，对每一个需要发送给OrderSystem的订单信息，进行记录；发送成功也需要记录；例如：
{'orderId':998,'statusStart':'待支付','statusEnd':'关闭','operateTime':2016-12-10 17:12:46.224}<br/>{'orderId':998,'statusStart':'待支付','statusEnd':'关闭','successTime':2016-12-10 17:12:47.085}<br/>
### 异常发生
#### 影响
未及时转换订单的状态。
#### 处理方式
可以通过日志，检查影响的订单，对受影响的订单手动请求做出相应的后期操作。<br/>
例如：处理待支付状态超时订单，还未调用OrderSystem进行状态转换时，断电！可以手动发出关闭该订单的请求。


## 排期
内容 | 内容详情 | 工作日 | 完成情况
------ | ------- | ------ | ------
搭Timer框架 | 1.搭建基本的gradle框架 <br> 2.搭建抽象的业务框架 | 1人日 | √
具体实现 | 1.实现简单业务流程现实 <br> 2.完善整个业务流程实现 | 1人日 | √
模拟自测 | 模拟数据，进行自测 | 1人日 | √

## 上线流程

#### 上线前准备

* 检查dimension-staging.yml和dimension-production.yml文件的env,client.serviceUrl.defaultZone等参数，敲定timer的每个特定时间。

#### 上线步骤
1. 登录到centor01服务器
2. cd /opt/zhushou/
3. 执行命令ll 查看是否有dimension文件夹
4. 如果没有执行命令 git clone git@github.com:Youhujia/dimension.git，如果有直接cd dna进去，git checkout master分支上
5. git pull 拉下最新代码
6. git log 查看版本是否是最新提交的
7. 如果是最新的，进行打包gradle build
8. 执行netstat -an | grep 5117和netstat -an | grep 5118命令，检查端口是否被占用
9. 如果都没有被占用，则执行./bin/start.production，如果被占用则尝试第8步，选取两个端口，执行命令CONFIG_URL=http://10.0.0.6:5001/ IP=10.0.0.6 PORT=4117 MPORT=4118 ENV=production gradle go
10. docker ps查看项目启动上去与否
11. docker logs -f xxxxxxxx 查看启动进度是否成功。
