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
> 删除乱码文件
```
查询inode节点
ll -i 
找到inode节点，进行删除
find . -inum 3501052912 -exec rm {} \;
```

> 查询并排除不需要的文件
```
find /glusterfs/metadatas/1802 -path "/glusterfs/metadatas/1802/SZ/*/0/20190418-20190419" -prune -o -print --exec rm -rf {} \;
```

>查找目录下的所有文件中是否含有某个字符串 
```
# 查找SO_REUSEADDR在linux文档中的定义
find /usr/include |xargs grep -ri "SO_REUSEADDR" 
```

>查找目录下的所有文件中是否含有某个字符串,并且只打印出文件名 
```
find .|xargs grep -ri "IBM" -l 
```
