# 1. 功能
> 实现字符串与数字类型，数字类型与字符串之间的互相转换。

```
#include <boost/lexical_cast.hpp>
#include <vector>
int main(int /*argc*/, char * argv[])
{    
    using boost::lexical_cast;
    using boost::bad_lexical_cast;    
    std::vector<short> args;
    while (*++argv)    
    {        
        try        
        {
            args.push_back(lexical_cast<short>(*argv));        
        }
        catch(const bad_lexical_cast &)        
        {            
            args.push_back(0);
        }    
    }    // ...
}
```