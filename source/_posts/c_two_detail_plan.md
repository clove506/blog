---
title: 【上门护理二期】合肥项目-C端二期详细设计
date: 2017-2-18 13:00:00
categories: 上门护理二期
tags:
- 优护助手
---

## 摘要

合肥项目-患者端详细设计

<!--more-->


# C端二期详细设计

## 类图概要设计

![](/media/c_two_detail_pic.png)

## 接口及接口详情

### 服务详情接口

接口没有改变，因为功能全部不变，只是添加了serviceDetail字段，所有信息通过CAItem注解得到，所以只需在BO里获取就行了。

#### QueryItemBO

获取item里对应的serviceDetail的信息。

### 用户下单前所需item、患者列表信息

接口没有改变，新增用户下拉列表功能，新增服务时间的重新设计。
其他功能不变，在OrderContextFactory里边调用yolar里的列表方法，在QueryOrderBO里返回列表信息。

#### QueryOrderBO

```java
getItemAndUserAddressList(Map<String, String> queryMap){
	//1.填充patientList信息
	//2.填充item信息
	//3.填充服务时间信息
}
//填充patientList信息
buildUserAddressList(OrderContext context);
//从@CAItem注解中获取Item相关信息，填充item信息与服务时间
buildOrderItem（OrderContext context);
buildServingTime（OrderContext context);

```

#### OrderContextFactory

```java
getItemAndUserAddressList(Map<String, String> queryMap) {
	//1.参数校验，检查queryMap里的userId、itemId是否存在
	//2.构建context
	//3.构建Item，通过@CAItem注解获得
	//4.构建Patient，通过@CAPatient注解获得
	//5.添加setPatientList的信息，方案：通过@CAPatient(needAddress = true)注解获得
}
```
### 修改前，查询患者信息	

新增接口：用户点击选择列表里的某个用户，通过patientId查询对应患者的具体信息。

#### QueryOrderBO

```java
getUserAddressById(Long patientId){
	//1.填充UserAddress的基本信息
	//2.填充Address信息
}
```

#### OrderContextFactory

```java
getUserAddressById(Long patientId){
	//1.校验userId与userAddressId参数
	//2.检验合法性：当前用户userId与查询的UserAddress中对应的userId是否相同
	//3.构建context
	//方案：调用halo，查询出来的结果，来构建context
}
```
### 提交修改的患者信息
		
新增接口：用户修改患者的信息。

#### UpdateUserAddressBO

```java
updateUserAddressMsg(Shooter.UserAddressUpdateOption option){

	//1.构建UserAddressUpdateOption
	computerUserAddressUpdateContext();
	//2.调用Yolar中的updateUserAddress方法，执行更新动作
}

```

#### UpdateUserAddressFactory

```java
updateUserAddressMsg(Shooter.UserAddressUpdateOption option){
	//1.校验参数
	//2.构建context
	//3.构建userAddress信息：根据userAddressId判断是否有对应的UserAddress存在
	computerUserAddressContent();
	//4.权限判断：判断用户的userId与userAddress中的userId是否相等
}
```
### 新增患者信息	

新增接口：用户添加新的患者。

#### AddOrderBO

```java
addUserAddressMsg(Shooter.AddUserAddressMsgOption addUserAddressMsgOption){
	//1.构建UserAddressCreateOption
	//2.调用yolar中的createUserAddress方法，进行添加动作
}
//构建患者信息的方法
computerUserAddress(AddOrderContext context);
```

#### AddOrderContextFactory

```java
addUserAddressMsg(Shooter.AddUserAddressMsgOption option) {
	//1.校验参数
	//2.构建context
}
```

### 删除当前患者

新增接口：使用patientId删除当前患者。

#### DeleteBO

```java
deleteUserAddress(Long patientId){
	//1.参数,权限校验
	checkDeleteLegal(userAddressId, queryMap)
	//2.调yolar中的deleteUserAddress方法执行删除操作
}
```

### 用户与患者的关系

新增接口：新需求，用户下单要选择自己和患者的关系。
enum，shooter层调用enum，并返回给前端使用。

#### QueryOrderBO

```java
relationList(Map<String, String > queryMap){
	//1.填充关系列表，并返回结果
	//2.取出context中的enum列表，遍历并添加列表信息
	buildRelation(orderContext);
}

```

#### OrderContextFactory

```java
patientList(Map<String, String > queryMap){
	//1.构建context，即用户与患者的关系列表
	//2.添加关系列表enum，方案：从halo的RelationEnum中取出，并添加
	computerRelation(context);
}

```

### 提交订单
 
接口没有改变：在原来的基础上，把对目前需求多余的字段去掉，添加新的字段，例：备注，服务时间，患者。

#### AddOrderBO

```java
addOrder(Shooter.OrderMsgAddOption orderMsgAddOption){
	//1.构建orderCreateOption
	buildOrder(context);
	//2.调owl中的createOrder方法，执行创建订单操作
}
buildOrder(AddOrderContext context){
	//1.填充患者信息
	//2.填充服务时间的信息
	//3.填充用户的备注
	//方案：在owl的proto里添加notes字段
}
```

#### AddOrderContextFactory

```java
addOrderContext(Shooter.OrderMsgAddOption orderMsgAddOption) {
	//1.校验参数
	//2.构建context
	//3.构建patient的信息
	//4.构建Item的信息
	//5.构建servingTime的信息。
}
```
#### 备注

解决方案：底层owl创建数据时，在proto添加notes字段

## 上线方案
### staging环境
1.依赖：config-repo、halo
2.config-repo线上配置文件
3.调用的服务：owl、dagon、cms、yolar、halo
4.使用的注解所在位置：authorization
### staging操作步骤

#### 把最新代码提交到release分支

1. 提交最新代码到develop分支
2. 在GitHub上，new pull request、create pull request 把develop分支刚提交的代码，发送到release分支
3. merge request

#### 在item中启动：

1. ssh gw01
2. ssh deploy@10.0.0.10
3. cd /opt/zhushou
4. cd /shooter
5. git pull
6. docker ps -a  查看所有
7. docker rm -f "正在运行项目的版本号" 删除
8. docker ps -a
9. ./bin/start.staging 启动项目
10. docker ps -a 
11. docker logs -f "正在运行项目的版本号" 查看是否启动成功




