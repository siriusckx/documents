# 写在前面
在这之前虽然照着书本写过一些简单的C++代码片段，但从来没有做过一个真正的C++服务端项目。作为练手这次接触到的是一个老的项目，对这个老的项目的一些功能作相应的优化，如检查redis断线重连机制、并完善该机制。虽然在C++语法上面比较默生，但在编程思想上面还是有一些经验的，在接到这个任务后，我是按照如下一些过程来进行实践的，该过程对新手可能是一个锻炼，对整体项目来说，可能表现出其中的一些管理短板。
# 实践过程
1. 部署开发环境（项目比较老用的vs2008）
   * 安装VS2008软件
   * 升级VS2008对应的SP1补丁
   * 配置一些需要库的环境变量
   * 安装VAssistX插件
   * 安装IncrediBuild插件
   * 安装ViEmuVS-3.7.0插件
   * 安装项目本身需要的LUA环境
   * 安装项目本身需要的PYTHON环境
1. 导入项目进行编译
   * 通过项目解决方案导入项目（`File→Open→project/solution`）找到对应的`*.sln`进行添加。
   * 导入项目依赖的子项目（`右键→Add→Existing Project`）找到对应的`*.vcproj`进行添加。
   * 设置项目的依赖模块（`右键→Project Dependencies`）勾选上要依赖的模块。
   * 设置主模块为默认启动项目(`右键→Set as StartUp Project`)后面才可以进行调试。
   * 设置项目对应的属性（`右键→Properties`）
      * General
         * Output Directory:`$(SolutionDir)_runtime\$(PlatformName).$(ConfigurationName)`
         * Intermediate Directory:`$(SolutionDir)_builder\$(PlatformName).$(ConfigurationName)\$(ProjectName)\`
         * Build Log File:`$(IntDir)\BuildLog.htm`
         * Inherited Project Property Sheets:`$(SolutionDir)XtEnv.vsprops`
         * Configuration Type:`Application (.exe)`
      * Debugging
         * Command:`$(TargetPath)`
         * Command Arguments:`$(SolutionDir)_runtime\conf\$(ProjectName)\$(ProjectName).ini`
         * Working Directory:`$(SolutionDir)_runtime\$(PlatformName).$(ConfigurationName)`
      * C/C++
         * General
            *Additional Include Directories:`"$(SERVER5BASE_DIR)\src\";"$(BOOST_ROOT)";"$(SolutionDir)\src";"$(SERVER5_LIBS)\trunk\include"`
         * Output Files
            * Object File Name:`$(IntDir)\`
            * Program Database File Name:`$(IntDir)\vc90.pdb`
            * XML Documents File Name:`$(IntDir)\`
      * Linker
         * General
            * Output File:`$(OutDir)\$(ProjectName).exe`
            * Additional Library Directories:`"$(BOOST_ROOT)\stage\lib";"$(SERVER5_LIBS)\trunk\lib\$(PlatformName)";"$(SERVER5_LIBS)\trunk\lib\$(PlatformName)\$(ConfigurationName)"`
         * Input
            * Additional Dependencies:`log4cxx.lib tinyxml.lib bson.lib zlib.lib libeay32.lib ssleay32.lib`
         * Manifest File
            * Manifest File:`$(IntDir)\$(TargetFileName).intermediate.manifest`
    > 以上有几个属性要特别注意`Debugging`,`Inherited Project Property Sheets`,`Additional Include Directories`,`Additional Library Directories`,`Additional Dependencies`

    > **注意:** 填写的变量路径不能包括空格，因为多个属性变量之间就是使用空格进行区分的。对于系统配置文件`$(SolutionDir)_runtime\conf\project\projectname.ini`里面的内容要注意编码是否含有BOM，在Linux环境上因为编码问题，可能读不到配置信息。

    > `$(SolutionDir)XtEnv.vsprops`配置的是一些项目要用到的变量，如下所示：
    ```xml
    <?xml version="1.0" encoding="gb2312"?>
    <VisualStudioPropertySheet
	    ProjectType="Visual C++"
	    Version="8.00"
	    Name="XtEnv"
	>
	<UserMacro
		Name="BOOST_ROOT"
		Value="$(BOOST_ROOT)"
	/>
	<UserMacro
		Name="SERVER5_LIBS"
		Value="$(SERVER5_LIBS)"
		PerformEnvironmentSet="true"
	/>
	<UserMacro
		Name="SERVER5BASE_DIR"
		Value="$(SolutionDir)libs/base/"
		PerformEnvironmentSet="true"
	/>
    </VisualStudioPropertySheet>
    ```
1. 将项目跑起来，至少能够调试
   > 按照如上步骤配置后，基本可进行编译和连接。接下来在调试的过程当中，缺少什么库文件，则将对应的dll文件复制到工作目录下面`$(SolutionDir)_runtime\$(PlatformName).$(ConfigurationName)`。
1. 在linux环境进行编译
   * 首先，找到一个可用的编译环境是很重要的，老项目的话，公司一般都有这样的环境。在这里要注意检查`Makefile`的编译命令是否与测试环境上面的一致。如果不一致，可能会走很多的弯路。
   * 其次，如果实在没有现成的环境，则自己需要准备对应的编译环境进行编译。
      * 需要掌握相应的`Makefile编译技巧`，参考[GNU make](http://www.gnu.org/software/make/manual/make.html)
      * 需要掌握G++ 相关的一些编译命令，参考[GCC online documentation](https://gcc.gnu.org/onlinedocs/)，
      * 需要准备相对应的版本库
1. 在linux服务器上部署相应的测试环境
   * 首先，还是找一个现成的测试环境是比较方便的，直接组装好的项目，加上配置文件路径运行即可，如：`./testproject ./conf/testproject/testproject.ini` 
1. 在linux环境下使用GDB进行调试
   * 使用GDB调试我们需要生成对应的`core文件`，如：`GDB ./testproject ./core`进入调试模式，这里不需要输入配置文件参数，调试技巧，参考[GDB十分钟教程](http://blog.csdn.net/liigo/article/details/582231) 或者`man文档`
   * 一般情况下，系统如果崩溃的话，则会生成对应的`core文件`，如果出现系统没有生成对应的core文件，可能有以下三种情况：
      * 系统崩溃的时候发送的信号，linux操作系统接受到该类信号不会生成转储文件，如：socket连接过程中，如果服务器端断开，第二次客户端检测到连接断开，第二次连接时会发送`SIGPIPE`信号，而Linux操作系统接收到该信号后，会直接退出系统，并不生成转储文件。更多信号可参考[C++ - C++ signal的使用](http://www.cnblogs.com/hero4china/archive/2011/09/17/2179599.html)
      * 操作系统本身配置不生成对应的转储文件，可参考`ulimit命令`的使用进行相关的查看。
      * 生成`core文件`的配置路径不对，可参考[Linux生成core文件、core文件路径设置](https://www.jianshu.com/p/5549a6e71a1d)
1. 完成功能任务获得小确幸
   > 到这里经过了一些简单的小实践，算是把环境弄好了，可以适当的奖励一下自己。
# C++11特性的支持
1. 如何运用C++11的特性，并知道哪一个G++版本支持哪些特性
   * 可参考[C++ Standards Support in GCC](https://gcc.gnu.org/projects/cxx-status.html#cxx11)，[GCC,the GNU Compiler Collection](https://gcc.gnu.org/)
   * 对于一些标准网站的专业词汇看不懂的，可以查看`C++ Primer 2015版`对应后面的索引，有对应的功能索引和翻译。
1. 其他技巧，待续……
