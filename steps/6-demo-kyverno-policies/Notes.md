
1. **Personnalisez l'activation des politiques** dans votre fichier `values.yaml` :
   ```yaml
   podSecurity:
     enabled: true
   bestPractices:
     enabled: true
   ```

2. **Ajustez le mode d'application** pour chaque groupe de politiques :
   ```yaml
   podSecurity:
     validationFailureAction: Enforce  # ou Audit
   ```

3. **Activez sélectivement les politiques individuelles** :
   ```yaml
   podSecurity:
     disallow-privileged-containers:
       enabled: true
     restrict-volume-types:
       enabled: false
   ```

