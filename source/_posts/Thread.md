---
title: thread-interview
date: 2017-7-20 22:30:30
categories: thread
---

1)现在有T1、T2、T3三个线程，你怎样保证T2在T1执行完后执行，T3在T2执行完后执行？

可以利用Thread提供join方法，即在T2.start()语句后在T1.调用T2.join()。

2)在Java中Lock接口比synchronized块的优势是什么？你需要实现一个高效的缓存，它允许多个用户读，但只允许一个用户写，以此来保持它的完整性，你会怎样去实现它？

Lock接口比synchronized关键字更加强大、灵活。它是基于Lock接口和实现它的类（如ReentrantLock）。这种机制有如下优势：

* 它允许以一种更灵活的方式来构建synchronized块。使用synchronized关键字，你必须以结构化方式得到释放synchronized代码块的控制权。Lock接口允许你获得更复杂的结构来实现你的临界区。
* Lock 接口比synchronized关键字提供更多额外的功能。新功能之一是实现的tryLock()方法。这种方法试图获取锁的控制权并且如果它不能获取该锁，是因为其他线程在使用这个锁，它将返回这个锁。使用synchronized关键字，当线程A试图执行synchronized代码块，如果线程B正在执行它，那么线程A将阻塞直到线程B执行完synchronized代码块。使用锁，你可以执行tryLock()方法，这个方法返回一个 Boolean值表示，是否有其他线程正在运行这个锁所保护的代码。
* 当有多个读者和一个写者时，Lock接口允许读写操作分离。
* Lock接口比synchronized关键字提供更好的性能。

两者区别：

1. synchronized是java中的关键字，是内置的语言实现，而Lock是一个接口；
2. synchronized在发生异常时，会自动释放线程占有的锁，因此不会发生死锁，而lock在发生异常时，如果没有主动通过unLock()去释放锁，则很可能造成死锁现象，因此使用Lock时需要在finally块中释放锁；
3. lock可以让等待的线程响应中断，synchronized不行，等待的线程会一直等待下去，不能够响应中断；
4. 通过lock方法可以知道是否获取到锁，而synchronized未知；
5. lock可以提高多个线程读操作的效率

3) Thread的wait、sleep、yield、join异同？

wait：会阻塞当前线程，同时会失去对monitor对象的所有权，需要超时唤醒或被notify/notifyAll，但是需要获取monitor对象的所有权，线程才会执行。因此wait只能出现同步代码块中

sleep：通过sleep方法实现的暂停，程序是顺序进入同步块的，只有当上一个线程执行完成的时候，下一个线程才能进入同步方法，sleep暂停期间一直持有monitor对象锁，其他线程是不能进入的。而wait方法则不同，当调用wait方法后，当前线程会释放持有的monitor对象锁，因此，其他线程还可以进入到同步方法，线程被唤醒后，需要竞争锁，获取到锁之后再继续执行。

- 原子性：
即一个操作或者多个操作 要么全部执行并且执行的过程不会被任何因素打断，要么就都不执行。
- 可见性：
指当多个线程访问同一个变量时，一个线程修改了这个变量的值，其他线程能够立即看得到修改的值。
- 有序性：
即程序执行的顺序按照代码的先后顺序执行。


4) Thread 类中的start() 和 run() 方法有什么区别？

  start方法被用来启动创建的线程，是真正实现了多线程，而且start内部调用了run方法，而run方法是在原来的线程中执行，并未新的线程启动。

5) Java中Runnable和Callable有什么不同？

Callable中的call方法较Runnable中的run方法可以返回值和抛出异常，同时，Callable能返回装载计算结果的Future对象。

6) Java中CyclicBarrier 和 CountDownLatch有什么不同？

CyclicBarrier 和 CountDownLatch 都可以用来让一组线程等待其它线程。与 CyclicBarrier 不同的是，CountdownLatch 不能重新使用。点此查看更多信息和示例代码。

### 参考文档

（1）http://ifeve.com/java%E9%9D%A2%E8%AF%95%E9%A2%98-%E5%9F%BA%E7%A1%80%E7%9F%A5%E8%AF%86/
（2）http://www.importnew.com/12773.html

