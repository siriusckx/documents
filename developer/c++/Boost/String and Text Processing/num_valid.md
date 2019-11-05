# 1 功能
> 对数字类型正确性的验证

```
#include <boost/lexical_cast.hpp>
int main()
{
    assert(num_valid<double>("3.14"));
    assert(num_valid<int>("3.14"));
    assert(num_valid<int>("65535"));
}
```