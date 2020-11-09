#!/bin/bash
#Apply on ControlPlane
echo "Adding registry mirror on ControlPlane"
systemctl stop docker
sed -i '2i \    "registry-mirrors\": [\"https://mirror.gcr.io\"],' /etc/docker/daemon.json
systemctl start docker

#Apply on node01
echo "Adding registry mirror on Node01"
ssh -o strictHostKeyChecking=no node01 << EOF
systemctl stop docker ; 
sed -i '2i \    "registry-mirrors\": [\"https://mirror.gcr.io\"],' /etc/docker/daemon.json ; 
systemctl start docker
EOF
