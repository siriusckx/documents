
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

## 七、ansible 注意事项
1. command 模块不支持 shell 变量,也不支持管道等 shell 相关的东西.如果你想使用 shell相关的这些东西, 请使用’shell’ 模块.两个模块之前的差别请参考 模块相关 .
2. 需要特别注意引号的使用规则
```
 ansible raleigh -m shell -a 'echo $TERM'
```
> 比如在上面的例子中,如果使用双引号”echo $TERM”,会求出TERM变量在当前系统的值,而我们实际希望的是把这个命令传递 到其它机器执行.
3. 可以在`/etc/ansible/ansible.cfg`修改`remote_port = 22`不用再每个主机后面都再指定端口
4. YAML陷阱
   >YAML语法要求如果值以{{ foo }}开头的话我们需要将整行用双引号包起来.这是为了确认你不是想声明一个YAML字典.该知识点在 YAML 语法 页面有所讲述.
5. 注意一下基本task的定义
   > 一种基本的 task 的定义,service moudle 使用 key=value 格式的参数,这也是大多数 module 使用的参数格式:
   ```
   tasks:
     - name: make sure apache is running
       service: name=httpd state=running
   ```
   >比较特别的两个 modudle 是 command 和 shell ,它们不使用 key=value 格式的参数,而是这样:
   ```
   tasks:
     - name: disable selinux
       command: /sbin/setenforce 0
   ```
   >使用 command module 和 shell module 时,我们需要关心返回码信息,如果有一条命令,它的成功执行的返回码不是0, 你或许希望这样做:
   ```
   tasks:
     - name: run this command and ignore the result
       shell: /usr/bin/somecommand || /bin/true
   ```
   或者是这样:
   ```
   tasks:
     - name: run this command and ignore the result
       shell: /usr/bin/somecommand
       ignore_errors: True
   ```
6. 使用 facts 的变量
   >我们可以称之为二级变量或者子键，分别对应着不同的值，这些子键的调用需要上级主键的配合使用才能完成变量调用，其格式为{{ main_var[ "sub_var" ] }}。 

