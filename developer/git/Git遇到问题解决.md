# Git配置常见操作和问题总结
## 一、Windows使用Git慢的问题，在bash中添加
* `git config --global core.preloadindex true`
* git config --global core.fscache true``
## 二、记住登录用户和密码
* `git config --global credential.helper store`
## 三、禁止自动转换windows和linux的回车换行
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

参考地址：[Git中的AutoCRLF与SafeCRLF换行符问题](http://www.cnblogs.com/flying_bat/p/3324769.html)

## 四、remote: Permission to ***/***.git denied to *** 问题解决（Windows）
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

## 五、Git恢复被修改的文件
>1.恢复到最后一次提交的改动  
`git checkout -- + 需要恢复的文件名`  

>2.但是，需要注意的是，如果该文件已经 add 到暂存队列中，上面的命令就不灵光喽
需要先让这个文件取消暂存，然后再使用第一条指令取消文件
`git reset HEAD -- + 需要取消暂存的文件名`  

>3.【额外】如果感觉命令多了记不住，那就做一两个匿名呗，比如:  
` git config --global alias.unstage 'reset HEAD --'`  
`git config --global alias.restore 'checkout --'`  
我们拿 README.md 这个文件举例，比如修改了一段文字描述，想恢复回原来的样子：  
` git restore README.md`  
即可，如果修改已经被 git add README.md 放入暂存队列，那就要  
`git unstage README.md`  
`git restore README.md`  

## 六、git add -A . * 的区别
>1. `git add -A` 代表将整颗git目录树变化的部分添加到索引文件中;  
>2. `git add .` 表示添加当前目录下和子目录下所有的文件，包括当前目录下以.开头的文件;
>3. `git add *` 其实并不是git的命令，它只是被shell解释为通配符，表示添加当前目录下和子目录西所有的文件，除了当前目录下以.开头的文件，如.gitignore就不会添加。但是子目录下以.开头的文件会添加。
>4. `git commit -am "注释内容"` 可以省去`git add -A`这一步骤。

## 七、如何更新已fork的项目
1. clone 自己的fork分支到本地
1. 增加源分支地址到你项目远程分支列表中(此处是关键)，先得将原来的仓库指定为upstream，命令为：
   *  git remote add upstream https://github.com/被fork的仓库.git
   *  此处使用git remote -v 查看远程分支列表
1. fetch源分支的新版本到本地
   * git fetch upstream
1. 合并两个版本的代码
   * git merge upstream/master
1. 将合并后的代码push到github上去
   * git push origin master