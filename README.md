# docker-rate-limit-workaround

A real quick workaround to get around the docker rate limits in our labs until we apply a permanent fix:

Run this on the control plane node.

```
bash <(curl -s https://raw.githubusercontent.com/kodekloudhub/docker-rate-limit-workaround/main/workaround.sh)
```
