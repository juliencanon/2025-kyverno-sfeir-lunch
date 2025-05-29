#!/bin/bash

. demo-magic.sh
clear

TYPE_SPEED=30
DEMO_PROMPT="${GREEN}➜ ${CYAN}\W ${COLOR_RESET}"


pe 'yq . < mut-ns-policy.yaml'
pe 'kubectl create -f mut-ns-policy.yaml'

pe 'yq . < mut-deploy-inject-policy.yaml'
pe 'kubectl create -f mut-deploy-inject-policy.yaml'

pe 'yq . < mut-pod-policy.yaml'
pe 'kubectl create -f mut-pod-policy.yaml'

pe 'kubectl get clusterpolicy'

pe 'yq . < mut-demo-ns.yaml'
pe 'kubectl create -f mut-demo-ns.yaml'
pe 'kubectl get namespace'
pe 'kubectl get namespace mut-demo -o yaml | yq .'

pe 'yq . < nginx-deployment-version.yaml'
pe 'kubectl create -f nginx-deployment-version.yaml'
pe 'kubectl get deploy -n mut-demo'
pe 'kubectl get deploy -n mut-demo -o yaml | yq .'

exit

