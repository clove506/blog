---
title: 【优护助手-合肥】合肥项目-Gateway 修改
date: 2016-12-28 17:26:13
categories: 合肥
---

## 摘要
Gateway 修改

<!--more-->

# Gateway 修改

之前只有针对护士端的处理，现在患者端也集成到了Gateway中，需要做相应的修改.

现在的想法是给每个不同的用户类型（现在是护士和患者，之后会有我们的运营，第三方服务提供商）添加对应的Filter，这个可以通过 将不同的URL Pattern配置给不同的Filter来实现。

1. 一个请求最多只会走 1 个 ZuulFilter

## 添加 ZuulFilter For User

### shouldFilter

在配置文件中配置好UserZuulFilter需要处理的URLs

### wechat login

和 Nurse Login 类似，登陆的校验放在 Era 中，前端 Post 从微信获取的Code到 Era 的登陆接口，如果Code valid， 返回 AuthToken， 否则返回错误。

之后的请求里，前端都需要带上该 AuthToken

Gateway中将只检查HttpHeader： Authorization，正确则放行，错误则返回401，并且在返回的Resp中，带上Callback URL（www.youhujia.com/ns/wx-login，这个其实是指向NodeJS Server的地址）

## 和之前代码的整合（Gateway For Nurse）

配置好使用NurseZuulFilter的URL列表，即可

## 应对将来系统的变化

todo

# API

## 登陆(Era)

**POST  /api/users/signup/{code}**

+ Response

  ```json
  {
     "result" : {"success" : true},
     "token" : "fake-token-for-user"
  }
  ```

## Request Fail Auth or No Token is taked

redirect url将会指向一个Angular的地址，在用户同意登陆，并被Wx Redirect后，wx会在这个callback url上加上code参数，然后redirect到该地址

+ Response

  ```json
  {
    "result" : {"success" : false},
    "redirect" : "https://open.weixin.qq.com/connect/oauth2/authorize?appid=wx66a47b413c596031&redirect_uri=http%3A%2F%2Fstaging.youhujia.com%2Fyh-api%2Fns%2Fplan%2Fdetails%3FdptNum%3D309jizhu%26planGroupId%3D11%26planId%3D24&response_type=code&scope=snsapi_userinfo&state=NO_STATE_YET#wechat_redirect"
  }
  ```

  ​