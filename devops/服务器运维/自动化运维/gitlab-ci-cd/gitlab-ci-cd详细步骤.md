# 1 gitlab 安装和配置
## 1.1 安装和配置必要的依赖
```
yum install -y curl policycoreutils-python openssh-server
yum install postfix
systemctl enable postfix
systemctl start postfix
```
## 1.2 添加 gitlab 包仓库地址并安装包
```
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.rpm.sh | sudo bash
yum install -y gitlab-ee
```

## 1.3 启用 https 
1. 修改配置文件
```
 [xieshuang@VM_177_101_centos gitlab]$ sudo vim /etc/gitlab/gitlab.rb
 
 #13行的 http >> https
 external_url 'https://ip:port'
 
 #修改nginx配置 810行
 nginx['redirect_http_to_https'] =true
 nginx['ssl_certificate'] = "/etc/gitlab/ssl/server.crt"
 nginx['ssl_certificate_key'] = "/etc/gitlab/ssl/server.key"
```

2. 生成秘钥与证书
```
 #秘钥脚本，将以下内容保存为shell脚本，然后运行
 #出现提示输入信息的地方输入信息，先输入域名然后4次证书密码，任意密码，四次保持一致。

 #!/bin/sh

 # create self-signed server certificate:
 
 read -p "Enter your domain [139.199.125.93]: " DOMAIN
 
 echo "Create server key..."
 
 openssl genrsa -des3 -out $DOMAIN.key 1024
 
 echo "Create server certificate signing request..."
 
 SUBJECT="/C=US/ST=Mars/L=iTranswarp/O=iTranswarp/OU=iTranswarp/CN=$DOMAIN"
 
 openssl req -new -subj $SUBJECT -key $DOMAIN.key -out $DOMAIN.csr
 
 echo "Remove password..."
 
 mv $DOMAIN.key $DOMAIN.origin.key
 openssl rsa -in $DOMAIN.origin.key -out $DOMAIN.key
 
 echo "Sign SSL certificate..."
 
 openssl x509 -req -days 3650 -in $DOMAIN.csr -signkey $DOMAIN.key -out $DOMAIN.crt
 
 echo "TODO:"
 echo "Copy $DOMAIN.crt to /etc/nginx/ssl/$DOMAIN.crt"
 echo "Copy $DOMAIN.key to /etc/nginx/ssl/$DOMAIN.key"
 echo "Add configuration in nginx:"
 echo "server {"
 echo "    ..."
 echo "    listen 443 ssl;"
 echo "    ssl_certificate     /etc/nginx/ssl/$DOMAIN.crt;"
 echo "    ssl_certificate_key /etc/nginx/ssl/$DOMAIN.key;"
 echo "}"
```

```
 #执行成功后生成文件如下：
 [xieshuang@VM_177_101_centos src]$ ls
 139.199.125.93.crt  139.199.125.93.origin.key             nginx-1.7.12   vim-7.3.tar.bz2
 139.199.125.93.csr  apache-tomcat-8.5.28.tar.gz           ssl_genKey.sh  vimcdoc-1.8.0
 139.199.125.93.key  gitlab-ce-10.0.0-ce.0.el7.x86_64.rpm  vim73          vimcdoc-1.8.0.tar.gz
```

```
 #移动到相应的位置
 sudo mkdir -p /etc/gitlab/ssl
 sudo chmod 700 /etc/gitlab/ssl/ -R
 sudo cp 139.199.125.93.crt /etc/gitlab/ssl/server.crt
 sudo cp 139.199.125.93.key /etc/gitlab/ssl/server.key
```

3. 重建gitlab配置
```
 sudo gitlab-ctl reconfigure
```

# 2 gitlab-runner 安装和配置
## 2.1 gitlab-runner 安装
1. 下载配置 yum repository 信息
```
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-ci-multi-runner/script.rpm.sh | sudo bash
```
2. 安装 gitlab-ci-multi-runner
```
yum install -y gitlab-ci-multi-runner
```

## 2.2 gitlab-runner 配置
1. **更改执行用户为root**
> gitlab-ci 的runner 默认使用 gitlab-runner 用户执行操作；
```
gitlab-runner uninstall

gitlab-runner install --working-directory /home/gitlab-runner --user root

systemctl restart gitlab-runner
```
> 再次执行ps aux|grep gitlab-runner会发现--user的用户名已经更换成root了

2. **注册 runner**
```
gitlab-runner register --tls-ca-file=/etc/gitlab/ssl/server.crt 
```
> --tls-ca-file 指向的server.crt 来源于 `gitlab` 服务器端生成的证书。

> 接下来按照提示将```GitLab->project->settings->CI/CD->runners```下的信息一一对应填上。

3. **gitlab 客户端需要配置一个永久的用户名和密码**

> 在做CI/CD的过程中，需要从服务器拉取代码，客户端可能因为没有缓存token或者token过期后，认证不通过，会一直卡住，直到超时。期间如果重置了`gitlab unset credential.helper `还会出现如下错误。
```
gitlab-runner fatal: could not read Username
```
> 解决办法如下：
```
1. 进入~（用户）目录，cd ~
2. 建立文件  .git-credentials， touch  .git-credentials
3. 编辑文件  .git-credentials， vi  .git-credentials
4. 添加http://用户名:密码@gitlab.com
5. 执行命令：git config --global credential.helper store
6. 查看文件：more .gitconfig，可以看到如下信息，设置成功。
```
> 关键是 `git config --global credential.helper store`

[Git Documentation](https://git-scm.com/docs/git-credential-store)   

[解决gitlab需要输入用户名密码的问题](https://www.jianshu.com/p/7f94238d24d4)

# 3 gitlab 配置优化
# 4 CI/CD 的使用
> 结合 gitlab-runner、ansible 以及 ansible 代理，实现项目的自动化集成和自动化部署。
