# Linux进程的Uninterruptible sleep（D）状态

 2020-02-11阅读 8260

**Linux系统进程状态**

PROCESS STATE CODES

Here are the different values that the s, stat and state output specifiers (header "STAT" or "S") will display to describe the state of a process.

D   Uninterruptible sleep (usually IO)

R   Running or runnable (on run queue)

S   Interruptible sleep (waiting for an event to complete)

T   Stopped, either by a job control signal or because it is being traced.

W  paging (not valid since the 2.6.xx kernel)

X   dead (should never be seen)

Z   Defunct ("zombie") process, terminated but not reaped by its parent.

  Linux 进程有两种睡眠状态，一种interruptible sleep，处在这种睡眠状态的进程是可以通过给它发信号来唤醒的，比如发 HUP 信号给 nginx 的 master 进程可以让 nginx 重新加载配置文件而不需要重新启动 nginx 进程；另外一种睡眠状态是 uninterruptible sleep，处在这种状态的进程不接受外来的任何信号，无论是kill，kill -9，还是kill -15，因为他们完全不受到这些信号的支配。

  ps 手册里描述的D 状态就是 uninterruptible sleep，可以使用ps命令查看：

[build@kbuild-john ~]$ ps -a -ubuild -o pid,ppid,stat,command

 PID  PPID STAT COMMAND 17009   1  Ds    -bash

17065   1  D     ls --color=tty -al

17577   1  D     /usr/java/jdk1.5.0_17/bin/java -Xmx512m -classpath /usr/local/a

17629   1  D     /usr/java/jdk1.5.0_17/bin/java -Xmx512m -classpath /usr/local/a

**Unintelligible(D) VS intelligible(S)**

运行：该进程此刻正在执行。

等待：进程能够运行，但没有得到许可，因为CPU分配给另一个进程。调度器可以在下一次任务切换时选择该进程。

睡眠：进程正在睡眠无法运行，因为它在等待一个外部事件。调度器无法在下一次任务切换时选择该进程。

Linux进程的睡眠状态有2种：

  一种是可中断睡眠，其标志位是TASK_INTERRUPTIBLE ，可中断的睡眠状态的进程会睡眠直到某个条件变为真，比如说产生一个硬件中断、释放进程正在等待的系统资源或是传递一个信号都可以是唤醒进程的条件。比如你ctrl+c或者kill -9 ，能够立刻让进程响应这些信号（切换到TASK_RUNNING和再次进入就绪队列，执行注册的信号处理函数），不必要等待所需的资源满足后再响应这些信号。   一种睡眠是不可中断睡眠，其标志位是TASK_UNINTERRUPTIBLE ，把信号传递到这种睡眠状态的进程不能改变它的状态，也就是除非等待的资源得到满足，否则就是怎么kill，这个进程也不会变成TASK_RUNNING和进入就绪队列的。怎么都杀不死的。

**TASK_UNINTERRUPTIBLE的意义**

  TASK_UNINTERRUPTIBLE存在的意义就在于，内核的某些处理流程是不能被打断的。如果响应异步信号，程序的执行流程中就会被插入一段用于处理异步信号的流程（这个插入的流程可能只存在于内核态，也可能延伸到用户态），于是原有的流程就被中断了。在对某些硬件进行操作时（比如进程调用read系统调用对某个设备文件进行读操作，而read系统调用最终执行到对应设备驱动的代码，并与对应的物理设备进行交互），可能需要TASK_UNINTERRUPTIBLE状态对进程进行保护，以避免进程与设备交互的过程被打断，造成设备陷入不可控的状态。

  通常情况下TASK_UNINTERRUPTIBLE状态是非常短暂的，通过ps命令基本上不可能捕捉到。进程又是为什么会被置于 uninterruptible sleep 状态呢？处于 uninterruptible sleep 状态的进程通常是在等待 IO，比如磁盘 IO，网络 IO，其他外设 IO，如果进程正在等待的 IO 在较长的时间内都没有响应，很有可能有 IO 出了问题，可能是外设本身出了故障，也可能是比如挂载的远程文件系统NFS等已经不可访问了，那么就很会不幸地被 ps 看到进程状态位已经变成D。

  正是因为得不到 IO 的相应，进程才进入了 uninterruptible sleep 状态，所以要想使进程从 uninterruptible sleep 状态恢复，就得使进程等待的 IO 恢复，比如如果是因为从远程挂载的 NFS 卷不可访问导致进程进入 D状态的，那么可以通过恢复该 NFS 卷的连接来使进程的 IO 请求得到满足，除此之外，要想干掉处在 D 状态进程就只能重启整个 Linux 系统了。如果为了想要杀掉 D 状态的进程，而去杀掉它的父进程（通常是shell，在shell下允许某进程，然后某进程转入D状态），就会出现这样的状态：他们的父进程被杀掉了，但是他们的父进程 PID 都变成了1，也就是 init 进程，D状态的进程会变成僵尸进程。

**Unintelligible sleep几种场景**

1.NFS服务器发生故障或者关闭了，而客户端还没umount，此时运行某个如df的操作；

（此类问题可以考虑使用intr或者soft mount参数挂载）

2.如果问题出现在scsi或者类似的本地硬件驱动程序，很有可能是Bug。

3.其他类似的IO问题；

在vmstat命令中表示不可中断睡眠的简写不同于ps  

  Procs

​     r: The number of processes waiting for run time.

​     b: The number of processes in uninterruptible sleep.

本文参与[腾讯云自媒体分享计划](https://cloud.tencent.com/developer/support-plan)，欢迎正在阅读的你也加入，一起分享。

https://cloud.tencent.com/developer/article/1581022