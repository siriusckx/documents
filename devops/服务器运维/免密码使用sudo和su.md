> 本文引自： https://www.jianshu.com/p/5d02428f313d

> 因为最近频繁的使用su root命令，受够了每次都要输入密码，于是网上搜了搜解决方案，还真有解决方案，不敢独享，整理分享给大家。
奉上原帖地址：
http://www.cnblogs.com/itech/archive/2009/08/07/1541017.html

# 设置sudo免密码
> sudo是linux系统管理指令，是允许系统管理员让普通用户执行一些或者全部的root命令的一个工具，如halt、reboot、su等等。

## 登录到 root 用户
## 将用户加入sudoers
```
visudo // 或者 vi /etc/sudoers
```
> 默认5分钟后刚才输入的sodo密码过期，下次sudo需要重新输入密码，如果觉得在sudo的时候输入密码麻烦，把刚才的输入换成如下内容即可：
your_user_name ALL=(ALL) NOPASSWD: ALL

> 注意： 有的时候你的将用户设了nopasswd，但是不起作用，原因是被后面的group的设置覆盖了，需要把group的设置也改为nopasswd。
your_user_name ALL=(ALL) NOPASSWD: ALL
%admin ALL=(ALL) NOPASSWD: ALL

## 设置 su 为不需要密码
> 如果需要对某用户su命令也不需要输入密码，则需要修改下列的：
* 切换到 root 权限
* 创建group为wheel，命令为groupadd wheel；
* 将用户加入wheel group中，命令为`usermod -G wheel your_user_name`；
* 修改su的配置文件/etc/pam.d/su,增加下列项：
```
 auth       required   pam_wheel.so group=wheel 
# Uncomment this if you want wheel members to be able to
# su without a password.
 auth       sufficient pam_wheel.so trust use_uid
```
> 至此你可以使用su root命令且不需要输入密码。