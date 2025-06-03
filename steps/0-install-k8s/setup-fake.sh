#!/bin/bash

cat <<EOF
## Démarrage de colima ##
-------------------------
INFO[0000] starting colima
INFO[0000] runtime: docker
INFO[0001] starting ...                                  context=vm
INFO[0013] provisioning ...                              context=docker                    INFO[0014] starting ...                                  context=docker                    INFO[0014] done                                                                            ## Démarrage minikube  ##                                                                  -------------------------                                                                  😄  [enterprise] minikube v1.36.0 on Darwin 15.5 (arm64)                                   ✨  Automatically selected the docker driver. Other choices: qemu2, ssh                    📌  Using Docker Desktop driver with root privileges                                       👍  Starting "enterprise" primary control-plane node in "enterprise" cluster
🚜  Pulling base image v0.0.47 ...
🔥  Creating docker container (CPUs=2, Memory=1956MB) ...
🐳  Preparing Kubernetes v1.33.1 on Docker 28.1.1 ...
    ▪ Generating certificates and keys ...
    ▪ Booting up control plane ...
    ▪ Configuring RBAC rules ...
🔗  Configuring CNI (Container Networking Interface) ...
🔎  Verifying Kubernetes components...
    ▪ Using image gcr.io/k8s-minikube/storage-provisioner:v5
🌟  Enabled addons: storage-provisioner, default-storageclass

👍  Starting "enterprise-m02" worker node in "enterprise" cluster
🚜  Pulling base image v0.0.47 ...
🔥  Creating docker container (CPUs=2, Memory=1956MB) ...
🌐  Found network options:
    ▪ NO_PROXY=192.168.49.2
🐳  Preparing Kubernetes v1.33.1 on Docker 28.1.1 ...
    ▪ env NO_PROXY=192.168.49.2
🔎  Verifying Kubernetes components...
🏄  Done! kubectl is now configured to use "enterprise" cluster and "default" namespace by default
## Vérification nodes  ##
-------------------------
NAME             STATUS   ROLES           AGE   VERSION
enterprise       Ready    control-plane   34s   v1.33.1
enterprise-m02   Ready    <none>          21s   v1.33.1
## Vérification ns     ##
-------------------------
NAME              STATUS   AGE
default           Active   34s
kube-node-lease   Active   34s
kube-public       Active   34s
kube-system       Active   34s
EOF

