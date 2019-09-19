## 参考地址
https://blog.csdn.net/liigo/article/details/582231  
http://www.cnblogs.com/kzloser/archive/2012/09/21/2697185.html  

## 通过GDB查看STL容器的内容

1. 通过安装工具来查看
https://blog.csdn.net/meteor1113/article/details/5180293  

2. 通过命令来查看vector中的前多少个元素，如：

   ```
   print *(myVector._M_impl._M_start)@N
   ```
3. 找到元素的地址，可以将地址转换成对应的指针，再对指针进行解引用来查看，注意要加上namespace来查看，如：
   
   ```
   p *(quoter::QuoterBase*)0x8876783234
   ```

## GDB操作技巧
https://www.cnblogs.com/JN-PDD/p/6953136.html


