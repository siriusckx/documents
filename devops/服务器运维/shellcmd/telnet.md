### telnet命令检查端口是否通
> 通常情况下，我们会使用telnet命令来检测端口通还是不通
```
telnet 10.10.1.100 55500
```
>要退出时，可按Ctrl+]，然后再输入quit退出telnet终端

### 使用telnet检查端口有问题时的几种表现
1. telnet直接返回不通，说明目标端口未被监听
2. telnet连上后一会儿，出现**Connection closed by foreign host**
   * 情况一：端口对应的应用被重复的重启，刚监听上端口，然后又被停了。
   * 情况二：端口做了相应的防火墙措施，可能是请求过去，但没返回来。如：监听的是10.10.1.100 3306端口，而不是0.0.0.0 3306端口。就有可能不通。
   * 情况三：查看服务器进程，进程在，但端口未被监听起来，可能是端口被其他进程占用