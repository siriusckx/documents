## 取消对资源的限制
```
ulimit -n 100000
```

## 生成core文件
> 取消对生成core文件大小的限制
```
ulimit -c unlimited
```

## 验证core文件是否生成
>通过向进程发送一个内存错误信号，进程捕获到以后会生成core文件，core文件默认在进程当前运行目录下生成
```
kill -s SIGSEGV 进行号
```