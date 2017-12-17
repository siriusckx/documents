## 连接MySQL
`mysql`> `mysql -u username -ppassword db_name;`
`mysql`:`mysql -u root -p123456 pets;`

## 创建用户
> 创建用户，只能访问`localhost`,给用户赋增加、删除、修改、查询权限

`mysql`> `CREATE USER 'chengkx'@'localhost' IDENTIFIED BY '123456';`
`mysql`> `GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP ON pets.* TO 'chengkx'@'localhost';`

> 为用户授权，能够创建、删除表

`mysql`>`GRANT CREATE,DROP ON pets.* TO 'chengkx'@'localhost';`

> 查看用度权限、查看创建用户语句

`mysql`>`SHOW GRANTS FOR 'chengkx'@'localhost';`
`mysql`>`SHOW CREATE USER 'chengkx'@'localhost';`

> 删除账号

`mysql`>`DROP USER 'chengkx'@'localhost'; `

> 查询有没有这个账号

## 用户资源限制

## 用户密码管理
