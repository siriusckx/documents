[Gitlab+Gitlab-CI+Docker实现持续集成(CI)与持续部署(CD)](https://www.cnblogs.com/liuge36/p/9882629.html)

[gitlab启用https](https://www.cnblogs.com/xieshuang/p/8488458.html)

[gitlab搭建与基本使用](https://blog.csdn.net/qq_34129814/article/details/100043914)

[docker安装](http://www.docker.org.cn/book/install/install-docker-on-rhel-29.html)
> 请不要随意相信yum update 这种鬼话，尤其是在生产上

[Git中文网-GitLab中文网](http://www.git-scm.com.cn/1511.html)

[GitLab CI/CD Docs](https://docs.gitlab.com/ee/ci/)

[GitLab CI/CD environment variables](https://docs.gitlab.com/ee/ci/variables/#predefined-variables-environment-variables)

[Predefined environment variables reference](https://docs.gitlab.com/ee/ci/variables/predefined_variables.html)

[GitLab之gitlab-ci.yml配置文件详解](https://www.cnblogs.com/szk5043/articles/9854712.html)

[GitLab CI/CD Pipeline Configuration Reference](https://docs.gitlab.com/ee/ci/yaml/README.html)

[Gitlab+Gitlab-CI+Docker实现持续集成(CI)与持续部署(CD)](https://www.cnblogs.com/liuge36/p/9882629.html)

[gitlab搭建与基本使用](https://blog.csdn.net/qq_34129814/article/details/100043914)

[docker安装](http://www.docker.org.cn/book/install/install-docker-on-rhel-29.html)
> 请不要随意相信yum update 这种鬼话，尤其是在生产上

[Git Submodule项目子模块管理](http://www.voidcn.com/article/p-ycqxwzir-bru.html)
```
添加子模块的例子
cd source/
cd libs
git submodule add http://210.14.136.68:6666/root/base.git base
```

[Git中submodule的使用](https://zhuanlan.zhihu.com/p/87053283)

> 关键是`git submodule foreach 'git pull origin master'`
> 
[Using Git submodules with GitLab CI](https://docs.gitlab.com/ee/ci/git_submodules.html)

[gitlab-runner如何更改执行用户为root](http://www.fidding.me/article/111)

[代码例子网站](https://code-examples.net/zh-CN/tags)

[gitlab-runner register 注册报错](https://blog.csdn.net/zuopiezia/article/details/88711750)

[Failed tls handshake. Does not contain any IP SANs](https://serverfault.com/questions/611120/failed-tls-handshake-does-not-contain-any-ip-sans)

[gitlab-runner 注册问题](https://blog.csdn.net/qq_34206560/article/details/88802893)

[Gitlab-CI runner: ignore self-signed certificate](https://stackoverflow.com/questions/44458410/gitlab-ci-runner-ignore-self-signed-certificate)

>First edit ssl configuration on the GitLab server (not the runner)
```
vim /etc/pki/tls/openssl.cnf

[ v3_ca ]
subjectAltName=IP:192.168.1.1 <---- Add this line. 192.168.1.1 is your GitLab server IP.
```

>Re-generate self-signed certificate
```
cd /etc/gitlab/ssl
sudo openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout /etc/gitlab/ssl/192.168.1.1.key -out /etc/gitlab/ssl/192.168.1.1.crt
sudo gitlab-ctl restart
```

>Copy the new CA to the GitLab CI runner
```
scp /etc/gitlab/ssl/192.168.1.1.crt root@192.168.1.2:/etc/gitlab/ssl/server.crt
```

> 注册runner时指定证书地址
```
gitlab-runner register --tls-ca-file=/etc/gitlab/ssl/server.crt 
```

[git push 缓存密码和用户名](https://www.cnblogs.com/oxspirt/p/11809123.html)

[git目录下object文件过大清理](https://blog.csdn.net/cysear/article/details/102823671)

```
git rev-list --objects --all | grep "$(git verify-pack -v .git/objects/pack/*.idx | sort -k 3 -n | tail -5 | awk '{print$1}')"

git filter-branch --force --index-filter 'git rm -rf --cached --ignore-unmatch 你的大文件名' --prune-empty --tag-name-filter cat -- --all

rm -rf .git/refs/original/
git reflog expire --expire=now --all
git gc --prune=now
git gc --aggressive --prune=now
git push origin master --force

git remote prune origin
```

1. 可以先提取出过大的是哪些文件（可能会导致过大的文件误删）
   
```
git rev-list --objects --all | grep "$(git verify-pack -v .git/objects/pack/*.idx | sort -k 3 -n | tail -$1 | awk '{print $1}')" > bigobjs.table.log
```
2. 针对过大的文件进行瘦身
```
filelist=`git rev-list --objects --all | grep "$(git verify-pack -v .git/objects/pack/*.idx | sort -k 3 -n | tail -$1 | awk '{print $1}')"`
j=0
for i in $filelist
do
if [ $((j%2)) -eq 1 ];
then
   git filter-branch --force --index-filter "git rm -rf --cached --ignore-unmatch $i" --prune-empty --tag-name-filter cat -- --all
fi
((j++))
done

rm -rf .git/refs/original/
git reflog expire --expire=now --all

echo "git gc--------"
git gc --prune=now
git gc --aggressive --prune=now
```

[如何使用GitLab进行敏捷软件开发](http://blog.sina.com.cn/s/blog_185a4b04b0102xerp.html)

[版本号命名规则](https://www.jianshu.com/p/8a1e0a827bae)