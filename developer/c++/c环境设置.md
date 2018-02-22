# 一、c++ 编译环境配置
1. C++编译环境配置；  
1. GDB调试环境配置；  
> 以上两个环境的配置，皆通过`MinGW`进行安装配置。安装好`MingW`之后，配置环境变量`C:\MinGW\bin`

# 二、开发环境安装配置
> 对于一些简单的开发或者学习方面，主要采用开发工具`Visual Studio Code 1.14.2`

1. 在官网下载安装`Visual Studio Code`;
1. 接下来安装`Visual Studio Code`的扩展插件，主要选择C++的，快捷键风格选择`vim`;
1. 接下来创建一个文件，如：`main.cpp`,然后需要配置c++对应的库环境，否则可能找不到对应的环境；
> 操作步骤：在`Visual Studio C++`下面按快捷键`Ctrl+Shift+p`，输入`cpp`,选择`C/Cpp:Edit Configuration`,它会在你新建文件对应的目录下，生成文件夹和文件`.vscode/c_cpp_properties.json`，打开这个文件，往`includePath`和`browse:path`下面增加`C++对应的库`，路径为·`C:/MinGW/lib`。
1. 接下来配置项目的构建环境  
> 操作步骤：在`Visual Studio C++`下面按快捷键`Ctrl+Shift+B`，输入`task`,选择`Tasks:Runer`,会自动生成文件`tasks.json`,修改其内容，如下所示：
```
"version": "2.0.0",
   "command": "g++",
   "type": "shell",
   "args": [
       "-g",
       "main.cpp"
   ]
```
1. 接下来配置项目的调试环境
> 第一次，选中调试，启动调试的时候，选择GDB作为调试引擎，接下来会生成 `launch.json`，需要修改属性为 ，`"program": "${workspaceRoot}/a.exe"`和`"program": "${workspaceRoot}/a.exe"`，这里a.exe是编译后的程序名，在编译的时候`G++`没有指定`-o`参数指定生成的目标文件，则默认为`a.exe`

> 到这里，一个基本的C++编写调试代码的环境算是搭建起来了。参考地址如下：  
http://www.runoob.com/cplusplus/cpp-environment-setup.html
http://blog.csdn.net/zhaojia92/article/details/53862840
https://code.visualstudio.com/docs/languages/cpp#_debug_windows_gdb
http://blog.csdn.net/lidong_12664196/article/details/68928136

