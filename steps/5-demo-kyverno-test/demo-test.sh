#!/bin/bash

. demo-magic.sh
TYPE_SPEED=30
clear

pe 'yq . <test/kyverno-test.yaml'
pe 'kyverno test .'

exit

