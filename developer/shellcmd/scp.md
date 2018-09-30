### 作用
> 复制文件到远程服务器上

> 使用指定的用户，指定的端口，复制数据到指定的目录
```
scp -P 4000 ./test.txt username@192.168.1.10:~/dir1/
```

> 从远程服务器复制文件到本地目录，只需要将对应的文件或目录颠倒位置即可
```
scp -r root@192.168.120.204:/opt/soft/mongodb /opt/soft/
``` 

> 注意一些参数的使用
* -r : 复制目录
* -v : 打印调试信息