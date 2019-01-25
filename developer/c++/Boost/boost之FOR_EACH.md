## 普通的for

## C++11 提供的for
```
for(int e:arr)
{
    cout << e ;
}
```

## boost中的FOR_EACH
```
#include <boost/foreach.hpp>

int[5] arr = {1,2,3,4,5};
//正序循环
BOOST_FOREACH(int e, arr)
{
    cout << e << endl;
}

//倒序循环
BOOST_REVERSE_FOEACH(int e, arr)
{
    cout << e << endl;
}
```