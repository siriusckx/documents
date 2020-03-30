1. 时区设置不对，导致程序获取时间不对
   >由于时区设置得不对，导致程序在获取时间的时候，会根据不同的时区计算出不同的时间出来。依赖于时间的程序，则会有问题。

2. 调用底层函数发送数据的时候，如果发送数据量过大时，会导致发送不出去，报broken错误。
   ```
    [Errno 32] Broken pipe done
   ```

3. 出现大量的`rcuoa/rcuob`进程
   > 这个不是一个问题，可能根据系统使用的情况来定。
   
   >https://www.cnblogs.com/hxlasky/p/10785720.html  
   >https://askubuntu.com/questions/523025/what-are-the-rcuos-rcuob-processes-im-seeing-in-top  
   >https://lwn.net/Articles/522262/
