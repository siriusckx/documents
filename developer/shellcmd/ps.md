1. 查询进程起动时间，流逝的时间以及启动命令
```
ps -eo pid,lstart,etime,cmd | grep redis-server
```