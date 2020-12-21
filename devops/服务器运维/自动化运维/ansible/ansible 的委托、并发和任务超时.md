## [Ansible 的委托 并发和任务超时](https://www.cnblogs.com/v394435982/p/5180933.html)

## 异步和轮询

Ansible 有时候要执行等待时间很长的操作, 这个操作可能要持续很长时间, 设置超过ssh的timeout. 这时候你可以在step中指定async 和 poll 来实现异步操作

async 表示这个step的最长等待时长, 如果设置为0, 表示一直等待下去直到动作完成.

poll 表示检查step操作结果的间隔时长.

例1:

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
---
- name: Test
  hosts: localhost
  tasks:
    - name: wair for
      shell: sleep 16
      async: 10
      poll: 2

结果:
TASK: [wair for] ************************************************************** 
ok: [localhost]
<job 207388424975.101038> polling, 8s remaining
ok: [localhost]
<job 207388424975.101038> polling, 6s remaining
ok: [localhost]
<job 207388424975.101038> polling, 4s remaining
ok: [localhost]
<job 207388424975.101038> polling, 2s remaining
ok: [localhost]
<job 207388424975.101038> polling, 0s remaining
<job 207388424975.101038> FAILED on localhost这个step失败, 因为操作时间超过了最大等待时长
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

例2:

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
---
- name: Test
  hosts: localhost
  tasks:
    - name: wair for
      shell: sleep 16
      async: 10
      poll: 0

结果:
TASK: [wair for] ************************************************************** 
<job 621720484791.102116> finished on localhost

PLAY RECAP ********************************************************************

poll 设置为0, 表示不用等待执行结果, 该step执行成功
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

例3:

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
---
- name: Test
  hosts: localhost
  tasks:
    - name: wair for
      shell: sleep 16
      async: 0
      poll: 10

结果:
# time ansible-playbook xiama.yml 
TASK: [wair for] ************************************************************** 
changed: [localhost]

PLAY RECAP ******************************************************************** 
localhost                  : ok=2    changed=1    unreachable=0    failed=0   


real    0m16.693s

async设置为0, 会一直等待直到该操作完成.
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

## Play执行时的并发限制 

一般情况下, ansible会同时在所有服务器上执行用户定义的操作, 但是用户可以通过serial参数来定义同时可以在多少太机器上执行操作.

```
- name: test play
  hosts: webservers
  serial: 3

webservers组中的3台机器完全完成play后, 其他3台机器才会开始执行,
```

**serial参数在ansible-1.8以后就开始支持百分比.**

## **最大失败百分比**

默认情况下, 只要group中还有server没有失败, ansible就是继续执行tasks. 实际上, 用户可以通过"max_fail_percentage" 来定义, 只要超过max_fail_percentage台的server失败, ansible 就可以中止tasks的执行.

```
- hosts: webservers
  max_fail_percentage: 30  serial: 10
Note: 实际失败机器必须大于这个百分比时, tasks才会被中止. 等于时是不会中止tasks的.
```

## 委托

通过"delegate_to", 用户可以把某一个任务放在委托的机器上执行. 

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
- hosts: webservers
  serial: 5

  tasks:

  - name: take out of load balancer pool
    command: /usr/bin/take_out_of_pool {{ inventory_hostname }}
    delegate_to: 127.0.0.1
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

上面的task会在跑ansible的机器上执行, "delegate_to: 127.0.0.1" 可以用local_action来代替

```
  tasks:

  - name: take out of load balancer pool
    local_action: command /usr/bin/take_out_of_pool {{ inventory_hostname }}
```

## 委托者的facts

默认情况下, 委托任务的facts是inventory_hostname中主机的facts, 而不是被委托机器的facts. 在ansible 2.0 中, 设置delegate_facts为true可以让任务去收集被委托机器的facts.

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
- hosts: app_servers
  tasks:
    - name: gather facts from db servers
      setup:
      delegate_to: "{{item}}"
      delegate_facts: True
      with_items: "{{groups['dbservers'}}"该例子会收集dbservers的facts并分配给这些机器, 而不会去收集app_servers的facts
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

**RUN ONCE**

通过run_once: true来指定该task只能在某一台机器上执行一次. 可以和delegate_to 结合使用

```
- command: /opt/application/upgrade_db.py
  run_once: true
  delegate_to: web01.example.org指定在"web01.example.org"上执行这
```

**如果没有delegate_to, 那么这个task会在第一台机器上执行**