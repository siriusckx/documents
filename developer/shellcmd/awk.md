# 1. awk的使用
## 1.1 使用分隔符提取相应的列

> 使用指定的分隔符 : 对文本内容进行分隔，并提取最后一列

```
awk -F ':' '{printf $NF}' test.txt
```

> 使用指定的分隔符 : 对文本内容进行分隔，提取最后一列，并在每列前面添加字符串

```
awk -F ':' '"/glusterfs/metadatas/"{printf $NF}' test.txt
```

> 使用指定的分隔符 : 对文本内容进行分隔，提取最后一列，并在每列前面添加字符串，最后将所有的列合成一行，用空格进行分隔。

```
awk -F ':' '{print "/glusterfs/metadatas/"$NF}' bson_error.log |tr -s "\n" " " 
```

> 第一次使用“:”对文本进行分割，将提取出来的列，再使用“,”进行二次分割，并打印二次分割后的所有列
```
awk -f ':' '{l=split($2, a , ","); for(i=0; i<=l; i++){print a[i]}}' test.txt
```

> 第一次使用“:”对文本进行分割，将提取出来的列，再使用“,”进行二次分割，并打印出二次分割后的第一列，再每一列前面添加字符串

```
awk -f ':' '{l=split($2, a, ","); {print "/glusterfs/metadatas/"a[i]}}' test.txt
```

## 1.2 打印前N行

> 打印前10行

```
awk 'NR <10 {print $0}' test.txt
```
> 打印前10行，还带上行号

```
awk 'NR <10 {print NR,$0}' test.txt
```

> 第一次使用“:”对文本进行分割，将提取出来的列，再使用“,”进行二次分割，并打印出二次分割后的第一列，再每一列前面添加字符串,并打印前10行

```
awk -f ':' 'NR <10{l=split($2, a, ","); {print "/glusterfs/metadatas/"a[i]}}' test.txt
```
