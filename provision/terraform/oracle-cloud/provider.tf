provider "oci" {
  tenancy_ocid     = data.sops_file.oracle_cloud_secrets.data["tenancy_ocid"]
  user_ocid        = data.sops_file.oracle_cloud_secrets.data["user_ocid"]
  private_key_path = data.sops_file.oracle_cloud_secrets.data["private_key_path"]
  fingerprint      = data.sops_file.oracle_cloud_secrets.data["fingerprint"]
  region           = data.sops_file.oracle_cloud_secrets.data["region"]
}

provider "sops" { }
