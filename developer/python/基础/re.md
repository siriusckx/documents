## 常用的方法

1.  compile(pattern, flags = 0) 

2. match(pattern, string, flags = 0)

   > 的概念是从头匹配一个符合规则的字符串，从 **起始位置** 开始匹配，匹配成功返回一个对象，未匹配成功返回None

3. search(pattern, string ,flags = 0) 

   > 函数会在字符串内查找模式匹配,只要找到第一个匹配然后返回，如果字符串没有匹配，则返回None。

4. findall(pattern, string[,flags] ) 

5. finditer(pattern, string[,flags] ) 

6. split(pattern, string, max = 0)

7. group(num = 0)

## re.Match 匹配对象

1.  group() 返回被 RE 匹配的字符串
2. start() 返回匹配开始的位置
3. end() 返回匹配结束的位置
4. span()返回一个元组包含匹配 (开始,结束) 的位置