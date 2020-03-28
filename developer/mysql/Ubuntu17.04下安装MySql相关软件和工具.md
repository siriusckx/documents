## 使用apt-repository方式安装mysql
[官方ubuntu环境下参考网址](https://dev.mysql.com/doc/mysql-apt-repo-quick-guide/en/#repo-qg-apt-available)  
1. 下载[MySQL APT repository](http://dev.mysql.com/downloads/repo/apt/)
1. 选择下载对应的MySQL包`mysql-apt-config_0.8.9-1_all.deb`
1. 切换到包目录下，安装默认的包`sudo dpkg -i mysql-apt-config_0.8.9-1_all.deb`
1. 更新对应的APT库`sudo apt-get update`
1. 安装MySql-Server `sudo apt-get install mysql-server`
1. 查看mysql状态`sudo service mysql status`
1. 停止mysql，`sudo service mysql stop`
1. 启动mysql,`sudo service mysql start`
1. 安装mysql-workbench,`sudo apt-get install mysql-workbench`,在这里要注意一下，官网上写的mysql-workbench-community找不到对应的包。
1. 其他，重新配置`sudo dpkg-reconfigure mysql-apt-config`
1. 查看安装了mysql相关的包`dpkg -l | grep mysql | grep ii`

## 卸载安装的mysql
1. 移除mysql-server，`sudo apt-get remove mysql-server`
1. 移除安装mysql-server时自动安装的其他软件`sudo apt-get autoremove`
1. 移除自己安装的包`sudo apt-get remove package-name`
1. 查看安装了mysql相关的包`dpkg -l | grep mysql | grep ii`

