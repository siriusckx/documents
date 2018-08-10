# 清理swap内存
```
[root@mysql172 ~]# sync
[root@mysql172 ~]# echo 1 > /proc/sys/vm/drop_caches
[root@mysql172 ~]# free -m
[root@mysql172 ~]# swapoff -a;swapon -a
```
```
drop_caches的详细文档如下：
Writing to this will cause the kernel to drop clean caches, dentries and inodes from memory, causing that memory to become free.
To free pagecache:
* echo 1 > /proc/sys/vm/drop_caches
To free dentries and inodes:
* echo 2 > /proc/sys/vm/drop_caches
To free pagecache, dentries and inodes:
* echo 3 > /proc/sys/vm/drop_caches
As this is a non-destructive operation, and dirty objects are notfreeable, the user should run "sync" first in order to make sure allcached objects are freed.
This tunable was added in 2.6.16.
```