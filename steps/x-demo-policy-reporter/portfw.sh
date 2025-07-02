#!/bin/bash

kubectl port-forward service/policy-reporter 8080:8080 -n policy-reporter

