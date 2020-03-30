## nc命令介绍
> NetCat，在网络工具中有“瑞士军刀”美誉，其有Windows和Linux的版本。因为它短小精悍（1.84版本也不过25k，旧版本或缩减版甚至更小）、功能实用，被设计为一个简单、可靠的网络工具，可通过TCP或UDP协议传输读写数据。同时，它还是一个网络应用Debug分析器，因为它可以根据需要创建各种不同类型的网络连接。

## nc命令的常见使用
1. 远程拷贝文件
   >server2上先监听对应的端口
   ```
   nc -l 1234 > text.txt
   ```
   >server1上往server2端口写入数据
   ```
   nc 192.168.10.11 1234 < text.txt
   ```
2. 克隆硬盘或分区
3. 端口扫描
   ```
   nc -v -w 2 192.168.10.11 -z 21-24
   ```
4. 保存web页面
   ```
   while true; do nc -l -p 80 -q 1 < somepage.html; done
   ```
5. 模拟HTTP Headers
6. 聊天
   >server2上启动
   ```
   nc -lp 1234
   ```
   >server1上传输
   ```
   nc 192.168.10.11 1234
   ```
   >使用Ctrl+D正常退出
7. 传输目录
   > server2上先运行nc监听端口
   ```
   nc -l 1234 |tar xzvf -
   ```
   > server1上运行
   ```
   tar czvf - nginx-0.6.34|nc 192.168.10.11 1234
   ```
8. 操作memchached
9. 打开一个shell
10. 反向shell
11. 指定源端口
    >假设你的防火墙过滤除25端口外其它所有端口，你需要使用-p选项指定源端口
    ```
    服务器端

    $nc -l 1567

    客户端

    $nc 172.31.100.7 1567 -p 25
    ```
    >使用1024以内的端口需要root权限,该命令将在客户端开启25端口用于通讯，否则将使用随机端口
12. 指定源地址
    >假设你的机器有多个地址，希望明确指定使用哪个地址用于外部数据通讯。我们可以在netcat中使用-s选项指定ip地址。
    1. server端
    ```
    nc -u -l 1567 < file.txt
    ```
    1. client端
    ```
    nc -u 172.31.100.7 1567 -s 172.31.100.5 > file.txt
    ```

## 参考地址
https://blog.csdn.net/u010003835/article/details/52218362 
https://www.cnblogs.com/lpfuture/p/5719066.html 


