## 连接数、文件数限制
https://www.cnblogs.com/zengkefu/p/5679314.html  
### 1. MySql最大文件数限制
(1). 查看MySql的配置文件
   ```
   mysql --help | grep 'my.cnf'
   ```
(2). 找到配置文件，将最大文件数设置为1000，但最大却为214
   ```
   service mysql status         --查看状态，找到service对应的配置文件
   vim /usr/lib/systemd/system/mysql.service

   --在后面添加
   LimitNOFILE=65535
   LimitNPROC=65535

   --重启mysql
   service mysql restart

   注意：有的时候是mysqld
   ```
