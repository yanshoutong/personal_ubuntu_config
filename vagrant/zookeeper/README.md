### Purpose
This Vagrantfile describes how to setup three zookeeper servers with specific IP addresses using [vagrant](https://www.vagrantup.com/) tool.

### Prerequisite softwares (ubuntu specific)
- [Vagrant](https://www.vagrantup.com/)
- [Virtual Box](https://www.virtualbox.org/)

### How to play

***1. change to this zookpeer directory***

> Vagrantfile and provision folder should be present now

```sh
$ pwd
	~/zookeeper
$ ls -F
	provision/
	README.md
	Vagrantfile
```

***2. issue the following command***

```sh
$ vagrant up
```

***3. after the `vagrant up` command finished, you will get three servers, hostnames are zk1, zk2 and zk3***

```sh
$ vagrant status
	Current machine states:

	zk1                       running (virtualbox)
	zk2                       running (virtualbox)
	zk3                       running (virtualbox)

	This environment represents multiple VMs. The VMs are all listed
	above with their current state. For more information about a specific
	VM, run `vagrant status NAME`.
```
and these servers' IP addresses are below

| server | IP addr |
|--------|---------|
|zk1|10.0.0.101| 
|zk2|10.0.0.102| 
|zk3|10.0.0.103| 

***4. ssh into each server and bring up zookeeper***

```sh
[~/zookeeper]$ vagrant ssh zk1
	Welcome to Ubuntu 16.04.4 LTS (GNU/Linux 4.4.0-116-generic x86_64)

	 * Documentation:  https://help.ubuntu.com
	 * Management:     https://landscape.canonical.com
	 * Support:        https://ubuntu.com/advantage

	26 packages can be updated.
	7 updates are security updates.


vagrant@zk1:~$ zkServer.sh start
	ZooKeeper JMX enabled by default
	Using config: /opt/zookeeper-3.4.13/bin/../conf/zoo.cfg
	Starting zookeeper ... STARTED
vagrant@zk1:~$ telnet 127.0.0.1 2181
	Trying 127.0.0.1...
	Connected to 127.0.0.1.
	Escape character is '^]'.
	stat
	This ZooKeeper instance is not currently serving requests
	Connection closed by foreign host.
vagrant@zk1:~$

```

***5. play with zookeeper client (java)***

`pom.xml`

```xml
	<dependency>
		<groupId>org.apache.zookeeper</groupId>
		<artifactId>zookeeper</artifactId>
		<version>3.4.13</version>
	</dependency>
```
`java`

```java
public class App implements Watcher
{
    private static CountDownLatch connectedSemaphore = new CountDownLatch(1);

    public static void main( String[] args )
    {
        System.out.println( "Hello World!" );

        try {
            ZooKeeper zooKeeper = new ZooKeeper("10.0.0.101:2181,10.0.0.102:2181,10.0.0.103:2181",
                    5000,
                    new App());
            System.out.println("zookeeper.state:" + zooKeeper.getState());

            try {
                connectedSemaphore.await();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }

            System.out.println("*** zookeeper session established.");

            zooKeeper.create("/zk-test-ephemeral-",
                    "".getBytes(),
                    ZooDefs.Ids.OPEN_ACL_UNSAFE,
                    CreateMode.EPHEMERAL,
                    new IStringCallback(),
                    "I am Context");


            zooKeeper.create("/zk-test-ephemeral-",
                    "111".getBytes(),
                    ZooDefs.Ids.OPEN_ACL_UNSAFE,
                    CreateMode.EPHEMERAL_SEQUENTIAL,
                    new IStringCallback(),
                    "I am Context");


            Thread.sleep(Integer.MAX_VALUE);

        } catch (IOException e) {
            e.printStackTrace();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

    }

    @Override
    public void process(WatchedEvent watchedEvent) {
        System.out.println("Received watched event:" + watchedEvent);

        if (Event.KeeperState.SyncConnected == watchedEvent.getState()) {
            connectedSemaphore.countDown();
        }
    }
}

class IStringCallback implements AsyncCallback.StringCallback {

    @Override
    public void processResult(int rc, String path, Object ctx, String name) {
        System.out.println("*** Create path result:[ " + rc + ", " + path + ", "
        + ", " + ctx + ", real path name:" + name);
    }
}

```
