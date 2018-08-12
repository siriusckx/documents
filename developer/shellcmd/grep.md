## 通过正则表达式进行文本匹配
> **格式**: grep [option] pattern filename 注意: pattern如果是表达式或者超过两个单词的, 需要用引号引用. 可以是单引号也可双引号, **区别是单引号无法引用变量而双引号可以**。

### grep常用简单表达式
> 获取日志中以今天开头的09:00分的日志,将其放到另一个文件里面并进行查看
```
grep "^$(date -d now +'%F 09:00')" test.log > tmp.log;less tmp.log;
```

> 查询语句中的多个关键字，中途可以由任意字符.*来替换
```
grep .*2018-04-27.*over tmp.log;
```
> 查询一行中即包括2018-04-27又包括over结尾的内容

> 查询的时候忽略大小写
```
grep -i aaa tmp.log ;
```
> 反向查询不包含对应关键字的行
```
grep -v aaa tmp.log;
```
>查询出内容添加行号
```
grep -n aaa tmp.log;
```
>查询出内容的行数不打印内容
```
grep -c aaa tmp.log;
```
>查询含特殊字符的固定内容
```
grep -F "$/aa@*" tmp.log;
```

### grep进阶表达式
> 在正则表达式中一些用来代表特殊含义的+、?、|、()、{}作为扩展的来进行对待，使用egrep 或者 grep -E

> f前包含1个或多个小写字母
```
grep -E "[a-z]+f" tmp.log; 
```
>a和d之间包含0个或1个符号
```
grep -E "a?d" tmp.log; 
```
> 包含a或者b或者d的行
```
grep -E "a|b|d" tmp.log;
```
> love(able|rs)ov+匹配loveable或lovers，连上o,再匹配一个或多个v.
```
grep -E "love(able|rs)ov+" tmp.log
```
>匹配指定次数{n},{n,},{n,m}
```
grep -E "a{2}" tmp.log 
```

参考：  
[正则表达式语法](http://www.runoob.com/regexp/regexp-syntax.html)     
[linux中grep和egrep的用法](http://blog.sina.com.cn/s/blog_4e7cf89d01000c49.html)  
[在线正则表达式测试](http://tool.oschina.net/regex#)


