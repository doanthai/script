# Install mysql https://www.devart.com/dbforge/mysql/install-mysql-on-debian/
sudo apt update
sudo apt upgrade
wget https://dev.mysql.com/get/mysql-apt-config_0.8.24-1_all.deb
sudo apt install ./mysql-apt-config_0.8.24-1_all.deb
sudo apt update
sudo apt-get install mariadb-server
# Install mongodb https://www.mongodb.com/docs/manual/tutorial/install-mongodb-on-ubuntu/
sudo apt-get install gnupg curl
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg \
   --dearmor
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org
sudo systemctl start mongod
sudo systemctl enable mongod
# Install Redis https://redis.io/docs/latest/operate/oss_and_stack/install/install-redis/install-redis-on-linux/
curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list

sudo apt-get update
sudo apt-get install -y redis
# Install kafka https://kafka.apache.org/quickstart
wget https://dlcdn.apache.org/kafka/3.7.0/kafka_2.13-3.7.0.tgz
tar -xzf kafka_2.13-3.7.0.tgz
sudo apt install openjdk-11-jre-headless
sudo apt install openjdk-11-jdk-headless
sudo echo "
[Unit]
Description=ZooKeeper
After=network.target

[Install]
WantedBy=multi-user.target

[Service]
Type=simple
User=pc
Group=pc
Restart=always
SyslogIdentifier=zookeeper
RestartSec=5s
WorkingDirectory=/opt/kafka_2.13-3.7.0
ExecStart=/opt/kafka_2.13-3.7.0/bin/zookeeper-server-start.sh /opt/kafka_2.13-3.7.0/config/zookeeper.properties
StandardOutput=/var/log/zookeeper.log
StandardError=/var/log/zookeeper-error.lo
" > /etc/systemd/system/zookeeper.service
sudo echo "
[Unit]
Description=Kafka Service
After=network.target
After=zookeeper

[Install]
WantedBy=multi-user.target

[Service]
Type=simple
User=pc
Group=pc
Restart=always
SyslogIdentifier=kafka
RestartSec=5s
WorkingDirectory=/opt/kafka_2.13-3.7.0
ExecStart=/opt/kafka_2.13-3.7.0/bin/kafka-server-start.sh /opt/kafka_2.13-3.7.0/config/server.properties
StandardOutput=/var/log/kafka.log
StandardError=/var/log/kafka-error.log
" > /etc/systemd/system/kafka.service
sudo systemctl enable zookeeper.service
sudo systemctl start zookeeper.service
sudo systemctl enable kafka.service
sudo systemctl start kafka.service

