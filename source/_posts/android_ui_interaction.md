---
title: android ui 交互网络请求的优化
date: 2017-02-15 21:20:00
categories: Android
tags:
- ui交互
- 网络请求
- 优化
---

# 摘要

在标签页面原来的交互逻辑可能和用户的操作不一致。

<!--more-->

# WIKI 维护人

罗秋雨

# PM
罗秋雨

# 优化

让交互与用户操作保持一致

# 实现方案

先根据用户操作更新view层展示内容，并把改变前的view状态保存，然后进行网络请求根据用户操作修改服务器数据，成功则更新view状态的保存，失败则view返回之前的状态。

### 具体实现


```
        CheckTag checkTag = labelTable.getAdapter().getTags().get(position);
    currentTable = labelTable;
    if (checkTag.tag.tagId != -99) {
       ArrayList<Integer> list = new ArrayList<>();
       //保存原有状态
       tempTags = myTags;
       myTags = new ArrayList<Tag>();
       //更新现有状态
       if (checkTag.ischeck) {
            if (tempTags != null) {
                for (Tag tag : tempTags) {
                    if (tag.tagId != checkTag.tag.tagId) {
                      list.add(tag.tagId);
                      myTags.add(tag);
                    }
                 }
             }
        } else {
            if (tempTags != null) {
               for (Tag tag : tempTags) {
                  list.add(tag.tagId);
                  myTags.add(tag);
               }
             }
             list.add(checkTag.tag.tagId);
             myTags.add(checkTag.tag);
        }
        updateMyTags(myTags);
        checkTag.ischeck = !checkTag.ischeck;
        labelTable.getAdapter().notifyDataSetChanged();
        //更新服务器数据
        updateMyTagsOnServer(list);
     } else {
        mChildTagName = "";
        mInputDialog.getEdit().setText("");
        mInputDialog.getPopupWindow().showAtLocation(mHeader, Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0);
     }
     
     
     
     private void updateMyTagsOnServer(ArrayList<Integer> list) {
        DataProvider.getInstance().setTagToPatient(this, mToken, mPatient.userId, list, new ITagResponse() {
            @Override
            public void success(TagResult tagResult) {
                updateMyTags(tagResult);
            }

            @Override
            public void fail(CommonResult failResult) {
                //失败返回原有状态
                updateMyTags(tempTags);
                requestFail(failResult);
            }

            @Override
            public void httpFail(int statusCode, Header[] headers, String responseString, Throwable throwable) {
                //失败返回原有状态
                updateMyTags(tempTags);
            }

            @Override
            public void sendReport(String urlKey, String url) {
                SensorReportUtils.reportRequest(activity, urlKey, url);
            }
        });
    }

```


