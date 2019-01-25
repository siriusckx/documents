## 伪随机数
1. 伪随机发生器（算法）
1. Mersenne Twister算法（马特赛特旋转演算法），周期长
    ```
    #include <boost/random.hpp>


    //马特赛特旋转演算法
    mt19937 mt(time(0));

    cout << mt.min() << "~" << mt.max() << endl;
    ```

1. rand48伪随机生成器,使用线性同余算法LCG
    ```
    #include <boost/random.hpp>

    rand48 r48;

    cout << r48.min() << "~" << r4.max() << endl;
    ```
1. 随机数分布器
   ```
   mt19937 mt(time(0));

   //产生0~1之间的随机数
   uniform_01<mt19937&> u01(mt);
   for(int i=0; i<5; i++)
   {
       cout << u01() << endl;
   }

   //产生指定数字区间的随机数
   uniform_int< > ui(1, 100);
   for(int i=0; i<5; i++)
   {
       cout << ui(mt) << endl;
   }
   ```