#!/bin/bash
#Apply on ControlPlane
echo "Adding registry mirror on ControlPlane"
systemctl stop docker
sed -i '2i \    "registry-mirrors\": [\"https://mirror.gcr.io\"],' /etc/docker/daemon.json
systemctl start docker

#Apply on nodes
for j in `kubectl get nodes --no-headers| awk '{print $1}' | grep ^node`
echo "Adding registry mirror on $j"
do
ssh -o strictHostKeyChecking=no $j << EOF
systemctl stop docker ; 
sed -i '2i \    "registry-mirrors\": [\"https://mirror.gcr.io\"],' /etc/docker/daemon.json ; 
systemctl start docker
EOF
done
