## 取消对资源的限制
```
ulimit -n 100000
```

## 修改生成core文件的文件名格式
```
echo "core-%e-%p-%t" > /proc/sys/kernel/core_pattern
```

## 生成core文件
> 取消对生成core文件大小的限制
```
ulimit -c unlimited
```

## 验证core文件是否生成
>通过向进程发送一个内存错误信号，进程捕获到以后会生成core文件，core文件默认在进程当前运行目录下生成
```
kill -s SIGSEGV 进程号
```

## CentOS 7 下 core 文件生成的限制

```
# enable coredump whith unlimited file-size for all users
echo -e "\n# enable coredump whith unlimited file-size for all users\n* soft core unlimited" >> /etc/security/limits.conf

# format the name of core file.   
# %% – 符号%
# %p – 进程号
# %u – 进程用户id
# %g – 进程用户组id
# %s – 生成core文件时收到的信号
# %t – 生成core文件的时间戳(seconds since 0:00h, 1 Jan 1970)
# %h – 主机名
# %e – 程序文件名
echo -e "./core-%e-%s-%u-%g-%p-%t" > /proc/sys/kernel/core_pattern

echo -e "\nkernel.core_pattern=./core-%e-%s-%u-%g-%p-%t" >> /etc/sysctl.conf


# suffix of the core file name
echo -e "1" > /proc/sys/kernel/core_uses_pid

sysctl -p /etc/sysctl.conf
```