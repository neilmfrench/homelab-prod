terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
      version = "4.108.1"
    }
  }
}

variable "compartment_ocid" {
    type = string
}
variable "image_ocid" {
  type = string
}
variable "availability_domain" {
  type = string
}
variable "memory_in_gbs" {
  type = string
}
variable "ocpus" {
  type = string
}
variable "subnet_ocid" {
  type = string
}
variable "workstation_public_key" {
  type = string
}

resource "oci_core_instance" "k3s_server" {
    availability_domain = var.availability_domain
    compartment_id = var.compartment_ocid
    shape = "VM.Standard.A1.Flex"

    agent_config {
      is_management_disabled = "false"
      is_monitoring_disabled = "false"

      plugins_config {
        desired_state = "DISABLED"
        name          = "Vulnerability Scanning"
      }

      plugins_config {
        desired_state = "ENABLED"
        name          = "Compute Instance Monitoring"
      }

      plugins_config {
        desired_state = "DISABLED"
        name          = "Bastion"
      }
    }

    shape_config {
      memory_in_gbs = var.memory_in_gbs
      ocpus         = var.ocpus
    }
    source_details {
        source_id = var.image_ocid
        source_type = "image"
    }

    create_vnic_details {
      assign_public_ip = false
      subnet_id        = var.subnet_ocid
    }

    metadata = {
        ssh_authorized_keys = var.workstation_public_key
    }
}
