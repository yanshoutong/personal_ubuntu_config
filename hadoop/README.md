# Hadoop

本文主要是总结如何进行**Hadoop**集群的搭建，其中，我也参考了很多其他人的总结资料，在此表示感谢，并且为了保持本文的简短性，对所有参考过的资料不一一列出，望见谅！

本**Hadoop**集群是在`Linux Ubuntu 16.04 x64`上进行搭建的。

```sh
root@ecs-f233:~# cat /etc/issue
Ubuntu 16.04.3 LTS \n \l
root@ecs-f233:~# uname -a
Linux ecs-f233 4.4.0-104-generic #127-Ubuntu SMP Mon Dec 11 12:16:42 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
```



### JDK

安装JDK1.8,为了确保不会出现`JPS无法找到的问题`，我们安装Oracle JDK8

```sh
$ sudo add-apt-repository ppa:webupd8team/java -y
$ sudo apt-get update
$ sudo apt-get install oracle-java8-installer -y
```

安装好后，我们确认一下最后的结果

```sh
root@ecs-f233:~# java -version
java version "1.8.0_181"
Java(TM) SE Runtime Environment (build 1.8.0_181-b13)
Java HotSpot(TM) 64-Bit Server VM (build 25.181-b13, mixed mode)

```

设置**JAVA_HOME**环境变量

```sh
$ export JAVA_HOME='/usr/lib/jvm/java-8-oracle'
```

