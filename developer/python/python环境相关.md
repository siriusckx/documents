## 1 python 文档查看

### 1.1 通过网页的形式，显示python的文档

```
## 命令行输入
python -m pydoc -p 6666
## 网页访问
http://localhost:6666
```

### 1.2 查看python存放包的路径

```
python -c "from distutils.sysconfig import get_python_lib; print (get_python_lib())"
```

## 2  pip 模块管理工具的安装和使用

### 2.1 python2.7 安装pip

1. 下载 https://pypi.org/project/pip
2. 解压对应的文件，进入解压目录
   ```
   python setup.py install
   ```
3. 配置环境变量
   ```
   C:\Python27\Scripts
   ```
4. 命令行查看pip则安装成功

> 或者直接安装
```
yum install python-pip
```
> pip 安装指定源到国内镜像
```
eg:pip install scrapy -i https://pypi.tuna.tsinghua.edu.cn/simple 
```
阿里云 https://mirrors.aliyun.com/pypi/simple/
中国科技大学 https://pypi.mirrors.ustc.edu.cn/simple/
豆瓣(douban) http://pypi.douban.com/simple/
清华大学 https://pypi.tuna.tsinghua.edu.cn/simple/
中国科学技术大学 http://pypi.mirrors.ustc.edu.cn/simple/

### 2.2 pip install xx 报错

```
 InsecurePlatformWarning
  Could not fetch URL https://pypi.org/simple/pylint/: There was a problem confirming the ssl certificate: HTTPSConnectionPool(host='pypi.org', port=443): Max retries exceeded with url: /simple/pylint/ (Caused by SSLError(SSLError(1, '_ssl.c:504: error:1407742E:SSL routines:SSL23_GET_SERVER_HELLO:tlsv1 alert protocol version'),)) - skipping
  ERROR: Could not find a version that satisfies the requirement pylint (from versions: none)
ERROR: No matching distribution found for pylint
```
1. 进入用户目录，创建pip目录，创建文件pip.ini
   ```
    [global]

    index-url=http://mirrors.aliyun.com/pypi/simple/

    [install]
    trusted-host=mirrors.aliyun.com
   ```
2. 添加环境变量
   ```
   HOMEPATH=c:/user/xxxx
   path=$path;%HOMEPATH%\pip\pip.in
   ```
### 2.3 python中有中文报错

```
SyntaxError: Non-ASCII character '\xef' in file server.py on line 18, but no encoding declared
```
1. 在文件第一行添加编译设置
   1. 方法1
   ```
   #coding=utf-8
   或者
   #encoding=utf-8

   注意：等号两边不能有任何空格
   ```
   2. 方法2
   ```
   # -*- coding:utf-8 -*- 
   ```

### 2.4 python安装bson

  ```
  pip uninstall bson
  pip install pymongo
  ```



## 2.5 更新pip和setuptools

```
pip install --upgrade pip
pip install --upgrade setuptools
```



### 2.5 python 文件处理时乱码问题

python 乱码解决

https://www.cnblogs.com/CasonChan/p/4669799.html

https://cloud.tencent.com/developer/article/1137667

## 2.6 CentOS 安装 python3 与 python2 共存

https://www.cnblogs.com/holdononedream/p/10847772.html

https://blog.51cto.com/liqingbiao/2083869

## 附录：

[python下载ftp](https://www.python.org/ftp/python/)



