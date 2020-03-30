## tar命令进行打包解压
> 带压缩的打包,排除某个目录和文件,并将新打包的内容放到另外的一个目录，注意在使用`--exclude`的时候，如果排除的是目录，最后一个不要带上 `/`
```
tar zcvf test.tar.gz ./* --exclude=./tmp --exclude=a.jar -C ./newdir
```

> 将打包的内容进行解压
```
tar zxvf test.tar.gz -C ./newdir
```