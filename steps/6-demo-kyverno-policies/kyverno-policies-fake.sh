#!/bin/bash

. demo-magic.sh
TYPE_SPEED=30
clear

p 'helm install kyverno-policies kyverno/kyverno-policies --version 3.4.2-rc.1 -n kyverno'
cat <<EOF
CUR_DATE=`date`
NAME: kyverno-policies
LAST DEPLOYED: ${CUR_DATE}
NAMESPACE: kyverno
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
Thank you for installing kyverno-policies 3.4.2-rc.1 😀

We have installed the "baseline" profile of Pod Security Standards and set them in Audit mode.

Visit https://kyverno.io/policies/ to find more sample policies.
EOF

p 'kubectl get clusterpolicy'
cat <<EOF
NAME                             ADMISSION   BACKGROUND   READY   AGE   MESSAGE
disallow-capabilities            true        true                 19s
disallow-host-namespaces         true        true                 19s
disallow-host-path               true        true                 19s
disallow-host-ports              true        true                 19s
disallow-host-process            true        true                 19s
disallow-privileged-containers   true        true                 19s
disallow-proc-mount              true        true                 19s
disallow-selinux                 true        true                 19s
restrict-apparmor-profiles       true        true                 19s
restrict-seccomp                 true        true                 19s
restrict-sysctls                 true        true                 19s
EOF

exit

