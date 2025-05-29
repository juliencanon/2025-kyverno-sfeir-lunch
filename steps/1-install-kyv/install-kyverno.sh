#!/bin/bash

. demo-magic.sh
clear

pe 'helm repo add kyverno https://kyverno.github.io/kyverno/'
pe 'helm repo update'
pe 'helm install kyverno kyverno/kyverno -n kyverno --create-namespace'

#helm install kyverno kyverno/kyverno -n kyverno --create-namespace \
#--set admissionController.replicas=3 \
#--set backgroundController.replicas=2 \
#--set cleanupController.replicas=2 \
#--set reportsController.replicas=2

pe 'kubectl get namespaces'
pe 'kubectl get deployment -n kyverno'
pe 'kubectl get pods -n kyverno'
pe 'kubectl get pods -n kyverno'

exit

