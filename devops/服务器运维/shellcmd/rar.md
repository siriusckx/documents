# centos7 安装 rar

1. 查看系统内核及版本
```
[root@zyhq-8 lv2binary]# uname -a
Linux zyhq-8.novalocal 3.10.0-327.el7.x86_64 #1 SMP Thu Nov 19 22:10:57 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
[root@zyhq-8 lv2binary]# cat /etc/centos-release
CentOS Linux release 7.2.1511 (Core) 
[root@zyhq-8 lv2binary]# 
```

2. 获取安装包安装
   
```
wget http://www.rarsoft.com/rar/rarlinux-x64-5.3.0.tar.gz
tar -zxvf rarlinux-x64-5.3.0.tar.gz
cd rar
make
```

3.  安装完后可以使用相应命令
```
解包：
rar x xxx.rar   # 解压xxx.rar到当前目录

打包：
rar xxx.rar ./dir  # 将dir目录下的内容，打包成xxx.rar
```