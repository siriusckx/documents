## waitpid和wait差别
1. waitpid可以回收指定PID的子进程
2. waitpid可以阻塞式或非阻塞式两种工作模式
   
## 使用waitpid实现wait的效果
1. ret = waitpid(-1, &status, 0); -1 表示不等待鞭个特定PID的子进程而是回收任意一个子进程，0表示用默认的方式（阻塞式）来进行等待。返回值是本次回收的子进程的pid。
2. ret = waitpid(pid, &status, 0);等待回收PID为pid的这个子进程，如果当前进程并没有一个ID号为pid的子进程，则返回值为-1；如果成功回收了pid这个子进程则返回值为回收的进程的PID.
3. ret = waitpid(pid, &status, WNOHANG);这种表示父进程要非阻塞式的回收子进程。此时如果父进程执行waitpid时子进程已经先结束等待回收则waitpid直接回收成功，返回值是回收的子进程的PID；如果父进程waitpid时子进程尚未结束则父进程立刻返回（非阻塞）,但是返回值为0（表示回收不成功）。


