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