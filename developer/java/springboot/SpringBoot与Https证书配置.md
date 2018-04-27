## SpringBoot要使用HTTPS
1. 进行代码修改：
[Spring Boot SSL [https] Example](https://howtodoinjava.com/spring/spring-boot/spring-boot-ssl-https-example/)

1. 证书的生成：
[【spring boot】配置ssl证书实现https](https://blog.csdn.net/arctan90/article/details/54142146)  
```
步骤一： openssl req -new -key myPrivateKey.key -out server.csr
```
>myPrivateKey.key自己保存，server.csr提交给代理商进行签名，代理商签名完成后会给出 yourDomain.crt文件

```
步骤二： openssl pkcs12 -export -clcerts -in yourDomain.crt -inkey myPrivateKey.key -out server.p12
```
>  这样生成了spring boot上可以用的私钥格式文件 server.p12 在这个转换的过程中要求输入一个密码，请记住这个**密码**

```
步骤三： keytool -list -keystore server.p12
```
> 运行该命令会提示你输入密码，就是上面设置的密码，输入密码后会显示, 您的密钥库包含 1 个条目`1, 2017-1-7, PrivateKeyEntry`注意这个1这是我们运行这个命令的目的,这个1即为别名。

```
最终代码：
server.port=8443
server.ssl.key-store:classpath:server.p12
server.ssl.key-store-password: 密码
server.ssl.keyStoreType: PKCS12
server.ssl.keyAlias: 1
```
> 注意：server.p12这个文件存放的位置，要与application.properties在一个层级。