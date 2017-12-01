## 查找替换
> 查找当前文件夹下，所有以`.js`结尾的文件，将其名字中为`AA`的部分替换为`BB`。
```
find . -name "*.js" |xargs sed -i 's#AA#BB#g'
```