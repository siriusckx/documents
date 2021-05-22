<center><h3>文档修改记录</h3></center>

| 日期       | 版本号 | 作者   | 操作                         | 说明 |
| ---------- | ------ | ------ | ---------------------------- | ---- |
| 2021-01-08 | v1.0.0 | 程开雄 | 创建                         |      |
| 2021-01-08 | v1.0.1 | 程开雄 | 增加多次内存分配数据统计分析 |      |

## 1. 操作系统内存分配机制

> 操作系统分配内存的时候，是一块一块分配的，在具体内存分配的过程中，如果未使用内存池技术或使用得不好，则会导致大量的内存碎片。现使用 malloc 对内存进行分配，以查看操作系统实际每次对内存分配的情况。

### 测试环境

```shell
[root@localhost test]# cat /etc/os-release 
NAME="CentOS Linux"
VERSION="7 (Core)"
ID="centos"
ID_LIKE="rhel fedora"
VERSION_ID="7"
PRETTY_NAME="CentOS Linux 7 (Core)"
ANSI_COLOR="0;31"
CPE_NAME="cpe:/o:centos:centos:7"
HOME_URL="https://www.centos.org/"
BUG_REPORT_URL="https://bugs.centos.org/"

CENTOS_MANTISBT_PROJECT="CentOS-7"
CENTOS_MANTISBT_PROJECT_VERSION="7"
REDHAT_SUPPORT_PRODUCT="centos"
REDHAT_SUPPORT_PRODUCT_VERSION="7"
```
## 1.1 malloc 单次内存分配

### 1.1.1 测试方法

> 每次手动申请内存，观察对应程序分配内存情况，再对申请内存进行释放，再观察分配内存的情况。

1. 测试代码

```cpp
[root@localhost test]# cat memory.cpp 
#include <stdio.h>      /* printf, scanf, NULL */
#include <stdlib.h>     /* malloc, free, rand */
#include <unistd.h>

int main ()
{
    int i,n;
    char * buffer;

    printf ("How long do you want the string? ");
    scanf ("%d", &i);
    
    buffer = (char*) malloc (i+1);
    if (buffer==NULL) exit (1);
    for (n=0; n<i; n++)
        buffer[n]=rand()%26+'a';
    buffer[i]='\0';
    
    printf("malloc size: %d\n", (i+1));
    sleep(30);
    free (buffer);
    printf ("memory release: %d\n",(i+1));
    
    sleep(30);
    return 0;
}
```

2. 如下命令观察内存

```shell
top -Hp $pid
```

### 1.1.2 测试数据 

| malloc 分配字符数  | 实际SHR KiB          | 实际RES KiB            | 实际VIRT KiB            | 实际分配大小 KiB  |
| ------------------ | -------------------- | ---------------------- | ----------------------- | ----------------- |
| 程序初始大小       | 276                  | 352 or 348             | 4220                    | -                 |
| 1 B                | 276                  | 352 or 348             | 4352                    | 132               |
| 100 B              | 276                  | 352 or 348             | 4352                    | 132               |
| 1024 B (1 KiB)     | 276                  | 352 or 348             | 4352                    | 132               |
| 2048 B (2 KiB)     | 276                  | 352                    | 4352                    | 132               |
| 4096 B (4 KiB)     | 276                  | 352 or 348             | 4356                    | **132  + 4**      |
| 8192 B (8 KiB)     | 276                  | 352 or 348             | 4360                    | 132  + 8          |
| 12288 B (12 KiB)   | 276                  | 352 or 348             | 4364                    | 132  + 12         |
| 65536 B (64 KiB)   | 276                  | 352 or 348             | 4416                    | 132 + 64          |
| 131072 B (128 KiB) | 424                  | 612<----free---->532   | 4352                    | **132 = 128 + 4** |
| 262144 B (256 KiB) | 424<----free---->436 | 608<----free---->528   | 4480<----free---->4220  | 256 +4            |
| 263168 B (257 KiB) | 424                  | 612                    | 4480                    | **256+4**         |
| 524288 B (512KiB)  | 436                  | 876                    | 4736                    | 512 + 4           |
| 1048576 B (1 MiB)  | 424                  | 1400                   | 5248                    | 1024 +4           |
| 67108864 B(64 MiB) | 424                  | 65820<----free---->532 | 69760<----free---->4220 | 64M + 4K          |

### 1.1.3 测试结果

**从测试数据分析**：操作系统为程序分配内存时，最小内存分配单位为 `4KiB` 其规律如下：

```mermaid
graph TD
A[程序向操作系统内存申请]
C1{ malloc < 4KiB}
C2{4KiB <= malloc < 128KiB}
C3{ malloc >= 128KiB}
B[分配132KiB]
D[分配132KiB + 满足最小申请内存数量]
E[满足最小申请内存+冗余4KiB]
A-->C1
A-->C2
A-->C3
C1-->B
C2-->D
C3-->E
```

**NOTE**:对于常驻内存和共享内存是怎么变换的，这个换页机制，还有待研究。

## 1.2 malloc 多次内存分配

### 1.2.1 测试方法

> 每次手动申请内存，分配完成后，观察对应程序分配内存情况，每次申请 100W 次。

```
[root@localhost test]# cat memory.cpp 
#include <stdio.h>      /* printf, scanf, NULL */
#include <stdlib.h>     /* malloc, free, rand */
#include <unistd.h>

int main ()
{
    int i,n;
    char * buffer;

    while(true)
    {
        printf ("How long do you want the string? ");
        scanf ("%d", &i);
        for(int j=0; j<1000000; ++j)
        {
            buffer = (char*) malloc (i+1);
            if (buffer==NULL) exit (1);
            for (n=0; n<i; n++)
                buffer[n]=rand()%26+'a';
            buffer[i]='\0';
        }
   
        printf("100W malloc size: %d\n", (i+1));
        sleep(30);
   
    }

    return 0;
}
```

### 1.2.2 测试数据

| malloc 分配字符数(100W次) | 实际申请总大小 MiB | 实际SHR KiB | 实际RES KiB | 实际VIRT KiB | 实际 VIRT MiB |
| ------------------------- | ------------------ | ----------- | ----------- | ------------ | ------------- |
| 程序初始大小              | 程序初始大小       | 276         | 352 or 348  | 4220         |               |
| 10B                       | 9.537              | 432         | 31764       | 35504        | 30.55078125   |
| 20B                       | 19.074             | 432         | 31760       | 35504        | 30.55078125   |
| 30B                       | 28.611             | 432         | 47340       | 51212        | 45.890625     |
| 60B                       | 57.222             | 432         | 78488       | 82364        | 76.3125       |
| 100B                      | 95.37              | 436         | 109908      | 113648       | 106.8632813   |
| 120B                      | 114.444            | 432         | 125444      | 129224       | 122.0742188   |
| 180B                      | 171.666            | 432         | 188016      | 191792       | 183.1757813   |
| 200B                      | 190.74             | 432         | 203592      | 207368       | 198.3867188   |
| 300B                      | 286.11             | 432         | 312848      | 316796       | 305.25        |
| 250B                      | 238.425            | 432         | 266120      | 269936       | 259.4882813   |
| 500B                      | 476.85             | 440         | 500536      | 504236       | 488.296875    |
| 750B                      | 715.275            | 440         | 750540      | 754244       | 732.4453125   |

![mallc.one.png](./img/malloc.one.png)

| malloc 分配字符数(100W次) | 实际申请总大小 MiB | 实际SHR KiB | 实际RES KiB | 实际VIRT KiB | 实际 VIRT MiB |
| ------------------------- | ------------------ | ----------- | ----------- | ------------ | ------------- |
| 程序初始大小              | 程序初始大小       | 276         | 352 or 348  | 4220         |               |
| 10B                       | 9.537              | 432         | 31764       | 35504        | 30.55078125   |
| 10B + 10B                 | 19.074             | 444         | 62916       | 66788        | 61.1015625    |
| 10B + 10B + 10B           | 28.611             | 444         | 94068       | 98072        | 91.65234375   |
| 60B                       | 57.222             | 432         | 78488       | 82364        | 76.3125       |
| 100B                      | 95.37              | 436         | 109908      | 113648       | 106.8632813   |
| 60B + 60B                 | 114.444            | 444         | 156592      | 160508       | 152.625       |
| 60B + 60B + 60B           | 171.666            | 444         | 234728      | 238652       | 228.9375      |
| 100B + 100B               | 190.74             | 444         | 219168      | 223076       | 213.7265625   |
| 100B + 100B + 100B        | 286.11             | 444         | 328420      | 332372       | 320.4609375   |
| 250B                      | 238.425            | 432         | 266120      | 269936       | 259.4882813   |
| 250B+250B                 | 476.85             | 444         | 531680      | 535520       | 518.8476563   |
| 250B + 250B + 250B        | 715.275            | 444         | 797264      | 801104       | 778.2070313   |

![malloc.two.png](.\img\mallc.two.png)

### 1.2.3 测试结果

**从测试数据分析**：

程序启动一次，申请一批，一批申请分配 100W 次内存，分配的总内存会比申请的总内存由最初的 3 倍左右到逐渐与申请的内存大小相近，随着申请内存的总量接近 750M 时，差距在 10MiB~30MiB 左右，相对来说还较为集中，碎片化程度还不是太大（应该有更先进的工具来分析，这个还需要进一步研究）。

程序启动一次，分多批申请，一批申请分配 100W 次内存，相对前一种只申请一批的情况，申请同样大小的内存，分多批次分配的内存较大，可以看出内存碎片程度较大一些，由申请的小内存最初的 3 倍左右，到逐渐与申请的内存大小相匹配，随着申请内存的总量接近 750M 时，差距在30MiB ~ 60MiB 左右。而在真实的生产中，程序会一次启动，可能会跑很久，碎片程度要比这个严重得多。

## 1.3 new 裸指针多次内存分配

### 1.3.1 测试代码

```
#include <stdio.h>      /* printf, scanf, NULL */
#include <stdlib.h>     /* malloc, free, rand */
#include <unistd.h>
#include <iostream>
#include <memory>
#include <vector>
using namespace std;

struct Demo
{
    long a;
    Demo(int ta):a(ta){}
};
typedef std::shared_ptr<Demo> DemoPtr;

int TIMES = 1000000;

int main ()
{
   std::cout<<"demo size:"<<sizeof(Demo)<<endl;
   std::cout<<"demo* size:"<<sizeof(Demo*)<<endl;
   std::vector<Demo*> lst;
   lst.resize(TIMES);
   sleep(30);
   std::cout<<"ready create obj"<<endl;
   long size = 0;
   for(int i=0;i <TIMES; i++)
   {   
       Demo* d=new Demo(1);
       lst[i]=d;
       size+=sizeof(Demo);
       size+=sizeof(Demo*);
   }   
   std::cout<<"total size:" << size << std::endl;
   sleep(30);

   return 0;
}
```

```shell
编译代码:
g++ -std=c++11 test_vector_ptr_min.cpp

使用boost::shared_ptr时例子
g++ -lboost_system -std=c++11 test_vector_ptr_min.cpp

使用 jemalloc 时例子
g++ -ljemalloc -lboost_system -std=c++11 test_vec_ptr_str_boost_gt4.cpp -o jemalloc.gt4.out
```



### 1.3.2 测试数据

| 是否使用 jemalloc | 程序未创建对象大小(KiB) | vector存100W个Demo*大小(B) | 程序物理内存大小（KiB） | 冗余内存比例（多次数据相似）                          |
| ----------------- | ----------------------- | -------------------------- | ----------------------- | ----------------------------------------------------- |
| 否                | 8988                    | 16,000,000                 | 40140                   | ((40140-8988)*1024-16,000,000)/16,000,000\*100%=99.4% |
| 是                | 9004                    | 16,000,000                 | 17188                   | 基本没什么浪费，vector在存数据时还不计算指针大小      |

## 1.4 std::sharted_ptr智能指针内存分配

### 1.4.1 测试代码

```c++
#include <stdio.h>      /* printf, scanf, NULL */
#include <stdlib.h>     /* malloc, free, rand */
#include <unistd.h>
#include <iostream>
#include <memory>
#include <vector>
using namespace std;

struct Demo
{
    long a;
    Demo(int ta):a(ta){}
};
typedef std::shared_ptr<Demo> DemoPtr;

int TIMES = 1000000;

int main ()
{
   std::cout<<"demo size:"<<sizeof(Demo)<<endl;
   std::cout<<"demoptr size:"<<sizeof(DemoPtr)<<endl;
   std::vector<DemoPtr> lst;
   lst.resize(TIMES);
   sleep(30);
   std::cout<<"ready create obj"<<endl;
   long size = 0;
   for(int i=0;i <TIMES; i++)
   {   
       DemoPtr d=std::shared_ptr<Demo>(new Demo(1));
       lst[i]=d;
       size+=sizeof(Demo);
       size+=sizeof(DemoPtr);
   }   
   std::cout<<"total size:" << size << std::endl;
   sleep(30);

   return 0;
}
```

### 1.4.2 测试数据

| 是否使用 jemalloc | 程序未创建对象大小(KiB) | vector存100W个DemoPtr大小(B) | 程序物理内存大小（KiB） | 冗余内存比例（多次数据相似）                           |
| ----------------- | ----------------------- | ---------------------------- | ----------------------- | ------------------------------------------------------ |
| 否                | 16640                   | 24,000,000                   | 79208                   | ((79208-16640)*1024-24,000,000)/24,000,000\*100%=167%  |
| 是                | 16928                   | 24,000,000                   | 57056                   | ((57056-16928)*1024-24,000,000)/24,000,000\*100%=71.2% |

## 1.5 结构体内存分配

### 1.5.1 测试代码

```c++
#include <stdio.h>      /* printf, scanf, NULL */
#include <stdlib.h>     /* malloc, free, rand */
#include <unistd.h>
#include <iostream>
#include <memory>
#include <vector>
using namespace std;

struct Demo
{
    long a;
    Demo(int ta):a(ta){}
};
typedef std::shared_ptr<Demo> DemoPtr;

int TIMES = 1000000;

int main ()
{
   std::cout<<"demo size:"<<sizeof(Demo)<<endl;
   std::vector<Demo> lst;
   lst.resize(TIMES);
   sleep(30);
   std::cout<<"ready create obj"<<endl;
   long size = 0;
   for(int i=0;i <TIMES; i++)
   {   
       Demo d(1);
       lst[i]=d;
       size+=sizeof(Demo);
   }   
   std::cout<<"total size:" << size << std::endl;
   sleep(30);

   return 0;
}
```
### 1.5.2 测试数据

| 是否使用 jemalloc | 程序未创建对象大小(KiB) | vector存100W个Demo*大小(B) | 程序物理内存大小（KiB） | 冗余内存比例（多次数据相似） |
| ----------------- | ----------------------- | -------------------------- | ----------------------- | ---------------------------- |
| 否                | 8984                    | 8,000,000                  | -                       | top 常驻物理内存，预先分配   |
| 是                | 8984                    | 8,000,000                  | -                       | top 常驻物理内存，预先分配   |

## 总结

1. 在使用智能指针包装数据，在将包装后的智能指针放入 `vector` 时，如果数据比较小，在数据条数比较多的时候会造成大量的内存浪费，基本在 `30% ~ 50%` 左右。使用结构体，则不会造成空间的浪费，要注意的是对结构体的拷贝操作。

## 进一步研究

1. C++ Vector 内存分配机制

2. 智能指针内存分配回收机制

3. new 和 delete 内存分配回收机制

4. 智能指针和裸指针放入 vector 为何在某些场景下裸指针占内存反而更大，此时的内存布局是什么样的

5. 字符串片段在内存中是如何分配的

6. 智能指针、裸指针、结构体之间的转换

7. 栈内存和堆内存分配机制，对于 vector 来说是否一致

   

