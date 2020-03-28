## openlog、syslog、closelog
> 打开日志，写日志，关闭日志
## 各种参数

## 编程实战
1. 日志写完后，一般log信息都在操作系统/var/log/messages这个文件中存储着，但是ubuntu在/var/log/syslog

## syslog的工作原理
1. 操作系统中有一个守护进程syslog(开机运行，关机时才结束),这个守护进程syslogd负责进行日志文件的写入和维护。
2. syslogd是独立于我们任意一个进程而运行的。我们当前进程和syslog进程本来是没有任何关系的，但是我们当前进程可以通过调用openlog打开一个和syslogd相连接的通道，然后通过syslog向syslogd发消息，然后由syslogd来将其写入到日志文件系统中。
3. syslogd其实就是一个日志文件系统的服务器进程，提供日志服务。任何需要写显示屏的进程都可以通过openlog/syslog/closelog这三个函数来利用syslogd提供的日志服务。这就是操作系统的服务式的设计。