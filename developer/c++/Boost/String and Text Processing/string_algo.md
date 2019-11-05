# 1 功能
> 它是一个非常全面的字符串算法库，提供了大量的字符串操作函数，如大小写无关比较，修剪，特定模式的子串查找等，可以在不使用正则表达式的情况下处理大多数字符串相关问题。
> 引用的头文件
```
#include <boost/algorithm/string.hpp>
using namespace boost;
```

## 1.1 大小写转换

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
## 1.3 修剪
## 1.4 查找与替换
## 1.5 分割与合并