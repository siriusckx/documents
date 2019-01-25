## boost:array
1. 性能由高到低普通数组，boost:array, stl::vector
1. boost::array和普通数组性能比较接近，对数组的操作比较方便。

## boost::unordered_set
1. 性能比set要高

## boost::unordered_map
1. 性能比map要高，无序

## bimap
1. 双端map，key和value必须唯一，可以通过key查找value，也可以通过value查找key

## circular_buffer
1. 固定大写的双端队列
   
## multi_array
1. 正常情况下，数组是线性存储的，在创建时，必须指定除第一维之外的数组大小，第一位不需要指定，主要是编译器可以根据元素的个数算出来。
1. 运行的时候，动态的创建数组的大小。
   ```
   multi_array<int, 3> arr(extents[a][b][c]);
   ```
1. 可以动态改变数组维度的大小，原有的元素会被复制到新分配的数组当中
   ```
   arr.resize(extends[4][5][6]);
   ```
1. 在总元素不变的情况下，可以改变多维数组的形状 4 * 5 * 6 = 2 * 5 * 12
   ```
   boost:array<int, 3> wd = {2, 5, 12}
   arr.reshape(wd);
   ```