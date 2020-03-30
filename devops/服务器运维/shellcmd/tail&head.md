# tail和head的联合使用
>总结：注意head和tail通过|进行联合使用，注意①head在前还是tail在前；②对应数字带+、-和不带符号时的区别。

>从第11行开始显示，除最后3行的内容
```
 head -n -3 /etc/passwd |tail -n +11
```
>显示前20行，但从第11行开始
```
head -n 20 /etc/passwd |tail -n +11 
```
>显示除最后3行以外的所有行，但只显示最后10行
```
 head -n -3 /etc/passwd |tail -n 10 
```
>显示前20行中的后10行
```
head -n 20 /etc/passwd |tail -n 10 
```
>从第11行开始显示，但只显示前10行
```
tail -n +11 /etc/passwd |head -n 10 
```
>从第11行开始显示，但不包括最后3行
```
tail -n +11 /etc/passwd |head -n -3
```
>显示最后13行中的前10行
```
tail -n 13 /etc/passwd |head -n 10 
```
>显示最后13行中除末尾的3行以外的前10行
```
tail -n 13 /etc/passwd |head -n -3
```