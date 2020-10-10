## 1 单引号 ‘ 的使用

## 2 双引号 “ 的使用

### 2.1 变量要用双 ” 号括起来

`shell`变量 IFS 默认是使用 `空格`，`\n`,  `tab` 进行分隔的，避免在变量中出现空格导致其他的二义性，变量需要用双“号括起来。

```shell
#!/bin/bash

# 目录下有包含空格的文件名，此时下面就会出现得不到的结果
for file in /home/rich/test/*
do

    if [ -d "$file" ]
    then
       echo "$file is a directory"
    elif [ -f "$file" ]
    then
       echo "$file is a file"
    fi
done
```

