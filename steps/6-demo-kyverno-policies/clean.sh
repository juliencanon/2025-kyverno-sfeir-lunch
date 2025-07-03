#!/bin/bash

. demo-magic.sh
TYPE_SPEED=30
clear

pe 'helm uninstall kyverno-policies -n kyverno'
pe 'kubectl get clusterpolicy'

exit

