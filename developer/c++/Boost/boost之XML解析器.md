## C++常用的XML解析器
1. TinyXML(DOM)
1. RapidXML(DOM)
1. Xerces-C++(DOM,SAX)
1. libXML

## boost::property_tree
1. 保存了多个属性值的树形结构
1. 可以解析和生成xml、json、ini、info
1. 对于解析带有中文的内容，要注意编码的转换
   ```
   #include <Windows.h>

   //cout无法输出 utf-8的编码
   //下面考虑utf-8转换为unicode，用wstring接受，然后用wcout输出

   //求转换为unicode需要多大的空间存放
   int len = MultiByteToWideChar(CP_UTF8, NULL, str.data(), str.length(), 0, 0);

   //开始转换编码
   wchar_t *pw = new wchar_t[len+1];
   MultiByteToWideChar(CP_UTF8, NULL, str.data(), str.length(), pw, len+1);
   pw[len] = L'\0';

   //设置wcout本地环境
   wcout.imbue(locale("",LC_CTYPE));
   wcout << L"姓名" << pw << endl;
   ```