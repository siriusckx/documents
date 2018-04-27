## tar命令进行打包解压
> 带压缩的打包,排除某个目录和文件,并将新打包的内容放到另外的一个目录
```
tar zcvf test.tar.gz ./* --exclude=./tmp --exclude=a.jar -C ./newdir
```

> 将打包的内容进行解压
```
tar zxvf test.tar.gz -C ./newdir
```