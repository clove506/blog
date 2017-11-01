---
title: V1.1优护助手 BUG LIST
date: 2016-11-23 15:44:13
categories: 项目管理
tags:
- 测试
- 优护助手1.1
---

## 摘要
1.1 的BUG LIST

ALL Fixed。
<!--more-->

## 详情
1. 【FIXED】新用户登录服务器错误（13117606956 ）。
   代码中对登录用户的状态表示错误。 

2. 【FIXED】登录的时候提示“服务器扔过来一个错误”（18611209794）。

3. 【FIXED】admin.zhushou.youhujia.com/authentication-list 管理后台认证通过报错，Method Not Found
    日常服务地址配置错误，已修复。
   错误信息：

   ```json
   2016-11-21 21:50:26.390  INFO 8 --- [nio-8081-exec-6] c.youhujia.gateway.filter.GateWayFilter  : {"data":{"authenticateResult":{"message4Show":"","pass":true},"context":{"method":"POST","uRI":"/api/nurses/msg/im/callback"}},"where":"GateWayFilter->doGateWayFilter"}
   2016-11-21 21:50:26.391 ERROR 8 --- [nio-8081-exec-6] c.youhujia.gateway.filter.GateWayFilter  : {"data":{"request":"/api/nurses/msg/im/callback","queryParam":{"CallbackCommand":["C2C.CallbackAfterSendMsg"],"SdkAppid":["123"]}},"errorCode":500,"errorExtraInfo":"","errorInfo":"unknown error","where":"GateWayFilter->handleException"}

   java.lang.NullPointerException: null
     at com.youhujia.gateway.domain.authorize.invoker.AuthorizeInvoker.isFilterMatch(AuthorizeInvoker.java:50) ~[gateway-0.0.1.jar!/:na]
     at com.youhujia.gateway.domain.authorize.invoker.AuthorizeInvoker.isAuthorized(AuthorizeInvoker.java:66) ~[gateway-0.0.1.jar!/:na]
     at com.youhujia.gateway.domain.authorize.AuthorizeBO.isAuthorized(AuthorizeBO.java:18) ~[gateway-0.0.1.jar!/:na]
     at com.youhujia.gateway.filter.GateWayFilter.doGateWayFilter(GateWayFilter.java:101) ~[gateway-0.0.1.jar!/:na]
     at com.youhujia.gateway.filter.GateWayFilter.run(GateWayFilter.java:63) ~[gateway-0.0.1.jar!/:na]
     at com.netflix.zuul.ZuulFilter.runFilter(ZuulFilter.java:112) [zuul-core-1.1.0.jar!/:1.1.0]
     at com.netflix.zuul.FilterProcessor.processZuulFilter(FilterProcessor.java:197) [zuul-core-1.1.0.jar!/:1.1.0]
     at com.netflix.zuul.FilterProcessor.runFilters(FilterProcessor.java:161) [zuul-core-1.1.0.jar!/:1.1.0]
     at com.netflix.zuul.FilterProcessor.preRoute(FilterProcessor.java:136) [zuul-core-1.1.0.jar!/:1.1.0]
     at com.netflix.zuul.ZuulRunner.preRoute(ZuulRunner.java:105) [zuul-core-1.1.0.jar!/:1.1.0]
     at com.netflix.zuul.http.ZuulServlet.preRoute(ZuulServlet.java:125) [zuul-core-1.1.0.jar!/:1.1.0]
     at com.netflix.zuul.http.ZuulServlet.service(ZuulServlet.java:74) [zuul-core-1.1.0.jar!/:1.1.0]
   ```


4. 【FIXED】无患者时界面显示有问题
   代码合并冲突。

5. 【FIXED】认证通过之后没有提示“token”失效 
   情况1：认证之后，你必须点下别的接口，而且cache没有生效，有API请求才会提示重新登录。

   情况2：18611209794 明明的账号在认证通过的时候我的页面已经显示了认证通过，并没有重新登录。
   setToken()有个隐含的bug，修改之后又改回去了。现在已经修复。

6. 【FIXED】患者列表没有关注的人显示了关注（关注页面提示）
   前端逻辑取错，已修复

7. 【FIXED】患者通讯录接口，患者没有被关注，且显示了关注信息。

``` json
curl 'http://api.zhushou.test.youhujia.com/api/nurses/users/2153/info' -H 'Authorization: MLyOdZWJrxyf1hoC9MzUfalaW4jlF715bnUITUrmPcebimghlOcmoiA5wRNp0O7dTMh8k5PTxPOckoisBmED62uisid7S6YnJtbSdIsqCMe7McMmeQOxmnqDLYLQcxmb' -H 'Origin: http://localhost:63342' -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: zh-CN,zh;q=0.8,en;q=0.6' -H 'User-Agent: Mozilla/5.0 (iPhone; CPU iPhone OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13B143 Safari/601.1' -H 'Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS' -H 'Access-Control-Allow-Origin: *' -H 'Accept: application/json' -H 'Referer: http://localhost:63342/YHZS-V1.2/src/index.html?818' -H 'Connection: keep-alive' -H 'Access-Control-Allow-Headers: X-Requested-With' --compressed
```

``` json
{"user": [{"title": "关注","member": [{"userId": 2153,"name": "欢","status": 1,"statusName": "已入院","avatarUrl": "img/title.png","patientRecord": {"admissionAt": "TODO","dischargeAt": "TODO","room": "TODO","bed": "TODO"},"tag": [{"tagId": 232,"tagType": 2,"tagName": "1","tagCategoryId": 0,"tagCategoryName": ""}]},{"userId": 2141,"name": "匿名","status": 1,"statusName": "已入院","avatarUrl": "http://yhjstatic.oss-cn-shanghai.aliyuncs.com/avatar/634638d5-5c20-6554-f297-a759f5da15af.jpg","patientRecord": {"admissionAt": "TODO","dischargeAt": "TODO","room": "TODO","bed": "TODO"},"tag": [{"tagId": 42,"tagType": 1,"tagName": "123","tagCategoryId": 0,"tagCategoryName": ""},{"tagId": 43,"tagType": 1,"tagName": "38","tagCategoryId": 0,"tagCategoryName": ""},{"tagId": 49,"tagType": 1,"tagName": "zhe ","tagCategoryId": 0,"tagCategoryName": ""},{"tagId": 52,"tagType": 1,"tagName": "bug","tagCategoryId": 0,"tagCategoryName": ""},{"tagId": 234,"tagType": 2,"tagName": "4","tagCategoryId": 0,"tagCategoryName": ""}]}]},{"title": "H","member": [{"userId": 2153,"name": "欢","status": 1,"statusName": "已入院","avatarUrl": "img/title.png","patientRecord": {"admissionAt": "TODO","dischargeAt": "TODO","room": "TODO","bed": "TODO"},"tag": [{"tagId": 232,"tagType": 2,"tagName": "1","tagCategoryId": 0,"tagCategoryName": ""}]}]},{"title": "J","member": [{"userId": 2149,"name": "佳佳鸿","status": 1,"statusName": "已入院","avatarUrl": "http://wx.qlogo.cn/mmopen/Q3auHgzwzM4pYCnafgVyzhTFQ1qdK0J0PegEYFYicN5X39dRq05KvJeTiad9dwTD1eY4EOYPsyaicbUcDBWoyhIKQ3b9H4j9jgib8Qa6C9gpibxY/0","patientRecord": {"admissionAt": "TODO","dischargeAt": "TODO","room": "TODO","bed": "TODO"},"tag": [{"tagId": 48,"tagType": 1,"tagName": "wo","tagCategoryId": 0,"tagCategoryName": ""},{"tagId": 51,"tagType": 1,"tagName": "bushi 48","tagCategoryId": 0,"tagCategoryName": ""}]}]},{"title": "L","member": [{"userId": 2138,"name": "liumingmin","status": 1,"statusName": "已入院","avatarUrl": "http://wx.qlogo.cn/mmopen/ZkIKhtgbfkCXGMhiapU8rfogiaLuZQjAWjhjCMnb1sQl2dQoRMQMJXia09FsMjqj94jjo9SyLHExh7H5XCBCsibabETiaO3tfdmeb/0","patientRecord": {"admissionAt": "TODO","dischargeAt": "TODO","room": "TODO","bed": "TODO"},"tag": [{"tagId": 43,"tagType": 1,"tagName": "38","tagCategoryId": 0,"tagCategoryName": ""},{"tagId": 49,"tagType": 1,"tagName": "zhe ","tagCategoryId": 0,"tagCategoryName": ""}]}]},{"title": "N","member": [{"userId": 2141,"name": "匿名","status": 1,"statusName": "已入院","avatarUrl": "http://yhjstatic.oss-cn-shanghai.aliyuncs.com/avatar/634638d5-5c20-6554-f297-a759f5da15af.jpg","patientRecord": {"admissionAt": "TODO","dischargeAt": "TODO","room": "TODO","bed": "TODO"},"tag": [{"tagId": 42,"tagType": 1,"tagName": "123","tagCategoryId": 0,"tagCategoryName": ""},{"tagId": 43,"tagType": 1,"tagName": "38","tagCategoryId": 0,"tagCategoryName": ""},{"tagId": 49,"tagType": 1,"tagName": "zhe ","tagCategoryId": 0,"tagCategoryName": ""},{"tagId": 52,"tagType": 1,"tagName": "bug","tagCategoryId": 0,"tagCategoryName": ""},{"tagId": 234,"tagType": 2,"tagName": "4","tagCategoryId": 0,"tagCategoryName": ""}]}]}],"result": {"success": true}}

```

``` json
globalNurseId:"5"
```


8.【FIXED】没有患者显示如下：![interview_exa](/media/interview_exam.png)

9. 【FIXED】登录的时候科室和医院的可以为空。


10. 【FEATURE】访客模式不能看到标签。
    下一个需求
11. 【FIXED】加入黑名单需要取消关注。
12. 【FIXED】gateway提示科秘随访相关接口没有权限
     相关权限未开通，开通后修复。
13. 【FIXED】随访前端表单全部完整，前端提示信息不完整。
14. 【FIXED】排班置顶信息编辑后消失。
15. 【FIXED】排班日期切换后置顶的月份没有发生变化。
16. 【FEATURE】标签的重复问题
17. 【FIXED】邀请失败。代码版本问题，合并后修复。
18. 【BAD DESIGN FIXED】黑名单管理里面的编辑，全选后对应的是操作动作是确认。
19. 【Fixed】护士管理员删除用户标签返回成功，实际未删除

