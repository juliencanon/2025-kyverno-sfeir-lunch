#!/bin/bash

. demo-magic.sh
TYPE_SPEED=30
clear

pe 'helm install kyverno-policies kyverno/kyverno-policies --version 3.4.2-rc.1 -n kyverno'
pe 'kubectl get clusterpolicy'

exit

