# 1 概述

> result_of是一个很小但很有用的组件，可以帮助程序员确定一个调用表达式的返回类型，主要用于泛型编程和其他Boost库组件。

>需要包含头文件
```
<boost/utility/result_of.hpp>
```

## 1.1 原理

> 所谓“调用表达式”，是指一个含有operator()的表达式，函数调用或函数对象调用都可以称为调用表达式，而result_of可以确定这个表达式所返回的类型。其功能有些类似typeof库，typeof可以确定一个表达式的类型，但它不具备推演调用表达式的能力。

> 假设我们有一个类型Func，它可以是函数指针、函数引用或者成员函数指针，当然也可以是函数对象类型，它的一个实例是func。Func有一个operator()，参数是（T1 t1, T2 t2）,这里T1、T2是两个模板类型，那么

```
result_of<Func(T1, T2)>::type 
```

>就是func(t1, t2)的返回值类型。

> 实例1：

```
#include <boost/utility/result_of.hpp>
using namespace boost;
int main()
{
    typedef double (*Func)(double d);

    Func func = sqrt;

    result_of<Func(double)>::type x = func(5.0);

    cout << typeid(x).name() ; 
}
```

>实例2：

```
#include <boost/ubility/result_of.hpp>
using namespace boost;
template<typename T, typename T1>
typename result_of<T(T1)>::type call_func(T t, T1 t1)
{
    return t(t1);
}

int main()
{
    typedef double (*Func)(double d);
    Func func = sqrt;

    BOOST_AUTO(x, call_func(func, 5.0)); //赋值表达式，可以用typeof

    cout << typeid(x).name();
}
```

## 1.2 用法

> result_of虽然小，但它用到了很多C++的高级特性，如模板偏特化和SFINAE,并且部分依赖于编译器的能力。它不仅可以用于函数指针，更重要的是用于函数对象进行泛型编程。

> 设类型Func可被调用（具有operator()）,func是Func的一个左值，那么：`typeid(result_of<Func(T1, T2, ... , TN)>::type)`必然等于`typeid(func(t1, t2, ..., tN))`。

> 在 `result_of`应用于函数对象时，推导会更复杂一些，例如：

* 如果Func有一个内部类型定义(typedef)result_type,那么`typeid(result_of<Func(...)>::type) == typeid(Func::result_type)`;
* 如果Func没有定义result_type类型，那么如果是无参调用，`typeid(result_of<Func()>::type) == typeid(void)`。否则`typeid(result_of<Func(...)>::type) == typeid(Func::result_of<Func(...)>::type);`
* 如果类型 Func 内部没有嵌套的 `result_of<Func(...)>::type`定义，那么`result_of`的类型推导将会失败，报出编译错误。