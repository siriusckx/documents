## 连接MySQL
`mysql`> `mysql -u username -ppassword db_name;`
`mysql`:`mysql -u root -p123456 pets;`

## 创建用户
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

## 用户资源限制
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

## 用户密码管理
