# Git配置
## Windows使用Git慢的问题，在bash中添加
* `git config --global core.preloadindex true`
* git config --global core.fscache true``
## 记住登录用户和密码
* `git config --global credential.helper store`
## 禁止自动转换windows和linux的回车换行
1. 提交时转换为LF,检出时转换为CRLF
* `git config --global core.autocrlf true`
2. 提交时转换为LF，检出时不转换
* `git config --global core.autocrlf input`
3. 提交和检出时均不转换
* `git config --global core.autocrlf false`

1. 拒绝提交包含混合换行符的文件
`git config --global core.safecrlf true`   
2. 允许提交包含混合换行符的文件
`git config --global core.safecrlf false`   
3. 提交包含混合换行符的文件时给出警告
`git config --global core.safecrlf warn`

[Git中的AutoCRLF与SafeCRLF换行符问题](http://www.cnblogs.com/flying_bat/p/3324769.html)

## remote: Permission to ***/***.git denied to *** 问题解决（Windows）
* `控制面板`→`用户账户`→`凭证管理器`→将对应的凭证删除，然后再重新`git push`输入新的用户名和密码即可
## error setting certificate verify locations CAfile:false; CApath:none;
修改成正确路径  
`git config --system http.sslcainfo "C:\Program Files (x86)\git\bin\curl-ca-bundle.crt"`   
去掉对应的验证  
`git config --system http.sslverify false`
## Git Status显示对应的文件被修改，但又无法提交
1. Git客户端执行如下命令
`git rm --cached filenames`
然后重新添加索引，提交可以解决问题

1. 如果是在Eclipse当中，则在提交的时候，会对应到untaged changes，这个时候可以将其选中，拖动到taged changes一栏当中，提交push即可。


