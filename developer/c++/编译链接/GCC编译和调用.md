## GCC介绍
## GCC参数详解
```
-O
-E //预编译
-c
-S
-g
```
## GCC多文件编译
## GCC静态编译
```
-static
```
## GCC动态库编译和调用
```
g++ Person.cpp -fpic -shared -o libPerson.so  # -fpic代码与库分离
g++ main.cpp -o main -I../Person -L../Person -lPerson
执行的时候，需要将Person.so文件拷贝到目录，或者设置EXPORT_LIBRARY_PATH
```