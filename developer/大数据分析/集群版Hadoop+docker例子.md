## 1 docker 下 hadoop 安装

> [基于 docker 构建构建 hadoop 平台 ](https://zhuanlan.zhihu.com/p/59758201)
>
> [**Docker 创建镜像、修改、上传镜像**](https://www.cnblogs.com/lsgxeva/p/8746644.html)
>
> [DockerFile 设置环境变量](https://www.jianshu.com/p/ae634ffb21ff)

| 需要软件 | 链接                                           |
| -------- | ---------------------------------------------- |
| scala    | https://www.cnblogs.com/shaosks/p/9242181.html |

> **NOTE**:docker 使用中遇到的问题

* [Centos7 Docker容器中报错 Failed to get D-Bus connection: Operation not permitted](https://blog.csdn.net/weixin_42123737/article/details/87984996)

### 1.1 软件配置清单

#### 1.1.1 制作镜像各文件结构

```sh
[root@localhost pack]# tree
.
├── CentOS-Base.repo
├── Dockerfile
├── hadoop-3.2.1.tar.gz
├── hadoop.etc
│   ├── core-site.xml
│   ├── hadoop-env.sh
│   ├── hdfs-site.xml
│   ├── mapred-site.xml
│   ├── workers
│   └── yarn-site.xml
├── hbase-2.2.5-bin.tar.gz
├── hbase.conf
│   ├── hbase-env.sh
│   ├── hbase-site.xml
│   └── regionservers
├── jdk-8u231-linux-x64.tar.gz
├── scala-2.11.8.tgz
├── spark-3.0.0-preview2-bin-hadoop3.2.tgz
└── spark.conf
    ├── slaves
    └── spark-env.sh
```

#### 1.1.2 hadoop 配置文件

> **NOTE**: 考虑到使用 `docker` 配置 `hadoop` 集群，容器中数据存储的数据卷，需要与主机的目录相关联，以下涉及到存储目录的，统一使用前缀`/home/docker-data`, 另外一些日志文件的目录也需要进行相应的配置。

1. `core-site.xml` 

```xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<!--
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License. See accompanying LICENSE file.
-->

<!-- Put site-specific property overrides in this file. -->

<configuration>
    <property>
        <name>fs.default.name</name>
        <value>hdfs://h01:9000</value>
    </property>
    <property>
        <name>hadoop.tmp.dir</name>
        <value>/home/docker-data/hadoop3/hadoop/tmp</value>
    </property>
  </configuration>
```

2.  `hdfs-site.xml`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<!--
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License. See accompanying LICENSE file.
-->

<!-- Put site-specific property overrides in this file. -->

<configuration>

<property>
      <name>dfs.replication</name>
      <value>2</value>
      </property>
      <property>
          <name>dfs.namenode.name.dir</name>
          <value>/home/docker-data/hadoop3/hadoop/hdfs/name</value>
      </property>
      <property>
          <name>dfs.namenode.data.dir</name>
          <value>/home/docker-data/hadoop3/hadoop/hdfs/data</value>
      </property>
</configuration>
```

3.  `mapred-site.xml`

```xml
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<!--
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License. See accompanying LICENSE file.
-->

<!-- Put site-specific property overrides in this file. -->

<configuration>
    <property>
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
    </property>
    <property>
        <name>mapreduce.application.classpath</name>
        <value>
            /usr/local/hadoop/etc/hadoop,
            /usr/local/hadoop/share/hadoop/common/*,
            /usr/local/hadoop/share/hadoop/common/lib/*,
            /usr/local/hadoop/share/hadoop/hdfs/*,
            /usr/local/hadoop/share/hadoop/hdfs/lib/*,
            /usr/local/hadoop/share/hadoop/mapreduce/*,
            /usr/local/hadoop/share/hadoop/mapreduce/lib/*,
            /usr/local/hadoop/share/hadoop/yarn/*,
            /usr/local/hadoop/share/hadoop/yarn/lib/*
       </value>
   </property>
</configuration>
```

4. `yarn-site.xml`

```xml
<?xml version="1.0"?>
<!--
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License. See accompanying LICENSE file.
-->
<configuration>
 <property>
     <name>yarn.resourcemanager.hostname</name>
     <value>h01</value>
 </property>
 <property>
     <name>yarn.nodemanager.aux-services</name>
     <value>mapreduce_shuffle</value>
 </property>
</configuration>
```

5. `hadoop-env.sh`

```shell
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Set Hadoop-specific environment variables here.

##
## THIS FILE ACTS AS THE MASTER FILE FOR ALL HADOOP PROJECTS.
## SETTINGS HERE WILL BE READ BY ALL HADOOP COMMANDS.  THEREFORE,
## ONE CAN USE THIS FILE TO SET YARN, HDFS, AND MAPREDUCE
## CONFIGURATION OPTIONS INSTEAD OF xxx-env.sh.
##
## Precedence rules:
##
## {yarn-env.sh|hdfs-env.sh} > hadoop-env.sh > hard-coded defaults
##
## {YARN_xyz|HDFS_xyz} > HADOOP_xyz > hard-coded defaults
##

# Many of the options here are built from the perspective that users
# may want to provide OVERWRITING values on the command line.
# For example:
#
#  JAVA_HOME=/usr/java/testing hdfs dfs -ls
#
# Therefore, the vast majority (BUT NOT ALL!) of these defaults
# are configured for substitution and not append.  If append
# is preferable, modify this file accordingly.

###
# Generic settings for HADOOP
###

# Technically, the only required environment variable is JAVA_HOME.
# All others are optional.  However, the defaults are probably not
# preferred.  Many sites configure these options outside of Hadoop,
# such as in /etc/profile.d

# The java implementation to use. By default, this environment
# variable is REQUIRED on ALL platforms except OS X!
# export JAVA_HOME=

# Location of Hadoop.  By default, Hadoop will attempt to determine
# this location based upon its execution path.
# export HADOOP_HOME=

# Location of Hadoop's configuration information.  i.e., where this
# file is living. If this is not defined, Hadoop will attempt to
# locate it based upon its execution path.
#
# NOTE: It is recommend that this variable not be set here but in
# /etc/profile.d or equivalent.  Some options (such as
# --config) may react strangely otherwise.
#
# export HADOOP_CONF_DIR=${HADOOP_HOME}/etc/hadoop

# The maximum amount of heap to use (Java -Xmx).  If no unit
# is provided, it will be converted to MB.  Daemons will
# prefer any Xmx setting in their respective _OPT variable.
# There is no default; the JVM will autoscale based upon machine
# memory size.
# export HADOOP_HEAPSIZE_MAX=

# The minimum amount of heap to use (Java -Xms).  If no unit
# is provided, it will be converted to MB.  Daemons will
# prefer any Xms setting in their respective _OPT variable.
# There is no default; the JVM will autoscale based upon machine
# memory size.
# export HADOOP_HEAPSIZE_MIN=

# Enable extra debugging of Hadoop's JAAS binding, used to set up
# Kerberos security.
# export HADOOP_JAAS_DEBUG=true

# Extra Java runtime options for all Hadoop commands. We don't support
# IPv6 yet/still, so by default the preference is set to IPv4.
# export HADOOP_OPTS="-Djava.net.preferIPv4Stack=true"
# For Kerberos debugging, an extended option set logs more information
# export HADOOP_OPTS="-Djava.net.preferIPv4Stack=true -Dsun.security.krb5.debug=true -Dsun.security.spnego.debug"

# Some parts of the shell code may do special things dependent upon
# the operating system.  We have to set this here. See the next
# section as to why....
export HADOOP_OS_TYPE=${HADOOP_OS_TYPE:-$(uname -s)}

# Extra Java runtime options for some Hadoop commands
# and clients (i.e., hdfs dfs -blah).  These get appended to HADOOP_OPTS for
# such commands.  In most cases, # this should be left empty and
# let users supply it on the command line.
# export HADOOP_CLIENT_OPTS=""

#
# A note about classpaths.
#
# By default, Apache Hadoop overrides Java's CLASSPATH
# environment variable.  It is configured such
# that it starts out blank with new entries added after passing
# a series of checks (file/dir exists, not already listed aka
# de-deduplication).  During de-deduplication, wildcards and/or
# directories are *NOT* expanded to keep it simple. Therefore,
# if the computed classpath has two specific mentions of
# awesome-methods-1.0.jar, only the first one added will be seen.
# If two directories are in the classpath that both contain
# awesome-methods-1.0.jar, then Java will pick up both versions.

# An additional, custom CLASSPATH. Site-wide configs should be
# handled via the shellprofile functionality, utilizing the
# hadoop_add_classpath function for greater control and much
# harder for apps/end-users to accidentally override.
# Similarly, end users should utilize ${HOME}/.hadooprc .
# This variable should ideally only be used as a short-cut,
# interactive way for temporary additions on the command line.
# export HADOOP_CLASSPATH="/some/cool/path/on/your/machine"

# Should HADOOP_CLASSPATH be first in the official CLASSPATH?
# export HADOOP_USER_CLASSPATH_FIRST="yes"

# If HADOOP_USE_CLIENT_CLASSLOADER is set, the classpath along
# with the main jar are handled by a separate isolated
# client classloader when 'hadoop jar', 'yarn jar', or 'mapred job'
# is utilized. If it is set, HADOOP_CLASSPATH and
# HADOOP_USER_CLASSPATH_FIRST are ignored.
# export HADOOP_USE_CLIENT_CLASSLOADER=true

# HADOOP_CLIENT_CLASSLOADER_SYSTEM_CLASSES overrides the default definition of
# system classes for the client classloader when HADOOP_USE_CLIENT_CLASSLOADER
# is enabled. Names ending in '.' (period) are treated as package names, and
# names starting with a '-' are treated as negative matches. For example,
# export HADOOP_CLIENT_CLASSLOADER_SYSTEM_CLASSES="-org.apache.hadoop.UserClass,java.,javax.,org.apache.hadoop."

# Enable optional, bundled Hadoop features
# This is a comma delimited list.  It may NOT be overridden via .hadooprc
# Entries may be added/removed as needed.
# export HADOOP_OPTIONAL_TOOLS="hadoop-aliyun,hadoop-openstack,hadoop-azure,hadoop-azure-datalake,hadoop-aws,hadoop-kafka"

###
# Options for remote shell connectivity
###

# There are some optional components of hadoop that allow for
# command and control of remote hosts.  For example,
# start-dfs.sh will attempt to bring up all NNs, DNS, etc.

# Options to pass to SSH when one of the "log into a host and
# start/stop daemons" scripts is executed
# export HADOOP_SSH_OPTS="-o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=10s"

# The built-in ssh handler will limit itself to 10 simultaneous connections.
# For pdsh users, this sets the fanout size ( -f )
# Change this to increase/decrease as necessary.
# export HADOOP_SSH_PARALLEL=10

# Filename which contains all of the hosts for any remote execution
# helper scripts # such as workers.sh, start-dfs.sh, etc.
# export HADOOP_WORKERS="${HADOOP_CONF_DIR}/workers"

###
# Options for all daemons
###
#

#
# Many options may also be specified as Java properties.  It is
# very common, and in many cases, desirable, to hard-set these
# in daemon _OPTS variables.  Where applicable, the appropriate
# Java property is also identified.  Note that many are re-used
# or set differently in certain contexts (e.g., secure vs
# non-secure)
#

# Where (primarily) daemon log files are stored.
# ${HADOOP_HOME}/logs by default.
# Java property: hadoop.log.dir
# export HADOOP_LOG_DIR=${HADOOP_HOME}/logs

# A string representing this instance of hadoop. $USER by default.
# This is used in writing log and pid files, so keep that in mind!
# Java property: hadoop.id.str
# export HADOOP_IDENT_STRING=$USER

# How many seconds to pause after stopping a daemon
# export HADOOP_STOP_TIMEOUT=5

# Where pid files are stored.  /tmp by default.
# export HADOOP_PID_DIR=/tmp

# Default log4j setting for interactive commands
# Java property: hadoop.root.logger
# export HADOOP_ROOT_LOGGER=INFO,console

# Default log4j setting for daemons spawned explicitly by
# --daemon option of hadoop, hdfs, mapred and yarn command.
# Java property: hadoop.root.logger
# export HADOOP_DAEMON_ROOT_LOGGER=INFO,RFA

# Default log level and output location for security-related messages.
# You will almost certainly want to change this on a per-daemon basis via
# the Java property (i.e., -Dhadoop.security.logger=foo). (Note that the
# defaults for the NN and 2NN override this by default.)
# Java property: hadoop.security.logger
# export HADOOP_SECURITY_LOGGER=INFO,NullAppender

# Default process priority level
# Note that sub-processes will also run at this level!
# export HADOOP_NICENESS=0

# Default name for the service level authorization file
# Java property: hadoop.policy.file
# export HADOOP_POLICYFILE="hadoop-policy.xml"

#
# NOTE: this is not used by default!  <-----
# You can define variables right here and then re-use them later on.
# For example, it is common to use the same garbage collection settings
# for all the daemons.  So one could define:
#
# export HADOOP_GC_SETTINGS="-verbose:gc -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -XX:+PrintGCDateStamps"
#
# .. and then use it as per the b option under the namenode.

###
# Secure/privileged execution
###

#
# Out of the box, Hadoop uses jsvc from Apache Commons to launch daemons
# on privileged ports.  This functionality can be replaced by providing
# custom functions.  See hadoop-functions.sh for more information.
#

# The jsvc implementation to use. Jsvc is required to run secure datanodes
# that bind to privileged ports to provide authentication of data transfer
# protocol.  Jsvc is not required if SASL is configured for authentication of
# data transfer protocol using non-privileged ports.
# export JSVC_HOME=/usr/bin

#
# This directory contains pids for secure and privileged processes.
#export HADOOP_SECURE_PID_DIR=${HADOOP_PID_DIR}

#
# This directory contains the logs for secure and privileged processes.
# Java property: hadoop.log.dir
# export HADOOP_SECURE_LOG=${HADOOP_LOG_DIR}

#
# When running a secure daemon, the default value of HADOOP_IDENT_STRING
# ends up being a bit bogus.  Therefore, by default, the code will
# replace HADOOP_IDENT_STRING with HADOOP_xx_SECURE_USER.  If one wants
# to keep HADOOP_IDENT_STRING untouched, then uncomment this line.
# export HADOOP_SECURE_IDENT_PRESERVE="true"

###
# NameNode specific parameters
###

# Default log level and output location for file system related change
# messages. For non-namenode daemons, the Java property must be set in
# the appropriate _OPTS if one wants something other than INFO,NullAppender
# Java property: hdfs.audit.logger
# export HDFS_AUDIT_LOGGER=INFO,NullAppender

# Specify the JVM options to be used when starting the NameNode.
# These options will be appended to the options specified as HADOOP_OPTS
# and therefore may override any similar flags set in HADOOP_OPTS
#
# a) Set JMX options
# export HDFS_NAMENODE_OPTS="-Dcom.sun.management.jmxremote=true -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.port=1026"
#
# b) Set garbage collection logs
# export HDFS_NAMENODE_OPTS="${HADOOP_GC_SETTINGS} -Xloggc:${HADOOP_LOG_DIR}/gc-rm.log-$(date +'%Y%m%d%H%M')"
#
# c) ... or set them directly
# export HDFS_NAMENODE_OPTS="-verbose:gc -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -XX:+PrintGCDateStamps -Xloggc:${HADOOP_LOG_DIR}/gc-rm.log-$(date +'%Y%m%d%H%M')"

# this is the default:
# export HDFS_NAMENODE_OPTS="-Dhadoop.security.logger=INFO,RFAS"

###
# SecondaryNameNode specific parameters
###
# Specify the JVM options to be used when starting the SecondaryNameNode.
# These options will be appended to the options specified as HADOOP_OPTS
# and therefore may override any similar flags set in HADOOP_OPTS
#
# This is the default:
# export HDFS_SECONDARYNAMENODE_OPTS="-Dhadoop.security.logger=INFO,RFAS"

###
# DataNode specific parameters
###
# Specify the JVM options to be used when starting the DataNode.
# These options will be appended to the options specified as HADOOP_OPTS
# and therefore may override any similar flags set in HADOOP_OPTS
#
# This is the default:
# export HDFS_DATANODE_OPTS="-Dhadoop.security.logger=ERROR,RFAS"

# On secure datanodes, user to run the datanode as after dropping privileges.
# This **MUST** be uncommented to enable secure HDFS if using privileged ports
# to provide authentication of data transfer protocol.  This **MUST NOT** be
# defined if SASL is configured for authentication of data transfer protocol
# using non-privileged ports.
# This will replace the hadoop.id.str Java property in secure mode.
# export HDFS_DATANODE_SECURE_USER=hdfs

# Supplemental options for secure datanodes
# By default, Hadoop uses jsvc which needs to know to launch a
# server jvm.
# export HDFS_DATANODE_SECURE_EXTRA_OPTS="-jvm server"

###
# NFS3 Gateway specific parameters
###
# Specify the JVM options to be used when starting the NFS3 Gateway.
# These options will be appended to the options specified as HADOOP_OPTS
# and therefore may override any similar flags set in HADOOP_OPTS
#
# export HDFS_NFS3_OPTS=""

# Specify the JVM options to be used when starting the Hadoop portmapper.
# These options will be appended to the options specified as HADOOP_OPTS
# and therefore may override any similar flags set in HADOOP_OPTS
#
# export HDFS_PORTMAP_OPTS="-Xmx512m"

# Supplemental options for priviliged gateways
# By default, Hadoop uses jsvc which needs to know to launch a
# server jvm.
# export HDFS_NFS3_SECURE_EXTRA_OPTS="-jvm server"

# On privileged gateways, user to run the gateway as after dropping privileges
# This will replace the hadoop.id.str Java property in secure mode.
# export HDFS_NFS3_SECURE_USER=nfsserver

###
# ZKFailoverController specific parameters
###
# Specify the JVM options to be used when starting the ZKFailoverController.
# These options will be appended to the options specified as HADOOP_OPTS
# and therefore may override any similar flags set in HADOOP_OPTS
#
# export HDFS_ZKFC_OPTS=""

###
# QuorumJournalNode specific parameters
###
# Specify the JVM options to be used when starting the QuorumJournalNode.
# These options will be appended to the options specified as HADOOP_OPTS
# and therefore may override any similar flags set in HADOOP_OPTS
#
# export HDFS_JOURNALNODE_OPTS=""

###
# HDFS Balancer specific parameters
###
# Specify the JVM options to be used when starting the HDFS Balancer.
# These options will be appended to the options specified as HADOOP_OPTS
# and therefore may override any similar flags set in HADOOP_OPTS
#
# export HDFS_BALANCER_OPTS=""

###
# HDFS Mover specific parameters
###
# Specify the JVM options to be used when starting the HDFS Mover.
# These options will be appended to the options specified as HADOOP_OPTS
# and therefore may override any similar flags set in HADOOP_OPTS
#
# export HDFS_MOVER_OPTS=""

###
# Router-based HDFS Federation specific parameters
# Specify the JVM options to be used when starting the RBF Routers.
# These options will be appended to the options specified as HADOOP_OPTS
# and therefore may override any similar flags set in HADOOP_OPTS
#
# export HDFS_DFSROUTER_OPTS=""

###
# HDFS StorageContainerManager specific parameters
###
# Specify the JVM options to be used when starting the HDFS Storage Container Manager.
# These options will be appended to the options specified as HADOOP_OPTS
# and therefore may override any similar flags set in HADOOP_OPTS
#
# export HDFS_STORAGECONTAINERMANAGER_OPTS=""

###
# Advanced Users Only!
###

#
# When building Hadoop, one can add the class paths to the commands
# via this special env var:
# export HADOOP_ENABLE_BUILD_PATHS="true"

#
# To prevent accidents, shell commands be (superficially) locked
# to only allow certain users to execute certain subcommands.
# It uses the format of (command)_(subcommand)_USER.
#
# For example, to limit who can execute the namenode command,
# export HDFS_NAMENODE_USER=hdfs
export JAVA_HOME=/usr/local/jdk/jdk1.8.0_231
export HDFS_NAMENODE_USER=root
export HDFS_DATANODE_USER=root
export HDFS_SECONDARYNAMENODE_USER=root
export YARN_RESOURCEMANAGER_USER=root
export YARN_NODEMANAGER_USER=root
```

6. `workers`

```ini
h01
h02
h03
h04
h05
```

#### 1.1.3 hbase 配置文件

> **NOTE**: 考虑到使用 `docker` 配置 `hadoop` 集群，容器中数据存储的数据卷，需要与主机的目录相关联，以下涉及到存储目录的，统一使用前缀`/home/docker-data`，另外一些日志文件的文件路径也需要配置。

1. `hbase-site.xml`

```xml
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<!--
/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, 
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
-->
<configuration>
  <!--
    The following properties are set for running HBase as a single process on a
    developer workstation. With this configuration, HBase is running in
    "stand-alone" mode and without a distributed file system. In this mode, and
    without further configuration, HBase and ZooKeeper data are stored on the
    local filesystem, in a path under the value configured for `hbase.tmp.dir`.
    This value is overridden from its default value of `/tmp` because many
    systems clean `/tmp` on a regular basis. Instead, it points to a path within
    this HBase installation directory.

    Running against the `LocalFileSystem`, as opposed to a distributed
    filesystem, runs the risk of data integrity issues and data loss. Normally
    HBase will refuse to run in such an environment. Setting
    `hbase.unsafe.stream.capability.enforce` to `false` overrides this behavior,
    permitting operation. This configuration is for the developer workstation
    only and __should not be used in production!__

    See also https://hbase.apache.org/book.html#standalone_dist
  -->
   <property>
         <name>hbase.rootdir</name>
         <value>hdfs://h01:9000/hbase</value>
   </property>
   <property>
         <name>hbase.cluster.distributed</name>
         <value>true</value>
   </property>
   <property>
         <name>hbase.master</name>
         <value>h01:60000</value>
   </property>
   <property>
         <name>hbase.zookeeper.quorum</name>
         <value>h01,h02,h03,h04,h05</value>
   </property>
   <property>
         <name>hbase.zookeeper.property.dataDir</name>
         <value>/home/docker-data/hadoop/zoodata</value>
   </property>
</configuration>
```

2. `hbase-env.sh`

```shell
#!/usr/bin/env bash
#
#/**
# * Licensed to the Apache Software Foundation (ASF) under one
# * or more contributor license agreements.  See the NOTICE file
# * distributed with this work for additional information
# * regarding copyright ownership.  The ASF licenses this file
# * to you under the Apache License, Version 2.0 (the
# * "License"); you may not use this file except in compliance
# * with the License.  You may obtain a copy of the License at
# *
# *     http://www.apache.org/licenses/LICENSE-2.0
# *
# * Unless required by applicable law or agreed to in writing, software
# * distributed under the License is distributed on an "AS IS" BASIS,
# * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# * See the License for the specific language governing permissions and
# * limitations under the License.
# */

# Set environment variables here.

# This script sets variables multiple times over the course of starting an hbase process,
# so try to keep things idempotent unless you want to take an even deeper look
# into the startup scripts (bin/hbase, etc.)

# The java implementation to use.  Java 1.8+ required.
# export JAVA_HOME=/usr/java/jdk1.8.0/

# Extra Java CLASSPATH elements.  Optional.
# export HBASE_CLASSPATH=

# The maximum amount of heap to use. Default is left to JVM default.
# export HBASE_HEAPSIZE=1G

# Uncomment below if you intend to use off heap cache. For example, to allocate 8G of 
# offheap, set the value to "8G".
# export HBASE_OFFHEAPSIZE=1G

# Extra Java runtime options.
# Below are what we set by default.  May only work with SUN JVM.
# For more on why as well as other possible settings,
# see http://hbase.apache.org/book.html#performance
export HBASE_OPTS="$HBASE_OPTS -XX:+UseConcMarkSweepGC"

# Uncomment one of the below three options to enable java garbage collection logging for the server-side processes.

# This enables basic gc logging to the .out file.
# export SERVER_GC_OPTS="-verbose:gc -XX:+PrintGCDetails -XX:+PrintGCDateStamps"

# This enables basic gc logging to its own file.
# If FILE-PATH is not replaced, the log file(.gc) would still be generated in the HBASE_LOG_DIR .
# export SERVER_GC_OPTS="-verbose:gc -XX:+PrintGCDetails -XX:+PrintGCDateStamps -Xloggc:<FILE-PATH>"

# This enables basic GC logging to its own file with automatic log rolling. Only applies to jdk 1.6.0_34+ and 1.7.0_2+.
# If FILE-PATH is not replaced, the log file(.gc) would still be generated in the HBASE_LOG_DIR .
# export SERVER_GC_OPTS="-verbose:gc -XX:+PrintGCDetails -XX:+PrintGCDateStamps -Xloggc:<FILE-PATH> -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=1 -XX:GCLogFileSize=512M"

# Uncomment one of the below three options to enable java garbage collection logging for the client processes.

# This enables basic gc logging to the .out file.
# export CLIENT_GC_OPTS="-verbose:gc -XX:+PrintGCDetails -XX:+PrintGCDateStamps"

# This enables basic gc logging to its own file.
# If FILE-PATH is not replaced, the log file(.gc) would still be generated in the HBASE_LOG_DIR .
# export CLIENT_GC_OPTS="-verbose:gc -XX:+PrintGCDetails -XX:+PrintGCDateStamps -Xloggc:<FILE-PATH>"

# This enables basic GC logging to its own file with automatic log rolling. Only applies to jdk 1.6.0_34+ and 1.7.0_2+.
# If FILE-PATH is not replaced, the log file(.gc) would still be generated in the HBASE_LOG_DIR .
# export CLIENT_GC_OPTS="-verbose:gc -XX:+PrintGCDetails -XX:+PrintGCDateStamps -Xloggc:<FILE-PATH> -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=1 -XX:GCLogFileSize=512M"

# See the package documentation for org.apache.hadoop.hbase.io.hfile for other configurations
# needed setting up off-heap block caching. 

# Uncomment and adjust to enable JMX exporting
# See jmxremote.password and jmxremote.access in $JRE_HOME/lib/management to configure remote password access.
# More details at: http://java.sun.com/javase/6/docs/technotes/guides/management/agent.html
# NOTE: HBase provides an alternative JMX implementation to fix the random ports issue, please see JMX
# section in HBase Reference Guide for instructions.

# export HBASE_JMX_BASE="-Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false"
# export HBASE_MASTER_OPTS="$HBASE_MASTER_OPTS $HBASE_JMX_BASE -Dcom.sun.management.jmxremote.port=10101"
# export HBASE_REGIONSERVER_OPTS="$HBASE_REGIONSERVER_OPTS $HBASE_JMX_BASE -Dcom.sun.management.jmxremote.port=10102"
# export HBASE_THRIFT_OPTS="$HBASE_THRIFT_OPTS $HBASE_JMX_BASE -Dcom.sun.management.jmxremote.port=10103"
# export HBASE_ZOOKEEPER_OPTS="$HBASE_ZOOKEEPER_OPTS $HBASE_JMX_BASE -Dcom.sun.management.jmxremote.port=10104"
# export HBASE_REST_OPTS="$HBASE_REST_OPTS $HBASE_JMX_BASE -Dcom.sun.management.jmxremote.port=10105"

# File naming hosts on which HRegionServers will run.  $HBASE_HOME/conf/regionservers by default.
# export HBASE_REGIONSERVERS=${HBASE_HOME}/conf/regionservers

# Uncomment and adjust to keep all the Region Server pages mapped to be memory resident
#HBASE_REGIONSERVER_MLOCK=true
#HBASE_REGIONSERVER_UID="hbase"

# File naming hosts on which backup HMaster will run.  $HBASE_HOME/conf/backup-masters by default.
# export HBASE_BACKUP_MASTERS=${HBASE_HOME}/conf/backup-masters

# Extra ssh options.  Empty by default.
# export HBASE_SSH_OPTS="-o ConnectTimeout=1 -o SendEnv=HBASE_CONF_DIR"

# Where log files are stored.  $HBASE_HOME/logs by default.
# export HBASE_LOG_DIR=${HBASE_HOME}/logs

# Enable remote JDWP debugging of major HBase processes. Meant for Core Developers 
# export HBASE_MASTER_OPTS="$HBASE_MASTER_OPTS -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=8070"
# export HBASE_REGIONSERVER_OPTS="$HBASE_REGIONSERVER_OPTS -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=8071"
# export HBASE_THRIFT_OPTS="$HBASE_THRIFT_OPTS -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=8072"
# export HBASE_ZOOKEEPER_OPTS="$HBASE_ZOOKEEPER_OPTS -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=8073"
# export HBASE_REST_OPTS="$HBASE_REST_OPTS -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=8074"

# A string representing this instance of hbase. $USER by default.
# export HBASE_IDENT_STRING=$USER

# The scheduling priority for daemon processes.  See 'man nice'.
# export HBASE_NICENESS=10

# The directory where pid files are stored. /tmp by default.
# export HBASE_PID_DIR=/var/hadoop/pids

# Seconds to sleep between slave commands.  Unset by default.  This
# can be useful in large clusters, where, e.g., slave rsyncs can
# otherwise arrive faster than the master can service them.
# export HBASE_SLAVE_SLEEP=0.1

# Tell HBase whether it should manage it's own instance of ZooKeeper or not.
# export HBASE_MANAGES_ZK=true

# The default log rolling policy is RFA, where the log file is rolled as per the size defined for the 
# RFA appender. Please refer to the log4j.properties file to see more details on this appender.
# In case one needs to do log rolling on a date change, one should set the environment property
# RFA appender. Please refer to the log4j.properties file to see more details on this appender.
# In case one needs to do log rolling on a date change, one should set the environment property
# HBASE_ROOT_LOGGER to "<DESIRED_LOG LEVEL>,DRFA".
# For example:
# HBASE_ROOT_LOGGER=INFO,DRFA
# The reason for changing default to RFA is to avoid the boundary case of filling out disk space as 
# DRFA doesn't put any cap on the log size. Please refer to HBase-5655 for more context.

# Tell HBase whether it should include Hadoop's lib when start up,
# the default value is false,means that includes Hadoop's lib.
# export HBASE_DISABLE_HADOOP_CLASSPATH_LOOKUP="true"

#jdk
export JAVA_HOME=/usr/local/jdk/jdk1.8.0_231
export HBASE_MANAGES_ZK=true
```

3. `regionservers`

```ini
h01
h02
h03
h04
h05
```

#### 1.1.4 spark 配置文件

1. `spark-env.sh`

```shell
#!/usr/bin/env bash

#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# This file is sourced when running various Spark programs.
# Copy it as spark-env.sh and edit that to configure Spark for your site.

# Options read when launching programs locally with
# ./bin/run-example or ./bin/spark-submit
# - HADOOP_CONF_DIR, to point Spark towards Hadoop configuration files
# - SPARK_LOCAL_IP, to set the IP address Spark binds to on this node
# - SPARK_PUBLIC_DNS, to set the public dns name of the driver program

# Options read by executors and drivers running inside the cluster
# - SPARK_LOCAL_IP, to set the IP address Spark binds to on this node
# - SPARK_PUBLIC_DNS, to set the public DNS name of the driver program
# - SPARK_LOCAL_DIRS, storage directories to use on this node for shuffle and RDD data
# - MESOS_NATIVE_JAVA_LIBRARY, to point to your libmesos.so if you use Mesos

# Options read in YARN client/cluster mode
# - SPARK_CONF_DIR, Alternate conf dir. (Default: ${SPARK_HOME}/conf)
# - HADOOP_CONF_DIR, to point Spark towards Hadoop configuration files
# - YARN_CONF_DIR, to point Spark towards YARN configuration files when you use YARN
# - SPARK_EXECUTOR_CORES, Number of cores for the executors (Default: 1).
# - SPARK_EXECUTOR_MEMORY, Memory per Executor (e.g. 1000M, 2G) (Default: 1G)
# - SPARK_DRIVER_MEMORY, Memory for Driver (e.g. 1000M, 2G) (Default: 1G)

# Options for the daemons used in the standalone deploy mode
# - SPARK_MASTER_HOST, to bind the master to a different IP address or hostname
# - SPARK_MASTER_PORT / SPARK_MASTER_WEBUI_PORT, to use non-default ports for the master
# - SPARK_MASTER_OPTS, to set config properties only for the master (e.g. "-Dx=y")
# - SPARK_WORKER_CORES, to set the number of cores to use on this machine
# - SPARK_WORKER_MEMORY, to set how much total memory workers have to give executors (e.g. 1000m, 2g)
# - SPARK_WORKER_PORT / SPARK_WORKER_WEBUI_PORT, to use non-default ports for the worker
# - SPARK_WORKER_DIR, to set the working directory of worker processes
# - SPARK_WORKER_OPTS, to set config properties only for the worker (e.g. "-Dx=y")
# - SPARK_DAEMON_MEMORY, to allocate to the master, worker and history server themselves (default: 1g).
# - SPARK_HISTORY_OPTS, to set config properties only for the history server (e.g. "-Dx=y")
# - SPARK_SHUFFLE_OPTS, to set config properties only for the external shuffle service (e.g. "-Dx=y")
# - SPARK_DAEMON_JAVA_OPTS, to set config properties for all daemons (e.g. "-Dx=y")
# - SPARK_DAEMON_CLASSPATH, to set the classpath for all daemons
# - SPARK_PUBLIC_DNS, to set the public dns name of the master or workers

# Options for launcher
# - SPARK_LAUNCHER_OPTS, to set config properties and Java options for the launcher (e.g. "-Dx=y")

# Generic options for the daemons used in the standalone deploy mode
# - SPARK_CONF_DIR      Alternate conf dir. (Default: ${SPARK_HOME}/conf)
# - SPARK_LOG_DIR       Where log files are stored.  (Default: ${SPARK_HOME}/logs)
# - SPARK_PID_DIR       Where the pid file is stored. (Default: /tmp)
# - SPARK_IDENT_STRING  A string representing this instance of spark. (Default: $USER)
# - SPARK_NICENESS      The scheduling priority for daemons. (Default: 0)
# - SPARK_NO_DAEMONIZE  Run the proposed command in the foreground. It will not output a PID file.
# Options for native BLAS, like Intel MKL, OpenBLAS, and so on.
# You might get better performance to enable these options if using native BLAS (see SPARK-21305).
# - MKL_NUM_THREADS=1        Disable multi-threading of Intel MKL
# - OPENBLAS_NUM_THREADS=1   Disable multi-threading of OpenBLAS

export JAVA_HOME=/usr/local/jdk/jdk1.8.0_231
export HADOOP_HOME=/usr/local/hadoop
export HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop
export SCALA_HOME=/usr/local/scala/scala-2.11.8

export SPARK_MASTER_HOST=h01
export SPARK_MASTER_IP=h01
export SPARK_WORKER_MEMORY=4g
```

2. `slaves`

```ini
#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# A Spark Worker will be started on each of the machines listed below.
h01
h02
h03
h04
h05
```



### 1.2 编写 `Dockerfile` 文件

```dockerfile
FROM centos:7.7.1908 
RUN mkdir /home/ckx
WORKDIR /home/ckx
COPY . .
RUN mv /home/ckx/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo
RUN yum install net-tools openssh-server openssh-clients vim -y
#免密登录SSH
RUN mkdir /root/.ssh
RUN ssh-keygen -t rsa -P "" -f /root/.ssh/id_rsa
RUN cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys
RUN systemctl enable sshd
#安装java,scala,hadoop,hbase,spark相关环境
RUN mkdir /usr/local/jdk;mkdir /usr/local/scala/; 
RUN tar -zxvf jdk-8u231-linux-x64.tar.gz -C /usr/local/jdk; 
RUN tar -zxvf scala-2.11.8.tgz -C /usr/local/scala
RUN tar -zxvf hadoop-3.2.1.tar.gz; mv hadoop-3.2.1 /usr/local/hadoop
RUN tar -zxvf hbase-2.2.5-bin.tar.gz -C /usr/local
RUN tar -zxvf spark-3.0.0-preview2-bin-hadoop3.2.tgz; mv spark-3.0.0-preview2-bin-hadoop3.2 /usr/local/spark-3.0.0
#java
ENV JAVA_HOME  /usr/local/jdk/jdk1.8.0_231
ENV JRE_HOME ${JAVA_HOME}/jre
ENV CLASSPATH ${JAVA_HOME}/lib:${JRE_HOME}/lib  
ENV PATH ${JAVA_HOME}/bin:$PATH
#scala
ENV SCALA_HOME /usr/local/scala/scala-2.11.8
ENV PATH ${SCALA_HOME}/bin:$PATH
#hadoop
ENV HADOOP_HOME /usr/local/hadoop
ENV PATH $PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
ENV HADOOP_COMMON_HOME $HADOOP_HOME 
ENV HADOOP_HDFS_HOME $HADOOP_HOME 
ENV HADOOP_MAPRED_HOME $HADOOP_HOME
ENV HADOOP_YARN_HOME $HADOOP_HOME 
ENV HADOOP_INSTALL $HADOOP_HOME 
ENV HADOOP_COMMON_LIB_NATIVE_DIR $HADOOP_HOME/lib/native 
ENV HADOOP_CONF_DIR $HADOOP_HOME 
ENV HADOOP_LIBEXEC_DIR $HADOOP_HOME/libexec 
ENV JAVA_LIBRARY_PATH $HADOOP_HOME/lib/native:$JAVA_LIBRARY_PATH
ENV HADOOP_PREFIX $HADOOP_HOME
ENV HADOOP_CONF_DIR $HADOOP_PREFIX/etc/hadoop
ENV HDFS_DATANODE_USER root
ENV HDFS_DATANODE_SECURE_USER root
ENV HDFS_SECONDARYNAMENODE_USER root
ENV HDFS_NAMENODE_USER root
ENV YARN_RESOURCEMANAGER_USER root
ENV YARN_NODEMANAGER_USER root
#hbase
ENV HBASE_HOME /usr/local/hbase-2.2.5
ENV PATH $PATH:$HBASE_HOME/bin
#spark
ENV SPARK_HOME /usr/local/spark-3.0.0
ENV PATH $PATH:$SPARK_HOME/bin

#修改hadoop配置
RUN /bin/cp ./hadoop.etc/* $HADOOP_HOME/etc/hadoop

#修改hbase配置
RUN /bin/cp ./hbase.conf/* $HBASE_HOME/conf

#修改spark配置
RUN /bin/cp ./spark.conf/* $SPARK_HOME/conf

WORKDIR /root
```

### 1.3 制作 `image`

```sh
[root@localhost pack]# docker image build -t hadoop-cluster:latest .
```

## 2 docker 容器使用

### 2.1 各容器节点的启用

1. 后台启动docker

   ```
   docker run -d -it --privileged test:latest /usr/sbin/init
   ```

2. docker 启动 hadoop

   * 创建 `hadoop` 集群单独使用的桥接网络
   
   ```sh
   [root@localhost pack]# docker network create hadoop
   ```
   
   * 以后台服务形式启动 `hadoop` 主节点，并将 `/home/docker-data` 主机上的目录挂载到容器 `/home/docker-data/h01`
   
   ```sh
   [root@localhost pack]# docker run -d -it --privileged --network hadoop -v /home/docker-data/h01:/home/docker-data -h "h01" --name "h01" -p 10.10.1.228:9870:9870 -p 10.10.1.228:8088:8088 hadoop-cluster:latest /usr/sbin/init
   68bfa4a2e11f58e9f9da97345453b6f3005789aa368303f108bff5a823df6b76
[root@localhost pack]#
   ```
   
   * 以后台服务形式启动 `h02` `h03` `h04` `h05` 节点，分别将数据卷挂载到 `/home/docker-data/h0*`  目录上。
   
     > **NOTE**: 不能和 `h01` 共用一个数据卷，这样会导致各个节点之间的数据相互覆盖。
   
   ```sh
   [root@localhost pack]# docker run -d -it --privileged --network hadoop -h "h02" --name "h02" -v /home/docker-data/h02:/home/docker-data hadoop-cluster:latest /usr/sbin/init
   02266b08a2637aa3a303a0553f7b9bbd8dcb62204460b573cef91c13c8fe3edb
   [root@localhost pack]# docker run -d -it --privileged --network hadoop -h "h03" --name "h03" -v /home/docker-data/h03:/home/docker-data hadoop-cluster:latest /usr/sbin/init
   74456ab57d3bf3e1b1c31a3c0bdc35ba31725859d1fe23484c960b29e4b28845
   [root@localhost pack]# docker run -d -it --privileged --network hadoop -h "h04" --name "h04" -v /home/docker-data/h04:/home/docker-data hadoop-cluster:latest /usr/sbin/init
   107b650a3f6f2adb8cfd81f5f68cbf50abcf9cbb389482dc3466bf84a4c2ff85
   [root@localhost pack]# docker run -d -it --privileged --network hadoop -h "h05" --name "h05" -v /home/docker-data/h05:/home/docker-data hadoop-cluster:latest /usr/sbin/init
   9b8c3d856cc320402f8e3e358c57ee52909f58788aa0ae832bec7b8d59dcb30a
   [root@localhost pack]# 
   ```
   
   * 以客户端的形式连上 `h01` 节点
   
   ```sh
   [root@localhost pack]# docker exec -it h01 /bin/bash
   ```
   

### 2.2 docker 使用参考

1. [docker 卷的使用](https://www.cnblogs.com/51kata/p/5266626.html)
2. [Docker学习笔记（6）——Docker Volume](https://www.jianshu.com/p/ef0f24fd0674)

## 3 hadoop 基本使用

### 3.1 hadoop 集群的启动

1. 接下来，在 `h01` 主机中，启动 `hadoop` 集群

   * 先进行格式化操作

     ```sh
     root@h01:/usr/local/hadoop/bin# ./hadoop namenode -format
     ```

   * 进入 `hadoop` 的 `sbin` 目录，启动

     ```sh
     root@h01:/# cd /usr/local/hadoop/sbin/
     root@h01:/usr/local/hadoop/sbin#
     root@h01:/usr/local/hadoop/sbin# ./start-all.sh 
     ```

2. 可通过网页端口 `http://10.10.1.228:8088/cluster` 或者 `http://10.10.1.228:9870` 查看对应的 `hadoop` 和 `HDFS` 使用状态，或者使用命令 `./hadoop dfsadmin -report` 可查看分布式文件系统的状态

3. 运行内置 WordCount 的例子

   把 license 作为需要统计的文件

   ```sh
   root@h01:/usr/local/hadoop# cat LICENSE.txt > file1.txt
   root@h01:/usr/local/hadoop# ls
   ```

   在 HDFS 中创建 input 文件夹

   ```sh
   root@h01:/usr/local/hadoop/bin# ./hadoop fs -mkdir /input
   root@h01:/usr/local/hadoop/bin#
   ```

   上传 file1.txt 文件到 HDFS 中

   ```sh
   root@h01:/usr/local/hadoop/bin# ./hadoop fs -put ../file1.txt /input
   root@h01:/usr/local/hadoop/bin#
   ```

   查看 HDFS 中 input 文件夹里的内容

   ```sh
   root@h01:/usr/local/hadoop/bin# ./hadoop fs -ls /input
   Found 1 items
   -rw-r--r--   2 root supergroup     150569 2019-03-19 11:13 /input/file1.txt
   root@h01:/usr/local/hadoop/bin#
   ```

   运行 workcount 例子程序

   ```sh
   root@h01:/usr/local/hadoop/bin# ./hadoop jar ../share/hadoop/mapreduce/hadoop-mapreduce-examples-3.2.1.jar wordcount /input /output
   ```

   查看 HDFS 中的 /output 文件夹的内容

   ```sh
   root@h01:/usr/local/hadoop/bin# ./hadoop fs -ls /output
   Found 2 items
   -rw-r--r--   2 root supergroup          0 2019-03-19 11:18 /output/_SUCCESS
   -rw-r--r--   2 root supergroup      35324 2019-03-19 11:18 /output/part-r-00000
   ```

## 4 hbase 基本使用

### 4.1 启动 hbase

   ```sh
   [root@h01 bin]# pwd
   /usr/local/hbase-2.2.5/bin
   [root@h01 bin]# ./start-hbase.sh 
   ```

### 4.2 启动 hbase shell

   ```sh
   [root@h01 bin]# hbase shell
   WARNING: HADOOP_PREFIX has been replaced by HADOOP_HOME. Using value of HADOOP_PREFIX.
   SLF4J: Class path contains multiple SLF4J bindings.
   SLF4J: Found binding in [jar:file:/usr/local/hadoop/share/hadoop/common/lib/slf4j-log4j12-1.7.25.jar!/org/slf4j/impl/StaticLoggerBinder.class]
   SLF4J: Found binding in [jar:file:/usr/local/hbase-2.2.5/lib/client-facing-thirdparty/slf4j-log4j12-1.7.25.jar!/org/slf4j/impl/StaticLoggerBinder.class]
   SLF4J: See http://www.slf4j.org/codes.html#multiple_bindings for an explanation.
   SLF4J: Actual binding is of type [org.slf4j.impl.Log4jLoggerFactory]
   HBase Shell
   Use "help" to get list of supported commands.
   Use "exit" to quit this interactive shell.
   For Reference, please visit: http://hbase.apache.org/2.0/book.html#shell
   Version 2.2.5, rf76a601273e834267b55c0cda12474590283fd4c, 2020年 05月 21日 星期四 18:34:40 CST
   Took 0.0060 seconds                                                                                                                                                      
   hbase(main):001:0> 
   ```

## 5 spark 基本使用

### 5.1 启动 spark

   ```sh
   [root@h01 sbin]# pwd
   /usr/local/spark-3.0.0/sbin
   [root@h01 sbin]# ./start-all.sh 
   starting org.apache.spark.deploy.master.Master, logging to /usr/local/spark-3.0.0/logs/spark--org.apache.spark.deploy.master.Master-1-h01.out
   h03: starting org.apache.spark.deploy.worker.Worker, logging to /usr/local/spark-3.0.0/logs/spark-root-org.apache.spark.deploy.worker.Worker-1-h03.out
   h04: starting org.apache.spark.deploy.worker.Worker, logging to /usr/local/spark-3.0.0/logs/spark-root-org.apache.spark.deploy.worker.Worker-1-h04.out
   h05: starting org.apache.spark.deploy.worker.Worker, logging to /usr/local/spark-3.0.0/logs/spark-root-org.apache.spark.deploy.worker.Worker-1-h05.out
   h02: starting org.apache.spark.deploy.worker.Worker, logging to /usr/local/spark-3.0.0/logs/spark-root-org.apache.spark.deploy.worker.Worker-1-h02.out
   h01: starting org.apache.spark.deploy.worker.Worker, logging to /usr/local/spark-3.0.0/logs/spark-root-org.apache.spark.deploy.worker.Worker-1-h01.out
   ```