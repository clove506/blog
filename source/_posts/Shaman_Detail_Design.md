---
title: HighPriest子项目Shaman详细设计
date: 2017-02-28 11:00
categories: 系统架构
tags:
- CI
---

##摘要
本系统用于给开发人员提供界面，操作aliyun容器服务中的应用。
##框架
后端采用Python Tornado框架。
类模型
```
Shaman
    |- handler
        |=> __init__.py
        |=> clusters.py
        |=> applications.py
    |- object
        |=> __init__.py
        |=> cluster.py
          ->class ClusterQuery
          ->class Cluster
    |- Dockerfile
    |- init_db.py
    |- server.py
```
##交互预想
参考aliyun
![集群页面](/media/aliyun_cs_clusters_ui.png)
![应用页面](/media/aliyun_cs_applications_ui.png)
##API设计
**获得集群列表**
GET /api/v1/clusters/
* Response
```json
{
	"clusters":[
		{
			"name": "zhushou-dev",
  		"cluster_id": "c023e25445998440daab10d256c082e8a",
			"state": "running"
		}
	],
	"result": {
		"success": true,
		"code": 0
	}
}
```

**刷新集群信息**
GET /api/v1/clusters/{id}/refresh
* Response
```json
{
	"result": {
		"success": true,
		"code": 0
	}
}
```

**获得集群应用列表**
GET /api/v1/clusters/{id}/applications
* Response
```json
{
	"applications":[
		{
      "state": "running",
      "name": "zhushou-config-dev-default"
    },
    {
      "state": "running",
      "name": "zhushou-dagon-dev"
    },
	],
	"result": {
		"success": true,
		"code": 0
	}
}
```

**操作应用** start & stop
POST /api/v1/applications/{name}/{action}?cluster_id={cluster_id}

* Response
```json
{
	"result": {
		"success": true,
		"code": 0
	}
}
```
