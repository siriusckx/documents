## boost::reference_wrapper的使用
1. 和一般引用的功能类似，包装了引用的功能
   ```
   #incude <boost/ref.hpp>


   template<class T>
   void Func(T a)
   {
       cout << ++a << endl;
   }

   int a = 10;
   boost::reference_wrapper<int> rw(a);

   //直接打印值
   cout << rw << endl;

   //获得引用的地址
   cout << rw.getPoint() << endl;

   //改变引用的值
   *rw.getPoint() = 11;

   Func(boost::reference_wrapper<int>(a));
   //a的值被改变了
   cout << a  << endl;
   ```
1. reference_wrapper的工厂函数ref和cref
   ```
   int c = 10;
   boost::reference_wrapper<int> rc = boost::ref(c);
   ++rc;
   ```
   