terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
      version = "> 2.0.0"
    }
  }
}

variable "vsphere_user" {} 
variable "vsphere_password" {} 
variable "vsphere_server" {} 
provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "vmw-datacenter" {
  name = "vxrail-datacenter"
}

data "vsphere_datastore" "vmw-datastore" {
  name          = "vxrail-vsan-ds"
  datacenter_id = data.vsphere_datacenter.vmw-datacenter.id
}

data "vsphere_resource_pool" "pool" {
  name          = "main-rp"
  datacenter_id = data.vsphere_datacenter.vmw-datacenter.id
}

data "vsphere_network" "network" {
  name          = "workload-net"
  datacenter_id = data.vsphere_datacenter.vmw-datacenter.id
}

data "vsphere_virtual_machine" "template" {
  name          = "ubuntu-2004-template"
  datacenter_id = data.vsphere_datacenter.vmw-datacenter.id
}

resource "vsphere_virtual_machine" "vm" {
  count = 1
  name             = "vmw-lahci-vm-${count.index}"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.vmw-datastore.id

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

resource "vsphere_virtual_machine" "vm-2" {
  name             = "vmw-lahci-redis"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.vmw-datastore.id

  num_cpus = 2
  memory   = 1024
  guest_id = "other3xLinux64Guest"

  network_interface {
    network_id   = "${data.vsphere_network.network.id}"
    adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
  }


  disk {
    label = "disk0"
    size  = 20
  }
}

