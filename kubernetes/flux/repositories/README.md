Unfortunately, flux doesn't let us use directories above the current work dir, so we can't pick and choose individual Chart repository configurations :(

https://stackoverflow.com/questions/67481924/referring-a-resource-yaml-from-another-directory-in-kustomization

Workaround:

---

apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:

- ../../base/helm
  patchesStrategicMerge:
- |-
  $patch: delete
  apiVersion: source.toolkit.fluxcd.io/v1
  kind: HelmRepository
  metadata:
  name: bitnami
  namespace: flux-system
