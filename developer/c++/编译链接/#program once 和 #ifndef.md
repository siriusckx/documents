# 1 #program once 和 #ifndef
大部分内容转自：https://www.cnblogs.com/doudou-1102/p/9383438.html

> 在写小demo的时候，注意到vs中会自动生成#program once；看别人写的代码的时候见到比较多的反而是#ifndef---#define---#endif；从字面上看两种方式会产生相同的效果：避免同一个文件重复包含多次，但知道两种方式的本质还是有必要的。

>#program once：“同一个文件”指存储在相同位置的文件，即物理位置下相同；当编译器意识到文件存储位置相同时便会跳过“副本文件”，仅仅编译一次该物理位置的文件；但如果发生拷贝情况，便会出现重复包含的情况。

> #ifndef--#define---#endif：#ifndef和#define后面是宏定义，这里的宏定义的作用仅仅是为了判断文件是否是同一个文件，即宏名便是我们判断是否是同一个文件的标注，因此，可以按照自己的习惯或者喜好来命名，和头文件名字没有必然联系；但如果有多个头文件，出现同名的几率会大大增加，误判的几率也会提高很多；

>#program once较#ifndef出现的晚，部分编译器并不支持这种写法，因此兼容性会较#ifndef差一些，但性能会好一些；

# 2 boost 使用 #program once的一个例子
```
#ifndef BOOST_ASSIGN_STD_VECTOR_HPP
#define BOOST_ASSIGN_STD_VECTOR_HPP

#if defined(_MSC_VER)
# pragma once
#endif

#include <boost/assign/list_inserter.hpp>
#include <boost/config.hpp>
#include <vector>

......

#endif
```
> 以上例子恰好是这种说法的一个例证：
> btw：我看到GNU的一些讨论似乎是打算在GCC 3.4（及其以后？）的版本取消对#pragma once的支持。不过事实上，我手上的GCC 3.4.2和GCC 4.1.1仍然支持#pragma once，甚至没有deprecation warning，倒是GCC2.95会对#pragma once提出warning。
    VC6及其以后版本亦提供对#pragma once方式的支持，这一特性应该基本稳定下来了。 