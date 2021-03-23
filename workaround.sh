#!/bin/bash
echo " "
#Download Flannel Image from tarball
curl -s https://storage.googleapis.com/pub-images/flannel.tar -o /tmp/flannel.tar > /dev/null
#Removed Cached Image if Any
docker image rm 4e9f801d2217 > /dev/null
#Load from Tarball
docker load < /tmp/flannel.tar > /dev/null
scp /tmp/flannel.tar node01:/tmp > /dev/null
ssh node01 "docker image rm 4e9f801d2217 > /dev/null; docker load < /tmp/flannel.tar > /dev/null"
#Apply on nodes
for j in $(kubectl get nodes --no-headers | awk '{print $1}' | grep ^node); do
    echo "Adding registry mirror on $j"
    ssh -q -o strictHostKeyChecking=no $j <<EOF
      if grep registry-mirrors /etc/docker/daemon.json | grep -q docker-registry-mirror.katacoda.com ; 
      then 
        sed -i 's@http://docker-registry-mirror.katacoda.com@https://mirror.gcr.io@g' /etc/docker/daemon.json;
      else
        sed -i '2i \    "registry-mirrors\": [\"https://mirror.gcr.io\"],' /etc/docker/daemon.json ; 
      fi
      systemctl restart docker
EOF
done

sleep 5
until kubectl get pods -n kube-system 2>/dev/null | egrep 'master|controlplane|weave|flannel' | grep '0/' | wc -l | grep -qw 0 2>/dev/null; do
    echo -n .
    sleep 1s
done
