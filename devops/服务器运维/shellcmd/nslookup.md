# nslookup命令的使用
> 检测DNS服务是否能正常解析
```
nslookup -q=ns www.baidu.com
```
> -q= dns的记录类型  
> **A记录**：A（Address）记录是用来指定主机名（或域名）对应的IP地址记录。  
> **NS记录**：  NS（Name Server）记录是域名服务器记录，用来指定该域名由哪个DNS服务器来进行解析。  
> **MX（Mail Exchanger）**：记录是邮件交换记录，它指向一个邮件服务器，用于电子邮件系统发邮件时根据收信人的地址后缀来定位邮件服务器。  
>  **CNAME（Canonical Name ）**：别名记录，允许您将多个名字映射到同一台计算机。  
>  **TXT记录**：一般指某个主机名或域名的说明。  
