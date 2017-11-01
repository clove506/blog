---
title: 【上门护理二期】C端地址子模块详细设计
date: 2017-2-24 14:16:13
categories: 上门护理二期
tags:
- 优护助手
---
	
## 摘要
C端地址子模块详细设计

<!--more-->


## 详细设计

### 需求：一个用户（user）可以有多个地址(userAddress)

### 表结构：

表名：user_address

字段名  | 类型  | 字段详解  |  是否允许为空
----|----|-------|--------
id  |  int    |  userAddress的Id | 主键，不可为空，自增项
name| string  |  姓名  |  不可以为空
gender| int   |  性别（0代表女，1代表男） |  不允许为空 
birthday | bigint  |  出生年月日，数据库存的是时间戳  |   不允许为空 
relation | int    |  关系（对应Enum对象）  |  不可以为空 
address | string   |  地址，会在上层将json格式转化为string格式存在数据库中  |  不允许为空
phone | string   |   用户的电话  |  不允许为空
user_id | int  |  userId  |  不允许为空，根据此项判断user是否存在
created_at | timestamp    |  记录创建时间，只在数据库中显示  | 不可允许为空
updated_at | timestamp    |  记录每一次修改的时间，只在数据库中显示  | 不允许为空
is_deleted | Boolean   |  代表数据是否删除（0-false,1-true）  | 允许为空
id_card | string    |  身份证号（注：这期不需要）  |  这期允许为空，以后不确定
is_default | Boolean   |  设置默认值，每次排序将它放在第一个(0-false,1-true)  | 允许为空

### api设计

#### 类图
![](/media/C_Two_under_detailed_design.png)

#### 增加userAddress
POST /api/yolar/v1/user-addresses   返回值：Yolar.UserAddressDTO

#### 根据userAddressId获得详细信息
 GET /api/yolar/v1/user-addresses/{userAddressId}  
 参数：userAddressId
 返回值：Yolar.UserAddressDTO
 
#### 根据userAddressId修改信息
PATCH /api/yolar/v1/user-addresses/{userAddressId}
参数：userAddressId
返回值：Yolar.UserAddressResultDTO

#### 根据userAddress删除某条信息
DELETE /api/yolar/v1/user-addresses/{userAddressId} 
参数：userAddressId
返回值：COMMON.SimpleResponse

#### 根据userAddressId修改is_default字段
PATCH /api/yolar/v1/user-addresses/{userAddressId}/set-default
参数：userAddressId 
返回值：COMMON.SimpleResponse

#### 根据userId获得userAddressList
GET /api/yolar/v1/users/{userId}/user-addresses
参数：userId
返回值：Yolar.UserAddressListDTO

### 具体设计

#### 1.UserAddressController

封装UserAddressBO  userAddressBO;

	1.增加
	@RequestMapping(value = "/api/yolar/v1/user-addresses",method=RequestMethod.POST)
	createUserAddress(@RequestBody Yolar.UserAddressCreateOption userAddressCreateOption)
	2.查找某条信息
	@RequestMapping(value="/api/yolar/v1/user-addresses/{userAddressId}",method = RequestMethod.GET)
	getUserAddress(@PathVariable("userAddressId") Long userAddressId)
	3.更改某条信息
	@RequestMapping(value = "/api/yolar/v1/user-addresses/{userAddressId}",method = RequestMethod.PATCH)
	updateUserAddress(@PathVariable("userAddressId") Long userAddressId,@RequestBody Yolar.UserAddressUpdateOption userAddressUpdateOption)
	4.删除某条信息
	@RequestMapping(value="/api/yolar/v1/user-addresses/{userAddressId}",method = RequestMethod.DELETE)
	deleteUserAddress(@PathVariable("userAddressId") Long userAddressId) 
	5.根据userAddress修改is_default字段
	@RequestMapping(value="/api/yolar/v1/user-addresses/{userAddressId}/set-default",method = RequestMethod.PATCH)
	setUserAddressDefault(@PathVariable("userAddressId") Long userAddressId,@RequestBody Yolar.UserAddressUpdateOption userAddressUpdateOption
	)

#### UserAddressBO UserAddressBO（与之平行的有UserAddress、UserAddressDAO）
  
* AddUserAddressBO addUserAddressBO;
* DeleteUserAddressBO deleteUserAddressBO;
* UpdateUserAddressBO updateUserAddressBO;
* QueryUserAddressBO queryUserAddressBO;
* SetBO setBO;

1. createUserAddress(Yolar.UserAddressCreateOption userAddressCreateOption)
   return addUserAddressBO.createUserAddress(userAddressCreateOption);
   
2. getByUserAddressId(Long userAddressId)
   return queryUserAddressBO.getByUserAddressId(userAddressId);
   
3. updateByUserAddressId(Long userAddressId, Yolar.UserAddressUpdateOption userAddressUpdateOption) 
	return updateUserAddressBO.updateByUserAddressId(userAddressId, userAddressUpdateOption);
	
4. deleteByUserAddressId(Long userAddressId, Long userId)
	return deleteUserAddressBO.deleteByUserAddressId(userAddressId,userId);
	
5. setUserAddressDefault(Long userAddressId)
	return setBO.setByUserAddressId(userAddressId);
	
####  add AddUserAddressBO

AddUserAddressFactory addUserAddressFactory;

UserAddressDAO userAddressDAO
    
    createUserAddress(Yolar.UserAddressCreateOption userAddressCreateOption) {
    1.将前端传过来的数据到addUserAddressFactory里面做校验
    2.创建链接数据库的实体类对象，将数据存在数据库中，
    3.在AddUserAddressDTOFactory中将数据传回
    }
#### AddUserAddressFactory
    computeAddContext(Yolar.UserAddressCreateOption userAddressCreateOption) {
    1.将前端传过来的数据存在addContext中
    2.校验数据是否为空，参数是否合法
    3.将结果返回
    }
    
#### query QueryUserAddressBO

QueryUserAddressFactory queryUserAddressFactory;

UserAddressDAO userAddressDAO

		getByUserAddressId(Long userAddressId) {
			1.到QueryUserAddressFactory中做参数校验
			2.根据Id到数据库中查询，放入context中
        3.到QueryUserAddressDTOFactory中将数据返回给前端。
		}
		
		getUserAddressListByUserId(Long userId){
		   1.到QueryUserAddressFactory中做参数校验
			2.根据userId到数据库中查询，放入context中
        3.到QueryUserAddressDTOFactory中将数据返回给前端。
		}    
   #### QueryUserAddressFactory
    computeQueryContext(Long userAddressId) {
    1.检查userAddressId是否合法,
    2.对权限做校验
    }
    
    QueryContext(Long userId){
      1.对userId做合法性校验
      2.对权限做校验
    }

#### delete DeleteUserAddressBO

DeleteAddressFactory deleteAddressFactory;
  
    deleteByUserAddressId(Long userAddressId, Long userId) {
    1.到DeleteAddressFactory中检验参数的合法行，以及权限校验
    2.将数据库中的is_deleted字段置为true
    3.将结果返回
    }
#### DeleteAddressFactory

    UserAddressDAO userAddressDAO;
    computeDeleteContext(Long userAddressId, Long userId) {
    1.检验参数的合法性以及权限校验
    }
    
#### update UpdateUserAddressBO

UpdateUserAddressFactory updateUserAddressFactory;
UserAddressDAO userAddressDAO;

	updateByUserAddressId(Long userAddressId,Yolar.UserAddressUpdateOption userAddressUpdateOption) {
		1.到UpdateUserAddressFactory中做参数的校验和权限的检查
		2.在UpdateUserAddressDTOFactory中将参数返回
	}

#### UpdateUserAddressFactory

computeUpdateContext(Long userAddressId, Yolar.UserAddressUpdateOption userAddressUpdateOption) {
    //对参数做校验，校验权限
    }
    
#### set SetBO

	SetUserAddressFactory setUserAddressFactory;
	UserAddressDAO userAddressDAO;
	setByUserAddress(Long userAddressId) {
		1.检查参数的合法性
		2.修稿default字段
		3.将结果返回
	}
#### SetUserAddressFactory
    computeSetContext(Long userAddressId) {
		1.检验参数的合法行
		2.将结果返回
    }
    
#### UserAddressDAO

注：UserAddressDAOextends是一个接口，继承JpaRepository
编写各种查询方法
 
      UserAddress findById(Long id);
     @Query("select userAddress from UserAddress userAddress where userAddress.userId = ?1")
     List<UserAddress> findByUserId(Long userId);
     @Query("select userAddress from UserAddress userAddress " +
     "where userAddress.userId = ?1 and userAddress.deleted = ?2 order by userAddress.default desc")
     List<UserAddress> findUserAddress(Long userId, boolean isDelete);
    
#### UserAddress

填写表中字段（可自动生成），作为数据中转站

#### 2.UserController 

封装UserService userService; 

    1.增加接口，根据userId获得userAddressList
    getUserAddressListByUserId (@PathVariable("userId") Long userId) {
    return userAddressBO.getUserAddressListByUserId(userId); }

## 注：地址问题

    地址改为json格式，可能会影响以前的部分功能，解决办法：在C端处理，将从数据库中拿出的地址拼接成字符串。 
     
     
 



		


