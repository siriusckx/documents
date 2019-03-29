## 一、 设置SVN不保存密码
> 要设置 /home/***/.subversion/config 下的 store-passwords = no  
> 设置 /home/***/.subversion/servers 下的两个变量 store-plaintext-passwords = no

## 二、 编码错误
> svn: Can't convert string from 'UTF-8' to native encoding:\nsvn: t

http://www.cnblogs.com/zhaobolu/archive/2014/04/02/3641309.html

## 三、 ssh-copy-id 复制公钥错误
https://blog.csdn.net/xwbk12/article/details/78884729

## 四、 将编译的脚本进行统一
1. 编译执行命令的统一
2. 输出模块名字的统一，以模块名为准

## 五、 ansible-playbook传递变量
> 使用-e传递参数，一个-e，只传递一个参数
1. 传递 key-value的变量
   ```
    ansible-playbook /root/playbook/nginx-116.yaml -e "key=value"
   ```
2. 传递 文件作为变量
   ```
   ansible-playbook /root/playbook/nginx-116.yaml -e "@var.json"
   ansible-playbook /root/playbook/nginx-116.yaml -e "@var.yaml"
   ```
3. 文件内通过vars关键字定义变量
   ```
   XXX.yml----------------文件里面
      vars:
        key: Ansible
   ```
4. 在playbook文件内使用vars_files引用文件内容作为变量
   ```
   vars_files:
        - var.yaml
   ```
5. 通过register使用另一个task的变量
   ```
    tasks: 
    - name: register variable 
      shell: hostname 
      register: info
   ```
   ## 六、统一ansible的目录
   ```
   mkdir -pv ./{role1,role2}/{files,templates,vars,tasks,handlers,meta,default}
   ```