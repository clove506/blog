---
title: 【上门护理二期】处理抛出异常信息显示不合理
date: 2017-2-20 12:10:00
categories: 上门护理二期
tags:
- Exception
---

## 摘要

处理异常抛出显示不合理
<!--more-->

## WIKI维护人

黄  英

## 涉及项目
halo、sophon、yolar、owl、midas、difoil、dagon、cms

## 描述

现在的情况是，如果前端发出请求在第一层就出现异常，显示的异常信息是没有问题的，但是请求继续往下层走，这时候就会通过halo进行请求，这个时候如果第二层或者更下层出现异常时，将异常抛出到达halo时，halo会重新抛出一个异常，于是之前的异常信息就会被覆盖，如果直接加上下层的错误信息就会出现一大堆信息，让人抓不住重点，所以需要对这个过程进行修改。

## 实现方案

1. 添加字段。现在的封装错误信息的result，其中的的字段都是进行过封装的，如果我们需要拿到原始信息就需要对result添加字段，添加的字段为：msgOnly4Log、msgOnly4Show、info
2. 重新封装result。在封装底层的result时，将其原始信息添加到result中。
3. 在halo中抛出指定的第三方异常（THE_THIRD_PARTY_EXCEPTION）。如果下层返回的result不为空并且success字段值为false时，会重新抛出异常，这时候抛出的异常我们指定抛出第三方异常。
4. 为第三方异常创建一个新的YHJException构造方法。因为在抛第三方异常的时候需要将下层的信息重新抛出，所以需要重新添加一个构造函数将下层错误信息抛出。   
5. 在检测异常为第三方异常的时候，需要新添加一个新的result值的封装方法。因为第三方抛出的异常信息和其他异常信息封装的不同，所以需要重新添加一个方法。

## 实现核心代码：
 
### 添加字段

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

### 封装result
        
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
 
### 添加构造函数
   
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

