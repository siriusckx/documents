# 注意事项
1. 忽略模式的使用
  [自建同步服务syncthing的忽略模式语法](https://blog.csdn.net/mingyizhan/article/details/92806121)

  > 对于忽略模式的使用，当syncthing重启后，syncthing的过滤规则会被丢弃掉（原因可能是.strignore文件被删除），使用syncthing同步文件的过程中要特别注意，一般采用同步文件的策略使用正向思维，即需要什么则配置什么，尽量不要采用反向思维，即不需要什么，排除什么等。

  > 在使用的过程中，有时会出现文件冲突，此时需要手动点击一下进行冲突处理。

2. 同步时间的理解
> 监视文件大概10s钟刷新一次
> 如果需要特殊的同步，可将目录设置小一些1s钟刷新一次。

