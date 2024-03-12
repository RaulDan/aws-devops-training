#!/bin/bash


sudo yum clean all
sudo yum update -y

sudo yum install -y java-11-amazon-corretto-devel

cd /opt
sudo mkdir online-shop-jar
cd ./online-shop-jar
sudo wget https://github.com/msg-CareerPaths/aws-devops-demo-app/releases/download/v0.0.1/online-shop-v0.0.1.jar
sudo groupadd -r jarGroup
sudo useradd -r -s /bin/false -g jarGroup jarUser
sudo chown -R jarUser:jarGroup /opt/online-shop-jar/
sudo cat <<'EOF' | sudo tee /etc/systemd/system/onlineShopJar.service
[Unit]
Description=Manage Java service

[Service]
WorkingDirectory=/opt/online-shop-jar
ExecStart=/bin/java -Xms128m -Xmx256m -jar online-shop-v0.0.1.jar
User=jarUser
Type=simple
Restart=on-failure
RestartSec=10

Environment="SPRING_DATASOURCE_USERNAME=postgres"
Environment="SPRING_DATASOURCE_PASSWORD=postgres"
Environment="SPRING_DATASOURCE_URL=jdbc:postgresql://online-shop-db.cp6imcium9lk.us-east-1.rds.amazonaws.com:5432/postgres"
Environment="SPRING_SESSION_STORETYPE=redis"
Environment="SPRING_REDIS_HOST=online-shop-cluster-001.zmuuxe.0001.use1.cache.amazonaws.com"
Environment="SPRING_REDIS_PORT=6379"
Environment="SPRING_SESSION_REDIS_CONFIGUREACTION=none"

[Install]
WantedBy=multi-user.target
EOF



sudo systemctl daemon-reload
sudo systemctl enable onlineShopJar
sudo systemctl start onlineShopJar.service