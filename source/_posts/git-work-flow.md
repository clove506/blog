---
title: 【代码规范】优护家代码规范
date: 2016-12-14 17:20:00
categories: 代码规范
tags:
---

优护家统一使用 Git & Github 来进行代码版本管理和托管代码服务。代码规范分为两部分：
1. 提交流程
2. 开发流程

# 提交流程
开发代码的过程中，必须以 fork 方式同步、提交代码。

流程如下：
1. 进入要开发的项目 Github 主页，点击 `Fork`，将会 `fork` 一个全新的项目到自己的名下；
2. 开发；
3. 要提交代码时，必须通过提交 `pull request` 方式提交；
5. 找 mentor 或者 同事 审核代码；
6. 上线。

# 开发流程
当 fork 代码之后，进入开发状态。

## 单人开发

遵循 [Git Flow](http://jeffkreeftmeijer.com/2010/why-arent-you-using-git-flow/)的开发模式，即开发分支有5种
1. master 线上分支
2. develop 开发分支
3. feature 开发功能分支
4. release 分支
5. hotfix 分支

开发时，在自己的项目中开发，例如开发主项目 `Youhujia/era` 项目：
1. 先 fork `Youhujia/era` 之后变为 `shawntien/era` 项目
2. clone `shawntien/era` 项目到本地
3. 用 git flow 模型开发。

## 多人开发

多人开发时，开发人员有两种：
* 项目负责人
* 开发者

`项目负责人` 和 `开发者` 都 fork 主项目，在自己的项目中使用 `Git Flow` 模型开发，同单人开发模式。当需要项目内部联调时，做一下操作：
1. 「开发者」创建一个 pull request 到 「项目负责人」；
2. 「项目负责人」负责合并代码，然后同步到测试服测试；
3. 测试完毕，提交 pull request 到主项目；
4. 由 `mentor` 或者 `同事` 做 review, 审核通过后合并代码到 master 分支；
5. 上线。

## 同步主项目代码
当有多人协作开发一个项目时，主项目会出现比个人项目代码更新的提交。

例如，A 和 B 同事开发一个项目，修改同一个文件，A 先做了提交，B 如果要继续提交代码，会被拒绝。因为 B 没有将 A 代码合并到自己的项目中。所以任何人在任何时间做代码提交时，都需要将主项目的代码先合并(merge)到本地。

合并有两种方式：
1. Github Client

  直接点击项目分支左上方的`Update from Youhujia/master`

2. 命令行方式

  ```json
  git remote add upstream git@github.com:Youhujia/{mainProjectName}.git

  git remote -v

  git fetch upstream

  git merge upstream/master
  ```

## 如果开启“强制 pull request”
创建项目的时候，在项目主页的 `settings` -> `Branches` 选项中：
1. 先在 `Protechted branches` 中选择 `master` 分支为受保护分支
2. 然后勾选
  * `Protect this branch`
  * `Require pull request reviews before merging `

然后点击保存。
