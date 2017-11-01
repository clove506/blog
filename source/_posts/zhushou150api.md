---
title: 【优护助手1.5.0】接口
date: 2016-12-06 11:44:13
categories: 优护助手原生APP
tags:
- Feature
---

# 优护助手1.5.0接口

{
    "className" :  "APIV2",
    "objcProtoPrefix" : "YHJ",
    "objcProtoFile" : "ZhushouV2",
    "javaProtoPackage" : "io.dcloud.service.protobuf.model",
    "javaProtoClass" : "ZhushouV2",
    "apis" : 
    [
        {
            "introduction" : "获取全部日常提醒页信息（不包括公告）",
            "api" : "getAllCanlendar",
            "tag" : "getAllCanlendar",
            "method" : "GET",
            "url" : "/api/nurses/calendars/messagePage",
            "responseClass" : "MessageCenterDTO"
        },
        {
            "introduction" : "添加公告",
            "api" : "addAnnouncement",
            "tag" : "addAnnouncement",
            "method" : "POST",
            "url" : "/api/nurses/calendars/events/announcement/v1",
            "requestClass" : "AnnouncementEventAddOption",
            "responseClass" : "AnnouncementEventAddDTO"
        },
        {
            "introduction" : "更新公告",
            "api" : "updateAnnouncement",
            "tag" : "updateAnnouncement",
            "method" : "PATCH",
            "url" : "/api/nurses/calendars/events/announcement/v1/{announcementId}",
            "urlParameter" :
            {
                "announcementId" : "uint"
            },
            "requestClass" : "AnnouncementEventUpdateOption",
            "responseClass" : "AnnouncementEventUpdateDTO"
        },
        {
            "introduction" : "获得单个公告",
            "api" : "getSingleAnnouncement",
            "tag" : "getSingleAnnouncement",
            "method" : "GET",
            "url" : "/api/nurses/calendars/events/announcement/v1/{announcementId}",
            "urlParameter" :
            {
                "announcementId" : "uint"
            },
            "responseClass" : "AnnouncementEventDTO"
        },
        {
            "introduction" : "获得所有公告",
            "api" : "getAllAnnouncement",
            "tag" : "getAllAnnouncement",
            "method" : "GET",
            "url" : "/api/nurses/calendars/events/announcements/v1",
            "responseClass" : "AnnouncementQueryDTO"
        },
        {
            "introduction" : "获得单个排班信息",
            "api" : "getSingleRoster",
            "tag" : "getSingleRoster",
            "method" : "GET",
            "url" : "/api/nurses/calendars/events/roster/{rosterId}",
            "urlParameter" :
            {
                "rosterId" : "uint"
            },
            "responseClass" : "RosterEventDTO"
        },
        {
            "introduction" : "获得单个随访信息",
            "api" : "getSingleFollowup",
            "tag" : "getSingleFollowup",
            "method" : "GET",
            "url" : "/api/nurses/calendars/events/followup/{followupId}",
            "urlParameter" :
            {
                "followupId" : "uint"
            },
            "responseClass" : "FollowUpEventDTO"
        },
        {
            "introduction" : "更新随访信息",
            "api" : "updateFollowup",
            "tag" : "updateFollowup",
            "method" : "PATCH",
            "url" : "/api/nurses/calendars/events/followup/{followupId}",
            "urlParameter" :
            {
                "followupId" : "uint"
            },
            "requestClass" : "FollowUpEventUpdateOption",
            "responseClass" : "FollowUpEventUpdateDTO"
        },
        {
            "introduction" : "QR Code",
            "api" : "getQRCode",
            "tag" : "getQRCode",
            "method" : "GET",
            "url" : "/api/galaxy/v1/my-qrcode?nurseId={nurseId}",
            "urlParameter" :
            {
                "nurseId" : "uint"
            },
            "responseClass" : "QrCodeDTO"
        },
        {
            "introduction" : "添加患者",
            "api" : "addPatient",
            "tag" : "addPatient",
            "method" : "POST",
            "url" : "/api/galaxy/v1/patients",
            "requestClass" : "PatientOpt",
            "responseClass" : "CommonResponseDTO"
        },
        {
            "introduction" : "发起评估",
            "api" : "createEvalution",
            "tag" : "createEvalution",
            "method" : "POST",
            "url" : "/api/galaxy/v1/evaluations/init",
            "requestClass" : "InitEvalution",
            "responseClass" : "CommonResponseDTO"
        },
        {
            "introduction" : "评估量表库",
            "api" : "getAllEvalution",
            "tag" : "getAllEvalution",
            "method" : "GET",
            "url" : "/api/galaxy/v1/evaluations",
            "responseClass" : "EvaluateGroupListDTO"
        },
        {
            "introduction" : "获取评估可选时间",
            "api" : "getEvalutionTime",
            "tag" : "getEvalutionTime",
            "method" : "GET",
            "url" : "/api/galaxy/v1/evaluation-times",
            "responseClass" : "ServiceTimeDTO"
        },
        {
            "introduction" : "评估表详情",
            "api" : "getEvalutionDetail",
            "tag" : "getEvalutionDetail",
            "method" : "GET",
            "url" : "/api/galaxy/v1/evalutions/{evalutionId}",
            "urlParameter" :
            {
                "evalutionId" : "uint"
            },
            "responseClass" : "EvaluationDTO"
        },
        {
            "introduction" : "提交评估",
            "api" : "submitEvalution",
            "tag" : "submitEvalution",
            "method" : "POST",
            "url" : "/api/galaxy/v1/evaluations/{evalutionId}",
            "urlParameter" :
            {
                "evalutionId" : "uint"
            },
            "requestClass" : "SubmitEvaluation",
            "responseClass" : "EvaluationResultDTO"
        },
        {
            "introduction" : "查看评估结果",
            "api" : "getEvalutionResult",
            "tag" : "getEvalutionResult",
            "method" : "GET",
            "url" : "/api/galaxy/v1/evaluations/{evaluationId}/{evaluationSubmitId}",
            "urlParameter" :
            {
                "evaluationId" : "uint",
                "evaluationSubmitId" : "uint"
            },
            "responseClass" : "EvaluationResultDTO"
        },
        {
            "introduction" : "健康宣教列表",
            "api" : "getArticleList",
            "tag" : "getArticleList",
            "method" : "GET",
            "url" : "/api/galaxy/v1/articles",
            "responseClass" : "ArticleGroupListDTO"
        },
        {
            "introduction" : "健康宣教详情",
            "api" : "getSingleArticle",
            "tag" : "getSingleArticle",
            "method" : "GET",
            "url" : "/api/galaxy/articles/{aritcleId}",
            "urlParameter" :
            {
                "aritcleId" : "uint"
            },
            "responseClass" : "ArticleDTO"
        },
        {
            "introduction" : "患者详情页",
            "api" : "getPatientDetailPage",
            "tag" : "getPatientDetailPage",
            "method" : "GET",
            "url" : "/api/galaxy/v1/users/{userId}",
            "urlParameter" :
            {
                "userId" : "uint"
            },
            "responseClass" : "UserDTO"
        },
        {
            "introduction" : "患者标签详情",
            "api" : "getPatientTags",
            "tag" : "getPatientTags",
            "method" : "GET",
            "url" : "/api/galaxy/v1/users/{userId}/tag-category",
            "urlParameter" :
            {
                "userId" : "uint"
            },
            "responseClass" : "TagCategory"
        },
        {
            "introduction" : "康复护理记录(患者的)",
            "api" : "getPatientCareRecord",
            "tag" : "getPatientCareRecord",
            "method" : "GET",
            "url" : "/api/galaxy/v1/care-records?patientId={patientId}",
            "urlParameter" :
            {
                "patientId" : "uint"
            },
            "responseClass" : "NursingRecordDTO"
        },
        {
            "introduction" : "我的工作记录",
            "api" : "getMyWorkRecord",
            "tag" : "getMyWorkRecord",
            "method" : "GET",
            "url" : "/api/galaxy/v1/work-records",
            "responseClass" : "WorkRecord"
        },
        {
            "introduction" : "提交反馈",
            "api" : "submitFeedback",
            "tag" : "submitFeedback",
            "method" : "POST",
            "url" : "/api/galaxy/v1/feedback",
            "requestClass" : "FeedbackSubmit",
            "responseClass" : "SimpleResponse"
        }
    ]
}


