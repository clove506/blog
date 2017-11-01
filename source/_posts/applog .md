---
title: 【优护数据】助手3.0.0埋点文档
date: 2016-12-06 11:44:13
categories: 优护数据
tags:
- Feature
---

# 优护助手3.0埋点文档

## key名

请求埋点格式：__ request _ app _ [requestName]
requestName与H5保持一致

页面埋点格式：__ page _ app _ [pageName]

## value格式
埋点格式：

@"hospitalId" : 医院id
@"hospital" : 医院名
@"departmentId" : 科室id
@"department" : 科室名
@"nurseId" : 用户Id
@"phone" : 手机号
@"currentVersion" : 当前版本号
@"env" : 当前环境代号如下

    YHJModeDebug = 0,    // 对内测试
    YHJModeDev = 1,      // 对外测试
    YHJModeRelease = 2,  // 正式
    YHJModeStaging = 3   // 灰度

## key值的page名详细对照
iOS：[pageName]

登录页面
YHJLoginViewController
基本信息页面
YHJBaseInfoViewController
医院列表页面
YHJHospitalTableViewController
科室列表页面
YHJDepartmentTableViewController
认证信息页面
YHJOccupationInformationViewController
Tab首页
YHJInformationViewController
Tab患者列表页
YHJPatientViewController
Tab工具列表页
YHJToolViewController
发起沟通页
YHJToolToCommunicationViewController
发起沟通选择患者
YHJSelectPatientViewController
发起沟通选择同事
YHJSelectColleagueViewController
管理界面
YHJToolToManageViewController
公告页面
YHJToolToNoticeViewController
全部同事页面
YHJMyColleagueViewController
Tab个人页面
YHJMyViewController
设置页面
YHJSetViewController
聊天页面
YHJChatViewController
文章工具列表页
YHJContentViewController
查看排班
YHJLookSchedulingViewController
选择排版
YHJSelectScheduleViewController
排版列表页
YHJRosterListViewController
编辑排版
YHJFixScheduleViewController
排班颜色
YHJRosterColorViewController
选择排版人员
YHJSelectExecutorsViewController
创建排班
YHJNewSchedulingViewController
批量排班
YHJBatchSchedulingViewController
批量添加排班页
YHJBatchToAddSchedulingViewController




