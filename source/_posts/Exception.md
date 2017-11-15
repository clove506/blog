---
title: 异常处理
date: 2017-11-15 13:20:30
categories: 开发总结
---

一般异常底层框架包括3部分，异常码，异常日志信息，用户提示信息。这些部分是由 Enum 实现的。如下：

```java
public enum ExceptionCodeEnum {

    AUTHENTICATE_FAIL(401, "authenticate fail invalid token", "登录异常"),
    SHOW_EXCEPTION_INFO_TO_USER(11009, "Display exception messages to the user", "可以预知展示给用户的指定异常");
   

    private Integer code;
    private String message4Log;
    private String message4Show;
    
    YHJExceptionCodeEnum(Integer code, String message4Log, String message4Show) {
        this.code = code;
        this.message4Log = message4Log;
        this.message4Show = message4Show;
    }
}
```

但这仅仅实现了异常信息的记录和组织形式，并未提供异常信息的处理方式，哪些信息是应该记录日志，哪些信息应该提示给用户，如此一来，需要提供操作方法。

在 java 面向对象编程中，我们往往在接口中定义行为，行为意味着公共方法。由此，我们定义了一套操作日志的行为：

```java

public interface ExceptionCode {

    // 获取异常code
    Integer getCode();
    // 获取异常日志信息（开发人员）
    String getMessage4Log();
    // 获取异常提示信息（用户）
    String getMessage4Show();
}

```

通过上文提到的 enum 实现该接口，我们就可以在 enum 中定义、操作日志信息。

到这，我们定义好了底层异常框架，相当于我们现在已经有了轮子，那怎么拼装成车的一部分呢？

我们真正使用的并不是 enum ，而是显示定义的 exception，以下是他的面纱：

```java

public class YHJException extends RuntimeException {

    private YHJExceptionCode yhjExceptionCodeAction;
    private String otherMsg;
    private String msgOnly4Log;

    private Integer theThirdCode;
    private String theThirdMessage4Log;
    private String theThirdMessage4Show;
    private String where;
    private String msg;
    
    // constructor...
}

```


































