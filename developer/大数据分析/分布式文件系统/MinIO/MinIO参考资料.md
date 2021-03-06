[基于 Go 开源项目 MIMIO 的对象存储方案在探探的实践](https://www.sohu.com/a/346007469_657921)

#### 优化思路：

1. 把原来随机写的小文件改成顺序写大文件，这样就能解决这个问题，利用page Cache 来提供磁盘的性能。

   > 顺序写比随机写性能高几百倍
   >
   > 磁盘性能简单说一下结论，磁盘在顺序读写的时候是非常快的，磁盘最大的耗时是在寻道上面，如果我们做到数据读的话速度也很快，是因为有 page Cache。

#### 存储选型

1. 需要了解存储系统的原理

2. 对存储系统做基准测试（cosBench, FIO）

   > 压测结果要很长时间才能稳定下来，做压测的时候，要留意一下。

#### MinIO一些重要的点

1. MinIO将数据和元数据作为对象一起写入，从而无需使用元数据数据库

#### 做一些知识储备

1. 全面了解 IO

   * IO 流程

   * Buffered IO vs Direct IO

   * Page Cache

   * IO Scheduler

   * 磁盘性能

   * 参数调优
1. [k8s相关文档](https://www.kubernetes.org.cn/k8s)
1. [kupernetes 中文文档](https://kubernetes.io/zh/docs/home/)
1. [Minio中国镜像](http://dl.minio.org.cn/server/minio/release/linux-amd64/)
1. [什么是对象存储？看这一篇就够了](https://www.sohu.com/a/391960620_505795)

