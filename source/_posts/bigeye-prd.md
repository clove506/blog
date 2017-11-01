---
title: 搜索项目 Big Eye
date: 2017-03-20 16:57:05
categories: 搜索
tags:
- BigEye
- 搜索
- PRD
- Redis
---

## 摘要

项目名称
Big Eye 大眼睛

当前新建科室非常繁琐，且宣教文章、工具无法方便的共享。为了解决这一问题，决定做一个搜索引擎，做优护家全局索引。

实现以下功能：
1. 当新建科室时，快速从已有知识库中通过**标签**筛选出与该标签相关联的文章、评估、自评等，迅速、自主的完成「自建科室」；
2. 有其他搜索需求，通过尽可能少的开发量，快速支持新类型的搜索。

## 需求分析
### 是什么？
Big Eye 主要提供一个强大的搜索功能，从已有的知识库中快速检索出文章、评估、自评等等，同时进行相应的排序。
### 怎么做？
搜索主要分为两个阶段。

- 第一，对已知内容的索引；
    1. MySQL 中的结构化的数据由 ODPS 做数据收集；
    2. 并将 ODPS 中的数据做关键属性的索引（倒排索引）；
    3. 将索引存入 Redis 中。
- 第二，查询索引
    1. 查询条件 `string` 输入 `Front Door`；
    2. 将搜索条件从 `string` 转化为「结构化」的查询数据；
    3. 在 `Front Door` 中将结构化的条件作更进一步的细分，并转发给相应的 `Search Engine`；
    4. `Search Engine` 将在 `Index` 查询的结果返回；
    5. `Front Door` 调用 `Ranker` 将数据做排序并返回。

<!-- more -->
<img src="http://static.wayknew.com/assets/2017-03-09/d859edad-c9f5-4d3f-b44a-058b80abf6fc.png" width="800">

### 文档更新
时间|内容|维护人
---|---|---
2017-3-20|创建文档|田学文
2017-3-27|更新文档|袁鑫

## 搜索模块
![搜索流程图](/media/searcher.png)

**搜索流程**

当 Front Door 将一个 Query String 转化为结构化的查询对象后，其中的原子Query 即为一个 Tag的 TagId。如何通过 TagID 查询到具体的 ArticleList ，需要执行一下流程：

1. 在 Redis 中根据TagID 查询 `get('T:5')` 得到该 TagID 的Tag树路径`'T:1:2:5'`

2. 通过Redis 获取`'T:1:2:5*` 的相关所有TagPath 如下：
- 'T:1:2:5'
- 'T:1:2:5:9'
- 'T:1:2:5:15'

3. 把一个Tag中所有TagPath，依次在 Redis 中查询 `get('T:1:2:5')` 得到该 TagID 对应TagPath的所有articleIds

4. 对 `aids` 中的值，即 `Article.id` 再次请求 `get('A:<articleId>')` 获取到宣教内容。数据格式，即为`宣教文章`格式。

5. 得到各tagID找出来的结果`tagResult`，然后通过各tagID的Operation，把`tagResult` merge成整个Query的`SearchResult`

### Ranker

针对查询的参数，对返回结果进行排序。项目第一期只做简单排序。

排序规则：TODO

## 数据模型

![数据流图](/media/bigeye-dfd.png)

### 搜索条件（Query）

可以是页面之间请求的 URL，搜索内容以参数的形式嵌入 URL 中。

> POST /api/bigeye/v1/search

**Request**
```JSON
{
  "pre": {
    "pre": "2",
    "op": "0",
    "post": "5"
  },
  "op": "1",
  "post": {
    "pre": "6",
    "op": "0",
    "post": "1"
  }
}
```

**OP操作符**
```
enum Operation {
  Intersect = 0;
  Union = 1;
  Except = 2;
}
```

### Redis 索引结构（存储结构）
**1. tagID**
存储的Key为T开头的Tag树完整路径，以TagID为标识，以“:”为每个TagID间分隔符
```
"TID:7"
    => "T:1:5:7"
"TID:15"
    => "T:1:5:15"
```

**2. tagPath**
存储的Key为T开头的Tag树完整路径，以TagID为标识，以“:”为每个TagID间分隔符
```
"T:1:5:7:10"
    => {"aids": [1, 2, 3, 4, 5, 6]}
"T:1:5:15:22"
    => {"aids": [1, 2, 4, 7, 9, 16]}
```

**3. article**
存储的Key为A+“:”+articleId的结构，与`宣教模型`一致即可

```
"A:1"
    => {"articleId": 1, "articleName": "name 1", "foo": "bar"},
"A:2"
    => {"articleId": 2, "articleName": "name 2", "foo": "bar"},
```

#### 注意
1. tagPath,"T:1:2"需要把所有找出如下所有tagPath下的内容

- 'T:1:2'
- 'T:1:2:3'
- 'T:1:2:4'
- 'T:1:2:5'

```Python
# 1. Get all tagPath by tagID
redis.keys("T:1:2*") = ["T:1:2","T:1:2:3","T:1:2:4","T:1:2:5"]
```

2. 文章只能关联到 tag 树的叶子节点。
```Python
# 1. Get articleIds by tagPath
redis.get("T:1:2:3") = {"aids": [1, 2, 3]}

# 2. Get article content via `articleId`
redis.get("A:1") = {"articleId": 1, "content": "xxx"}
redis.get("A:2") = {"articleId": 2, "content": "xxx"}
redis.get("A:3") = {"articleId": 3, "content": "xxx"}

# Ranker
```


### 结果实体
搜索模块根据搜索的内容实体 (Entity) 有：
- 宣教文章


**宣教文章**
```JSON
{
  "articleId": 1,
  "title": "颅内",
  "article": [
    {
      "articleId": 1,
      "name": "颅内高压 后期如何恢复？优护家专家专题解说",
      "brief": "颅内高压康复，如何吃很重要",
      "author": "优护家刘专家",
      "content": "<p>请在这里编辑内容，꧁簡҉ ҉單҉ ҉點꧂</p>",
      ...
    }
  ]
}
```


## 类模型

```
com.youhujia.bigeye
  |- search
    |- SearchBO
    |- SearchController
    |- SearchFactory
  |- searcher
    |- impl
      |- ArticleSearcher
      |- ToolSearcher
    |- AbstractSearcher
    |- BaseSearcher
    |- SearchContext
    |- SearchEntry
    |- SearchResult
    |- SearcherConfig
```

```JAVA
BigEye.Query query = frontDoorBO.parseQuery(queryString);

// SearchContext.java
class SearchContext {
  private String tagName;
  private String title;
}

// BaseSearch.java
interface BaseSearch {
  void search(searchContext);
}

// AbstractSearch.java
public abstract class AbstractSearch implement BaseSearch {
  abstract List doSearch(SearchContext context);
}

// ArticleSearcher.java
public class ArticleSearcher extend AbstractSearch {

  @Override
  public List<BigEye.Article> doSearch(SearchContext context) {
    // Do search in redis
    List<Long> aids = jedis.get(context.getTagName());
    List<BigEye.Article> articles = aids.stream().map(id-> jedis.get(id));
    return articles;
  }

}

public class SearchEntry {
    private static List<AbstractSearcher> searcherList = new ArrayList<>();

    public static SearchResult doSearch(SearchContext context) {
        SearchResult result = new SearchResult();
        searcherList.forEach(searcher -> result.addResult(searcher.doSearch(context), searcher.getClass()));
        return doRanker(result);
    }

    private static SearchResult doRanker(SearchResult searchResult) {
        List<BigEye.Article> articles = searchResult.getMap().get(ArticleSearcher.class.getName());
        List<BigEye.Tool> tools = searchResult.getMap().get(ToolSearcher.class.getName());
        searchResult.setArticles(articles);
        searchResult.setTools(tools);
        return searchResult;
    }

    @PostConstruct
    public void init() {
        searcherConfig.getSearcherNames().forEach(searcherName -> register(getSearcherByString(searcherName)));
    }

    private void register(AbstractSearcher searcher) { searcherList.add(searcher); }
}

public class SearchResult{
  public void addResult(List list, Class clazz) {map.put(clazz.getName(), list); }
}


```
