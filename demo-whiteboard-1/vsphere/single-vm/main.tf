terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
      version = "> 2.0"
    }
  }
}

variable "vsphere_host" {}
variable "vsphere_user" {}
variable "vsphere_password" {} 


provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_host

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "vmw-dc" {
  name = "vmw-vxrail-datacenter"
}

data "vsphere_datastore" "vmw-datastore" {
  name          = "vmw-vxrail-datastore"
  datacenter_id = data.vsphere_datacenter.vmw-dc.id
}

data "vsphere_resource_pool" "pool" {
  name          = "vmw-vxrail-cluster/Resources"
  datacenter_id = data.vsphere_datacenter.vmw-dc.id
}

data "vsphere_network" "network" {
  name          = "workload-net"
  datacenter_id = data.vsphere_datacenter.vmw-dc.id
}

resource "vsphere_virtual_machine" "vm" {
  name             = "vmw-lahci-vm"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.vmw-dc.id

  num_cpus = 2
  memory   = 1024
  guest_id = "other3xLinux64Guest"

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label = "disk0"
    size  = 20
  }
}