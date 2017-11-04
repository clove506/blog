---
title: java-interview
date: 2017-8-3 22:30:30
categories: JVM
---

1. Java线程的状态

java线程总共有6个状态。

-	New。一个线程刚刚被创建出来，还未进入开始运行的状态，即还未调用start方法。
- 	Runnable。当线程调用start方法时，线程处于就绪状态，当获取到cpu时间片时，线程进入运行状态。
- 	Blocked。当可运行状态获取锁（系统资源）失败，即锁被其他线程占用时，该线程为被阻塞状态。
- 	Waiting。当前线程调用 wait、join、park 方法时，就会进入等待状态，当前线程会失去CPU的使用权。
- 	Timed-Waiting。超时等待，当前线程调用 sleep 方法时，该线程进超时等待，到了超时时间后，该线程变为 Runnable 状态。
- 	Dead。线程执行完 run 方法正常退出或发生未捕获异常终止 run 方法运行。

![线程状态机](http://upload-images.jianshu.io/upload_images/44770-698ba70a7a713f44.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

2. 进程和线程的区别，进程间如何通讯，线程间如何通讯

- 	进程：是操作系统的资源调度实体，有自己运行的内存空间和运行环境，等同于应用软件或程序，进程通信依赖于管道、信号量、套接字、共享内存、消息队列等。

- 线程：进程中程序执行实体，一个进程由许多线程组成，可线程可以并发执行任务，因此线程是轻量级进程。线程之间的通信依赖 JVM 提供的 wait、notify、notifyAll API 来进行通信。


3. HashMap的数据结构是什么？如何实现的。和HashTable，ConcurrentHashMap的区别

-	HashMap 是由一个 Node<K,V> 的数组容器、K是当前 Key 根据 hashcode 方法计算得出的索引值，V是当前 Key 代表的 value 值，当出现不同 key 值得出的索引值是一致时，将用链表进行存储，即在索引构建一个 bucket（桶），由链表实现，当 bucket 的数据量超过 TREEIFY_THRESHOLD 值时，链表结构将变成红黑树的结构。 

- HashMap 线程不安全，而 HashTable 内部是由同步方法来实现的，因此，它是线程安全的，但是效率较低，ConcurrentHashMap 是线程安全，不过 HashTable 每次操作时，会锁住所有整个结构，只有一个线程能访问 Map ，而 ConcurrentHashMap 只会锁住某个节点，只有在涉及到 size 的操作时才会锁整个表结构。


4. Cookie和Session的区别

-  Cookie存储于客户端，Session存储于服务端。
-  Cookie 和 Session 都是用户会话跟踪的手段，但由于Cookie不安全，很有可能会被客户端禁掉。
-  session 的实现依赖cookie，seesion 的 sessionId 保存在 cookie 中。

5. 索引有什么用？如何建索引？

todo

6. ArrayList是如何实现的，ArrayList和LinkedList的区别？ArrayList如何实现扩容。

ArrayList 是基于可变数组实现的，它实现了 List 接口，与 Vector 的区别是 ArrayList 是线程不安全的，而 Vector 是线程安全的。

LinkedList 是基于双向链表实现的，它实现了 Dqueue 接口，因此在增加、删除、修改时效率高于 ArrayList ，查询某个元素时，ArrayList 效率高于 LinkedList 。

在java8中，ArrayList的size默认为10，当实际长度大于 ArrayList 的 size 时，默认扩充为原来的 2 倍，当 newCapacity 比 minCapacity 小时，则 size 变为 minCapacity，当 newCapacity 比 maxCapacity 大时，size 变为 MAX_VALUE。
	
7. equals方法实现

-	重写 equals 方法必须重写 hashcode 方法。

-	编写equals方法后，检查是否符合：对称性、传递性、一致性、自反性和非空性

8. 面向对象

9. 线程状态，BLOCKED和WAITING有什么区别

BLOCKED 状态是指当前线程在等待 monitor 对象锁，一旦其他线程释放 monitor 对象锁，JVM 会让处于 BLOCKED 状态的线程去竞争 monitor 对象锁，而 WAITING 状态的线程是指当前线程在等待其他线程发送唤醒通知，才能进行执行下去。两者最重要的区别在于由谁唤醒线程。






