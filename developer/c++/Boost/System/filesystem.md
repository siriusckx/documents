# 1 filesystem功能
> 目录、文件处理是脚本语言如Shell、Python、Perl所擅长的领域，但C++语言缺乏对操作系统中文件的查询和操作能力，因此C++程序员经常需要再掌握另外一门脚本语言以方便自己的工作，这增加了学习的成本。
> filesystem库是一个可移植的文件系统操作库，它在底层做了大量的工作，使用POSIX标准表示文件系统的路径，使C++具有了类似脚本语言的功能，可以跨平台操作目录、文件，写出通用的脚本程序。

## 1.1 编译filesystem库
> filesystem库需要system库支持，因此必须先编译system库，filesystem库需要编译才能使用，bjam命令如下：

```
bjam -toolset=msvc -with-filesystem -build-type=complete stdlib=stlport stage
```

## 1.2 需要引入的头文件

```
#include <boost/filesystem.hpp>
```

# 2 <boost/filesystem.hpp>概述
## 2.1 Class path

1. 路径表示
   
   >path的构造函数可以接受C字符串和string,也可以是一个指定首末端迭代器字符串序列区间。path使用标准的POSIX语法提供可移植的路径表示，它也是Unix、Linux的原生路径。POSIX语法使用（/）来分隔文件名和目录名，点号（.）表示当前目录，双点号（..）表示上一级目录。path也支持操作系统的原生路径表示，如在Windows下使用盘符，分隔符使用反斜杠(\\)

   >path的构造函数没有被声明为explicit，因此字符串可以被隐式转换为path对象，这在编写操作文件系统的代码时非常方便，可以不用创建一个临时的path对象

   >path重载了operator/=,可以像使用普通路径一个用/来追加路径，成员函数append()也可以追加一个字符串序列。

   >自由函数system_complete()可以返回路径在当前文件系统中的完整路径（也就是通常说的绝对路径）。

   >**需要注意**：path仅仅是用于表示路径，而并不关心路径中的文件或目录是否存在，路径也可能是个在当前文件系统中无效的名字，例如在Windows下不允许文件名或目录名使用冒号、尖括号、星号、问号。

2. 可移植的文件名
   
   >自由函数portable_posix_name()和windows_name()分别检测文件名字符串是否符合POSIX规范和Windows规范，保证名字可以移植到对应的操作系统上。

   >portable_name()判断名字是否是一个可移植的文件名，相当于portable_posix_name() && windows_name()。但名字不能以点号或者连字符开头，并允许表示当前目录的“.”和父目录的“..”。

   >portable_directory_name()的判断规则进一步严格，它包含了portable_name()并且要求名字中不能出现点号。

   >portable_file_name()类似portable_directory_name()，提供更可移植的文件名，它要求文件名中最多有一个点号，且后缀名不能超过3个字符。

   >filesystem库提供一个native()函数，它判断文件名是否符合本地文件系统命名规则，在windows下它等同于windows_name()，而在其他操作系统下则只是简单地判断文件名不是空格且不包含斜杠。

3. 路径的处理
   
   >path的成员函数string()返回标准格式的路径表示，directory_string()返回文件系统格式的路径表示，parent_path()、stem()、filename()和extension()分别返回路径中的父路径、不含扩展名的全路径名、文件名和扩展名。

   ```
   //windows操作系统上面
   path p("/usr/local/include/xxx.hpp");
   p.string(); // /usr/local/include/xxx.hpp
   p.directory_string(); // \usr\local\include\xxx.hpp
   p.parent(); // /usr/local/include/
   p.stem(); // /usr/local/include/xxx
   p.filename(); // xxx.hpp
   p.extension(); // .hpp
   ```

   >成员函数is_complete()用于检测path是否是一个完整（绝对）路径，这需要依据具体的文件系统的表示。

   >root_name()、root_directory()、root_path()这三个成员函数用于处理根目录，如果path中含有根，那么它们分别返回根的名字、根目录和根路径。

   ```
   //在windows下
   path p("c:/xxx/yyy");
   p.root_name(); // c:
   p.root_directory(); // /
   p.root_path(); // c:/

   //在linux下
   path("/")
   p.root_name();  //空字符串
   p.root_directory(); // /
   p.root_path();  //  /
   ```

   >成员函数relative_path()返回path的相对路径，相当于去掉了root_path().

   >根路径和相对路径的这四个函数都有对应的has_xxx()的形式，用来判断是否存在对应的路径，同样，has_filename()和has_parent_path用于判断路径是否有文件名或者父路径。

   >remove_filename()函数可以删除路径中最后的文件名，把path变为纯路径表示。

   >replace_extension()可以变更文件的扩展名。

   > 可以对两个path对象执行比较操作，它基于字典序并且大小写敏感比较路径字符串，提供operator<操作符，并基于<提供其他的比较操作，因此它的operator==是等价语义。

4. 文件状态

   > filesystem库提供一个文件状态类file_status及一组相关函数，用检查文件的各种属性，如是否存在、是否是目录、是否是符号链接等等。

   >file_status的成员函数type()可以获得文件的状态，它是一个枚举值。但通常我们不直接使用file_status类（就像是std::typeinfo），而是用相关函数返回的file_status对象。

   >函数status(const Path& p) 和 symlink_status(const Path& p )测试路径p的状态，结果可以用file_status的type()获得，如果路径p不能被解析则会抛出异常filesystem_error。文件可能的状态file_type是个枚举类型，值如下：
   1. file_not_found: 文件不存在  
   2. status_unknown: 文件存在但状态未知
   3. regular_file:是一个普通文件
   4. directory_file:是一个目录
   5. symlink_file:是一个链接文件
   6. block_file:是一个块设备文件
   7. character_file:是一个字符设备文件
   8. fifo_file:是一个管道设备文件
   9. socket_file:是一个socket设备文件
   10. type_unknown:文件的类型未知

   >filesystem库还提供了一些便利的谓词函数is_xxx()，可以简化对文件状态的判断，大部分谓词函数都可以望文知意，比较特别的是is_other()和is_empty()。当文件存在且不是普通文件、目录或链接文件时is_other()返回true。如果path对象是目录，那么当目录里无文件时is_empty()返回true，如果path对象是文件，那么文件长度为0,is_empty()返回true.

5. 文件属性
   1. initial_path() 返回程序启动时（进入main函数）的当前路径
   2. current_path()返回当前路径，它和initial_path返回的都是一个完整路径（绝对路径）;
   3. file_size()以字节为单位返回文件的大小
   4. last_write_time()返回文件的最后修改时间
   5. space()可以返回一个space_info结构，表明该路径下的磁盘空间分配情况

6. 文件操作
   1. create_directory 创建目录
   2. rename 文件改名
   3. remove 文件删除
   4. copy_file 文件拷贝

   ```
   #include <boost/filesystem.hpp>
   using namespace boost::filesystem;
   int main()
   {
       namespace fs = boost::filesystem;

       path ptest = "c:/test";
       if(exists(ptest))
       {
           if(is_empty(ptest))
           {
               fs::remove(ptest); //remove只能删除空目录或者文件
           }
           else
           {
               remove_all(ptest); //remove_all 可以递归删除
           }
       }

       assert(!exists(ptest));
       create_directory(ptest);    //创建一个目录

       copy_file("d:/boost/readme.txt", ptest / "a.txt"); //拷贝
       rename(ptest / "a.txt", ptest / "b.txt");  //改名

       create_directories(ptest / "sub_dir1" / "sub_dir1"); //使用create_directories可以一次创建多级目录
   }
   ```

7. 迭代目录
   > filesystem库使用basic_directory_iterator提供了迭代一个目录下的所有文件的功能，它预定义了两个typedef:directory_iterator和wdirectory_iterator. directory_iterator用法有些类似string_algo库的find_iterator、split_iterator或xpressive库的regex_token_iterator，空的构造函数生成一个逾尾end迭代器，伟入path对象构造将开始一个迭代操作，反复调用operator++即可迭代目录下的所有文件。如：

   ```
   directory_iterator end;
   for( directory_iterator pos("d:/boost/"); pos != end; ++pos)
   {
       cout << *pos << endl;
   }
   ```


   > 需要注意：basic_directory_iterator迭代器返回的对象并不是path，而是一个basic_directory_entry对象，但basic_directory_entry类定义了一个到path的类型转换函数，因此可以在需要path的语境中隐式转换到path.

   >basic_directory_entry可以用path()方法返回路径，status()返回路径的状态，它也有两个typedef，与directory_iterator对应的是directory_entry。

   >directory_iterator只能迭代本层目录，不支持深度遍历目录，可以使用递归来实现这个功能，并不是很难

   ```
   void recursive_dir(const path& dir)   //递归遍历目录
   {
       directory_iterator end;
       for(directory_iterator pos(dir); pos != end; ++pos)
       {
           if(is_directory(*pos))
           {
               recursive_dir(*pos); //是目录则递归遍历
           }
           else
           {
               cout << *pos << endl;
           }
       }
   }
   ```

   >filesystem库专门提供了另外一个类basic_recursive_directory_iterator,它遍历目录的效率要比递归的directory_iterator高很多，它可以递归遍历目录结构。  

   ```
   typedef recursive_directory_iterator rd_iterator;
   ```

   >成员函数level()返回当前的目录深度m_level,当rd_iterator构造时(未开始遍历)m_level == 0，每深入一层子目录则m_level增加，退出时减少。成员函数pop()用于退出当前目录层次的遍历，同时--m_level。当迭代到一个目录时，no_push可以让目录不参与遍历，使rd_iterator的行为等价于directory_iterator。

   > 使用rd_iterator，对目录进行深度遍历：

   rd_iterator end;
   for(rd_iterator pos("d:/test"); pos != end; ++pos)
   {
       cout << "level" << pos.level() << ":" << *pos << endl;
   }

   >下面代码使用no_push()令rd_iterator的行为等价于directory_iterator:

   ```
   rd_iterator end;
   for(rd_iterator pos("d:/test"); pos != end; ++pos)
   {
       if(is_directory(*pos))
       {
           pos.no_push(); //使用no_push()，不深度遍历
       }
       cout << *pos << endl;
   }
   ```

   >恰当地使用level()和no_push()，不宋史以实现指定深度的目录遍历。

# 3 对应的一些实例

## 3.1 实现查找文件功能

```
#include <boost/optional.hpp>
optional<path> find_file(const path& dir, const string& filename)
{
    typedef optional<path> result_type;          //返回值类型定义
    if(!exists(dir) || !is_directory(dir))
    {
        return result_type();
    }

    rd_iterator end;                             //递归迭代器
    for(rd_iterator pos(dir); pos != end; ++pos)
    {
        if(!is_directory(*pos) && pos->path().filename() == filename)
        {
            return result_type(pos->path());
        }
    }

    return result_type();
}


int main()
{
    optional<path> r= find_file("d:/atest", "README.txt");
    if(r)
    {
        cout << *r << endl;
    }
    else
    {
        cout << "file not found" << endl;
    }
}

```

## 3.2 实现模糊查找文件功能
> 模糊查找的几个实现要点：  
> 1. 文件名中用于分隔主名与扩展名的点号必须转义，因为点号在正则表达式中是一个特殊的字符；
> 2. 通配符*应该转换为正则表达式的\.\*,以表示任意多的字符；
> 3. 在判断文件名是否查找到时我们应该使用正则表达式而不是简单的判断相等。
> 4. 函数的返回值不能再使用optional\<path\>,因为模糊查找可能会返回多个结果，因此应该使用vector\<path\>。

```
#include <boost/xpressive/xpressive_dynamic.hpp>
#include <boost/algorithm/string.hpp>

using namespace boost::xpressive;
void find_files(const path& dir, const string& filename, vector<path> &v)
{
    static xpressive::sregex_compiler rc;     //正则表达式工厂
    if(!rc[filename].regex_id())
    {
        string str = replace_all_copy(replace_all_copy(filename, ".", "\\."), "*", ".*");       //处理文件名

        rc[filename] = rc.compile(str);  //创建正则表达式
    }

    typedef vector<path> result_type;    //返回值类型定义
    if(!exists(dir) || !is_directory(dir))
    {
        return;
    }

    rd_iterator end;                      //递归迭代器逾尾位置
    for(rd_iterator pos(dir); pos != end; ++pos)
    {
        if(!is_directory(*pos) && regex_match(pos->path().filename(),rc[filename]))
        {
            v.push_back(pos->path()); //找到，加入vector
        }
    }
}
```



   



