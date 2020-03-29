# yum之慎用 update upgrade
> centos 7 yum update 和 upgrade 均会升级操作系统的发行版，yum update还会进一步升级操作系统的内核。如下所示：

1. 升级前
```
[root@localhost ~]# cat /etc/centos-release
CentOS Linux release 7.2.1511 (Core) 
[root@localhost ~]# uname -r
3.10.0-327.el7.x86_64
[root@localhost ~]# 
```
2. 执行 `yum -y upgrade`
```
[root@localhost ~]# cat /etc/centos-release
CentOS Linux release 7.7.1908 (Core)
[root@localhost ~]# uname -r
3.10.0-327.el7.x86_64
[root@localhost ~]# 
```
3. 执行`yum --exclude=kernel* update`
>其效果同 yum -y upgrade 的一致
```
[root@localhost ~]# cat /etc/centos-release
CentOS Linux release 7.7.1908 (Core)
[root@localhost ~]# uname -r
3.10.0-327.el7.x86_64
[root@localhost ~]# 
```
4. 执行`yum -y update`
>需要重启操作系统后，才可以看见内核更新
```
[root@localhost log]# cat /etc/centos-release
CentOS Linux release 7.7.1908 (Core)
[root@localhost log]# uname -r
3.10.0-1062.18.1.el7.x86_64
[root@localhost log]# 
```