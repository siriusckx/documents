# 1 C++ #pragma 预处理指令
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