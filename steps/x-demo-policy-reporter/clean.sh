#!/bin/bash

echo "## Extinction des feux ##"
echo "-------------------------"
minikube stop -p policy-reporter
minikube delete -p policy-reporter
colima stop
helm repo remove kyverno
helm repo remove policy-reporter
echo "##    Vérifications    ##"
echo "-------------------------"
minikube profile list
colima status

