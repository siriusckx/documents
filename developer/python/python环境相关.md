## 通过网页的形式，显示python的文档
```
## 命令行输入
python -m pydoc -p 6666
## 网页访问
http://localhost:6666
```

## 查看python存放包的路径
```
python -c "from distutils.sysconfig import get_python_lib; print (get_python_lib())"
```

## python2.7 安装pip
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

## pip install xx 报错
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