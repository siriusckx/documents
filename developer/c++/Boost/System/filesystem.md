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

   



