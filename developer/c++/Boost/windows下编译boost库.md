## 需要进行单独编译的库
* Boost.Chrono
* Boost.Context
* Boost.FileSystem
* Bost.GraphParallel
* Boost.IOStreams
* Boost.Locale
* Boost.Log
* Boost.MPI
* Boost. ProgramOptions
* Boost.Python
* Boost.Regex
* Boost.Serialization
* Boost.Signals
* Boost.System
* Boost.Thread
* Boost.Timer
* Boost.Wave
* Boost.DateTime
* Boost.Graph
* Boost.Math
* Boost.Random
* Boost.Test
* Boost.Exception
## 编译步骤
```
booststrap.bat
./b2.exe   # bjam的升级版   
./bjam.exe # 用于编译boost的工具

bjam --show-libraries  #展示需要编译的模块
```