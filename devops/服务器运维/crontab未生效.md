# crond不执行原因分析
> 自己写了个脚本，让crond来周期性执行脚本进行备份，但是在crontab -e里面加入了执行脚本之后，发现没有执行，后来分析了一下，crond不执行的原因主要有以下几个方面：

1. crond服务没启动（suse下为cron）
   
   ```
    service crond start        //启动服务
    service crond stop         //关闭服务
    service crond restart      //重启服务
    service crond reload       //重新载入配置
   ```

2. 用户没有执行crond的权限
   
   > /etc/cron.deny文件用来控制哪些用户不能执行crond服务的功能。可以将自己从文件中删去，或者联系root

3. crontab不提供所执行用户的环境变量
   > 解决方法：在脚本中加入下面这一行：
   ```
   . /etc/profile
   ```

4. 没有使用绝对路径
   
   >这里的绝对路径包括脚本中的路径和crond命令中的路径两个方面。

5. 如果上面都没有解决问题的话可以再找找问题：
   
   1. 去邮件看看，在这个过程中用户应该会收到邮件，比如收到这样的提示：
    You have mail in /var/spool/mail/root去看看里面就有crond的内容
   2. 在脚本里面加入output用来调试可以在crontab的脚本里面添加个echo $PATH > /tmp/test.log 对比和终端下执行脚本的echo $PATH
   
本文链接：https://blog.csdn.net/doc_sgl/article/details/41653641