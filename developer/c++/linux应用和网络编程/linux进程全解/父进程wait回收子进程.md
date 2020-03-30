## wait的工作原理
1. 子进程结束时，系统向其父进程发送SIGCHILD信号
2. 父进程调用wait函数后阻塞
3. 父进程被SIGCHILD信号唤醒然后去回收僵尸子进程
4. 若父进程没有任何子进程则wait返回错误
5. 父子进程之间是异步的，SIGCHILD信号机制就是为了解决父子进程之间的异步通信问题，让父进程可以及时的去回收僵尸子进程。

## wait实战编程
1. wait的参数status.status用来返回子进程结束时的状态，父进程通过wait得到status后就可以知道子进程的一些结束状态信息。
2. wait的返回值pid_t，这个返回值就是本次wait回收的子进程的PID.当前进程有可能有多个子进程，wait函数阻塞直到其中一个子进程结束wait就会返回，wait的返回值就可以用来判断到底是哪一个子进程本次被回收了。
3. 对wait做个总结：wait主要是用来回收子进程资源，回收同时还可以得知被回收子进程的pid和退出状态。
4. WIFEXITED、WIFSIGNALED、WEXITSTATUS这几个宏用来获取子进程的退出状。
   WIFEXITED宏用来判断子进程是否正常终止（return、exit、_exit退出）
   WIFSIGNALED宏用来判断子进程是否非正常终止（被信号终止）
   WEXITSTATUS宏用来得到正常终止情况下的进程返回值。