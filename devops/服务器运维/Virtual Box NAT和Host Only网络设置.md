## 使用VirtualBox实现上网、宿主机与虚拟机互通
参考网址：

https://blog.csdn.net/GD_Hacker/article/details/80961159  
https://blog.csdn.net/techsupporter/article/details/51810649  



注意：
1. 如果虚拟机里面对应DHCP获得的IP地址和virtual box设置的nat全局网络不是一个网段，需要手动进行修改。
1. 注意如果需要上网，则需要将主机的网络设置成共享网络。
1. 将虚拟机的网关设置成对应主机Adapter的地址。
   
https://blog.csdn.net/bzhxuexi/article/details/32714971
注意：使用以上连接的NAT和桥接模式后，需要将宿主机本地的VirtualBox Host-Only Ethernet Adapter 禁用才可以