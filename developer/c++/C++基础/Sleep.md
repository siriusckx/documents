## C++中调用睡眠函数

```
//头文件
#ifdef WIN32
#include "windows.h"
#else
#include "unistd.h"
#endif

//睡眠的时间
#ifdef WIN32
    Sleep(5); //睡眠5ms
#else
    usleep(5); //睡眠5us
#endif
```