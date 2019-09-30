## 1. 参考地址
https://blog.csdn.net/liigo/article/details/582231  
http://www.cnblogs.com/kzloser/archive/2012/09/21/2697185.html  

## 2. 通过GDB查看STL容器的内容

### 2.1 通过工具来查看

1. 通过安装工具来查看
https://blog.csdn.net/meteor1113/article/details/5180293  

### 2.2 通过命令来查看

> gdb 7之前的版本不能直接打印vector，但是vector的内部实现是用数组array，所以找到array地址就可以打印出vector内容。

1. 打印整个vector
   ```
   (gdb) print *(myVector._M_impl._M_start)@myVector.size()
   ```

2. 打印前N个元素
   ```
   print *(myVector._M_impl._M_start)@N
   ```

3. 打印第N个元素后的M个元素
   ```
   print *(myVector._M_impl._M_start+N)@M
   ```
### 2.3 GDB使用实践
4. 通过命令来查看vector中的前多少个元素，如：

   ```
   print *(myVector._M_impl._M_start)@N
   ```
5. 找到元素的地址，可以将地址转换成对应的指针，再对指针进行解引用来查看，注意要加上namespace来查看，如：
   
   ```
   p *(quoter::QuoterBase*)0x8876783234
   ```

   ```
   p *((*(SegmentInfo*)0x7f88618122c0).structDatas._M_impl._M_start)@2
   ```

6. px和pn的含义

   ```
   element_type * px;                 // contained pointer
   boost::detail::shared_count pn;    // reference counter
   ```

7. 通过GDB查看boost智能指针的引用情况
   ```
   p *(boost::detail::shared_count*)0x7f7bafb78ea0 //对应pn的地址

   p *(boost::detail::sp_counted_impl_p<quoter::QuoteAux>*)0x7f7bafb78ea0  //对应pn的地址
   ```

## GDB操作技巧
https://www.cnblogs.com/JN-PDD/p/6953136.html


