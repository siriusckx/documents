# 1 C++ #pragma 预处理指令
> 本文转载自：https://www.cnblogs.com/runningRain/p/5936788.html  

> #pragma 预编译指令的作用是设定编译器的状态或者是指示编译器完成一些特定的动作。#pragma指令对每个编译器给出了一个方法，在保持与C和C++语言完全兼容的情况下，给出主机或操作系统专有的特征。

>其使用的格式一般为: #pragma Para。其中Para 为参数，常见的参数如下：

# 2 #pragma 参数
## 2.1 Message参数
> Message参数编译信息输出窗口中输出相应地信息，使用方法如下：
```
#pragma message("消息文本")
```
>使用示例，假如在程序中我们定义了很多宏来控制源代码版本的时候，我们自己有可能都会忘记有没有正确的设置这些宏，此时我们可以用这条指令在编译的时候就进行检查。假设我们希望判断自己有没有在源代码的什么地方定义了_X86这个宏可以用下面的方法：
```
#ifdef _X86
#pragma message("_X86 macro activated!")
#endif
```

## 2.2 code_seg参数
> code_seg参数可以设置程序中函数代码存放的代码段，使用方式如下：
```
#pragma code_seg(["section-name"[,"section-class"]])
```

## 2.3 once 参数
> 其作用是在在头文件的最开始加入这条指令，以保证头文件被编译一次。但#program once是编译器相关的，就是说在这个编译系统上能用，但在其他的编译系统上就不一定能用，所以其可移植性较差。一般如果强调程序跨平台，还是选择使用“#ifndef,   #define,   #endif”比较好。

## 2.4 hdrstop
> #program hdrstop表示预编译头文件到此为止，后面的头文件不进行编译。

## 2.5 resource 
>#program resource  “*.dfm”表示把*.dfm文件中的资源添加到工程。

## 2.6 comment
> #program comment将一个注释记录放入一个对象文件或可执行文件。

## 2.7 data_seg
> #program data_seg用来建立一个新的数据段并定义共享数据。如下：
```
#pragma data_seg（"shareddata")
HWNDsharedwnd=NULL;//共享数据
#pragma data_seg()
```
>**说明**：a. #pragma data_seg()一般用于DLL中。也就是说，在DLL中定义一个共享的有名字的数据段。最关键的是：这个数据段中的全局变量可以被多个进程共享,否则多个进程之间无法共享DLL中的全局变量。  
> b. 共享数据必须初始化，否则微软编译器会把没有初始化的数据放到.BSS段中，从而导致多个进程之间的共享行为失败。例如:

```
#pragma data_seg("MyData")
intg_Value;　　　　//Note that the global is not initialized.
#pragma data_seg()
//DLL提供两个接口函数：
int GetValue()
{
    return g_Value;
}
void SetValue(int n)
{
    g_Value=n;
}
```
>**解释**：启动两个进程A和B，A和B都调用了这个DLL，假如A调用了SetValue(5); B接着调用int m = GetValue(); 那么m的值不一定是5，而是一个未定义的值。因为DLL中的全局数据对于每一个调用它的进程而言，是私有的，不能共享的。假如你对g_Value进行了初始化，那么g_Value就一定会被放进MyData段中。换句话说，如果A调用了SetValue(5); B接着调用int m = GetValue(); 那么m的值就一定是5，这就实现了跨进程之间的数据通信。

## 2.8 region
> #program region用于折叠特定的代码段，示例如下：

```
#pragma region Variables
HWND hWnd;
const size_t Max_Length = 20;
//other variables
#pragma endregion This region contains global variables.
```

## 2.9 pack
> **应用实例**：在网络协议编程中，经常会处理不同协议的数据报文。一种方法是通过指针偏移的方法来得到各种信息，但这样做不仅编程复杂，而且一旦协议有变化，程序修改起来也比较麻烦。在了解了编译器对结构空间的分配原则之后，我们完全可以利用这一特性定义自己的协议结构，通过访问结构的成员来获取各种信息。这样做，不仅简化了编程，而且即使协议发生变化，我们也只需修改协议结构的定义即可，其它程序无需修改，省时省力。下面以TCP协议首部为例，说明如何定义协议结构。

>协议的定义结构如下：
```
#pragma pack(1)　　//按照1字节方式进行对齐
struct TCPHEADER
{
shortSrcPort;　　//16位源端口号
shortDstPort;　　//16位目的端口号
intSerialNo;　　//32位序列号
intAckNo;　　　　//32位确认号
unsignedcharHaderLen:4;　　//4位首部长度
unsignedcharReserved1:4;　　//保留16位中的4位
unsignedcharReserved2:2;　　//保留16位中的2位
unsignedcharURG:1;
unsignedcharACK:1;
unsignedcharPSH:1;
unsignedcharRST:1;
unsignedcharSYN:1;
unsignedcharFIN:1;
shortWindowSize;　　//16位窗口大小
shortTcpChkSum;　　//16位TCP检验和
shortUrgentPointer;　　//16位紧急指针
};
#pragm apop()　　//取消1字节对齐方式
```
>#pragma pack规定的对齐长度，实际使用的规则是： 结构，联合，或者类的数据成员，第一个放在偏移为0的地方，以后每个数据成员的对齐，按照#pragma pack指定的数值和这个数据成员自身长度中，比较小的那个进行。 但是，当#pragma pack的值等于或超过最长数据成员的长度的时候，这个值的大小将不产生任何效果。 而结构整体的对齐，则按照结构体中最大的数据成员进行。
