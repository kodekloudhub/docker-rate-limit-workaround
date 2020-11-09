#!/bin/bash
#Apply on ControlPlane
echo "Adding registry mirror on ControlPlane"
systemctl stop docker
sed -i '2i \    "registry-mirrors\": [\"https://mirror.gcr.io\"],' /etc/docker/daemon.json
systemctl start docker

echo "Wait for Docker Service to be Ready"
until kubectl get nodes 2>/dev/null | grep -w Ready 2> /dev/null; do  echo -n  .;sleep 1s; done
#Apply on nodes
for j in `kubectl get nodes --no-headers| awk '{print $1}' | grep ^node`
do
echo "Adding registry mirror on $j"
ssh -o strictHostKeyChecking=no $j << EOF
systemctl stop docker ; 
sed -i '2i \    "registry-mirrors\": [\"https://mirror.gcr.io\"],' /etc/docker/daemon.json ; 
systemctl start docker
EOF
done
