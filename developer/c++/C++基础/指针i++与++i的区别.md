## 不同指针++的顺序
```
#include <iostream>

using namespace std;

int main()
{
   cout << "Hello World" << endl; 
   int a =0;
   int * i=&a;
   std::cout << *i << endl;  //解引用 0
   std::cout << ++(*i) << endl; //解引用，先++，再使用 1
   std::cout << ++*i << endl; // 解引用，先++, 再使用 2
   std::cout << (*i)++ << endl; //解引用，先使用，再++ 2
   std::cout << *i++ << endl; // 解引用，先使用，再对指针++ 3
   std::cout << *i << endl; //上一个值对指针地址作了改变，对应的值随机
   
   return 0;
}
```