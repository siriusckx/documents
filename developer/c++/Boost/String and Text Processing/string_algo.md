# 1 功能
> 它是一个非常全面的字符串算法库，提供了大量的字符串操作函数，如大小写无关比较，修剪，特定模式的子串查找等，可以在不使用正则表达式的情况下处理大多数字符串相关问题。
> 引用的头文件
```
#include <boost/algorithm/string.hpp>
using namespace boost;
```

## 1.1 大小写转换
> 对应的文件：<boost/algorithm/string/case_conv.hpp>

```
#include <boost/algorithm/string.hpp>
using namespace boost;
int main()
{
    string str("hello boost");
    cout << to_upper_copy(str); // 返回大写拷贝
    cout << str; //原字符串不变
    cout << to_lower(str); //字符串小写
    cout << str; //原字符串被改动
}
```

## 1.2 判断式与分类
>对应的文件：<boost/algorithm/string/predicate.hpp>

```
#include <boost/algorithm/string.hpp>
int main()
{
    string str("Hello World");
    string str2("hello world");

    assert(boost::iends_with(str, "ld")); //大小写无关检测后缀
    assert(boost::iequals(str, str2));  //大小写无关判断相等
    assert(boost::contains(str, "Hello")); //测试包含关系
}
```

## 1.3 分类
>对应的文件：<boost/algorithm/string/classification.hpp>
```

```
## 1.4 修剪
>对应的文件：<boost/algorithm/string/trim.hpp>
```
#include <boost/format.hpp>
#include <boost/algorithm/string.hpp>
int main()
{
    boost::format fmt("|%s|\n");

    string str = " sams aran ";
    std::cout << fmt % trim_copy(str); //删除两端的空格
    std::cout << fmt % trim_left_copy(str); //删除左端的空格

    trim_right(str); //原地删除右端的空格

    string str2 = "2010 Happy new Year!!!";
    std::cout << fmt % trim_left_copy_if(str2, is_digit());//删除左端的数字
    std::cout << fmt % trim_right_copy_if(str2, is_punct()); //删除右端的标点

    std::cout << fmt % trim_copy_if(str2, is_punct() || is_digit() || is_space()); //删除两端的标点、数字和空格
}
```
## 1.4 查找与替换
>对应的文件：<boost/algorithm/string/find.hpp>
```
#include <boost/format.hpp>
#include <boost/algorithm/string.hpp>
int main()
{
    format fmt("|%s|. pos = %d \n");

    string str="Long long ago, there was a king.";
    iterator_range<string::iterator> rge;   //迭代器区间

    rge = find_first(str, "long"); //找第一次出现
    cout << fmt %rge %(rge.begin() - str.begin());

    rge = ifind_first(str, "long"); //大小写无关找第一次出现
    cout << fmt %rge %(rge.begin() - str.begin());

    rge = find_nth(str, "ng", 2); //找第3次出现
    cout << fmt %rge %(rge.begin() - str.begin());

    rge = find_head(str, 4); //取前4个字符
    cout << fmt %rge %(rge.begin() - str.begin());

    rge = find_tail(str, 5); //取末尾5个字符
    cout << fmt %rge %(rge.begin() - str.begin());

    rge = find_first(str, "samus");
    assert(rge.empty() && !rge); //找不到


}
```

## 1.5 替换与删除
> 对应的文件：<boost/algorithm/string/replace.hpp>
> 对应的文件：<boost/algorithm/string/erase.hpp>

## 1.5 分割与合并
> 对应的文件：<boost/algorithm/string/split.hpp>  
> 对应的文件：<boost/algorithm/string/join.hpp>  