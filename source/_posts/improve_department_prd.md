---
title: 科室完善 PRD文档
date: 2017-3-14 13:30:00
categories: 优护助手
tags:
- 万家科室
- 优护助手
- 优护后台
---

# 摘要
## 背景
为了完成万家科室项目，需获取全国医院及科室的基础信息及其位置信息（北京、合肥等城市优先），并将其整合到Yolar下相关的表结构中
## 实现
通过爬虫爬到相关城市的医院科室信息，利用这些信息调用高德地图的API，获得其地理位置信息并整理存储在我们的数据库表结构中
## 预期产出
1. 完整的中国三级行政区域结构表
2. 包含有基础信息以及地理位置信息的医院和科室信息
3. 对医院和科室信息的CURD以及认证审核的接口

<!--more-->

# 文档更新

时间|内容|维护人
---|---|---
2017-3-14|创建文档|李圣阳
2017-3-15|完善文档|李圣阳


# 设计使用场景

**预配置**
1. 三级行政区域信息入库
2. 爬取全国城市的医院科室信息（主要城市优先）
3. 更新Yolar数据库中医院和科室的基本信息
4. 更新Yolar数据库中医院和科室的位置信息
5. 完成预配置

**优护助手中的护士**
1. 护士注册时新建医院，科室
2. 护士注册时选择医院，科室

**admin端**
1. 运营人员新建医院，科室
2. 运营人员修改医院，科室信息
3. 运营人员审核认证医院，科室

# 模型设计

## Area模型介绍
### 为何会有Area
为了存储全国的三级地理行政区域划分，在我们的系统中引入了Area（区域）这个概念模型并落实到表和类中（表结构在下文数据库设计中，其对应的实体类则严格按照数据库表结构来生成）
### 何为Area
Area（区域）为一个设计概念，在这个模型中，所有的省，市，行政区域皆为平级结构模型Area，也就是说，这三个等级的区域划分在我们的数据库和类中是不做区分的，统一为Area这个模型概念。而当我们需要一个严格按照地理区域规划形成的“省——市——行政区域”的树状层级的数据结构的时候，我们从数据库中一次性遍历出所有的节点（所有的省、市、行政区域的Area），根据他们节点信息中存储的parent_id（其上一个地理区域划分的节点），将之构建为我们需要的结构。
### Area与医院地理位置信息
在我们这一期项目中，会对医院的结构中加入一个名为Area_id的字段，并将其作为医院表的外键连接Area表的id字段；保存在医院表中的id字段为该医院所位于的第三级地理区域划分的area记录的id（即医院所在行政区域的id，如"中国人民解放军总医院第一附属医院"这条医院记录中的area_id所对应的area表中表示的应该是海淀区）

# 数据库设计


**行政区域表**

```SQL
CREATE TABLE IF NOT EXISTS `area` (
  `id` BIGINT UNSIGNED NOT NULL COMMENT '唯一标识id',
  `name` VARCHAR(512) NOT NULL COMMENT '当前行政区域名称',
  `parent_id` BIGINT NULL DEFAULT '-999' COMMENT '该行政区域上一级的行政区域的id，默认为-999，即省级行政区域的上一级为-999',
  PRIMARY KEY (`id`))
ENGINE = InnoDB DEFAULT CHARSET=utf8;
```

**Yolar.organization**

```SQL
ALTER TABLE `organization` 
ADD COLUMN `level` VARCHAR(512) NULL COMMENT 'String 用来记录医院的等级 暂时的等级是一级、二级、三级；甲等乙等丙等（其中三级独有特等）' AFTER `status`,
ADD COLUMN `area_id` BIGINT NULL COMMENT '外键 关联区域规划表中的区级 用来存储医院的区域信息' AFTER `level`,
ADD COLUMN `img_url` VARCHAR(512) NULL COMMENT '医院图片的url' AFTER `area_id`;
ALTER TABLE `organization` 
ADD CONSTRAINT `organization_area`
  FOREIGN KEY ()
  REFERENCES `area` ()
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
```

**Yolar.department**

```SQL
ALTER TABLE `department` 
ADD COLUMN `may_contact` VARCHAR(512) NULL COMMENT '可能的联系方式' AFTER `status`,
ADD COLUMN `img_url` VARCHAR(512) NULL COMMENT '科室图片url' AFTER `may_contact`;
```
## protobuf数据模型
```

// ---------- area result message ----------//

//区级行政规划数据，包括id和其name
message 
AdministrativeDivisionData{
    optional int64 adId = 1;
    optional string adName = 2;
}

//市级行政规划数据，包括其id、name以及其下所有的区级区域的信息
message CityData{
    optional int64 cityId = 1;
    optional string cityName = 2;
    repeated AdministrativeDivisionData administrativeDivisions = 3;
}

//省级行政规划数据，包括其id，name以及其下所有的市级区域信息
message ProvinceData{
    optional int64 pId = 1;
    optional string pName = 2;
    repeated CityData cities = 3;
}

//用来包装所有的省级区域信息
message MapDataDTO{
    repeated ProvinceData provinces = 1;
}

//用来返回result以及包装返回数据
message MapDTO{
    optional Result result = 1;
    optional MapDataDTO data = 2;
}

// ---------- message for zhushuo ----------//

//简单的医院信息
message OrganizationInfo{
    optional int64 id = 1;
    optional string name = 2;
}

//包装简单医院信息
message LBSOrganizationDataDTO{
    repeated OrganizationInfo infos = 1;
}

//包装返回信息和result
message LBSOrganizationDTO{
    optional Result result = 1;
    optional LBSOrganizationDataDTO data = 2;
}

//简单科室信息
message LBSDepartmentInfo{
    optional int64 id = 1;
    optional string name = 2;
}

//包装简单科室信息
message LBSDepartmentDataDTO{
    repeated LBSDepartmentInfo infos = 1;
}

//包装返回信息和result
message LBSDepartmentDTO{
    optional Result result = 1;
    optional LBSDepartmentDataDTO data = 2;
}

//注册科室：
//organizationId：医院id
//name：科室的名称
//mayContact：审核联系方式
message LBSCreateDepartmentOption{
    optional int64 organizationId = 1;
    optional string name = 2;
    optional string mayContact = 3;
}

//创建医院及科室的接口中的科室的信息
message LBSCreateDepartment{
    optional string name = 1;
    optional string mayContact = 2;
}

//创建医院及科室的传入信息
//name:医院的名字
//area_id:该医院所在的区域（区级行政区域划分的id）
message LBSCreateOrganizationAndDepartmentOption{
    optional string name = 1;
    optional int64 area_id = 2;
    optional LBSCreateDepartment departmentInfo = 3;
}

//---------- message for admin ----------//
//manager organization
message CreateOrUpdateOrganizationOption{
    optional int64 id = 1;
    optional string name = 2;
    optional string level = 3;
    optional string address = 4;
    optional double lat = 5;
    optional double lon = 6;
    optional int32 status = 7;
    optional int64 areaId = 8;
    optional string imgUrl = 9;
}

message ManagerOrganization{
    optional int64 id = 1;
    optional string name = 2;
    optional string level = 3;
    optional string province = 4;
    optional string city = 5;
    optional string ad = 6;
    optional string address = 7;
    optional double lat = 8;
    optional double lon = 9;
    optional int64 createdAt = 10;
    optional int32 status = 11;
    optional int64 areaId = 12;
    optional string imgUrl = 13;
}

message ManagerOrganizationDataDTO{
    optional ManagerOrganization organization = 1;
}
message ManagerOrganizationDTO{
    optional Result result = 1;
    optional ManagerOrganizationDataDTO data = 2;
}

message ManagerOrganizationListDataDTO{
    repeated ManagerOrganization managerOrganizations = 1;
}

message ManagerOrganizationListDTO{
    optional Result result = 1;
    optional ManagerOrganizationListDataDTO data = 2;
    optional int32 draw = 3;
    optional int32 recordsFiltered = 4;
    optional int32 recordsTotal = 5;
}
//mamager department
message CreateOrUpdateDepartmentOption{
    optional int64 id = 1;
    optional int64 organizationId = 2;
    optional string name = 3;
    optional string number = 4;
    optional string mayContact = 5;
    optional string imgUrl = 6;
    optional int32 status = 7;
}

message ManagerDepartment{
    optional int64 id = 1;
    optional int64 organizationId = 2;
    optional string name = 3;
    optional string number = 4;
    optional string mayContact = 5;
    optional string imgUrl = 6;
    optional string organizationName = 7;
    optional int64 createdAt = 8;
    optional int32 status = 9;
}

message ManagerDepartmentDataDTO{
    optional ManagerDepartment department = 1;
}
message ManagerDepartmentDTO{
    optional Result result = 1;
    optional ManagerDepartmentDataDTO data = 2;
}

message ManagerDepartmentListDataDTO{
    repeated ManagerDepartment managerDepartments = 1;
}
message ManagerDepartmentListDTO{
    optional Result result = 1;
    optional ManagerDepartmentListDataDTO data = 2;
}
//---------- end ----------//
```



# 附上高德地图关键API测试url（个人开发账号 每月请求次数有限 请不要没事点两下）
## 获取全国的三级行政区域划分数据：
http://restapi.amap.com/v3/config/district?key=6fc800378f55173878a9004e0dd1aa7b&keywords=中国&subdistrict=3&showbiz=false&extensions=base

## 根据医院名称以及省份获取医院的区域规划信息：
http://restapi.amap.com/v3/place/text?key=6fc800378f55173878a9004e0dd1aa7b&keywords=吐鲁番市高昌区人民医院&types=&city=吐鲁番&children=1&offset=20&page=1&extensions=all

# 场景分析
## 优护助手
### 新增科室

- 注册时选择医院
    - 基于地理位置：省市/直辖市区
    - 选择医院时，发现无此医院，可以进行新增（医院名下至少有一个科室）
        - 显示已选的地区
        - 填写医院及科室的名称、联系方式
    - 新增完成，填入其所填医院及科室

![chooseHospital](/media/chooseHospital.png)

- 注册时选择科室
    - 如有科室，选择后返回注册页面
    - 如没有科室，可以新建科室
        - 显示已选的地区
        - 填写科室的名称、联系方式
        - 提交后返回注册页

![chooseDepartment](/media/chooseDepartment-1.png)

- 对于新增的医院及科室，状态均为**审核不通过**
- 审核通过即在B端医院&科室list显示


## admin端
### 科室审核

- 医院列表


![41医院列表](/media/id_01.jpg)

- 新增&编辑医院信息

![42医院新增编辑](/media/id_02.jpg)

- 科室列表

![51科室列表](/media/id_03.jpg)

- 新增&编辑科室信息

![52科室编辑](/media/id_04.jpg)
![52科室新增](/media/id_05.jpg)


# 接口文档
## 工具服务相关接口
**获取三级行政区域划分**

GET /api/era/utils/areas

* 接口描述：获取所有省份的三级行政区域划分的数据集合

* Response  (protobuf MapDTO)

  ```json
  {
    "result": {
        "code": 0,
        "success": true
    },
    "data": {
        "provinces": [
            {
                "pId": 1,
                "pName": "黑龙江",
                "cities": [
                    {
                        "cityId": 34,
                        "cityName": "哈尔滨",
                        "administrativeDivisions": [
                            {
                                "adId": 677,
                                "adName": "道里区"
                            }
                        ]
                    }
                ]
            }
        ]
    }
}
  ```
  
## 优护助手相关服务接口

**新建医院及科室**

POST /api/organizations/create-organization-and-department

* 接口描述：创建医院及其名下一个科室

* Request  (protobuf LBSCreateOrganizationAndDepartmentOption)

  ```json
  {
    "name": "304医院",
    "area_id": 455,
    "departmentInfo": {
        "name": "生老病死科",
        "mayContact": "110-119-120"
    }
}
  ```

* Response  (protobuf CreateOrUpdateOrganizationDTO,会有部分字段因为不存在的关系没有数据)

  ```json
  {
    "result": {
        "code": 0,
        "success": true
    },
    "data": {
        "organization": {
            "id": 1222,
            "name": "火烧蛋包饭附属医院",
            "level": "三级甲等",
            "areaId": 456,
            "lat": 112.44,
            "lon": 211.22,
            "address": "二踢脚弄二次爆炸胡同3号",
            "imgUrl":"http://www.kengni.w"
        }
    }
}
  ```
  
**新建科室**

POST /api/departments/create-department

* 接口描述：创建一个科室

* Request  (protobuf LBSCreateDepartmentOption)

  ```json
  {
    "organizationId": 11,
    "name": "戛然而止科",
    "mayContact": "134422"
}
  ```

* Response  (protobuf CreateOrUpdateDepartmentDTO,会有部分字段因为不存在的原因没有数据)

  ```json
  {
    "result": {
        "code": 0,
        "success": true
    },
    "data": {
        "department": {
            "id": 2333,
            "name": "六点多科",
            "organizationId": 32,
            "number": "ldd-12",
            "mayContact": "18833334444",
            "imgUrl": "http://www.kengni.w"
        }
    }
}
  ```
**根据行政区域划分查询对应的医院**

GET /api/organizations/get-by-area/{administrativeDivisionId}

* 接口描述：根据行政区域划分中的区级信息对应的id，查找当前区域内的所有医院

* Response  (protobuf LBSOrganizationDTO)

  ```json
  {
    "result": {
        "code": 0,
        "success": true
    },
    "data": {
        "infos": [
            {
                "id": 123,
                "name": "苞米地第一医院"
            }
        ]
    }
}
  ```
**根据医院id查询对应的科室**

GET /api/departments/get-by-org-id/{orgId}

* 接口描述：根据医院对应的id，查找所有在其名下的科室

* Response  (protobuf LBSDepartmentDTO)

  ```json
  {
    "result": {
        "code": 0,
        "success": true
    },
    "data": {
        "infos": [
            {
                "id": 123,
                "name": "旗鼓相当科"
            }
        ]
    }
}
  ```

## 后台管理相关服务接口

**根据行政区域划分查询对应的医院**

GET /api/era/v1/admin/organizations/get-by-area/{administrativeDivisionId}

* 接口描述：根据行政区域划分中的区级信息对应的id，查找当前区域内的所有医院

* Response  (protobuf LBSOrganizationDTO)

  ```json
  {
    "result": {
        "code": 0,
        "success": true
    },
    "data": {
        "infos": [
            {
                "id": 123,
                "name": "苞米地第一医院"
            }
        ]
    }
}
  ```

  **获取所有的医院列表**

GET /api/era/v1/admin/organizations/manager-organization?adId={adId}&draw={draw}&length={length}&start={start}

* 接口描述：获取所有的医院（包括未审核的医院）

* Response  (protobuf ManagerOrganizationListDTO)

  ```json
  {
    "result": {
        "code": 0,
        "success": true
    },
    "data": {
        "managerOrganizations": [
            {
                "id": 12,
                "name": "驴打滚生生不息医院",
                "level": "二级甲等",
                "province": "辽宁省",
                "city": "沈阳市",
                "ad": "二货区",
                "address": "胡同拐角狗洞2号",
                "lat": 111.22,
                "lon": 233.44,
                "createdAt": 23123198231231,
                "status": 0,
                "areaId":456,
                "imgUrl":"wwww.www.w"
            }
        ]
    }
}
  ```
  
  **根据医院获取所有的科室列表**

GET /api/era/v1/admin/departments/manager-department?orgId

* 接口描述：获取医院名下所有的科室（包括未审核的科室）

* Response  (protobuf ManagerDepartmentListDTO)

  ```json
  {
    "result": {
        "code": 0,
        "success": true
    },
    "data": {
        "managerDepartments": [
            {
                "id": 12,
                "organizationId":100329,
                "name": "不会旋转科",
                "organizationName": "驴打滚生生不息医院",
                "createdAt": 23123198231231,
                "status": 0,
                "number":"kk-10",
                "mayContact":"400-820-8820",
                "imgUrl":"www.w.w.w.w"
            }
        ]
    }
}

  ```
  
  **新建医院**

POST /api/era/v1/admin/organizations/manager-organization

* 接口描述：创建一个医院

* Request  (protobuf CreateOrUpdateOrganizationOption)

  ```json
  {
    "name": "火烧蛋包饭附属医院",
    "level": "三级特等",
    "areaId":456,
    "lat":112.44,
    "lon":211.22,
    "address":"二踢脚弄二次爆炸胡同3号",
    "imgUrl":"http://www.kengni.w"
}
  ```

* Response  (protobuf ManagerOrganizationDTO)

  ```json
  {
    "result": {
        "code": 0,
        "success": true
    },
    "data": {
        "organization": {
            "id": 1222,
            "name": "火烧蛋包饭附属医院",
            "level": "三级特等",
            "areaId": 456,
            "lat": 112.44,
            "lon": 211.22,
            "address": "二踢脚弄二次爆炸胡同3号",
            "imgUrl":"http://www.kengni.w",
            "status":1
        }
    }
}
  ```

  **新建科室**

POST /api/era/v1/admin/departments/manager-department

* 接口描述：创建一个科室

* Request  (protobuf CreateOrUpdateDepartmentOption)

  ```json
  {
    "name": "六点多科",
    "organizationId": 32,
    "number":"ldd-12",
    "mayContact":"18833334444",
    "imgUrl":"http://www.kengni.w"
}
  ```

* Response  (protobuf ManagerDepartmentDTO)

  ```json
  {
    "result": {
        "code": 0,
        "success": true
    },
    "data": {
        "department": {
            "id": 2333,
            "name": "六点多科",
            "organizationId": 32,
            "number": "ldd-12",
            "mayContact": "18833334444",
            "imgUrl": "http://www.kengni.w",
            "status":1
        }
    }
}
  ```
  
  **修改医院信息**

PATCH /api/era/v1/admin/organizations/manager-organization/{orgId}

* 接口描述：修改医院信息

* Request  (protobuf CreateOrUpdateOrganizationOption)

  ```json
  {
    "name": "火烧蛋包饭附属医院",
    "level":  "一级丙等",
    "areaId":456,
    "lat":112.44,
    "lon":211.22,
    "address":"二踢脚弄二次爆炸胡同3号",
    "imgUrl":"www.baidu.com",
    "status":1
}
  ```

* Response  (protobuf ManagerOrganizationDTO)

  ```json
  {
    "result": {
        "code": 0,
        "success": true
    },
    "data": {
        "organization": {
            "id": 1222,
            "name": "火烧蛋包饭附属医院",
            "level": "二级乙等",
            "areaId": 456,
            "lat": 112.44,
            "lon": 211.22,
            "address": "二踢脚弄二次爆炸胡同3号",
            "imgUrl":"http://www.kengni.w",
    "status":1
        }
    }
}
  ```

  **修改科室信息**

PATCH /api/era/v1/admin/departments/manager-department/{departmentId}

* 接口描述：修改科室信息

* Request  (protobuf CreateOrUpdateDepartmentOption)

  ```json
  {
    "name": "六点多科",
    "organizationId": 32,
    "number":"ldd-12",
    "mayContact":"18833334444",
    "imgUrl":"www.google.cn",
    "status":1
}
  ```

* Response  (protobuf ManagerDepartmentDTO)

  ```json
  {
    "result": {
        "code": 0,
        "success": true
    },
    "data": {
        "department": {
            "id": 2333,
            "name": "六点多科",
            "organizationId": 32,
            "number": "ldd-12",
            "mayContact": "18833334444",
            "imgUrl": "http://www.kengni.w"
,
    "status":1        }
    }
}
  ```
  
  **删除一个医院**

DELETE /api/era/v1/admin/organizations/manager-organization/{orgId}

* 接口描述：根据医院id删除一个医院

* Response   (protobuf ManagerOrganizationDTO)

  ```json
  {
    "result": {
        "code": 0,
        "success": true
    }
}
  ```

  **删除一个科室**

DELETE /api/era/v1/admin/departments/manager-department/{departmentId}

* 接口描述：根据科室id删除一个科室

* Response   (protobuf ManagerDepartmentDTO)

  ```json
  {
    "result": {
        "code": 0,
        "success": true
    }
}
  ```
  
  
  **获取单个医院信息**

GET /api/era/v1/admin/organizations/manager-organization/{orgId}

* 接口描述：根据医院id获取一个医院的信息

* Response  (protobuf ManagerOrganizationDTO)

  ```json
  {
    "result": {
        "code": 0,
        "success": true
    },
    "data": {
        "organization": {
            "id": 122,
            "name": "麦乐鸡扭曲第三医院",
            "level": "乙级二等",
            "province": "吉林省",
            "city": "吉林市",
            "ad": "吉林区",
            "lat": 222.33,
            "lon": 111.22,
            "address": "木头桩子村村口王师傅脚下",
            "imgUrl": "www.sina.com.cn",
    "status":1,
    "createdAt":1231232323123,
    "areaId":456
        }
    }
}
  ```

  **获取单个科室信息**

GET /api/era/v1/admin/departments/manager-department/{departmentId}

* 接口描述：根据科室id获取一个科室信息

* Response  (protobuf ManagerDepartmentDTO)

  ```json
  {
    "result": {
        "code": 0,
        "success": true
    },
    "data": {
        "department": {
            "id": 122,
            "organizationId":11
            "organizationName": "麦乐鸡扭曲第三医院",
            "name": "骨缝破裂科",
            "number": "gfpl",
            "mayContact": "400-820-8820",
            "imgUrl": "www.soho.cn",
    "status":1,
    "createdAt":1234567
        }
    }
}
  ```
  
# 开发方案

## 预处理阶段
1. 利用高德地图API获取全国所有的省市三级行政区域划分信息，按照area表结构入库
2. 根据医院分级创建医院科室的分级信息enum
3. 根据设计的表结构，建表并生成对应的实体类

## 数据获得阶段
0. 先将我们数据库中所有的医院和科室的status置为已审核（1）
1. 通过爬虫爬取医院及科室信息，大致的json如下：
{"hospital_level": "三甲", "department_name": "运动医学科", "hospital_name": "北京百汇京顺医院", "city_name": "朝阳", "province_name": "北京"}

2. 根据这些json信息过滤出我们需要的信息（医院名称，科室名称，省份信息）
3. 进行一次性操作：根据医院/科室名称，更新已有科室的level信息，同时新建查询不到的医院/科室
4. 根据高德地图API和对应的医院、省份信息获取医院的行政区域划分同时更新area_id字段

## 收尾阶段
1. 完成功能接口，实现科室和医院的CRUD以及审核等接口
2. 自测


# 可能存在的风险
1. 高德地图的API使用次数，使用方法，复杂返回值的处理
2. 因为新增了很多的科室，所以其他项目中的获取全部医院/科室的接口调用就会变更为获取全部已审核的医院/科室，可能会有部分方法的实现需要改动

  
# 参考

http://wiki.office.test.youhujia.com/2017/03/06/Our_Perfect_Departments/
  
  http://wiki.office.test.youhujia.com/2017/03/13/improve_department/


# 开发排期

内容|耗时/人日|actor|预计开始日期
---|---|---|---
前期准备：数据库修改、生成实体类、protobuf对象生成、医院等级enum对象构建等|1|李圣阳|03.20
地理区域高德API调用入库|1|李圣阳|03.21
数据爬取梳理|1.5|李圣阳|03.22
数据处理入库|1|李圣阳|03.23
医院、科室的CRUD和审核接口|1.5|李圣阳|03.25
受影响的接口的修改|1|李圣阳|03.27
前端页面开发|3|李旭|03.25
客户端开发|3|-|03.2？
自测|1|李圣阳|03.28
客户端联调|1|李圣阳&-|03.29
前后端联调|1|李圣阳&李旭|03.30
提测|1|郑旭红|03.31
部署、验收、上线|1|李圣阳&张正宇|04.01


# 部署上线流程：

1、合并Halo,Yolar,Era,Gateway的代码到master分支

2、调用 /api/era/utils/all-in 接口，在数据库中生成Area信息

3、修改Area中部分脏数据：

北京市市辖区、天津市市辖区、上海市市辖区、重庆市市辖区 —— 北京市、上海市、天津市、重庆市

为 济源市、神农架林区、潜江市、天门市、仙桃市、嘉峪关市、三沙市、儋州市、石河子市、五家渠市、东莞市、中山市、定西市 添加同名区域信息

在做数据注入前，必须要先把所有医院和科室的status置为1

4、去权限管理系统中配置app和role

5、修改config_repo的配置：

Era:

role:
  reader: 10
  editor: 12
  admin: 13 
  
  improveDepartment:
  id: 9
  secret: 875ea597-958e-409b-b69e-e186b09bc11
  
  map:
  areaInfoUrl: http://restapi.amap.com/v3/config/district
  areaInfoParams: key=6fc800378f55173878a9004e0dd1aa7b&keywords=中国&subdistrict=3&showbiz=false&extensions=base
  readHospitalFileName: src/main/resources/department.json
  amapAPIKey: 6fc800378f55173878a9004e0dd1aa7b
  amapSearchPOIUrl: http://restapi.amap.com/v3/place/text
  hospitalErrOutFileName: src/main/resources/errorHospitalLog.json

  Gateway：
  
  no.need.authenticate.urls: /api/era/utils
  filters.admin2.urls:/api/era/v1/admin/
  
6、重启Gateway、Era

7、调用 /api/era/utils/department-wife 接口将department.json中的科室信息入库

  code : ekufgisdgfiu-gwe09r23r79g-fwr9fg9-23ygw9efuge8rv
  
8、上线完毕，预计六小时


# 开发日志

### 2017-03-14

**今日**

- 科室完善前期调研
- 科室完善初步方案
- 科室完善prd文档第一版成稿

**明日**

- 科室完善方案完成，进一步review，争取kick off

### 2017-03-15

**今日**

- 完善prd文档 
- 与前端同学初步沟通方案和时间等问题
- 与客户端同学初步沟通方案和时间等问题
- 后台开发方案review

**明日**

- 进一步review，抓紧开会，争取kick off

### 2017-03-16
**今日**

- 完善prd文档 
- review会议，和前端服务器同学沟通接口以及人员排期
- 经mmliu桑同意，项目kick off

**明日**

- 因为学校身份信息补录，开始休假。预计周一收假。

### 2017-03-21

**今日**

- 前期准备：数据库修改、生成实体类、protobuf对象生成 
- 地理区域高德API调用

**明日**

- 确认爬取的具体城市
- 数据爬取、读取、入库

### 2017-03-22

**今日**

- 医院json文件的读取 整理 地图API调用 处理返回数据 入库的代码完成

**明日**

- 测试今日代码的正确性
- 如若正确 进度向前推进

### 2017-03-23

**今日**

- 北京、合肥医院科室信息已经全部进入yolar_dev库，高德地图API企业开发者账号申请中，进度乐观，具体了乐观到什么程度不告诉你们。

**明日**

- 进度push push push！

### 2017-03-24

**今日**

- 后端开发进行到了era层面，哈哈哈哈哈哈哈

**明日**

- 进度push push push！

### 2017-03-25

**今日**

- era,halo,yolar三端不涉及权限的部分，搞定，期待袁鑫明天的加班

**明日**

- 进度push push push！

### 2017-03-27

**今日**

- 自测完毕

**明日**

- 进度push push push！

### 2017-03-28
**今日**

- 自测完毕
- 添加完善现有医院的逻辑
- 完成全国八万多家科室的入库，并发现一些脏数据
- 确认前端客户端排期和联调时间


**明日**

- 代码review
- 客户端联调

### 2017-03-29
**今日**

- 客户端联调完成
- 确认前端排期和联调时间


**明日**

- 代码review
- 配合前端开发
- 熟悉新需求，准备下一阶段的开发

### 2017-03-30
**今日**

- 客户端联调完成
- 前后端部分联调完成
- 修改接口和和前端统一

**明日**

- 代码review
- 前后端联调
- 熟悉新需求，准备下一阶段的开发

### 2017-03-31
**今日**

- 客户端联调完成
- 前后端部分联调完成
- 修改接口和和前端统一

**明日**

- 代码review
- 前后端联调
- 熟悉新需求，准备下一阶段的开发

### 2017-04-01
**今日**

- 终于上了dev

**节后**

- 代码review
- 前后端联调，提测
- 熟悉新需求，准备下一阶段的开发

### 2017-04-05
**今日**

- 项目冻结

**明天**

- 冻上了

