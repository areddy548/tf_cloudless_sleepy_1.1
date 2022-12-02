data "vsphere_datacenter" "datacenter" {
  name = var.vsphere_datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
  name          = var.vsphere_network
  datacenter_id = data.vsphere_datacenter.datacenter.id
}
resource "random_string" "random" {
  length  = 4
  lower   = true
  special = false
  upper   = false
  numeric = false
}
locals {
  status = vsphere_virtual_machine.vm.name+random_string.random.id
}
data "template_file" "init" {
  template = file(signal.sh)
  vars = {
    key_status = local.status
  }
}
resource "vsphere_virtual_machine" "vm" {
    timeouts{
        create ="10m"
    }
  name             = var.vsphere_virtual_machine
  resource_pool_id = "resgroup-15"
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus         = 2
  memory           = 4096
  guest_id         = "rhel8_64Guest"
  network_interface {
    network_id = data.vsphere_network.network.id
  }
  disk {
    label = "disk0"
    size  = 100
  }
  cpu_hot_add_enabled     = true
  efi_secure_boot_enabled = true
  enable_logging          = true
  firmware                = "efi"
  memory_hot_add_enabled  = true
  sata_controller_count   = 1
  sync_time_with_host     = true
  tools_upgrade_policy    = "upgradeAtPowerCycle"
  cdrom {
    client_device  = true
  }
  extra_config = {
    "guestinfo.metadata.encoding" = "gzip+base64"
    "guestinfo.userdata.encoding" = "gzip+base64"
    # "guestinfo.metadata"          = file(signal.sh)
    "guestinfo.userdata" = file(signal.sh)
  }
}
resource "null_resource" "retry_until_signal" {
  depends_on = [
    vsphere_virtual_machine.vm
  ]
      environment = {
      key_status = local.status
    }
  # vm_name-randomid
  provisioner "local-exec" {
    command = "sh retry_signal.sh"
  }
}
