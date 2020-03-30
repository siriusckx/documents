## jiffies的引入
1. jiffies是linux内核中的一个全局变量，这个就是用来记录以jiffies为单位时间长度的一个数值。
2. 内核暑假定义了一个节拍时间，实际上linux内核的调度系统工作时就是以这个节拍时间为时间片的。
3. jiffies变量开机时有一个基准值，然后内核每过一个节拍时间jiffies就回加1，然后到了系统的任意一个时间我们当前时间就被jiffies这个变量所标注。


## linux系统如何记录时间
1. 内核在开机启动的时候会读取RTC硬件获取一个时间作为初始基准时间，这个基准时间对应一个jiffies值（这个基准时间换算成jiffies值的方法是：用这个时间减去 1970-01-01 00：00：00： +0000（UTC）然后把这个时间段换算成jiffies数值），这个jiffies值作为我们开机时的基准jiffies值存在。然后系统运行时每个时钟节拍的末尾都会给jiffies这个全局变量加1，因此操作系统就使用jiffies这个全局变量记录了下来当前的时间。当我们需要当前时间点时，就用jiffies这个时间点去计算（计算方法就是先把这个jiffies值对应的时间段算出来，然后加上1970-01-01 00：00：00： +0000（UTC）这个时间的差值）
2. 其实操作系统只在开机时读一次RTC，整个系统运行过程中RTC是无作用的。RTC的真正作用其实就是OS的2次开机之间进行时间的保存。
3. 理解时一定要点时间和段时间结合起来理解。jiffies这个变量记录的其实是段时间（其实就是当前时间和1970-01-01 00：00：00： +0000（UTC）这个时间的差值）
4. 一个时间节拍的时间取决于操作系统的设置，现代linux系统一般是10ms或者1ms。这个时间主是调度时间，在内核中用HZ来记录和表示。如果HZ定义成1000,那么时钟节拍就是1/HZ，也就是1ms。

## linux中时间相关的系统调用
> 常用的时间相关的API和库函数有9个：time,ctime,localtime,gtime,mktime,asctime,strftime,gettimeofday,settimeofday

1. 系统调用返回当前时间以秒为单位的距离1970年的秒数。
 1. 将把time得到的秒数变成一个struct tm结构体表示的时间，区别是gmtime得到的是国际时间。localtime得到的是本地时间。mktime用来完成相反方向的转换。
1. 如果从struct tm出发想得到字符串格式的时间，可以用asctime,strftime.
1. gettimeofday返回的时间是由struct timeval和struct timezone这两个结构体来共同表示的，其中timeval表示时间，而timezone表示时区。settimeofday是用来设置当前的时间和时区的。

    