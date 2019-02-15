## boost与gcc的兼容性
### 存在的问题
1. boost 1.58 与 gcc 4.8.5 一起时，boost::bind boost::thread_pool会很耗内存

>解决策略：看官方文档，查看Release Notes，找对应匹配的版本。如：
https://www.boost.org/users/history/version_1_58_0.html
https://www.boost.org/users/history/
