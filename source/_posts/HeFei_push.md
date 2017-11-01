---
title: 【优护助手-合肥】合肥项目--push子系统
date: 2016-12-13 11:30:00
categories: 合肥
tags:
- 优护助手
---
## 摘要
合肥项目Push子系统设计详情

<!--more-->
## WIKI维护人
袁鑫<br/>
陈晨<br/>
田学文<br/>

## 背景

### 什么是Push?
push意为推，即推送之意，可以理解为消息的推送。

### 为什么需要Push？
因为我们的业务涉及的不是单机交互，是为了服务护士和患者，所以在护士或者患者操作订单时，有些时候也需要让另一方知道操作的内容。例如：护士接单，需要告诉患者“您的订单已被接单了”，以及护士的信息。

## 主要业务
当不同动作发生时，填充相应的内容，并调用其他接口发送推送消息给护士或患者。

| push场景       | 接收者|触发该Push的状态|push内容   | push方式|
| ------------- | --------------- | -------|-----------|------------- |
|患者支付超时|患者|待支付、支付中|您的订单由于长时间没支付，已被取消。|微信内推送   |
|患者支付成功|护士|支付中|您有新的可接接单。|App提醒|
|订单2小时无人接单|患者|高优先待接单、派单|您的订单超时无人接单，正在给您退款。|微信内推送|
|同意退款|患者|退款申请中、服务纠纷|您的退款已被同意，正在给您退款。|微信内推送|
|护士取消订单|患者|服务中|抱歉！为您服务的护士已取消订单，正在给您退款。|微信内推送|
|患者申请退款|护士|服务中、服务完成|您的订单患者正申请退款。|App提醒|
|患者取消退款|护士|退款申请中、服务纠纷|您的订单患者已取消退款|App提醒|
|护士接单|患者|待接单|您的订单已接单，点击查看订单详情。|微信内推送|
|接单后患者发起退款，护士拒绝|患者|退款申请中|您的退款申请护士已拒绝，等待客服人员处理，点击查看订单详情|微信内推送|
|接单后患者发起退款，超时|患者|退款申请中|您的退款申请由于长时间无人确认，需等待客服人员处理，点击查看订单详情。|微信内推送|
|服务纠纷时，运营拒绝退款|患者|服务纠纷|您的退款申请客服人员已拒绝，点击查看订单详情。|微信内推送|
|服务中，护士进入纠纷|患者|服务中|为您服务的护士选择进入纠纷，点击查看订单详情。|微信内推送|
|服务开始|患者|待服务|您的订单服务已开始，可以查看宣教内容，点击查看详情。|微信内推送|
|服务超时/异常|护士|服务中、服务超时|您的订单已超时，请尽快完成服务。|App提醒|
|服务完成（护士触发）|患者|服务中|护士已完成订单所有服务步骤，请及时做出评价。|微信内推送|

## 业务流程
通过监听数据库binlog来了解Order的改变，根据其改变去判断哪些需要push，对需要push的改变，然后填充相应的推送内容，最后调用Singer接口push到设备上。
![](/media/QQ20161213-1.png)

## 实现
### 实现技术
* Open Replicator是一个用Java编写的MySQL binlog分析程序。Open Replicator 首先连接到MySQL（就像一个普通的MySQL Slave一样），然后接收和分析binlog，最终将分析得出的binlog events以回调的方式通知应用。
* 使用Spring Boot整合RabbitMQ，做消息队列的实现，以防信息断电丢失，SpringBoot的AMQP模块就可以很好的支持RabbitMQ。
以Open Replicator监听binlog,Spring Boot整合RabbitMQ做消息队列。
### 类图
![](/media/QQ20161213-0.png)

## 测试方案
启动Push项目，然后对数据库的Order更改，来触发消息的推送。
<br/>
随后即可在微信上看到推送的消息。

## 运维

加入日志记录，对每一个push成功的操作和基本的异常，进行记录。例如：
```
{‘userId’:98,’operate’:‘护士接单’,’successTime’:2016-12-10 17:12:46.224}
{‘nurseId’:98,’operate’:‘患者退款’,’successTime’:2016-12-10 17:12:46.224}
```

## 排期
内容 | 内容详情 | 工作日
------- | --------- |-----------
调研 | 1.调研阿里云云数据库RDS的binlog接口  √ <br> 2.调研Open Replicator的使用 √ | 2人日
具体实现 | 1.搭Push框架  √ <br>  2.接入Open Replicator的使用 √ <br> 3.根据需要push的动作处理binlog返回的Event √ <br> 4.指定push的具体内容 √ | 4人日
模拟自测 | 1.测试binlog返回的Event是否正常 √ <br> 2.测试修改Order能否返回需要的push内容 √ | 2人日

## 上线流程

#### 上线前准备

* 检查线上binlog是否开启；
    * 命令行执行mysql.server start,开启mysql，执行mysql -hxx -uxx -pxx进入数据库
    * show variables like 'log_bin'; 查看log_bin的value是否为ON，ON为开启。
    * show master status;查看当前正在写入的binlog文件
* 敲定线上RocketMQ的ConsumerId、ProducerId、topic配置信息；
* 检查dna-staging.yml和dna-production.yml文件的env,client.serviceUrl.defaultZone等参数，敲定各个状态push的文案内容；
* 把项目release分支提pull request到master分支，检查无误，进行merge。

#### 上线步骤
1. 登录到centor01服务器
2. cd /opt/zhushou/
3. 执行命令ll 查看是否有dna文件夹
4. 如果没有执行命令 git clone git@github.com:Youhujia/dna.git，如果有直接cd dna进去，git checkout master分支上
5. git pull 拉下最新代码
6. git log 查看版本是否是最新提交的
7. 如果是最新的，进行打包gradle build
8. 执行netstat -an | grep 5115和netstat -an | grep 5116命令，检查端口是否被占用
9. 如果都没有被占用，则执行./bin/start.production，如果被占用则尝试第8步，选取两个端口，执行命令CONFIG_URL=http://10.0.0.6:5001/ IP=10.0.0.6 PORT=4115 MPORT=4116 ENV=production gradle go
10. docker ps查看项目启动上去与否
11. docker logs -f xxxxxxxx 查看启动进度是否成功。




