# k3s homelab cluster backed by Flux

Multi-cluster setup:

1. Bootstrap flux components on to cluster
   1. kubectl apply --kustomize kubernetes/bootstrap
2. Create flux settings/secret
3. Apply flux config (Sets up homelab GitRepository)
4. Apply infrastructure for specific env
   1. clusters/production
   2. clusters/staging-phx
   3. clusters/staging-sj
5. Apply apps for specific env
   1. clusters/production
   2. clusters/staging-phx
   3. clusters/staging-sj
