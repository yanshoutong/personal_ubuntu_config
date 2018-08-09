#! /bin/sh

ZOOKEEPER_TGZ="http://mirrors.shu.edu.cn/apache/zookeeper/zookeeper-3.4.13/zookeeper-3.4.13.tar.gz"

export DEBIAN_FRONTEND=noninteractive

echo "Provisioning virtual machine..."

apt-get update
apt-get install -y vim
apt-get install -y openjdk-8-jdk
(cd /tmp/; wget -q ${ZOOKEEPER_TGZ}; tar xzvf zookeeper-3.4.13.tar.gz; mv zookeeper-3.4.13 /opt/; chown vagrant -R /opt/zookeeper-3.4.13)

echo "Setup zookeeper data directory..."
mkdir /tmp/zookeeper
echo `ifconfig eth1 | grep 'inet addr' | cut -d':' -f2 | cut -b 10` > /tmp/zookeeper/myid
chown vagrant -R /tmp/zookeeper

echo "Setup zookeeper configuration file..."
cp /opt/zookeeper-3.4.13/conf/zoo_sample.cfg  /opt/zookeeper-3.4.13/conf/zoo.cfg
echo "server.1=10.0.0.101:2888:3888" >> /opt/zookeeper-3.4.13/conf/zoo.cfg
echo "server.2=10.0.0.102:2888:3888" >> /opt/zookeeper-3.4.13/conf/zoo.cfg
echo "server.3=10.0.0.103:2888:3888" >> /opt/zookeeper-3.4.13/conf/zoo.cfg
chown vagrant /opt/zookeeper-3.4.13/conf/zoo.cfg

echo "Setup vagrant user environment variables..."
echo "export ZOOKEEPER_HOME='/opt/zookeeper-3.4.13'" >> /home/vagrant/.bashrc
echo "export PATH=$PATH:/opt/zookeeper-3.4.13/bin" >> /home/vagrant/.bashrc
