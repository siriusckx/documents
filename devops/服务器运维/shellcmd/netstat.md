参考地址： https://www.cnblogs.com/ginvip/p/6367913.html

1. 每隔一段时间观察一下发送队列信息
```
netstat -antp -c 2 | awk '{if($3>0){print $0}}'
```