> sshd服务某天不能正常提供访问，通过连上服务器后查看出现如下错误
```
[CentOS]Failed to start OpenSSH server daemon
```
1. 通过 `sshd -t` 命令查看错误信息原因
   ```
   /var/empty/sshd must be owned by root and not group or world-writable
   ```
2. 通过`ls -l /var/empty` 查看目录权限
   ```
   drwxdrwxdrwx.
   ```
   >经测试这样的权限是错误的，但不知道为何这个权限会被更改成这样。
3. 重新将该目录删除，重新创建目录后，重启应用程序，sshd服务可正常启动。
   ```
   find /var/empty/sshd |xargs rm -rf;
   mkdir /var/empty/sshd
   systemctl restart sshd
   ```
4. 查看正常`/var/empty/sshd`目录权限为
   ```
    [root@localhost ~]# ll /var/empty/
    drwxr-xr-x. 2 root root 6 1月   5 11:31 sshd
   ```