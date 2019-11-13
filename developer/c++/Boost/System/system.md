# 1 功能
> C++中处理错误的最佳方式是使用异常，但操作系统和许多底层API不具有这个能力，它们一般使用更通用也更难以操作的错误代码来表示出错的原因，不同的操作系统的错误代码通常不是兼容的，这给编写跨平台的程序带来了很大的麻烦。

## 1.1 编译system库
> system库需要编译才能使用，byam命令如下：

```
bjam -toolset=msvc -with-system -build-type=complete stdlib=stlport stage
```
