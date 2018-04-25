## 查找替换
> 查找当前文件夹下，所有以`.js`结尾的文件，将其文件内容为`AA`的部分替换为`BB`。
```
find . -name "*.js" |xargs sed -i 's#AA#BB#g'
```
> 去除文件下的特殊字符
```
find . -type f |xargs sed -i 's/^M/\n/g'
```
> 批量去除bom头
```
find . -type f |xargs sed -i 's/\xef\xbb\xbf//g'
```
> 列出当前目录下的所有文件(包括隐藏文件)的绝对路径,对目录不做递归
```
find $PWD -maxdepth 1 | xargs ls -ld  
```
> 列出当前目录下的所有文件（包括隐藏文件）的绝对路径，对目录做递归
```
find $PWD | xargs ls -ld
```
