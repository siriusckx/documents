## 一、连接MySQL
`mysql`> `mysql -u username -ppassword db_name;`  
`mysql`:`mysql -u root -p123456 pets;`

## 二、创建用户
> 创建用户，只能访问`localhost`,给用户赋增加、删除、修改、查询权限

`mysql`> `CREATE USER 'chengkx'@'localhost' IDENTIFIED BY '123456';`  
`mysql`> `GRANT SELECT,INSERT,UPDATE,DELETE,ON pets.* TO 'chengkx'@'localhost';`

> 为用户授权，能够创建、删除表

`mysql`>`GRANT CREATE,DROP ON pets.* TO 'chengkx'@'localhost';`

> 查看用户权限、查看创建用户语句

`mysql`>`SHOW GRANTS FOR 'chengkx'@'localhost';`  
`mysql`>`SHOW CREATE USER 'chengkx'@'localhost';`

> 删除账号

`mysql`>`DROP USER 'chengkx'@'localhost'; `

> 查询有没有这个账号

## 三、用户资源限制
> 对用户资源的限制，主要有两个方面，一个是针对用户账号的限制，一个是系统级别的限制。用户级别的控制，通过在Grant后面通过with进行资源的限制，系统级别，则通过变量进行相应 的限制。

1. 用户级别的限制

```
-- 创建账户时通过WITH限制资源
CREATE USER 'chengkx'@'localhost' IDENTIFIED BY '123456'
    WITH MAX_QUERIES_PER_HOUR 20
    MAX_UPDATES_PER_HOUR 10
    MAX_CONNECTIONS_PER_HOUR 5
    MAX_USER_CONNECTIONS 2;

--修改账户时通过WITH限制资源
ALTER USER 'user1'@'localhost' WITH MAX_USER_CONNECTIONS 0;
当数据值为0的时候，表示不做限制，由mysql的全局变量做相应的限制。
```

2. 系统变量查看和使用，参考如下地址https://dev.mysql.com/doc/refman/5.7/en/server-system-variables.html#sysvar_max_user_connections

## 四、用户密码管理
> 用户密码过期管理，主要有两种方式，一种是手动设置密码过期，一种是通过全局变量设置所有的密码过期，在这里要特别注意的一点是，对于那些要通过脚本连接数据库的程序，不能设置其密码过期，以防止应用程序中断。

```
-- 修改用户使其密码过期
ALTER USER 'chengkx'@'localhost' PASSWORD EXPIRE;

-- 创建或修改用户使其密码90天修改一次
CREATE USER 'chengkx'@'localhost' PASSWORD EXPIRE INTERVAL 90 DAY;
ALTER USER 'chengkx'@'localhost' PASSWORD EXPIRE INTERVAL 90 DAY;

-- 创建或修改用户使用其密码永远不过期
CREATE USER 'chengkx'@'localhost' PASSWORD EXPIRE NEVER;
ALTER USER 'chengkx'@'localhost' PASSWORD EXPIRE NEVER;

-- 创建或修改用户使其密码遵循系统全局配置
CREATE USER 'chengkx'@'localhost' PASSWORD EXPIRE DEFAULT;
ALTER USER 'chengkx'@'localhost' PASSWORD EXPIRE DEFAULT;

-- 设置MYSQL系统变量，密码过期策略
在my.cnf里面配置 default_password_lifetime=180 ## 代表180天要改一次密码，为0代表不限制。

通过命令进行设置（系统重启后可能无效，待确认）SET GLOBAL default_password_lifetime = 180; 为0时代表不限制。

-- 注意在修改用户密码的时候，对于5.7.6之前的版本要使用SET PASSWORD语句进行修改，而不能使用ALTER USER语句进行修改。

```
## 五、用户认证插件
> 客户端在连到服务器端之后，需要认证连接的客户端是不是有相应的权限，这是通过认证插件进行实现的。常用的认证插件有：  

1. 本地密码哈希认证插件 [Native Pluggable Authentication](https://dev.mysql.com/doc/refman/5.7/en/native-pluggable-authentication.html)，[ older (pre-4.1) Native Pluggable Authentication ](https://dev.mysql.com/doc/refman/5.7/en/old-native-pluggable-authentication.html)，
1. SHA-256密码哈希认证插件 [SHA-256 Pluggable Authentication](https://dev.mysql.com/doc/refman/5.7/en/sha256-pluggable-authentication.html)
1. [Section 6.5.1.5, “Client-Side Cleartext Pluggable Authentication”](https://dev.mysql.com/doc/refman/5.7/en/cleartext-pluggable-authentication.html)
1. [ Section 6.5.1.6, “PAM Pluggable Authentication”](https://dev.mysql.com/doc/refman/5.7/en/pam-pluggable-authentication.html)
1. [ Section 6.5.1.7, “Windows Pluggable Authentication”](https://dev.mysql.com/doc/refman/5.7/en/windows-pluggable-authentication.html)
1. [ Section 6.5.1.8, “LDAP Pluggable Authentication”](https://dev.mysql.com/doc/refman/5.7/en/ldap-pluggable-authentication.html)
1. [Section 6.5.1.9, “No-Login Pluggable Authentication”](https://dev.mysql.com/doc/refman/5.7/en/no-login-pluggable-authentication.html)
1. [ Section 6.5.1.10, “Socket Peer-Credential Pluggable Authentication”](https://dev.mysql.com/doc/refman/5.7/en/socket-pluggable-authentication.html)
1. [ Section 6.5.1.11, “Test Pluggable Authentication”](https://dev.mysql.com/doc/refman/5.7/en/test-pluggable-authentication.html)
1. [自己定义的插件](https://dev.mysql.com/doc/refman/5.7/en/writing-authentication-plugins.html)

**注意NOTE:**[--skip-grant-tables](https://dev.mysql.com/doc/refman/5.7/en/server-options.html#option_mysqld_skip-grant-tables)会使得插件认证无效。注意与[ --skip-networking](https://dev.mysql.com/doc/refman/5.7/en/server-options.html#option_mysqld_skip-networking)的混晓。

## 六、代理用户管理
## 七、用户锁定
## 八、用户激活
## 九、通过表查询用户权限
> `MySql`权限表是指在mysql数据库下的5张表:`user`、`db`、`tables_priv`、`columns_priv`、`procs_priv`
```sql

```
## 十、MySql权限总览
## 十一、MySql控制客户访问原理
### （一）用户连接时的检查
1. 当用户连接的时候，MySQL服务器首先从use表里匹配host、user、password，匹配不到则拒绝该连接。
1. 接着检查user表的max_connections和max_user_connections，如果超过上限则拒绝连接
1. 检查user表的SSL安全连接，如果有配置SSL，则需确认用户提供的证书是否合法
>  只有上面3个检查通过后,服务器才建立连接，连接建立后,当用户执行SQL语句时,需要如下检查。
### （二）执行SQL语句时的检查
1. 检查user表的max_questions和max_updates，如果超过上限则拒绝执行SQL，接下来进行权限检查
1. 首先检查user表,看是否有相应的全局权限，如果有则执行，没有则继续下一步检查
1. 接着到db表，看是否有数据库级别的权限，如果有则执行，没有则继续下一步检查
1. 最后到tables_priv、columns_priv、procs_priv表里查看是否有相应对象的权限

> 从以上的过程,我们可以知道，MySQL检查权限是一个比较复杂的过程，所以为了提高性能，MySQL启动时，会把这5张权限表加载到内存。

## 十一、用户管理经验
1. 尽量使用create user, grant等语句，而不要直接修改权限表。
   > 虽然create user, grant等语句底层也是修改权限表，和直接修改权限表的效果是一样的，但是，对于非高手来说，采用封装好的语句肯定不会出错，而如果直接修改权限表，难免会漏掉某些表。而且，修改完权限表之后，还需要执行flush privileges重新加载到内存，否则不会生效。
1. 把匿名用户删除掉
   > 匿名用户没有密码，不但不安全，还会产生一些莫名其妙的问题，强烈建议删除。
1. 只授予能满足需要的最小权限，防止用户干坏事。
   > 比如用户只是需要查询，那就只给select权限就可以了，不要给用户赋予update、insert或者delete权限。
1. 创建用户的时候限制用户的登录主机，一般是限制成指定IP或者内网IP段。
1. 为每个用户设置满足密码复杂度的密码。
1. 定期清理不需要的用户，回收权限或者删除用户。


参考地址：  
[MySQL之权限管理](http://www.cnblogs.com/Richardzhu/p/3318595.html)  
[探索权限表](https://www.2cto.com/database/201310/252697.html)  
[MySql使用proxies_priv实现用户组管理](http://www.bkjia.com/Mysql/1221537.html)  