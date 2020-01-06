# Ansible AWX 安装使用简明文档

https://www.jianshu.com/p/67068436a052

# 注意事项
1. 安装 npm 时要先添加对应的库
   ```
    Install OKey repository:
    # yum install http://repo.okay.com.mx/centos/7/x86_64/release/okay-release-1-1.noarch.rpm

    Install npm rpm package:

    # yum install npm

   ```

# 安装过程遇到问题

## 1. 问题1集锦
> https://www.psay.cn/toss/135.html

## 2. 还需要安装postgreSQL数据库
> 通过官方文档查看，还需要对postgreSQL数据库进行安装  
https://www.jianshu.com/p/7e95fd0bc91a    
https://www.cnblogs.com/think8848/p/5877076.html  

> 注意，如果通过 `pg_ctl start -D $PGDATA` 这个启动了postgres,则`systemctl start postgres-9.5.service`不会启动，报错：
```
 Registered Authentication Agent for unix-process:27165
```
> 参考 https://dba.stackexchange.com/questions/180209/postgresql-service-start-failed-on-centos-7 解决。

## 3. 安装之前最好要仔细查看对应的版本需求
> 使用 awx 9.0.1 的话，需要 ansible 2.8 +
> 版本对不上，可能会出现一些语法上面的错误

```
'int' object is not iterable
```

## 4. ansible报错"RequestsDependencyWarning"
> 原因：python库中urllib3 (1.21.1) or chardet (2.2.1) 的版本不兼容
> 解决办法：
```
pip uninstall urllib3
 
pip uninstall  chardet
 
pip install requests
```

## 5. 如果出现某个python 模块不兼容
> 卸载掉对应的模块，重新安装，尝试不同版本的模块。