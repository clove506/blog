---
title: 【合肥项目】对admin相关操作API设计
date: 2017-1-13 17:00:00
categories: 合肥
tags:
- Admin
---

## 摘要

 合肥项目-admin CRUD 和adminTag CURD
 <!-- more -->
 
## WIKI维护人
李江明
# admin CRUD API详细设计i
## 新建一个admin的接口设计

POST /api/yolar/v1/admins

## 接口描述
新建一个admin的操作
## Request
``` json
{
	"name" :"youhujia",
	"phone": "13170800999",
	"system":"orderSystem",
	"avatarUrl":"aaa.jpg",
	"idCard":"01012222222222222222"
}
```
## Response
token由后台程序自动生成
```json
{
  "result": {
    	"success": true,
    	"code": 0
  },
  "admin": {
    	"adminId": 16,
    	"name": "youhujia",
    	"phone": "13170800999",
    	"status": 1,
    	"system": "orderSystem",
    	"title": 1,
    	"avatarUrl": "aaa.jpg",
		"token":"PGrSgP3KJ81GaaeiJN6BjR1PZ56QFZk4ALTtbTNhRZRqLRsLJEgcw2OVsFxRewXHJK5XRXjDNh9S7zlDpJWvidmafqkxF9C6rwWcm257Zoe5DHODyu0vpxMdLrFbn6wM",
    	"idCard": "01012222222222222222"
  }
}
```
## 实现设计
前端传入要添加的admin的信息，数据合法则保存到数据库。

## 更新admin信息接口设计
PATCH /api/yolar/v1/admins/{adminId}
## 接口描述
根据adminId,将该admin的信息更新为传入的数据
## Request
```json
{
	"adminId":19	,
	"name":"Beyond_19",
	"phone":"18370600889",
	"system":"orderSystem",
	"avatarUrl":"bbb.jpg",
	"idCard":"011666666666666666666"
}
```
## Response
```json
{
  "result": {
    	"success": true,
    	"code": 0
  }
}
```
## 实现设计
在前端传入要更新的adminId和需要更新的内容，根据adminId查询到该admin，将原始数据更改为新数据，然后保存到数据库中。

## 根据adminId查询admin信息的接口设计
GET /api/yolar/v1/admins/{adminId}
## 接口描述
传入adminId，查询出admin的详细信息
## Request
/api/admins/yolar/v1/admins/1
## Response
```json
{
  "result": {
  		"success": true,
  		"code": 0
  },
  "admin": {
  		"adminId": 1,
    	"name": "李江明",
    	"phone": "18370600881",
    	"status": 1,
    	"createdAt": 1483801922000,
    	"updatedAt": 1483801922000,
    	"system": "orderSystem",
		"token":"PGrSgP3KJ81GaaeiJN6BjR1PZ56QFZk4ALTtbTNhRZRqLRsLJEgcw2OVsFxRewXHJK5XRXjDNh9S7zlDpJWvidmafqkxF9C6rwWcm257Zoe5DHODyu0vpxMdLrFbn6wM",
		"title": 1,
		"avatarUrl": "aa.jpg",
		"idCard": "010888888888"
  }
}
```
## 实现设计
根据传入的adminId，从数据库中将对应的admin信息返回。

## 删除一个admin的接口设计
DELETE /api/yolar/v1/admins/{id}
## 接口描述
目前只提供该接口，接口在实现的时候，抛出一个异常，实际并不删除数据库中的数据。

## 根据phone查询admin的接口
GET /api/yolar/v1/admins/phone/{phone}
## 接口描述
传入手机号，根据手机号查询出对应的admin记录
## Request
/api/yoar/v1/admins/phone/18370600881
## Response
```json
{
  "result": {
    	"success": true,
    	"code": 0
  },
  "admin": {
    	"adminId": 1,
    	"name": "李江明",
    	"phone": "18370600881",
    	"status": 1,
    	"createdAt": 1483801922000,
    	"updatedAt": 1483801922000,
    	"system": "orderSystem",
		"token":"PGrSgP3KJ81GaaeiJN6BjR1PZ56QFZk4ALTtbTNhRZRqLRsLJEgcw2OVsFxRewXHJK5XRXjDNh9S7zlDpJWvidmafqkxF9C6rwWcm257Zoe5DHODyu0vpxMdLrFbn6wM",
    	"title": 1,
    	"avatarUrl": "aa.jpg",
    	"idCard": "010888888888"
  }
}
```
## 实现设计
根据传入的手机，手机号在库中是唯一确定的，所以一个手机号只能查询出一个条对应的记录。

## 更新admin token的接口设计
POST /api/yolar/v1/admins/{admins}/reset-token
## 接口描述
传入要更新token的adminId，给这个admin随机生成一个token，并保存到数据库
## Request
/api/yolar/v1/admins/1/reset-token
## Response
```json
{
	"result":{
		"success":true,
		"code":0
	}
}
```
## 实现设计
通过adminId查找出要更新token的admin,然后程序自动生成一个token，然后保存到数据库中。

## 根据tagId查询admin的接口设计
GET /api/yolar/v1/tags/{tagId}/admins
## 接口描述
根据tagId，查询出有该tag的所有admin
## Request
/api/yolar/v1/tags/1/admins/
## Response
```json
	{
		"result":{
			"success":true,
			"code":0
		}
		"admin":{
    		"adminId": 1,
    		"name": "李江明",
    		"phone": "18370600881",
    		"status": 1,
    		"createdAt": 1483801922000,
    		"updatedAt": 1483801922000,
    		"system": "orderSystem",
			"token":"PGrSgP3KJ81GaaeiJN6BjR1PZ56QFZk4ALTtbTNhRZRqLRsLJEgcw2OVsFxRewXHJK5XRXjDNh9S7zlDpJWvidmafqkxF9C6rwWcm257Zoe5DHODyu0vpxMdLrFbn6wM",
    		"title": 1,
    		"avatarUrl": "aa.jpg",
    		"idCard": "010888888888"
  		}
	}
```
## 实现设计
传入tagId,然后根据tagId从adminTag表中查询出和与之对应的adminId，然后根据adminId查询出admin信息。

## 根据adminId，查询出该admin下的所有tag的接口设计
GET /api/yolar/v1/tags/admins/{adminId}
## 接口描述
传入adminId，根据该id查询出admin下的所有tag
## Request
/api/yolar/v1/tags/admins/1
## Response
```json
{
	"result":{
		"success":true,
		"code":0
	}
	{
  "tag": [
    {
      "id": 1,
      "name": "耳朵变长了",
      "type": 1,
      "creatorId": 2,
      "organizationId": 1,
      "departmentId": 13,
      "tagCategoryId": 1,
      "tagCategoryName": "耳朵",
      "createdAt": 1477381354000,
      "updatedAt": 1477381354000
    },
    {
      "id": 16,
      "name": "爱上杜甫",
      "type": 1,
      "creatorId": 2,
      "organizationId": 1,
      "departmentId": 13,
      "tagCategoryId": 1,
      "tagCategoryName": "耳朵",
      "createdAt": 1477410542000,
      "updatedAt": 1477410542000
    }
  ],
  "result": {
    "success": true,
    "code": 0
  }
}
}
```
## 实现设计
传入adminId，根据adminId从adminTag表中与之对应的tagId，然后根据tagId查询出tag的信息。

## 为admin添加tag的接口设计
POST /api/yolar/v1/tags/admins/{admins}
## 接口描述
为admin添加tag
## Request
/api/yolar/v1/tags/admins/1
```json
{
	"tagId":1
}
```
## Response
```json
{
	"result":{
		"code":0,
		"result":true
	}
	{
		"id":1,
		"name":"耳朵变长了",
		"type":1,
		"creatorId":1,
		"organizationId":1,
		"departmentId":13,
		"tagCategoryId":1,
		"tagCategoryName":"耳朵",
		"createdAt":1483801922000,
		"updatedAt":1483801922000 
	}
}
```
## 实现设计

## 将admin下所有的tag都删除的接口设计
DELETE /api/yolar/v1/tags/admins/{adminId}
## 接口描述
根据adminId，删除该admin下的所有的tag
## Request
/api/yolar/v1/tags/admins/1
## Response
```json
	{
		"result":{
			"success":true,
			"code":0
		}
	}
```
## 实现设计
传入adminId,根据adminId找到adminTag表中的对应记录，然后将其删除。




