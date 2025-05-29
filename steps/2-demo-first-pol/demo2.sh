#!/bin/bash

. demo-magic.sh
clear

TYPE_SPEED=30
DEMO_PROMPT="${GREEN}➜ ${CYAN}\W ${COLOR_RESET}"

pe 'kubectl get namespace'
pe 'kubectl create -f appli-ns.yaml'
pe 'kubectl get namespace'

pe 'yq . < appli-pod-latest.yaml'
pe 'kubectl create -f appli-pod-latest.yaml'
pe 'kubectl get pods -n appli'
pe 'kubectl get pods -n appli'

clean
echo "Nettoyage"
echo ""
pe 'kubectl delete -f appli-pod-latest.yaml'
pe 'kubectl get pods -n appli'

clean
echo "Ajoutons une policy"
echo ""
pe 'yq . < kyv-pol-disable-latest.yaml'
pe 'kubectl create -f kyv-pol-disable-latest.yaml'
pe 'kubectl get clusterpolicy'

pe 'kubectl create -f appli-pod-latest.yaml'
pe 'kubectl get pods -n appli'

pe 'yq . < appli-pod-version.yaml'
pe 'kubectl create -f appli-pod-version.yaml'
pe 'kubectl get pods -n appli'
pe 'kubectl get pods -n appli'

echo '💡Bonus 😍'
pe 'yq . < appli-deployment-version.yaml'
pe 'kubectl create -f appli-deployment-version.yaml'
pe 'kubectl get clusterpolicy disallow-latest-tag -o yaml | yq .'

exit

