<p align="center">
  <a><img src="https://avatars.githubusercontent.com/u/61287648" /></a>
  <div align="center">
    <a href="https://k3s.io/"><img alt="k3s" src="https://img.shields.io/badge/k3s-v1.28.3-orange?logo=kubernetes&logoColor=white&style=flat-square"></a>
    <a href="https://talos.dev"><img alt="talos" src="https://img.shields.io/badge/OS-Talos-success?logo=kubernetes&logoColor=white&style=flat-square"></a>
    <a href="https://github.com/neilmfrench/homelab-prod/commits/main"><img alt="GitHub Last Commit" src="https://img.shields.io/github/last-commit/neilmfrench/homelab-prod?logo=git&logoColor=white&color=purple&style=flat-square"></a>
  </div>
</p>

# HomeLab Kubernetes Cluster with Talos and k3s

Welcome to the IaC repository for my personal homelab Kubernetes clusters! I have 3 homelab clusters - 1 "on-prem" (sitting on a side table next to my desk) and 2 in Oracle cloud, taking advantage of their extremely generous free tier offerings. All cluster workloads are [managed as code](https://github.com/neilmfrench/homelab-prod/tree/main/kubernetes) using [Flux](https://github.com/fluxcd/flux2) and deployed using [Ansible + Terraform](https://github.com/neilmfrench/homelab-prod/tree/main/provision). 

## On-prem [Talos](https://github.com/siderolabs/talos) cluster:

#### Hardware
4 nodes (3 control plane, 1 worker):
- Dell OptiPlex 3080 Micro
  - CPU: i3 10100T (4C/8T, 3.80 GHz)
  - 32GB RAM
  - Disks
    - Intel Optane 118GB (OS)
    - Samsung 2TB Enterprise-grade SSD (Ceph cluster)

#### Infrastructure
- Networking: [Cilium](https://github.com/cilium/cilium)
- Storage: [Rook-ceph](https://github.com/rook/rook)

## Oracle Cloud Phoenix [k3s](https://k3s.io) cluster:
4 nodes (3 control plane, 1 worker):
- Ampere A1 VM
  - CPU: Single core 3.0Ghz ARM64
  - 6GB RAM
  - 50GB virtual disk 

#### Infrastructure
- Networking: [Calico](https://github.com/projectcalico/calico)
- Storage: [Longhorn](https://github.com/longhorn/longhorn)

## Oracle Cloud San Jose [Talos](https://github.com/siderolabs/talos) cluster
4 nodes (3 control plane, 1 worker):
- Ampere A1 VM
  - CPU: Single core 3.0Ghz ARM64
  - 6GB RAM
  - 50GB virtual disk 

#### Infrastructure
- Networking: [Cilium](https://github.com/cilium/cilium)
- Storage: [OpenEBS Jiva](https://github.com/openebs/jiva)

## Read More
Check out my [blog](https://blog.neilfren.ch/) for more in-depth arcticles on my Homelab, as well as DevSecOps in general!
