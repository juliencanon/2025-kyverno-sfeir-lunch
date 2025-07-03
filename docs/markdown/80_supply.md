
<!-- .slide: class="flex-row center" data-background="./assets/lunch/bkgnd-lunch.png"-->
#### Respectons notre supply chain
![h-600](./assets/techready/origine-image.png)




##==##
<!-- .slide: class="with-code-dark max-height" data-background="./assets/lunch/bkgnd-lunch.png"-->
#### Supply: Vérification des signatures d'images avec Notary
```yaml [2,12-13,16-17,26]
apiVersion: policies.kyverno.io/v1alpha1
kind: ImageValidatingPolicy
metadata:
  name: check-images
spec:
  matchConstraints:
    resourceRules:
      - apiGroups: [""]
        apiVersions: ["v1"]
        operations: ["CREATE"]
        resources: ["pods"]
  variables:
    - name: cm
      expression: >-
        resource.Get("v1", "configmaps", object.metadata.namespace, "keys")
  matchImageReferences:
    - glob: ghcr.io/*                         
  attestors:
        - name: notary
          notary:
            certs:
              value: |
                -----BEGIN CERTIFICATE-----
                MIIBjTCCATOgAwIBAgIUdMiN3gC...
                -----END CERTIFICATE-----
              expression: variables.cm.data.cert
```


##==##
<!-- .slide: class="with-code-dark max-height" data-background="./assets/lunch/bkgnd-lunch.png"-->
#### Supply: vérification des attestations de conformité SBOM

```yaml [2,4,12-15,22-23,26]
apiVersion: policies.kyverno.io/v1alpha1
kind: ImageValidatingPolicy
metadata:
  name: check-images
spec:
  matchConstraints:
    resourceRules:
      - apiGroups: [""]
        apiVersions: ["v1"]
        operations: ["CREATE"]
        resources: ["pods"]
  matchImageReferences:
    - glob: ghcr.io/*
      attestors:
        - name: notary
          notary:
            certs:
              value: |-
                  -----BEGIN CERTIFICATE-----
                  ...
                  -----END CERTIFICATE-----
      attestations:
        - name: sbom
          referrer:
            type: sbom/cyclone-dx
  validations:
    - expression: >-
        images.containers.map(image, verifyImageSignatures(image, [attestors.notary])).all(e, e > 0)
      message: failed to verify image with notary cert
    - expression: >-
        images.containers.map(image, verifyAttestationSignatures(image, 
           attestations.sbom, [attestors.notary])).all(e, e > 0)
      message: failed to verify attestation with notary cert
    - expression: >-
        images.containers.map(image, extractPayload(image, attestations.sbom).bomFormat == 'CycloneDX').all(e, e)
      message: sbom is not a cyclone dx sbom
```

