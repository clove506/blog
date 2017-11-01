---
title: 【合肥】系统公共服务二期-高频对象工厂/RPC调用易用性升级/并发&资源锁
date: 2016-12-14 17:00:00
categories: 合肥
tags:
- 公共服务
---

## 摘要

二期的详细内容。

<!--more-->

## WIKI维护人
陈晨

## 背景

### 高频对象工厂
系统公共服务一期上线了快速获取Nurse信息的注解，通过加注解，可以在Localthread中设置相应的线程独享上下文，在通过统一的工厂获取，使用简单，方便，屏蔽了各种底层获取逻辑，异常处理等。二期打算对该部分逻辑进行升级，覆盖到患者信息，订单信息。

### RPC调用易用性升级
我们的RPC调用结合了很多内容，在使用上已经相对方便，只需要引入Halo包，调用相关应用的Inteface方法即可。但是这里忽略了统一的异常处理，调用日志，断路处理等，各个应用方需要写很多冗余的样板代码。本期需要对新提供的RPC调用提供上述统一的处理，旧接口，兼容升级。

### 并发&资源锁

提供对并发和某些资源的锁机制，保护系统安全。

## 详细设计


### 高频对象工厂-提供订单、患者、服务商品、护士信息的快捷访问

**注意：本次升级不向前兼容**

#### 思路

通过在方法上加入Halo指定的注解，通过AOP方式从Http的Header中获取必要参数，将构建好的HaloContext中放入Localthread，最终通过统一的接口对外提供Context。

**注解**

- @CNurse
- @CPatient
- @Admin
- @COrder
- @CItem

其中的C是Context的缩写，避免和其他JAR提供的注解冲突。


**HaloContextFactory中的获取方法**

``` java
private HaloContext getUserContextFromRequest()
```


**HaloContextFactory中的构造方法**

``` java

public HaloContext buildContextFrom(HaloEnum haloEnum, Annotation contextAnnotation)

```

构造方法中会在AOP中统一通过切点进入。


其中的HaloEnum和注解一一对应（方便使用，其实可以通过反射加规约实现）

``` java
public enum HaloEnum {
    Nurse,
    Patient,
    Admin,
    Order,
    Item
}

```

contextAnnotation 即是上面创建的注解

**HaloContext的内容**

HaloContext的内容就是对应注解的标注的内容，如Nurse，会有Nurse的基本信息，Tag信息等。


**HaloContextFactory**

构建过程就是调用各个底层service拼接Context中定义内容的过程。

**性能问题解决方法1**

例如Order中会有Order信息，Action信息，护士信息，患者信息，如果一口气全获取会造造成很多无误的IO，这里讲获取的权利交给使用放，通过在注解中添加各类参数。

``` java

@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface CNurse {
    //you can use string below for convenience
    boolean needTag()  default false;
}

```

**性能问题解决方法2**

一个应用中不同的方法可能都用到了同一个注解，如果每次都获取一遍，性能会非常差，这里做了一个优化，如果当前线程中已经保存了注解对应的内容，则直接返回不保存。


#### TODO

完善Item Order的内容，这里要根据学文产出的OrderAPI来定制，放到后续工作中。


### RPC调用易用性升级

把旧的PRC调用和新的调用改造成如下内容，需要注意以下几个方面：

- 异常方法的处理
- 各种日志
- 完善断路器
- 对异常情况抛统一的YHJException

``` java

public Yolar.NurseDTO getNurseByToken(String token) {

        String where = "UserServiceWrap->getNurseByToken";

        Yolar.NurseDTO ret;

        try {
            ret = yolarClient.getNurseByToken(token);
        } catch (Exception e) {
            logger.error(YHJExceptionCode.THIRD_SERVICE_EXCEPTION.getMessage4Log(), e);
            throw new YHJException(YHJExceptionCode.THIRD_SERVICE_EXCEPTION, where + "unknown exception");
        }

        if (!ret.hasResult()) {
            String logMessage = LogInfoGenerator.generateErrorInfo(where,YHJExceptionCode.THIRD_SERVICE_EXCEPTION,"api result empty","token",token);
            logger.error(logMessage);
            throw new YHJException(YHJExceptionCode.THIRD_SERVICE_EXCEPTION, logMessage);
        }

        if (!ret.getResult().getSuccess()) {
            String logMessage = LogInfoGenerator.generateErrorInfo(where,YHJExceptionCode.THIRD_SERVICE_EXCEPTION,"api result not success","token",token,"result",ret);
            logger.error(logMessage);
            throw new YHJException(YHJExceptionCode.THIRD_SERVICE_EXCEPTION, logMessage);
        }

        //不是出错信息
        if (!ret.hasId()) {
            return null;
        }

        return ret;
    }

```

### 并发&资源锁

新建请求如果并发的话会造成同样内容的脏数据，为了避免这种情况需要加并发锁，该锁在特定时间内会失效。失效后并不会对原有业务或者系统造成影响。

并发锁并不能保证资源同一时间只能只有一方来操作，如果多方的动作是互斥的，则会造成不可预期的影响，这种情况下需要对资源加锁。 这种类型的锁需要根据业务的特点来判断锁是否超时失效，针对这种情况，提供了两种锁的思路，一种是超时自动释放的锁，一种是不会失效的锁。

不会失效的锁在异常情况下需要业务方根据业务特点自动解决异常，如通过检查，发现锁可以被去除，则业务方需要自主调用去锁方法。

相关详情查看: [锁](http://wiki.office.test.youhujia.com/2016/12/13/Hefei_C_Lock/)


## 时间点

工作内容 |  内容详情 | 人日
------------ |-------- | -------------
高频对象工厂  | 1. 确认Item Order 内容详情，制定API <br> 2.  代码编写 <br> 3. 测试 |  3人日
RPC调用易用性升级 | 1. 优先保证新接口的内容，有各自项目Owner自己评估时间，整合到HALO中。<br> 2. 旧接口改造升级（这次业务代码中用到的接口来改造，比如用户相关内容）。 | 2人日
并发&资源锁 | 详细内容参考 [锁](http://wiki.office.test.youhujia.com/2016/12/13/Hefei_C_Lock/) | 大致5-6人日，已经单独启动 

总体需要投入5人日开发。



