---
title: 【合肥项目】支付系统API设计
date: 2016-12-11 00:00:00
categories: 合肥
tags:
- 支付系统
---

# Midas API (Payment Service API)说明

## 发起支付
POST `api/midas/v1/order/{orderId}/charge`  

* **Request**

```json
{
    "subject": "service item",
    "description": "item description",
    "channel": "wx_pub",
    "amount": 100,
    "extra": {
        "open_id": "wx123123dfef"
    }
}
```  

* orderId: 订单id
* subject: 订单标题，建议限制 32 unicode 字符（超出部分会在发到pingpp前截断）
* description: 订单描述，建议限制 128 unicode 字符（超出部分会在发到pingpp前截断）
* channel: 目前只需要 微信内嵌浏览器的微信公众号WAP支付
* amount: 人命币单位分，即此处100为1元
* extra: 不同支付渠道，可能需要的附加参数，目前wx_pub需要传open_id
* 参考：https://www.pingxx.com/api?language=cURL#支付渠道属性值
* 参考：https://www.pingxx.com/api?language=cURL#支付渠道-extra-参数说明

* **Response**  

```json
{
    "result": {
        "success" : true
    },
    "data": {
      "id": "ch_Hm5uTSifDOuTy9iLeLPSurrD",
      "object": "charge",
      "created": 1410778843,
      "livemode": true,
      "paid": false,
      "refunded": false,
      "app": "app_1Gqj58ynP0mHeX1q",
      "channel": "upacp",
      "order_no": "123456789",
      "client_ip": "127.0.0.1",
      "amount": 100,
      "amount_settle": 100,
      "currency": "cny",
      "subject": "Your Subject",
      "body": "Your Body",
      "extra":{},
      "time_paid": null,
      "time_expire": 1410782443,
      "time_settle": null,
      "transaction_no": null,
      "refunds": {
        "object": "list",
        "url": "/v1/charges/ch_Hm5uTSifDOuTy9iLeLPSurrD/refunds",
        "has_more": false,
        "data": []
      },
      "amount_refunded": 0,
      "failure_code": null,
      "failure_msg": null,
      "credential": {
        "object": "credential",
        "upacp": {
          "tn": "201409151900430000000",
          "mode": "01"
        }
      },
      "description": null        
    }
}
```
* result: 操作结果
* data: pingpp charge 对象，client端需要用pingpp sdk加载该对象发起支付
* 参考: https://www.pingxx.com/api?language=cURL#charges-支付
* 参考: https://github.com/PingPlusPlus/pingpp-html5/blob/master/example-wap/views/wap.html

## 发起退款
POST `api/midas/v1/order/{orderId}/refund`

* **Request**
```json
{
    "description": "refund on something",
    "amount": 100,
}
```
* description: 退款描述
* amount: 退款金额，人民币单位分

* **Response**
```json
{
    "result": {
        "success": true
    }
}
```
* result: 操作结果


## Ping++ Webhook
>仅提供给 ping++ event callback 使用

POST `api/midas/v1/webhook`
* Request (JSON)

>ping++ charge.succeeded

```json
{
    "id": "evt_ugB6x3K43D16wXCcqbplWAJo",
    "created": 1427555101,
    "livemode": true,
    "type": "charge.succeeded",
    "data": {
        "object": {
            "id": "ch_Xsr7u35O3m1Gw4ed2ODmi4Lw",
            "object": "charge",
            "created": 1427555076,
            "livemode": true,
            "paid": true,
            "refunded": false,
            "app": "app_1Gqj58ynP0mHeX1q",
            "channel": "upacp",
            "order_no": "123456789",
            "client_ip": "127.0.0.1",
            "amount": 100,
            "amount_settle": 100,
            "currency": "cny",
            "subject": "Your Subject",
            "body": "Your Body",
            "extra": {},
            "time_paid": 1427555101,
            "time_expire": 1427641476,
            "time_settle": null,
            "transaction_no": "1224524301201505066067849274",
            "refunds": {
                "object": "list",
                "url": "/v1/charges/ch_L8qn10mLmr1GS8e5OODmHaL4/refunds",
                "has_more": false,
                "data": []
            },
            "amount_refunded": 0,
            "failure_code": null,
            "failure_msg": null,
            "metadata": {},
            "credential": {},
            "description": null
        }
    },
    "object": "event",
    "pending_webhooks": 0,
    "request": "iar_qH4y1KbTy5eLGm1uHSTS00s"
}
```

>ping++ refund.succeeded

```json
{
    "id": "evt_gJKelawq06CiPojS5gt3noQA",
    "created": 1427555348,
    "livemode": true,
    "type": "refund.succeeded",
    "data": {
        "object": {
            "id": "re_SG0mnjTD3jAHimbvDKjnXLC9",
            "object": "refund",
            "order_no": "SG0mnjTD3jAHimbvDKjnXLC9",
            "amount": 100,
            "created": 1427555346,
            "succeed": true,
            "status": "succeeded",
            "time_succeed": 1427555348,
            "description": "Refund Description",
            "failure_code": null,
            "failure_msg": null,
            "metadata": {},
            "charge": "ch_Xsr7u35O3m1Gw4ed2ODmi4Lw"
        }
    },
    "object": "event",
    "pending_webhooks": 0,
    "request": "iar_Ca1Oe10OqTSOPOmzX9Hi1a5"
}
```
>更多event类型见ping++: https://www.pingxx.com/api?language=cURL#event-事件类型

* Response
>成功，返回 HTTP 2xx  
>失败，返回 Non-HTTP2xx

***

## 请求Midas尝试拉取付款／退款状态
>应仅对内部可见  

GET `<internal_address>/{orderId}/charge`  
GET `<internal_address>/{orderId}/refund`

* **Response**
```json
{
    "result": {
         "success": true
    }
}
```
* result: 操作结果

***
## Health check接口
>用作服务器基本状态监控，比如SLB Alive鉴定，具体待定（各个服务都应提供类似接口）
