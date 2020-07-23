# Linux 三剑客之 awk 详解

> awk 不仅仅是 linux 系统中的一个命令，而且是一种编程语言；它可以用来处理数据和生成报告（excel）; 处理的数据可以是一个或多个文件；可以直接来自标准输入，也可以通过管道获取标准输入；awk 可以在命令上直接编辑命令进行操作，也可以编写成 awk 程序来进行更为复杂的运用。

## 一、awk环境简介

> 本文涉及的 awk 为 gawk ,即 GNU 版本的 awk 。

```
    [root@tg-c13-xuntou-zyhq-8 mds]# cat /etc/redhat-release 
    CentOS Linux release 7.2.1511 (Core) 
    [root@tg-c13-xuntou-zyhq-8 mds]# uname -r
    3.10.0-327.el7.x86_64
    [root@tg-c13-xuntou-zyhq-8 mds]# ll `which awk`
    lrwxrwxrwx. 1 root root 4 Nov 24  2017 /usr/bin/awk -> gawk
    [root@tg-c13-xuntou-zyhq-8 mds]# awk --version
    GNU Awk 4.0.2
```

## 二、 awk的格式

> awk 指令是由模式、动作、或者模式和动作的组合组成。

```
awk [ option ] 'pattern {action}' file
```
> option 参数。

> pattern 模式（即找谁），可以类似理解成 sed 的模式匹配，可以由表达式组成，也可以是两个正斜杠之间的正则表达式。比如 `NR == 1` ，这就是模式，可以把它理解成一个条件。

> action 动作（干啥），是由在大括号里面的一条或多条语句组成，语句之间使用分号隔开。如下 awk 使用格式。

## 三、记录和域

|名称|含义|
|--|--|
|record|记录，行|
|field|域、区域、字段、列|

1. NF (number of field) 表示一行中的区域（列）数量，`$NF` 取最后一个区域，`$(NF-1)` 取倒倒数第二个区域。
2. $ 符号表示取某个列（区域）， $1, $2, $NF 。
3. NR(number of record) 行号， awk 对每一行的记录号都有一个内置变量 NR 来保存，每处理完一条记录 NR 的值就会自动 +1 。
4. FS (-F) field separator 列分隔符，以什么把行分隔成多列。

### 3.1 指定分隔符

```
[root@creditease awk]# awk -F "#" '{print $NF}' awk.txt
GKL$123
GKL$213
GKL$321
[root@creditease awk]# awk -F '[#$]' '{print $NF}' awk.txt
123
213
321
```

### 3.2 基本的条件和动作

```
[root@creditease awk]# cat awk.txt
ABC#DEF#GHI#GKL$123
BAC#DEF#GHI#GKL$213
CBA#DEF#GHI#GKL$321
[root@creditease awk]# awk -F "#" 'NR==1{print $1}' awk.txt
ABC
```

### 3.3 只有条件（默认打印所有域）

```
[root@creditease awk]# awk -F "#" 'NR==1' awk.txt
ABC#DEF#GHI#GKL$123
```

### 3.4 只有动作（默认处理所有行）

```
[root@creditease awk]# awk -F "#" '{print $1}' awk.txt
ABC
BAC
CAB
```

### 3.5 多个模式和动作

```
[root@creditease awk]# awk -F "#" 'NR==1{print $NF}NR==3{print $NF}' awk.txt
GKL$123
GKL$321
```

### 3.6 对$0的认识

> awk 中 $0 表示整行

```
[root@creditease awk]# awk '{print $0}' awk_space.txt
ABC DEF GHI GKL$123
BAC DEF GHI GKL$213
CBA DEF GHI GKL$321
```

### 3.7 FNR

> FNR 与 NR 类似，不过多文件记录不递增，每个文件都从1开始

```
[root@creditease awk]# awk '{print NR}' awk.txt awk_space.txt
1
2
3
4
5
6
[root@creditease awk]# awk '{print FNR}' awk.txt awk_space.txt
1
2
3
1
2
3
```

# 四、正则表达式

> awk 同 sed 一样也可以通过模式匹配来对输入的文本进行匹配处理。 awk 也支持大量的正则表达式模式，大部分与 sed 支持的元字符类似，而且正则表达式是玩转三剑客的必备工具。一般的正则表达式元字符，awk 支持，`{}` 正则表达式元字符 awk 不支持。

> 正则表达式的使用，默认是在行内查找匹配的字符串，若有匹配则执行 action 操作，但是有时候仅需要固定的列表匹配指定的正则表达式。

> 比如：

> 我想取 /etc/passwd 文件中第五列 ($5) 这一列查找匹配 mail 字符串的行，这样就需要用另外两个匹配操作符。并且 awk 里面只有这两个操作符来匹配正则表达式的。

|正则匹配操作符|作用|
|--|--|
|~|用于对记录或区域的表达式进行匹配。|
|!~|用于表达与~相反的意思|

### 4.1 显示 awk.txt 中 GHI 列

```
linux-sn4a:/tmp # cat > awk.txt << EOF
> ABC#DEF#GHI#GKL\$123
> BAC#DEF#GHI#GKL\$213
> CBA#DEF#GHI#GKL\$321
> EOF
linux-sn4a:/tmp # awk -F "#" '{print $3}' awk.txt 
GHI
GHI
GHI
linux-sn4a:/tmp # awk -F "#" 'print $(NF-1)' awk.txt
awk: cmd. line:1: print $(NF-1)
awk: cmd. line:1: ^ syntax error
linux-sn4a:/tmp # awk -F "#" '{print $(NF-1)}' awk.txt
GHI
GHI
GHI
linux-sn4a:/tmp # 
```

### 4.2 显示包含321的行

```
linux-sn4a:/tmp # awk '/321/{print $0}' awk.txt
CBA#DEF#GHI#GKL$321
linux-sn4a:/tmp # 
```

### 4.3 以 # 为分隔符，显示第一列以 B 开头或最后一列以 1 结尾的行

```
linux-sn4a:/tmp # awk -F "#" '$1~/^B/{print $0}$NF~/1$/{print $0}' awk.txt 
BAC#DEF#GHI#GK$213
CBA#DEF#GHI#GKL$321
```

### 4.4 以 # 为分隔符，显示第一列以 B 或 C 开头的行

```
linux-sn4a:/tmp # awk -F "#" '$1~/^B|^C/{print $0}' awk.txt 
BAC#DEF#GHI#GK$213
CBA#DEF#GHI#GKL$321
linux-sn4a:/tmp # awk -F "#" '$1~/^[BC]/{print $0}' awk.txt 
BAC#DEF#GHI#GK$213
CBA#DEF#GHI#GKL$321
linux-sn4a:/tmp # awk -F "#" '$1~/^(B|C)/{print $0}' awk.txt 
BAC#DEF#GHI#GK$213
CBA#DEF#GHI#GKL$321
linux-sn4a:/tmp # awk -F "#" '$1!~/^A/{print $0}' awk.txt 
BAC#DEF#GHI#GK$213
CBA#DEF#GHI#GKL$321
```

## 五、比较表达式

> awk 是一种编程语言，能够进行更为复杂的判断，当条件为真时， awk 就执行相关的 action ，主要是在针对某一区域做出相关的判断，比如打印成绩在 80 分以上的，这样就必须对这一个区域作比较判断。

### 5.1 显示表达式的第 2，3 行

```
linux-sn4a:/tmp # awk 'NR==2{print $0}NR==3{print $0}' awk.txt 
BAC#DEF#GHI#GK$213
CBA#DEF#GHI#GKL$321
linux-sn4a:/tmp # awk 'NR==2,NR==3{print $0}' awk.txt 
BAC#DEF#GHI#GK$213
CBA#DEF#GHI#GKL$321
linux-sn4a:/tmp # awk '/BAC/,/CBA/{print $0}' awk.txt 
BAC#DEF#GHI#GK$213
CBA#DEF#GHI#GKL$321
linux-sn4a:/tmp # 
```

## 六、awk 模块、变量与执行

> 完整 awk 结构图如下：

```
    开始模块       模式     动作     结束模块
awk BEGIN{coms} 'pattern1{action}' END{coms}
```

> BEGIN 模块在 awk 读取文件之前就执行，BEGIN 模式常常被用来修改内置变量 ORS, RS, FS, OFS 等的值，可以不接任何输入件。

|变量名|属性|
|--|--|
|$0|当前记录，一整行|
|$1,$2,$3 ... $a|当前记录的第n个区域，区域间由 FS 分隔|
|FS|输入区域分隔符，默认是空格。field separator|
|NF|当前记录中的区域个数，就是有多少列。number of field|
|NR|已经读出的记录数，就是行号，从1开始。number of record|
|RS|输入的记录分隔符默认为换行符。record separator|
|OFS|输出区域分隔符，默认也是空格。output record separator|
|FNR|当前文件的读入记录号，每个文件重新计算。|
|FILENAME|当前正在处理的文件的文件名|

### 6.1 BEGIN第一个作用：定义内置变量

```
linux-sn4a:/tmp # awk 'BEGIN{RS="#"}{print $0}' awk.txt 
ABC
DEF
GHI
G$123
BAC
DEF
GHI
GK$213
CBA
DEF
GHI
GKL$321
```

### 6.2 BEGIN第二个作用：打印标识

```
linux-sn4a:/tmp # awk 'BEGIN{print "=======start======"}{print $0}' awk.txt 
=======start======
ABC#DEF#GHI#G$123
BAC#DEF#GHI#GK$213
CBA#DEF#GHI#GKL$321
```

### 6.3 awk实现计算功能
```
linux-sn4a:/tmp # awk 'BEGIN{a=8; b=90; print a+b, a-c, a/b, a%b}'
98 8 0.0888889 8
```

> END在awk读取完所有的文件的时候，再执行END模块，一般用来输出一个结果（累加、数组结果）。也可以是和BEGIN模块类似的结尾标识信息。

### 6.4 END第一个作用：打印标识
```
linux-sn4a:/tmp # awk 'BEGIN{print "=======start======"}{print $0}END{print "========end========"}' awk.txt 
=======start======
ABC#DEF#GHI#G$123
BAC#DEF#GHI#GK$213
CBA#DEF#GHI#GKL$321
========end========
```

### 6.5 END第二个作用：累加
（1）统计空行（blank.txt 文件）

> awk 中的变量，可以直接使用，默认初始值为 0 。
```
linux-sn4a:/tmp # cat > blank.txt << EOF
> blandkadfadf
> 
> adf
> 
> 
> EOF
linux-sn4a:/tmp # grep "^$" blank.txt |wc -l
3
linux-sn4a:/tmp # sed -n '/^$/p' blank.txt |wc -l
3
linux-sn4a:/tmp # awk '/^$/' blank.txt |wc -l
3
linux-sn4a:/tmp # awk '/^$/{i=i+1}END{print i}' blank.txt 
3
```

（2）算术题

> 1 + 2 + 3 ...... + 100 = 5050，怎么用 awk 表示？

```
linux-sn4a:/tmp # seq 100|awk '{i=i+$0}END{print i}'
5050
```

> 总结：
> 1. BEGIN 和 END模块只能有一个， BEGIN{}BEGIN{} 或者 END{}END{}都是错误的。
> 2. PATHEN找谁、ACTION干啥模块，可以是多个。

## 七、awk 数组与语法

### 7.1 数组结构

```
 数组名    元素名  元素值
arrayname[string]=value
```
```
linux-sn4a:/tmp # awk 'BEGIN{word[0]="credit"; word[1]="easy"; print word[0],word[1]}'
credit easy
linux-sn4a:/tmp # awk 'BEGIN{word[0]="credit"; word[1]="easy"; for(i in word) print word[i]}'
credit
easy
```

### 7.2 数组分类
> 索引数组：以数字为下标
> 关联数组：以字符串为下标

### 7.3 awk 关联数组

> 现有如下文本，格式如下：即左边是随机字母，右边是随机数字，即将相同的字母后面的数字加在一起，按字母的顺序输出。

```
a 1
b 3
c 2
d 7
b 5
a 3
g 2
f 6
```
> 以 $1 为下标，创建数组 a[$1] = a[$1] + $2 (a[$1] += $2) 然后配合 END 和 for 循环输出结果：

```
linux-sn4a:/tmp # cat > jia.txt << EOF
> a 1
> b 3
> c 2
> d 7
> b 5
> a 3
> g 2
> f 6
> EOF
linux-sn4a:/tmp # awk '{a[$1]=a[$1]+$2}END{for(i in a)print i,a[i]}' jia.txt
a 4
b 8
c 2
d 7
f 6
g 2
```
### 7.4 awk 索引数组

> 以数字为下标的数组 seq 生成 1-10 的数字，要求只显示计数行。

```
linux-sn4a:/tmp # seq 10|awk '{a[NR]=$0}END{for(i=1;i<=NR;i+=2){print a[i]}}'
1
3
5
7
9
```

> seq 生成 1-10的数字，要求不显示文件的后 3 行
```
linux-sn4a:/tmp # seq 10|awk '{a[NR]=$0}END{for(i=1;i<=NR-3;i++){print a[i]}}'
1
2
3
4
5
6
7
```

### 7.5 awk 数组实战去重

> 对如下文本进行去重处理，针对第二列去重
```
linux-sn4a:/tmp # cat > qc.txt << EOF
> 2018/10/20   xiaoli     13373305025
> 2018/10/25   xiaowang   17712215986
> 2018/11/01   xiaoliu    18615517895 
> 2018/11/12   xiaoli     13373305025
> 2018/11/19   xiaozhao   15512013263
> 2018/11/26   xiaoliu    18615517895
> 2018/12/01   xiaoma     16965564525
> 2018/12/09   xiaowang   17712215986
> 2018/11/24   xiaozhao   15512013263
> EOF
解法一：此方法去重后的结果显示的是文本开头开始的所有不重复的行
linux-sn4a:/tmp # awk '!a[$2]++' qc.txt 
2018/10/20   xiaoli     13373305025
2018/10/25   xiaowang   17712215986
2018/11/01   xiaoliu    18615517895 
2018/11/19   xiaozhao   15512013263
2018/12/01   xiaoma     16965564525
解法二：此方法去重后的结果显示的是文本开头开始的所有不重复的行
linux-sn4a:/tmp # awk '++a[$2]==1' qc.txt
2018/10/20   xiaoli     13373305025
2018/10/25   xiaowang   17712215986
2018/11/01   xiaoliu    18615517895 
2018/11/19   xiaozhao   15512013263
2018/12/01   xiaoma     16965564525
解法三：此方法去重后的结果显示的是文本结尾开始的所有不重复的行
linux-sn4a:/tmp # awk '{a[$2]=$0}END{for(i in a){print a[i]}}' qc.txt 
2018/11/12   xiaoli     13373305025
2018/11/26   xiaoliu    18615517895
2018/12/01   xiaoma     16965564525
2018/12/09   xiaowang   17712215986
2018/11/24   xiaozhao   15512013263
```

### 7.6 awk 处理多个文件（数组、NR、FNR）

> 使用 awk 取 file.txt 的第一列和 file1.txt 的第二列然后重定向到一个新文件 new.txt 中
```
linux-sn4a:/tmp # cat > file1.txt << EOF
> a b
> c d
> e f
> g h
> i j
> EOF
linux-sn4a:/tmp # cat > file2.txt << EOF
> 1 2
> 3 4
> 5 6
> 7 8
> 9 10
> EOF
linux-sn4a:/tmp # awk 'NR==FNR{a[FNR]=$1}NR!=FNR{print a[FNR],$2}' file1.txt file2.txt 
a 2
c 4
e 6
g 8
i 10
linux-sn4a:/tmp # awk 'NR==FNR{a[FNR]=$1}NR!=FNR{print a[FNR],$2}' file1.txt file2.txt > new.txt
linux-sn4a:/tmp # cat new.txt 
a 2
c 4
e 6
g 8
i 10
```

### 7.7 awk 分析日志文件，统计访问网站个数

```
linux-sn4a:/tmp # cat > url.txt << EOF
> http://www.baidu.com
> http://mp4.video.cn
> http://www.qq.com
> http://www.listeneasy.com
> http://mp3.music.com
> http://www.qq.com
> http://www.qq.com
> http://www.listeneasy.com
> http://www.listeneasy.com
> http://mp4.video.cn
> http://mp3.music.com
> http://www.baidu.com
> http://www.baidu.com
> http://www.baidu.com
> http://www.baidu.com
> EOF
linux-sn4a:/tmp # awk -F "[/]+" '{h[$2]++}END{for(i in h) print i,h[i]}' url.txt 
www.qq.com 3
www.baidu.com 5
mp4.video.cn 2
mp3.music.com 2
www.listeneasy.com 3
```

## 八、awk 简单语法
### 8.1 函数sub gsub

```
linux-sn4a:/tmp # cat > sub.txt << EOF
> ABC DEF AHI GKL$123
> BAC DEF AHI GKL$213
> CBA DEF GHI GKL$321
> EOF

注意：sub 只会替换行内匹配的第一次内容；相当于 sed 's###'
linux-sn4a:/tmp # awk '{sub(/A/,"a");print $0}' sub.txt 
aBC DEF AHI GKL23
BaC DEF AHI GKL13
CBa DEF GHI GKL21

注意：gsub 会替换行内匹配的所有内容；相当于 sed 's###g'
linux-sn4a:/tmp # awk '{gsub(/A/,"a");print $0}' sub.txt 
aBC DEF aHI GKL23
BaC DEF aHI GKL13
CBa DEF GHI GKL21
linux-sn4a:/tmp # 
```

### 8.2 练习

> 以 ‘|’为分隔， 现要将第二个域字母前的数字去掉，其他地方都不变
```
linux-sn4a:/tmp # cat > sub_hm.txt << EOF
> 0001|20081223efskjfdj|EREADFASDLKJCV
> 0002|20081208djfksdaa|JDKFJALSDJFsddf
> 0003|20081208efskjfdj|EREADFASDLKJCV
> 0004|20081211djfksdaa1234|JDKFJALSDJFsddf
> EOF

linux-sn4a:/tmp # awk -F "|" 'BEGIN{OFS="|"}{sub(/[0-9]+/,"",$2);print $0}' sub_hm.txt 
0001|efskjfdj|EREADFASDLKJCV
0002|djfksdaa|JDKFJALSDJFsddf
0003|efskjfdj|EREADFASDLKJCV
0004|djfksdaa1234|JDKFJALSDJFsddf
```

### 8.3 if 和 else 用法

```
linux-sn4a:/tmp # cat > ifelse.txt << EOF
> AA
> BC
> AA
> CB
> CC
> AA
> EOF

匹配到 AA 则打印 YES, 未匹配到 AA 则打印 NO YES
linux-sn4a:/tmp # awk '{if($0~/AA/){print $0" YES"} else{print $0" NO YES"}}' ifelse.txt 
AA YES
BC NO YES
AA YES
CB NO YES
CC NO YES
AA YES

匹配到 AA 则打印 YES, 未匹配到 AA 则打印 NO YES
linux-sn4a:/tmp # awk '$0~/AA/{print $0" YES"}$0!~/AA/{print $0" NO YES"}' ifelse.txt 
AA YES
BC NO YES
AA YES
CB NO YES
CC NO YES
AA YES

next:跳过后边的所有代码，next前面的匹配，后面的部分则不执行，前面的不匹配，才执行后面的部分
linux-sn4a:/tmp # awk '$0~/AA/{print $0" YES";next}$0!~/AA/{print $0" NO YES"}' ifelse.txt 
AA YES
BC NO YES
AA YES
CB NO YES
CC NO YES
AA YES
```

### 8.4 printf不换行输出

```
linux-sn4a:/tmp # cat > printf.txt << EOF
> Packages: Hello-1
> Owner: me me me me
> Other: who care?
> Description:
> Hello world!
> Other2: don't care
> EOF

注意：printf打印（不换行），print打印（需换行）
linux-sn4a:/tmp # awk '/Desc.*:$/{printf $0}!/Desc.*:$/{print $0}' printf.txt 
Packages: Hello-1
Owner: me me me me
Other: who care?
Description:Hello world!
Other2: don't care
```

### 8.5 去重后计数按要求重定向到指定文件

> 文本如下，要求计算出每项重复的个数，然后把重复次数大于 2 的放入 gt2.txt 文件中，把重复次数小于等于 2 的放入 le2.txt 文件中。

```
linux-sn4a:/tmp # cat > qcjs.txt << EOF
> aaa
> bbb
> ccc
> aaa
> ddd
> bbb
> rrr
> ttt
> ccc
> eee
> ddd
> rrr
> bbb
> rrr
> bbb
> EOF
```

```
思路：通过联合数组进行统计，然后最后END通过for循环将值输出到对应的文件中
解析：{print }，或括号中打印后可直接重定向到一个新文件，文件名用双引号引起来。如{print $1 > "xin.txt"}
linux-sn4a:/tmp # awk '{a[$1]++}END{for(i in a){if(a[i]>2){print i,a[i]>"gt2.txt"}else{print i,a[i]>"le2.txt"}}}' qcjs.txt 
linux-sn4a:/tmp # cat gt2.txt 
rrr 3
bbb 4
linux-sn4a:/tmp # cat le2.txt 
aaa 2
ccc 2
eee 1
ttt 1
ddd 2
```



# 九、 awk一些实践例子
## 9.1 使用分隔符提取相应的列

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

## 9.2 打印前N行

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

## 9.3 使用正则匹配对应的列

> 例：以 # 为分隔符，显示第一列以B开头或最后一列以1结尾的行

```
awk -F "#" '$1~/^B/{print $0}$NF~/1$/{print $0}' awk.txt
```

## 9.4 读取文件中的每一行，判断是否在另一个文件中存在

```
for line in $(<gte110times.txt); do grep $line login.log; done
```

## 9.5 将某个程序的依赖库拷贝到当前目录

```shell
for i in `ldd proxy |awk -F '=>' '{print $2}'|awk -F ' ' '{print $1}'`;do cp $i .; done
```



