# 同步两台服务器的文件

## 1 服务端的配置

1.  `/etc/rsyncd.conf`配置

```shell
gid = users
read only = true
use chroot = false
transfer logging = true
log format = %h %o %f %l %b
log file = /var/log/rsyncd.log
pid file = /var/run/rsyncd.pid
slp refresh = 300 
use slp = false

lock file=/var/run/rsync.lock
port=873
address=10.10.1.76
uid=0
gid=0
max connections = 50
hosts allow=10.10.1.103
hosts deny=*
auth users= syndata
secrets file=/etc/rsyncd.secrets

[sh3001]
comment=sh3001
path=/glusterfs/metadatas/3001/SH
ignore errors

[sz3001]
comment=sh3001
path=/glusterfs/metadatas/3001/SZ
ignore errors
```

2. `/etc/rsyncd.secrects`的权限设置成其他组用户不可读

> `/etc/rsyncd.secrets`存放的是用户名密码，如:`syndata:111`，另外要保证该文件其他的用户不可读，权限如下所示：
>
> ```shell
> [root@localhost ~]# chmod 640 /etc/rsyncd.secrets 
> [root@localhost ~]# ll /etc/rsyncd.secrets 
> -rw-r----- 1 root root 12 5月   7 13:24 /etc/rsyncd.secrets
> ```
>

3. 启动 `rsync server`端

   ```shell
   [root@localhost ~]# rsync --daemon
   ```

## 2. 客户端的配置

1. 同步数据的脚本

   ```shell
   nohup rsync -arvPW --delete syndata@10.10.1.76::sh3001 /glusterfs/metadatas/3001/SH --password-file=/etc/rsyncd.passwd >> /home/xxx/log/rsync.log 2>&1 &
   ```

2. `/etc/rsyncd.passwd`权限设置成其他组用户不可读

   ```shell
   [root@localhost ~]# chmod 640 /etc/rsyncd.passwd 
   [root@localhost ~]# ll /etc/rsyncd.passwd
   -rw-r----- 1 root root 12 5月   7 13:24 /etc/rsyncd.passwd
   ```

3. 注意添加监控脚本`jk_rsync.sh`

   > 避免有的时候同步数据，导致客户端同步脚本出现异常，退出。可通过监控脚本将其拉起，继续同步数据。

   ```
   #!/bin/bash
   cd /home/xxx/scripts
   while [ 1 ]
   do
   rsyncpid=`/usr/bin/pgrep -f /etc/rsyncd.passwd|wc -l`
   echo $rsyncpid
   if [ $rsyncpid -lt 1 ]; 
   then
   ./run.sh
   fi
   
   sleep 5
   done
   ```

   

参考网址：  

https://www.cnblogs.com/regit/p/8074221.html

https://blog.csdn.net/counsellor/article/details/86537786

https://blog.csdn.net/supermenxxx/article/details/50617423

