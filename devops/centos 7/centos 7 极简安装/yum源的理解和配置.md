> 以下内容引自 https://blog.csdn.net/oschina_41140683/article/details/81255545


# Centos 7 常用yum源配置
## 一、环境
> CentOS 7.2 64Bit

## 二、概要
### 2.1 什么是yum，什么是yum源，常见的yum源有哪些？
> yum是centos下更新、管理软件的命令，也有相应的图像界面版本。

> yum源是yum命令去哪里取安装包的地图；

> 常见的yum源：网易、阿里云、epel等。

### 2.2 yum、rpm、repo什么关系？
> yum命令查询repo上配置的地址云取相应的rpm包进行安装；

## 三、方法步骤
### 3.1 配置下 centos 的DNS
> 国内、国外

```
vi /etc/resolv.conf
nameserver 114.114.114.114
nameserver 8.8.8.8
```

### 3.2 备份下原来的 yum 源

```
cd /etc/yum.repos.d
mv CentOS-Base.repo CentOS-Base.repo_bak
```

### 3.3 网易yum源
```
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.163.com/.help/CentOS7-Base-163.repo

yum clean all

yum makecache
```

### 3.4 阿里云yum源

```
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo

yum clean all

yum makecache
```

### 3.5 epel源

```
yum -y install epel-release

yum clean all

yum makecache
```