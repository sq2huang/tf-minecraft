#!/bin/bash

sudo yum update
sudo yum install java -y
curl https://launcher.mojang.com/v1/objects/bb2b6b1aefcd70dfd1892149ac3a215f6c636b07/server.jar --output minecraft_server.1.15.2.jar
java -Xmx1024M -Xms1024M -jar minecraft_server.1.15.2.jar nogui
echo "eula=true" > eula.txt
sed -i 's/online-mode=true/online-mode=false/' server.properties
nohup java -Xmx1024M -Xms1024M -jar minecraft_server.1.15.2.jar nogui &
sleep 1
echo done