## 命令补全
1. bash
2. $PATH 外部命令查找

## 路径补全
每个路径都可以切割为两部分：基名（basename + 路径），目录名（dirname + 路径）

## bash的命令历史
>相关的一些成员变量
1. HISTSIZE
2. HISTFILE
3. HISTFILESIZE
4. HISTCONTROL
   ignoredups:忽略重复的命令，连续的相同命令才会忽略
   ignorespace：忽略以空格开头的命令
   ignoreboth:以上两者都忽略

## Linux硬件时钟及时间同步机制
1. hwclock
   * -s:以硬件为准
   * -w:以系统为准
2. ntp：Network Time Protocol
   >通过网络同步系统时间
   * ntpdate

## Linux下文件系统层级结构标准FHS:FileSystem Hierarchy Standard
1. 可以直接看标准文档
   http://www.pathname.com/fhs/
2. 应用程序的组成部分
   * 二进制程序
   * 库文件
   * 配置文件
   * 帮助文件
3. selinux：Security Enhanced Linux 安全加强的linux
   
## 文件的类型
1. 普通文件 - f
2. 目录文件 d
3. 符号链接文件 l
4. 设备文件
   * 字符设备：c (线性设备)
   * 块设备： b (随机设备)
5. 命名管道 p
6. 套接字文件 s （unix sock文件）

> file 文件路径  ， 查看文件的相关的类型