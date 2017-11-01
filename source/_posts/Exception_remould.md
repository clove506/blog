---
title: 【Exception】相关改造以及规范
date: 2017-03-27 12:10:00
categories: 代码规范
tags:
- Exception
---


## 摘要

Exception 相关改造以及抛错规范

<!--more-->

## WIKI维护人

黄  英

### 为什么要做

#### 显示给用户更合理：

为了给用户显示的异常显示更为合理，所以需要去掉异常信息的前缀，例如之前抛给用户的异常信息：参数错误，info：手机号码不能为空。这样看起来很不合理，所以现在改造为：手机号不能为空。

#### 显示给开发人员更简明：

现在在一个项目调用另外一个项目的时候，我们都是通过halo项目调用的，在调用时我们做了一个抛错的处理，但是正式因为这样导致下层的错误会在这儿进行一次封装，导致如果是下层抛出错误时我们看到的错误都是经过包装的，要是项目之间一层调用一层的话，这样就会导致真正的错误信息被持续包裹，导致我们看错误时很难筛选出有用的信息。所以我们需要这儿进行处理让下层的错误能够很直观的一层接一层的抛出，最后直观的显示。

#### 出现错误时能快速定位错误：

由于我们使用的是微服务架构，一个模块就是一个项目，所以导致项目的数量很多，排查问题很难定位。为了在出现异常信息的时候，我们开发人员能直接找到异常的根源所在，我们需要在异常信息前加一个标记。这个标记就是traceId，那么traceId又是什么呢，请看下面
随着微服务数量不断增长，需要跟踪一个请求从一个微服务到下一个微服务的传播过程， Spring Cloud Sleuth 正是解决这个问题，它在日志中引入唯一ID，以保证微服务调用之间的一致性，这样你就能跟踪某个请求是如何从一个微服务传递到下一个。Spring Cloud Sleuth在日志中增加两种ID 类型，一个是trace ID，另外一个是span ID，span ID代表工作基本单元，比如发送一个HTTP 请求；treace ID包含一系列span ID，形成一个树状结构。

### 怎么做

#### 直接抛出底层错误信息

1. 添加字段。现在的封装错误信息的result，其中的的字段都是进行过封装的，如果我们需要拿到原始信息就需要对result添加字段，添加的字段为：msgOnly4Log、msgOnly4Show、info
2. 重新封装result。在封装底层的result时，将其原始信息添加到result中。
3. 在halo中抛出指定的第三方异常（THE_THIRD_PARTY_EXCEPTION）。如果下层返回的result不为空并且success字段值为false时，会重新抛出异常，这时候抛出的异常我们指定抛出第三方异常。
4. 为第三方异常创建一个新的YHJException构造方法。因为在抛第三方异常的时候需要将下层的信息重新抛出，所以需要重新添加一个构造函数将下层错误信息抛出。
5. 在检测异常为第三方异常的时候，需要新添加一个新的result值的封装方法。因为第三方抛出的异常信息和其他异常信息封装的不同，所以需要重新添加一个方法。

#### 展示给非用户的错误信息时，加上一个traceId

1. 处理Message4Show的时候，在其前面加上一个traceId，详情见代码块4

#### 展示给用户时，直接显示最直观错误信息 

1. 指定一个特定的展示给用户的异常：SHOW_EXCEPTION_INFO_TO_USER
2. 处理Message4Show的时候，根据是否是展示给用户的异常，来进行具体的处理，详情见代码块4

### 实现核心代码：
 
#### 代码块1:添加字段

```
message Result {
    optional bool success = 1;
    optional int64 code = 2;
    optional string msg = 3;
    optional string displaymsg = 4;
    optional string msgOnly4Log = 5;
    optional string msgOnly4Show = 6;
    optional string info = 7;
}
```

#### 代码块2:封装result
        
```
if (yhje.getCode() == code && msgOnly4Log.equals(yhje.getMessage4Log()) && msgOnly4Show.equals(yhje.getMessage4Show())) {
            return COMMON.Result.newBuilder()
                .setSuccess(false)
                .setCode(yhje.getRealCode())
                .setMsg(yhje.getMessage4Log())
                .setDisplaymsg(yhje.getMessage4Show())
                .setInfo(yhje.getRealInfo())
                .setMsgOnly4Log(yhje.getRealMsgOnly4Log())
                .setMsgOnly4Show(yhje.getRealMsgOnly4Show())
                .build();
        }
        return COMMON.Result.newBuilder()
            .setSuccess(false)
            .setCode(yhje.getCode())
            .setMsg(yhje.getMessage4Log())
            .setDisplaymsg(yhje.getMessage4Show())
            .setInfo(yhje.getRealInfo())
            .setMsgOnly4Log(yhje.getRealMsgOnly4Log())
            .setMsgOnly4Show(yhje.getRealMsgOnly4Show())
            .build();
    }
```
 
#### 代码块3:添加构造函数
   
```
public YHJException(YHJExceptionCode yhjExceptionCodeAction, Integer code, String otherMsg, String message4Log, String message4Show, String msgOnly4Log) {
        super();
        this.yhjExceptionCodeAction = yhjExceptionCodeAction;
        this.otherMsg = otherMsg;
        this.realCode = code;
        this.realMessage4Log = message4Log;
        this.realMessage4Show = message4Show;
        this.msgOnly4Log = msgOnly4Log;
    }
```

#### 代码块4:设置Message4Show


```
public String getMessage4Show() {
        Object tracedId = MDC.get("X-B3-TraceId");
        StringBuilder builder = new StringBuilder();
        if (yhjExceptionCodeAction == YHJExceptionCodeEnum.THE_THIRD_PARTY_EXCEPTION) {
            if (YHJExceptionCodeEnum.SHOW_EXCEPTION_INFO_TO_USER.getCode().equals(this.theThirdCode)) {
                builder.append(this.otherMsg);
            } else {
                builder.append(tracedId + "，");
                builder.append(this.theThirdMessage4Show);
                if (this.otherMsg != null && !this.otherMsg.isEmpty()) {
                    builder.append("，详情：");
                    builder.append(this.otherMsg);
                }
            }
        } else if (yhjExceptionCodeAction == YHJExceptionCodeEnum.SHOW_EXCEPTION_INFO_TO_USER) {
            builder.append(this.otherMsg);
        } else {
            builder.append(tracedId + "，");
            builder.append(yhjExceptionCodeAction.getMessage4Show());
            if (this.otherMsg != null && !this.otherMsg.isEmpty()) {
                builder.append("，详情：");
                builder.append(this.otherMsg);
            }
        }
        return builder.toString();
    }
```

## 规范

### service层的项目：

#### 1 统一抛YHJException，示例代码如下


```
throw new YHJException(YHJExceptionCodeEnum.THIRD_SERVICE_EXCEPTION, logWhere + "api result empty");

```

#### 2 异常的Enum可以YHJExceptionCodeEnum，也可以根据自己的需要设置，但是需要实现YHJExceptionCode这个类，示例代码如下


```
public enum OwlExceptionCodeEnum implements YHJExceptionCode {

    ORDER_NOT_FOUND(20000, "order not found", "订单找不到或已被删除");

    private Integer code;
    private String message4Log;
    private String message4Show;

    OwlExceptionCodeEnum(Integer code, String message4Log, String message4Show) {
        this.code = code;
        this.message4Log = message4Log;
        this.message4Show = message4Show;
    }

    public Integer getCode() {
        return this.code;
    }

    public String getMessage4Log() {
        return this.message4Log;
    }

    public String getMessage4Show() {
        return this.message4Show;
    }
}
```

备注：code不要和其他项目中已经存在的code重复，因为不同的code代表的是不同的异常，特别是和halo中的是真的不要重复了

#### 3 设置错误的result值的时候统一用halo中baseController类中的handleException方法，示例代码如下

```
try {
        //具体的业务代码
        } catch (Exception e) {
            return handleException(a -> Common.SimpleResponse.newBuilder().setResult(a).build(), e);
        }
```

#### 4 可以预知是抛给用户显示的信息时，要抛halo中指定的异常（SHOW_EXCEPTION_INFO_TO_USER）例如，用户填写信息的时候填写不正确或没有填写时抛出的信息，示例代码如下

```
throw new YHJException(YHJExceptionCodeEnum.SHOW_EXCEPTION_INFO_TO_USER,"请填写正确的手机号码！");
```

### halo

#### 封装clientServiceWrap类中的方法时，当result中success字段的值为false时，需要抛出指定的异常，这里对抛这个异常的方法进行了封装，可以直接调用方法

  
``` 
    @Override
    public TaskEngine.TaskEngineDTO addTask(TaskEngine.TaskAddOption addOption) {

        String where = "SophonServiceWrap->addTask";

        TaskEngine.TaskEngineDTO ret;

        try {
            ret = sophonClient.addTask(addOption);
        } catch (Exception e) {
            //和原来代码一样
        }
        if (!ret.hasResult()) {
            //和原来代码一样
        }
        if (!ret.getResult().getSuccess()) {
            logger.error(LogInfoGenerator.generateErrorInfo(where, YHJExceptionCodeEnum.THE_THIRD_PARTY_EXCEPTION, "not success", "addOption", JsonFormat.printToString(addOption), "ret", JsonFormat.printToString(ret)));
            Helper.throwTheThirdPartyException(ret.getResult(), where);
        }
        return ret;
    }
```

### application层的项目

因为application层的protobuf文件一般都是直接写在其项目中，导致其result的类型和halo中的result类型不一致，所以不能直接调用halo的baseCotroller的handleException方法设置出现异常的result值，因此需要自己实现，示例代码如下



```
public class BaseController {

    final Logger logger = Logger.getLogger(getClass());

    public FollowUp.Result buildHandleResult(YHJException re){
        return  FollowUp.Result.newBuilder()
                .setCode(re.getCode())
                .setSuccess(false)
                .setMsg(re.getMessge4Log())
                .setDisplaymsg(re.getMessage4Show()).build();
    }

    public FollowUp.Result buildNotHandleResult(Exception e){
        logger.error(RedCoastExceptionCodeEnum.UNKNOWN_ERROR.getMessage4Log(),e);

        return  FollowUp.Result.newBuilder()
                .setCode(RedCoastExceptionCodeEnum.UNKNOWN_ERROR.getCode())
                .setSuccess(false)
                .setDisplaymsg(addTraceId4UnKnowErrorDisplaymsg(RedCoastExceptionCodeEnum.UNKNOWN_ERROR.getMessage4Show())).build();
    }
    
    private String addTraceId4UnKnowErrorDisplaymsg(String originMsg){
        Object traceId = MDC.get("X-B3-TraceId");
        StringBuilder builder = new StringBuilder();
        builder.append(traceId + ",");
        if (!Utils.isEmpty(originMsg)){
            builder.append(originMsg);
        }
        return builder.toString();
    }
}
```


