---
title: 泰乐城六月项目 产品断点修复技术文档
---

# 背景

关于影子公众号，见文档：https://wayknew.com/articles/222

之前已经实现了影子公众号的部分逻辑，主要是可以获取用户在影子公众号下的 openId，但是未实现后续通过该影子公众号给用户下发微信模板消息。
现在需要完善该逻辑。

prd 见：[「泰乐城六月项目」产品断点修复PRD](https://wayknew.com/articles/264)

需要更新的逻辑：微信扫码和模板消息相关，主要涉及三个项目：

- Era
- Difoil
- Singer

# Era

主要涉及影子公众号功能的恢复。


之前影子公众号的逻辑放在 Era 中，现在 Era 项目已经废弃，需要迁移相关代码到 Yolar。
影子公众号设计文档：https://wayknew.com/articles/222

# Difoil

主要涉及微信扫码后的 callback 处理。



对启用影子公众号的科室，二维码需要配置特殊参数，以方便后台区别对待:

- 现有普通科室科室的二维码参数形如：`departmentId_<211>`，后缀为科室 id。
- 对于启用影子公众号的科室，需使用如下参数：`shadow_<311>`， 后缀为影子公众号id。

对于微信扫码的 callback，检查到此类参数后，返回的欢迎语中，携带链接为影子公众号专用链接。

点击之后，走之前影子公众号的流程（https://wayknew.com/articles/222），以获取该用户在影子公众号的 openId。



配合 C 端逻辑，需要在该流程中增加两个操作：

- 给用户关联上科室
- 给用户关联上相应的疾病

以保证用户进入 C 端后，已经被关联上了相关科室。

# Singer

涉及微信模板消息的下发。



现有的微信模板消息，都是通过优护家公众号下发的，现在则优先通过影子公众号下发模板消息，需要 Singer 提供新接口。

涉及的修改 ：

- 增加影子公众号和科室的关联
- 统一微信模板的 id
- Singer 添加新的模板消息发送接口
- 调用方使用新的接口发送模板消息

## 增加影子公众号和科室的关联

现在影子公众号（shadow_wx_account）没有关联科室信息，科室产生消息后，无法确认对应的公众号是哪一个，该对应信息需要加上。

## 模板 id 统一管理

之前发送模板消息时，需要业务方指明 templateID，现在对应不同的微信账号，templateId 各不相同，交给业务方显得太过繁琐，所以在 singer 中统一模板消息，业务方只需指定模板的 enum 即可。

**模板消息 Enum在 Halo 中定义**：

- FollowUpNotify
- NewIMMsg
- NewOrderInfo



**数据库添加模板 id 信息**：

各账号下模板消息配置信息统一在数据库中管理，给 `shadow_wx_account` 表添加字段：`wx_template_info`。

示例：

```json
{
  "FollowUpNotify" : "UFHEoI6BVlNizJ2bvNA49YRHtLs0GG4dM1ROVg6DFkA",
  "NewIMMsg" : "foo",
  "NewOrderInfo" : "bar"
}
```

## Singer 添加新的模板消息发送接口

```java
@ReqeustMapping("/wechat-template-msg/shadow-account-first")
public @ResponseBody SimpleResponse sendWechatTmplMsgShodowAccountFirst(@RequestBody WechatTmplMsgOpt msgOpt){}
```

```protobuf
message WechatTmplMsgOpt{
  optional int templateEnumId = 1;
  
  optional int userId = 2;
  optional int dptId = 3;
  
  optional string payload = 4;
}
```

发送模板消息的逻辑如下：

[LINK](https://www.processon.com/view/link/59425f9fe4b04d4c799d1c7c)

![](https://ws3.sinaimg.cn/large/006tNc79gy1fgniblha12j30fx0mi3zm.jpg)

## 调用方使用新的接口发送模板消息

已知的调用方：

- difoil
- dimension

## 具体排期

| 内容   | 耗时/人日   | 开始日期   | 实现者|
| ---- | ---- | ---- | ---- |
| C端优护家公众号授权页面和后端逻辑开发、自测   | 2 | 0618 |  擎祖&CC    |
| di-foil扫码逻辑开发、自测	   | 0.5 | 0620 |  卢江    |
| yolar影子公众号和科室管理底层逻辑开发、自测   | 0.5 | 0620 |  卢江    |
| singer模板信息推送开发、自测   | 1 | 0621 |  卢江    |
| C端随访、新消息Push接口改造、自测   | 1 | 0622 |  卢江    |
| C端订单Push接口改造、自测   | 1 | 0623 |  卢江    |
| staging环境测试   | 1 | 0624 |  旭红&奥伟    |
| 上线   | 1 | 0626 |  赵蔺Or明敏    |


## 进度日志

### 6月20日

- kick off
- yolar底层逻辑开发（泰乐城公众号和科室进行关联）
- 泰乐城公众号授权页面和后端逻辑开发

### 6月21日

- 影子公众号和科室关联
- 通过科室Id查找影子公众号接口
- 用户和影子公众号下科室关联并为用户添加关注疾病
- Singer统一微信模板消息接口

### 6月22日

- 生成影子公众号下科室二维码接口
- 改造di-foil扫码接口，加入影子公众号扫码逻辑
- 测试影子公众号科室扫码逻辑及正确跳转C端科室首页

### 6月23日

- Singer统一微信模板消息接口测试（Push Push Push~）
- 修改di-foil和dimension微信模板消息逻辑，调动Singer新增统一微信模板消息接口及测试

### 6月24日
- staging环境验收（由于网络、bug等各方面原因，预计延期一天，今日上dev）

