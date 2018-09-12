## 一、什么是gcc/g++
> 首先说明，gcc和g++是两个不同的东西  
> GCC:GNU Compiler Collection(GUN编译器集合)，它可以编译C、C++、JAV、Fortran、Pascal、Object-C、Ada等语言。  
> gcc:是GCC中的GNU C Compiler(C编译器)
> g++:是GCC中的GNU C++ Compiler(C++编译器)

一个有趣的事实就是，就本质而言，gcc和g++并不是编译器，它们只是一种驱动器，根据参数中要编译的文件类型，调用对应的GNU编译器而已，比如，用gcc编译一个c文件的话，会有以下几个步骤：  
   Step1: Call a preprocessor,like cpp.  
   Step2: Call an actual compiler,like cc or cc1.  
   Step3: Call an assembler, like as.  
   Step4: Call a linker, like ld.  
由于编译器是可以更换的，所以gcc不仅可以编译C文件，所以，更准确的说法是：gcc调用了C compiler,而g++ 调用了C++ compiler。

## 二、gcc和g++的主要区别
1. 对于*.c和*.cpp文件，gcc分别当做c和cpp文件编译（c和cpp的语法强度是不一样的）。
2. 对于*.c和*.cpp文件，g++则统一当做cpp文件编译。
3. 使用g++编译文件时，g++会自动链接标准库STL，而gcc不会自动链接STL。
4. gcc在编译C文件时，可使用的预定义宏是比较少的。
5. gcc在编译cpp文件时,g++在编译c文件和cpp文件时（这时候gcc和g++调用的都是cpp文件的编译器），会加入一些额外的宏，这些宏如下：
    ```
    #define __GXX_WEAK__ 1
    #define __cplusplus 1
    #define __DEPRECATED 1
    #define __GNUG__ 4
    #define __EXCEPTIONS 1
    #define __private_extern__ extern
    ```
6. 在用gcc编译C++文件时，为了能够使用STL，需要加参数 --lstdc++,但这并不代表 gcc --lstdc++和g++等价，它们的区别不仅仅是这个，主要参数：
   ```
   -g  :turn on debugging(so GDB gives morefriendly output)
   -Wall :turns on most warning
   -O or -O2 : turn on optimizations
   -o : name of the output file
   -c :output an object file (.o)
   -l:specify an includedirectory
   -L:specify an libdirectory
   -I:link with librarylib.a
   ```
参考地址  
http://www.cnblogs.com/samewang/p/4774180.html