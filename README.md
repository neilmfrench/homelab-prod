# k3s homelab cluster backed by Flux

Multi-cluster setup:

1. Bootstrap flux components on to cluster
   1. kubectl apply --kustomize kubernetes/bootstrap
2. Create flux age secret
3. Create flux settings/secret
4. Apply flux/config (Sets up homelab GitRepository)
5. Apply infrastructure for specific env
   1. clusters/production
   2. clusters/staging-phx
   3. clusters/staging-sj
6. Apply apps for specific env
   1. clusters/production
   2. clusters/staging-phx
   3. clusters/staging-sj
