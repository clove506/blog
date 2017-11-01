---
title: 【合肥项目】OWl-Order
date: 2017-1-6 12:00:00
categories: 合肥
tags:
- Order
---

## 摘要

 合肥项目-订单系统相关

<!--more-->
## WIKI维护人
田学文
黄  英

## 说在前面
因为这次项目主要就是针对于接单服务这么一个项目，所依订单有着举足轻重的性质。贯穿了整个下单、接单、服务、结算这么一个整体的流程。每一步操作都需要限制在特定的状态，详情请查看状态流转图。根据此需求我们设计了状态机，从而来实现状态对操作的限制。其他的订单的详细设计不在多说，详情请看下面的订单服务详细设计。
# 订单服务详细设计

订单API详细设计，请点击——>  [订单系统 API](https://github.com/Youhujia/docs/blob/master/backend/product_order/OwlAPI.md)

订单数据库设计，请点击——>  [订单数据库表设计](https://github.com/Youhujia/docs/blob/master/backend/product_order/OrderDatabase.md)

# 上线
## staging环境：
1、依赖：config-repo、 halo（上线必要支持）
config-repo线上配置文件：[owl-staging.yml](https://github.com/Youhujia/config-repo/blob/master/owl-staging.yml)
2、建立数据库：owl
3、调用服务：dagon、midas、sophon（上线时不影响）

## 正式环境：
操作之前：
依赖：config-repo、 halo（上线必要支持）
config-repo线上配置文件：[owl-production.yml](https://github.com/Youhujia/config-repo/blob/master/owl-production.yml)

正式操作步骤
1、登陆center 01服务器
2、切换到/opt/zhushou/目录下
3、克隆线上owl项目：git clone git@github.com:Youhujia/owl.git
4、git log查确认是否为最新项目
4、确认项目为最新切正确，将项目打包
5、将./bin/start.production 文件权限设置为可执行文件
6、启动项目
7、启动完毕，查看是否启动成功




# 项目回顾总结
## 完成流程：
### 设计：
时间点：（2017-12-15～2017-12-16）

1、根据需求来设计商品模型，数据库字段。
2、设计API以及接口的请求和返回内容。
3、根据业务流转状态设计orderState枚举、orderAction枚举以及orderRefundState枚举
4、设计state之间互相转换的模型，限制每个状态下能进行的操作。
5、最后进行每个action操作具体内容进行填充。

### 代码书写：
时间点：（2017-12-17～2017-12-24）

1、进行项目创建以及环境的搭建。
2、对项目的主要框架进行搭建。
3、书写数据库和order 对象。
4、书写状态机，也就是状态的流转框架。
5、对主体的业务代码进行填充书写。
6、添加订单退款的日志代码的书写。
7、书写订单的操作日志代码。
8、对出现的可以重构的代码进行了重构。

### 自我内部测试：
时间点：（2017-12-25～2017-01-05）

1、进行接口请求联通测试，确定请求能正常运行。
2、在允许可操作状态和不允许操作状态下进行操作测试，检验限制设置。
3、和dagon接口、sophon接口测试，确定创建订单的正确性。
3、和midas接口联合测试，确定支付和退款相关接口。
4、和B、C两端联合测试，确定业务逻辑的正确性。

### 联合测试参与验收：
时间点：（2017-01-06～2017-01-10）

1、和订单相关的项目，以及前端一起联合测试。
2、修改测试中出现的bug。

## 项目亮点：
### 1、组合查询
可以查询多个状态的下的订单，订单状态个数不限，状态之间可依随意组合。

#### 组合查询使用范例代码：

```
 String select = "select o from Order o";
    String count = "select count(o) from Order o";

    String query = " where o.del = :delete "
        + "AND (:hasState is null OR o.status in (:statusList)) "
        + "AND (:nurseId is null OR o.nurseId = :nurseId) "
        + "AND (:userId is null OR o.userId = :userId) "
        + "AND (:departmentId is null OR o.departmentId = :departmentId) "
        + "order by o.id";

    @Query(value = select + query,
        countQuery = count + query)
    Page<Order> query(@Param("delete") Boolean delete,
                      @Param("hasState") Boolean hasState,
                      @Param("statusList") List<Long> statusList,
                      @Param("nurseId") Long nurseId,
                      @Param("userId") Long userId,
                      @Param("departmentId") Long departmentId,
                      Pageable pageable);
```
说明：如代码:hasState is null OR o.status in (:statusList)，当hasState为空的时候，则查询所有状态的记录，否则（OR）则在statusList这些状态之中。

#### 分页Pageable代码：

```
Pageable pageable = new PageRequest(
            queryContext.getIndex(), queryContext.getSize(), Sort.Direction.DESC, "id");
```
说明：index 为页码下标，从0开始
		size 为每页数量
		Sort.Direction.DESC 该例为按照id倒序。
		
		
### 2、状态机
因为对订单的每个操作都是限定在特定的状态下的，所以设计了状态机来实现，状态机也是本次项目的一个亮点。
实现方式以及相关中心代码：
#### 创建一个OrderStateEnum列举出所有的状态枚举：
将现有的状态进行列举，如果有新加的状态只需要加入该枚举，从而实现对状态的控制。
具体枚举：[state 枚举](https://github.com/Youhujia/docs/blob/master/backend/product_order/OwlAPI.md)

#### 创建一个OrderActionEnum列举出所有的状态枚举：
将现有的动作进行列举，如果有新加的动作只需要加入该枚举，从而对动作实现控制。
具体枚举：[action 枚举](https://github.com/Youhujia/docs/blob/master/backend/product_order/OwlAPI.md)

#### 创建一个StateActionUnit 接口：

```
public interface StateActionUnit {

    void invoke(OrderContext context, OrderActionEnum orderActionEnum);

    OrderState getUnitOrderState(OrderContext context);
}
```
#### 实现基类 

然后创建一个BaseUnitInvoker的抽象类来实现StateActionUnit接口，从而从整体控制全部状态，我们首先会取到操作的该订单的状态，该状态在orderStateEnum枚举状态内，我们才会执行接下来的动作，否则返回错误信息：“state is not in states”


```
public abstract class BaseUnitInvoker implements StateActionUnit {

    @Override
    public void invoke(OrderContext context, OrderActionEnum orderActionEnum) {
        if (context.getOrderState() != getUnitOrderState(context)) {
            throw new YHJException(OwlExceptionCodeEnum.STATE_NOT_EXIST, "Not in state");

        }
        context.setOrderActionEnum(orderActionEnum);
        actualInvoke(context, orderActionEnum);
    }

    abstract public void actualInvoke(OrderContext context, OrderActionEnum orderActionEnum);
```

#### 创建具体状态的类实现BaseUnitInvoker类
例如：（payingUnit）未支付状态的具体实现类：
未支付状态下只能发起的动作USER_PAY、USER_CANCEL、UNPAID_TIMEOUT如果在该状态下的执行的动作不在这三个动作内，则会返回错误，错误信息为“state do not allow current action”。正确的话，就会根据动作执行相应的操作，从而对订单进行操作。



```
@Component
public class PayingUnit extends BaseUnitInvoker {

    @Override
    public OrderState getUnitOrderState(OrderContext context) {
        return OrderState.PAYING;
    }

    @Override
    public void actualInvoke(OrderContext context, OrderActionEnum orderActionEnum) {
        String where = "PayingUnit->actualInvoke";

        switch (orderActionEnum) {
            case PAY_SUCCESS:
                paySuccess(context);
                break;
            case USER_PAY:
                handlePay(context);
                break;
            case USER_CANCEL:
                userCancelOrder(context);
                break;
            case UNPAID_TIMEOUT:
                unpaidTimeout(context);
                break;
            default:
                logger.error(LogInfoGenerator.generateErrorInfo(where, OwlExceptionCodeEnum.ACTION_NOT_ALLOWD, "PAYING " + orderActionEnum.name(), "order", context.getOrder()));
                throw new YHJException(OwlExceptionCodeEnum.ACTION_NOT_ALLOWD, "PAYING " + orderActionEnum.name());
        }
    }

    @Transactional
    private void handlePay(OrderContext context) {
    //具体操作
    }

    private void paySuccess(OrderContext context) {
    //具体操作
    }

    private void userCancelOrder(OrderContext context) {
    //具体操作
    }

    private void unpaidTimeout(OrderContext context) {
    //具体操作
    }
}
```






## 总结：
### 项目总结：
针对owl工程总体来说，完成的过程总体比较平稳，完成的效果和预期基本一致，虽然完成的时间比预计的多用了一天时间，但是所差的都是一些内部代码，不耽误总体项目的进度，所以总体还是可以接受的。
详细的来说在开发的过程中还是存在一些问题，具体如下：
1、在状态的流转设计和书写中，因为开始针对于state具体跳转的设计有不同意见，导致状态机的产出时间较晚，进而影响了项目的开发时间。
2、设计时考虑的不够完善，导致在开发中，会加入一些那些没有考虑完备的东西，所以有时候会导致代码结构的变动，或者部分代码的重写。
以上的问题，通过仔细的考虑设计和对项目的业务细节进行仔细了解以及良好的沟通，就可以有效的降低，所以以后能从此借鉴，能更好更快的完成。

### 个人总结：
对于自己来说这是个人时加入公司开始的第一个项目，在项目开始的时候，感觉到有对于开发未知的紧张压迫也有开始新项目的期待。继而在学文哥指导下开始了对项目的开发，在开发过程中，自己也遇到了大大小小的问题，下面记录几个印象较为深刻的，
自己完成项目过程的问题：
1、refundCord，退款各个的过程自己考虑的不是周全，所以导致refundCord设计不够完善，最后在学文哥和深入开发中逐渐解决。
2、operationLog，自己没有考虑到要记录动作之前的状态和动作后的状态，最后在晨哥和学文哥指导下完善。
3、组合查询，开始自己是根据请求的参数来判断，从而进行查询，这种方法是是最笨的方法，因为随着参数个数的增加，判断条件会几何增长，所以是不可取的。最后学文哥采取了query注解加入sql语句的in语法，直接很好的解决了这个问题。
最后，通过此次开发自己感觉到了成长，同时也感觉到了自我价值的实现，总体完成了自己的任务。





