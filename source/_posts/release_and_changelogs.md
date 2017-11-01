---
title: 12月份发布记录
date: 2016-12-05
categories: 发布记录
tags:
- 标签
- 缺陷修复
---

# 2016-12-19 【缺陷修复】优护助手今日日程显示数量有误
## 内容
1.2版本优化助手--日程提醒--今日日程显示的日程项，新建公告和排班不在日程中显示

## 原因
Momentum和Galaxy的halo版本升级不一致，导致Galaxy在返回后台公告和排班数据时不返回给前端。

## 修复办法
修改Momentum和Galaxy，升级所有Halo版本为1.4.2，将Halo中所有日志包改为jcl-over-slfj-1.7.21.jar


# 2016-12-12 停机维护15分钟

## 内容

center01 系统磁盘满了，docker的数据从 /var/lib/docker 迁移到 /data/docker/data 下


# 2016-12-08 【缺陷修复】优化助手今日日程显示数量不对
## 内容
1.2版本优化助手--日程提醒--今日日程显示的日程项，数量过多。

## 原因
由于今日日程接收到的数据中隐含的加上了公告，所以在今日日程的显示日程项中，比应该有的多了公告数。

## 修复办法
修改galaxy中HomeContextFactory，把发送给前端的Today中的Task筛选出排班和随访。

# 2016-12-08 微信C端文章详情更新
## 微信C端文章详情更新 
修改二文章详情，关闭显示更多功能
涉及服务 yhzs-c

# 2016-12-08 后台二维码更新
## 科室二维码  
修改二维码列表，添加医院／科室的id和名称   
涉及服务 yhj-admin

# 2016-12-06 后台二维码上线
## 科室二维码
涉及服务 yhj-admin


# 2016-12-06 Momentum 上线
## 内容
Momentum 项目上线。

## 具体上线流程
sophon, momentum, galaxy
1 备份数据库
2. 发布 sophon
3. 发布 momentum
4. 发布 galaxy
5. 测试

## 上线过程遇到的问题
1. galaxy production 环境配置没有准备好；
2. sophon production 配置没有完全配置好，PORT & MPORT 依旧是老的配置；
3. galaxy 配置中， android/ios 配置中 `版本` & `URL` 并没有提前准备好。

## bug
上线后发现两个问题
1. 原有接口被改名，老版本 App 无法访问
2. 发生一例 [NullPointerException](https://github.com/Youhujia/galaxy/issues/1)


# 2016-12-05 后台二维码列表 上线
## 内容
基于ng2的二维码列表后台上线。

## 具体上线流程  
1. 更新项目代码
2. 重启服务器

# 2016-12-05 认证后台超时错误
## 问题
认证页面数据加载超时。

## 修复办法
取消 gateway 的超时设置，即修改 `config-repo` 中 `gateway-production.yml`

```
hystrix.command.default.execution.timeout.enabled: false
```

该修复为临时修复，后续发版时增加专用查询所有护士接口。


# 2016-12-01【缺陷修复】修复普通护士不能删除患者标签的问题
## 摘要
修复了之前的问题，现在所有护士，不论是否为「护士管理员」或者「科秘」都可以删除患者标签了。

## 内容
- 删除患者标签时，不对 `nurse` 做状态检查，即 `nurse.status` 检查。


