## 查看windows对应CPU负载
```
wmic cpu get loadpercentage
```
## 查看windows端口占用
```
netstat -aon|findstr "80"
```