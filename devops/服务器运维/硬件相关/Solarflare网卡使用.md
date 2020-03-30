## 环境和硬件信息
```
CentOS 7.2
solarflare 2522
```

## 解决问题的方式
1. 尽可能的从厂家那儿获取技术支持和帮助
   
   https://solarflare.com/quickstart/

   https://support.solarflare.com/index.php/component/cognidox/?view=categories&id=1945

   

# 遇到问题
## 编译OpenOnload
1. 缺乏`kernel-devel`
```
mmakebuildtree: No kernel build at '/usr/lib/modules/3.10.0-327.el7.x86_64/build'
onload_build: FAILED: mmakebuildtree --driver -d x86_64_linux-3.10.0-327.el7.x86_64
```
https://www.cnblogs.com/beixiaobei/p/9041143.html

> 可通过这里面进行下载 `3.10.0-327.el7.x86_64`

2. 编译过程中，so对应的软链接被损坏
```
/usr/bin/ld: skipping incompatible /usr/lib/gcc/x86_64-redhat-linux/4.8.5/libgcc_s.so when searching for -lgcc_s
/usr/bin/ld: cannot find -lgcc_s
/usr/bin/ld: skipping incompatible /usr/lib64/libc.so when searching for -lc
/usr/bin/ld: skipping incompatible /usr/lib64/libc.so when searching for -lc
/usr/bin/ld: cannot find -lc
/usr/bin/ld: skipping incompatible /usr/lib/gcc/x86_64-redhat-linux/4.8.5/libgcc_s.so when searching for -lgcc_s
/usr/bin/ld: cannot find -lgcc_s
collect2: error: ld returned 1 exit status
```
> 将对应的软链接，链接正确，并且要有对应32位的libgcc

https://blog.csdn.net/qq_19393857/article/details/82797315

https://blog.csdn.net/u013043762/article/details/72458265

> 参考命令：
```
测试库是否正确加载，gcc -libgcc_s --verbose.
```

```
locate libgcc_s.so | egrep ^/usr | xargs file
```

# 参考网址
[Solarflare网卡开发：openonload 安装与调试](https://williamlfang.github.io/post/2019-12-11-solarflare%E7%BD%91%E5%8D%A1%E5%BC%80%E5%8F%91-openonload-%E5%AE%89%E8%A3%85%E4%B8%8E%E8%B0%83%E8%AF%95/)

[Linux 调整 cstate 实现cpu超频](https://williamlfang.github.io/post/2019-12-11-linux-%E8%B0%83%E6%95%B4-cstate-%E5%AE%9E%E7%8E%B0cpu%E8%B6%85%E9%A2%91/)

