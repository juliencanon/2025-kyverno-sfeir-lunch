
<!-- .slide: class="flex-row center" data-background="./assets/lunch/bkgnd-lunch.png"-->
### Niveau 300 : Une demande du CISO vient de tomber...
![h600](./assets/lunch/100-chateau-600.png)

Il faut sécuriser les containers dans le cluster !

##==##
<!-- .slide: class="flex-row center" data-background="./assets/lunch/bkgnd-lunch.png"-->
### Pod Security Standards

- interdiction des capabilities
- interdiction des escalations de privilege
- interdiction de tourner sous l'indentité root
- séparer les namespaces de la machine hôte (PID, IPC, Network, HostAlias,...)

[https://kubernetes.io/docs/concepts/security/pod-security-standards/](https://kubernetes.io/docs/concepts/security/pod-security-standards/)

##==##
<!-- .slide: class="flex-row center" data-background="./assets/lunch/bkgnd-lunch.png"-->
### Pod Security Standards
![h500](./assets/lunch/pss-700.png)


##==##
<!-- .slide: class="flex-row center" data-background="./assets/lunch/bkgnd-lunch.png"-->
### Le repo helm kyverno offre un charts nommé kyverno-policies

Choix du profil : 
![h500](./assets/lunch/policies-baseline.jpg)

Mode : Audit ou Enforce
![h500](./assets/lunch/policies-enforce.jpg)

##==##
<!-- .slide: class="flex-row center" data-background="./assets/lunch/bkgnd-lunch.png"-->
### Utilisons le helm chart kyverno-policies
![h-800](./assets/techready/demo-time-girl.png)

