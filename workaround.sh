#!/bin/bash
#Apply on ControlPlane
echo "Adding registry mirror on ControlPlane"
systemctl stop docker
sed -i '2i \    "registry-mirrors\": [\"https://mirror.gcr.io\"],' /etc/docker/daemon.json
systemctl start docker

#Apply on nodees
echo "Adding registry mirror on Node01"
for j in `kubectl get nodes --no-headers| awk '{print $1}' | grep ^node`
do
ssh -o strictHostKeyChecking=no $j << EOF
systemctl stop docker ; 
sed -i '2i \    "registry-mirrors\": [\"https://mirror.gcr.io\"],' /etc/docker/daemon.json ; 
systemctl start docker
EOF
done
