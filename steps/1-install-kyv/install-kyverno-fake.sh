#!/bin/bash

. demo-magic.sh
TYPE_SPEED=30
clear

p 'helm repo add kyverno https://kyverno.github.io/kyverno/'
cat <<EOF
"kyverno" has been added to your repositories
EOF

p 'helm repo update'
cat <<EOF
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "kyverno" chart repository
Update Complete. ⎈Happy Helming!⎈
EOF

p 'helm install kyverno kyverno/kyverno -n kyverno --create-namespace'
cat <<EOF
CUR_DATE=`date`
NAME: kyverno
LAST DEPLOYED: ${CUR_DATE}
NAMESPACE: kyverno
STATUS: deployed
REVISION: 1
NOTES:
Chart version: 3.4.1
Kyverno version: v1.14.1

Thank you for installing kyverno! Your release is named kyverno.

The following components have been installed in your cluster:
- CRDs
- Admission controller
- Reports controller
- Cleanup controller
- Background controller


⚠️  WARNING: Setting the admission controller replica count below 2 means Kyverno is not running in high availability mode.


⚠️  WARNING: PolicyExceptions are disabled by default. To enable them, set '--enablePolicyException' to true.

💡 Note: There is a trade-off when deciding which approach to take regarding Namespace exclusions. Please see the documentation at https://kyverno.io/docs/installation/#security-vs-operability to understand the risks.
EOF

p 'kubectl get namespaces'
cat <<EOF
NAME              STATUS   AGE
default           Active   82s
kube-node-lease   Active   82s
kube-public       Active   82s
kube-system       Active   82s
kyverno           Active   4s
EOF

p 'kubectl get deployment -n kyverno'
cat <<EOF
NAME                            READY   UP-TO-DATE   AVAILABLE   AGE
kyverno-admission-controller    1/1     1            0           20s
kyverno-background-controller   1/1     1            0           20s
kyverno-cleanup-controller      1/1     1            0           20s
kyverno-reports-controller      1/1     1            0           20s
EOF

exit

