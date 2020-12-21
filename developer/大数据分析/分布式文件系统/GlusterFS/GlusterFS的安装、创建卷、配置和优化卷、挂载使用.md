一、网站推荐：

　　1、https://gluster.readthedocs.io/en/latest/   这是官方的说明网站。这里面有安装Glusterfs原理，安装流程，各种卷的原理、创建方式、以及使用领域的说明。推荐直接访问官方网站学习使用。

　　2、https://download.gluster.org/pub/gluster/glusterfs  这是官方的资源网站。这里面有各种系统的Glusterfs资源下载路径。

 

二、安装流程（需要在每台服务器上操作）

　　假设我们有三台测试机分别是192.168.1.11 192.168.1.22 192.168.1.33，三台需要同时安装服务端和客户端。

　　常用术语简介（可去http://gluster.readthedocs.io/en/latest/Quick-Start-Guide/Terminologies/ 查看学习）

　　Brick:  GFS中的存储单元，通过是一个受信存储池中的服务器的一个导出目录。可以通过主机名和目录名来标识，如'SERVER:EXPORT'
　　Client:  挂载了GFS卷的设备
　　Extended Attributes:  xattr是一个文件系统的特性，其支持用户或程序关联文件/目录和元数据。
　　FUSE:  Filesystem Userspace是一个可加载的内核模块，其支持非特权用户创建自己的文件系统而不需要修改内核代码。通过在用户空间运行文件系统的代码通过FUSE代码与内核进行桥接。
　　Node: 一个拥有若干brick的设备
　　Volume:  一组bricks的逻辑集合

 

　　1、查看系统版本，根据版本选择安装方式（常用的有Ubuntu、Red Hat等）

```
cat` `/proc/version``;
```

　　　　![img](https://img2020.cnblogs.com/blog/1457314/202007/1457314-20200703174006424-1565705735.png)

　　　　![img](https://img2020.cnblogs.com/blog/1457314/202007/1457314-20200703173729981-305173568.png)

　　2、查看ip：　　　

```
ifconfig` `| ``grep` `-``v` `grep` `| ``grep` `inet | ``grep` `-``v` `inet6 | ``grep` `-``v` `"127.0.0.1"` `| ``awk` `'{print $2}'
```

　　3、配置/etc/hosts：

```
sudo` `echo` `"192.168.1.11  dn11"` `>> ``/etc/hosts``; ``sudo` `echo` `"192.168.1.22  dn22"` `>> ``/etc/hosts``;``sudo` `echo` `"192.168.1.33  dn33"` `>> ``/etc/hosts``;``cat` `/etc/hosts``;
```

　　　![img](https://img2020.cnblogs.com/blog/1457314/202005/1457314-20200506154409804-34703785.png)

　　4、更改主机名称：

　　　　1）临时更改主机名：

```
hostname``;　　``#查看主机名，如果是localhost.localdomain就说明是默认的<br>　　　　hostname 主机名;　　#临时设置主机名，立即生效
```

　　　　2）永久改变主机名方法一：

```
sudo` `vim ``/etc/sysconfig/network``; 　　``#通过配置文件更改主机名，重启后生效
```

　　　　3）永久改变主机名方法二：

```
sudo` `hostnamectl --static ``set``-``hostname` `主机名;　　``#通过命令更改主机名，立即生效
```

　　5、安装glusterfs部分包依赖的epel源：

```
sudo` `yum -y ``install` `epel-release;
```

　　6、安装资源包：

```
sudo` `yum ``install` `centos-release-gluster -y;
```

　　7、查看可用的资源包：

```
sudo` `yum list glusterfs --showduplicates | ``sort` `-r;
```

　　　 ![img](https://img2018.cnblogs.com/blog/1457314/201905/1457314-20190516143014094-744016892.png)

　　8、添加下载配置源文件：

```
sudo` `vim ``/etc/yum``.repos.d``/gluster-epel``.repo;
```

　　内容如下：

```
# CentOS-Gluster-6.repo``#``# Please see http://wiki.centos.org/SpecialInterestGroup/Storage for more``# information` `[centos-gluster6]``name=CentOS-$releasever - Gluster 6``mirrorlist=http:``//mirrorlist``.centos.org?arch=$basearch&release=$releasever&repo=storage-gluster-6``#baseurl=http://mirror.centos.org/$contentdir/$releasever/storage/$basearch/gluster-6/``gpgcheck=1``enabled=1``gpgkey=``file``:``///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-Storage` `[centos-gluster6-``test``]``name=CentOS-$releasever - Gluster 6 Testing``baseurl=http:``//buildlogs``.centos.org``/centos/``$releasever``/storage/``$basearch``/gluster-6/``gpgcheck=0``enabled=0``gpgkey=``file``:``///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-Storage
```

　　9、安装Glusterfs：

```
sudo` `yum -y ``install` `glusterfs-server glusterfs-fuse;
```

　　注意：上面5、6、7、8、9是在Red Hat上操作，Ubuntu上对应操作参考：https://launchpad.net/~gluster/+archive/ubuntu/glusterfs-6

　　Ubuntu对应的命令如下：

```
sudo` `add-apt-repository ppa:gluster``/glusterfs-6``sudo` `apt-get update
```

　　10、开启glusterd服务：

```
sudo` `systemctl ``enable` `glusterd.service;``sudo` `systemctl start glusterd.service; （或者service glusterd start）``sudo` `systemctl status glusterd.service;
```

　　11、开启开机启动：

```
sudo` `chkconfig glusterd on;
```

　　12、关闭selinux：

```
sudo` `sed` `-i ``'s/SELINUX=enforcing/SELINUX=disabled/'` `/etc/sysconfig/selinux` `/etc/selinux/config``;
```

　　13、防火墙设置：

```
sudo` `firewall-cmd --zone=public --permanent --add-port=24007-24008``/tcp` `--add-port=49152-49158``/tcp` `--add-port=38465-38469``/tcp` `--add-port=111``/tcp` `--add-port=111``/udp` `--add-port=2049``/tcp``;``sudo` `firewall-cmd --reload;
```

　　14、磁盘准备：

　　　　每台服务器准备1-2T的磁盘用于文件系统数据存储；

　　15、磁盘挂载：

　　　　1）查看磁盘信息：

```
sudo` `fdisk` `-l;
```

　　　　![img](https://img2020.cnblogs.com/blog/1457314/202005/1457314-20200506162350179-713157965.png)

　　　　2）格式化磁盘：

```
sudo` `mkfs.xfs ``/dev/sda3``;
```

　　　　3）创建磁盘挂载路径：

```
sudo` `mkdir` `-p ``/data/brick1``;
```

　　　　4）磁盘开机自动挂载方式：

```
sudo` `echo` `'/dev/sda3 /data/brick1 xfs defaults 1 2'` `>> ``/etc/fstab``;``sudo` `mount` `-a && ``mount``;
```

　　　　5）磁盘非开机自动挂载方式：　　　　　

```
sudo` `mount` `/dev/sda3` `/data/brick1``;
```

　　　*说明：没有磁盘也是可以的，创建卷的时候加上 force

 

三、创建卷以及相关命令介绍（任意一台服务器上操作即可）

　　1、添加授信池：

```
sudo` `gluster peer probe dn11;``sudo` `gluster peer probe dn22;``sudo` `gluster peer probe dn33;
```

　　注意：这里的节点可以替换成对应的ip如：

```
sudo` `gluster peer probe 192.168.1.11
```

　　2、查看集群节点状态：

```
sudo` `gluster peer status;
```

　　![img](https://img2020.cnblogs.com/blog/1457314/202007/1457314-20200706113359057-1012689614.png)

 　Connected说明链接正常，如果是DisConnected则说明那个节点连接出现问题，这时需要查看日志再进行相应处理。

　　3、在集群中删除某个节点，如删除dn11，慎操作：

```
sudo` `gluster peer detach dn11;
```

　　4、卷操作（官网链接：https://gluster.readthedocs.io/en/latest/ ）

　　　　1）创建一个复制卷（可以在任意一台服务器上执行，本例在dn11上执行）

```
sudo` `gluster volume create Distributed-Replicate-volume replica 2 transport tcp dn11:``/fleetDatas` `dn22:``/fleetDatas` `force;
```

　　　　2）启动卷：

```
sudo` `gluster volume start Distributed-Replicate-volume;
```

　　　　3）查看卷信息：

```
sudo` `gluster volume info Distributed-Replicate-volume;
```

　　　　4）停止、删除卷（慎操作）

```
sudo` `gluster volume stop Distributed-Replicate-volume; ``#停止卷``sudo` `gluster volume delete Distributed-Replicate-volume; ``#删除卷
```

 

四、配置（任意一台操作即可）

　　1、设置允许挂载范围，注意默认是允许所有客户端，哪怕不在授信池内的客户端

```
sudo` `gluster volume ``set` `Distributed-Replicate-volume auth.allow dn11,dn22,dn33;
```

　　2、开启ACL支持

```
sudo` `gluster volume ``set` `Distributed-Replicate-volume acl on;
```

　　3、设置磁盘剩余空间最小阈值，达到这个值就不能再继续写入数据了

```
sudo` `gluster volume ``set` `Distributed-Replicate-volume cluster.min-``free``-disk 15;
```

　　4、设置请求等待超时时间，默认1800秒，设置范围0-1800秒，读写的数据超过1800秒未返回结果就认为超时

```
sudo` `gluster volume ``set` `Distributed-Replicate-volume network.frame-timeout 1500;
```

　　5、设置客户端检测服务器可用超时时间，默认42秒，范围为0-42秒

```
sudo` `gluster volume ``set` `Distributed-Replicate-volume network.``ping``-timeout 20;
```

　　6、关闭NFS服务，默认为开启

```
sudo` `gluster volume ``set` `Distributed-Replicate-volume nfs.disable off;
```

　　7、设置IO线程数，默认为16，范围为0-65

```
sudo` `gluster volume ``set` `Distributed-Replicate-volume performance.io-thread-count 32;
```

　　8、设置缓存数据校验周期，默认为1秒，默认为0-61秒，如果同时有多个用户在读写一个文件，一个用户更新了数据，另一个用户在Cache刷新周期到来前可能读到非最新的数据，即无法保证数据的强一致性。因此实际应用时需要在性>能和数据一致性之间进行折中，如果需要更高的数据一致性，就得调小缓存刷新周期，甚至禁用读缓存；反之，是可以把缓存周期调大一点，以提升读性能　

```
sudo` `gluster volume ``set` `Distributed-Replicate-volume performance.cache-refresh-timeout 2;
```

　　9、设置读缓存大小，单位为字节，默认大小为32M

```
sudo` `gluster volume ``set` `Distributed-Replicate-volume performance.cache-size 128MB;
```

　　10、启用对小文件的优化性能，默认即为打开

```
sudo` `gluster volume ``set` `Distributed-Replicate-volume performance.quick-``read` `on;
```

　　11、设置文件预读，用预读的方式提高读取的性能,读取操作前就预先抓取数据,这个有利于应用频繁持续性的访问文件，当应用完成当前数据块读取的时候，下一个数据块就已经准备好了，预读处理有page-size和page-count来定义，page-size定义了，一次预读取的数据块大小，page-count定义的是被预读取的块的数量,不过官方网站上说这个中继在以太网上没有必要，一般都能跑满带宽。主要是在IB-verbs或10G的以太网上用。

```
sudo` `gluster volume ``set` `Distributed-Replicate-volume performance.``read``-ahead on;
```

　　12、设置在写数据的时候先写入到缓存再写入到磁盘，以提高写入性能，默认为开启

```
sudo` `gluster volume ``set` `Distributed-Replicate-volume performance.nfs.write-behind on;
```

　　13、缓存已经读过的数据，默认即开启，结合上面的performance.quick-read和performance.read-ahead使用

```
sudo` `gluster volume ``set` `Distributed-Replicate-volume performance.io-cache on;
```

　　14、开启磁盘修复功能（只适用于复制卷或分布式复制卷）

```
sudo` `gluster volume heal Distributed-Replicate-volume full;
```

　　15、查看磁盘状况

```
sudo` `gluster volume heal Distributed-Replicate-volume info;
```

　　16、查看卷信息

```
sudo` `gluster volume info Distributed-Replicate-volume;
```

　　　![img](https://img2020.cnblogs.com/blog/1457314/202005/1457314-20200506170216564-1189716376.png)

　　17、清空一个选项的参数，如清空acl的配置

```
sudo` `gluster volume reset Distributed-Replicate-volume acl force;
```

　　18、查看一个选项的参数，如查看acl的配置　　

```
sudo` `gluster volume get Distributed-Replicate-volume acl;
```

 

五、挂载使用（在auth.allow配置下的任意客户端都可以执行）

　　1、创建一个挂载路径：

```
sudo` `mkdir` `-p ``/home/Distributed-Replicate-volume-test``;
```

　　2、 文件系统开机自动挂载方式：

```
sudo` `echo` `"192.168.1.11:/Distributed-Replicate-volume /home/Distributed-Replicate-volume-test glusterfs defaults,_netdev,acl 0 0"` `>> ``/etc/fstab``; ``sudo` `mount` `-a && ``mount
```

　　3、文件系统非开机自动挂载方式：

```
sudo` `mount` `-t glusterfs -o acl dn11:``/Distributed-Replicate-volume` `/home/Distributed-Replicate-volume-test``;
```

　　说明：上诉两种挂载方式是在开启了acl配置的前提下，如果没有开启acl配置，去掉acl的参数即可。

　　4、卸载文件系统挂载：

```
sudo` `umount` `/home/Distributed-Replicate-volume-test``;
```

 

六、结束感言：

　　创作不易，如果对你有帮助，请帮忙点赞、收藏，谢谢！

=========================结束！=======================



七、补充

1. 在使用 gluster 的时候，要学会使用各种命令，来查看信息。

   ```
   gluster volume help
   gluster volume get volume-name key  # 获得某个 key 的属性值
   gluster volume get volume-name all  # 获得所有的属性值
   gluster volume get volume-name all|grep performance  #获取和性能相关的参数
   ```

   

