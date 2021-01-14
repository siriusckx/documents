## 优化选项配置（这些参数还未经验证）

1. 客户端元数据缓存（md-cache）

   > 主要作用于fuse和smb应用，具有较好的效果。

   ```
   md-cache
   
   md-cache allows client-site caching and invalidates the cache by receiving events from the server.
   
   Allow multiple threads for each client
   gluster volume set <volume> client.event-threads <value> (default: 2)
    
   
   Allow the server to use multiple threads for a volume
   gluster volume set <volume> server.event-threads <value> (default: 1)
   
   gluster volume set <volname> features.cache-invalidation on (default: off)
   gluster volume set <volname> features.cache-invalidation-timeout 600 (default: 60)
   gluster volume set <volname> performance.stat-prefetch on (default: on)
   gluster volume set <volname> performance.cache-invalidation on (default: false)
   gluster volume set <volname> performance.md-cache-timeout 600 (default: 1)
   ```

   

2. 目录项预读（readdir-ahead）

   > 打开目录时，预读其目录项返回客户端，加速目录项读取。

3. 复合操作（use-compound-fops）

   > 适用于副本卷，用于减少网络往返通信次数。

4. 消极查询缓存（nl-cache）

   > 在客户端缓存查找结果，加速查询操作，主要用于fuse和smb协议。

[Glusterfs小文件问题剖析](https://mp.weixin.qq.com/s/xEGcW2NC6XX8_9q2fbqZkw)

[Glusterfs 优化](https://vanderzee.org/linux/article-170626-141044/article-171031-113239/article-171212-095104)

[](https://mp.weixin.qq.com/s/zpsoh3p15DgJHj8EWRkQhA)

