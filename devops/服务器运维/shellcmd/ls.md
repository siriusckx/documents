## 目录文件查看

> 按时间从低到高列出内容，按人类容易识别的方式显示文件的大小  
```
ls -lrth
```
> 按时间从高到低列出内容，按人类容易识别的方式显示文件的大小
```
ls -lth
```

> 列出当前目录及其子目录文件的内容
```
ls -lRh
```
> 按文件大小进行相应的排序
```
ls -lSh
```
> 只显示文件
```
ls -l | grep "^-"  # 目录下的所有文件
```
> 只显示目录
```
    ls -l |grep "/$"  # 不包含 . ..目录
    或者
    ls -l |grep "^d"  # 不包含 . ..目录
    ls -l | grep "/$" | xargs rm -rf; #删除当前目录下的所有子目录
```
> 目录下的文件个数
```
ls -l | grep "^-" | wc -l #目录下所有文件的个数
ls -l | grep "^d" | wc -l #目录下所有子目录的个数
```