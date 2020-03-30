### 下载文件
1. 安装的是sun的[JDK 1.8](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html);
1. 下载后的文件存在路径为`~/Downloads/jdk-8u152-linux-x64.tar.gz`;
1. 通常情况下，我这边对软件的安装方式是将软件安装到`/opt/app`目录中；
1. 复制下载的软件到app目录下：`sudo cp ~/Downloads/jdk-8u152-linux-x64.tar.gz /opt/app`

### 解压文件
1. 进入到目录`cd /opt/app`;
1. 将压缩文件进行解压

```
将压缩文件解压到当前目录
tar zxvf jdk-8u152-linux-x64.tar.gz

将压缩文件解压到指定的目录（需要提前创建好目录）
tar zxvf jdk-8u152-linux-x64.tar.gz -C jdk1.8

```

### 配置环境变量
> 在配置环境变量前，首先了解ubuntu对环境变量的加载顺序也是很有必要的。

 * /etc/environment
 * /etc/profile
     * /etc/profile.d下的所有.sh文件
 * ~/.profile(或～/.bash_profile 或 ./bash_login)
     * ~/.bashrc(如果在运行bash才行)
         * ~/.bash_aliases
         * ~/etc/bash_completion

> /etc/environment与 /etc/profile 为系统级别的环境变量，以～开头的为当前用户的局部环境变量。/etc/environment在系统一些核心组件加截完成后最先调用，很多外围程序都依赖它运行，如果这里面出现了什么问题，那么很可能导致系统无法正常启动。相当于是系统级别的公共变量。
> /etc/profile在启动登录环境时被首先执行，相当于应用级别的公共环境变量。
> ~/.profile在shell被打开时，次于/etc/profile级别，相当于是应用级的用户环境变量。
> 注意：~/.profile是打开shell时执行的，也就是说它或者它会调用的脚本（一般是.bashrc）里面配置的环境变量，在图形界面下是无效的。如果想要配置在图形界面下依然有效的环境，可以放在/etc/profile.d下建立一个.sh文件，写入相应的内容，例如JAVA_HOME。

>在了解上述环境变量加载顺序之后，采用在/etc/profile.d下建立developer.sh用于配置相应的环境变量，内容如下：

```
/etc/profile.d/developer.sh

# JDK environment
export JAVA_HOME=/opt/app/jdk1.8.0_152
export PATH=$PATH:$JAVA_HOME/bin

```
>最后在配置完以后，最后重新启动一下系统或者source一下。

### 修改系统默认选择
   >在安装操作系统的时候，ubuntu已经自带了OPEN JDK并且为默认的JDK环境变量，在实际开发中，我们一般使用的是SUN的JRE作为环境。在这里需要将默认的JDK环境变量改成sun的。linux提供了`update-alternatives`命令，该命令是linux专门用来配置命令链接。使用`update-alternatives`命令配置java命令对应环境变量步骤如下：

   1. 首先运行如下命令查看java当前的默认配置

    ```linux
    chengkx@chengkx:documents$ update-alternatives --display java 
       java - 手动模式
       最佳链接版本为 /opt/app/jdk1.8.0_152/bin/java
       链接目前指向 /opt/app/jdk1.8.0_152/bin/java
       链接 java 指向 /usr/bin/java
       从链接 java.1.gz 指向 /usr/share/man/man1/java.1.gz
       /opt/app/jdk1.8.0_152/bin/java - 优先级 1081
       /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java - 优先级 1081
       次要 java.1.gz：/usr/lib/jvm/java-8-openjdk-amd64/jre/man/man1/java.1.gz
       chengkx@chengkx:documents$ 
    ```
   1. 把自己安装的JDK加入到备选方案当中
   ```linux
       运行命令（注意命令最后的数字表示优先级，其中1081为SunJDK的alternative的优先级）
       update-alternatives  --install /usr/bin/java java /opt/app/jdk1.8.0_152/bin/java 1080 
   ```
   1. 选择自己安装的SunJDK作为首选java命令
   ```linux
   chengkx@chengkx:documents$ update-alternatives --config java
   有 2 个候选项可用于替换 java (提供 /usr/bin/java)。

     选择       路径                                          优先级  状态
     ------------------------------------------------------------
       0            /opt/app/jdk1.8.0_152/bin/java                   1081      自动模式
       1            /opt/app/jdk1.8.0_152/bin/java                   1081      手动模式
       2            /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java   1081      手动模式
       要维持当前值[*]请按<回车键>，或者键入选择的编号：
   ```
   >说明：在配置步骤1中，我们指定SunJDK的优先级是1080（比当前优先级1081低），所以需要进行步骤二进行手动选择；如果我们指定的优先级比当前优先级1081高，则步骤二可以省略，系统自动会选择优先级高的作为默认alternative！

参考地址如下：
http://blog.csdn.net/rj042/article/details/72034650

关于update-alternatives命令更详细的说明，请参照
1. http://www.cnblogs.com/pengdonglin137/p/3462492.html
1. http://www.mamicode.com/info-detail-1144825.html
1. http://persevere.iteye.com/blog/1479524

