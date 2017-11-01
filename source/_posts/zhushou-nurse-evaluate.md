---
title: 护士评估
date: 2017-01-06 20:35:13
categories: api
tags:
- api
---

# 摘要

护士端需要支持对病人做评估

<!--more-->

# WIKI维护人

mmliu

# 概要

之前的只支持用户自测，现在需要支持护士评估。

## API （from w-breaker）

### 1. 获取评估工具

参考之前 [C端接口](https://github.com/Youhujia/docs/blob/master/backend/kfb/KFB-API-Backup.md#get-tools-toolget-toolid)

**GET /api/wbreaker/v1/nurses/{nurseId}/tools/{toolId}**

+ Response

  ```json
  {
    "result" : {"success" : true},
    "toolBasicInfo": {
      "id": 2,
      "name": "康复宝康复宝",
      "brief": ""
    },
    "question": [
      {
        "id": 4,
        "title": "感冒怎么办",
        "type": 1,
        "toolId": 2,
        "rank": 0,
        "option": [
          {
            "id": 10,
            "questionId": 4,
            "rank": 1,
            "content": "吃药喝水",
            "score": 5
          },
          {
            "id": 9,
            "questionId": 4,
            "rank": 0,
            "content": "喝水吃药",
            "score": 5
          },
          {
            "id": 11,
            "questionId": 4,
            "rank": 2,
            "content": "打针输液",
            "score": 10
          }
        ]
      },
      {
        "id": 5,
        "title": "头疼",
        "type": 2,
        "toolId": 2,
        "rank": 1,
        "option": [
          {
            "id": 13,
            "questionId": 5,
            "rank": 1,
            "content": "是病吗",
            "score": 10
          },
          {
            "id": 12,
            "questionId": 5,
            "rank": 0,
            "content": "不是病",
            "score": 5
          }
        ]
      },
      {
        "id": 6,
        "title": "脑子坏到了",
        "type": 1,
        "toolId": 2,
        "rank": 2,
        "option": [
          {
            "id": 15,
            "questionId": 6,
            "rank": 0,
            "content": "不好使",
            "score": 10
          },
          {
            "id": 16,
            "questionId": 6,
            "rank": 1,
            "content": "不中用",
            "score": 0
          }
        ]
      }
    ],
    "toolResult": [
      {
        "id": 2,
        "toolId": 2,
        "scoreFrom": 1,
        "scoreTo": 1000,
        "title": "",
        "resultExplain": "<i>药</i>不能<strong style=\"color:blue\">停不能停</strong>"
      },
      {
        "id": 3,
        "toolId": 2,
        "scoreFrom": 11,
        "scoreTo": 1000,
        "title": "",
        "resultExplain": "有基本的<strong style=\"color:blue\">css医疗常识</strong>"
      }
    ]
  }
  ```

### 2. 提交评估，获取结果

参考之前 [C 端接口](https://github.com/Youhujia/docs/blob/master/backend/kfb/KFB-API-Backup.md#获取答案-toolsubmit_options)

其中，添加了 evaluateType， 表示当前的评估是为什么而做的，当前仅有 ServiceOrderEvaluate，targetId 随 evaluateType 不同而意义变化，evaluateType 为 ServiceOrderEvaluate 时， targetId 即为 serviceOrderId。

**POST /api/wbreaker/v1/nurses/{nurseId}/tools/{toolId}/answer**

+ Request

  ```json
  {
      "evaluateType" : 1,
      "extraInfo" : "{\"actionId\": 1, \"orderId\": 3}",
      "userId": 1,
      "toolId": 15,
      "options": [
          {
              "questionId": 14,
              "optionId": 2
          },
          {
              "questionId": 14,
              "optionId": 2
          },
          {
              "questionId": 14,
              "optionId": 2
          },
          {
              "questionId": 14,
              "optionId": 2
          }
      ]
  }
  ```


+ Response

  ```json
  {
    "result": {
      "success": true
    },
    "userId": 1,
    "toolId": 15,
    "score": "8.0",
    "title": "",
    "msg": "重度功能障碍!!!重度功能障碍，患者大部分日常生活不能完成或需他人服侍，!!!多数日常生活活动不能完成，依赖明显或完全依赖，禁止患者自己活动或自己完全不能活动，基本生活行动完全需要帮助。!!!需要给予整理床单位、面部清洁、梳头、刷牙、全身温水擦浴、翻身、床上，使用大小便器并进行擦拭，协助进食等。"
  }
  ```

  ​