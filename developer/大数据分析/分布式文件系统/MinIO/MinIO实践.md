## 一、服务端的搭建

### 1.1 单机版的安装

### 1.2 集群的安装

> 注意集群时，minio 实例数的编排，以及集群扩展的机制。
>
> https://github.com/minio/minio/blob/master/docs/zh_CN/distributed/README.md
>
> https://blog.csdn.net/sinat_15946141/article/details/105675351

#### 1.2.1 单台服务器，每台服务器4个目录

> https://my.oschina.net/beyondken/blog/3285803

```
#!/bin/bash
#只需要在1台服务器上运行即可
export MINIO_ACCESS_KEY=minioadmin
export MINIO_SECRET_KEY=minioadmin
cd /home/ckx/soft
nohup ./minio server /home/minio_data1 /home/minio_data2 /home/minio_data3 /home/minio_data4 &
```

#### 1.2.2 两台服务器，每台服务器2个目录

```
#!/bin/bash

# 需要在两台服务器上都运行
export MINIO_ACCESS_KEY=minioadmin
export MINIO_SECRET_KEY=minioadmin
cd /home/xxx/soft
nohup ./minio server http://10.10.1.228:9000/home/minio_data1 http://10.10.1.228:9000/home/minio_data2 http://10.10.1.226:9000/home/minio_data1 http://10.10.1.226:9000/home/minio_data2 &
```

#### 1.2.3 四台服务器，每台服务器1个目录

```
#!/bin/bash
export MINIO_ACCESS_KEY=minioadmin
export MINIO_SECRET_KEY=minioadmin

# 需要在四台服务器上都运行
cd /home/ckx/soft
nohup ./minio server http://10.10.1.228:9000/home/minio_data http://10.10.1.226:9000/home/minio_data http://10.10.1.101:9000/home/minio_data http://10.10.1.105:9000/home/minio_data &
```



### 1.3 集群宕机恢复

#### 1.3.1 MinIO 节点宕机，服务程序重启

#### 1.3.2 MinIO 节点宕机，目录重新挂载

### 1.4 生产环境调优

#### 1.4.1 基本诊断

> https://github.com/minio/minio/blob/master/docs/zh_CN/debugging/README.md

#### 1.4.2 环境配置的调优

> https://github.com/minio/minio/blob/master/docs/zh_CN/deployment/kernel-tuning/README.md

#### 1.4.3 启动磁盘缓存

> https://github.com/minio/minio/blob/master/docs/zh_CN/disk-caching/README.md

#### 1.4.4 MinIO服务器限制

> 对 MinIO 的服务根据实际情况，做相应的限制
>
> https://github.com/minio/minio/blob/master/docs/zh_CN/throttle/README.md

#### 1.2.5 使用 tls 做安全验证

## 二、客户端的使用

1. 注意 python 版本的兼容，使用 3.7.5。
2. mc 工具使用

## 三、MinIO 使用注意事项

### 3.1 MinIO 的缓存机制

>默认情况下，对象缓存处于以下设置状态

- 缓存大小是你内存大小的一半，不过如果你的内存小于8G的话，缓存是不开启的。
- 缓存对象的过期时间是72小时。
- 每次过期时间的1/4时间点（每18小时）触发一次过期对象垃圾回收清理。

注意：上述配置不支持手动修改。

> https://github.com/minio/minio/blob/master/docs/zh_CN/caching/README.md

### 3.2 MinIO 的压缩机制

> https://github.com/minio/minio/blob/master/docs/zh_CN/compression/README.md

### 3.3 MinIO 分布式容错校验

> minio 磁盘利用率为n/(n+m)，n 为数据块个数，m为校验块个数。具体到minio：通常n=m=disks/2
>
> 基于纠删码的方法与多副本方法相比具有冗余度低、磁盘利用率高等优点，但计算、网络开销大，恢复效率低。
>
> 纠删码所带来的额外负担主要是计算量和数倍的网络负载，优缺点都相当明显。尤其是在出现硬盘故障后，重建数据非常耗CPU，而且计算一个数据块需要通过网络读出N倍的数据并传输，所以网络负载也有数倍甚至10数倍的增加。由于性能损失的原因，用在本身压力已经很大，很“热”的在线存储系统明显不是很合适，所以目前大多数系统还是把 erasure code用于冷数据的离线处理阶段。
>
> [minio是怎么解决数据可靠性的?](https://ieevee.com/tech/2017/11/15/minio-erasure.html)
>
> [Erasure Coding（纠删码）深入分析 转](https://www.bbsmax.com/A/MyJxxWXeJn/)

### 3.4 MinIO 桶命名规则

> MinIO 桶的命名，目前在严格模式下，名字只能包含 数字、小写字母、中划线，对象名称不受此约束，对于不符合规则的数据，可以放入里面做一些特殊的处理。如何使用非严格模式呢？
>
> https://docs.rightscale.com/faq/clouds/aws/What_are_valid_S3_bucket_names.html

### 3.5 MinIO 写入重复文件

## 四、MinIO基准测试

### 4.1 硬件基准测试

**NOTE:** `使用 fio 进行测试， 指定的文件名，需要是一个空白的文件名，不要直接指定设备名，要指定设备名，则需要一个纯空白的硬盘。`

> 使用 fio 对不同的硬件做基准测试 https://www.cnblogs.com/raykuan/p/6914748.html
>
> 使用 `smartctl -a /dev/sda` 或 `smartctl -x /dev/sda` 或 `smartctl -a -d megaraid,0 /dev/sda` 查看硬盘信息

#### 4.1.1 硬盘 fio 测试样例

1. HDD机械硬盘，DELL (PERC) H310

   ```
   [root@localhost ~]# smartctl -a /dev/sda
   smartctl 7.0 2018-12-30 r4883 [x86_64-linux-3.10.0-1062.18.1.el7.x86_64] (local build)
   Copyright (C) 2002-18, Bruce Allen, Christian Franke, www.smartmontools.org
   
   === START OF INFORMATION SECTION ===
   Vendor:               DELL
   Product:              PERC H310
   Revision:             2.12
   Compliance:           SPC-3
   User Capacity:        3,000,034,656,256 bytes [3.00 TB]
   Logical block size:   512 bytes
   Logical Unit id:      0x6c81f660f8beb8001b37494303285f74
   Serial number:        00745f28034349371b00b8bef860f681
   Device type:          disk
   Local Time is:        Thu Dec 24 10:51:21 2020 CST
   SMART support is:     Unavailable - device lacks SMART capability.
   ```

2. 官方说明

   ①符合串行连接 SCSI (SAS) 2.0，可提供高达 6 Gb/秒的吞吐量。

   ②在保持相同驱动器类型（SAS 或 SATA）和技术（HDD 或 SSD）的情况下，支持混用具有不同速度（7,200 rpm、10,000 rpm 或 15,000 rpm）和带宽（3 Gbps 或 6 Gbps）的磁盘。
   
3. FIO测试结果

   ```sh
   [root@localhost ~]# fio -filename=/home/emcpowerb -direct=1 -iodepth 1 -thread -rw=randrw -rwmixread=70 -ioengine=psync -bs=4k -size=50G -numjobs=50 -runtime=180 -group_reporting -name=randrw_70read_4k
   ```

   ```
   randrw_70read_4k: (g=0): rw=randrw, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=psync, iodepth=1
   ...
   fio-3.7
   Starting 50 threads
   randrw_70read_4k: Laying out IO file (1 file / 51200MiB)
   Jobs: 50 (f=50): [m(50)][100.0%][r=992KiB/s,w=436KiB/s][r=248,w=109 IOPS][eta 00m:00s]
   randrw_70read_4k: (groupid=0, jobs=50): err= 0: pid=37333: Thu Dec 24 11:03:53 2020
      read: IOPS=283, BW=1133KiB/s (1160kB/s)(199MiB/180231msec)
       clat (msec): min=6, max=624, avg=94.70, stdev=59.31
        lat (msec): min=6, max=624, avg=94.70, stdev=59.31
       clat percentiles (msec):
        |  1.00th=[   16],  5.00th=[   26], 10.00th=[   34], 20.00th=[   47],
        | 30.00th=[   60], 40.00th=[   71], 50.00th=[   84], 60.00th=[   96],
        | 70.00th=[  111], 80.00th=[  132], 90.00th=[  169], 95.00th=[  207],
        | 99.00th=[  305], 99.50th=[  342], 99.90th=[  447], 99.95th=[  481],
        | 99.99th=[  558]
      bw (  KiB/s): min=    7, max=   88, per=2.21%, avg=25.07, stdev=12.02, samples=16236
      iops        : min=    1, max=   22, avg= 6.22, stdev= 3.01, samples=16236
     write: IOPS=122, BW=490KiB/s (502kB/s)(86.2MiB/180231msec)
       clat (msec): min=11, max=879, avg=168.64, stdev=104.22
        lat (msec): min=11, max=879, avg=168.64, stdev=104.22
       clat percentiles (msec):
        |  1.00th=[   31],  5.00th=[   50], 10.00th=[   64], 20.00th=[   85],
        | 30.00th=[  104], 40.00th=[  123], 50.00th=[  144], 60.00th=[  167],
        | 70.00th=[  199], 80.00th=[  241], 90.00th=[  309], 95.00th=[  376],
        | 99.00th=[  514], 99.50th=[  567], 99.90th=[  709], 99.95th=[  751],
        | 99.99th=[  869]
      bw (  KiB/s): min=    7, max=   40, per=2.61%, avg=12.76, stdev= 5.79, samples=13761
      iops        : min=    1, max=   10, avg= 3.14, stdev= 1.47, samples=13761
     lat (msec)   : 10=0.04%, 20=1.59%, 50=15.47%, 100=35.26%, 250=40.55%
     lat (msec)   : 500=6.70%, 750=0.36%, 1000=0.02%
     cpu          : usr=0.01%, sys=0.84%, ctx=92109, majf=0, minf=5464
     IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
        submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
        complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
        issued rwts: total=51029,22075,0,0 short=0,0,0,0 dropped=0,0,0,0
        latency   : target=0, window=0, percentile=100.00%, depth=1
   
   Run status group 0 (all jobs):
      READ: bw=1133KiB/s (1160kB/s), 1133KiB/s-1133KiB/s (1160kB/s-1160kB/s), io=199MiB (209MB), run=180231-180231msec
     WRITE: bw=490KiB/s (502kB/s), 490KiB/s-490KiB/s (502kB/s-502kB/s), io=86.2MiB (90.4MB), run=180231-180231msec
   
   Disk stats (read/write):
       dm-2: ios=51031/22148, merge=0/0, ticks=4834272/3782169, in_queue=8625017, util=95.13%, aggrios=51263/22179, aggrmerge=10/3, aggrticks=5127232/3853583, aggrin_queue=8980823, aggrutil=95.39%
     sda: ios=51263/22179, merge=10/3, ticks=5127232/3853583, in_queue=8980823, util=95.39%
    
   ```

#### 4.1.2 IOPS 指标与吞吐量关系

1. 磁盘的 IOPS，即一秒内，磁盘进行多少次 I/O 读写

   > IOPS 可细分为如下几个指标

   * Toatal IOPS，**混合读写和顺序随机I/O负载情况下的磁盘IOPS，这个与实际I/O情况最为相符，大多数应用关注此指标。**
   * Random Read IOPS，100%随机读负载情况下的 IOPS。
   * Random Write IOPS，100%随机写负载情况下的 IOPS。
   * Sequential Read IOPS，100%顺序读负载情况下的 IOPS。
   * Sequential Write IOPS，100%顺序写负载情况下的 IOPS。

2. 磁盘的吞吐量，也就是每秒磁盘 I/O 的流量，即磁盘写入加上读出的数据的大小。

3. 每秒 I/O 吞吐量 = IOPS * 平均 I/O SIZE

4. IOPS的计算公式

   > 对于磁盘来说一个完整的 IO 操作包括 `寻址时间`，`旋转延时`，`传送时间`

   IO Time = Seek Time + 60 sec/Rotational Speed/2 + IO Chunk Size/Transfer Rate

   IOPS = 1/IO Time = 1/(Seek Time + 60 sec/Rotational Speed/2 + IO Chunk Size/Transfer Rate)

[磁盘性能评价指标—IOPS和吞吐量](https://blog.csdn.net/hanchengxi/article/details/19089589)

[吞吐量和 IOPS 及测试工具 FIO 使用](https://www.cnblogs.com/hukey/p/12714113.html)

> **NOTE**:要善于使用 `hdparm`、`smartctl`、`fdisk` 等工具熟悉硬盘的各种信息。如：
>
> ```
> smartctl -a -d megaraid,0 /dev/sda
> ```
>
> https://ostechnix.com/how-to-find-hard-disk-drive-details-in-linux/

#### 4.1.3 各磁盘接口类型的关键信息一览表

1. **IOPS一览表**

| 硬盘接口类型  | IOPS |
| ------------- | ---- |
| FC 15K RPM    | 180  |
| FC 10K RPM    | 140  |
| SAS 15K RPM   | 180  |
| SAS 10K RPM   | 150  |
| SATA 10K RPM  | 290  |
| SATA 7.2K RPM | 80   |
| SATA 5.4K RPM | 40   |
| Flash drive   | 2500 |

2. **寻道时间一览表**

| 硬盘接口类型 | 平均物理寻道时间 |
| ------------ | ---------------- |
| 7200转/分    | 9ms              |
| 10000转/分   | 6ms              |
| 15000转/分   | 4ms              |

3. **旋转延迟时间一览表**

| 硬盘接口类型 | 平均旋转延迟时间        |
| ------------ | ----------------------- |
| 7200转/分    | 60*1000/7200/2 = 4.17ms |
| 10000转/分   | 60*1000/10000/2 = 3ms   |
| 15000转/分   | 60*1000/15000/2 = 2ms   |

#### 4.1.4  4*1 分布式硬件环境

| 服务器      | 服务器信息                                                   | 备注 |
| ----------- | ------------------------------------------------------------ | ---- |
| 10.10.1.101 | CPU: `GenuineIntel Intel(R) Xeon(R) 2.40GHz 2*4` MEM: `16G ` DISK: `Dell PERC H700 2.10` |      |
| 10.10.1.105 | CPU: `GenuineIntel Intel(R) Xeon(R) 2.40GHz 4*1` MEM: `32G` DISK: `DELL PERC H310 2.12 SPC-3` |      |
| 10.10.1.226 | CPU: `GenuineIntel Intel(R) Xeon(R) 1.80GHz 4*2` MEM: `32G` DISK: `DELL PERC H310 2.12 SPC-3` |      |
| 10.10.1.228 | CPU: `GenuineIntel Intel(R) Xeon(R) 1.80GHz 4*2` MEM: `32G` DISK: `DELL PERC H310 2.12 SPC-3` |      |

### 4.2 软件基准测试

```
2020-12-30 10:10:41 INFO put object 041452064-19700101-22060723 0.23012250382453203s
2020-12-30 10:10:42 INFO put object 041453001-19700101-22060723 0.24286351446062326s
2020-12-30 10:10:42 INFO put object 041453002-19700101-22060723 0.21933304797858s
2020-12-30 10:10:43 INFO put object 041453003-19700101-22060723 0.18300578836351633s
2020-12-30 10:10:43 INFO put object 041453004-19700101-22060723 0.22276652418076992s
2020-12-30 10:10:44 INFO put object 041453005-19700101-22060723 0.2399271773174405s
2020-12-30 10:10:44 INFO put object 041453006-19700101-22060723 0.191570152528584s
2020-12-30 10:10:45 INFO put object 041453007-19700101-22060723 0.2451731665059924s
2020-12-30 10:10:47 INFO put object 041453008-19700101-22060723 0.2871444383636117s
2020-12-30 10:10:47 INFO put object 041453009-19700101-22060723 0.22854785341769457s
2020-12-30 10:10:48 INFO put object 041453010-19700101-22060723 0.23045704513788223s
2020-12-30 10:10:48 INFO put object 041453011-19700101-22060723 0.2558949710801244s
2020-12-30 10:10:49 INFO put object 041453012-19700101-22060723 0.15720008313655853s
2020-12-30 10:10:49 INFO put object 041453013-19700101-22060723 0.3031325815245509s
2020-12-30 10:10:50 INFO put object 041453014-19700101-22060723 0.29556100256741047s
2020-12-30 10:10:50 INFO put object 041453015-19700101-22060723 0.24312557838857174s
2020-12-30 10:10:51 INFO put object 041453016-19700101-22060723 0.24582980014383793s
```

> 通过搭建minio分布式存储系统，进行实际数据写入测试，得出如下结论：minio在较老的硬件上，其性能表现不佳，不如 glusterfs，最好使用其官方网站推荐的硬件。这其中一个因素是其采用纠删码机制，需要对文件进行分割合并，相较于单纯的文件拷贝性能会低一些，对于大规模的云场景，其采用摊提平均后，性能会非常的可观。另外目前minio还处于高速的跌代期，还存在许多的问题。其发展前景很不错，但目前不太适合我们。



