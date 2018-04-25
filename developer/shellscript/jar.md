## 解压到当前目录
```
jar xvf lm.jar
```
## 打包的时候引入MANIFEST(SpringBoot打包适用)
```
jar cvfm0 test-1.0.0-RELEASE.ja ./META-INF/MANIFEST.MF .

参数含义：
c:创建一个jar包
v:显示压缩过程的信息
f:指定文件名字
m:指定MANIFEST.MF文件
0:对打包的内容不进行压缩
```

## 更新jar包的内容
   >前提是要对jar包的结构十分了解，要更新的内容的路径，也要和jar包的路径保持一致
```
   #查看jar包结构
   jar tf test-1.0.0-RELEASE.jar 
```
```
   #更新test-1.0.0-RELEASE.jar包内BOOT-INF/lib/test-page-1.0.0-RELEASE.jar的这一个jar包
   jar uf0 test-1.0.0-RELEASE.jar BOOT-INF/lib/test-page-1.0.0-RELEASE.jar 
```
