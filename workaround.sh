#!/bin/bash
echo
#Apply on nodes
echo "Adding registry mirror on node01"
ssh -q -o strictHostKeyChecking=no node01 << EOF
systemctl stop docker ; 
sed -i '2i \    "registry-mirrors\": [\"https://mirror.gcr.io\"],' /etc/docker/daemon.json ; 
systemctl start docker
EOF


#Apply on ControlPlane
if [ /etc/docker/daemon.json ]
then
echo "Adding registry mirror on ControlPlane"
systemctl stop docker
sed -i '2i \    "registry-mirrors\": [\"https://mirror.gcr.io\"],' /etc/docker/daemon.json
systemctl start docker
sleep 5
echo "Wait for Docker Service to be Ready"
until kubectl get pods -n kube-system 2>/dev/null | egrep 'master|controlplane|weave|flannel' | grep  '0/' | wc -l | grep -qw 0 2> /dev/null; do  echo -n  .;sleep 1s; done
fi
