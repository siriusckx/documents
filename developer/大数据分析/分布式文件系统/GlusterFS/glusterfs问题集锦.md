## 一、GlusterFS 问题集锦

### 1.1 glusterfs 进行 rebalance 

> 环境描述：glusterfs 7.9.1 ，以 3 * 1 的分布式卷方式进行部署。
>
> 问题描述：glusterfs 在执行 rebalance 过程当中，有一些节点通过标准的 fopen，fread 函数，通过挂载的glusterfs目录读取文件时，提示找不到文件。需要通过手动执行一下 `ll` 命令后才可以找到对应的文件。

**NOTE1**: 对于分布式卷，在做 rebalance 的过程中，可能会出现访问不到数据的情况出现。

**NOTE2**:在做 rebalance 的过程中，另一边写数据，可能会导致数据被覆盖。

### 1.2 glusterfs 替换分布式复制卷

> 环境描述：glusterfs 7.4 , 以 3 * 2 的分布式卷方式进行部署。
>
> 问题描述：按照如下方式进行坏的分布式卷替换后，未能正常的进行自愈
>
> ```
> Replacing bricks in Replicate/Distributed Replicate volumes
> 选定一个新的目录  /data/gfsdata
> 确定要替换的brick 离线
> 格式化新的硬盘并挂载
> mkfs.xfs /dev/sda
> vim /etc/fstab
> mount /dev/sda /data
> mkdir /data/gfsdata
> 
> 查看故障节点的备份节点服务器的属性
> [root@localhost ~]# getfattr -d -m. -e hex /home/gfsdata 
> getfattr: Removing leading '/' from absolute path names
> # file: home/gfsdata
> trusted.afr.dirty=0x000000000000000000000000
> trusted.afr.gv0-client-0=0x000000000000000600000001
> trusted.gfid=0x00000000000000000000000000000001
> trusted.glusterfs.dht=0x0000000100000000aaaaaa42ffffffff
> trusted.glusterfs.dht.commithash=0x3432333639343730363000
> trusted.glusterfs.mdata=0x010000000000000000000000005fabc05d00000000305fe76f000000005fabc05d00000000305fe76f000000005f7b9c02000000000a4f9e36
> trusted.glusterfs.volume-id=0x6933a6cbfb0b42719b6ff6bd6fc388cc
> 
> 设置故障节点新目录的扩展属性，触发自愈【该目录填写的是要挂载的目录，不是gluster存储数据的那个物理目录】
> mkdir /glusterfs/metadatas/test1
> rm -rf /glusterfs/metadatas/test1
> setfattr -n trusted.non-existent-key -v abc /glusterfs/metadatas
> setfattr -x trusted.non-existent-key  /glusterfs/metadatas
> 
> 再次查询故障节点的备份节点的扩展属性，看新节点是否进行了同步
> [root@localhost ~]# getfattr -d -m. -e hex /home/gfsdata 
> 
> 
> 用新的卷替换要下线的卷 
> gluster volume replace-brick gv0 bj-p-70:/data/gfsdata1 bj-p-70:/data/gfsdata commit force
> 
> 检查卷的状态正常，但是未能正常触发自愈
> 【通过在后台，执行如下命令，才看见自愈功能有触发】
> nohup gluster volume heal gv0 info &
> tail -f /var/log/glusterfs/glustershd.log
> ```
>
> 



