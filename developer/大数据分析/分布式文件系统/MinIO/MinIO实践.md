## 一、服务端的配置

### 1.1 单机版的安装

### 1.2 集群的安装

> 注意集群时，minio 实例数的编排，以及集群扩展的机制。
>
> https://github.com/minio/minio/blob/master/docs/zh_CN/distributed/README.md

#### 1.2.1 基本诊断

> https://github.com/minio/minio/blob/master/docs/zh_CN/debugging/README.md

#### 1.2.2 环境配置的调优

> https://github.com/minio/minio/blob/master/docs/zh_CN/deployment/kernel-tuning/README.md

#### 1.2.3 启动磁盘缓存
> https://github.com/minio/minio/blob/master/docs/zh_CN/disk-caching/README.md

#### 1.2.4 MinIO服务器限制

> 对 MinIO 的服务根据实际情况，做相应的限制
>
> https://github.com/minio/minio/blob/master/docs/zh_CN/throttle/README.md

#### 1.2.5 使用 tls 做安全验证


## 二、客户端的使用

1. 注意 python 版本的兼容，使用 3.7.5

## 三、MinIO 使用注意事项

### 3.1 MinIO 的缓存机制

>默认情况下，对象缓存处于以下设置状态

- 缓存大小是你内存大小的一半，不过如果你的内存小于8G的话，缓存是不开启的。
- 缓存对象的过期时间是72小时。
- 每次过期时间的1/4时间点（每18小时）出发一次过期对象垃圾回收清理。

注意：上述配置不支持手动修改。

> https://github.com/minio/minio/blob/master/docs/zh_CN/caching/README.md

### 3.2 MinIO 的压缩机制

> https://github.com/minio/minio/blob/master/docs/zh_CN/compression/README.md

### 3.3 MinIO 分布式容错校验

## 四、辅助工具的使用

### 4.1 mc 工具使用

