---
title: 【合肥项目—Dagon—Item】项目总结。
date: 2017-1-15 16:16:16
categories: 项目管理
tags:
- 项目总结
---


## 摘要

合肥项目—Dagon—Item 项目总结。

<!--more-->

## WIKI维护人
clove
## 说在前面

 对于一个菜鸟来说，首次独自开发一个子系统，用于商业用途，虚归虚，但值得庆幸的是终究还是做完了，其中滋味，恐怕也就只有自己最清楚。好啦，不想煽情，回归正题。

## 项目回顾

### 整体节奏
整个项目的时间原计划如下：

## 时间排期
内容 | 详情 | 人日
--- | --- | --- | ---
项目准备 |1. github repo <br> 2. config-repo 配置 | 1 
Dagon 接口定义 | 1. Item 接口|1
|2. Service Item 接口|1
|3. Item Prop 接口|1
|4. Service Item Template 接口 | 1
Dagon 实现 | 1. Item CRUD 实现|1
|2. Service Item CRUD 实现 |1
|3. Item Prop CRUD 实现|1
|4. Service Item Template CRUD 实现 | 5

实际的测试结束待上线时间12月22号晚（开发环境）。

整个项目的需求，详细设计文档详见wiki：
      
[商品服务API](http://wiki.office.test.youhujia.com/2017/01/06/HeFei-Item-Design/)

## 问题总结
### 技术方案设计和Review不到位
开发前期整体的API接口设计不合理，特别是ServiceItem接口设计思路出现问题，有两个直接影响：

1. 在开发进度接近50%时，接口和项目结构大改，原有的开发被推翻了，导致项目重新洗牌，从零开始。
2. 在开发后期，处理ServiceItem接口过程中，根据属性值叉乘生成ServiceItem，相当吃力。

问题的关键是，二期开发Item，这会是个必趟的坑，我总结有以下原因：

1. Item的数据模型不合理
    如果只是单纯按照属性值来叉乘生成Service，那应该在属性值表中加入ItemId字段，防止生成ServiceItem的时候还需要去查询数据库得到ItemId，当遇到再添加新的属性和属性值得时候，就可以根据ItemId查询己胆小，还是自己没有主见，都说明了我还不具备独立解决问题的能力，在很大程度上依靠别人，无法形成自得到已有的属性值，相比没有ItemId的情况下，有ItemId更直接。
    
2. 自己能力不够，信心不足
    如果能在开发Item属性值的初期，提出Item模型的缺陷，也许就没有后面那么多麻烦事了。这里，先自我反思，不管是自己胆小，还是自己没有主见，都说明了我还不具备独立解决问题的能力，在很大程度上依靠别人，无法形成自己的一套思维逻辑。期待2017能有所突破~
    
    PS：后端开发团队相当和谐，所谓将熊熊一窝，晨哥的干练严谨作风，将会是影响我以后职业生涯的重要因素。作为实习生，心有余而力不足，有些时候还给晨哥添乱，有点愧疚，不免感慨，遇上他是我的福气~

      
## 技术分享
 虽说是第一次单独开发一个子系统，但其中还是有很多值得分享和总结的地方。

### 亮点 属性值叉乘生成新的ServiceItem记录
当增加属性和属性值时，分为两种情况：

1. 新增属性，同时新增属性值。在这种情况下，又可以分为两种情况，第一次新增属性和属性值，非第一次新增属性和属性值。第一次新增属性和属性值相对来说比较简单，新增数据合法之后即可插入数据库。当非第一次新增属性和属性值时，需要将之前所有的属性值取出来并叉乘此次新增的属性值，生成新的ServiceItem记录。而这次最关键的操作是如何获取已有不同属性值的组合。我的解决思路如下：    
    
``` 
    private ServiceItemContext buildServiceItemName2SaveContext(Item item, ItemPropValue itemPropValue) {

        ServiceItemContext serviceItemContext = new ServiceItemContext();

        List<Long> itemPropIdsWithOutAddItemProp = itemPropDAO.findByItemId(item.getId()).stream()
            .filter(itemProp -> itemProp.getId().longValue() != itemPropValue.getItemPropId().longValue())
            .map(itemProp -> itemProp.getId()).collect(Collectors.toList());

        Map<Long, List<ItemPropValue>> itemPropValueIdItemPropValueWithOutAddItemProp = itemPropIdsWithOutAddItemProp.stream()
            .flatMap(itemPropId -> itemPropValueDAO.findByItemPropId(itemPropId).stream())
            .collect(Collectors.groupingBy(ItemPropValue::getItemPropId));
        Map<Long, List<ItemPropValue>> itemPropValueIdItemPropValueWithOutAddItemPropResult = new HashMap<>();

        itemPropValueIdItemPropValueWithOutAddItemProp.entrySet().stream().sorted(Map.Entry.<Long, List<ItemPropValue>>comparingByKey())
            .forEachOrdered(x -> itemPropValueIdItemPropValueWithOutAddItemPropResult.put(x.getKey(), x.getValue()));

        int position = 0;
        for (Long id : itemPropValueIdItemPropValueWithOutAddItemPropResult.keySet()) {
            if (itemPropValue.getItemPropId() > id) {
                position++;
            }
        }
        /**
         * From YuanXin
         */
        List<String> serviceItemNameStrs = new ArrayList<>();
        serviceItemNameStrs.add("");

        itemPropValueIdItemPropValueWithOutAddItemProp.forEach((k, v) -> {
            int preSize = serviceItemNameStrs.size();

            v.forEach(itemPV -> {
                for (int i = 0; i < preSize; i++) {
                    serviceItemNameStrs.add(serviceItemNameStrs.get(i) + itemPV.getValue() + "-");
                }
            });
            for (int i = 0; i < preSize; i++) {
                serviceItemNameStrs.remove(0);
            }
        });
        /**
         * Thanks YuanXin
         */
        serviceItemContext.setServiceItemNameStrs(serviceItemNameStrs);
        serviceItemContext.setPropIdPosition(position);

        return serviceItemContext;
    }
```

这段代码用到了java8的新特性之一--lambda表达式。第一个lambda表达式，将除新增属性值所属属性id之外的所有属性id遍历出来，并将其放入一个List中；第二个lambda表达式根据第一个表达式的List集合获取每个属性下所有属性值，并将每个查询结果映射成一个map集合，key是属性id，value是属性下所有属性值；为避免每次查询的List结果顺序不一致，因此第三个lambda表达式用来对第二个lambda表达式的结果Map集合的value结果集进行排序。到此，已经获取到了有序的除去新增属性之外其他属性的属性值，接下来，就是将这个结果和新增的属性值进行叉乘，生成新的ServiceItem。但是关键的叉乘问题来了，首先并不知道有取出的集合中有几个属性，属性下有几个属性值，所以无法拿到每个属性值进行叉乘。我在做这块的时候，这个问题困扰我整整一个下午，后来找袁鑫同学沟通，他后来想了一个绝妙的算法，完美解决了这个死锁问题，也就是最后9行代码，整个Item系统中最有分量的代码。在这里对袁鑫同学说句感谢！他给出的解是通过在有限的空间里，组装所有不同属性的属性值。具体思路是这样的：

**① List<String> serviceItemNameStrs = new ArrayList<>();**
这一步是创建一个有限的空间，用来存储遍历完成的属性值和不同属性值的组装结果；
**② serviceItemNameStrs.add("");**
这一步是初始化空间大小，用来保存第一次遍历的属性值；
**③ itemPropValueIdItemPropValueWithOutAddItemProp.forEach((k, v) -> {};**
这一步是遍历每个属性；
**④ int preSize = serviceItemNameStrs.size();**
获取空间大小；
**⑤ v.forEach(itemPV -> {}**
遍历每个属性下的所有属性值
**⑥ for (int i = 0; i < preSize; i++){
    serviceItemNameStrs.add(serviceItemNameStrs.get(i) +itemPV.getValue() + "-");
}**
这一步是将每个属性下的属性值保存到空间中；

**⑦ for (int i = 0; i < preSize; i++) {
        serviceItemNameStrs.remove(0);
    }**
    
这一步是这7步中最精妙的地方，在每次遍历完一组属性之后，完产生上次遍历属性值所产生的中间值，需要将这些值删除掉。
现举个例子推演一下整个过程，某个Item已有属性性别，属性值是男和女，属性级别，属性值是普通和高级，新增属性周期，属性值是5天和7天。在叉乘属性值的时候，需要取出男女属性值，普通高级属性值，和新添的属性值组合。
第一次运行③时，此时的value是（男，女），④的结果是1，⑤首次遍历的是男，男和“-”进行组合，置于List中，第二次遍历是女，女和“-”进行组合，同样置于List中，此时性别属性遍历完成，List中有三个元素，分别是“”，“男-”，“女-”，而“”是多余，需要删除，因此⑦删除“”；
第二次运行③，此时的value是（普通，高级），④的结果是2，⑤首次遍历的是普通，普通和“男-”进行组合，置于List中，第二次遍历是，普通和“女-”进行组合，同样置于List中，此时普通属性值遍历完成，高级属性值组合过程同上，⑥步完成之后，List中有三个元素，分别是“男-”，“女-”，“男-普通”，“女-普通”，“男-高级”，“女-高级”，而“男-”，“女-”是多余的，需要删除，因此⑦删除“男-”，“女-”；
.......
1. 新增已有属性的属性值。 
过程同增加新属性新属性值。
 
## 关于理想程序员

当面对一个未知的问题时，如何定位复杂条件下的核心问题、如何抽丝剥茧地分析问题的潜在原因、如何排除干扰还原一个最小的可验证场景、如何抓住关键数据验证自己的猜测与实验，是体现程序员思考力的最好场景。然而自己却无法快速定位问题所在，准确无误解决问题，距离一个理想程序员还差得很远。
或许，每次我去找晨哥，学文，问他们「遇到一个问题被卡住了，怎么办」的时候，我总觉得自己其实可以做得更好。比如，可以检查试验别的任务，以排除代码自身的原因；可以通过Web UI检查异常；可以排查主机日志缓存，再不济，总应该提供控制台日志给他们，而不应该傻乎乎地跑去问他们，自己一脸懵逼，他们也一头雾水。
该来句口号了，不然会觉得少了点什么，**理想的程序员永远不会等事情前进，他们会用尽一切方法让事情前进。**
与君共勉！

