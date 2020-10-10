![Linux Load Averages：什么是平均负载？](https://pic4.zhimg.com/v2-87611bce430c49957664dbf016534c71_1440w.jpg?source=172ae18b)

# Linux Load Averages：什么是平均负载？

[![三毛不是三毛](https://pic4.zhimg.com/v2-22695bc7810df875003a8ee14459d88d_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/violet-guo-42)

[三毛不是三毛](https://www.zhihu.com/people/violet-guo-42)

随着云计算的不断发展，很多场景使用 Linux load averages 作为参考指标之一来指导 VPA 和 HPA，进而调整容器的数量和容器拥有的资源数，但是 Load  averages 这个指标究竟意味着什么依旧困扰着很多小伙伴（包括我），这篇文章很好的揭示了 Load Averages 的含义。 

这篇文章原文为 **Linux Load Averages: Solving the Mystery**，是 Brendan Gregg 在 2017 年的一篇博客。作者为了理清楚 load average 到底意味着什么，不断地追根溯源，甚至追溯到了 20 多年前的 Linux 提交记录，从技术和历史两个角度来揭开 Linux Load Averages  神秘的面纱，建议英语不错的小伙伴可以读一下原文。 

文章传送门：[http://www.brendangregg.com/blog/2017-08-08/linux-load-averages.html](https://link.zhihu.com/?target=http%3A//www.brendangregg.com/blog/2017-08-08/linux-load-averages.html) 

译文如下： 

------

Load averages 在工业界中是一个很关键的指标，我的公司就根据 Load average 和其他指标来对百万个 cloud instance  进行自动扩缩容，但是该指标在 Linux 究竟代表了什么含义依旧很困惑。Linux load averages 不仅可以用于追踪  runnable 任务，还可以跟踪不间断睡眠状态下的任务（uninterruptible sleep  state）。但是为什么呢？我也从来没有找到过相关解释，在这篇文章中，我将揭开这个谜团，并为每个希望能深入理解 load average  的小伙伴做一个详细的总结。 

Linux load averages 是系统负载平均值（system load  averages），它将正在运行的线程（任务）对系统的需求显示为平均运行数和等待线程数。Linux load averages  可以衡量任务对系统的需求，并且它可能大于系统当前正在处理的数量，大多数工具将其显示为三个平均值，分别为 1、5 和 15 分钟值。

以下为系统中显示 Linux load averages 的实例：

```bash
# 方法一：uptime
$ uptime
 16:48:24 up  4:11,  1 user,  load average: 25.25, 23.40, 23.46

# 方法二：top
top - 16:48:42 up  4:12,  1 user,  load average: 25.25, 23.14, 23.37

# 方法三：cat /proc/loadavg
$ cat /proc/loadavg 
25.72 23.19 23.35 42/3411 43603
```

一些解释： 

- 如果平均值为 0.0，意味着系统处于空闲状态 
- 如果 1min 平均值高于 5min 或 15min 平均值，则负载正在增加 
- 如果 1min 平均值低于 5min 或 15min 平均值，则负载正在减少 
- 如果它们高于系统 CPU 的数量，那么系统很可能会遇到性能问题（视情况而定） 



1min、5min、15min  作为一个三元组，可以通过这三个值来判断系统中负载是正在增加还是减少。同时，它们也可以应用于其他的场景，例如作为云计算中实例自动扩缩容的规则。但是，如果没有其他指标的帮助是很难理解 load averages 到底意味着什么。例如，单个值 23-25 本身并不意味着什么，但是如果已知系统 CPU 的数量，并且知道它是一个  CPU-bound 的负载，则可能知道它意味着什么。 

我通常会使用其他的指标来进行 debug，而不是使用 load averages。我将在下面的 “更好的指标” 部分讨论在 debug 时使用哪些指标比较好。 

## 历史

原始的 load averages 仅显示 CPU 需求：运行的进程数 + 等待运行的进程数。在 1973 年 8 月的 [RFC 546](https://link.zhihu.com/?target=https%3A//tools.ietf.org/html/rfc546) 中对 Load average 有一个很好的描述，题目为“TENEX Load Average”， 

> [1] The TENEX load average is a measure of CPU demand. The load average is  an average of the number of runnable processes over a given time period. For example, an hourly load average of 10 would mean that (for a single CPU system) at any time during that hour one could expect to see 1  process running and 9 others ready to run (i.e., not blocked for I/O)  waiting for the CPU.



在 [ietf.org](https://link.zhihu.com/?target=http%3A//ietf.org/) 上的这个版本链接到 1973 年 7 月手绘负载平均图的 PDF 扫描版，显示这个指标已经被监控了几十年。 

![img](https://pic3.zhimg.com/80/v2-2be21b5ecaa1273027d8fd6cb41a53b2_720w.jpg)source: https://tools.ietf.org/html/rfc546

在现在，旧操作系统的源代码也可以找到，这是 [TENEX](https://link.zhihu.com/?target=https%3A//github.com/PDP-10/tenex)（1970 年代更早期）的 SCHED.MAC 中：

```text
NRJAVS==3               ;NUMBER OF LOAD AVERAGES WE MAINTAIN
GS RJAV,NRJAVS          ;EXPONENTIAL AVERAGES OF NUMBER OF ACTIVE PROCESSES
[...]
;UPDATE RUNNABLE JOB AVERAGES

DORJAV: MOVEI 2,^D5000
        MOVEM 2,RJATIM          ;SET TIME OF NEXT UPDATE
        MOVE 4,RJTSUM           ;CURRENT INTEGRAL OF NBPROC+NGPROC
        SUBM 4,RJAVS1           ;DIFFERENCE FROM LAST UPDATE
        EXCH 4,RJAVS1
        FSC 4,233               ;FLOAT IT
        FDVR 4,[5000.0]         ;AVERAGE OVER LAST 5000 MS
[...]
;TABLE OF EXP(-T/C) FOR T = 5 SEC.

EXPFF:  EXP 0.920043902 ;C = 1 MIN
        EXP 0.983471344 ;C = 5 MIN
        EXP 0.994459811 ;C = 15 MIN
```



这是现在 Linux 代码的摘录（[include/linux/sched /loadavg.h](https://link.zhihu.com/?target=https%3A//github.com/torvalds/linux/blob/master/include/linux/sched/loadavg.h)）： 

```c
#define EXP_1           1884            /* 1/exp(5sec/1min) as fixed-point */
#define EXP_5           2014            /* 1/exp(5sec/5min) */
#define EXP_15          2037            /* 1/exp(5sec/15min) */
```



Linux 也将 1min、5min、15min 直接写到代码中作为常量。 

在更老的系统中存在类似的 load average 指标，包括 [Multics](https://link.zhihu.com/?target=http%3A//web.mit.edu/Saltzer/www/publications/instrumentation.html)，其具有 exponential scheduling queue average。 



## 三个数字

这三个数字是 1min、5min 和 15min 的 load averages。除了他们不是真正的平均值外，他们也不是 1、5、10  分钟。从上面的资料中可以看到，1、5、15min 是在等式中使用到的常量，其计算了 5s 平均的 expoentially-damped  moving sums 。最终得到的 1min、5min、15min 的 load averages 反映了超过 1、5、15 分钟的负荷。 

如果你使用一个空闲的系统，然后运行一个单线程的 CPU-bound 的负载，60 秒后 1min load average 是多少？如果它是一个简单的平均值，它应该是 1.0。以下是这个实验： 

![img](https://pic1.zhimg.com/80/v2-661d32e4930087637c01abe4b78fcf88_720w.jpg)Load average experiment to visualize exponential damping

所谓的“一分钟平均值”仅在一分钟内达到了 ~0.62，有关等式和类似实验的更多信息，Neil Gunther 博士写了一篇关于 load average 的文章：[How It Works](https://link.zhihu.com/?target=https%3A//www.helpsystems.com/resources/guides/unix-load-average-part-1-how-it-works)，以及 [loadavg.c](https://link.zhihu.com/?target=https%3A//github.com/torvalds/linux/blob/master/kernel/sched/loadavg.c) 中有许多 Linux 源代码注释可供参考。 



## Linux 不间断任务

当 load averages 首次出现在 Linux 中时，就像其他操作系统一样，它们反映了 CPU 的需求。但后来在 Linux  上将它们改为不仅包括 runnable 任务，还包括处于不间断状态的任务（TASK_UNINTERRUPTIBLE 或  nr_uninterruptible）。希望避免信号中断的 code path 会使用该状态，其中包括磁盘 I/O  上阻塞的任务和一些锁。你可能之前已经看到过这种状态：它 *ps* 和 *top* 中显示为 “D” 状态。ps(1) 手册将其称为 “uninterruptible sleep (usually IO)”。 

在系统中增加不间断状态意味着 Linux load averages 可能会因为磁盘（或 NFS）I/O 负载而增加，而不仅仅是 CPU 需求，对于熟悉其他操作系统及其 CPU load averages 的每个人来说，包含这种状态起初都是令人困惑的。 

**为什么呢？**为什么 Linux 确实这样做了？ 

关于 load averages 的文章数不胜数，其中许多都指出 Linux nr_uninterruptible gotcha，但是我没有看到任何解释甚至猜测说明为什么包括它，我自己的猜测是，它意味着更普遍意义上的资源需求，而不仅仅是 CPU 需求。 



## 寻找古老的 Linux 补丁

想了解 Linux 中发生变化的原因很简单：可以阅读相关文件中的 git commit 历史记录和更改说明。我查找了 [loadavg.c](https://link.zhihu.com/?target=https%3A//github.com/torvalds/linux/commits/master/kernel/sched/loadavg.c)  的历史记录，但是增加不间断状态的更改早于该文件，该文件是使用早期文件中的代码创建的。我检查了另外一个文件，但是那条路也凉凉了。希望能找到比较快速的办法，我将整个 Linux github 仓库转存了 “git log -p”，一共 4G  的文本文件，并开始向后读取它以查看代码首次出现的时间，但是这也是一个死胡同。整个 Linux 仓库中最久远的变化可以追溯到 2005 年，当时  Linux 导入了 Linux 2.6.12-rc2，而我想要找的 change 是早于这个时间的。 

这里有一些有历史的 Linux 仓库（[here](https://link.zhihu.com/?target=https%3A//git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git) and [here](https://link.zhihu.com/?target=https%3A//kernel.googlesource.com/pub/scm/linux/kernel/git/nico/archive/)），但这些变化也缺少了对应的描述。我在 [kernel.org](https://link.zhihu.com/?target=http%3A//kernel.org/) 上搜索了压缩包，发现它已经被修改为 0.99.15，而不是 0.99.13，但是 0.99.14 的压缩包丢失了。我在其他的地方找到了它，并确认我想找的是在 1993 年 11 月的 Linux 0.99 patchlevel 14 中。我希望 [Linus 的 0.99.14 的 release description](https://link.zhihu.com/?target=http%3A//www.linuxmisc.com/30-linux-announce/4543def681c7f27b.htm) 可以解释这个变化，但是这也是个死胡同： 

> "Changes to the last official release (p13) are too numerous to mention (or even to remember)..." – Linus



他提到了重大变化，但是并没有提到 load average 变化。

根据日期，我查找了内核邮件列表存档以查找真正的补丁，但最早的电子邮件是从 1995 年 6 月开始的，当时 sysadmin 写到：

> "While working on a system to make these mailing archives scale more  effecitvely I accidently destroyed the current set of archives (ah  whoops)."



我开始感觉我的查找过程像被诅咒了一样，但值得庆幸的是，我从服务器备份中发现了一些较旧的 linux-devel 邮件列表档案，我搜索了超过 6000 个摘要，包含超过 98000 封电子邮件，其中 30000 封电子邮件来自  1993 年，但它们在某种程度上都缺失了信息。看起来好像原始的补丁说明可能永远丢失了，而 “为什么” 仍然是个谜团。 



## 不间断状态的起源

幸运的是，我终于在 [oldlinux.org](https://link.zhihu.com/?target=http%3A//oldlinux.org/) 上的 1993 年压缩邮件文件中找到了对应的更改： 

```text
From: Matthias Urlichs <urlichs@smurf.sub.org>
Subject: Load average broken ?
Date: Fri, 29 Oct 1993 11:37:23 +0200


The kernel only counts "runnable" processes when computing the load average.
I don't like that; the problem is that processes which are swapping or
waiting on "fast", i.e. noninterruptible, I/O, also consume resources.

It seems somewhat nonintuitive that the load average goes down when you
replace your fast swap disk with a slow swap disk...

Anyway, the following patch seems to make the load average much more
consistent WRT the subjective speed of the system. And, most important, the
load is still zero when nobody is doing anything. ;-)

--- kernel/sched.c.orig Fri Oct 29 10:31:11 1993
+++ kernel/sched.c  Fri Oct 29 10:32:51 1993
@@ -414,7 +414,9 @@
    unsigned long nr = 0;

    for(p = &LAST_TASK; p > &FIRST_TASK; --p)
-       if (*p && (*p)->state == TASK_RUNNING)
+       if (*p && ((*p)->state == TASK_RUNNING) ||
+                  (*p)->state == TASK_UNINTERRUPTIBLE) ||
+                  (*p)->state == TASK_SWAPPING))
            nr += FIXED_1;
    return nr;
 }
--
Matthias Urlichs        \ XLink-POP N|rnberg   | EMail: urlichs@smurf.sub.org
Schleiermacherstra_e 12  \  Unix+Linux+Mac     | Phone: ...please use email.
90491 N|rnberg (Germany)  \   Consulting+Networking+Programming+etc'ing      42
```



能阅读到 24 年前这一变化后面的想法真的是太神奇了。 

这证实了故意改变 load averages 以反映对其他系统资源的需求，而不仅仅针对于 CPU 资源。Linux 从 “CPU load averages” 变为 “system load averages”。 

他使用较慢的 swap disk 的例子是有道理的：通过降低系统的性能，对系统的需求量（测量为 running +  queued）应该是增加的。但是，load averages 下降是因为它们仅跟踪 CPU 运行状态而不是交换状态，Matthias  认为这不是直观的，所以修改了它。 



## 不间断状态的今天

但是，Linux load averages 有时不会太高，磁盘 I/O 可以解释吗？可以解释的，尽管我的猜测是由于使用  TASK_UNINTERRUPTIBLE 的新代码路径在 1993 年不存在。在 Linux 0.99.14 中，有 13 个代码路径直接设置  TASK_UNINTERRUPTIBLE 或 TASK_SWAPPING（交换状态后来从 Linux 中删除）。如今，在 Linux 4.12  中，有将近 400 个代码路径设置了 TASK_UNINTERRUPTIBLE，包括一些锁原语。有可能是这些代码路径中的某一个可能不应该考虑进  load averages 中，下次如果我系统的 load averages 看起来太高，我会看看是否是这种情况，以及是否可以修复。 

我通过电子邮件向 Matthias 询问了他对 24 年后 load averages 变化的看法，他在一个小时内回复了我，并写道： 

> "The point of "load average" is to arrive at a number relating how busy the  system is from a human point of view. TASK_UNINTERRUPTIBLE means  (meant?) that the process is waiting for something like a disk read  which contributes to system load. A heavily disk-bound system might be  extremely sluggish but only have a TASK_RUNNING average of 0.1, which  doesn't help anybody."



所以马蒂亚斯仍然认为这是有道理的，至少考虑到 TASK_UNINTERRUPTIBLE 的含义。

但是今天 TASK_UNITERRUPTIBLE 可以匹配更多东西。我们应该将 load averages 更改为 CPU 和磁盘的需求吗？调度器维护者 Peter Zijstra 发给了我一个聪明的选项来解释为什么： task_struct->in_iowait 是在 load  averages 中而不是 TASK_UNINTERRUPTIBLE 中，以便它更紧密的匹配磁盘 I/O。

然而这又引出了另一个问题，那就是我们真正想要的是什么呢？我们是想从线程角度来衡量系统需求吗？还是衡量对物理资源的需求呢？如果它是前者，那么应该包括等待 uninterruptible locks，因为这些线程是系统的需求，他们并没有闲着。因此，Linux load averages  已经按照我们希望的方式运行。

为了更好地理解 uninterruptible 的代码路径，我想要一种运行中衡量它们的方法。我们可以运行不同的例子，量化在它们中各个部分的时间开销，看看它是否都有意义。



## 测量不间断任务

以下是来自生产服务器的 [Off-CPU 火焰图](https://link.zhihu.com/?target=http%3A//www.brendangregg.com/blog/2016-01-20/ebpf-offcpu-flame-graph.html)，包含了 60s 中内核堆栈的情况，其中我过滤为仅包括处于 TASK_UNINTERRUPTIBLE 状态的，它提供了许多不间断代码路径的示例：

![img](https://pic4.zhimg.com/80/v2-92d2334eb4691b4bc240bd8a87e48a67_720w.jpg)

http://www.brendangregg.com/blog/images/2017/out.offcputime_unint02.svg

在 SVG 原图中可以看到各个部分的时间开销和占比，因为没办法上传 SVG 原图，原图链接如下：

[http://www.brendangregg.com/blog/images/2017/out.offcputime_unint02.svg](https://link.zhihu.com/?target=http%3A//www.brendangregg.com/blog/images/2017/out.offcputime_unint02.svg)



如果你不熟悉 off-CPU 火焰图，你可以单机其进行放大，查看完整堆栈。x 轴大小与 off-CPU 的时间成正比，排序顺序（从左到右）没有实际意义。对于 off-CPU 堆栈颜色为蓝色，饱和度具有随机差异以区分。

我使用 [bcc](https://link.zhihu.com/?target=https%3A//github.com/iovisor/bcc) 的 offcputime 工具生成了这个（这个工具需要 Linux 4.8+ 的 eBPF 功能）和我的[火焰图软件](https://link.zhihu.com/?target=https%3A//github.com/brendangregg/FlameGraph)。

```bash
# ./bcc/tools/offcputime.py -K --state 2 -f 60 > out.stacks
# awk '{ print $1, $2 / 1000 }' out.stacks | ./FlameGraph/flamegraph.pl --color=io --countname=ms > out.offcpu.svgb>
```



我使用 awk 将输出从微秒改为毫秒，其中 offcputime “—state 2” 匹配 TASK_UNINTERRUPTIBLE（参见 sched.h）。Fackbook 的 Josef Bacik 首先用他的 [kernelscope](https://link.zhihu.com/?target=https%3A//github.com/josefbacik/kernelscope) 工具做到了这一点，该工具也是用了 bcc 和火焰图，在我的示例中，我只是显示内核栈，但 offcputime.py 也支持显示用户栈。

至于上面的火焰图：它显示 60s 内只有 926ms 用于不间断睡眠（uninterruptible sleep），这只使 load averages 增加了 0.015，有一些时间在 cgroup 路径中，但是这台服务器没有做太多的磁盘 I/O。

这是一个更有趣的例子，这次只是 10s：

![img](https://pic1.zhimg.com/80/v2-d9071e9424ee8e41b5ec8e7a1bc75eb8_720w.jpg)

http://www.brendangregg.com/blog/images/2017/out.offcputime_unint01.svg



右边的宽塔显示 systemd-journal 在 proc_pid_cmdline_read() （读取 /proc/PID/cmdline）被阻塞，并为  load average 贡献了 0.07。并且左侧有一个更宽的 page fault 塔，最终也是停止在  rwsem_down_read_failed()（平均负载增加 0.23）。我使用火焰图搜索功能高亮了这些函数，以下是  rwsem_down_read_failed() 的摘录：

```c
    /* wait to be given the lock */
    while (true) {
        set_task_state(tsk, TASK_UNINTERRUPTIBLE);
        if (!waiter.task)
            break;
        schedule();
    }
```



这是使用 TASK_UNINTERRUPTIBLE 的获得锁的代码，Linux 有 uninterruptible 和 interruptible  两种获得锁的函数（例如 mutex_lock() vs mutex_lock_interruptible()，down() 和  down_interruptible() 用于信号量）。可中断版本允许任务被信号中断，然后再获取锁之前唤醒它进行处理。不间断锁睡眠的时间不会对  load average 增加太多，但是在这种情况下它们会增加 0.3，如果这个更高，那么值得分析看看是否可以减少锁争用（例如，我开始挖掘  systemd-journal 和 proc_pid_cmdline_read()!），这应该会提高性能并降低 load average。

将这些代码路径包含在 load average 中是否有意义呢？答案是有意义的，这些线程正在工作，碰巧遇到了锁，他们并没有闲着，这是系统的需求，尽管是软件资源而不硬件资源。



## 分解 Linux load averages

Linux load average 是否可以完全分解为组件？ 举个例子：在一个空闲的 8 CPU系统上，我启动了 tar 来存档一些未缓存的文件，这会花费几分钟时间大部分都会被磁盘读取阻止。 以下是从三个不同的终端窗口收集的统计数据：

```bash
terma$ pidstat -p `pgrep -x tar` 60
Linux 4.9.0-rc5-virtual (bgregg-xenial-bpf-i-0b7296777a2585be1)     08/01/2017  _x86_64_    (8 CPU)

10:15:51 PM   UID       PID    %usr %system  %guest    %CPU   CPU  Command
10:16:51 PM     0     18468    2.85   29.77    0.00   32.62     3  tar

termb$ iostat -x 60
[...]
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.54    0.00    4.03    8.24    0.09   87.10

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
xvdap1            0.00     0.05   30.83    0.18   638.33     0.93    41.22     0.06    1.84    1.83    3.64   0.39   1.21
xvdb            958.18  1333.83 2045.30  499.38 60965.27 63721.67    98.00     3.97    1.56    0.31    6.67   0.24  60.47
xvdc            957.63  1333.78 2054.55  499.38 61018.87 63722.13    97.69     4.21    1.65    0.33    7.08   0.24  61.65
md0               0.00     0.00 4383.73 1991.63 121984.13 127443.80    78.25     0.00    0.00    0.00    0.00   0.00   0.00

termc$ uptime
 22:15:50 up 154 days, 23:20,  5 users,  load average: 1.25, 1.19, 1.05
[...]
termc$ uptime
 22:17:14 up 154 days, 23:21,  5 users,  load average: 1.19, 1.17, 1.06
```



我还收集了一个仅用于不间断状态的 Off-CPU 火焰图 

![img](https://pic3.zhimg.com/80/v2-9060515db506e6ac4e38e777812fe41e_720w.jpg)http://www.brendangregg.com/blog/images/2017/out.offcputime_unint08.svg



最后一分钟的平均负载为1.19。让我分解一下： 

- 0.33 来自 tar 的 CPU 时间（pidstat）
- 0.67 是来自 tar 的不间断磁盘读取，由此可以推断（offcpu火焰图有这个 0.69，我怀疑它开始收集一点之后，跨越一个稍微不同的时间范围）
- 0.04 来自其他 CPU 用户（iostat 用户+系统，从 pidstat 减去 tar 的 CPU）
- 0.11 是来自内核工作者不间断磁盘的I / O时间，刷磁盘写入（offcpu flame graph，左边的两个塔）

文章的评论中解释一下这几个数字是怎么计算的：

> tar: the off-CPU flame graph has 41,464 ms, and that's a sum over a 60  second trace. Normalizing that to 1 second = 41.464 / 60 = 0.69. The  pidstat output has tar taking 32.62% average CPU (not a sum), and I know all its off-CPU time is in uninterruptible (by generating off-CPU  graphs for the other states), so I can infer that 67.38% of its time is  in uninterruptible. 0.67. I used that number instead, as the pidstat  interval closely matched the other tools I was running.
> by mpstat I  meant iostat sorry (I updated the text), but it's the same CPU summary.  It's 0.54 + 4.03% for user + sys. That's 4.57% average across 8 CPUs,  4.57 x 8 = 36.56% in terms of one CPU. pidstat says that tar consumed  32.62%, so the remander is 36.56% - 32.62% = 3.94% of one CPU, which was used by things that weren't tar (other processes). That's the 0.04  added to load average.



这相当于1.15，但是仍然缺少0.04，其中一些可能是舍入和测量间隔误差等，但很多可能是由于 load averages 是 exponentially-damped moving  sum，然而我是用的其他平均值（pidstat，iostat）都是正常的平均值。在 1.19 之前，一分钟的平均值为  1.25，所以其中一些仍将其弄得很高。是多少呢？从我之前的图表中，在一分钟标记处，62％的指标来自那一分钟。所以0.62 x 1.15 +  0.38 x 1.25 = 1.18，这与1.19非常接近。 

我希望这个例子可以表明这些数字确实是有意义的（CPU + 不间断），你可以通过分解它们弄明白。 



## 理解 Linux load averages

我和操作系统一起长大，其中 load averages 意味着 CPU load averages，因此 Linux 版本一直困扰着我。也许真正的问题一直是“load  averages”这个词和“I / O”一样含糊不清。是哪种类型的 I / O 呢？磁盘 I / O？文件系统 I / O？网络 I / O？  同样，哪个 load averages？ CPU load averages？System load averages？可以用这种方式理解它： 

- 在 Linux 中，对于整个系统而言，load averages 是 “**system load averages**”，测量正在运行和等待运行的线程数（CPU，磁盘，不间断锁）。换句话说，它测量不完全空闲的线程数。优点：包含了对不同资源的需求。
- 在其他操作系统上，load averages 是 “**CPU load averages**”，测量 CPU 运行的数量 + CPU 可运行的线程。优点：更容易理解（仅适用于CPU）。

请注意，还有另一种可能的类型：“**physical resource load averages**”，其中仅包括物理资源的负载（CPU +磁盘）。 

也许有一天我们会在 Linux 中增加额外的 load averages，并让用户选择他们想要使用的：单独的“CPU load averages”，“disk  load averages”，“network load averages”等，或者使用不同的指标。 



## 什么是“好”或“坏”负载平均值？

有些人似乎发现了一些阈值可以适用于他们的系统和负载：他们知道当负载超过 X 时，应用程序延迟就很高，同时客户也开始抱怨，但实际上并没有这方面的规律。

![img](https://pic3.zhimg.com/80/v2-10b17ffac5d0e31396e98cfd9315b1d2_720w.jpg)Load averages measured in a modern tool

对于 CPU load averages，可以将该值除以 CPU 数量，如果该比率超过  1.0，则表示正在运行饱和，这可能会导致性能问题。这有点模棱两可，因为它是一个可以隐藏变化的长期平均值（至少一分钟）。一个比率为 1.5  的系统可能会正常运行，而另一个 load average 为 1.5 的系统在一分钟内可能会表现不佳。 

我曾经管理过一个  two-CPU 电子邮件服务器，在白天运行时 CPU load averages 在 11~16 之间（比值介于  5.5~8）。延迟是可以接受的，并且也没有人抱怨。这是一个极端的例子：大多数系统在 load / CPU = 2 的情况下就可能会有性能问题。 

对于 Linux 的 system load average，由于它们涵盖了不同的资源类型，它就更加模糊一些，因此我们不能仅仅除以 CPU  数量。它对于相对场景下的对比更有意义：如果你知道系统在 load average = 20 的情况下运行正常，如果它现在为  40，那么就该花时间去研究其他指标了解发生了什么。 



## 更好的指标

当 Linux load averages 增加时，你知道负载对资源（CPU、磁盘和某些锁）有更高的需求，但并不能确定是哪个资源，你可以结合其他指标进行判断。例如，对于CPU： 

- **per-CPU utilization**：例如，使用 mpstat -P ALL 1
- **Per-process CPU utilization**：例如，top、pidstat 1 等。
- **Per-thread run queue (scheduler) latency**：例如，在/ proc / PID / schedstats，delaystats，perf sched
- **CPU run queue latency**：例如，在/ proc / schedstat，perf sched，[runqlat](https://link.zhihu.com/?target=http%3A//www.brendangregg.com/blog/2016-10-08/linux-bcc-runqlat.html) [bcc](https://link.zhihu.com/?target=https%3A//github.com/iovisor/bcc)。
- **CPU run queue length**：例如，使用 vmstat 1 和 'r' 列，runqlen bcc。

前两个是利用率指标，后三个是饱和指标。利用率对于负载的特征刻画很有帮助，同时饱和度指标对于识别性能问题非常有用。最佳的 CPU  饱和度指标是运行队列（或调度器）的延迟，即任务／线程处于可运行状态的时间，但是必须等待执行。我们可以使用这些指标计算性能的影响大小，例如线程在调度中时间开销的比例。相反，测量队列长度可能表明存在问题，但是很难估算其性能影响的大小。

schedstats facility 在 Linux 4.6（sysctl  kernel.sched_schedstats）中成为内核可调参数，默认情况下为关闭状态。delay accounting  暴露了相同的调度器延迟指标，这在 cpustat 中，我建议将它添加到 htop，因为这会使人们更容易使用，比从  /proc/sched_debug 输出中获取调度器延迟更容易： 

```text
$ awk 'NF > 7 { if ($1 == "task") { if (h == 0) { print; h=1 } } else { print } }' /proc/sched_debug
            task   PID         tree-key  switches  prio     wait-time             sum-exec        sum-sleep
         systemd     1      5028.684564    306666   120        43.133899     48840.448980   2106893.162610 0 0 /init.scope
     ksoftirqd/0     3 99071232057.573051   1109494   120         5.682347     21846.967164   2096704.183312 0 0 /
    kworker/0:0H     5 99062732253.878471         9   100         0.014976         0.037737         0.000000 0 0 /
     migration/0     9         0.000000   1995690     0         0.000000     25020.580993         0.000000 0 0 /
   lru-add-drain    10        28.548203         2   100         0.000000         0.002620         0.000000 0 0 /
      watchdog/0    11         0.000000   3368570     0         0.000000     23989.957382         0.000000 0 0 /
         cpuhp/0    12      1216.569504         6   120         0.000000         0.010958         0.000000 0 0 /
          xenbus    58  72026342.961752       343   120         0.000000         1.471102         0.000000 0 0 /
      khungtaskd    59 99071124375.968195    111514   120         0.048912      5708.875023   2054143.190593 0 0 /
[...]
         dockerd 16014    247832.821522   2020884   120        95.016057    131987.990617   2298828.078531 0 0 /system.slice/docker.service
         dockerd 16015    106611.777737   2961407   120         0.000000    160704.014444         0.000000 0 0 /system.slice/docker.service
         dockerd 16024       101.600644        16   120         0.000000         0.915798         0.000000 0 0 /system.slice/
[...]
```



除了 CPU 指标外，还可以查看磁盘设备的利用率和饱和度指标，我专注于 [USE 方法](https://link.zhihu.com/?target=http%3A//www.brendangregg.com/usemethod.html)中的这些指标，这里有一个[Linux 清单](https://link.zhihu.com/?target=http%3A//www.brendangregg.com/USEmethod/use-linux.html)。

虽然有更明确的指标，但这并不意味着 load averages 是没有用的，它们和其他一些指标成功用于云计算中微服务的 scale-up  策略，这有助于微服务可以应对不同的负载、CPU 或 磁盘 I/O。扩大规模比不扩大规模更安全，因此需要更多的有意义的指标。

我一直使用 load averages 的一个原因是他们的历史信息，如果我被要求检查云上性能出现问题的  instance，那么登录后发现一分钟平均值远低于十五分钟的平均值，这就是很大的一个线索，我在看其他指标之前，我只需要发几分钟来思考 load  averages。 



## 总结

1993年，一位 Linux 工程师发现一个带有 load averages 的非直观场景，并且使用补丁将他们从 “CPU load averages”  永久地改为 “system load averages”。他的更改还包括处于不间断状态的任务，因此 load averages  反映了对磁盘资源的需求，而不仅仅是 CPU。这些 system load averages 计算了等待和正在运行的线程数，并总结为  exponentially-damped moving sum averages 的三元组，使用1、5 和 15min  作为等式中的常数，这三个数字可以让我们看到负载是在增加还是减少，它们最大的价值是与自己的历史值进行比较。 

在 Linux 内核中，不间断状态的使用越来越多，现在包括不间断锁的原语。如果 load averages 是衡量正在运行和等待运行线程对资源需求的指标，那么它们正在按照我们希望的方式工作。 

在这篇文章中，我查找了 1993 年的 Linux load average 补丁，包括了作者的解释。我还在现代 Linux 系统上使用 bcc／eBPF  测量了不间断状态下的堆栈的 trace 和时间，并将其可视化为 off-CPU  火焰图。火焰图提供了许多不间断睡眠的例子，并且可以在需要时生成以解释 load averages  很高的情况。我还提出了其他指标，你可以使用这些指标更详细地了解系统负载，而不是负载平均值。 

我通过调度器的 maintainer Peter Zijlstra 在 Linux 源码中 kernel / sched / loadavg.c 的一段注释来结束本文： 

> \* This file contains the magic bits required to compute the global loadavg
> \* figure. **Its a silly number but people think its important.** We go through
> \* great pains to make it work on big machines and tickless kernels.



## 参考资料

- Saltzer, J., and J. Gintell. “[The Instrumentation of Multics](https://link.zhihu.com/?target=http%3A//web.mit.edu/Saltzer/www/publications/instrumentation.html),” CACM, August 1970 (explains exponentials).
- Multics [system_performance_graph](https://link.zhihu.com/?target=http%3A//web.mit.edu/multics-history/source/Multics/doc/privileged/system_performance_graph.info) command reference (mentions the 1 minute average).
- [TENEX](https://link.zhihu.com/?target=https%3A//github.com/PDP-10/tenex) source code (load average code is in SCHED.MAC).
- [RFC 546](https://link.zhihu.com/?target=https%3A//tools.ietf.org/html/rfc546) "TENEX Load Averages for July 1973" (explains measuring CPU demand).
- Bobrow, D., et al. “TENEX: A Paged Time Sharing System for the PDP-10,”  Communications of the ACM, March 1972 (explains the load average  triplet).
- Gunther, N. "UNIX Load Average Part 1: How It Works" [PDF](https://link.zhihu.com/?target=http%3A//www.teamquest.com/import/pdfs/whitepaper/ldavg1.pdf) (explains the exponential calculations).
- Linus's email about [Linux 0.99 patchlevel 14](https://link.zhihu.com/?target=http%3A//www.linuxmisc.com/30-linux-announce/4543def681c7f27b.htm).
- The load average change email is on [oldlinux.org](https://link.zhihu.com/?target=http%3A//oldlinux.org/Linux.old/mail-archive/) (in alan-old-funet-lists/kernel.1993.gz, and not in the linux directories, which I searched first).
- The Linux kernel/sched.c source before and after the load average change: [0.99.13](https://link.zhihu.com/?target=http%3A//kernelhistory.sourcentral.org/linux-0.99.13/%3Ff%3D/linux-0.99.13/S/449.html%23L332), [0.99.14](https://link.zhihu.com/?target=http%3A//kernelhistory.sourcentral.org/linux-0.99.14/%3Ff%3D/linux-0.99.14/S/323.html%23L412).
- Tarballs for Linux 0.99 releases are on [kernel.org](https://link.zhihu.com/?target=https%3A//www.kernel.org/pub/linux/kernel/Historic/v0.99/).
- The current Linux load average code: [loadavg.c](https://link.zhihu.com/?target=https%3A//github.com/torvalds/linux/blob/master/kernel/sched/loadavg.c), [loadavg.h](https://link.zhihu.com/?target=https%3A//github.com/torvalds/linux/blob/master/include/linux/sched/loadavg.h)
- The [bcc](https://link.zhihu.com/?target=https%3A//github.com/iovisor/bcc) analysis tools includes my [offcputime](https://link.zhihu.com/?target=http%3A//www.brendangregg.com/blog/2016-01-20/ebpf-offcpu-flame-graph.html), used for tracing TASK_UNINTERRUPTIBLE.
- [Flame Graphs](https://link.zhihu.com/?target=http%3A//www.brendangregg.com/flamegraphs.html) were used for visualizing uninterruptible paths.