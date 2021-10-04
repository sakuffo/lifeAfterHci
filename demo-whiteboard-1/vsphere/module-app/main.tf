# Configure the VMware vSphere Provider
provider "vsphere" {
  user           = "administrator@vsphere.local"
  password       = "Vx5eals!!"
  vsphere_server = "192.2.0.26"

  # if you have a self-signed cert
  allow_unverified_ssl = true
}

# Deploy 2 linux VMs
module "example-server-linuxvm" {
  source    = "Terraform-VMWare-Modules/vm/vsphere"
  version   = "1.0.1"
  vmtemp    = "ubuntu-2004-template"
  instances = 2
  vmname    = "vmware-server-linux"
  vmrp      = "vxrail-main-datacenter/Resources"
  network = {
    "workload-net" = ["10.13.113.2", "10.13.113.3"] # To use DHCP create Empty list ["",""]; You can also use a CIDR annotation;
  }
  vmgateway = "10.13.113.1"
  dc        = "vxrail-datacenter"
  datastore = "vxrail-vsan-ds"
}