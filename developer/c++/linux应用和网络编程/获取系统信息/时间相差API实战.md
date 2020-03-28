## time
1. time能得到一个当前时间距离标准起点时间 1970-01-01 00:00:00 +0000(UTC)过去了多少秒。
## ctime
1. ctime可以从time_t出发得到一个容易观察的字符串格式中的当前时间。
2. ctime的时间格式是固定的。
3. ctime已经考虑到了本地时间的形式。

## gmtime
1. gmtime获取的时间中：年份是以1970为基准的差值，月份是0表示1月，小时数是以UTC时间的0时区为标准的小时数。
2. localtime和gmtime的差别在于时区。

## asctime
1. asctime和ctime的效果一样，得到的字符串都是格式的。
2. 需要格式化的，需要使用strftime

## gettimeofday
1. 前面获得的时间都是以秒为单位的，而gettimeofday可以获得以微秒为单位的时间。

