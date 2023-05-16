terraform {
  required_providers {
    sops = {
      source = "carlpett/sops"
      version = "0.7.2"
    }
    oci = {
      source = "oracle/oci"
      version = "4.120.0"
    }
  }
}

data "sops_file" "oracle_cloud_secrets" {
  source_file = "secrets.sops.yaml"
}

module "k3s_cluster" {
  region              = data.sops_file.oracle_cloud_secrets.data["region"]
  availability_domain = data.sops_file.oracle_cloud_secrets.data["availability_domain"]
  tenancy_ocid        = data.sops_file.oracle_cloud_secrets.data["tenancy_ocid"]
  compartment_ocid    = data.sops_file.oracle_cloud_secrets.data["compartment_ocid"]
  cluster_name        = data.sops_file.oracle_cloud_secrets.data["cluster_name"]
  my_public_ip_cidr   = data.sops_file.oracle_cloud_secrets.data["my_public_ip_cidr"]
  environment         = "staging-phx"
  os_image_id         = data.sops_file.oracle_cloud_secrets.data["os_image_id"]
  k3s_version         = "v1.26.3+k3s1"
  disable_ingress     = true
  install_longhorn    = false
  install_certmanager = false
  install_argocd      = false
  install_argocd_image_updater = false
  expose_kubeapi      = true
  public_key_path     = "/home/neil/.ssh/id_rsa.pub"
  source              = "./k3s-oci-cluster"
}

output "k3s_servers_ips" {
  value = module.k3s_cluster.k3s_servers_ips
}

output "k3s_workers_ips" {
  value = module.k3s_cluster.k3s_workers_ips
}

output "public_lb_ip" {
  value = module.k3s_cluster.public_lb_ip
}
