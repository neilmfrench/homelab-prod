<p align="center">
  <a><img src="https://avatars.githubusercontent.com/u/61287648" /></a>
  <div align="center">
    <a href="https://k3s.io/"><img alt="k3s" src="https://img.shields.io/badge/k3s-v1.28.3-orange?logo=kubernetes&logoColor=white&style=flat-square"></a>
    <a href="https://talos.dev"><img alt="talos" src="https://img.shields.io/badge/OS-Talos-success?logo=kubernetes&logoColor=white&style=flat-square"></a>
    <a href="https://github.com/neilmfrench/homelab-prod/commits/main"><img alt="GitHub Last Commit" src="https://img.shields.io/github/last-commit/neilmfrench/homelab-prod?logo=git&logoColor=white&color=purple&style=flat-square"></a>
  </div>
</p>

#  HomeLab Kubernetes Cluster with Talos and k3s

Welcome to the IaC repository for my personal homelab Kubernetes clusters! I have 3 homelab clusters - 1 "on-prem" (sitting on a side table next to my desk) and 2 in Oracle cloud, taking advantage of their extremely generous free tier offerings. All cluster workloads are [managed as code](https://github.com/neilmfrench/homelab-prod/tree/main/kubernetes) using [Flux](https://github.com/fluxcd/flux2) and deployed using [Ansible + Terraform](https://github.com/neilmfrench/homelab-prod/tree/main/provision). 

# 📁 Repository structure

The Git repository contains the following directories under `kubernetes` and are ordered below by how Flux will apply them.

```sh
📁 kubernetes             # k8s clusters defined as code
├─📁 bootstrap            # bootstrap config, loaded once for cluster creation
├─📁 flux                 # flux, gitops operator, loaded before everything
├─📁 clusters             # cluster config, loaded before 📁 infrastructure and 📁 apps
├─📁 infrastructure       # crucial apps, namespaced dir tree, loaded before 📁 apps
└─📁 apps                 # regular apps, namespaced dir tree, loaded last
```

# 💻 Clusters

| Cluster     | Nodes    | CPU | RAM | Disks | OS | Networking | Storage | 
|----------|----------|-----|-----|-------|----|------------|---------|
| On-prem     | 4 (3 controlplane, 1 worker) | i3 10100T (4C/8T, 3.8 GHz) | 32GB | <ul><li>118Gb Intel Optane (OS)</li> <li>2TB Samsung Enterprise-grade SSD (Ceph cluster)</li></ul>| [Talos](https://github.com/siderolabs/talos) | [Cilium](https://github.com/cilium/cilium) | [Rook-ceph](https://github.com/rook/rook) |
| Oracle Cloud (Phoenix) | 4 (3 controlplane, 1 worker) | Single core 3.0Ghz ARM64 | 6GB | 50GB Virtual Disk | [k3s](https://k3s.io) | [Calico](https://github.com/projectcalico/calico) | [Longhorn](https://github.com/longhorn/longhorn) |
| Oracle Cloud (San Jose) | 4 (3 controlplane, 1 worker) | Single core 3.0Ghz ARM64 | 6GB | 50GB Virtual Disk | [Talos](https://github.com/siderolabs/talos) | [Cilium](https://github.com/cilium/cilium) | [OpenEBS Jiva](https://github.com/openebs/jiva) |

## :wrench:&nbsp; Tools

| Tool                                                               | Purpose                                                             |
|--------------------------------------------------------------------|---------------------------------------------------------------------|
| [go-task](https://github.com/go-task/task)                         | A task runner / simpler Make alternative written in Go              |
| [sops](https://github.com/mozilla/sops)                            | Encrypts k8s secrets with GnuPG                                     |

## 📖 Read More
Check out my [blog](https://blog.neilfren.ch/) for more in-depth arcticles on my Homelab, as well as DevSecOps in general!

