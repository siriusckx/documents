# Git配置
## Windows使用Git慢的问题，在bash中添加
* `git config --global core.preloadindex true`
* git config --global core.fscache true``
## 记住登录用户和密码
* `git config --global credential.helper store`
## 禁止自动转换windows和linux的回车换行
* `git config --global core.autocrlf false`
* `git config --global core.safecrlf true`
## remote: Permission to ***/***.git denied to *** 问题解决（Windows）
* `控制面板`→`用户账户`→`凭证管理器`→将对应的凭证删除，然后再重新`git push`输入新的用户名和密码即可
## error setting certificate verify locations CAfile:false; CApath:none;
* 解决办法1：修改成正确的路径
```
git config --system http.sslcainfo "C:\Program Files (x86)\git\bin\curl-ca-bundle.crt"
```
* 解决办法2：去掉这个验证
```
git config --system http.sslverify false
```